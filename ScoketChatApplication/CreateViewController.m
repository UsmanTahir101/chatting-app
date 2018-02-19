//
//  CreateViewController.m
//  ScoketChatApplication
//
//  Created by AbdulRehman on 21/06/2016.
//  Copyright © 2016 Abdul Rehman. All rights reserved.
//

#import "CreateViewController.h"
#import "dataSharingClass.h"
#import "DBManager.h"
#import "FriendsTableViewController.h"

@interface CreateViewController (){
    //    NSMutableArray * selectedNameArray;
    //    NSMutableArray * selectedIdArray;
    dataSharingClass *shareObj;
    DBManager * objDB;
}
@property (weak, nonatomic) IBOutlet UITextField *txtName;
@property (weak, nonatomic) IBOutlet UITableView *tableView;


@end

@implementation CreateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.tableView.delegate  = self;
    self.tableView.dataSource = self;
    shareObj = [[UIApplication sharedApplication] delegate];
    objDB=[[DBManager alloc]initWithDatabaseFilename:@"Clients"];
    
    [shareObj.selectedNameArray removeAllObjects];
    [shareObj.selectedIdArray removeAllObjects];
}
-(void)viewWillAppear:(BOOL)animated{
    NSLog(@"\nSelected Names : %@",shareObj.selectedNameArray);
    NSLog(@"\nSelected ID : %@",shareObj.selectedIdArray);
    
    [self.tableView reloadData];
//    self.hidesBottomBarWhenPushed = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return shareObj.selectedNameArray.count;
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    if(shareObj.selectedNameArray.count > 0){
        cell.textLabel.text = shareObj.selectedNameArray[indexPath.row];
    }
    else{
        cell.textLabel.text = @"test";
    }
    
    return cell;
    
}


 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

 }
 
- (IBAction)btnCreate:(id)sender {
    
    if (shareObj.selectedNameArray.count > 0) {
        if (![_txtName.text  isEqual: @""]) {
            
            
            
            NSString* strIdArray = @"";
            
            for (int i = 0; i<shareObj.selectedNameArray.count; i+=1) {
                if(i  == 0){
                    strIdArray = shareObj.selectedIdArray[i];
                }else{
                    strIdArray = [NSString stringWithFormat:@"%@,%@",strIdArray,shareObj.selectedIdArray[i]];
                }
            }
            
            NSString *alertText1 = _txtName.text;
            NSString *alertText2 = strIdArray;
            NSString * str = [NSString stringWithFormat:@"%@,%@",alertText2,shareObj.selfUserPhoneNo];
            NSString * query= [NSString stringWithFormat:@" INSERT INTO home (Name,PhoneNo,IsGroup) VALUES ('%@','%@','yes')",alertText1,str];
            NSLog(@"\n\n Query : %@",query);
            [objDB executeQuery:query];
            
            [self.tableView reloadData];
            
            NSString *groupName = alertText1;
            NSString *val = @"CreateGroup|";
            NSString *Sender = shareObj.selfUserPhoneNo ;
            NSString *Receiver = alertText2 ;
            Receiver = [Receiver stringByAppendingString:@","];
            Receiver = [Receiver stringByAppendingString:shareObj.selfUserPhoneNo];
            val = [val stringByAppendingString:Sender];
            val = [val stringByAppendingString:@"|"];
            val = [val stringByAppendingString:Receiver];
            val = [val stringByAppendingString:@"|"];
            val = [val stringByAppendingString:groupName];
            val = [val stringByAppendingString:@"|"];
            val = [val stringByAppendingString:shareObj.selfUserName];
            
            
            NSLog(@"\n\nCreate Message Query : %@",val);
            
            shareObj.sendMSG = val;
            
            shareObj.needToReloadTableView = @"true";
           [self.navigationController popViewControllerAnimated:YES];
             self.hidesBottomBarWhenPushed = NO;
        }
        else{
            UIAlertController * alert=   [UIAlertController
                                          alertControllerWithTitle:@"Alert"
                                          message:[NSString stringWithFormat:@"Enter Group Name To Create Group Text:%@ ",self.txtName.text]
                                          preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* ok = [UIAlertAction
                                 actionWithTitle:@"OK"
                                 style:UIAlertActionStyleDefault
                                 handler:^(UIAlertAction * action)
                                 {
                                     [alert dismissViewControllerAnimated:YES completion:nil];
                                     
                                 }];
        
            
            [alert addAction:ok];
     
            
             [self presentViewController:alert animated:YES completion:nil];
        }
    }
    else{

        
        UIAlertController * alert=   [UIAlertController
                                      alertControllerWithTitle:@"Alert"
                                      message:@"Selecte Group Members To Create Group"
                                      preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* ok = [UIAlertAction
                             actionWithTitle:@"OK"
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action)
                             {
                                 [alert dismissViewControllerAnimated:YES completion:nil];
                                 
                             }];
        
        
        [alert addAction:ok];
        
        
        [self presentViewController:alert animated:YES completion:nil];
    }
}

@end
