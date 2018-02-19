//
//  dataSharingClass.h
//  ScoketChatApplication
//
//  Created by Abdul Rehman on 5/22/16.
//  Copyright © 2016 Abdul Rehman. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface dataSharingClass : NSObject{
    
    NSString* MSG;
    NSString* valid;
    NSString* InValid;
    NSString *registeredSuccesfuly;
    NSString* clientList;
    NSString* addNewUser;
    NSString *listOfOnlineClient;
    
    NSString *sendMSG;
    
    NSString * senderName;
    NSString *senderId;
    NSString *receiverName;
    NSString *receiverId;
    
    NSString *selfUserName;
    NSString *selfUserPhoneNo;
    
    
    NSString *createGroup;
    NSString *phoneNumber;
    
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
