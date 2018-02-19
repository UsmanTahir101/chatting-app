//
//  SocketClientVc.m
//  ScoketChatApplication
//
//  Created by Abdul Rehman on 5/22/16.
//  Copyright © 2016 Abdul Rehman. All rights reserved.
//

#import "SocketClientVc.h"
#import "VerifyVC.h"
#import "DBManager.h"

@interface SocketClientVc (){
    AsyncSocket *socket;
    NSTimer *timer;
    JSQMessageControllerTest *JSQMessage;
    
    dataSharingClass *shareObj;
    
    DBManager * objDB;
    NSArray * dataArray;
    
    NSArray * selfUserData;
    NSString *userID ;
    
    
}

@end

@implementation SocketClientVc
- (instancetype)init
{
    self = [super init];
    if (self) {
        
        
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
}

- (void)connectWithSocket
{
    shareObj = [[UIApplication sharedApplication] delegate];
    
    
    objDB=[[DBManager alloc]initWithDatabaseFilename:@"Clients"];
    NSString *q =@"select * from self";
    selfUserData=[objDB loadDataFromDB:q];
    NSLog(@"\n\nself user detail From DB  : %@\n\n",selfUserData);
    
    if(selfUserData.count > 0){
        shareObj.selfUserName = selfUserData[0][0];
        shareObj.selfUserPhoneNo = selfUserData[0][1];
        userID = [NSString stringWithFormat:@"ID|%@",shareObj.selfUserPhoneNo];
    }
    else{
        userID = @"ID|0123456789";
    }
    
    
    
    
    //shareObj.sendMSG = @"";
    
    
    shareObj.MSG = @"";
    shareObj.valid = @"";
    shareObj.InValid = @"";
    shareObj.registeredSuccesfuly = @"";
    shareObj.clientList = @"";
    shareObj.addNewUser = @"";
    shareObj.listOfOnlineClient = @"";
    shareObj.createGroup = @"";
    
    
    // creating socket with static ip of server
    // change the ip of server if needed
    
    socket=[[AsyncSocket alloc]initWithDelegate:self];
    [socket connectToHost:@"192.168.43.30" onPort:11010 error:nil];
    
    NSData* data = [userID dataUsingEncoding:NSUTF8StringEncoding];
    [socket writeData:data withTimeout:-1 tag:0];
    
}


-(void)stopScoket{
    [socket disconnect];
    [self stopTimer];
    
}

-(void)startTimer{
    // receiveind data in another thread
    
    timer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(timerCalled) userInfo:nil repeats:YES];
    
}
-(void)stopTimer{
    [timer  invalidate];
}
-(void)timerCalled
{
    if(socket.isConnected == false){
        socket=[[AsyncSocket alloc]initWithDelegate:self];
        [socket connectToHost:@"192.168.43.30" onPort:11010 error:nil];
        
        NSData* data = [userID dataUsingEncoding:NSUTF8StringEncoding];
        [socket writeData:data withTimeout:-1 tag:0];

    }
    // NSLog(@"Timer Called");
    [socket readDataWithTimeout:-1 tag:0];
    
    if([shareObj.sendMSG isEqualToString:@""] != true){
        [self writeData:shareObj.sendMSG];
        
    }
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// when recieve data

- (void)onSocket:(AsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag {
    
    
    NSString *output=[[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
    
     NSLog(@"Response : %@",output);
    
    NSArray *arr = [output componentsSeparatedByString:@"|"];
    
    // NSLog(@"Response at 0 index : %@",[arr objectAtIndex:0]);
    
    if([[arr objectAtIndex:0] isEqualToString:@"MSG"]){
        
        shareObj.MSG = output;
        [shareObj.MSGRecievedArray addObject:output];
        
        NSLog(@"\n\nMSG\n\n");
        
        NSLog(@"Message Array : %@",shareObj.MSGRecievedArray);
    }
    else  if([[arr objectAtIndex:0] isEqualToString:@"Valid"]){
        shareObj.valid = output;
        NSLog(@"\n\nValid \n\n");
        
        
    } else  if([[arr objectAtIndex:0] isEqualToString:@"InValid"]){
        shareObj.InValid = [arr objectAtIndex:0];
        NSLog(@"\n\n InValid\n\n");
        
        
    } else  if([[arr objectAtIndex:0] isEqualToString:@"RegisteredSuccesfuly"]){
        shareObj.registeredSuccesfuly = output;
        NSLog(@"\n\n RegisteredSuccesfuly\n\n");
        
        [self addSelfUserIntoDB:[arr objectAtIndex:1]];
        
        
    } else  if([[arr objectAtIndex:0] isEqualToString:@"Clientslist"]){
        
        shareObj.clientList = output;
        NSLog(@"\n\nClientList  :%@:\n\n",[arr objectAtIndex:1]);
        
         if([[arr objectAtIndex:1] isEqualToString:@""] ){
               shareObj.clientListAdded = @"true";
         }
        if(![[arr objectAtIndex:1] isEqualToString:@""] ){
            [self addAllUsersIntoDB:[arr objectAtIndex:1]];
        }
        
        
        
    } else  if([[arr objectAtIndex:0] isEqualToString:@"AddNewUser"]){
        shareObj.addNewUser = output;
        NSLog(@"\n\n AddNewUser\n\n");
        
        [self addNewUserIntoDB:[arr objectAtIndex:1]];
        
        
    } else  if([[arr objectAtIndex:0] isEqualToString:@"ListOfOnlineClient"]){
        shareObj.listOfOnlineClient = output;
        // NSLog(@"\n\n ListOfOnlineClient\n\n");
        
        
    } else  if([[arr objectAtIndex:0] isEqualToString:@"AllClientsAreOfline"]){
        NSLog(@"\n\nAllClientsAreOfline \n\n");
        
    }
    else  if([[arr objectAtIndex:0] isEqualToString:@"CreateGroup"]){
        shareObj.createGroup = output;
        [self addGroupIntoDB];
        NSLog(@"\n\n CreateGroup \n\n");
        
    }
    
    
    
    
    
    
    
}



-(void) readData {
    
    [socket readDataWithTimeout:-1 tag:0];
    
    
}


-(void)writeData : (NSString *)data{
    
    NSLog(@"\nSending Msg : %@",data);
    
    NSData* msgValue = [data dataUsingEncoding:NSUTF8StringEncoding];
    [socket writeData:msgValue withTimeout:-1 tag:-1 ];
    
    shareObj.sendMSG = @"";
    
    
}

-(void)addNewUserIntoDB: (NSString *)userStr{
    
    NSArray * userDetailArray = [userStr componentsSeparatedByString:@","];
    
    NSLog(@"userDetailArray :%@:",userDetailArray);
    NSString * query= [NSString stringWithFormat:@" INSERT INTO home (Name,PhoneNo,IsGroup) VALUES ('%@','%@','no')",userDetailArray[0],userDetailArray[1]];
    [objDB executeQuery:query];
    shareObj.needToReloadTableView = @"true";
}

-(void)addAllUsersIntoDB: (NSString *)usersStr{
    
    NSArray * usersDetailArray = [usersStr componentsSeparatedByString:@"/"];
    if(usersDetailArray.count > 0){
        for (int i=0; i<usersDetailArray.count; i++) {
            
            NSArray *user = [usersDetailArray[i] componentsSeparatedByString:@","];
            if(![shareObj.selfUserPhoneNo isEqualToString:user[1]]){
                NSString * query= [NSString stringWithFormat:@" INSERT INTO home (Name,PhoneNo,IsGroup) VALUES ('%@','%@','no')",user[0],user[1]];
                [objDB executeQuery:query];
            }
            
        }
    }
    shareObj.clientListAdded = @"true";
    
}
-(void)addSelfUserIntoDB: (NSString *)userStr{
    
    NSArray * userDetailArray = [userStr componentsSeparatedByString:@","];
    
    NSString * query= [NSString stringWithFormat:@" INSERT INTO self (Name,PhoneNo) VALUES ('%@','%@')",userDetailArray[0],userDetailArray[1]];
    [objDB executeQuery:query];
}
//CreateGroup|0347670226|03476760227,03365565947,0347670226|hello34|Warraich

-(void)addGroupIntoDB{
    
    
    NSArray *arr = [shareObj.createGroup componentsSeparatedByString:@"|"];
    
    if([[arr objectAtIndex:0] isEqualToString:@"CreateGroup"]){
        if(![[arr objectAtIndex:4] isEqualToString:shareObj.selfUserName]){
            
            NSString * query= [NSString stringWithFormat:@"INSERT INTO home (Name,PhoneNo,IsGroup) VALUES ('%@','%@','yes')",arr[3],arr[2]];
            [objDB executeQuery:query];
        }
    }
    shareObj.needToReloadTableView = @"true";
}
@end
