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


#import "BeintooAchievementsVC.h"
#import "Beintoo.h"

@implementation BeintooAchievementsVC

@synthesize achievementsArrayList,achievementsImages;

- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.title = NSLocalizedStringFromTable(@"achievements",@"BeintooLocalizable",@"Wallet");
	
	[walletView setTopHeight:20];
	[walletView setBodyHeight:460];

	achievementsTable.delegate	= self;
	achievementsTable.rowHeight	= 70.0;
	walletLabel.text		= NSLocalizedStringFromTable(@"hereiswallet",@"BeintooLocalizable",@"");
	

	_achievements			 = [[BeintooAchievements alloc] init];
	_player					 = [[BeintooPlayer alloc] init];

	UIBarButtonItem *barCloseBtn = [[UIBarButtonItem alloc] initWithCustomView:[BeintooVC closeButton]];
	[self.navigationItem setRightBarButtonItem:barCloseBtn animated:YES];
	[barCloseBtn release];
	
	self.achievementsArrayList = [[NSMutableArray alloc] init];
	self.achievementsImages    = [[NSMutableArray alloc]init];
}

- (void)viewWillAppear:(BOOL)animated{
	
    if ([BeintooDevice isiPad]) {
        [self setContentSizeForViewInPopover:CGSizeMake(320, 415)];
    }
    
    _achievements.delegate	 = self;

    noAchievementsLabel.text		= NSLocalizedStringFromTable(@"noAchievementsLabel",@"BeintooLocalizable",@"");
    
    [self.achievementsArrayList removeAllObjects];
    [self.achievementsImages removeAllObjects];
    [achievementsTable reloadData];
    [noAchievementsLabel setHidden:YES];
    [achievementsTable deselectRowAtIndexPath:[achievementsTable indexPathForSelectedRow] animated:YES];
    [BLoadingView startActivity:self.view];
    [_achievements getAchievementsForCurrentUser];
}

#pragma mark -
#pragma mark Delegates

- (void)didGetAllUserAchievementsWithResult:(NSArray *)result{
    
	[self.achievementsArrayList removeAllObjects];
	[self.achievementsImages removeAllObjects];
	[noAchievementsLabel setHidden:YES];
	if ([result count] <= 0) {
		[noAchievementsLabel setHidden:NO];
	}
	if ([result isKindOfClass:[NSDictionary class]]) {
		[noAchievementsLabel setHidden:NO];
		[BLoadingView stopActivity];
		[achievementsTable reloadData];
		return;
	}
	
	for (int i=0; i<[result count]; i++) {
		@try {
			NSMutableDictionary *achievementEntry = [[NSMutableDictionary alloc]init];
			NSDictionary *currentAchievement = [[result objectAtIndex:i] objectForKey:@"achievement"];
            
			
			NSString *name          = [currentAchievement objectForKey:@"name"]; 
			NSString *description   = [currentAchievement objectForKey:@"description"]; 
			NSString *bedollarsVal	= [currentAchievement objectForKey:@"bedollars"];
			NSString *imageURL		= [currentAchievement objectForKey:@"imageURL"];
			
			NSString *blockedBy		= [currentAchievement objectForKey:@"blockedBy"];
			BOOL isBlockedByOthers = FALSE;
			if (blockedBy != nil) {
				isBlockedByOthers = TRUE;
			}

			BImageDownload *download = [[[BImageDownload alloc] init] autorelease];
			download.delegate = self;
			download.urlString = [currentAchievement objectForKey:@"imageURL"];
			
			[achievementEntry setObject:name forKey:@"name"];
			[achievementEntry setObject:description	forKey:@"description"];
			[achievementEntry setObject:bedollarsVal forKey:@"bedollarsValue"];
			[achievementEntry setObject:imageURL forKey:@"imageURL"];
			if (isBlockedByOthers) {
				[achievementEntry setObject:blockedBy forKey:@"blockedBy"];
			}
			[self.achievementsArrayList addObject:achievementEntry];
			[self.achievementsImages addObject:download];
			[achievementEntry release];
		}
		@catch (NSException * e) {
			NSLog(@"BeintooException: %@ \n for object: %@",e,[result objectAtIndex:i]);
		}
	}
	[achievementsTable reloadData];
	[BLoadingView stopActivity];
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [self.achievementsArrayList count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
	static NSString *CellIdentifier = @"Cell";
   	int _gradientType = (indexPath.row % 2) ? GRADIENT_CELL_HEAD : GRADIENT_CELL_BODY;
	
	BTableViewCell *cell = (BTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil || TRUE) {
        cell = [[[BTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier andGradientType:_gradientType] autorelease];
    }	
	
	@try {

		UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(70, 10, 180, 20)];
		textLabel.text = [[self.achievementsArrayList objectAtIndex:indexPath.row] objectForKey:@"name"];
		textLabel.font = [UIFont systemFontOfSize:13];
		textLabel.backgroundColor = [UIColor clearColor];
		textLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;

		UILabel *detailTextLabel = [[UILabel alloc] initWithFrame:CGRectMake(70, 27, 180, 40)];
		detailTextLabel.text = [[self.achievementsArrayList objectAtIndex:indexPath.row] objectForKey:@"description"];
		detailTextLabel.font = [UIFont systemFontOfSize:12];
		detailTextLabel.numberOfLines = 2;
		detailTextLabel.textColor = [UIColor colorWithWhite:0 alpha:0.7];
		detailTextLabel.backgroundColor = [UIColor clearColor];
		detailTextLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		
		UILabel *bedollars = [[UILabel alloc] initWithFrame:CGRectMake(240, 10, 70, 20)];
		bedollars.text = @"Bedollars";
		bedollars.font = [UIFont systemFontOfSize:11];
		bedollars.textColor = [UIColor colorWithWhite:0 alpha:0.6];
		bedollars.backgroundColor = [UIColor clearColor];
		bedollars.textAlignment		= UITextAlignmentRight;
		bedollars.autoresizingMask	= UIViewAutoresizingFlexibleLeftMargin;
		bedollars.autoresizingMask	= UIViewAutoresizingFlexibleWidth;
		
		NSString *value = [NSString stringWithFormat:@"%@",[[self.achievementsArrayList objectAtIndex:indexPath.row] objectForKey:@"bedollarsValue"]]; 
		UILabel *bedollarsValue = [[UILabel alloc] initWithFrame:CGRectMake(240, 20, 70, 50)];
		bedollarsValue.text = [NSString stringWithFormat:@"+%@",value]; 
		bedollarsValue.font = [UIFont systemFontOfSize:20];
		bedollarsValue.textColor = [UIColor colorWithWhite:0 alpha:0.6];
		bedollarsValue.backgroundColor = [UIColor clearColor];
		bedollarsValue.textAlignment	= UITextAlignmentRight;
		bedollarsValue.autoresizingMask	= UIViewAutoresizingFlexibleLeftMargin;
		bedollarsValue.autoresizingMask	= UIViewAutoresizingFlexibleWidth;
		
		if ([value intValue] > 0) {
			[cell addSubview:bedollars];
			[cell addSubview:bedollarsValue];
		}

		BImageDownload *download = [self.achievementsImages objectAtIndex:indexPath.row];
		UIImage *cellImage  = download.image;

		UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(6, 6, 55, 55)];
		imageView.contentMode = UIViewContentModeScaleAspectFit;
		imageView.backgroundColor = [UIColor clearColor];
		[imageView setImage:cellImage];
		
		[cell addSubview:textLabel];
		[cell addSubview:detailTextLabel];
		[cell addSubview:imageView];

		[textLabel release];
		[detailTextLabel release];
		[imageView release];
		[bedollars release];
		[bedollarsValue release];
	}
	@catch (NSException * e) {
		//[_player logException:[NSString stringWithFormat:@"STACK: %@\n\nException: %@",[NSThread callStackSymbols],e]];
	}
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[achievementsTable deselectRowAtIndexPath:[achievementsTable indexPathForSelectedRow] animated:NO];
	[BPopup showPopupForAchievement:[achievementsArrayList objectAtIndex:indexPath.row] insideView:self.view];
}

#pragma mark -
#pragma mark BImageDownload Delegate Methods
- (void)bImageDownloadDidFinishDownloading:(BImageDownload *)download{
    NSUInteger index = [self.achievementsImages indexOfObject:download]; 
    NSUInteger indices[] = {0, index};
    NSIndexPath *path = [[NSIndexPath alloc] initWithIndexes:indices length:2];
    [achievementsTable reloadRowsAtIndexPaths:[NSArray arrayWithObject:path] withRowAnimation:UITableViewRowAnimationNone];
    [path release];
    download.delegate = nil;
}

- (void)bImageDownload:(BImageDownload *)download didFailWithError:(NSError *)error{
    NSLog(@"Beintoo - Image Loading Error: %@", [error localizedDescription]);
}

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
    _achievements.delegate   = nil;
    
    @try {
		[BLoadingView stopActivity];
	}
	@catch (NSException * e) {
	}
}

- (void)dealloc {
	[self.achievementsArrayList release];
	[self.achievementsImages	release];
	[_player release];
	[_achievements release];
    [super dealloc];
}

@end
