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


#import "BeintooWalletVC.h"
#import "Beintoo.h"

@implementation BeintooWalletVC

@synthesize vGoodArrayList,walletImages,segControl;

- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.title = NSLocalizedStringFromTable(@"wallet",@"BeintooLocalizable",@"Wallet");
	
	[walletView setTopHeight:85];
	[walletView setBodyHeight:342];

	vWalletTable.delegate	= self;
	vWalletTable.rowHeight	= 75.0;
	walletLabel.text		= NSLocalizedStringFromTable(@"hereiswallet",@"BeintooLocalizable",@"");
	
	[segControl setTitle:NSLocalizedStringFromTable(@"tobeconverted",@"BeintooLocalizable",@"Pending") forSegmentAtIndex:0];
	[segControl setTitle:NSLocalizedStringFromTable(@"converted",@"BeintooLocalizable",@"Ongoing") forSegmentAtIndex:1];
    segControl.tintColor = [UIColor colorWithRed:108.0/255 green:128.0/255 blue:154.0/255 alpha:1];

	vGood			 = [[BeintooVgood alloc] init];
	_player			 = [[BeintooPlayer alloc] init];
	vgoodShowVC		 = [BeintooVGoodShowVC alloc];
	[vgoodShowVC setIsFromWallet:YES];
	friendsListVC	 = [BeintooFriendsListVC alloc];

	UIBarButtonItem *barCloseBtn = [[UIBarButtonItem alloc] initWithCustomView:[self closeButton]];
	[self.navigationItem setRightBarButtonItem:barCloseBtn animated:YES];
	[barCloseBtn release];
	
	self.vGoodArrayList = [[NSMutableArray alloc] init];
	self.walletImages   = [[NSMutableArray alloc]init];
}

- (void)viewWillAppear:(BOOL)animated{
    if ([BeintooDevice isiPad]) {
        [self setContentSizeForViewInPopover:CGSizeMake(320, 415)];
    }
    
    vGood.delegate	 = self;
    
    noGoodsLabel.text		= NSLocalizedStringFromTable(@"nogoodslabel",@"BeintooLocalizable",@"");
    if (![Beintoo userHasAllowedLocationServices]) {
        noGoodsLabel.text	= NSLocalizedStringFromTable(@"nogoodsnolocation",@"BeintooLocalizable",@"");
    }
    
    [self.vGoodArrayList removeAllObjects];
    [self.walletImages removeAllObjects];
    [vWalletTable reloadData];
    [noGoodsLabel setHidden:YES];
    [vWalletTable deselectRowAtIndexPath:[vWalletTable indexPathForSelectedRow] animated:YES];
    [BLoadingView startActivity:self.view];
    
    if (self.segControl.selectedSegmentIndex==0) {
        [vGood showGoodsByPlayerForState:TO_BE_CONVERTED];
    }
    else if (self.segControl.selectedSegmentIndex==1) {
        [vGood showGoodsByPlayerForState:CONVERTED];
    }
}

#pragma mark -
#pragma mark SegmentedControl

- (IBAction) segmentedControlIndexChanged{
	switch (self.segControl.selectedSegmentIndex) {
		case 0:{
			[BLoadingView stopActivity];
			[BLoadingView startActivity:self.view];
			[vGood showGoodsByPlayerForState:TO_BE_CONVERTED];
		}
			break;
		case 1:{
			[BLoadingView stopActivity];
			[BLoadingView startActivity:self.view];
			[vGood showGoodsByPlayerForState:CONVERTED];
		}
			break;
			
		default:
			break;
	}
}


#pragma mark -
#pragma mark Delegates
- (void)didGetAllvGoods:(NSArray *)vGoodList{
	[vWalletTable reloadData];
	[self.vGoodArrayList removeAllObjects];
	[self.walletImages removeAllObjects];
	[noGoodsLabel setHidden:YES];
	if ([vGoodList count] <= 0) {
		[noGoodsLabel setHidden:NO];
	}
	if ([vGoodList isKindOfClass:[NSDictionary class]]) {
		[noGoodsLabel setHidden:NO];
		[BLoadingView stopActivity];
		[vWalletTable reloadData];
		return;
	}
	
	for (int i=0; i<[vGoodList count]; i++) {
		@try {
			NSMutableDictionary *walletEntry = [[NSMutableDictionary alloc]init];
			NSString *name                   = [[vGoodList objectAtIndex:i] objectForKey:@"name"]; 
			NSString *vgoodid                = [[vGoodList objectAtIndex:i] objectForKey:@"id"]; 
			
			BImageDownload *download         = [[[BImageDownload alloc] init] autorelease];
			download.delegate                = self;
			download.urlString               = [[vGoodList objectAtIndex:i] objectForKey:@"imageSmallUrl"];
			
			NSString *showUrl                = [[vGoodList objectAtIndex:i] objectForKey:@"showURL"];
			NSString *endDate                = [[vGoodList objectAtIndex:i] objectForKey:@"enddate"];
		
			[walletEntry setObject:vgoodid forKey:@"id"];
			[walletEntry setObject:name forKey:@"name"];
			[walletEntry setObject:showUrl forKey:@"showURL"];
			[walletEntry setObject:endDate forKey:@"endDate"];
			[self.vGoodArrayList addObject:walletEntry];
			[self.walletImages addObject:download];
			[walletEntry release];
			[self.walletImages count];
		}
		@catch (NSException * e) {
			//[_player logException:[NSString stringWithFormat:@"STACK: %@\n\nException: %@",[NSThread callStackSymbols],e]];
			NSLog(@"BeintooException: %@ \n for object: %@",e,[vGoodList objectAtIndex:i]);
		}
	}
	[vWalletTable reloadData];
	[BLoadingView stopActivity];
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [self.vGoodArrayList count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
	static NSString *CellIdentifier = @"Cell";
   	int _gradientType = (indexPath.row % 2) ? GRADIENT_CELL_HEAD : GRADIENT_CELL_BODY;
	
	BTableViewCell *cell = (BTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil || TRUE) {
        cell = [[[BTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier andGradientType:_gradientType] autorelease];
    }	
	
	@try {
		NSString *localEndDate = [BeintooNetwork convertToCurrentDate:[[self.vGoodArrayList objectAtIndex:indexPath.row] objectForKey:@"endDate"]];

		UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 17, 230, 20)];
		textLabel.text = [[self.vGoodArrayList objectAtIndex:indexPath.row] objectForKey:@"name"];
		textLabel.font = [UIFont systemFontOfSize:14];
		textLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		textLabel.backgroundColor = [UIColor clearColor];

		UILabel *detailTextLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 37, 230, 20)];
		detailTextLabel.text = [NSString stringWithFormat:@"%@ %@",NSLocalizedStringFromTable(@"endDate",@"BeintooLocalizable",@"End Date"),localEndDate];
		detailTextLabel.font = [UIFont systemFontOfSize:12];
		detailTextLabel.backgroundColor = [UIColor clearColor];
		
		BImageDownload *download = [self.walletImages objectAtIndex:indexPath.row];
		UIImage *cellImage  = download.image;

		UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(7, 7, 60, 60)];
		imageView.contentMode = UIViewContentModeScaleAspectFit;
		imageView.backgroundColor = [UIColor clearColor];
		[imageView setImage:cellImage];
		
		[cell addSubview:textLabel];
		[cell addSubview:detailTextLabel];
		[cell addSubview:imageView];
		
		[textLabel release];
		[detailTextLabel release];
		[imageView release];
	}
	@catch (NSException * e) {
		//[_player logException:[NSString stringWithFormat:@"STACK: %@\n\nException: %@",[NSThread callStackSymbols],e]];
	}
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	if (self.segControl.selectedSegmentIndex==0) {
		UIActionSheet	*popup = [[UIActionSheet alloc] initWithTitle:nil 
														   delegate:self 
												  cancelButtonTitle:NSLocalizedStringFromTable(@"cancel",@"BeintooLocalizable",@"") 
											 destructiveButtonTitle:nil
												  otherButtonTitles:NSLocalizedStringFromTable(@"show",@"BeintooLocalizable",@""),NSLocalizedStringFromTable(@"sendAsGift",@"BeintooLocalizable",@""), nil ];
		
		popup.actionSheetStyle = UIActionSheetStyleDefault;
		popup.tag = indexPath.row;
		[popup showInView:[self.view superview]];
		[popup release];
		
	}else {
		[vgoodShowVC initWithNibName:@"BeintooVGoodShowVC" bundle:[NSBundle mainBundle] urlToOpen:[[self.vGoodArrayList objectAtIndex:indexPath.row] objectForKey:@"showURL"]];
		[self.navigationController pushViewController:vgoodShowVC animated:YES];
	}
}

#pragma mark -
#pragma mark UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	[vWalletTable deselectRowAtIndexPath:[vWalletTable indexPathForSelectedRow] animated:YES];
	if (buttonIndex == 0) { // --  GET IT REAL
		
		NSString *getRealURLWithLocation = [[self.vGoodArrayList objectAtIndex:actionSheet.tag] objectForKey:@"showURL"];
		NSString *locationParams = [Beintoo getUserLocationForURL];
		if (locationParams != nil) {
			getRealURLWithLocation = [getRealURLWithLocation stringByAppendingString:locationParams];
		}
		
		[vgoodShowVC initWithNibName:@"BeintooVGoodShowVC" bundle:[NSBundle mainBundle] urlToOpen:getRealURLWithLocation];
		[self.navigationController pushViewController:vgoodShowVC animated:YES];
	}else if (buttonIndex == 1) { // -- SEND AS A GIFT
		
		if ([[Beintoo getUserIfLogged]objectForKey:@"id"]!=nil){
			
			NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:[[self.vGoodArrayList objectAtIndex:actionSheet.tag] objectForKey:@"id"], @"vGoodID", @"sendAsAGift",@"caller",self,@"callerVC",nil];
			
			[friendsListVC  initWithNibName:@"BeintooFriendsListVC" bundle:[NSBundle mainBundle] andOptions:options];
			[self.navigationController pushViewController:friendsListVC animated:YES];
		}
        else{
            UIAlertView *av = [[UIAlertView alloc]initWithTitle:nil message:NSLocalizedStringFromTable(@"unableToSendAsAGift",@"BeintooLocalizable",@"Send as a gift") delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            [av show];
            [av release];
        }
	}
	else if (buttonIndex == 2){
		// CANCEL
	}
}

#pragma mark -
#pragma mark BImageDownload Delegate Methods
- (void)bImageDownloadDidFinishDownloading:(BImageDownload *)download{
    NSUInteger index = [self.walletImages indexOfObject:download]; 
    NSUInteger indices[] = {0, index};
    NSIndexPath *path = [[NSIndexPath alloc] initWithIndexes:indices length:2];
    [vWalletTable reloadRowsAtIndexPaths:[NSArray arrayWithObject:path] withRowAnimation:UITableViewRowAnimationNone];
    [path release];
    download.delegate = nil;
}
- (void)bImageDownload:(BImageDownload *)download didFailWithError:(NSError *)error{
    BeintooLOG(@"Beintoo - Image Loading Error: %@", [error localizedDescription]);
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return NO;
}

- (UIView *)closeButton{
    UIView *_vi = [[UIView alloc] initWithFrame:CGRectMake(-25, 5, 35, 35)];
    
    UIImageView *_imageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 15, 15)];
    _imageView.image = [UIImage imageNamed:@"bar_close_button.png"];
    _imageView.contentMode = UIViewContentModeScaleAspectFit;
	
    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
	closeBtn.frame = CGRectMake(6, 6.5, 35, 35);
    [closeBtn addSubview:_imageView];
	[closeBtn addTarget:self action:@selector(closeBeintoo) forControlEvents:UIControlEventTouchUpInside];
    
    [_vi addSubview:closeBtn];
	
    return _vi;
}

- (void)closeBeintoo{
    BeintooNavigationController *navController = (BeintooNavigationController *)self.navigationController;
    [Beintoo dismissBeintoo:navController.type];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    vGood.delegate   = nil;
    
    @try {
		[BLoadingView stopActivity];
	}
	@catch (NSException * e) {
	}
}

- (void)dealloc {
	[self.vGoodArrayList release];
	[self.walletImages	release];
	//[vGood release];
	[vgoodShowVC release];
	[_player release];
	[friendsListVC release];
    [super dealloc];
}

@end
