//
//  DataClass.m
//  JSQMessages
//
//  Created by C_v on 19/05/2016.
//  Copyright © 2016 Hexed Bits. All rights reserved.
//

#import "DataClass.h"
//#import "NSUserDefaults+DemoSettings.h"


/**
 *  This is for demo/testing purposes only.
 *  This object sets up some fake model data.
 *  Do not actually do anything like this.
 */

@implementation DataClass

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        self.messages = [[NSMutableArray alloc]init];
        
        /**
         *  Create avatar images once.
         *
         *  Be sure to create your avatars one time and reuse them for good performance.
         *
         *  If you are not using avatars, ignore this.
         */
        
        
        
        
        self.users = @{ @"03476760226" : @"Abdulrehman",
                        @"03365565947" : @"Umair"
                        };
        
        
        /**
         *  Create message bubble images objects.
         *
         *  Be sure to create your bubble images one time and reuse them for good performance.
         *
         */
        JSQMessagesBubbleImageFactory *bubbleFactory = [[JSQMessagesBubbleImageFactory alloc] init];
        
        self.outgoingBubbleImageData = [bubbleFactory outgoingMessagesBubbleImageWithColor:[UIColor jsq_messageBubbleLightGrayColor]];
        self.incomingBubbleImageData = [bubbleFactory incomingMessagesBubbleImageWithColor:[UIColor jsq_messageBubbleGreenColor]];
    }
    
    return self;
}




@end
