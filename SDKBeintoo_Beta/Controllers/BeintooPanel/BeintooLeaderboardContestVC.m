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

#import "BeintooLeaderboardContestVC.h"
#import "BeintooLoginVC.h"
#import "Beintoo.h"

@implementation BeintooLeaderboardContestVC

@synthesize segControl,players,leaderboardEntries,leaderboardImages,selectedPlayer;

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.title = NSLocalizedStringFromTable(@"leaderboard",@"BeintooLocalizable",@"Leaderboard");

	[leaderboardContestView setTopHeight:60];
	[leaderboardContestView setBodyHeight:367];
	
    noScoresLabel.text = NSLocalizedStringFromTable(@"errorMessage",@"BeintooLocalizable",@"All");

	[segControl setTitle:NSLocalizedStringFromTable(@"all",@"BeintooLocalizable",@"All") forSegmentAtIndex:0];
	[segControl setTitle:NSLocalizedStringFromTable(@"friends",@"BeintooLocalizable",@"Friends") forSegmentAtIndex:1];
    [segControl setTitle:NSLocalizedStringFromTable(@"tobeat",@"BeintooLocalizable",@"Friends") forSegmentAtIndex:2];
   
    segControl.tintColor = [UIColor colorWithRed:108.0/255 green:128.0/255 blue:154.0/255 alpha:1];

	UIBarButtonItem *barCloseBtn = [[UIBarButtonItem alloc] initWithCustomView:[BeintooVC closeButton]];
	[self.navigationItem setRightBarButtonItem:barCloseBtn animated:YES];
	[barCloseBtn release];	
	
	user					 = [[BeintooUser alloc] init];
	_player					 = [[BeintooPlayer alloc] init];

	leaderboardContestTable.delegate  = self;	
	leaderboardContestTable.rowHeight = 60;
	allScores				 = [[NSDictionary alloc]init];
	self.leaderboardEntries  = [[NSMutableArray alloc]init];
	self.leaderboardImages   = [[NSMutableArray alloc]init];
	
	currentUser				= [[NSDictionary alloc] init];
	players                 = [[NSMutableArray alloc]init];
    
    profileVC               = [BeintooProfileVC alloc];	
    loginVC                 = [[BeintooLoginVC alloc] initWithNibName:@"BeintooLoginVC" bundle:[NSBundle mainBundle]];
    
    UIColor *barColor		= [UIColor colorWithRed:108.0/255 green:128.0/255 blue:154.0/255 alpha:1.0];
	loginNavController      = [[UINavigationController alloc] initWithRootViewController:loginVC];
	[[loginNavController navigationBar] setTintColor:barColor];	
}

- (void)viewWillAppear:(BOOL)animated{
    if ([BeintooDevice isiPad]) {
        [self setContentSizeForViewInPopover:CGSizeMake(320, 415)];
    }
    
    user.delegate			 = self;
	_player.delegate		 = self;

    noScoresLabel.hidden = YES;
    
    isAlreadyLogging = NO;
    
    if (signupViewForPlayers != nil) {
        signupViewForPlayers = nil;
        [signupViewForPlayers release];
    }
    [[self.view viewWithTag:1111] removeFromSuperview];
    signupViewForPlayers = [[BSignupLayouts getBeintooLeaderboardSignupViewWithFrame:CGRectMake(0, 0 , self.view.bounds.size.width, 90) andButtonActionSelector:@selector(tryBeintoo) fromSender:self] retain];
    signupViewForPlayers.tag = 1111;
    [self.view addSubview:signupViewForPlayers];

	plusOneCell              = 0;
	startRows                = 0;
	[self.leaderboardEntries removeAllObjects];
	[self.leaderboardImages removeAllObjects];
    
    if ([Beintoo isUserLogged]) {
        [signupViewForPlayers setHidden:YES];
        [segControl setEnabled:YES forSegmentAtIndex:0];
        [segControl setEnabled:YES forSegmentAtIndex:1];
        [segControl setEnabled:YES forSegmentAtIndex:2];
        
        if(homeTablePlayerAnimationPerformed){
            CGRect currentFrame = leaderboardContestTable.frame;
            leaderboardContestTable.frame = CGRectMake(currentFrame.origin.x, currentFrame.origin.y-30, currentFrame.size.width, currentFrame.size.height+30);
            homeTablePlayerAnimationPerformed = NO;
        }
    }
    else{
        [signupViewForPlayers setHidden:NO];
        if(!homeTablePlayerAnimationPerformed){
            CGRect currentFrame = leaderboardContestTable.frame;
            leaderboardContestTable.frame = CGRectMake(currentFrame.origin.x, currentFrame.origin.y+30, currentFrame.size.width, currentFrame.size.height-30);
            homeTablePlayerAnimationPerformed = YES;
        }
        [segControl setEnabled:YES forSegmentAtIndex:0];
        [segControl setEnabled:NO forSegmentAtIndex:1];
        [segControl setEnabled:NO forSegmentAtIndex:2];
    }

    [BLoadingView startActivity:self.view];
    if (self.segControl.selectedSegmentIndex==0) {
        
        isLeaderboardCloseToUser = NO;
        [BLoadingView stopActivity];
        [BLoadingView startActivity:self.view];
        
        [_player topScoreFrom:startRows andRows:NUMBER_OF_ROWS forUser:nil andContest:[[NSUserDefaults standardUserDefaults] objectForKey:@"selectedContest"]];		
    }
    else if (self.segControl.selectedSegmentIndex==1) {
        
        isLeaderboardCloseToUser = NO;
        [BLoadingView stopActivity];
        [BLoadingView startActivity:self.view];
        
        [_player topScoreFrom:startRows andRows:NUMBER_OF_ROWS forUser:[Beintoo getUserID] andContest:[[NSUserDefaults standardUserDefaults] objectForKey:@"selectedContest"]];
    }
    else if (self.segControl.selectedSegmentIndex==2){
        
        isLeaderboardCloseToUser = YES;
        [BLoadingView stopActivity];
        [BLoadingView startActivity:self.view];
        
        [_player topScoreFrom:0 andRows:20 closeToUser:[Beintoo getUserID] andContest:[[NSUserDefaults standardUserDefaults] objectForKey:@"selectedContest"]];
    }
}


#pragma mark AppDelegates

- (void)appDidGetTopScoreswithResult:(NSDictionary *)result{

	@try {
		NSDictionary *currentContest = [result objectForKey:[[NSUserDefaults standardUserDefaults] objectForKey:@"selectedContest"]];
		currentUser					 = [currentContest objectForKey:@"currentUser"];
		self.players				 = [currentContest objectForKey:@"leaderboard"];
		if ([self.players count]>0 && !isLeaderboardCloseToUser) {
			plusOneCell = 1;
		}
		else {
			plusOneCell = 0;
		}
        if ([self.players count] <= 0 && !currentUser) {
            noScoresLabel.hidden = NO;
        }

	}
	@catch (NSException * e) {
		//[_player logException:[NSString stringWithFormat:@"STACK: %@\n\nException: %@",[NSThread callStackSymbols],e]];
	}
    
	if ([self.leaderboardEntries count]<=0 && currentUser != nil) {
		@try { // --------- Here we set the first element of the leaderboard: the current player and its position
			NSMutableDictionary *leaderboardEntry = [[NSMutableDictionary alloc]init];
			
			NSString *position		= [currentUser objectForKey:@"pos"]; 	
			NSString *score			= [currentUser objectForKey:@"score"];
			NSDictionary *theUser	= [currentUser objectForKey:@"user"];
			
			BImageDownload *download = [[[BImageDownload alloc] init] autorelease];
			download.delegate = self;
			download.urlString = [theUser objectForKey:@"usersmallimg"];
			
			[leaderboardEntry setObject:position forKey:@"position"];
			[leaderboardEntry setObject:score forKey:@"score"];
			[leaderboardEntry setObject:theUser forKey:@"user"];
			
			[self.leaderboardEntries addObject:leaderboardEntry];
			[self.leaderboardImages addObject:download];
			
			[leaderboardEntry release];
		}
		@catch (NSException * e) {
			//[_player logException:[NSString stringWithFormat:@"STACK: %@\n\nException: %@",[NSThread callStackSymbols],e]];
		}
	}
		
	for (int i=0; i<[self.players count]; i++) {
		@try {
			NSMutableDictionary *leaderboardEntry = [[NSMutableDictionary alloc]init];
			
			NSString *position		= [[self.players objectAtIndex:i] objectForKey:@"pos"]; 	
			NSString *score			= [[self.players objectAtIndex:i] objectForKey:@"score"];
			NSDictionary *theUser	= [[self.players objectAtIndex:i] objectForKey:@"user"];
			
			BImageDownload *download = [[[BImageDownload alloc] init] autorelease];
			download.delegate = self;
			download.urlString = [theUser objectForKey:@"usersmallimg"];
						
			[leaderboardEntry setObject:position forKey:@"position"];
			[leaderboardEntry setObject:score forKey:@"score"];
			[leaderboardEntry setObject:theUser forKey:@"user"];
			
			[self.leaderboardEntries addObject:leaderboardEntry];
			[self.leaderboardImages addObject:download];
			
			[leaderboardEntry release];
		}
		@catch (NSException * e) {
			//[_player logException:[NSString stringWithFormat:@"STACK: %@\n\nException: %@",[NSThread callStackSymbols],e]];
			NSLog(@"BeintooException: %@ \n for object: %@",e,[players objectAtIndex:i]);
		}
	}
	[BLoadingView stopActivity];
    
    //int currentUserPosition = [[currentUser objectForKey:@"pos"] intValue];
	[leaderboardContestTable reloadData];
}

- (void)tryBeintoo{	
    
    if (!isAlreadyLogging) {
        isAlreadyLogging = YES;
        @try {
            if ([BeintooNetwork connectedToNetwork]) {
                [BLoadingView startActivity:self.view];
                [loginNavController popToRootViewControllerAnimated:NO];                
            }
            [user getUserByUDID];
        }
        @catch (NSException * e) {
        }
    }
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
	return [self.leaderboardEntries count] + plusOneCell;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
	static NSString *CellIdentifier = @"Cell";
   	int _gradientType = (indexPath.row % 2) ? GRADIENT_CELL_HEAD : GRADIENT_CELL_BODY;
	
	UIFont *positionFont = [UIFont systemFontOfSize:16];
	if (indexPath.row == 0 && currentUser != nil) {
		_gradientType = GRADIENT_CELL_SPECIAL;
		positionFont  = [UIFont boldSystemFontOfSize:15]; 
	}
	
	BTableViewCell *cell = (BTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil || YES) {
        cell = [[[BTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier andGradientType:_gradientType] autorelease];
    }
	
	if (indexPath.row == [self.leaderboardEntries count]) {
		
		UILabel *loadMoreLabel			= [[UILabel alloc] initWithFrame:CGRectMake(110, 20, 110, 14)];
		loadMoreLabel.autoresizingMask	= UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin;
		loadMoreLabel.backgroundColor	= [UIColor clearColor];
		loadMoreLabel.font				= [UIFont systemFontOfSize:17];		
		loadMoreLabel.text				= @"Load more";
		
		[cell addSubview:loadMoreLabel];
		[loadMoreLabel release];

	}
	else {
        UIImage *cellImage;
        if ([self.leaderboardImages count]>0) {
            BImageDownload *download = [self.leaderboardImages objectAtIndex:indexPath.row];
            cellImage  = download.image;
        }
        
        if ([self.leaderboardEntries count]>0) {
            NSDictionary *userToShow = [[self.leaderboardEntries objectAtIndex:indexPath.row] objectForKey:@"user"];
            
            cell.textLabel.text             = [userToShow objectForKey:@"nickname"];
            cell.detailTextLabel.text       = [NSString stringWithFormat:@"%@: %@",NSLocalizedStringFromTable(@"score",@"BeintooLocalizable",@"Score"),[[self.leaderboardEntries objectAtIndex:indexPath.row] objectForKey:@"score"]];
            cell.textLabel.font             = [UIFont systemFontOfSize:14];
            cell.detailTextLabel.textColor  = [UIColor blackColor];
            cell.detailTextLabel.font       = [UIFont systemFontOfSize:12];
            
            cell.imageView.image = cellImage;
            
            UILabel *positionLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 35, 17)];
            positionLabel.backgroundColor = [UIColor clearColor];
            positionLabel.font = positionFont;
            positionLabel.adjustsFontSizeToFitWidth = YES;
            positionLabel.text = [NSString stringWithFormat:@"%@",[[self.leaderboardEntries objectAtIndex:indexPath.row] objectForKey:@"position"]];
            
            cell.accessoryView = positionLabel;
            
            [positionLabel release];		   
        }
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	if (indexPath.row == [self.leaderboardEntries count]) {
		startRows = startRows + NUMBER_OF_ROWS;

		// Adding new elements to the tableview, depending on the segmentcontrol we use the userId or not to load only friends
		if (self.segControl.selectedSegmentIndex == 0) {
			[_player topScoreFrom:startRows andRows:NUMBER_OF_ROWS forUser:nil andContest:[[NSUserDefaults standardUserDefaults] objectForKey:@"selectedContest"]];
		}else {
			[_player topScoreFrom:startRows andRows:NUMBER_OF_ROWS forUser:[Beintoo getUserID] andContest:[[NSUserDefaults standardUserDefaults] objectForKey:@"selectedContest"]];
		}
		[BLoadingView startActivity:self.view];
	}
	else if([Beintoo isUserLogged]) {  /* LEADERBOARD FOR USER */
        // here we have to choose among:
        // -- 1. Send a challenge
        // -- 2. View profile
        // -- 3. Add as friend
        
		self.selectedPlayer = [self.leaderboardEntries objectAtIndex:indexPath.row];
		NSString *myUserID = [Beintoo getUserID];
		if (![[[self.selectedPlayer objectForKey:@"user"] objectForKey:@"id"] isEqualToString:myUserID]) {
			[self openSelectedPlayer];
		}else {
			[leaderboardContestTable deselectRowAtIndexPath:[leaderboardContestTable indexPathForSelectedRow] animated:YES];
		}
	}
    else{  /* LEADERBOARD FOR PLAYER */
        [leaderboardContestTable deselectRowAtIndexPath:[leaderboardContestTable indexPathForSelectedRow] animated:YES];
    }
}

#pragma mark -
#pragma mark BImageDownload Delegate Methods

- (void)bImageDownloadDidFinishDownloading:(BImageDownload *)download{
    NSUInteger index = [self.leaderboardImages indexOfObject:download]; 
    NSUInteger indices[] = {0, index};
    NSIndexPath *path = [[NSIndexPath alloc] initWithIndexes:indices length:2];
    [leaderboardContestTable reloadRowsAtIndexPaths:[NSArray arrayWithObject:path] withRowAnimation:UITableViewRowAnimationNone];
    [path release];
    download.delegate = nil;
}
- (void)bImageDownload:(BImageDownload *)download didFailWithError:(NSError *)error{
    NSLog(@"BeintooImageError: %@", [error localizedDescription]);
}

#pragma mark -
#pragma mark ActionSheetCall

- (void)openSelectedPlayer{

	UIActionSheet	*popup = [[UIActionSheet alloc] initWithTitle:nil delegate:self 
                                                    cancelButtonTitle:@"Cancel" 
                                                    destructiveButtonTitle:nil
                                            otherButtonTitles:NSLocalizedStringFromTable(@"leadSendChall",@"BeintooLocalizable",@""),
                                                    NSLocalizedStringFromTable(@"leadViewProfile",@"BeintooLocalizable",@""),
                                                    NSLocalizedStringFromTable(@"leadAddFriend",@"BeintooLocalizable",@""), nil ];
    
	popup.actionSheetStyle = UIActionSheetStyleDefault;
	[popup showInView:[self.view superview]];
	[popup release];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
	if (buttonIndex == 0) { 
        // ---------- Send challenge
        //[user challengeRequestfrom:myUserExt to:toUserExt withAction:@"INVITE" forContest:[[NSUserDefaults standardUserDefaults] objectForKey:@"selectedContest"]];
        
        BSendChallengesView *sendChallengeView  = [[BSendChallengesView alloc] initWithFrame:self.view.frame];
        sendChallengeView.challengeReceiver     = [self.selectedPlayer objectForKey:@"user"];
        sendChallengeView.challengeSender       = [Beintoo getUserIfLogged];
        
        [sendChallengeView drawSendChallengeView];
        sendChallengeView.tag = BSENDCHALLENGE_VIEW_TAG;
        sendChallengeView.alpha = 0;
        [self.view addSubview:sendChallengeView];
        [sendChallengeView release];
        
        [UIView beginAnimations:@"sendChallengeOpen" context:nil];
        [UIView setAnimationDelay:0];
        [UIView setAnimationDuration:0.45];
        sendChallengeView.alpha = 1;
        [UIView commitAnimations];	
    }
    else if (buttonIndex == 1) {
		// ---------- View profile
        NSDictionary *profileOptions = [NSDictionary dictionaryWithObjectsAndKeys:@"friendsProfile",@"caller",
                                        [[self.selectedPlayer objectForKey:@"user"] objectForKey:@"id"],@"friendUserID",
                                        [[self.selectedPlayer objectForKey:@"user"] objectForKey:@"nickname"],@"friendNickname",nil];
		[profileVC initWithNibName:@"BeintooProfileVC" bundle:[NSBundle mainBundle] andOptions:profileOptions];
		[self.navigationController pushViewController:profileVC animated:YES];

	}
    else if (buttonIndex == 2){
        // ---------- Add as a friend
        [user sendFriendshipRequestTo:[[self.selectedPlayer objectForKey:@"user"]objectForKey:@"id"]];

    }
    [leaderboardContestTable deselectRowAtIndexPath:[leaderboardContestTable indexPathForSelectedRow] animated:YES];
}

#pragma mark -
#pragma mark Friend request response

- (void)didGetFriendRequestResponse:(NSDictionary *)result{
	[BLoadingView stopActivity];
	
	NSString *alertMessage;
	if ([[result objectForKey:@"message"] isEqualToString:@"OK"]) 
		alertMessage = NSLocalizedStringFromTable(@"requestSent",@"BeintooLocalizable",@"");
	else{
		int messageID = (int)[[result objectForKey:@"messageID"] doubleValue];
		if (messageID == -23) 
			alertMessage = NSLocalizedStringFromTable(@"pendingFriendRequest",@"BeintooLocalizable",@"");
		else
			alertMessage = NSLocalizedStringFromTable(@"requestNotSent",@"BeintooLocalizable",@"");
	}
	UIAlertView *av = [[UIAlertView alloc] initWithTitle:nil message:alertMessage delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
	[av show];
	[av release];
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

-(IBAction) segmentedControlIndexChanged{
    noScoresLabel.hidden = YES;
    
	switch (self.segControl.selectedSegmentIndex) {
		case 0:{
			
			// Resetting all the leaderboards array
			plusOneCell              = 0;
			startRows                = 0;
            isLeaderboardCloseToUser = NO;
			[self.leaderboardEntries removeAllObjects];
			[self.leaderboardImages removeAllObjects];
			
			
			[BLoadingView stopActivity];
			[BLoadingView startActivity:self.view];
			
			[_player topScoreFrom:startRows andRows:NUMBER_OF_ROWS forUser:nil andContest:[[NSUserDefaults standardUserDefaults] objectForKey:@"selectedContest"]];
		}
			break;
		case 1:{
			// Resetting all the leaderboards array
            plusOneCell              = 0;
			startRows                = 0;
            isLeaderboardCloseToUser = NO;
            [self.leaderboardEntries removeAllObjects];
			[self.leaderboardImages removeAllObjects];
			
			[BLoadingView stopActivity];
			[BLoadingView startActivity:self.view];
			
			[_player topScoreFrom:startRows andRows:NUMBER_OF_ROWS forUser:[Beintoo getUserID] andContest:[[NSUserDefaults standardUserDefaults] objectForKey:@"selectedContest"]];
		}
			break;
        
        case 2:{
			// Resetting all the leaderboards array
			plusOneCell              = 0;
			startRows                = 0;
            isLeaderboardCloseToUser = YES;
			[self.leaderboardEntries removeAllObjects];
			[self.leaderboardImages removeAllObjects];
			
			[BLoadingView stopActivity];
			[BLoadingView startActivity:self.view];
			
			[_player topScoreFrom:0 andRows:20 closeToUser:[Beintoo getUserID] andContest:[[NSUserDefaults standardUserDefaults] objectForKey:@"selectedContest"]];
		}
			break;
			
		default:
			break;
	}
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
    [super viewDidUnload];
}

- (void)viewWillDisappear:(BOOL)animated {
    user.delegate       = nil;
    _player.delegate    = nil;
    
    @try {
		[BLoadingView stopActivity];
        for (UIView *view in [self.view subviews]) {
            if([view isKindOfClass:[BLoadingView class]]){	
            [view removeFromSuperview];
            }
        }
	}
	@catch (NSException * e) {
	}
}

- (void)viewDidDisappear:(BOOL)animated{
    @try {
        UIView *sendChallenge  = [self.view viewWithTag:BSENDCHALLENGE_VIEW_TAG];
        [sendChallenge removeFromSuperview];
    }
	@catch (NSException * e) {
        NSLog(@"Exception on view removing");
    }
    
    @try {
        UIView *signupView  = [self.view viewWithTag:1111];
        [signupView removeFromSuperview];
        [self.leaderboardEntries removeAllObjects];
        [self.leaderboardImages removeAllObjects];
	}
	@catch (NSException * e) {
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return NO;
}

- (void)dealloc {
	[currentUser release];
	[players release];
    [profileVC release];
	[allScores release];
	[self.leaderboardEntries release];
	[self.leaderboardImages release];
	[user release];
    [loginVC release];
	[_player release];
    [signupViewForPlayers release];
    [super dealloc];
}

@end
