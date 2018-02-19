//
//  FriendsTableViewController.m
//  ScoketChatApplication
//
//  Created by Abdul Rehman on 5/22/16.
//  Copyright © 2016 Abdul Rehman. All rights reserved.
//

#import "FriendsTableViewController.h"
#import "DBManager.h"
#import "SocketClientVc.h"
#import "JSQMessageControllerTest.h"
#import "CreateViewController.h"


@interface FriendsTableViewController (){
    DBManager * objDB;
    
    SocketClientVc * socket;
    dataSharingClass *shareObj;
    
    NSTimer * classTimer;
    NSArray* dataArray ;
    
    NSString *senderId;
    NSString *receiverId;
    
    NSArray * dataFromDataBase;
    
    NSArray * selfUserData;
    
}
@property (weak, nonatomic) IBOutlet UITabBarItem *tabBar;
@end

@implementation FriendsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    shareObj = [[UIApplication sharedApplication] delegate];
    
    socket = [[SocketClientVc alloc]init];
    
    [socket connectWithSocket];
    [socket startTimer];
    
    
    [self startclassTimer];
    [self loadData];
    
    shareObj.chatArray = [[NSMutableArray alloc] initWithCapacity:5];
    shareObj.recieverIDArray = [[NSMutableArray alloc] initWithCapacity:5];
    shareObj.recieverNameArray = [[NSMutableArray alloc] initWithCapacity:5];
    shareObj.mainChatDictionary = [[NSMutableDictionary alloc] init];
    
    
   
    
    
    
}
-(void)loadData{
    
    /*objDB=[[DBManager alloc]initWithDatabaseFilename:@"Clients"];
    NSString *q =@"select * from self";
    selfUserData=[objDB loadDataFromDB:q];
    NSLog(@"\n\nself user detail From DB  : %@\n\n",selfUserData);
    
    if(selfUserData.count > 0){
        shareObj.selfUserName = selfUserData[0][0];
        shareObj.selfUserPhoneNo = selfUserData[0][1];
    }
    */
    objDB=[[DBManager alloc]initWithDatabaseFilename:@"Clients"];
    
    NSString * query=@"select * from home";
    dataFromDataBase=[objDB loadDataFromDB:query];
    NSLog(@"\n\nNames From DB  : %@\n\n",dataFromDataBase);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
   
    return dataFromDataBase.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    
    cell.textLabel.text = dataFromDataBase[indexPath.row][0];
    
        if ([dataFromDataBase[indexPath.row][2]  isEqual: @"yes"]) {
            UIImage* im = [UIImage imageNamed:@"2.png"];
            UIGraphicsBeginImageContextWithOptions(CGSizeMake(20,20), YES, 0);
            [im drawInRect:CGRectMake(0,0,20,20)];
            UIImage* im2 = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            cell.imageView.image = im2;
            cell.imageView.contentMode = UIViewContentModeCenter;
        }
        else{
            UIImage* im = [UIImage imageNamed:@"1.png"];
            UIGraphicsBeginImageContextWithOptions(CGSizeMake(20,20), YES, 0);
            [im drawInRect:CGRectMake(0,0,20,20)];
            UIImage* im2 = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            cell.imageView.image = im2;
            cell.imageView.contentMode = UIViewContentModeCenter;
        }
    
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    shareObj.receiverName = dataFromDataBase[indexPath.row][0];
    shareObj.receiverId = dataFromDataBase[indexPath.row][1];
    
    shareObj.senderName = shareObj.selfUserName;
    shareObj.senderId = shareObj.selfUserPhoneNo;
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    JSQMessageControllerTest *viewController = [storyboard instantiateViewControllerWithIdentifier:@"jsmessage"];
    
    viewController.hidesBottomBarWhenPushed = YES;
    
//    [self.navigationController presentViewController: viewController animated:YES completion:nil];

    [self.navigationController pushViewController:viewController animated:YES];
    
}

-(void)startclassTimer{
    // receiveind data in another thread
    
    classTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(classTimerCalled) userInfo:nil repeats:YES];
    
}
-(void)stopclassTimer{
    [classTimer invalidate];
}
-(void)classTimerCalled
{
    
    
    if (![shareObj.listOfOnlineClient  isEqual: @""]) {
        
        NSArray *arr = [shareObj.listOfOnlineClient componentsSeparatedByString:@"|"];
        
        //        NSLog(@"Response at 0 index : %@",[arr objectAtIndex:0]);
        
        if (arr.count > 1) {
            //            NSLog(@"Response at 1 index : %@",[arr objectAtIndex:1]);
            dataArray = [[arr objectAtIndex:1] componentsSeparatedByString:@","];
            
        }
        
        else{
            
            dataArray = [[NSArray alloc]init];
        }
        
        [self.tableView reloadData];
    }
    
    if ([shareObj.needToReloadTableView isEqualToString:@"true"]) {
        
        [self loadData];
        [self.tableView reloadData];
        shareObj.needToReloadTableView = @"";
    }
    
    
    
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if ([segue.identifier  isEqual: @"selectUser"]) {
        
        CreateViewController *viewController = segue.destinationViewController;
        viewController.hidesBottomBarWhenPushed = YES;
    }
    
}
- (IBAction)btn_Add:(id)sender {

    [self performSegueWithIdentifier:@"selectUser" sender:nil];
    
}



@end
