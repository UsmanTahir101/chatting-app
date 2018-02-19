//
//  SocketClientVc.h
//  ScoketChatApplication
//
//  Created by Abdul Rehman on 5/22/16.
//  Copyright © 2016 Abdul Rehman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AsyncSocket.h"
#import "JSQMessageControllerTest.h"
#import "AppDelegate.h"
#import "dataSharingClass.h"

@interface SocketClientVc : UIViewController
-(void)wirteData : (NSString *)data;
-(void)stopTimer;
-(void)startTimer;
-(void)stopScoket;
- (void)connectWithSocket;
-(void) readData ;
@end
