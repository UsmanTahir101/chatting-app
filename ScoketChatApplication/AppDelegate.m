//
//  AppDelegate.m
//  ScoketChatApplication
//
//  Created by Abdul Rehman on 5/21/16.
//  Copyright © 2016 Abdul Rehman. All rights reserved.
//

#import "AppDelegate.h"
#import "DBManager.h"
#import "dataSharingClass.h"
#import "ViewController.h"
#import "FriendsTableViewController.h"

@interface AppDelegate (){
    DBManager * objDB;
    dataSharingClass *shareObj;
    
    NSString* MSG;
    NSString* valid;
    NSString* InValid;
    NSString *registeredSuccesfuly;
    NSString* clientList;
    NSString* addNewUser;
    NSString *listOfOnlineClient;
    
    NSString * sendMSG;
    
    //    NSString * tableViewDataSet;
    
    NSString * senderName;
    NSString * senderId;
    NSString *receiverName;
    NSString * receiverId;
    
    NSString *selfUserName;
    NSString *selfUserPhoneNo;
    
    NSString *createGroup;
    NSString *phoneNumber;
    
    NSArray * selfUserData;
    
    NSString *clientListAdded;
    
    NSString *needToReloadTableView;
    
    NSMutableArray *chatArray;
    NSMutableArray *recieverIDArray;
    NSMutableArray *recieverNameArray;
    NSMutableDictionary *mainChatDictionary;
    
    NSMutableArray *MSGRecievedArray;
    
    NSMutableArray * selectedIdArray;
    NSMutableArray * selectedNameArray;
    
}
@property (nonatomic, retain) NSMutableArray * selectedNameArray;
@property (nonatomic, retain) NSMutableArray * selectedIdArray;

@property (nonatomic, retain)    NSString * MSG;
@property (nonatomic, retain)    NSString * valid;
@property (nonatomic, retain)    NSString * InValid;
@property (nonatomic, retain)    NSString * registeredSuccesfuly;
@property (nonatomic, retain)    NSString * clientList;
@property (nonatomic, retain)    NSString * addNewUser;
@property (nonatomic, retain)    NSString * listOfOnlineClient;

@property (nonatomic, retain)    NSString * sendMSG;

//@property (nonatomic, retain)    NSString * tableViewDataSet;

@property (nonatomic, retain)    NSString * senderName;
@property (nonatomic, retain)    NSString * senderId;
@property (nonatomic, retain)    NSString *receiverName;
@property (nonatomic, retain)    NSString * receiverId;

@property (nonatomic, retain)    NSString *selfUserName;
@property (nonatomic, retain)    NSString *selfUserPhoneNo;

@property (nonatomic, retain)    NSString *createGroup;
@property (nonatomic, retain)    NSString *phoneNumber;

@property (nonatomic, retain)    NSString *clientListAdded;
@property (nonatomic, retain)    NSString *needToReloadTableView;

@property (nonatomic, retain)    NSMutableArray *chatArray;
@property (nonatomic, retain)    NSMutableArray *recieverIDArray;
@property (nonatomic, retain)    NSMutableArray *recieverNameArray;

@property (nonatomic, retain)    NSMutableDictionary *mainChatDictionary;

@property (nonatomic, retain)    NSMutableArray *MSGRecievedArray;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    shareObj = [[UIApplication sharedApplication] delegate];
    objDB=[[DBManager alloc]initWithDatabaseFilename:@"Clients"];
    shareObj.MSGRecievedArray = [[NSMutableArray alloc]init];
    NSString *q =@"select * from self";
    selfUserData=[objDB loadDataFromDB:q];
    NSLog(@"\n\nself user detail From DB  : %@\n\n",selfUserData);
    
    //If Registered first then go to chat
    if(selfUserData.count > 0){
        shareObj.selfUserName = selfUserData[0][0];
        shareObj.selfUserPhoneNo = selfUserData[0][1];
        
        
        self.window = [[UIWindow alloc] initWithFrame:UIScreen.mainScreen.bounds];
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        
        UIViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:@"tbar"]; // <storyboard id>
        
        self.window.rootViewController = viewController;
        [self.window makeKeyAndVisible];


    }
    else{
        self.window = [[UIWindow alloc] initWithFrame:UIScreen.mainScreen.bounds];
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        
        UIViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:@"login"]; // <storyboard id>
        
        self.window.rootViewController = viewController;
        [self.window makeKeyAndVisible];

    
    }
    
    shareObj.sendMSG = @"";
    
   
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
