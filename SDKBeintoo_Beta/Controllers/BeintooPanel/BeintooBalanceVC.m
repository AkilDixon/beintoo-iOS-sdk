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

#import "BeintooBalanceVC.h"
#import "Beintoo.h"

@implementation BeintooBalanceVC

@synthesize elementsTable, elementsArrayList, elementsImages, selectedElement, startingOptions;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil andOptions:(NSDictionary *)options{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
		self.startingOptions	= options;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.title		= NSLocalizedStringFromTable(@"balance",@"BeintooLocalizable",@"");
	titleLabel.text = NSLocalizedStringFromTable(@"balanceTitle",@"BeintooLocalizable",@"");
	noBalanceLabel.text		= NSLocalizedStringFromTable(@"nobalancelabel",@"BeintooLocalizable",@"Select A Friend");
	
	[balanceView setTopHeight:40];
	[balanceView setBodyHeight:377];
	
	_user					= [[BeintooUser alloc] init];
	_player					= [[BeintooPlayer alloc] init];
	
	self.elementsArrayList = [[NSMutableArray alloc] init];
	self.elementsImages    = [[NSMutableArray alloc] init];	
	
	UIBarButtonItem *barCloseBtn = [[UIBarButtonItem alloc] initWithCustomView:[BeintooVC closeButton]];
	[self.navigationItem setRightBarButtonItem:barCloseBtn animated:YES];
	[barCloseBtn release];			
	
	self.elementsTable.delegate		= self;
	self.elementsTable.rowHeight	= 75.0;	
}

- (void)viewWillAppear:(BOOL)animated{
    if ([BeintooDevice isiPad]) {
        [self setContentSizeForViewInPopover:CGSizeMake(320, 415)];
    }
	[noBalanceLabel setHidden:YES];
    
    _user.delegate			= self;

	if (![Beintoo isUserLogged])
		[self.navigationController popToRootViewControllerAnimated:NO];
	else {
		[BLoadingView startActivity:self.view];
		[_user getBalanceFrom:0 andRowns:20];
	}
}

#pragma mark -
#pragma mark Delegates

- (void)didGetBalance:(NSMutableArray *)result{
	[self.elementsArrayList removeAllObjects];
	[self.elementsImages removeAllObjects];
	
	if ([result count]<=0) {
		[noBalanceLabel setHidden:NO];
	}
	
	for (int i=0; i<[result count]; i++) {
		@try {
			NSMutableDictionary *balanceEntry = [[NSMutableDictionary alloc]init];
			NSString *appName	 = [[[result objectAtIndex:i] objectForKey:@"app"] objectForKey:@"name"];
			NSString *movReason	 = [[result objectAtIndex:i] objectForKey:@"reason"];
			NSString *movValue	 = [[result objectAtIndex:i] objectForKey:@"value"];
			NSString *movDate	 = [[result objectAtIndex:i] objectForKey:@"creationdate"];
			
			BImageDownload *download = [[[BImageDownload alloc] init] autorelease];
			download.delegate = self;
			download.urlString = [[[result objectAtIndex:i] objectForKey:@"app"] objectForKey:@"imageSmallUrl"];
			
			[balanceEntry setObject:appName forKey:@"appName"];
			[balanceEntry setObject:movReason forKey:@"movReason"];
			[balanceEntry setObject:movValue forKey:@"movValue"];
			[balanceEntry setObject:movDate forKey:@"movDate"];
			[self.elementsArrayList addObject:balanceEntry];
			[self.elementsImages addObject:download];
			[balanceEntry release];
		}
		@catch (NSException * e) {
			NSLog(@"BeintooException: %@ \n for object: %@",e,[result objectAtIndex:i]);
		}
	}
	[BLoadingView stopActivity];
	[self.elementsTable reloadData];
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [self.elementsArrayList count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
   	int _gradientType = (indexPath.row % 2) ? GRADIENT_CELL_HEAD : GRADIENT_CELL_BODY;
	
	BTableViewCell *cell = (BTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil || TRUE) {
        cell = [[[BTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier andGradientType:_gradientType] autorelease];
    }
	
	UILabel *textLabel			= [[UILabel alloc] initWithFrame:CGRectMake(77, 8, 230, 20)];
	textLabel.text				= [[self.elementsArrayList objectAtIndex:indexPath.row] objectForKey:@"appName"];
	textLabel.font				= [UIFont systemFontOfSize:15];
	textLabel.textColor			= [UIColor colorWithWhite:0 alpha:0.7];
	textLabel.backgroundColor	= [UIColor clearColor];
	textLabel.autoresizingMask	= UIViewAutoresizingFlexibleWidth;
	
	UILabel *detailTextLabel			= [[UILabel alloc] initWithFrame:CGRectMake(77, 30, 230, 20)];
	detailTextLabel.text				= [[self.elementsArrayList objectAtIndex:indexPath.row] objectForKey:@"movDate"];
	detailTextLabel.font				= [UIFont systemFontOfSize:12];
	detailTextLabel.textColor			= [UIColor colorWithWhite:0 alpha:0.7];
	detailTextLabel.backgroundColor		= [UIColor clearColor];
	detailTextLabel.autoresizingMask	= UIViewAutoresizingFlexibleWidth;
	
	UILabel *detailTextLabel2			= [[UILabel alloc] initWithFrame:CGRectMake(77, 46, 230, 20)];
	NSString *movReason					= NSLocalizedStringFromTable([[self.elementsArrayList objectAtIndex:indexPath.row] objectForKey:@"movReason"],@"BeintooLocalizable",@"Select A Friend");
	detailTextLabel2.text				= movReason;
	detailTextLabel2.font				= [UIFont systemFontOfSize:12];
	detailTextLabel2.textColor			= [UIColor colorWithWhite:0 alpha:0.7];
	detailTextLabel2.backgroundColor	= [UIColor clearColor];
	detailTextLabel2.autoresizingMask	= UIViewAutoresizingFlexibleWidth;
	
	UILabel *movValue			= [[UILabel alloc] initWithFrame:CGRectMake(250, 10, 50, 50)];
	NSString *value				= [NSString stringWithFormat:@"%@",[[self.elementsArrayList objectAtIndex:indexPath.row] objectForKey:@"movValue"]];
	if ([value rangeOfString:@"-"].length <= 0) {
		value = [NSString stringWithFormat:@"+%@",value];
	}
	movValue.text				= value;
	movValue.font				= [UIFont systemFontOfSize:21];
	movValue.textColor			= [UIColor colorWithWhite:0 alpha:0.7];
	movValue.backgroundColor	= [UIColor clearColor];
	movValue.autoresizingMask	= UIViewAutoresizingFlexibleWidth;
	movValue.textAlignment		= UITextAlignmentRight;
	movValue.autoresizingMask	= UIViewAutoresizingFlexibleLeftMargin;
	
	BImageDownload *download	= [self.elementsImages objectAtIndex:indexPath.row];
	UIImage *cellImage			= download.image;
	
	UIImageView *imageView		= [[UIImageView alloc]initWithFrame:CGRectMake(7, 10, 50, 50)];
	imageView.contentMode		= UIViewContentModeScaleAspectFit;
	imageView.backgroundColor	= [UIColor clearColor];
	[imageView setImage:cellImage];
	
	[cell addSubview:textLabel];
	[cell addSubview:detailTextLabel];
	[cell addSubview:detailTextLabel2];
	[cell addSubview:movValue];
	[cell addSubview:imageView];
	
	[textLabel release];
	[detailTextLabel release];
	[imageView release];
	[detailTextLabel2 release];
	[movValue release];
	
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	//self.selectedFriend = [self.friendsArrayList objectAtIndex:indexPath.row];
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark -
#pragma mark BImageDownload Delegate Methods

- (void)bImageDownloadDidFinishDownloading:(BImageDownload *)download{
    NSUInteger index = [self.elementsImages indexOfObject:download]; 
    NSUInteger indices[] = {0, index};
    NSIndexPath *path = [[NSIndexPath alloc] initWithIndexes:indices length:2];
    [self.elementsTable reloadRowsAtIndexPaths:[NSArray arrayWithObject:path] withRowAnimation:UITableViewRowAnimationNone];
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
    _user.delegate      = nil;
    
    @try {
		[BLoadingView stopActivity];
	}
	@catch (NSException * e) {
	}
}

- (void)dealloc {
	[_user release];
	[_player release];
	[self.elementsArrayList release];
	[self.elementsImages release];
    [super dealloc];
}


@end
