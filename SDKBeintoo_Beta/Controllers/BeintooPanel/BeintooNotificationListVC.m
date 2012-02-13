/*******************************************************************************
 * Copyright 2011 Beintoo - author fmessina@beintoo.com
 * 
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 * 
 *   http://www.apache.org/licenses/LICENSE-2.0
 * 
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 ******************************************************************************/

#import "BeintooNotificationListVC.h"
#import "Beintoo.h"


@implementation BeintooNotificationListVC

@synthesize notificationTable, notificationArrayList, notificationImages, selectedNotification, startingOptions;

- (void)viewDidLoad {
    [super viewDidLoad];
    
	self.title      = NSLocalizedStringFromTable(@"notifications",@"BeintooLocalizable",@"");
    
	mainView        = [[BView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
    [mainView setTopHeight:0];
	[mainView setBodyHeight:422];
    
    self.view = mainView;
	
    notificationTable = [[BTableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, mainView.frame.size.height)];
    notificationTable.autoresizingMask  = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	self.notificationTable.delegate     = self;
    self.notificationTable.dataSource   = self;
	self.notificationTable.rowHeight	= 90.0;	
	
    notificationArrayList = [[NSMutableArray alloc] init];
	notificationImages    = [[NSMutableArray alloc] init];
    
    UIBarButtonItem *barCloseBtn = [[UIBarButtonItem alloc] initWithCustomView:[self closeButton]];
	[self.navigationItem setRightBarButtonItem:barCloseBtn animated:YES];
	[barCloseBtn release];	
    
    _notification           = [[BeintooNotification alloc] init];
    _notification.delegate  = self;
    
    
    // ViewControllers initialization
    messagesVC              = [[BeintooMessagesVC alloc] initWithNibName:@"BeintooMessagesVC" bundle:[NSBundle mainBundle] andOptions:nil];
    friendRequestVC         = [[BeintooFriendRequestsVC alloc] initWithNibName:@"BeintooFriendRequestsVC" bundle:[NSBundle mainBundle] andOptions:nil];
    
    walletVC                = [[BeintooWalletVC alloc]initWithNibName:@"BeintooWalletVC" bundle:[NSBundle mainBundle]];
    challengesVC            = [[BeintooChallengesVC alloc]initWithNibName:@"BeintooChallengesVC" bundle:[NSBundle mainBundle]];
    achievementVC           = [[BeintooAchievementsVC alloc]initWithNibName:@"BeintooAchievementsVC" bundle:[NSBundle mainBundle]];
    pendigAllianceReqVC     = [BeintooAlliancePendingVC alloc];
    viewAllianceVC          = [[BeintooViewAllianceVC alloc] initWithNibName:@"BeintooViewAllianceVC" bundle:[NSBundle mainBundle] andOptions:nil];
    tipsAndForumVC          = [BeintooBrowserVC alloc];
	
    noNotificationLabel                 = [[UILabel alloc] initWithFrame:CGRectMake(20, 60, 280, 30)];
    noNotificationLabel.backgroundColor = [UIColor clearColor];
	noNotificationLabel.text            = [NSString stringWithFormat:NSLocalizedStringFromTable(@"messagenotificationp",@"BeintooLocalizable",@""),0];
    noNotificationLabel.textAlignment   = UITextAlignmentCenter;
    noNotificationLabel.autoresizingMask= UIViewAutoresizingFlexibleWidth;
    noNotificationLabel.font            = [UIFont boldSystemFontOfSize:15];
    noNotificationLabel.textColor       = [UIColor colorWithWhite:0 alpha:0.8];
        
    [self.view addSubview:notificationTable];
    [self.view addSubview:noNotificationLabel];
    
    [notificationTable release];
    [noNotificationLabel release];
    
    
}

- (void)viewWillAppear:(BOOL)animated{
    if ([BeintooDevice isiPad])
        [self setContentSizeForViewInPopover:CGSizeMake(320, 415)];
    

    [BLoadingView startActivity:self.view];
    [_notification getNotificationListWithStart:0 andRows:50];	
    [noNotificationLabel setHidden:YES];
}

- (void)didGetNotificationListWithResult:(NSArray *)result{
    	
    [notificationArrayList removeAllObjects];
	[notificationImages removeAllObjects];

	[noNotificationLabel setHidden:YES];

	if ([result count] == 0) {
		[noNotificationLabel setHidden:NO];
	}
    //NSLog(@"----> result <---- %@", result);
    if ([result isKindOfClass:[NSArray class]]) {
		for (int i=0; i<[result count]; i++) {
			@try {
				NSMutableDictionary *notificationEntry = [[NSMutableDictionary alloc]init];
				NSString *creationDate	 = [[result objectAtIndex:i] objectForKey:@"creationdate"];
				NSString *image_url	 = [[result objectAtIndex:i] objectForKey:@"image_url"];
				NSString *message = [[result objectAtIndex:i] objectForKey:@"localizedMessage"];
                NSString *status = [[result objectAtIndex:i] objectForKey:@"status"];
                NSString *type = [[result objectAtIndex:i] objectForKey:@"type"];
                NSString *messageId = [[result objectAtIndex:i] objectForKey:@"id"];
				
				BImageDownload *download = [[[BImageDownload alloc] init] autorelease];
				download.delegate = self;
				download.urlString = [[result objectAtIndex:i] objectForKey:@"image_url"];
				
				[notificationEntry setObject:creationDate forKey:@"creationDate"];
				[notificationEntry setObject:image_url forKey:@"image_url"];
				[notificationEntry setObject:message forKey:@"localizedMessage"];
                [notificationEntry setObject:status forKey:@"status"];
                [notificationEntry setObject:type forKey:@"type"];
                [notificationEntry setObject:messageId forKey:@"messageId"];
				[notificationArrayList addObject:notificationEntry];
				[notificationImages addObject:download];
				[notificationEntry release];
			}
			@catch (NSException *e) {
				NSLog(@"BeintooException - FriendList: %@ \n for object: %@",e,[result objectAtIndex:i]);
			}
		}
	}
    
    [BLoadingView stopActivity];
	[notificationTable reloadData];

    if ([self.notificationArrayList count] > 0) {
        NSDictionary *lastNotification = [self.notificationArrayList objectAtIndex:0];
        if ([[lastNotification objectForKey:@"status"] isEqualToString:@"UNREAD"]) {
            NSString *notificationID = [lastNotification objectForKey:@"messageId"];
            [_notification setAllNotificationReadUpToNotification:notificationID];
        }
    }
}

- (void)didSetNotificationReadWithResult:(NSArray *)result{
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    NSString *textToMeasure = [[self.notificationArrayList objectAtIndex:indexPath.row] objectForKey:@"localizedMessage"];
    CGSize maximumLabelSize = CGSizeMake(200,9999);
    CGSize expectedLabelSize = [textToMeasure sizeWithFont:[UIFont systemFontOfSize:13] constrainedToSize:maximumLabelSize lineBreakMode:UILineBreakModeWordWrap];

    if (expectedLabelSize.height < 30) {
        expectedLabelSize.height = 32;
    }
    
    return expectedLabelSize.height + 42;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [notificationArrayList count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    NSString *notificationStatus    = [[self.notificationArrayList objectAtIndex:indexPath.row]objectForKey:@"status"];
   	int _gradientType = ([notificationStatus isEqualToString:@"UNREAD"]) ? GRADIENT_NOTIF_UNDREAD_CELL : GRADIENT_CELL_BODY;
	
	BTableViewCell *cell = (BTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil || TRUE) {
        cell = [[[BTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier andGradientType:_gradientType] autorelease];
    }
    
    NSString *textToMeasure     = [[self.notificationArrayList objectAtIndex:indexPath.row] objectForKey:@"localizedMessage"];
    CGSize maximumLabelSize     = CGSizeMake(200,9999);
    CGSize expectedLabelSize    = [textToMeasure sizeWithFont:[UIFont systemFontOfSize:13] constrainedToSize:maximumLabelSize lineBreakMode:UILineBreakModeWordWrap];
    
    UIImageView *imageView      = [[UIImageView alloc] initWithFrame:CGRectMake(10, 12, 50, 50)];
	
	BImageDownload *download    = [self.notificationImages objectAtIndex:indexPath.row];
	UIImage *cellImage          = download.image;
	imageView.image             = cellImage;
    
    [cell addSubview:imageView];
    [imageView release];
    
    UILabel *messageLabel           = [[UILabel alloc] initWithFrame:CGRectMake(70, 10, 200, expectedLabelSize.height)];
	messageLabel.text               = [[self.notificationArrayList objectAtIndex:indexPath.row] objectForKey:@"localizedMessage"];
	messageLabel.font               = [UIFont systemFontOfSize:13];
    messageLabel.textColor          = [UIColor colorWithWhite:0 alpha:1.0];
    if ([[[self.notificationArrayList objectAtIndex:indexPath.row] objectForKey:@"status"] isEqualToString:@"UNREAD"]) {
        messageLabel.font           = [UIFont boldSystemFontOfSize:12];
        messageLabel.textColor      = [UIColor colorWithWhite:0 alpha:0.9];
    }
    messageLabel.numberOfLines      = 0;
    messageLabel.autoresizingMask   = UIViewAutoresizingFlexibleWidth;
    messageLabel.backgroundColor    = [UIColor clearColor];
    
    [cell addSubview:messageLabel];
    [messageLabel release];
    
    UILabel *notificationDate           = [[UILabel alloc] initWithFrame:CGRectMake(70, expectedLabelSize.height+11, 200, 15)];
	notificationDate.text               = [[self.notificationArrayList objectAtIndex:indexPath.row] objectForKey:@"creationDate"];
	notificationDate.font               = [UIFont systemFontOfSize:11];
    notificationDate.backgroundColor    = [UIColor clearColor];
    notificationDate.autoresizingMask   = UIViewAutoresizingFlexibleWidth;
    
    [cell addSubview:notificationDate];
    [notificationDate release];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.selectedNotification = [self.notificationArrayList objectAtIndex:indexPath.row];
	[self.notificationTable deselectRowAtIndexPath:[self.notificationTable indexPathForSelectedRow] animated:YES];	
    
    NSString *notificationType  = [self.selectedNotification objectForKey:@"type"];
    
    if ([notificationType isEqualToString:@"FRIENDSHIP_GOT"]) {
        // Friendship request to be accepted
        [self.navigationController pushViewController:friendRequestVC animated:YES];
    }
    else if ([notificationType isEqualToString:@"FRIENDSHIP_ACCEPTED"]) {
        // Friendship request has been accepted - do nothing
    }
    else if ([notificationType isEqualToString:@"MESSAGE_NEW"]) {
        // New message to read
        [self.navigationController pushViewController:messagesVC animated:YES];
    }
    else if([notificationType isEqualToString:@"CHALLENGE_INVITED"] || [notificationType isEqualToString:@"CHALLENGE_ACCEPTED"] 
             || [notificationType isEqualToString:@"CHALLENGE_WON"] || [notificationType isEqualToString:@"CHALLENGE_LOST"]) {
        
        [self.navigationController pushViewController:challengesVC animated:YES];
    }
    else if ([notificationType isEqualToString:@"MISSION_COMPLETED"]) {
        // Do Nothing
    }
    else if ([notificationType isEqualToString:@"ALLIANCE_ACCEPTED"]) {
        // User has been accepted on alliance
        [self.navigationController pushViewController:viewAllianceVC animated:YES];
    }
    else if ([notificationType isEqualToString:@"ALLIANCE_ADMIN_PENDING"]) {
        // User alliance has to confirm new members
        NSDictionary *pendingOptions = [NSDictionary dictionaryWithObjectsAndKeys:[BeintooAlliance userAllianceID],@"allianceID",[Beintoo getUserID],@"allianceAdminID", nil];
        
        [pendigAllianceReqVC initWithNibName:@"BeintooAlliancePendingVC" bundle:[NSBundle mainBundle] andOptions:pendingOptions];
        [self.navigationController pushViewController:pendigAllianceReqVC animated:YES];
    }
    else if ([notificationType isEqualToString:@"VGOOD_ASSIGNED"] || [notificationType isEqualToString:@"VGOOD_GIFTED"])  {
        // Vgood received
        [self.navigationController pushViewController:walletVC animated:YES];
    }
    
    else if ([notificationType isEqualToString:@"FORUM_REPLIED"]) {
        // --------------- forum&tips
        NSString *tipsUrl = [NSString stringWithFormat:@"http://appsforum.beintoo.com/?apikey=%@&userExt=%@#main",
                             [Beintoo getApiKey],[Beintoo getUserID]];
        [tipsAndForumVC initWithNibName:@"BeintooBrowserVC" bundle:[NSBundle mainBundle] urlToOpen:nil];
        [tipsAndForumVC setUrlToOpen:tipsUrl];

        [self.navigationController pushViewController:tipsAndForumVC animated:YES];
    }
    else if ([notificationType isEqualToString:@"ACHIEVEMENT_UNLOCKED"]) {
        [self.navigationController pushViewController:achievementVC animated:YES];
    }
    else{
        // If the notification is not one of the standard case, we open a webview with an url received on the notification (if received)
        if([self.selectedNotification objectForKey:@"url"] != nil){
            NSString *tipsUrl = [self.selectedNotification objectForKey:@"url"];
            [tipsAndForumVC initWithNibName:@"BeintooBrowserVC" bundle:[NSBundle mainBundle] urlToOpen:nil];
            [tipsAndForumVC setUrlToOpen:tipsUrl];
            
            [self.navigationController pushViewController:tipsAndForumVC animated:YES];
        }
    }

    // ----- We verify if the message is unread and if yes mark it as read (on the server)
    NSString *status            = [self.selectedNotification objectForKey:@"status"];
    if ([status isEqualToString:@"UNREAD"]){
        [[self.notificationArrayList objectAtIndex:indexPath.row] setObject:@"READ" forKey:@"status"];
        [notificationTable reloadData];
    }
}

#pragma mark -
#pragma mark BImageDownload Delegate Methods

- (void)bImageDownloadDidFinishDownloading:(BImageDownload *)download{
    NSUInteger index = [self.notificationImages indexOfObject:download]; 
    NSUInteger indices[] = {0, index};
    NSIndexPath *path = [[NSIndexPath alloc] initWithIndexes:indices length:2];
    [notificationTable reloadRowsAtIndexPaths:[NSArray arrayWithObject:path] withRowAnimation:UITableViewRowAnimationNone];
    [path release];
    download.delegate = nil;
}
- (void)bImageDownload:(BImageDownload *)download didFailWithError:(NSError *)error{
    NSLog(@"Beintoo - Image Loading Error: %@", [error localizedDescription]);
}

#pragma mark - Close Notification
-(void)closeBeintoo{
	if([BeintooDevice isiPad]){
		//[Beintoo dismissIpadLogin];
	}else {
		[self dismissModalViewControllerAnimated:YES];
	}
}

- (UIButton *)closeButton{
	UIImage *closeImg = [UIImage imageNamed:@"bar_close.png"];
	UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
	[closeBtn setImage:closeImg forState:UIControlStateNormal];
	closeBtn.frame = CGRectMake(0,0, closeImg.size.width+7, closeImg.size.height);
	[closeBtn addTarget:self action:@selector(closeBeintoo) forControlEvents:UIControlEventTouchUpInside];
	return closeBtn;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return (interfaceOrientation == [Beintoo appOrientation]);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
    [super viewDidUnload];
}

- (void)viewWillDisappear:(BOOL)animated {
    @try {
		[BLoadingView stopActivity];
	}
	@catch (NSException * e) {
	}
}

- (void)viewDidDisappear:(BOOL)animated{
}

- (void)dealloc {
    [pendigAllianceReqVC release];
    [viewAllianceVC release];
    [messagesVC release];
    [friendRequestVC release];
    [walletVC release];
    [challengesVC release];
    [achievementVC release];
    [tipsAndForumVC release];
	[_notification release];
	[notificationArrayList release];
	[notificationImages release];
    [noNotificationLabel release];
	[super dealloc];
}


@end
