//
//  JSQMessageControllerTest.m
//  JSQMessages
//
//  Created by C_v on 19/05/2016.
//  Copyright © 2016 Hexed Bits. All rights reserved.
//

#import "JSQMessageControllerTest.h"
#import "SocketClientVc.h"

@interface JSQMessageControllerTest (){
    SocketClientVc * socket;
    dataSharingClass *shareObj;
    NSTimer *timer;
    NSString * _testMsg;
}

@end

@implementation JSQMessageControllerTest
@synthesize shareID;
@synthesize shareName;
@synthesize receiverID;
@synthesize receiverName;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    shareObj = [[UIApplication sharedApplication] delegate];
    
    
    
    self.tabBarItem.accessibilityElementsHidden = true;
    //    self.senderId = ABId;
    //    self.senderDisplayName = AB ;
    //    NSLog(@"%@",self.senderId);
    
    self.senderId = shareObj.selfUserPhoneNo;
    self.senderDisplayName = shareObj.selfUserName;
    
    NSLog(@"\n Sender ID : %@",shareObj.selfUserPhoneNo);
    NSLog(@"\n Receiver Name : %@",shareObj.receiverName);
    NSLog(@"\n Receiver ID : %@",shareObj.receiverId);
    
    self.navigationItem.title = shareObj.receiverName;
    
    
    if([shareObj.recieverIDArray containsObject:shareObj.receiverId]){
       
        NSLog(@"Reciever Object Exist :%@",[shareObj.recieverIDArray objectAtIndex:[shareObj.recieverIDArray indexOfObject:shareObj.receiverId]]);
    }
    else{
        [shareObj.recieverIDArray addObject:shareObj.receiverId];
        [shareObj.recieverNameArray addObject:shareObj.receiverName];
        
        NSLog(@"Reciever Array :%@",shareObj.recieverIDArray);
    }
    
    
    // hiding Attachment  Button
    
    self.inputToolbar.contentView.leftBarButtonItem = nil;
    
    self.demoData = [[DataClass alloc] init];
    self.inputToolbar.contentView.textView.pasteDelegate = self;
    
    
    // NSString *val = @"ID";
    //val = [val stringByAppendingString:@"|03365565947"];
    //[socket wirteData:val ];//send data to server using this method
    
    
    /**
     *  Create message bubble images objects.
     *
     *  Be sure to create your bubble images one time and reuse them for good performance.
     *
     */
    JSQMessagesBubbleImageFactory *bubbleFactory = [[JSQMessagesBubbleImageFactory alloc] init];
    
    // chahniing color of  incoming and outgoning message bubbles
    
    self.demoData.outgoingBubbleImageData = [bubbleFactory outgoingMessagesBubbleImageWithColor:[UIColor jsq_messageBubbleBlueColor]];
    self.demoData.incomingBubbleImageData = [bubbleFactory incomingMessagesBubbleImageWithColor:[UIColor jsq_messageBubbleGreenColor]];
    
    // displaying message in bubbles
    
    //[self receiveMessagePressed:@""];
    [self loadViewIfNeeded];
    
    
//    /**
//     *  Register custom menu actions for cells.
//     */
//    [JSQMessagesCollectionViewCell registerMenuAction:@selector(customAction:)];
    
    
    /**
     *  OPT-IN: allow cells to be deleted
     */
    [JSQMessagesCollectionViewCell registerMenuAction:@selector(delete:)];
    
    
    // receiveind data in another thread
    
    timer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(timerCalled) userInfo:nil repeats:YES];
    
 //    [self demoDataForJSQ];
    
    NSArray *arrMain;
    [self.demoData.messages removeAllObjects];
    
    if ([shareObj.mainChatDictionary objectForKey:shareObj.receiverId]) {
        
        arrMain = [shareObj.mainChatDictionary objectForKey:shareObj.receiverId];
        for (int i=0; i < arrMain.count; i++) {
            JSQMessage *message = [arrMain objectAtIndex:i];
            [self.demoData.messages addObject:message];
            [self reloadMessagesView];
        }
        
    }
    
  
    
    
    
    
    
    
}

-(void)timerCalled
{
    //Checking for Recevied data
    //NSLog(@"Timer Ticked");
    if (![shareObj.MSG isEqualToString:@""]) {
        
        [self receiveMessagePressed:@""];
    }
    
}

// Display username at top of cell using this method

- (NSAttributedString *)collectionView:(JSQMessagesCollectionView *)collectionView attributedTextForCellTopLabelAtIndexPath:(NSIndexPath *)indexPath
{
    /**
     *  This logic should be consistent with what you return from `heightForCellTopLabelAtIndexPath:`
     *  The other label text delegate methods should follow a similar pattern.
     *
     *  Show a timestamp for every 3rd message
     */
    //    if (indexPath.item % 3 == 0) {
    //        JSQMessage *message = [self.demoData.messages objectAtIndex:indexPath.item];
    //        return [[JSQMessagesTimestampFormatter sharedFormatter] attributedTimestampForDate:message.date];
    //    }
    
//    return nil;
    
    JSQMessage *message = [self.demoData.messages objectAtIndex:indexPath.item];
            return [[JSQMessagesTimestampFormatter sharedFormatter] attributedTimestampForDate:message.date];
}


// reload the messages in bubbles
- (void)reloadMessagesView {
    [self.collectionView reloadData];
}

// number of messages in chat
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.demoData.messages count];
}

// displaying each messages one by one just like tableview

- (UICollectionViewCell *)collectionView:(JSQMessagesCollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    /**
     *  Override point for customizing cells
     */
    JSQMessagesCollectionViewCell *cell = (JSQMessagesCollectionViewCell *)[super collectionView:collectionView cellForItemAtIndexPath:indexPath];
    
    /**
     *  Configure almost *anything* on the cell
     *
     *  Text colors, label text, label colors, etc.
     *
     *
     *  DO NOT set `cell.textView.font` !
     *  Instead, you need to set `self.collectionView.collectionViewLayout.messageBubbleFont` to the font you want in `viewDidLoad`
     *
     *
     *  DO NOT manipulate cell layout information!
     *  Instead, override the properties you want on `self.collectionView.collectionViewLayout` from `viewDidLoad`
     */
    
    JSQMessage *msg = [self.demoData.messages objectAtIndex:indexPath.item];
    
    if (!msg.isMediaMessage) {
        
        // chahning text color of message bubbles
        
        if ([msg.senderId isEqualToString:self.senderId]) {
            cell.textView.textColor = [UIColor whiteColor];
        }
        else {
            cell.textView.textColor = [UIColor whiteColor];
        }
        
        cell.textView.linkTextAttributes = @{ NSForegroundColorAttributeName : cell.textView.textColor,
                                              NSUnderlineStyleAttributeName : @(NSUnderlineStyleSingle | NSUnderlinePatternSolid) };
    }
    
    return cell;
}

#pragma mark - UICollectionView Delegate

#pragma mark - Custom menu items

// actions at selecting the mesages text like cut copy and paste

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender
{
    if (action == @selector(customAction:)) {
        return YES;
    }
    
    return [super collectionView:collectionView canPerformAction:action forItemAtIndexPath:indexPath withSender:sender];
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender
{
    if (action == @selector(customAction:)) {
        [self customAction:sender];
        return;
    }
    
    [super collectionView:collectionView performAction:action forItemAtIndexPath:indexPath withSender:sender];
}

- (void)customAction:(id)sender
{
    NSLog(@"Custom action received! Sender: %@", sender);
    
    [[[UIAlertView alloc] initWithTitle:@"Custom Action"
                                message:nil
                               delegate:nil
                      cancelButtonTitle:@"OK"
                      otherButtonTitles:nil]
     show];
}

#pragma mark - Adjusting cell label heights

// chanong the height of cell lable

- (CGFloat)collectionView:(JSQMessagesCollectionView *)collectionView
                   layout:(JSQMessagesCollectionViewFlowLayout *)collectionViewLayout heightForCellTopLabelAtIndexPath:(NSIndexPath *)indexPath
{
    /**
     *  Each label in a cell has a `height` delegate method that corresponds to its text dataSource method
     */
    
    /**
     *  This logic should be consistent with what you return from `attributedTextForCellTopLabelAtIndexPath:`
     *  The other label height delegate methods should follow similarly
     *
     *  Show a timestamp for every 3rd message
     */
//    if (indexPath.item % 3 == 0) {
//        return kJSQMessagesCollectionViewCellLabelHeightDefault;
//    }
//    
//    return 0.0f;
    
     return kJSQMessagesCollectionViewCellLabelHeightDefault;
    
}

// changing height of message bubble top lable

- (CGFloat)collectionView:(JSQMessagesCollectionView *)collectionView
                   layout:(JSQMessagesCollectionViewFlowLayout *)collectionViewLayout heightForMessageBubbleTopLabelAtIndexPath:(NSIndexPath *)indexPath
{
    /**
     *  iOS7-style sender name labels
     */
    JSQMessage *currentMessage = [self.demoData.messages objectAtIndex:indexPath.item];
    if ([[currentMessage senderId] isEqualToString:self.senderId]) {
        return 0.0f;
    }
    
    if (indexPath.item - 1 > 0) {
        JSQMessage *previousMessage = [self.demoData.messages objectAtIndex:indexPath.item - 1];
        if ([[previousMessage senderId] isEqualToString:[currentMessage senderId]]) {
            return 0.0f;
        }
    }
    
    return kJSQMessagesCollectionViewCellLabelHeightDefault;
}

// chaning the hieght of cell bottom lable

- (CGFloat)collectionView:(JSQMessagesCollectionView *)collectionView
                   layout:(JSQMessagesCollectionViewFlowLayout *)collectionViewLayout heightForCellBottomLabelAtIndexPath:(NSIndexPath *)indexPath
{
    return 0.0f;
}

// proding message data to display from our array

- (id<JSQMessageData>)collectionView:(JSQMessagesCollectionView *)collectionView messageDataForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return [self.demoData.messages objectAtIndex:indexPath.item];
}

// deleteing a message by selecting it

- (void)collectionView:(JSQMessagesCollectionView *)collectionView didDeleteMessageAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableArray *arrMain = [shareObj.mainChatDictionary objectForKey:shareObj.receiverId];
    
//    [arrMain removeObjectAtIndex:[arrMain indexOfObject:[self.demoData.messages objectAtIndex:indexPath.item]]];
    [arrMain removeObject:[self.demoData.messages objectAtIndex:indexPath.item]];
    NSLog(@"Remove : %@",[self.demoData.messages objectAtIndex:indexPath.item]);
    
    [self.demoData.messages removeObjectAtIndex:indexPath.item];
}


- (id<JSQMessageBubbleImageDataSource>)collectionView:(JSQMessagesCollectionView *)collectionView messageBubbleImageDataForItemAtIndexPath:(NSIndexPath *)indexPath
{
    /**
     *  You may return nil here if you do not want bubbles.
     *  In this case, you should set the background color of your collection view cell's textView.
     *
     *  Otherwise, return your previously created bubble image data objects.
     */
    
    JSQMessage *message = [self.demoData.messages objectAtIndex:indexPath.item];
    
    if ([message.senderId isEqualToString:self.senderId]) {
        return self.demoData.outgoingBubbleImageData;
    }
    
    return self.demoData.incomingBubbleImageData;
}

// displaying avatar image

- (id<JSQMessageAvatarImageDataSource>)collectionView:(JSQMessagesCollectionView *)collectionView avatarImageDataForItemAtIndexPath:(NSIndexPath *)indexPath
{
    /**
     *  Return `nil` here if you do not want avatars.
     *  If you do return `nil`, be sure to do the following in `viewDidLoad`:
     *
     *  self.collectionView.collectionViewLayout.incomingAvatarViewSize = CGSizeZero;
     *  self.collectionView.collectionViewLayout.outgoingAvatarViewSize = CGSizeZero;
     *
     *  It is possible to have only outgoing avatars or only incoming avatars, too.
     */
    
    /**
     *  Return your previously created avatar image data objects.
     *
     *  Note: these the avatars will be sized according to these values:
     *
     *  self.collectionView.collectionViewLayout.incomingAvatarViewSize
     *  self.collectionView.collectionViewLayout.outgoingAvatarViewSize
     *
     *  Override the defaults in `viewDidLoad`
     */
    //    JSQMessage *message = [self.demoData.messages objectAtIndex:indexPath.item];
    //
    //    if ([message.senderId isEqualToString:self.senderId]) {
    //        if (![NSUserDefaults outgoingAvatarSetting]) {
    //            return nil;
    //        }
    //    }
    //    else {
    //        if (![NSUserDefaults incomingAvatarSetting]) {
    //            return nil;
    //        }
    //    }
    //
    //
    //    return [self.demoData.avatars objectForKey:message.senderId];
    
    return nil;
}




// Display text at top of bubble using this method

- (NSAttributedString *)collectionView:(JSQMessagesCollectionView *)collectionView attributedTextForMessageBubbleTopLabelAtIndexPath:(NSIndexPath *)indexPath
{
    JSQMessage *message = [self.demoData.messages objectAtIndex:indexPath.item];
    
    /**
     *  iOS7-style sender name labels
     */
    if ([message.senderId isEqualToString:self.senderId]) {
        return nil;
    }
    
    if (indexPath.item - 1 > 0) {
        JSQMessage *previousMessage = [self.demoData.messages objectAtIndex:indexPath.item - 1];
        if ([[previousMessage senderId] isEqualToString:message.senderId]) {
            return nil;
        }
    }
    
    /**
     *  Don't specify attributes to use the defaults.
     */
    return [[NSAttributedString alloc] initWithString:message.senderDisplayName];
}

// Display text at bottom of bubble using this method

- (NSAttributedString *)collectionView:(JSQMessagesCollectionView *)collectionView attributedTextForCellBottomLabelAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

- (BOOL)composerTextView:(JSQMessagesComposerTextView *)textView shouldPasteWithSender:(id)sender
{
    //    if ([UIPasteboard generalPasteboard].image) {
    //        // If there's an image in the pasteboard, construct a media item with that image and `send` it.
    //        JSQPhotoMediaItem *item = [[JSQPhotoMediaItem alloc] initWithImage:[UIPasteboard generalPasteboard].image];
    //        JSQMessage *message = [[JSQMessage alloc] initWithSenderId:self.senderId
    //                                                 senderDisplayName:self.senderDisplayName
    //                                                              date:[NSDate date]
    //                                                             media:item];
    //        [self.demoData.messages addObject:message];
    //        [self finishSendingMessage];
    //        return NO;
    //    }
    return YES;
}

// sending message by pressing send button

- (void)didPressSendButton:(UIButton *)button
           withMessageText:(NSString *)text
                  senderId:(NSString *)senderId
         senderDisplayName:(NSString *)senderDisplayName
                      date:(NSDate *)date
{
    [JSQSystemSoundPlayer jsq_playMessageSentSound];
    
    JSQMessage *message = [[JSQMessage alloc] initWithSenderId:self.senderId
                                             senderDisplayName:self.senderDisplayName
                                                          date:[NSDate date]
                                                          text:text];
    
    [self.demoData.messages addObject:message];
    
    [self finishSendingMessageAnimated:YES];
    
    NSString *msg = text;
    NSString *val = @"MSG|";
    NSString *Sender = shareObj.senderId ;
    NSString *Receiver = shareObj.receiverId ;
    val = [val stringByAppendingString:Sender];
    val = [val stringByAppendingString:@"|"];
    val = [val stringByAppendingString:Receiver];
    val = [val stringByAppendingString:@"|"];
    val = [val stringByAppendingString:msg];
    val = [val stringByAppendingString:@"|"];
    val = [val stringByAppendingString:shareObj.senderName];
  
    NSMutableArray *arrMain;
//    NSMutableArray *subArr = [[NSMutableArray alloc] initWithCapacity:2];
    
    if ([shareObj.mainChatDictionary objectForKey:shareObj.receiverId]) {
        
        arrMain = [shareObj.mainChatDictionary objectForKey:shareObj.receiverId];
//        subArr[0] = shareObj.senderId ;
//        subArr[1] = message ;
//        [arrMain addObject:subArr];
        [arrMain addObject:message];
        
        [shareObj.mainChatDictionary setObject:arrMain forKey:shareObj.receiverId];
        
    }
    else{
        arrMain = [[NSMutableArray alloc]init];
        
//        subArr[0] = shareObj.senderId ;
//        subArr[1] = message ;
//        [arrMain addObject:subArr];

        [arrMain addObject:message];
        [shareObj.mainChatDictionary setObject:arrMain forKey:shareObj.receiverId];
    }
    
    
    
    shareObj.sendMSG = val;
    
    
}

- (void)receiveMessagePressed:(NSString *)receivedText
{
   /* if (_testMsg != shareObj.MSG) {
        _testMsg = shareObj.MSG;
        
        NSArray *arr = [shareObj.MSG componentsSeparatedByString:@"|"];
        
        if([[arr objectAtIndex:0] isEqualToString:@"MSG"]){
            if(![[arr objectAtIndex:4] isEqualToString:shareObj.selfUserName] && ![[arr objectAtIndex:1] isEqualToString:shareObj.selfUserPhoneNo]){
                
                JSQMessage *copyMessage ;
                
                copyMessage = [[JSQMessage alloc] initWithSenderId:[arr objectAtIndex:1]
                                                 senderDisplayName:[arr objectAtIndex:4]
                                                              date:[NSDate date]
                                                              text:[arr objectAtIndex:3]];
                
                
                [self.demoData.messages addObject:copyMessage];
                shareObj.MSG = @"";
                NSMutableArray *arrMain;
                //    NSMutableArray *subArr = [[NSMutableArray alloc] initWithCapacity:2];
                
                if ([shareObj.mainChatDictionary objectForKey:shareObj.receiverId]) {
                    
                    arrMain = [shareObj.mainChatDictionary objectForKey:shareObj.receiverId];
                    //        subArr[0] = shareObj.senderId ;
                    //        subArr[1] = message ;
                    //        [arrMain addObject:subArr];
                    [arrMain addObject:copyMessage];
                    
                    [shareObj.mainChatDictionary setObject:arrMain forKey:shareObj.receiverId];
                    
                }
                else{
                    arrMain = [[NSMutableArray alloc]init];
                    
                    //        subArr[0] = shareObj.senderId ;
                    //        subArr[1] = message ;
                    //        [arrMain addObject:subArr];
                    
                    [arrMain addObject:copyMessage];
                    [shareObj.mainChatDictionary setObject:arrMain forKey:shareObj.receiverId];
                }
                
                [self reloadMessagesView];
                
                
                
                
                
            }
            
        }
        
        
        
    }*/
    
    for (int i= 0; i<shareObj.MSGRecievedArray.count; i++) {
        
        if (![[shareObj.MSGRecievedArray objectAtIndex:i]isEqualToString:@""]){
            
            NSArray *arr = [[shareObj.MSGRecievedArray objectAtIndex:i] componentsSeparatedByString:@"|"];
            
            if([[arr objectAtIndex:0] isEqualToString:@"MSG"]){
                
                NSArray *arr = [shareObj.MSG componentsSeparatedByString:@"|"];
                
                if([[arr objectAtIndex:0] isEqualToString:@"MSG"]){
                    if(![[arr objectAtIndex:4] isEqualToString:shareObj.selfUserName] && ![[arr objectAtIndex:1] isEqualToString:shareObj.selfUserPhoneNo]){
                        
                        JSQMessage *copyMessage ;
                        
                        copyMessage = [[JSQMessage alloc] initWithSenderId:[arr objectAtIndex:1]
                                                         senderDisplayName:[arr objectAtIndex:4]
                                                                      date:[NSDate date]
                                                                      text:[arr objectAtIndex:3]];
                        
                        
                        [self.demoData.messages addObject:copyMessage];
                        shareObj.MSG = @"";
                        NSMutableArray *arrMain;
                        //    NSMutableArray *subArr = [[NSMutableArray alloc] initWithCapacity:2];
                        
                        if ([shareObj.mainChatDictionary objectForKey:shareObj.receiverId]) {
                            
                            arrMain = [shareObj.mainChatDictionary objectForKey:shareObj.receiverId];
                            //        subArr[0] = shareObj.senderId ;
                            //        subArr[1] = message ;
                            //        [arrMain addObject:subArr];
                            [arrMain addObject:copyMessage];
                            
                            [shareObj.mainChatDictionary setObject:arrMain forKey:shareObj.receiverId];
                            
                        }
                        else{
                            arrMain = [[NSMutableArray alloc]init];
                            
                            //        subArr[0] = shareObj.senderId ;
                            //        subArr[1] = message ;
                            //        [arrMain addObject:subArr];
                            
                            [arrMain addObject:copyMessage];
                            [shareObj.mainChatDictionary setObject:arrMain forKey:shareObj.receiverId];
                        }
                        
                        [self reloadMessagesView];
                        
                        
                        
                        
                        
                    }
                    
                }
            }
            
            [shareObj.MSGRecievedArray removeObjectAtIndex:i];
            
            
            
        }

    }
    
    
    
}
/*

-(void)demoDataForJSQ
 {
 
 JSQMessage *copyMessage ;
 
 copyMessage = [[JSQMessage alloc] initWithSenderId:@"1"
 senderDisplayName:@"Usman"
 date:[NSDate date]
 text:@"Hello"];
 [self.demoData.messages addObject:copyMessage];
 
     NSMutableArray *arrMain;
     NSMutableArray *subArr = [[NSMutableArray alloc] initWithCapacity:2];
     
     if ([shareObj.mainChatDictionary objectForKey:shareObj.receiverId]) {
         
         arrMain = [shareObj.mainChatDictionary objectForKey:shareObj.receiverId];
         subArr[0] = shareObj.senderId ;
         subArr[1] = @"Test" ;
         [arrMain addObject:subArr];
         
         [shareObj.mainChatDictionary setObject:arrMain forKey:shareObj.receiverId];
         
     }
     else{
         arrMain = [[NSMutableArray alloc]init];
         
         subArr[0] = shareObj.senderId ;
         subArr[1] = @"Test"  ;
         [arrMain addObject:subArr];
         
         [shareObj.mainChatDictionary setObject:arrMain forKey:shareObj.receiverId];
     }

     
 copyMessage = [[JSQMessage alloc] initWithSenderId:@"1"
 senderDisplayName:@"Usman"
 date:[NSDate date]
 text:@"kya hal ha bhai"];
 [self.demoData.messages addObject:copyMessage];
 
 
 copyMessage = [[JSQMessage alloc] initWithSenderId:@"2"
 senderDisplayName:@"Faiz"
 date:[NSDate date]
 text:@"Hum theek hain ap sunao"];
 [self.demoData.messages addObject:copyMessage];
 
 
 copyMessage = [[JSQMessage alloc] initWithSenderId:@"3"
 senderDisplayName:@"Saqib"
 date:[NSDate date]
 text:@"Hum theek what about you !"];
 [self.demoData.messages addObject:copyMessage];
 
 [self reloadMessagesView];
 
 
 }
*/

- (void)didPressAccessoryButton:(UIButton *)sender
{
    [self.inputToolbar.contentView.textView resignFirstResponder];
    
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:NSLocalizedString(@"Media messages", nil)
                                                       delegate:self
                                              cancelButtonTitle:NSLocalizedString(@"Cancel", nil)
                                         destructiveButtonTitle:nil
                                              otherButtonTitles:NSLocalizedString(@"Send photo", nil), NSLocalizedString(@"Send location", nil), NSLocalizedString(@"Send video", nil), NSLocalizedString(@"Send audio", nil), nil];
    
    [sheet showFromToolbar:self.inputToolbar];
}

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == actionSheet.cancelButtonIndex) {
        [self.inputToolbar.contentView.textView becomeFirstResponder];
        return;
    }
    
     [JSQSystemSoundPlayer jsq_playMessageSentSound];
    
    [self finishSendingMessageAnimated:YES];
}


- (void)addPhotoMediaMessage
{
    JSQPhotoMediaItem *photoItem = [[JSQPhotoMediaItem alloc] initWithImage:[UIImage imageNamed:@"goldengate"]];
    JSQMessage *photoMessage = [JSQMessage messageWithSenderId:shareObj.selfUserPhoneNo
                                                   displayName:shareObj.selfUserName
                                                         media:photoItem];
   [self.demoData.messages addObject:photoMessage];
}


@end
