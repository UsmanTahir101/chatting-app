//
//  AddGroupTableViewController.m
//  ScoketChatApplication
//
//  Created by AbdulRehman on 21/06/2016.
//  Copyright © 2016 Abdul Rehman. All rights reserved.
//

#import "AddGroupTableViewController.h"
#import "DBManager.h"
#import "SocketClientVc.h"
#import "dataSharingClass.h"
#import "CreateViewController.h"

@interface AddGroupTableViewController (){
    DBManager * objDB;
    
    SocketClientVc * socket;
    dataSharingClass *shareObj;
    
    NSTimer * classTimer;
    NSArray* dataArray ;
    
    NSString *senderId;
    NSString *receiverId;
    
    NSArray * dataFromDataBase;
    
    NSArray * selfUserData;
    
    NSMutableArray * nameArray;
    NSMutableArray * idArray;
    
    NSMutableArray * selectedNameArray;
    NSMutableArray * selectedIdArray;
    
}

@end

@implementation AddGroupTableViewController

int dataCounter = 0;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.hidesBottomBarWhenPushed = YES;
    
    shareObj = [[UIApplication sharedApplication] delegate];
    [self loadData];
    nameArray = [[NSMutableArray alloc]init];
    idArray = [[NSMutableArray alloc]init];
    
    selectedNameArray = [[NSMutableArray alloc]init];
    selectedIdArray = [[NSMutableArray alloc]init];
    
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc]
                                   initWithTitle:@"Done"
                                   style:UIBarButtonItemStyleBordered
                                   target:self
                                   action:@selector(doneButton:)];
    self.navigationItem.rightBarButtonItem = doneButton;
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (IBAction)doneButton:(id)sender {
    
    shareObj.selectedNameArray = selectedNameArray;
    shareObj.selectedIdArray = selectedIdArray;
    
    
    
    [self.navigationController popViewControllerAnimated:YES];
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    
    if ([dataFromDataBase[indexPath.row][2]  isEqual: @"no"]) {
        
        cell.imageView.contentMode = UIViewContentModeCenter;
        //        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        
        cell.textLabel.text = dataFromDataBase[indexPath.row][0];
        cell.imageView.image = nil;
        [nameArray addObject:dataFromDataBase[indexPath.row][0]];
        [idArray addObject: dataFromDataBase[indexPath.row][1]];
        dataCounter += 1 ;
        
    }
    
    
    return cell;
}-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(indexPath.row < dataCounter){
        
        
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        if(![cell.textLabel.text isEqual:@""]){
            if( cell.imageView.image == nil){
                UIImage* im = [UIImage imageNamed:@"check2.png"];
                UIGraphicsBeginImageContextWithOptions(CGSizeMake(20,20), YES, 0);
                [im drawInRect:CGRectMake(0,0,20,20)];
                UIImage* im2 = UIGraphicsGetImageFromCurrentImageContext();
                UIGraphicsEndImageContext();
                cell.imageView.image = im2;
                
                [selectedIdArray addObject:[idArray objectAtIndex:[nameArray indexOfObject: cell.textLabel.text]]];
                [selectedNameArray addObject:[nameArray objectAtIndex:[nameArray indexOfObject: cell.textLabel.text]]];
            }
            else{
                cell.imageView.image = nil;
                [selectedNameArray removeObject:[nameArray objectAtIndex:[nameArray indexOfObject: cell.textLabel.text]]];
                [selectedIdArray removeObject:[idArray objectAtIndex:[nameArray indexOfObject: cell.textLabel.text]]];
            }
        }
        
        
        
    }
    
    
}


-(void)loadData{
    
    
    objDB=[[DBManager alloc]initWithDatabaseFilename:@"Clients"];
    
    NSString * query=@"select * from home";
    dataFromDataBase=[objDB loadDataFromDB:query];
    NSLog(@"\n\nNames From DB  : %@\n\n",dataFromDataBase);
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier  isEqual: @"selectedMembers"]){
        
        shareObj.selectedNameArray = selectedNameArray;
        shareObj.selectedIdArray = selectedIdArray;
        
        NSLog(@"\nSelected Names : %@",shareObj.selectedNameArray);
        NSLog(@"\nSelected ID : %@",shareObj.selectedIdArray);
        
        
        
        
    }
}


@end
