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


#import "BeintooProfileVC.h"
#import "Beintoo.h"
#import "BSignupLayouts.h"

@implementation BeintooProfileVC


@synthesize sectionScores,allScores,allContests,allScoresForContest,arrayWithScoresForAllContests,startingOptions;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil andOptions:(NSDictionary *)options{
	self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
		self.startingOptions	= options;
	}
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	
	isAFriendProfile = NO;
	if ([[self.startingOptions objectForKey:@"caller"] isEqualToString:@"friendsProfile"]) {
		isAFriendProfile = YES;
	}		 
		
	self.title = NSLocalizedStringFromTable(@"profile", @"BeintooLocalizable", @"Profile");
	
    loginVC                 = [[BeintooLoginVC alloc] initWithNibName:@"BeintooLoginVC" bundle:[NSBundle mainBundle]];
    
    UIColor *barColor		= [UIColor colorWithRed:108.0/255 green:128.0/255 blue:154.0/255 alpha:1.0];
	loginNavController      = [[UINavigationController alloc] initWithRootViewController:loginVC];
	[[loginNavController navigationBar] setTintColor:barColor];	

    
	levelTitle.text		= NSLocalizedStringFromTable(@"level",@"BeintooLocalizable",@"UserLevel");
	noScoreLabel.text	= NSLocalizedStringFromTable(@"noscoreLabel",@"BeintooLocalizable",@"You don't have any points on this app.");
	
	friendsToolbarLabel.text	= NSLocalizedStringFromTable(@"friends",@"BeintooLocalizable",@"");
	messagesToolbarLabel.text	= NSLocalizedStringFromTable(@"messages",@"BeintooLocalizable",@"");
	balanceToolbarLabel.text	= NSLocalizedStringFromTable(@"balance",@"BeintooLocalizable",@"");
    alliancesLabel.text         = NSLocalizedStringFromTable(@"alliances",@"BeintooLocalizable",@"");

    
	[profileView setTopHeight:108.0];
	[profileView setBodyHeight:450.0];
	[profileView setIsScrollView:YES];

	scrollView.contentSize          = CGSizeMake(self.view.bounds.size.width, 450);
	scrollView.backgroundColor      = [UIColor colorWithRed:108.0/255 green:128.0/255 blue:154.0/255 alpha:1];

	scoresTable.delegate		= self;
	scoresTable.rowHeight		= 25.0;
	
	messagesVC          = [BeintooMessagesVC alloc];
	newMessageVC        = [BeintooNewMessageVC alloc];
	balanceVC           = [BeintooBalanceVC alloc];
	friendActionsVC     = [[BeintooFriendActionsVC alloc] initWithNibName:@"BeintooFriendActionsVC" bundle:[NSBundle mainBundle] andOptions:nil];
    alliancesActionVC   = [[BeintooAllianceActionsVC alloc] initWithNibName:@"BeintooAllianceActionsVC" bundle:[NSBundle mainBundle] andOptions:nil];
	
	listOfContests				= [[NSMutableArray alloc]init];
	self.allScores				= [[NSDictionary alloc]init];
	self.allContests			= [[NSMutableArray alloc]init];
	self.allScoresForContest	= [[NSMutableArray alloc]init];
	feedNameLists				= [[NSMutableArray alloc]init];

	UIBarButtonItem *barCloseBtn = [[UIBarButtonItem alloc] initWithCustomView:[BeintooVC closeButton]];
	[self.navigationItem setRightBarButtonItem:barCloseBtn animated:YES];
	[barCloseBtn release];

	self.sectionScores	 = [[NSMutableArray alloc] init];
	
	_player				= [[BeintooPlayer alloc] init];
	_user				= [[BeintooUser alloc]init];
	
	[logoutButton setHighColor:[UIColor colorWithRed:156.0/255 green:168.0/255 blue:184.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(156, 2)/pow(255,2) green:pow(168, 2)/pow(255,2) blue:pow(184, 2)/pow(255,2) alpha:1]];
	[logoutButton setMediumHighColor:[UIColor colorWithRed:116.0/255 green:135.0/255 blue:159.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(116, 2)/pow(255,2) green:pow(135, 2)/pow(255,2) blue:pow(159, 2)/pow(255,2) alpha:1]];
	[logoutButton setMediumLowColor:[UIColor colorWithRed:108.0/255 green:128.0/255 blue:154.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(108, 2)/pow(255,2) green:pow(128, 2)/pow(255,2) blue:pow(154, 2)/pow(255,2) alpha:1]];
    [logoutButton setLowColor:[UIColor colorWithRed:89.0/255 green:112.0/255 blue:142.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(89, 2)/pow(255,2) green:pow(112, 2)/pow(255,2) blue:pow(142, 2)/pow(255,2) alpha:1]];
	[logoutButton setTitle:NSLocalizedStringFromTable(@"logoutBtn",@"BeintooLocalizable",@"") forState:UIControlStateNormal];
	[logoutButton setButtonTextSize:15];

	[detachButton setHighColor:[UIColor colorWithRed:156.0/255 green:168.0/255 blue:184.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(156, 2)/pow(255,2) green:pow(168, 2)/pow(255,2) blue:pow(184, 2)/pow(255,2) alpha:1]];
	[detachButton setMediumHighColor:[UIColor colorWithRed:116.0/255 green:135.0/255 blue:159.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(116, 2)/pow(255,2) green:pow(135, 2)/pow(255,2) blue:pow(159, 2)/pow(255,2) alpha:1]];
	[detachButton setMediumLowColor:[UIColor colorWithRed:108.0/255 green:128.0/255 blue:154.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(108, 2)/pow(255,2) green:pow(128, 2)/pow(255,2) blue:pow(154, 2)/pow(255,2) alpha:1]];
    [detachButton setLowColor:[UIColor colorWithRed:89.0/255 green:112.0/255 blue:142.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(89, 2)/pow(255,2) green:pow(112, 2)/pow(255,2) blue:pow(142, 2)/pow(255,2) alpha:1]];
	[detachButton setTitle:NSLocalizedStringFromTable(@"detach",@"BeintooLocalizable",@"Detach from device") forState:UIControlStateNormal];
	[detachButton setButtonTextSize:15];
	
	[newMessageButton setHighColor:[UIColor colorWithRed:156.0/255 green:168.0/255 blue:184.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(156, 2)/pow(255,2) green:pow(168, 2)/pow(255,2) blue:pow(184, 2)/pow(255,2) alpha:1]];
	[newMessageButton setMediumHighColor:[UIColor colorWithRed:116.0/255 green:135.0/255 blue:159.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(116, 2)/pow(255,2) green:pow(135, 2)/pow(255,2) blue:pow(159, 2)/pow(255,2) alpha:1]];
	[newMessageButton setMediumLowColor:[UIColor colorWithRed:108.0/255 green:128.0/255 blue:154.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(108, 2)/pow(255,2) green:pow(128, 2)/pow(255,2) blue:pow(154, 2)/pow(255,2) alpha:1]];
    [newMessageButton setLowColor:[UIColor colorWithRed:89.0/255 green:112.0/255 blue:142.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(89, 2)/pow(255,2) green:pow(112, 2)/pow(255,2) blue:pow(142, 2)/pow(255,2) alpha:1]];
	[newMessageButton setTitle:NSLocalizedStringFromTable(@"sendMessage",@"BeintooLocalizable",@"Send message") forState:UIControlStateNormal];
	[newMessageButton setButtonTextSize:15];
	
	// Toolbar
	[toolbarView setGradientType:GRADIENT_TOOLBAR];
}

- (void)viewWillAppear:(BOOL)animated{
    if ([BeintooDevice isiPad]) {
        [self setContentSizeForViewInPopover:CGSizeMake(320, 415)];
    }
    _player.delegate	= self;
	_user.delegate		= self;

    profileView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    if (![BeintooDevice isiPad]) {
        if ([Beintoo appOrientation] == UIInterfaceOrientationLandscapeRight || 
            [Beintoo appOrientation] == UIInterfaceOrientationLandscapeLeft) {
            profileView.frame = CGRectMake(0, 0, 480,450);
        }
        else{
            profileView.frame = CGRectMake(0, 0, 320,440);
        }
        profileView.clipsToBounds = YES;
    }   
    
    userImg.contentMode = UIViewContentModeScaleAspectFit;
    userImg.image       = nil;
    isAlreadyLogging    = NO;
    
    unreadMessagesLabel.text	= [NSString stringWithFormat:@"%d",[BeintooMessage unreadMessagesCount]];
    [unreadMessagesLabel setHidden:YES];
    
    [noScoreLabel setHidden:YES];
    
    
    if(![Beintoo isUserLogged]){
        [detachButton setHidden:YES];
        [logoutButton setHidden:YES];
        [newMessageButton setHidden:YES];
        [toolbarView setHidden:NO];
        
        [nickname setHidden:YES];
        [level setHidden:YES];
        [beDollars setHidden:YES];
        [levelTitle setHidden:YES];
        [bedollarsTitle setHidden:YES];
                        
        if (signupViewForPlayers != nil) {
            signupViewForPlayers = nil;
            [signupViewForPlayers release];
        }
        [[self.view viewWithTag:1111] removeFromSuperview];
        signupViewForPlayers = [[BSignupLayouts getBeintooSignupViewForProfileWithFrame:CGRectMake(100, 10 , 220, 90) andButtonActionSelector:@selector(tryBeintoo) fromSender:self] retain];
        signupViewForPlayers.tag = 1111;
        [self.view addSubview:signupViewForPlayers];
        
        [BLoadingView startActivity:self.view];
        [_player getAllScores];

    }
    else if (isAFriendProfile) {
        [detachButton setHidden:YES];
        [logoutButton setHidden:YES];
        [newMessageButton setHidden:NO];
        [toolbarView setHidden:YES];

        [nickname setHidden:NO];
        [level setHidden:NO];
        [beDollars setHidden:NO];
        [levelTitle setHidden:NO];
        [bedollarsTitle setHidden:NO];
        
        scoresTable.center = CGPointMake(scoresTable.center.x, scoresTable.center.y-56);
        [BLoadingView startActivity:self.view];
        [_player getPlayerByUserID:[self.startingOptions objectForKey:@"friendUserID"]];
    }
    else { // user profile
        [detachButton setHidden:NO];
        [logoutButton setHidden:NO];
        [newMessageButton setHidden:YES];
        [toolbarView setHidden:NO];

        [nickname setHidden:NO];
        [level setHidden:NO];
        [beDollars setHidden:NO];
        [levelTitle setHidden:NO];
        [bedollarsTitle setHidden:NO];
        
        [BLoadingView startActivity:self.view];
        [_player getAllScores];
        if ([BeintooMessage unreadMessagesCount]>0) {
            [unreadMessagesLabel setHidden:NO];
        }
    }
}
										
#pragma mark -
#pragma mark delegates
- (void)player:(BeintooPlayer *)player didGetAllScores:(NSDictionary *)result{
	
    self.allScores = result; 
	if (self.allScores == nil) {
		[noScoreLabel setHidden:NO];
	}
	
	@try {
		NSDictionary *currentUser = [Beintoo getUserIfLogged];	
        if (!currentUser) {
            userImg.contentMode = UIViewContentModeCenter;
            userImg.image       = [UIImage imageNamed:@"beintoo_profile.png"];
        }
        else{
            NSData *imgData = [NSData dataWithContentsOfURL:[NSURL URLWithString:[currentUser objectForKey:@"userimg"]]];
            [userImg setImage:[UIImage imageWithData:imgData]];
        }
		nickname.text  = [currentUser objectForKey:@"nickname"];
		level.text	   = [self translateLevel:[currentUser objectForKey:@"level"]];
		beDollars.text = [NSString stringWithFormat:@"%.2f",[[currentUser objectForKey:@"bedollars"]floatValue]];
		
		[self.allContests removeAllObjects];
		[self.allScoresForContest removeAllObjects];
		
		for (id theKey in allScores) {
			NSDictionary *contestValues = [[allScores objectForKey:theKey]objectForKey:@"contest"];
			if ( ([[contestValues objectForKey:@"isPublic"] intValue]==1) || ([[contestValues objectForKey:@"codeID"] isEqualToString:@"default"]) ) {
				[self.allContests addObject:theKey];
			}
		}
	}
	@catch (NSException * e) {
	}
	
	for (int i=0; i<[self.allContests count]; i++) {
		@try {
			NSMutableArray *scores = [[NSMutableArray alloc]init];
			NSString *totalScore = [[self.allScores objectForKey:[self.allContests objectAtIndex:i]]objectForKey:@"balance"];
			NSString *bestScore = [[self.allScores objectForKey:[self.allContests objectAtIndex:i]]objectForKey:@"bestscore"];
			NSString *lastScore = [[self.allScores objectForKey:[self.allContests objectAtIndex:i]]objectForKey:@"lastscore"];
			
			[scores addObject:totalScore];
			[scores addObject:bestScore];
			[scores addObject:lastScore];
			
            NSLog(@"scores %@", scores);
            
			[self.allScoresForContest addObject:scores];
			[scores release];
		}
		@catch (NSException * e) {
			NSLog(@"BeintooException: %@ \n for object: %@",e,[self.allContests objectAtIndex:i]);
		}
	}
	[scoresTable reloadData];
	[BLoadingView stopActivity];
}

- (void)didgetPlayerByUser:(NSDictionary *)result{
	@try {
		
		self.allScores = [result objectForKey:@"playerScore"];
		
		if (self.allScores == nil) {
			[noScoreLabel setHidden:NO];
		}
		
		NSDictionary *currentUser = [result objectForKey:@"user"];	
		NSData *imgData = [NSData dataWithContentsOfURL:[NSURL URLWithString:[currentUser objectForKey:@"userimg"]]];
		[userImg setImage:[UIImage imageWithData:imgData]];
		nickname.text  = [currentUser objectForKey:@"nickname"];
		level.text	   = [self translateLevel:[currentUser objectForKey:@"level"]];
		beDollars.text = [NSString stringWithFormat:@"%.2f",[[currentUser objectForKey:@"bedollars"]floatValue]];
		
		[self.allContests removeAllObjects];
		[self.allScoresForContest removeAllObjects];
		
		for (id theKey in allScores) {
			NSDictionary *contestValues = [[allScores objectForKey:theKey]objectForKey:@"contest"];
			if ( ([[contestValues objectForKey:@"isPublic"] intValue]==1) || ([[contestValues objectForKey:@"codeID"] isEqualToString:@"default"]) ) {
				[self.allContests addObject:theKey];
			}
		}
	}
	@catch (NSException * e) {
		NSLog(@"BeintooException - Profile: %@",e);
	}
	
	for (int i=0; i<[self.allContests count]; i++) {
		@try {
			NSMutableArray *scores = [[NSMutableArray alloc]init];
			NSString *totalScore = [[self.allScores objectForKey:[self.allContests objectAtIndex:i]]objectForKey:@"balance"];
			NSString *bestScore = [[self.allScores objectForKey:[self.allContests objectAtIndex:i]]objectForKey:@"bestscore"];
			NSString *lastScore = [[self.allScores objectForKey:[self.allContests objectAtIndex:i]]objectForKey:@"lastscore"];
			
			[scores addObject:totalScore];
			[scores addObject:bestScore];
			[scores addObject:lastScore];
			
			[self.allScoresForContest addObject:scores];
			[scores release];
		}
		@catch (NSException * e) {
			NSLog(@"BeintooException - Profile: %@ \n for object: %@",e,[self.allContests objectAtIndex:i]);
		}
	}
	[scoresTable reloadData];
	[BLoadingView stopActivity];
}

#pragma mark -
#pragma mark IBActions

- (IBAction)logout{
	UIActionSheet	*popup = [[UIActionSheet alloc] initWithTitle:NSLocalizedStringFromTable(@"logout",@"BeintooLocalizable",@"Are you sure?") 
													   delegate:self 
											  cancelButtonTitle:nil 
										 destructiveButtonTitle:NSLocalizedStringFromTable(@"yes",@"BeintooLocalizable",@"")
											  otherButtonTitles:@"No", nil ];
	
	popup.actionSheetStyle = UIActionSheetStyleDefault;
	[popup showInView:[self.view superview]];
	popup.tag = POPUP_LOGOUT;
	[popup release];	
}

- (IBAction)detachUserFromDevice{	
	UIActionSheet	*popup = [[UIActionSheet alloc] initWithTitle:NSLocalizedStringFromTable(@"detachFromDevice",@"BeintooLocalizable",@"Are you sure?") 
													   delegate:self 
											  cancelButtonTitle:nil 
										 destructiveButtonTitle:NSLocalizedStringFromTable(@"yes",@"BeintooLocalizable",@"")
											  otherButtonTitles:@"No", nil ];
	
	popup.actionSheetStyle = UIActionSheetStyleDefault;
	[popup showInView:[self.view superview]];
	popup.tag = POPUP_DETACH;
	[popup release];
}

- (IBAction)openBalance{	
    if([Beintoo isUserLogged]){
        [balanceVC initWithNibName:@"BeintooBalanceVC" bundle:[NSBundle mainBundle] andOptions:nil];
        [self.navigationController pushViewController:balanceVC animated:YES];
    }else{
        UIView *featureView = [[BSignupLayouts getBeintooDashboardViewForLockedFeatureProfileWithFrame:CGRectMake(30, 70, 290, 220) andButtonActionSelector:@selector(tryBeintoo) fromSender:self] retain];
        featureView.tag = 3333;
        [self.view addSubview:featureView];
        [self.view bringSubviewToFront:featureView];
        [featureView release];
    }
}	 

- (IBAction)openMessages{	
    if([Beintoo isUserLogged]){
        [messagesVC initWithNibName:@"BeintooMessagesVC" bundle:[NSBundle mainBundle] andOptions:nil];
        [self.navigationController pushViewController:messagesVC animated:YES];
    }else{
        UIView *featureView = [[BSignupLayouts getBeintooDashboardViewForLockedFeatureProfileWithFrame:CGRectMake(30, 70, 290, 220) andButtonActionSelector:@selector(tryBeintoo) fromSender:self] retain];
        featureView.tag = 3333;
        [self.view addSubview:featureView];
        [self.view bringSubviewToFront:featureView];
        [featureView release];    }
}

- (IBAction)openFriends{	
    if([Beintoo isUserLogged]){
        [self.navigationController pushViewController:friendActionsVC animated:YES];
    }else{
        UIView *featureView = [[BSignupLayouts getBeintooDashboardViewForLockedFeatureProfileWithFrame:CGRectMake(30, 70, 290, 220) andButtonActionSelector:@selector(tryBeintoo) fromSender:self] retain];
        featureView.tag = 3333;
        [self.view addSubview:featureView];
        [self.view bringSubviewToFront:featureView];
        [featureView release];    }    
}

- (IBAction)openAlliances{	
    if([Beintoo isUserLogged]){
        [self.navigationController pushViewController:alliancesActionVC animated:YES];
    }else{
        UIView *featureView = [[BSignupLayouts getBeintooDashboardViewForLockedFeatureProfileWithFrame:CGRectMake(30, 70, 290, 220) andButtonActionSelector:@selector(tryBeintoo) fromSender:self] retain];
        featureView.tag = 3333;
        [self.view addSubview:featureView];
        [self.view bringSubviewToFront:featureView];
        [featureView release];
    } 
}

- (void)dismissFeatureSignupView{
    UIView *featureView = [self.view viewWithTag:3333];
    [featureView removeFromSuperview];
}

// Friend profile
- (IBAction)sendMessage{
	NSDictionary *replyOptions	= [NSDictionary dictionaryWithObjectsAndKeys:[self.startingOptions objectForKey:@"friendNickname"],@"from",
										[self.startingOptions objectForKey:@"friendUserID"],@"fromUserID",nil];
	NSDictionary *newMsgOptions	= [NSDictionary dictionaryWithObjectsAndKeys:replyOptions,@"replyOptions",nil];
	[newMessageVC initWithNibName:@"BeintooNewMessageVC" bundle:[NSBundle mainBundle] andOptions:newMsgOptions];
	[self.navigationController pushViewController:newMessageVC animated:YES];
}

#pragma mark -
#pragma mark UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	
	if (actionSheet.tag == POPUP_DETACH){
		if(buttonIndex == 0){
			[_user removeUDIDConnectionFromUserID:[[Beintoo getUserIfLogged] objectForKey:@"id"]];
			[self logoutUser];
		}
	}
	
	if (actionSheet.tag == POPUP_LOGOUT){
		if(buttonIndex == 0)
			[self logoutUser];
	}
}
						   
#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.allContests count];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	//NSArray *scores = [allScores objectForKey:[self.allContests objectAtIndex:section]];
	//return [scores count]-1;
	return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
	
	BTableViewCell *cell = (BTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil || YES) {
        cell = [[[BTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier andGradientType:GRADIENT_CELL_BODY] autorelease];
    }
	
	@try {
		NSArray *scoresForThisSection = [self.allScoresForContest objectAtIndex:indexPath.section];
				
		
		UILabel *totLabel               = [[UILabel alloc] initWithFrame:CGRectMake(10, 2, 95, 20)];
		UILabel *bestLabel              = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width*0.35, 2, 95, 20)];
		UILabel *lastLabel              = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width*0.68, 2, 95, 20)];
        
        UIColor *labelBGColor           = [UIColor clearColor];
		totLabel.backgroundColor		= labelBGColor;
		bestLabel.backgroundColor		= labelBGColor;
		lastLabel.backgroundColor		= labelBGColor;
		
        UIFont *labelFont               = [UIFont systemFontOfSize:13];
        UIColor *labelTextColor         = [UIColor colorWithWhite:0 alpha:0.7];
        
		totLabel.font                   = labelFont;
		totLabel.textColor              = labelTextColor;
		bestLabel.font                  = labelFont;
		bestLabel.textColor             = labelTextColor;
		lastLabel.font                  = labelFont;
		lastLabel.textColor             = labelTextColor;
		
		totLabel.text                   = [NSString stringWithFormat:@"%@ %@", NSLocalizedStringFromTable(@"totalScore", @"BeintooLocalizable", nil), [scoresForThisSection objectAtIndex:0]];
		bestLabel.text                  = [NSString stringWithFormat:@"%@ %@", NSLocalizedStringFromTable(@"bestScore", @"BeintooLocalizable", nil), [scoresForThisSection objectAtIndex:1]];
		lastLabel.text                  = [NSString stringWithFormat:@"%@ %@", NSLocalizedStringFromTable(@"lastScore", @"BeintooLocalizable", nil),[scoresForThisSection objectAtIndex:2]];
        
        totLabel.adjustsFontSizeToFitWidth  = YES;
        bestLabel.adjustsFontSizeToFitWidth = YES;
        lastLabel.adjustsFontSizeToFitWidth = YES;
        
		[cell addSubview:totLabel];
		[cell addSubview:bestLabel];
		[cell addSubview:lastLabel];
		
		[totLabel release];
		[bestLabel release];
		[lastLabel release];
		
	}
	@catch (NSException * e) {
		//[_player logException:[NSString stringWithFormat:@"STACK: %@\n\nException: %@",[NSThread callStackSymbols],e]];
	}
    return cell;
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
	BGradientView *gradientView = [[[BGradientView alloc] initWithGradientType:GRADIENT_HEADER]autorelease];
	gradientView.frame = CGRectMake(0, 0, tableView.bounds.size.width, 40);

	UILabel *contestNameLbl			= [[UILabel alloc]initWithFrame:CGRectMake(10,2,300,20)];
	contestNameLbl.backgroundColor	= [UIColor clearColor];
	contestNameLbl.textColor		= [UIColor blackColor];
	contestNameLbl.font				= [UIFont systemFontOfSize:13];
	
	UILabel *feedNameLbl		= [[UILabel alloc]initWithFrame:CGRectMake(10,2,300,50)];
	feedNameLbl.backgroundColor = [UIColor clearColor];
	feedNameLbl.textColor	    = [UIColor blackColor];
	feedNameLbl.font		    = [UIFont systemFontOfSize:13];
	
	
	NSDictionary *contest = [[self.allScores objectForKey:[self.allContests objectAtIndex:section]] objectForKey:@"contest"];
	NSString *feedName = [contest objectForKey:@"feed"];
	
	/*if ([[self.allContests objectAtIndex:section] isEqualToString:@"default"]) {
		tempLabel.text = NSLocalizedStringFromTable(@"pointsOnThisApp",@"BeintooLocalizable",@"Points on this app");
	}
	else
		tempLabel.text = [NSString stringWithFormat:@"%@ %@:",NSLocalizedStringFromTable(@"pointsOn",@"BeintooLocalizable",@"Points on"),[self.allContests objectAtIndex:section]];
	*/
	
	contestNameLbl.text = [contest objectForKey:@"name"];
	feedNameLbl.text	= feedName;
	[gradientView addSubview:contestNameLbl];
	[gradientView addSubview:feedNameLbl];
	[contestNameLbl release];
	[feedNameLbl release];
	return gradientView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
	return 40.0;
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath{
	return nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return NO;
}


- (NSString *)translateLevel:(NSNumber *)levelNumber{	
	if (levelNumber.intValue==1) {return NSLocalizedStringFromTable(@"novice",@"BeintooLocalizable",@"Novice");}
	else if(levelNumber.intValue==2){return NSLocalizedStringFromTable(@"learner",@"BeintooLocalizable",@"Learner");}
	else if(levelNumber.intValue==3){return NSLocalizedStringFromTable(@"passionate",@"BeintooLocalizable",@"Passionate");}
	else if(levelNumber.intValue==4){return NSLocalizedStringFromTable(@"winner",@"BeintooLocalizable",@"Winner");}
	else if(levelNumber.intValue==5){return NSLocalizedStringFromTable(@"master",@"BeintooLocalizable",@"Master");}
	else
		return @"";
}

- (void)logoutUser{
	[Beintoo setUserLogged:NO];
	[Beintoo dismissBeintoo];
}

- (void)tryBeintoo{	
    
    if (!isAlreadyLogging) {
        isAlreadyLogging = YES;
        @try {
            if ([BeintooNetwork connectedToNetwork]) {
                [BLoadingView startActivity:self.view];
                [loginNavController popToRootViewControllerAnimated:NO];                
            }
            [_user getUserByUDID];
        }
        @catch (NSException * e) {
        }
    }
}

- (void)didGetUserByUDID:(NSMutableArray *)result{
    @synchronized(self){
        [Beintoo setLastLoggedPlayers:[(NSArray *)result retain]];        
        [BLoadingView stopActivity]; 
        if([BeintooDevice isiPad]){ // --- iPad, we need to show the "Login Popover"
            [Beintoo launchIpadLogin];
        }else {
            [self presentModalViewController:loginNavController animated:YES];
        }
        isAlreadyLogging = NO;
    }	
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
	
    [super viewDidUnload];
}

- (void)viewWillDisappear:(BOOL)animated {
    _player.delegate  = nil;
    _user.delegate    = nil;

    @try {
		[BLoadingView stopActivity];
	}
	@catch (NSException * e) {
	}
}

- (void)viewDidDisappear:(BOOL)animated {
	if (isAFriendProfile) {
		scoresTable.center = CGPointMake(scoresTable.center.x, scoresTable.center.y+56);
	}
    
    @try {        
        UIView *featureView = [self.view viewWithTag:3333];
        UIView *signupView  = [self.view viewWithTag:1111];
        [featureView removeFromSuperview];
        [signupView removeFromSuperview];
	}
	@catch (NSException * e) {
    }
}


- (void)dealloc {
	[listOfContests release];
	[self.allScores release];
	[self.sectionScores release];
	[self.allContests release];
	[self.allScoresForContest release];
	[feedNameLists release];
	[_player release];
	[_user release];
	[messagesVC release];
	[newMessageVC release];
	[friendActionsVC release];
    [signupViewForPlayers release];
    [loginVC release];
    [super dealloc];
}

@end
