//
//  VerifyVC.m
//  ScoketChatApplication
//
//  Created by Abdul Rehman on 5/24/16.
//  Copyright © 2016 Abdul Rehman. All rights reserved.
//

#import "VerifyVC.h"
#import "dataSharingClass.h"
#import "SocketClientVc.h"
#import "DBManager.h"

@interface VerifyVC (){
    dataSharingClass *shareObj;
    SocketClientVc * socket;
    NSTimer * timer;
    DBManager *objDB;
    
    
}
@property (weak, nonatomic) IBOutlet UITextField *txt_vCode;

@end

@implementation VerifyVC
@synthesize vCode;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    shareObj = [[UIApplication sharedApplication] delegate];
    objDB=[[DBManager alloc]initWithDatabaseFilename:@"Clients"];
    //    NSLog(@"\nmsg : %@",shareObj.sendMSG );
    
    socket = [[SocketClientVc alloc]init];
    
    [socket connectWithSocket];
    [socket startTimer];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btn_verify:(id)sender {
    
    [self startTimer];
    
    
    
    
}


-(void)startTimer{
    // receiveind data in another thread
    
    timer = [NSTimer scheduledTimerWithTimeInterval:0.50 target:self selector:@selector(timerCalled) userInfo:nil repeats:YES];
    
}
-(void)stopTimer{
    [timer invalidate];
}
-(void)timerCalled
{
    if(![shareObj.valid isEqualToString:@""]){
        NSArray *vResult = [shareObj.valid componentsSeparatedByString:@"|"];
        
        if ([_txt_vCode.text  isEqual: [vResult objectAtIndex:1]] && [[vResult objectAtIndex:0] isEqual: @"Valid"]) {
            
            NSLog(@"User is Valid");
            
          
            NSString *strMessage = [NSString stringWithFormat:@"NewUser|%@",shareObj.phoneNumber];
            
            shareObj.sendMSG =  strMessage;
            
            shareObj.valid = @"";
            
           
        }
    }
    
    if([shareObj.clientListAdded isEqualToString:@"true"]){
        [socket stopScoket];
        [self stopTimer];
        [self performSegueWithIdentifier:@"numberVerified" sender:nil];
    }
    
    if([shareObj.InValid isEqualToString:@"InValid"]){
        
        UIAlertController * alert=   [UIAlertController
                                      alertControllerWithTitle:@"Alert"
                                      message:@"Try to Register Invalid User"
                                      preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* ok = [UIAlertAction
                             actionWithTitle:@"OK"
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action)
                             {
                                 [socket stopScoket];
                                 [self stopTimer];
                                 [self performSegueWithIdentifier:@"segueInValid" sender:nil];
                                 
                                 [alert dismissViewControllerAnimated:YES completion:nil];
                                 
                             } ];
        
        
        [alert addAction:ok];
        [self presentViewController:alert animated:YES completion:nil];
        
        
    }

    
}



@end
