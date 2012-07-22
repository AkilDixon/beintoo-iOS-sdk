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

#import "BeintooFriendsListVC.h"
#import "Beintoo.h"
#import "BeintooMarketplaceSelectedItemVC.h"

@implementation BeintooFriendsListVC

@synthesize friendsTable, friendsArrayList, friendsImages, selectedFriend, vGood, startingOptions, backFromWebView, callerIstance, caller, callerIstanceSC;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil andOptions:(NSDictionary *)options {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
		self.startingOptions = options;
	}
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.title			 	= NSLocalizedStringFromTable(@"friends",@"BeintooLocalizable",@"Friends");
	noFriendsLabel.text		= NSLocalizedStringFromTable(@"nofriendslabel",@"BeintooLocalizable",@"");
	
	if ([[self.startingOptions objectForKey:@"caller"] isEqualToString:@"profile"]) 
		selectFriendLabel.text  = NSLocalizedStringFromTable(@"hereAreYourFriends",@"BeintooLocalizable",@"Select A Friend");
	else
		selectFriendLabel.text  = NSLocalizedStringFromTable(@"selectFriend",@"BeintooLocalizable",@"Select A Friend");

	[friendsView setTopHeight:45];
	[friendsView setBodyHeight:382];
	
	self.friendsTable.delegate	= self;
	self.friendsTable.rowHeight	= 60.0;	
	
	friendsArrayList = [[NSMutableArray alloc] init];
	friendsImages    = [[NSMutableArray alloc] init];
	
	user			= [[BeintooUser alloc] init];
	_player			= [[BeintooPlayer alloc] init];
	profileVC		= [BeintooProfileVC alloc];	
	
	vGood = [[BeintooVgood alloc] init];
	vGood.delegate = self;
}

- (void)viewWillAppear:(BOOL)animated{
    
    if(backFromWebView){
        callerIstance.needsToReloadData = YES;
        [self.navigationController popViewControllerAnimated:NO];
        
    }
    if ([caller isEqualToString:@"MarketplaceList"]){
        callerIstance.needsToReloadData = NO;
    }
    
    if ([caller isEqualToString:@"MarketplaceCoupon"]){
        
    }
    
    if ([BeintooDevice isiPad]) {
        [self setContentSizeForViewInPopover:CGSizeMake(320, 415)];
    }
    user.delegate	= self;

	[noFriendsLabel setHidden:YES];
	
	if (![Beintoo isUserLogged])
		[self.navigationController popToRootViewControllerAnimated:NO];
	else {
		[BLoadingView startActivity:self.view];
		[user getFriendsByExtid];	
		[self.friendsTable deselectRowAtIndexPath:[self.friendsTable indexPathForSelectedRow] animated:YES];
	}	
}

- (void)didGetFriendsByExtid:(NSMutableArray *)result{
	[friendsArrayList removeAllObjects];
	[friendsImages removeAllObjects];

	[noFriendsLabel setHidden:YES];

	if ([result count]<=0) {
		[noFriendsLabel setHidden:NO];
	}
	if ([result isKindOfClass:[NSArray class]]) {
		for (int i=0; i<[result count]; i++) {
			@try {
				NSMutableDictionary *friendsEntry = [[NSMutableDictionary alloc]init];
				NSString *nickname	 = [[result objectAtIndex:i] objectForKey:@"nickname"];
				NSString *userExt	 = [[result objectAtIndex:i] objectForKey:@"id"];
				NSString *userImgUrl = [[result objectAtIndex:i] objectForKey:@"usersmallimg"];
				
				BImageDownload *download = [[[BImageDownload alloc] init] autorelease];
				download.delegate = self;
				download.urlString = [[result objectAtIndex:i] objectForKey:@"usersmallimg"];
				
				[friendsEntry setObject:nickname forKey:@"nickname"];
				[friendsEntry setObject:userExt forKey:@"userExt"];
				[friendsEntry setObject:userImgUrl forKey:@"userImgUrl"];
				[friendsArrayList addObject:friendsEntry];
				[friendsImages addObject:download];
				[friendsEntry release];
			}
			@catch (NSException * e) {
				NSLog(@"BeintooException - FriendList: %@ \n for object: %@",e,[result objectAtIndex:i]);
				//[_player logException:[NSString stringWithFormat:@"STACK: %@\n\nException: %@",[NSThread callStackSymbols],e]];
			}
		}
	}

	[BLoadingView stopActivity];
	[friendsTable reloadData];
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [friendsArrayList count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
   	int _gradientType = (indexPath.row % 2) ? GRADIENT_CELL_HEAD : GRADIENT_CELL_BODY;
	
	BTableViewCell *cell = (BTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil || TRUE) {
        cell = [[[BTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier andGradientType:_gradientType] autorelease];
    }
	
	cell.textLabel.text  = [[self.friendsArrayList objectAtIndex:indexPath.row] objectForKey:@"nickname"];
	cell.textLabel.font	 = [UIFont systemFontOfSize:16];
	
	BImageDownload *download = [self.friendsImages objectAtIndex:indexPath.row];
	UIImage *cellImage  = download.image;
	cell.imageView.image = cellImage;

    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	selectedFriend = [self.friendsArrayList objectAtIndex:indexPath.row];
	
	// Act as "Send as a gift"
	if ([[self.startingOptions objectForKey:@"caller"] isEqualToString:@"sendAsAGift"]) 
		[self openSelectedFriendToSendAGift];
	
    // Act as "Marketplace Send as a gift"
	if ([[self.startingOptions objectForKey:@"caller"] isEqualToString:@"MarketplaceSendAsAGift"]) 
		[self openSelectedFriendToSendAGift];

	// Act as "New message"
	if ([[self.startingOptions objectForKey:@"caller"] isEqualToString:@"newMessage"]) 
		[self pickAFriendToSendMessage];
	
	// Act as "Friend list"
	if ([[self.startingOptions objectForKey:@"caller"] isEqualToString:@"profile"]) 
		[self pickaFriendToShowProfile];
}

- (void)openSelectedFriendToSendAGift {	
	[self.friendsTable deselectRowAtIndexPath:[self.friendsTable indexPathForSelectedRow] animated:YES];
	UIActionSheet	*popup = [[UIActionSheet alloc] initWithTitle:NSLocalizedStringFromTable(@"doYouFriend",@"BeintooLocalizable",@"") delegate:self 
											  cancelButtonTitle:@"No" 
										 destructiveButtonTitle:nil
											  otherButtonTitles:NSLocalizedStringFromTable(@"yes",@"BeintooLocalizable",@""),nil]; 
    if ([[self.startingOptions objectForKey:@"caller"] isEqualToString:@"MarketplaceSendAsAGift"])
        popup.tag = 111;
    else 
        popup.tag = 222;
    
	popup.actionSheetStyle = UIActionSheetStyleDefault;
	[popup showInView:[self.view superview]];
	[popup release];
}

- (void)pickaFriendToShowProfile {	
	[self.friendsTable deselectRowAtIndexPath:[self.friendsTable indexPathForSelectedRow] animated:YES];
	
	@try {
		NSDictionary *profileOptions = [NSDictionary dictionaryWithObjectsAndKeys:@"friendsProfile",@"caller",
																			[self.selectedFriend objectForKey:@"userExt"],@"friendUserID",
																			[self.selectedFriend objectForKey:@"nickname"],@"friendNickname",nil];
		[profileVC initWithNibName:@"BeintooProfileVC" bundle:[NSBundle mainBundle] andOptions:profileOptions];
		[self.navigationController pushViewController:profileVC animated:YES];
	}
	@catch (NSException * e) {
	}
}

- (void)pickAFriendToSendMessage {	
	[self.friendsTable deselectRowAtIndexPath:[self.friendsTable indexPathForSelectedRow] animated:YES];
	
	@try {
		if ([[self.startingOptions objectForKey:@"callerVC"] isKindOfClass:[BeintooNewMessageVC class]]){
			BeintooNewMessageVC *callingViewController = [self.startingOptions objectForKey:@"callerVC"];
			[callingViewController setSelectedFriend:self.selectedFriend];
			//[self dismissModalViewControllerAnimated:YES];
			[self.navigationController popViewControllerAnimated:YES];
		}
	}
	@catch (NSException * e) {
		
	}
}

#pragma mark -
#pragma mark actionSheet sendAsAGift

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	if (buttonIndex == 0) { // YES
		if (actionSheet.tag == 222){
            // Send as a gift call
            [BLoadingView startActivity:self.view];
            [vGood sendGoodWithID:[self.startingOptions objectForKey:@"vGoodID"] asGiftToUser:[self.selectedFriend objectForKey:@"userExt"]];
        }
        else {
            
            if ([caller isEqualToString:@"MarketplaceList"]){
                callerIstance.selectedFriend    = [selectedFriend objectForKey:@"userExt"];
                callerIstance.caller            = self.caller;
                callerIstance.selectedVgood     = startingOptions;
                
            }
            else if ([caller isEqualToString:@"MarketplaceSelectedCoupon"]){
                callerIstanceSC.selectedFriend          = [selectedFriend objectForKey:@"userExt"];
                callerIstanceSC.caller                  = self.caller;
                callerIstanceSC.vGoodToBeSentAsAGift    = startingOptions;
            }
            [startingOptions release];
            [self.navigationController popViewControllerAnimated:NO];
        }
	}else if (buttonIndex == 1) { // NO
		
	}
}

- (void)didSendVGoodAsGift:(BOOL)result{
	[BLoadingView stopActivity];
	
	if (result) {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:NSLocalizedStringFromTable(@"giftSent",@"BeintooLocalizable",@"Friends")
													   delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil]; 
		alert.tag = 1;
		[alert show];
		[alert release];
	}else {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil	message:NSLocalizedStringFromTable(@"giftNotSent",@"BeintooLocalizable",@"Friends")
													   delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil]; 
		alert.tag = 2;
		[alert show];
		[alert release];	
	}
}

#pragma mark -
#pragma mark UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex{ 
	if (buttonIndex == 0)
		if ([[self.startingOptions objectForKey:@"callerVC"] isKindOfClass:[BeintooWalletVC class]])
			[self.navigationController popViewControllerAnimated:YES];
		else {
			if (alertView.tag == 1) { // the vgood was correctly sent as a gift 
				[Beintoo dismissPrize];
			}
		}
}

#pragma mark -
#pragma mark BImageDownload Delegate Methods

- (void)bImageDownloadDidFinishDownloading:(BImageDownload *)download{
    NSUInteger index = [self.friendsImages indexOfObject:download]; 
    NSUInteger indices[] = {0, index};
    NSIndexPath *path = [[NSIndexPath alloc] initWithIndexes:indices length:2];
    [friendsTable reloadRowsAtIndexPaths:[NSArray arrayWithObject:path] withRowAnimation:UITableViewRowAnimationNone];
    [path release];
    download.delegate = nil;
}
- (void)bImageDownload:(BImageDownload *)download didFailWithError:(NSError *)error{
    NSLog(@"Beintoo - Image Loading Error: %@", [error localizedDescription]);
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
    user.delegate	= nil;

    @try {
		[BLoadingView stopActivity];
	}
	@catch (NSException * e) {
	}
}

- (void)viewDidDisappear:(BOOL)animated{
}

- (void)dealloc {
	[user release];
	[vGood release];
    [profileVC release];
	[friendsArrayList release];
	[friendsImages release];
	[_player release];
    [super dealloc];
}


@end
