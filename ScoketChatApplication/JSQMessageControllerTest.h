//
//  JSQMessageControllerTest.h
//  JSQMessages
//
//  Created by C_v on 19/05/2016.
//  Copyright © 2016 Hexed Bits. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JSQMessage.h"
#import "JSQMessagesViewController.h"
#import "dataSharingClass.h"
#import "DataClass.h"
#import "SocketClientVc.h"



@interface JSQMessageControllerTest : JSQMessagesViewController <JSQMessagesComposerTextViewPasteDelegate  >{
    
    NSString *receiverName;
    NSString *receiverID;
    NSString *shareName;
    NSString *shareID;
    
    
}
-(void)receiveMessagePressed : (NSString *)receivedText;
@property (strong, nonatomic) DataClass *demoData;
//@property (strong, nonatomic) clientSocket *socketTest;
@property (strong, nonatomic) NSMutableArray *messages;

@property (strong, nonatomic) JSQMessagesBubbleImage *outgoingBubbleImageData;

@property (strong, nonatomic) JSQMessagesBubbleImage *incomingBubbleImageData;

@property (retain, nonatomic) NSString *receiverName;
@property (retain, nonatomic) NSString *receiverID;
@property (retain, nonatomic) NSString *shareName;
@property (retain, nonatomic) NSString *shareID;

@end
