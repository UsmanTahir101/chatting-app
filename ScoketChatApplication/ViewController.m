//
//  ViewController.m
//  BiiTapp
//
//  Created by Usman's Mac on 08/03/2016.
//  Copyright © 2016 Usman's Mac. All rights reserved.
//

#import "ViewController.h"
#import "SocketClientVc.h"
#import "DBManager.h"

@interface ViewController ()
{
    
    dataSharingClass *shareObj;
    
    
    NSString * resultStrHeader;
    NSString * resultStrBody;
}
@property (weak, nonatomic) IBOutlet UITextField *numberTextField;


@end

@implementation ViewController

@synthesize numberTextField;



// keyboard dismissing
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    shareObj = [[UIApplication sharedApplication] delegate];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)continueBtn:(id)sender {
    if([numberTextField.text isEqualToString:@""])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Warning"
                                                        message:@"Insert number in text feild"
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        
    }
    else
    {
        
        NSString *strVal = [NSString stringWithFormat:@"check|%@",numberTextField.text];
        
        shareObj.sendMSG =  strVal;
        shareObj.phoneNumber = numberTextField.text;
        [self performSegueWithIdentifier:@"VerifacyCode" sender:nil];
        
    }
    
}
-(NSString *)SaveNumber:(NSString *)phoNumber
{
    return @"";
}
-(NSString *)AutoGenerateNumber:(NSString *)phoNumber
{
    return @"";
}


@end
