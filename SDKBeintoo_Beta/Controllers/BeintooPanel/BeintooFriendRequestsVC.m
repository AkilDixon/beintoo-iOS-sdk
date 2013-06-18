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

#import "BeintooFriendRequestsVC.h"
#import "Beintoo.h"

@implementation BeintooFriendRequestsVC

@synthesize elementsTable, elementsArrayList, selectedElement, elementsImages, startingOptions, isFromNotification;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil andOptions:(NSDictionary *)options
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
		self.startingOptions	= options;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	self.title			= NSLocalizedStringFromTable(@"friendRequests",@"BeintooLocalizable",@"Select A Friend");
	titleLabel.text		= NSLocalizedStringFromTable(@"friendReqTitle",@"BeintooLocalizable",@"");
	noResultLabel.text	= NSLocalizedStringFromTable(@"noRequest",@"BeintooLocalizable",@"");
	
	[friendsActionView setTopHeight:40];
	[friendsActionView setBodyHeight:387];
	
	_player					= [[BeintooPlayer alloc] init];
	_user					= [[BeintooUser	alloc] init];
	
	self.elementsArrayList  = [[NSMutableArray alloc] init];
	self.elementsImages	    = [[NSMutableArray alloc] init];
	
	friendsVC		= [BeintooFriendsListVC alloc];
	findFriendsVC	= [BeintooFindFriendsVC alloc];
			
	UIBarButtonItem *barCloseBtn = [[UIBarButtonItem alloc] initWithCustomView:[self closeButton]];
	[self.navigationItem setRightBarButtonItem:barCloseBtn animated:YES];
    
#ifdef BEINTOO_ARC_AVAILABLE
#else
    [barCloseBtn release];
#endif
	
	self.elementsTable.delegate		= self;
	self.elementsTable.dataSource   = self;
	self.elementsTable.rowHeight	= 60.0;	
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if ([BeintooDevice isiPad]) {
        [self setContentSizeForViewInPopover:CGSizeMake(320, 529)];
    }
    
    _user.delegate			= self;

	if (![Beintoo isUserLogged])
		[self.navigationController popToRootViewControllerAnimated:NO];
	else {
		[self.elementsArrayList removeAllObjects];
		[self.elementsTable reloadData];
		
		[BLoadingView startActivity:self.view];
		[_user getFriendRequests];		
	}
}

#pragma mark -
#pragma mark User_delegates

- (void)didGetFriendRequests:(NSMutableArray *)result
{	
	[self.elementsArrayList removeAllObjects];
	[self.elementsImages removeAllObjects];
	
	[noResultLabel setHidden:YES];
	
	if ([result count] <= 0) {
		[noResultLabel setHidden:NO];
	}
	if ([result isKindOfClass:[NSArray class]]) {
		for (int i = 0; i < [result count]; i++) {
			@try {
				NSMutableDictionary *friendsEntry = [[NSMutableDictionary alloc]init];
				NSString *nickname	 = [[result objectAtIndex:i] objectForKey:@"nickname"];
				NSString *userExt	 = [[result objectAtIndex:i] objectForKey:@"id"];
				NSString *userImgUrl = [[result objectAtIndex:i] objectForKey:@"usersmallimg"];
				
#ifdef BEINTOO_ARC_AVAILABLE
                BImageDownload *download = [[BImageDownload alloc] init];
#else
                BImageDownload *download = [[[BImageDownload alloc] init] autorelease];
#endif
				download.delegate = self;
				download.urlString = [[result objectAtIndex:i] objectForKey:@"usersmallimg"];
				
				[friendsEntry setObject:nickname forKey:@"nickname"];
				[friendsEntry setObject:userExt forKey:@"userExt"];
				[friendsEntry setObject:userImgUrl forKey:@"userImgUrl"];
				[self.elementsArrayList addObject:friendsEntry];
				[self.elementsImages addObject:download];
                
#ifdef BEINTOO_ARC_AVAILABLE
#else
                [friendsEntry release];
#endif
				
			}
			@catch (NSException * e) {
				BeintooLOG(@"BeintooException - FriendList: %@ \n for object: %@",e,[result objectAtIndex:i]);
            }
		}
	} 
	
	[BLoadingView stopActivity];
	[self.elementsTable reloadData];	
}

- (void)didGetFriendRequestResponse:(NSDictionary *)result
{	
    [BLoadingView stopActivity];
		
	NSString *successAlertMessage;
	if (friendResponseKind == USER_ACCEPT_FRIENDSHIP) 
		successAlertMessage = NSLocalizedStringFromTable(@"requestAccepted",@"BeintooLocalizable",@"");
	else 
		successAlertMessage = NSLocalizedStringFromTable(@"requestRefused",@"BeintooLocalizable",@"");
	
	NSString *alertMessage;
	if ([[result objectForKey:@"message"] isEqualToString:@"OK"]) 
		alertMessage = successAlertMessage;
	else
		alertMessage = NSLocalizedStringFromTable(@"requestNotSent",@"BeintooLocalizable",@"");
	UIAlertView *av = [[UIAlertView alloc] initWithTitle:nil message:alertMessage delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
	[av show];
    
#ifdef BEINTOO_ARC_AVAILABLE
#else
    [av release];
#endif
	
	[BLoadingView startActivity:self.view];
	[_user getFriendRequests];
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [self.elementsArrayList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{    
    static NSString *CellIdentifier = @"Cell";
   	int _gradientType = (indexPath.row % 2) ? GRADIENT_CELL_HEAD : GRADIENT_CELL_BODY;
	
	BTableViewCell *cell = (BTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil || TRUE) {
        
#ifdef BEINTOO_ARC_AVAILABLE
        cell = [[BTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier andGradientType:_gradientType];
#else
        cell = [[[BTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier andGradientType:_gradientType] autorelease];
#endif
        
    }
	
	cell.textLabel.text = [[self.elementsArrayList objectAtIndex:indexPath.row] objectForKey:@"nickname"];
	cell.textLabel.font	= [UIFont systemFontOfSize:16];
    cell.textLabel.backgroundColor  = [UIColor clearColor];
	
	BImageDownload *download = [self.elementsImages objectAtIndex:indexPath.row];
	UIImage *cellImage  = download.image;
	cell.imageView.image = cellImage;	
	
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	self.selectedElement = [self.elementsArrayList objectAtIndex:indexPath.row];
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	
	UIActionSheet *as = [[UIActionSheet alloc] initWithTitle:NSLocalizedStringFromTable(@"friendRequestFrom",@"BeintooLocalizable",@"")
													delegate:self 
										   cancelButtonTitle:NSLocalizedStringFromTable(@"cancel",@"BeintooLocalizable",@"")
									  destructiveButtonTitle:nil otherButtonTitles:NSLocalizedStringFromTable(@"acceptBtn",@"BeintooLocalizable",@""),
																				NSLocalizedStringFromTable(@"refuseBtn",@"BeintooLocalizable",@""),nil];
	as.actionSheetStyle = UIActionSheetStyleDefault;
	[as showInView:self.view];
    
#ifdef BEINTOO_ARC_AVAILABLE
#else
    [as release];
#endif
	
}

#pragma mark -
#pragma mark actionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{	
	if(buttonIndex == 0){ // Accept friend
		
        friendResponseKind = USER_ACCEPT_FRIENDSHIP;
		[BLoadingView startActivity:self.view];
		[_user replyToFriendshipRequestWithAnswer:USER_ACCEPT_FRIENDSHIP toUser:[self.selectedElement objectForKey:@"userExt"]];
	}
	if(buttonIndex == 1){ // Refuse friend
		
        friendResponseKind = USER_REFUSE_FRIENDSHIP;
		[BLoadingView startActivity:self.view];
		[_user replyToFriendshipRequestWithAnswer:USER_REFUSE_FRIENDSHIP toUser:[self.selectedElement objectForKey:@"userExt"]];
	}
	if(buttonIndex == 2){ // Cancel
	}
	[self.elementsTable deselectRowAtIndexPath:[self.elementsTable indexPathForSelectedRow] animated:YES];
}

#pragma mark -
#pragma mark BImageDownload Delegate Methods

- (void)bImageDownloadDidFinishDownloading:(BImageDownload *)download
{
    NSUInteger index = [self.elementsImages indexOfObject:download]; 
    NSUInteger indices[] = {0, index};
    NSIndexPath *path = [[NSIndexPath alloc] initWithIndexes:indices length:2];
    [self.elementsTable reloadRowsAtIndexPaths:[NSArray arrayWithObject:path] withRowAnimation:UITableViewRowAnimationNone];
    
#ifdef BEINTOO_ARC_AVAILABLE
#else
    [path release];
#endif
    
    download.delegate = nil;
}

- (void)bImageDownload:(BImageDownload *)download didFailWithError:(NSError *)error
{
    BeintooLOG(@"Beintoo - Image Loading Error: %@", [error localizedDescription]);
}


#if __IPHONE_OS_VERSION_MIN_REQUIRED < BEINTOO_IOS_6_0
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return NO;
}
#endif

- (UIView *)closeButton
{
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

- (void)closeBeintoo
{
    if (isFromNotification){
        if ([BeintooDevice isiPad]){
            [Beintoo dismissIpadNotifications];
        }
        else {
            if ([self respondsToSelector:@selector(dismissViewControllerAnimated:completion:)])
                [self dismissViewControllerAnimated:YES completion:nil];
            else
                [self dismissModalViewControllerAnimated:YES];
        }
    }
    else
        [Beintoo dismissBeintoo];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    _user.delegate			= nil;

    @try {
		[BLoadingView stopActivity];
	}
	@catch (NSException * e) {
	}
}

#ifdef BEINTOO_ARC_AVAILABLE
#else
- (void)dealloc {
	[_player release];
	[_user release];
	[friendsVC release];
	[self.elementsArrayList release];
	[self.elementsImages release];
	[titleLabel release];
    [super dealloc];
}
#endif

@end
