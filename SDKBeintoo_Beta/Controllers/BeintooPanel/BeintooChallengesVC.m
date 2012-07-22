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

#import "BeintooChallengesVC.h"
#import "Beintoo.h"

@implementation BeintooChallengesVC

@synthesize challengesArrayList,selectedChallenge,segControl,titleLabel,showChallengeVC,myImage,challengeImages;

- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.title = NSLocalizedStringFromTable(@"challenges",@"BeintooLocalizable",@"Challenges");

	challengesTable.delegate	= self;
	challengesTable.rowHeight	= 60.0;
	
	[challengesView setTopHeight:60.0];
	[challengesView setBodyHeight:370.0];
	
	[segControl setTitle:NSLocalizedStringFromTable(@"pending",@"BeintooLocalizable",@"Pending") forSegmentAtIndex:0];
	[segControl setTitle:NSLocalizedStringFromTable(@"ongoing",@"BeintooLocalizable",@"Ongoing") forSegmentAtIndex:1];
	[segControl setTitle:NSLocalizedStringFromTable(@"ended",@"BeintooLocalizable",@"Ended") forSegmentAtIndex:2];

    segControl.tintColor = [UIColor colorWithRed:108.0/255 green:128.0/255 blue:154.0/255 alpha:1];
	
	titleLabel.text = NSLocalizedStringFromTable(@"nochallenges",@"BeintooLocalizable",@"You don't have any challenge in this state");
	titleLabel1.text = NSLocalizedStringFromTable(@"hereare",@"BeintooLocalizable",@"Here are your challenges");
	titleLabel2.text = NSLocalizedStringFromTable(@"itstimeto",@"BeintooLocalizable",@"It's time to win!");
	
	UIBarButtonItem *barCloseBtn = [[UIBarButtonItem alloc] initWithCustomView:[BeintooVC closeButton]];
	[self.navigationItem setRightBarButtonItem:barCloseBtn animated:YES];
	[barCloseBtn release];		
		
	[self.titleLabel setHidden:YES];
	self.challengesArrayList    = [[NSMutableArray alloc] init];
    self.challengeImages        = [[NSMutableArray alloc] init];
	self.showChallengeVC        = [BeintooShowChallengeVC alloc];

	user = [[BeintooUser alloc] init];
	_player = [[BeintooPlayer alloc] init];
}

- (void)viewWillAppear:(BOOL)animated{

    if ([BeintooDevice isiPad]) {
        [self setContentSizeForViewInPopover:CGSizeMake(320, 415)];
    }
	[self.titleLabel setHidden:YES];	
    
    user.delegate = self;
	
	if (![Beintoo isUserLogged])
		[self.navigationController popToRootViewControllerAnimated:NO];
	else {
		[BLoadingView startActivity:self.view];
		
		if (self.segControl.selectedSegmentIndex==0) 
			[user showChallengesbyStatus:CHALLENGES_TO_BE_ACCEPTED];	
		else if (self.segControl.selectedSegmentIndex==1) 
			[user showChallengesbyStatus:CHALLENGES_STARTED];
		else if (self.segControl.selectedSegmentIndex==2) 
			[user showChallengesbyStatus:CHALLENGES_ENDED];
	}
}

#pragma mark -
#pragma mark Delegates
- (void)didShowChallengesByStatus:(NSArray *)result{
    	
    [self.challengesArrayList removeAllObjects];
    [self.challengeImages removeAllObjects];
		
	if ([result count] == 0) {
		[self.titleLabel setHidden:NO];
	}else {
		[self.titleLabel setHidden:YES];
	}

	if([result isKindOfClass:[NSDictionary class]]){
		NSDictionary *errorRes = (NSDictionary *)result;
		if ([errorRes objectForKey:@"kind"]!=nil) {
			[BLoadingView stopActivity];
			[self.titleLabel setHidden:NO];
			return;
		}
	}
	
	for (int i=0; i<[result count]; i++) {
		@try {
			NSMutableDictionary *challengeEntry = [[NSMutableDictionary alloc]init];
			
            NSString *imgUrlFrom = [[[[result objectAtIndex:i] objectForKey:@"playerFrom"] objectForKey:@"user"] objectForKey:@"usersmallimg"];
			NSString *imgUrlTo = [[[[result objectAtIndex:i] objectForKey:@"playerTo"] objectForKey:@"user"] objectForKey:@"usersmallimg"];
			NSString *imgUrl;
            
			NSString *status		= [[result objectAtIndex:i] objectForKey:@"status"];
			NSString *playerFromScore;
			NSString *playerToScore;
			NSString *startDate;
			NSString *endDate;
			NSString *winner;
						
			if (![status isEqualToString:@"TO_BE_ACCEPTED"]) {
				playerFromScore	= [[result objectAtIndex:i] objectForKey:@"playerFromScore"];
				playerToScore	= [[result objectAtIndex:i] objectForKey:@"playerToScore"];
				startDate		= [[result objectAtIndex:i] objectForKey:@"startdate"];
				endDate         = [[result objectAtIndex:i] objectForKey:@"enddate"];
			}
			if ([status isEqualToString:@"ENDED"]) {
				winner			= [[[result objectAtIndex:i] objectForKey:@"winner"] objectForKey:@"user"];
			}
            
			NSString *playerFrom	= [[[[result objectAtIndex:i] objectForKey:@"playerFrom"] objectForKey:@"user"] objectForKey:@"nickname"];
			NSString *playerTo		= [[[[result objectAtIndex:i] objectForKey:@"playerTo"] objectForKey:@"user"] objectForKey:@"nickname"];
			NSString *userExtFrom	= [[[[result objectAtIndex:i] objectForKey:@"playerFrom"] objectForKey:@"user"] objectForKey:@"id"];
			NSString *userExtTo		= [[[[result objectAtIndex:i] objectForKey:@"playerTo"] objectForKey:@"user"] objectForKey:@"id"];
			NSString *contestName	= [[[result objectAtIndex:i] objectForKey:@"contest"] objectForKey:@"name"];
			NSString *contestCodeID = [[[result objectAtIndex:i] objectForKey:@"contest"] objectForKey:@"codeID"];
            
            NSString *actorId = [[[[result objectAtIndex:i] objectForKey:@"userActor"] objectForKey:@"user"] objectForKey:@"id"];
            NSString *type = [[result objectAtIndex:i] objectForKey:@"type"];

			if ([playerFrom isEqualToString:[[Beintoo getUserIfLogged] objectForKey:@"nickname"]]) {
				imgUrl = imgUrlTo;
			}else{ imgUrl = imgUrlFrom;}
                    
            BImageDownload *download         = [[[BImageDownload alloc] init] autorelease];
			download.delegate                = self;
			download.urlString               = imgUrl;

			NSString *price			= [[result objectAtIndex:i] objectForKey:@"price"];
			NSString *prize			= [[result objectAtIndex:i] objectForKey:@"prize"];
            NSString *targetScore   = [[result objectAtIndex:i] objectForKey:@"targetScore"];

			[challengeEntry setObject:playerFrom forKey:@"playerFrom"];
			[challengeEntry setObject:playerTo forKey:@"playerTo"];
			if (![status isEqualToString:@"TO_BE_ACCEPTED"]) {
				[challengeEntry setObject:playerFromScore forKey:@"playerFromScore"];
				[challengeEntry setObject:playerToScore forKey:@"playerToScore"];
				[challengeEntry setObject:startDate forKey:@"startDate"];
				[challengeEntry setObject:endDate forKey:@"endDate"];
			}
			if ([status isEqualToString:@"ENDED"]) {
				if (winner!=nil) {
					[challengeEntry setObject:winner forKey:@"winner"];
				}
			}
			[challengeEntry setObject:userExtFrom forKey:@"userExtFrom"];
			[challengeEntry setObject:userExtTo forKey:@"userExtTo"];
			[challengeEntry setObject:contestName forKey:@"contestName"];
			[challengeEntry setObject:contestCodeID forKey:@"contestCodeID"];
			[challengeEntry setObject:status forKey:@"status"];
            [challengeEntry setObject:price	forKey:@"price"];
			[challengeEntry setObject:prize forKey:@"prize"];
            
            [challengeEntry setObject:imgUrlFrom forKey:@"imgUrlFrom"];	
            [challengeEntry setObject:imgUrlTo forKey:@"imgUrlTo"];			
            
            if ( [[result objectAtIndex:i] objectForKey:@"targetScore"] != nil){
                [challengeEntry setObject:targetScore forKey:@"targetScore"];
            }
			
			[challengeEntry setObject:actorId forKey:@"actorId"];
            [challengeEntry setObject:type forKey:@"type"];
			
            [self.challengeImages addObject:download];
			[self.challengesArrayList addObject:challengeEntry];
			[challengeEntry release];
			
		}
		@catch (NSException * e) {
			//[_player logException:[NSString stringWithFormat:@"STACK: %@\n\nException: %@",[NSThread callStackSymbols],e]];
			NSLog(@"BeintooException: %@ \n for object: %@",e,[result objectAtIndex:i]);
		}
	}
	[BLoadingView stopActivity];
	[challengesTable reloadData];
}

- (IBAction) segmentedControlIndexChanged{
	switch (self.segControl.selectedSegmentIndex) {
		case 0:{
			[BLoadingView stopActivity];
			[BLoadingView startActivity:self.view];
			[user showChallengesbyStatus:CHALLENGES_TO_BE_ACCEPTED];	
		}
			break;
		case 1:{
			[BLoadingView stopActivity];
			[BLoadingView startActivity:self.view];
			[user showChallengesbyStatus:CHALLENGES_STARTED];	
		}
			break;
			
		case 2:{
			[BLoadingView stopActivity];
			[BLoadingView startActivity:self.view];
			[user showChallengesbyStatus:CHALLENGES_ENDED];	
		}
			break;
			
			
		default:
			break;
	}
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [self.challengesArrayList count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 65;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
	static NSString *CellIdentifier = @"Cell";
   	int _gradientType = (indexPath.row % 2) ? GRADIENT_CELL_HEAD : GRADIENT_CELL_BODY;
	
	BTableViewCell *cell = (BTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil || YES) {
        cell = [[[BTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier andGradientType:_gradientType] autorelease];
    }
    
    UILabel *textLabel              = [[UILabel alloc] initWithFrame:CGRectMake(75, 10, 230, 24)];
    textLabel.text                  = [NSString stringWithFormat:@"%@",[[self.challengesArrayList objectAtIndex:indexPath.row] objectForKey:@"contestName"]];
    textLabel.font                  = [UIFont systemFontOfSize:18];
    textLabel.autoresizingMask      = UIViewAutoresizingFlexibleWidth;
    textLabel.backgroundColor       = [UIColor clearColor];
    
    NSString *detailString          = [NSString stringWithFormat:@"%@ %@ %@ %@",NSLocalizedStringFromTable(@"from",@"BeintooLocalizable",@""),[[self.challengesArrayList objectAtIndex:indexPath.row] objectForKey:@"playerFrom"],NSLocalizedStringFromTable(@"to",@"BeintooLocalizable",@""),[[self.challengesArrayList objectAtIndex:indexPath.row] objectForKey:@"playerTo"]];
    
    UILabel *detailTextLabel        = [[UILabel alloc] initWithFrame:CGRectMake(75, 34, 230, 20)];
    detailTextLabel.text            = detailString;
    detailTextLabel.textColor       = [UIColor grayColor];
    detailTextLabel.font            = [UIFont systemFontOfSize:13];
    detailTextLabel.autoresizingMask= UIViewAutoresizingFlexibleWidth;
    detailTextLabel.backgroundColor = [UIColor clearColor];
    
    BImageDownload *download        = [self.challengeImages objectAtIndex:indexPath.row];

    UIImage *challengeImage         = download.image;
    UIImageView *imageView          = [[UIImageView alloc] initWithFrame:CGRectMake(7, 6, 50, 50)];
    imageView.backgroundColor       = [UIColor clearColor];    
    imageView.image                 = challengeImage;

    [cell addSubview:imageView];
    [cell addSubview:textLabel];
    [cell addSubview:detailTextLabel];
    
    [imageView release];
    [textLabel release];
    [detailTextLabel release];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	self.selectedChallenge = [self.challengesArrayList objectAtIndex:indexPath.row];
	[self.showChallengeVC initWithNibName:@"BeintooShowChallengeVC" bundle:[NSBundle mainBundle] andChallengeStatus:self.selectedChallenge];
	NSString *devicePlayer = [[Beintoo getUserIfLogged] objectForKey:@"nickname"];
	if ([[self.selectedChallenge objectForKey:@"status"]isEqualToString:@"TO_BE_ACCEPTED"]) {
		if (![[self.selectedChallenge objectForKey:@"playerFrom"] isEqualToString:devicePlayer]){
			[self.navigationController pushViewController:self.showChallengeVC animated:YES];
		}
	}
	else 
		[self.navigationController pushViewController:self.showChallengeVC animated:YES];

	[challengesTable deselectRowAtIndexPath:[challengesTable indexPathForSelectedRow] animated:YES];
}

#pragma mark - ImageDownload Delegate
- (void)bImageDownloadDidFinishDownloading:(BImageDownload *)download{
    NSUInteger index = [self.challengeImages indexOfObject:download]; 
    NSUInteger indices[] = {0, index};
    NSIndexPath *path = [[NSIndexPath alloc] initWithIndexes:indices length:2];
    [challengesTable reloadRowsAtIndexPaths:[NSArray arrayWithObject:path] withRowAnimation:UITableViewRowAnimationNone];
    [path release];
    download.delegate = nil;
}
- (void)bImageDownload:(BImageDownload *)download didFailWithError:(NSError *)error{
    NSLog(@"Beintoo - Image Loading Error: %@", [error localizedDescription]);
}

#pragma mark - UIViewController end methods
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return NO;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
    [super viewDidUnload];
}

- (void)viewWillDisappear:(BOOL)animated {
    user.delegate = nil;
    @try {
		[BLoadingView stopActivity];
	}
	@catch (NSException * e) {
	}
}

- (void)dealloc {
	[user release];
    [self.challengesArrayList release];
    [self.challengeImages release];
	[self.showChallengeVC release];
	[_player release];
    [super dealloc];
}

@end
