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

#import "BeintooAlliancesLeaderboardVC.h"
#import "Beintoo.h"

@implementation BeintooAlliancesLeaderboardVC

@synthesize players,leaderboardEntries,leaderboardImages,selectedPlayer;

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	//self.title = NSLocalizedStringFromTable(@"leaderboard",@"BeintooLocalizable",@"Leaderboard");

	[leaderboardContestView setTopHeight:10];
	[leaderboardContestView setBodyHeight:427];
	    
    noAlliancesLabel.text = @"No active alliances on this contest.";

	UIBarButtonItem *barCloseBtn = [[UIBarButtonItem alloc] initWithCustomView:[BeintooVC closeButton]];
	[self.navigationItem setRightBarButtonItem:barCloseBtn animated:YES];
	[barCloseBtn release];	
	
	user					 = [[BeintooUser alloc] init];
	_player					 = [[BeintooPlayer alloc] init];
    _alliance                = [[BeintooAlliance alloc] init];

	leaderboardContestTable.delegate  = self;	
	leaderboardContestTable.rowHeight = 60;
	allScores				 = [[NSDictionary alloc]init];
	self.leaderboardEntries  = [[NSMutableArray alloc]init];
	self.leaderboardImages   = [[NSMutableArray alloc]init];
	
	currentUser				= [[NSDictionary alloc] init];
	self.players			= [[NSMutableArray alloc]init];
    
}

- (void)viewWillAppear:(BOOL)animated{
    if ([BeintooDevice isiPad]) {
        [self setContentSizeForViewInPopover:CGSizeMake(320, 415)];
    }

    user.delegate			 = self;
    _player.delegate		 = self;
    _alliance.delegate       = self;

	plusOneCell = 0;
	startRows	= 0;
	[self.leaderboardEntries removeAllObjects];
	[self.leaderboardImages removeAllObjects];
    noAlliancesLabel.hidden = YES;


    [BLoadingView startActivity:self.view];
    [_alliance topScoreFrom:startRows andRows:NUMBER_OF_ROWS_ALLIANCE
                forContest:[[NSUserDefaults standardUserDefaults] objectForKey:@"selectedContest"]];

}


#pragma mark AppDelegates
- (void)didGetAllianceTopScore:(NSDictionary *)result{
    
    noAlliancesLabel.hidden = YES;
    
    @try {
		NSDictionary *currentContest = [result objectForKey:[[NSUserDefaults standardUserDefaults] objectForKey:@"selectedContest"]];
		currentUser					 = [currentContest objectForKey:@"currentUser"];
		self.players				 = [currentContest objectForKey:@"leaderboard"];
		if ([self.players count]>0) {
			plusOneCell = 1;
		}
		else {
			plusOneCell = 0;
		}
        if ([self.players count] <= 0 && !currentUser) {
            noAlliancesLabel.hidden = NO;
        }
	}
    @catch (NSException * e) {
		//[_player logException:[NSString stringWithFormat:@"STACK: %@\n\nException: %@",[NSThread callStackSymbols],e]];
	}
    
    if ([self.leaderboardEntries count]<=0) {
		@try { // --------- Here we set the first element of the leaderboard: the current player and its position
			NSMutableDictionary *leaderboardEntry = [[NSMutableDictionary alloc] init];
			
			NSString *position          = [currentUser objectForKey:@"pos"]; 	
			NSString *score             = [currentUser objectForKey:@"score"];
			NSDictionary *theAlliance	= [currentUser objectForKey:@"alliance"];
			
			//BImageDownload *download = [[[BImageDownload alloc] init] autorelease];
			//download.delegate = self;
			//download.urlString = [theAlliance objectForKey:@"usersmallimg"];
			
			[leaderboardEntry setObject:position forKey:@"position"];
			[leaderboardEntry setObject:score forKey:@"score"];
			[leaderboardEntry setObject:theAlliance forKey:@"user"];
			
			[self.leaderboardEntries addObject:leaderboardEntry];
            //[self.leaderboardImages addObject:download];
			
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
			NSDictionary *theUser	= [[self.players objectAtIndex:i] objectForKey:@"alliance"];
			
			//BImageDownload *download = [[[BImageDownload alloc] init] autorelease];
			//download.delegate = self;
			//download.urlString = [theUser objectForKey:@"usersmallimg"];
            
			[leaderboardEntry setObject:position forKey:@"position"];
			[leaderboardEntry setObject:score forKey:@"score"];
			[leaderboardEntry setObject:theUser forKey:@"user"];
			
			[self.leaderboardEntries addObject:leaderboardEntry];
			//[self.leaderboardImages addObject:download];
			
			[leaderboardEntry release];
		}
		@catch (NSException * e) {
			NSLog(@"BeintooException: %@ \n for object: %@",e,[players objectAtIndex:i]);
		}
	}
    [BLoadingView stopActivity];
    [leaderboardContestTable reloadData];
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
        NSDictionary *allianceToShow = [[self.leaderboardEntries objectAtIndex:indexPath.row] objectForKey:@"user"];
        
        cell.textLabel.text = [allianceToShow objectForKey:@"name"];
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@: %@",NSLocalizedStringFromTable(@"score",@"BeintooLocalizable",@"Score"),[[self.leaderboardEntries objectAtIndex:indexPath.row] objectForKey:@"score"]];
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        cell.detailTextLabel.font = [UIFont systemFontOfSize:12];
        
        cell.imageView.image    = [UIImage imageNamed:@"beintoo_alliance_iconsmall.png"];
        
        UILabel *positionLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 35, 17)];
        positionLabel.backgroundColor = [UIColor clearColor];
        positionLabel.font = positionFont;
        positionLabel.adjustsFontSizeToFitWidth = YES;
        positionLabel.text = [NSString stringWithFormat:@"%@",[[self.leaderboardEntries objectAtIndex:indexPath.row] objectForKey:@"position"]];
        
        cell.accessoryView = positionLabel;
        
        [positionLabel release];		
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	if (indexPath.row == [self.leaderboardEntries count]) {
		startRows = startRows + NUMBER_OF_ROWS_ALLIANCE;

		// Adding new elements to the tableview, depending on the segmentcontrol we use the userId or not to load only friends
        [_alliance topScoreFrom:startRows andRows:NUMBER_OF_ROWS_ALLIANCE forContest:[[NSUserDefaults standardUserDefaults] objectForKey:@"selectedContest"]];
		[BLoadingView startActivity:self.view];
	}
	else { 
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
    [super viewDidUnload];
}

- (void)viewWillDisappear:(BOOL)animated{
    user.delegate			 = nil;
    _player.delegate		 = nil;
    _alliance.delegate       = nil;

    @try {
		[BLoadingView stopActivity];
	}
	@catch (NSException * e) {
	}
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return NO;
}

- (void)dealloc {
	[currentUser release];
	[self.players release];
	[allScores release];
	[self.leaderboardEntries release];
	[self.leaderboardImages release];
	[user release];
	[_player release];
    [super dealloc];
}

@end
