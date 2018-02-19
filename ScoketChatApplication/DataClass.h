//
//  DataClass.h
//  JSQMessages
//
//  Created by C_v on 19/05/2016.
//  Copyright © 2016 Hexed Bits. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

#import "JSQMessages.h"

static NSString * const AB = @"AB";
static NSString * const Umair = @"Umair";
static NSString * const ABId = @"03476760226";
static NSString * const UmairId = @"03365565947";



@interface DataClass : NSObject

@property (strong, nonatomic) NSMutableArray *messages;

@property (strong, nonatomic) NSDictionary *avatars;

@property (strong, nonatomic) JSQMessagesBubbleImage *outgoingBubbleImageData;

@property (strong, nonatomic) JSQMessagesBubbleImage *incomingBubbleImageData;

@property (strong, nonatomic) NSDictionary *users;


@end
