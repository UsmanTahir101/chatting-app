//
//  VerifyVC.h
//  ScoketChatApplication
//
//  Created by Abdul Rehman on 5/24/16.
//  Copyright © 2016 Abdul Rehman. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VerifyVC : UIViewController{
     NSString * vCode;
    
}
-(void)startTimer;
-(void)stopTimer;
@property (nonatomic,retain)  NSString * vCode;
@end
