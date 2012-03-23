/*******************************************************************************
 * Copyright 2011 Beintoo - author gpiazzese@beintoo.com
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

#import "BeintooMarketplaceVC.h"
#import "BeintooMarketplaceSelectedItemVC.h"
#import "BImageCache.h"

@implementation BeintooMarketplaceVC
@synthesize selectedDictionary, table, reloading, refreshHeaderView, needsToReloadData, caller, selectedFriend, selectedVgood, mainSegmentedControl, childSegmentedControl, homeView, nickLabel, bedollarsLabel, magnifierButton, bodyView, couponName, couponActivity, couponBedollars, couponCloseButton, couponDescription, couponEnddate, couponGetButton, couponImageView, couponSendButton, couponSubView, couponView, couponYouAreGoingToBuyLabel, noMoneyActivity, noMoneyMessage, noMoneySubView, noMoneyImageView, noMoneyCouponCost, noMoneyCouponName, noMoneyCloseButton, noMoneyCouponEnddate, noMoneyCouponDescription;

#ifdef UI_USER_INTERFACE_IDIOM
@synthesize popOverController,loginPopoverController;
#endif

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)dealloc{
    //[selectedDictionary release];
    [marketplaceContent release];
    [marketplaceImages release];
    [_marketplace release];
    [_user release];
    [_vgood release];
    [vgoodShowVC release];
    [friendsListVC release];
    [currentKind release];
    [currentCategory release];
    [currentSorting release];
    [buttonsArray release];
    [loginVC release];
    [loginNavController release];
    [activity release];
    [super dealloc];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UILabel *titleLabel             = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 160, 44)];
    titleLabel.text                 = NSLocalizedStringFromTable(@"MPmarketplaceTitle",@"BeintooLocalizable",@"Marketplace");
    titleLabel.backgroundColor      = [UIColor clearColor];
    titleLabel.textColor            = [UIColor whiteColor];
    titleLabel.textAlignment        = UITextAlignmentCenter;
    titleLabel.font                 = [UIFont boldSystemFontOfSize:20.0];
    self.navigationItem.titleView   = titleLabel;
    [titleLabel release];
    
    _marketplace                =   [[BeintooMarketplace alloc] init];
    _user                       =   [[BeintooUser alloc] init];
    _vgood                      =   [[BeintooVgood alloc] init];
    
    marketplaceContent          =   [[NSMutableArray alloc] init];
    marketplaceImages           =   [[NSMutableArray alloc] init];
    
    buttonsArray                =   [[NSMutableArray alloc] init];
    options                     =   [[NSDictionary alloc] init];
    
    currentKind                 =   [[NSString alloc] init];
    currentSorting              =   [[NSString alloc] init];
    currentCategory             =   [[NSString alloc] init];
    
    loginVC                     = [[BeintooLoginVC alloc] initWithNibName:@"BeintooLoginVC" bundle:[NSBundle mainBundle]];
    
    UIColor *barColor           = [UIColor colorWithRed:108.0/255 green:128.0/255 blue:154.0/255 alpha:1.0];
	loginNavController          = [[UINavigationController alloc] initWithRootViewController:loginVC];
	[[loginNavController navigationBar] setTintColor:barColor];
    
    vgoodShowVC                     = [[BeintooVGoodShowVC alloc] initWithNibName:@"BeintooVGoodShowVC" bundle:[NSBundle mainBundle]];
    friendsListVC                   = [[BeintooFriendsListVC alloc] initWithNibName:@"BeintooFriendsListVC" bundle:[NSBundle mainBundle]];
    
    [homeView setTopHeight:33.0f];
	[homeView setBodyHeight:403.0f];	
    homeView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;

    //-------> semitransparent view <-------
    couponView.alpha            = 0.0f;
    [self.view addSubview:couponView];
    
    //-------> coupon view implementation <-------
    [couponSubView setTopHeight:28.0f];
	[couponSubView setBodyHeight:152.0f];
    
    //-------> no money coupon view implementation <-------
    [noMoneySubView setTopHeight:28.0f];
	[noMoneySubView setBodyHeight:152.0f];
        
    table.frame                = CGRectMake(table.frame.origin.x, childSegmentedControl.frame.origin.y, table.frame.size.width, bodyView.frame.size.height - 10 - mainSegmentedControl.frame.size.height + childSegmentedControl.frame.size.height - 35);
    
    mainSegmentedControl.selectedSegmentIndex = 1;
    [mainSegmentedControl setTitle:NSLocalizedStringFromTable(@"MPmainSegmentedIndexTitle0",@"BeintooLocalizable",@"Marketplace") forSegmentAtIndex:0];
    [mainSegmentedControl setTitle:NSLocalizedStringFromTable(@"MPmainSegmentedIndexTitle1",@"BeintooLocalizable",@"Marketplace") forSegmentAtIndex:1];
    [mainSegmentedControl setTitle:NSLocalizedStringFromTable(@"MPmainSegmentedIndexTitle2",@"BeintooLocalizable",@"Marketplace") forSegmentAtIndex:2];
    
    childSegmentedControl.hidden = YES;
    [childSegmentedControl setTitle:NSLocalizedStringFromTable(@"MPchildSegmentedIndexTitle0",@"BeintooLocalizable",@"Marketplace") forSegmentAtIndex:0];
    [childSegmentedControl setTitle:NSLocalizedStringFromTable(@"MPchildSegmentedIndexTitle1",@"BeintooLocalizable",@"Marketplace") forSegmentAtIndex:1];
    
    UIBarButtonItem *barCloseBtn = [[UIBarButtonItem alloc] initWithCustomView:[BeintooMarketplaceVC closeButton]];
	[self.navigationItem setRightBarButtonItem:barCloseBtn animated:YES];
	[barCloseBtn release];	
    
    couponYouAreGoingToBuyLabel.text = NSLocalizedStringFromTable(@"MPyouAreGoingToBuy", @"BeintooLocalizable", nil);
    
    UIImageView *rateImgViews           = [[UIImageView alloc] initWithFrame:CGRectMake(6.5, 6.5, 15, 15)];
    rateImgViews.backgroundColor        = [UIColor clearColor];
    rateImgViews.image                  = [UIImage imageNamed:@"exit.png"];
    rateImgViews.contentMode            = UIViewContentModeScaleAspectFit;
    [couponCloseButton addSubview:rateImgViews];
    [rateImgViews release];
    
    UIImageView *rateImgViews1           = [[UIImageView alloc] initWithFrame:CGRectMake(6.5, 6.5, 15, 15)];
    rateImgViews1.backgroundColor        = [UIColor clearColor];
    rateImgViews1.image                  = [UIImage imageNamed:@"exit.png"];
    rateImgViews1.contentMode            = UIViewContentModeScaleAspectFit;
    [noMoneyCloseButton addSubview:rateImgViews1];
    [rateImgViews1 release];

    isLoadMoreActive = YES;
    needsToReloadData = YES;
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    for (UIView *_subviews in [couponView subviews]){
        [_subviews removeFromSuperview];
    }
    couponView.alpha = 0.0f;
    
    if (refreshHeaderView == nil) {
        refreshHeaderView                       = [[BRefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - self.table.bounds.size.height, 320.0f, self.table.bounds.size.height)];
        refreshHeaderView.backgroundColor       = [UIColor colorWithRed:226.0/255.0 green:231.0/255.0 blue:237.0/255.0 alpha:1.0];
        refreshHeaderView.bottomBorderThickness = 1.0;
        [self.table addSubview:refreshHeaderView];
        self.table.showsVerticalScrollIndicator = YES;
        [refreshHeaderView release];
    }
    else {
        [self dataSourceLoadingError];
    }

    if ([BeintooDevice isiPad]) {
        [self setContentSizeForViewInPopover:CGSizeMake(320, 415)];
    }
    
    if ([caller isEqualToString:@"MarketplaceList"]){
        
        NSString *getRealURLWithLocation    = [NSString stringWithFormat:@"%@", [[self.selectedVgood objectForKey:@"vGood"] objectForKey:@"getRealURL"]];
        NSString *locationParams            = [Beintoo getUserLocationForURL];
        if (locationParams != nil) {
            getRealURLWithLocation          = [getRealURLWithLocation stringByAppendingString:locationParams];
        }
        NSString *elementsToSend            = [NSString stringWithFormat:@"&guid=%@", [Beintoo getPlayerID]];
        getRealURLWithLocation              = [getRealURLWithLocation stringByAppendingString:elementsToSend];
        
        if ([Beintoo isVirtualCurrencyStored]){
            float currentCurrencyAmount     = [Beintoo getVirtualCurrencyBalance];
            float currentCost               = [[[self.selectedVgood objectForKey:@"vGood"] objectForKey:@"virtualCurrencyPrice"] floatValue];
            float totalCurrentCurrencyAmount = currentCurrencyAmount - currentCost;
            
            [Beintoo setVirtualCurrencyBalance:totalCurrentCurrencyAmount];
            
            getRealURLWithLocation          = [getRealURLWithLocation stringByAppendingFormat:@"&developer_user_guid=%@", [Beintoo getDeveloperUserId]];
            
        }
        
        vgoodShowVC.urlToOpen               = getRealURLWithLocation;
        vgoodShowVC.caller                  = @"MarketplaceList";
        vgoodShowVC.callerIstanceMP         = self;
        [self.navigationController pushViewController:vgoodShowVC animated:YES];
        
        caller                              = nil;
        selectedFriend                      = nil;
        selectedVgood                       = nil;
        
    }
    
    [table deselectRowAtIndexPath:[table indexPathForSelectedRow] animated:NO];
    
    _marketplace.delegate                   = self;
    _user.delegate                          = self;
    _vgood.delegate                         = self;
    
    [self dismissFeatureSignupView];
    
    if ([Beintoo isVirtualCurrencyStored]){
       
        bedollarsLabel.hidden           = NO;
        nickLabel.hidden                = NO;
        
        nickLabel.text                  = NSLocalizedStringFromTable(@"MPcredits", @"BeintooLocalizable", @"Marketplace"); 
        bedollarsLabel.text             = [NSString stringWithFormat:@"%@ %@", [NSString stringWithFormat:@"%.2f", [Beintoo getVirtualCurrencyBalance]], [Beintoo getVirtualCurrencyName]];
    }
    else{
        if (![Beintoo isUserLogged]){
            bedollarsLabel.hidden           = YES;
            nickLabel.hidden                = YES;
        }
        else {
            bedollarsLabel.hidden           = NO;
            nickLabel.hidden                = NO;
            nickLabel.text                      = NSLocalizedStringFromTable(@"MPcredits", @"BeintooLocalizable", @"MarketplaceSelectedItem"); 
            @try {
                NSDictionary *currentUser   = [Beintoo getUserIfLogged];
                bedollarsLabel.text         = [NSString stringWithFormat:@"%@ %@",[currentUser objectForKey:@"bedollars"], NSLocalizedStringFromTable(@"bedollars", @"BeintooLocalizable", @"Marketplace")];
            }
            @catch (NSException *e) {
                NSLog(@"exception");
            }
        }
    }
    
    @try {
        [BLoadingView stopActivity];
    }
    @catch (NSException *exception) {
        NSLog(@"exception");
    }
    
    if (needsToReloadData == YES){
            
        [self hideWithAnimationForView:couponView];
        
        isLoadMoreActive                    = YES;
        isNewSearch                         = YES;
        
        
        
        [BLoadingView startFullScreenActivity:self.view];
        
        if (isNewSearch == YES){
            totalRows = 0;
            [marketplaceContent removeAllObjects];
            [marketplaceImages removeAllObjects];
            [buttonsArray removeAllObjects];
            [table reloadData];
        }
        
        if (mainSegmentedControl.selectedSegmentIndex == 1){
            [self showChildSegment];
            childSegmentedControl.hidden    = NO;
            
            if (childSegmentedControl.selectedSegmentIndex == 0){
                //-------> Top Sales
                currentKind                 = KIND_NATIONAL_TOPSOLD;
                currentSorting              = SORT_PRICE;
                [_marketplace getMarketplaceContentForKind:KIND_NATIONAL_TOPSOLD andStart:totalRows andNumberOfRows:TOTAL_ROWS_INCREMENT andSorting:SORT_PRICE];
            }
            else {
                //-------> Categories
                isLoadMoreActive            = NO;
                currentKind                 = CATEGORY_KIND;
                [_marketplace getMarketplaceCategories];
            }
        }
        else {
            if (mainSegmentedControl.selectedSegmentIndex == 0){
                currentKind                 = KIND_FEATURED;
                currentSorting              = SORT_PRICE;
                [_marketplace getMarketplaceContentForKind:KIND_FEATURED andStart:totalRows andNumberOfRows:TOTAL_ROWS_INCREMENT andSorting:SORT_PRICE];
            }
            else if(mainSegmentedControl.selectedSegmentIndex == 2){
                currentKind                 = KIND_AROUND_ME;
                currentSorting              = SORT_DISTANCE;
                [_marketplace getMarketplaceContentForKind:KIND_AROUND_ME andStart:totalRows andNumberOfRows:TOTAL_ROWS_INCREMENT andSorting:SORT_DISTANCE];
            }
        }
    }
    needsToReloadData = YES;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    _marketplace.delegate                   = nil;
    _user.delegate                          = nil;
    _vgood.delegate                         = nil; 
    
    @try {
        for (UIView *view in self.view.subviews){
            if ([view isKindOfClass:[BLoadingView class]] == YES){
                [view removeFromSuperview];
            }
        }
    }
    @catch (NSException *exception) {
        
    }

}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return NO;
}

#pragma mark - Beintoo delegates

- (void)didMarketplaceGotContent:(NSMutableArray *)result{
    if (isNewSearch == YES){
        [marketplaceContent removeAllObjects];
        [marketplaceImages removeAllObjects];
        [buttonsArray removeAllObjects];
    }
    
    @try {
        if ([result count] < TOTAL_ROWS_INCREMENT || [result count] == 0){
            isLoadMoreActive                = NO;
        }
        for (int i = 0; i < [result count]; i++){
            BImageCache *imageCache = [[[BImageCache alloc] init] autorelease];
            if ([imageCache isRemoteFileCached:[[result objectAtIndex:i] objectForKey:@"imageSmallUrl"]]){
               [marketplaceImages addObject:[imageCache getCachedRemoteFile:[[result objectAtIndex:i] objectForKey:@"imageSmallUrl"]]];
            }
            else {
                BImageDownload *download        = [[[BImageDownload alloc] init] autorelease];
                download.delegate               = self;
                //download.idImg                  = [[result objectAtIndex:i] objectForKey:@"id"];
                download.urlString              = [[result objectAtIndex:i] objectForKey:@"imageSmallUrl"];
                [marketplaceImages addObject:download];
                
            }
            
            [buttonsArray addObject:@"Hidden"];
            [marketplaceContent addObject:[result objectAtIndex:i]];
        }
    }
    @catch (NSException *exception) {
        NSLog(@"Exception on marketplace filling in");
    }
        
    totalRows                               = [marketplaceContent count];
    [self performSelector:@selector(dataSourceDidFinishLoadingNewData) withObject:nil afterDelay:0.0];
    if (isNewSearch == YES){
        [table scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:NO];
    }

    @try {
        if (activity)
            [activity stopAnimating];
        
        [BLoadingView stopActivity];
    }
    @catch (NSException *exception) {
        NSLog(@"Exception after Marketplace data was received: %@", exception);
    }
}

- (void)didNotMarketplaceGotContent{
    NSLog(@"BEINTOO ERROR: error while getting content");
    [marketplaceContent removeAllObjects];
    [marketplaceImages removeAllObjects];
    [buttonsArray removeAllObjects];
    
    [self dataSourceLoadingError];
    //[self performSelector:@selector(dataSourceLoadingError) withObject:nil afterDelay:1.0f];
    
    @try {
        [BLoadingView stopActivity];
    }
    @catch (NSException *exception) {
        NSLog(@"Error Exception after Marketplace data was NOT received: %@", exception);
    }
    
}

- (void)didMarketplaceGotCategories:(NSMutableArray *)result{
    
    [marketplaceContent removeAllObjects];
    [marketplaceImages removeAllObjects];
    [buttonsArray removeAllObjects];
    
    @try {
       
        for (int i = 0; i < [result count]; i++){
            
            BImageCache *imageCache = [[[BImageCache alloc] init] autorelease];
            if ([imageCache isRemoteFileCached:[[result objectAtIndex:i] objectForKey:@"imageSmallUrl"]]){
                [marketplaceImages addObject:[imageCache getCachedRemoteFile:[NSString stringWithFormat:@"http://static.beintoo.com/sdk/marketplace_categories/%@.png", [[result objectAtIndex:i] objectForKey:@"id"]]]];
            }
            else {
                BImageDownload *download        = [[[BImageDownload alloc] init] autorelease];
                download.delegate               = self;
                download.urlString              = [NSString stringWithFormat:@"http://static.beintoo.com/sdk/marketplace_categories/%@.png", [[result objectAtIndex:i] objectForKey:@"id"]];
                [marketplaceImages addObject:download];
                
            }
            [marketplaceContent addObject:[result objectAtIndex:i]];
            [buttonsArray addObject:@"no"];
        }
    }
    @catch (NSException *exception) {
        NSLog(@"Exception after Marketplace categories were received: %@", exception);
    }
    
    totalRows = [marketplaceContent count];
    
    [BLoadingView stopActivity];
    [self performSelector:@selector(dataSourceDidFinishLoadingNewData) withObject:nil afterDelay:0.0];
    if (isNewSearch == YES){
        [table scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:NO];
    }   
    
}

- (void)didNotMarketplaceGotCategories{
    NSLog(@"BEINTOO ERROR: error while getting categories");
    [marketplaceContent removeAllObjects];
    [marketplaceImages removeAllObjects];
    [buttonsArray removeAllObjects];
    
    [self dataSourceLoadingError];
    
    @try {
        for (UIView *view in self.view.subviews){
            if ([view isKindOfClass:[BLoadingView class]] == YES){
                [view removeFromSuperview];
            }
        }
        [BLoadingView stopActivity];
    }
    @catch (NSException *exception) {
        NSLog(@"Error Exception after Marketplace data was NOT received: %@", exception);
    }   
    
}


- (void)didMarketplaceGotCategoryContent{
    [marketplaceContent removeAllObjects];
    [marketplaceImages removeAllObjects];
    [buttonsArray removeAllObjects];
    
    [self performSelector:@selector(dataSourceDidFinishLoadingNewData) withObject:nil afterDelay:0.0];
    @try {
        for (UIView *view in self.view.subviews){
            if ([view isKindOfClass:[BLoadingView class]] == YES){
                [view removeFromSuperview];
            }
        }
        [BLoadingView stopActivity];
    }
    @catch (NSException *exception) {
        NSLog(@"Error Exception after Marketplace categories were NOT received: %@", exception);
    }
    
}

- (void)didNotMarketplaceGotCategoryContent{
    
    NSLog(@"BEINTOO ERROR: error while getting category content");
    [marketplaceContent removeAllObjects];
    [marketplaceImages removeAllObjects];
    [buttonsArray removeAllObjects];
    
   [self dataSourceLoadingError];
    
    @try {
        for (UIView *view in self.view.subviews){
            if ([view isKindOfClass:[BLoadingView class]] == YES){
                [view removeFromSuperview];
            }
        }
    }
    @catch (NSException *exception) {
        NSLog(@"Error Exception after Marketplace categories were NOT received: %@", exception);
    }
    
}


- (void)didGetUserByUDID:(NSMutableArray *)result{
    @synchronized(self){
        [Beintoo setLastLoggedPlayers:[(NSArray *)result retain]];        
        [BLoadingView stopActivity]; 
        
        needsToReloadData = NO;
        loginVC.caller = @"MarketplaceList";
        loginVC.callerIstance = self;
        
        if([BeintooDevice isiPad]){ // --- iPad, we need to show the "Login Popover"
            [Beintoo launchIpadLogin];
        }
        else {
            [self presentModalViewController:loginNavController animated:YES];
        }
    }	
}

#pragma mark - UISegmentedControl methods

- (IBAction)changeMainSegmentedValue{
    isLoadMoreActive = YES;
    isNewSearch = YES;
    
    @try {
        [marketplaceContent removeAllObjects];
        [marketplaceImages removeAllObjects];
        [buttonsArray removeAllObjects];
    }
    @catch (NSException *exception) {
        NSLog(@"Exception on removing array objects");
    }
    
    if (isNewSearch == YES){
        totalRows = 0;
       // [table setHidden:YES];
    }
    
    mainSegmentedControl.userInteractionEnabled = NO;
    if (mainSegmentedControl.selectedSegmentIndex == 1){
        [self showChildSegment];
        childSegmentedControl.hidden = NO;
        
        @try {
            [BLoadingView stopActivity];
            [BLoadingView startFullScreenActivity:self.view];
        }
        @catch (NSException *exception) {
            
        }

        if (childSegmentedControl.selectedSegmentIndex == 0){
            //-------> Top Sales
            currentKind = KIND_NATIONAL_TOPSOLD;
            currentSorting = SORT_PRICE;
            [_marketplace getMarketplaceContentForKind:KIND_NATIONAL_TOPSOLD andStart:totalRows andNumberOfRows:TOTAL_ROWS_INCREMENT andSorting:SORT_PRICE];
        }
        else {
            //-------> Categories
            isLoadMoreActive = NO;
            currentKind = CATEGORY_KIND;
            [_marketplace getMarketplaceCategories];
        }
    }
    else {
        
        [self hideChildSegment];
       
        if (mainSegmentedControl.selectedSegmentIndex == 0){
           
            @try {
                [BLoadingView stopActivity];
                [BLoadingView startFullScreenActivity:self.view];
            }
            @catch (NSException *exception) {
                
            }
            currentKind = KIND_FEATURED;
            currentSorting = SORT_PRICE;
            [_marketplace getMarketplaceContentForKind:KIND_FEATURED andStart:totalRows andNumberOfRows:TOTAL_ROWS_INCREMENT andSorting:SORT_PRICE];
        }
        else if(mainSegmentedControl.selectedSegmentIndex == 2){
            @try {
                [BLoadingView stopActivity];
                [BLoadingView startFullScreenActivity:self.view];
            }
            @catch (NSException *exception) {
                
            }
            
            currentKind = KIND_AROUND_ME;
            currentSorting = SORT_DISTANCE;
            [_marketplace getMarketplaceContentForKind:KIND_AROUND_ME andStart:totalRows andNumberOfRows:TOTAL_ROWS_INCREMENT andSorting:SORT_DISTANCE];
            
        }
    }
    mainSegmentedControl.userInteractionEnabled = YES;
    
    
}

- (IBAction)changeChildSegmentedValue{
    childSegmentedControl.userInteractionEnabled = NO;
    isNewSearch = YES;
    isLoadMoreActive = YES;
    
    @try {
        [marketplaceContent removeAllObjects];
        [marketplaceImages removeAllObjects];
        [buttonsArray removeAllObjects];
    }
    @catch (NSException *exception) {
        NSLog(@"Exception on removing array objects");
    }
    
    if (isNewSearch == YES){
        totalRows = 0;
        //[table setHidden:YES];
    }
    
    @try {
        [BLoadingView stopActivity];
        [BLoadingView startFullScreenActivity:self.view];
    }
    @catch (NSException *exception) {
        
    }
    
    if (childSegmentedControl.selectedSegmentIndex == 0){
        
        currentKind = KIND_NATIONAL_TOPSOLD;
        currentSorting = SORT_PRICE;
        [_marketplace getMarketplaceContentForKind:KIND_NATIONAL_TOPSOLD andStart:totalRows andNumberOfRows:totalRows + TOTAL_ROWS_INCREMENT andSorting:SORT_PRICE];
        
    }
    else {
        isLoadMoreActive = NO;
        currentKind = CATEGORY_KIND;
        [_marketplace getMarketplaceCategories];
    }
    childSegmentedControl.userInteractionEnabled = YES;
}

- (void)searchMarketplaceContentForCurrentSorting:(id)sender{

    isLoadMoreActive = YES;
    isNewSearch = YES;
    
    @try {
        [marketplaceContent removeAllObjects];
        [marketplaceImages removeAllObjects];
        [buttonsArray removeAllObjects];
    }
    @catch (NSException *exception) {
        NSLog(@"Exception on removing array objects");
    }
    
    if (isNewSearch == YES){
        totalRows = 0;
    }
    
    @try {
        [BLoadingView stopActivity];
        [BLoadingView startFullScreenActivity:self.view];
    }
    @catch (NSException *exception) {
        
    }
    
    int _kind;
    if (currentKind == KIND_FEATURED)
        _kind = 0;
    else if (currentKind == KIND_NATIONAL_TOPSOLD)
        _kind = 1;
    else if (currentKind == CATEGORY_KIND)
        _kind = 2;
    else if (currentKind == SUB_CATEGORY_KIND)
        _kind = 3;
    else if (currentKind == KIND_AROUND_ME)
        _kind = 4;
    
    NSString  *_sorting;
    if ([sender tag] == 1)
        _sorting = SORT_PRICE;
    else if ([sender tag] == 2)
        _sorting = SORT_PRICE_ASC;
    else if ([sender tag] == 3)
        _sorting = SORT_DISTANCE;
    
    switch (_kind) {
            
        case 0:
           
            //currentKind = KIND_FEATURED;
            currentSorting = _sorting;
            [_marketplace getMarketplaceContentForKind:currentKind andStart:totalRows andNumberOfRows:TOTAL_ROWS_INCREMENT andSorting:_sorting];
            
            break;
            
        case 1:
            
            //currentKind = KIND_NATIONAL_TOPSOLD;
            currentSorting = _sorting;
            [_marketplace getMarketplaceContentForKind:currentKind andStart:totalRows andNumberOfRows:TOTAL_ROWS_INCREMENT andSorting:_sorting];
            
            break;
        
        case 2:
            
            isLoadMoreActive = NO;
            currentKind = CATEGORY_KIND;
            [_marketplace getMarketplaceCategories];
            
        case 3:
            
            //currentKind = SUB_CATEGORY_KIND;
            currentSorting = _sorting;
            
            [_marketplace getMarketplaceContentForKind:KIND_NATIONAL andCategory:currentCategory andStart:totalRows andNumberOfRows:TOTAL_ROWS_INCREMENT andSorting:_sorting];
            
            break;
        
        case 4:
            
            //currentKind = KIND_AROUND_ME;
            currentSorting = _sorting;
            [_marketplace getMarketplaceContentForKind:currentKind andStart:totalRows andNumberOfRows:TOTAL_ROWS_INCREMENT andSorting:_sorting];

            break;
    }
}


#pragma mark - private methods

+ (UIView *)closeButton{
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

+ (void)closeBeintoo{
    [Beintoo dismissBeintoo];
}

- (void)showChildSegment{
    
    [UIView beginAnimations:@"childSegmentShow" context:nil];
    [UIView setAnimationDuration:0.4];
    [UIView setAnimationDelegate:self];
    
    table.frame = CGRectMake(table.frame.origin.x, childSegmentedControl.frame.origin.y + childSegmentedControl.frame.size.height + 9, table.frame.size.width, bodyView.frame.size.height - 8 - 8 - 11 - mainSegmentedControl.frame.size.height - childSegmentedControl.frame.size.height);
    
    [UIView commitAnimations];

}

- (void)hideChildSegment{
    
    [UIView beginAnimations:@"childSegmentHide" context:nil];
    [UIView setAnimationDuration:0.4];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(hideChildDidStop)];
    table.frame = CGRectMake(table.frame.origin.x, childSegmentedControl.frame.origin.y, table.frame.size.width, bodyView.frame.size.height - 10 - mainSegmentedControl.frame.size.height + childSegmentedControl.frame.size.height - 8 - 8 - 21);
    
    [UIView commitAnimations];
}

- (void)hideChildDidStop{
    childSegmentedControl.hidden = YES;
}


#pragma mark -
#pragma mark IBActions

- (IBAction)backToCategories{
    isLoadMoreActive = YES;
    isNewSearch = YES;
    
    @try {
        [marketplaceContent removeAllObjects];
        [marketplaceImages removeAllObjects];
        [buttonsArray removeAllObjects];
    }
    @catch (NSException *exception) {
        NSLog(@"Exception on removing array objects");
    }
    
    if (isNewSearch == YES){
        totalRows = 0;
    }
    
    @try {
        [BLoadingView stopActivity];
        [BLoadingView startFullScreenActivity:self.view];
    }
    @catch (NSException *exception) {
        
    }
    
    //-------> Categories
    isLoadMoreActive = NO;
    currentKind = CATEGORY_KIND;
    [_marketplace getMarketplaceCategories];
    
}

- (IBAction)clickedButton:(id)sender{
    
    @try {
        noMoneyCloseButton.tag      = [sender tag];
        couponCloseButton.tag       = [sender tag];
        if ([Beintoo isVirtualCurrencyStored]) {
            float missingMoney      = [[[marketplaceContent objectAtIndex:[sender tag]] objectForKey:@"virtualCurrencyPrice"] floatValue] - [Beintoo getVirtualCurrencyBalance];
            
            if ([Beintoo getVirtualCurrencyBalance] < [[[marketplaceContent objectAtIndex:[sender tag]] objectForKey:@"virtualCurrencyPrice"] floatValue]){
                
                noMoneyMessage.text             = [NSString stringWithFormat:NSLocalizedStringFromTable(@"MPnoMoneyToGetCoupon", @"BeintooLocalizable", @"Marketplace"), missingMoney, [Beintoo getVirtualCurrencyName]]; 
                
                noMoneyCouponDescription.text   = [[marketplaceContent objectAtIndex:[sender tag]] objectForKey:@"description"];
                noMoneyCouponName.text          = [[marketplaceContent objectAtIndex:[sender tag]] objectForKey:@"name"];
                noMoneyCouponEnddate.text       = [NSString stringWithFormat:@"%@ %@", NSLocalizedStringFromTable(@"endDate", @"BeintooLocalizable", nil),[[marketplaceContent objectAtIndex:[sender tag]] objectForKey:@"enddate"]];
                noMoneyCouponCost.text          = [NSString stringWithFormat:@"%@: %@", [Beintoo getVirtualCurrencyName], [[marketplaceContent objectAtIndex:[sender tag]] objectForKey:@"virtualCurrencyPrice"]];
                [noMoneyActivity startAnimating];
                
                [self showWithAnimationForView:couponView withTag:[sender tag]];
                
                BImageDownload *download        = [[[BImageDownload alloc] init] autorelease];
                download.delegate               = self;
                download.urlString              = [[marketplaceContent objectAtIndex:[sender tag]] objectForKey:@"imageUrl"];
                download.tag                    = 2222;
                noMoneyImageView.image          = download.image;
                
                [couponView addSubview:noMoneySubView];
                [noMoneySubView setCenter:CGPointMake(couponView.center.x, couponView.center.y)];
                
                [self showWithAnimationForView:couponView withTag:0];
                
            }
            else {
                [buttonsArray replaceObjectAtIndex:[sender tag] withObject:@"noHidden"];
                for (int i = 0; i < [buttonsArray count]; i++){
                    
                    if (i != [sender tag]){
                        [buttonsArray replaceObjectAtIndex:i withObject:@"Hidden"];
                    }
                    
                }
                [table reloadData];
            
            }
        }
        else {
            float missingMoney                  = [[[marketplaceContent objectAtIndex:[sender tag]] objectForKey:@"bedollars"] floatValue] - [[[Beintoo getUserIfLogged] objectForKey:@"bedollars"] floatValue];
            if (![Beintoo isUserLogged]){
                [self showFeatureSignupView];
            
            }
            else if ([[[Beintoo getUserIfLogged] objectForKey:@"bedollars"] floatValue] < [[[marketplaceContent objectAtIndex:[sender tag]] objectForKey:@"bedollars"] floatValue]){
                
                noMoneyCouponDescription.text   = [[marketplaceContent objectAtIndex:[sender tag]] objectForKey:@"description"];
                noMoneyCouponName.text          = [[marketplaceContent objectAtIndex:[sender tag]] objectForKey:@"name"];
                noMoneyCouponEnddate.text       = [NSString stringWithFormat:@"%@ %@", NSLocalizedStringFromTable(@"endDate", @"BeintooLocalizable", nil), [[marketplaceContent objectAtIndex:[sender tag]] objectForKey:@"enddate"]];
                noMoneyCouponCost.text          = [NSString stringWithFormat:@"%@: %@", NSLocalizedStringFromTable(@"bedollars", @"BeintooLocalizable", nil),[[marketplaceContent objectAtIndex:[sender tag]] objectForKey:@"bedollars"]];
                
                [noMoneyActivity startAnimating];
                
                [self showWithAnimationForView:couponView withTag:[sender tag]];
                
                BImageDownload *download        = [[[BImageDownload alloc] init] autorelease];
                download.delegate               = self;
                download.urlString              = [[marketplaceContent objectAtIndex:[sender tag]] objectForKey:@"imageUrl"];
                download.tag                    = 2222;
                noMoneyImageView.image          = download.image;
                
                noMoneyMessage.text             = [NSString stringWithFormat:NSLocalizedStringFromTable(@"MPnoMoneyToGetCoupon", @"BeintooLocalizable", @"Marketplace"), missingMoney, NSLocalizedStringFromTable(@"bedollars", @"BeintooLocalizable", @"Marketplace")]; 
                [couponView addSubview:noMoneySubView];
                [noMoneySubView setCenter:CGPointMake(couponView.center.x, couponView.center.y)];
                
                //[self showWithAnimationForView:couponView withTag:0];
            
            }
            else {
                [buttonsArray replaceObjectAtIndex:[sender tag] withObject:@"noHidden"];
                for (int i = 0; i < [buttonsArray count]; i++){
                    
                    if (i != [sender tag]){
                        [buttonsArray replaceObjectAtIndex:i withObject:@"Hidden"];
                    }
                    
                }
                [table reloadData];
            
            }
        }
    }
    @catch (NSException *exception) {
        NSLog(@"Exception on button clicked, %@", exception);
    }
    
}

- (IBAction)clickedBuyButton:(id)sender{
    
    @try {
        [couponView addSubview:couponSubView];
        [couponSubView setCenter:CGPointMake(couponView.center.x, couponView.center.y)];
        
        [couponSendButton setTitle:NSLocalizedStringFromTable(@"MPsendAsAGift",@"BeintooLocalizable", nil) forState:UIControlStateNormal];
        [couponSendButton setTextSize:[NSNumber numberWithInt:15]];
        [couponSendButton setHighColor:[UIColor colorWithRed:156.0/255 green:168.0/255 blue:184.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(156, 2)/pow(255,2) green:pow(168, 2)/pow(255,2) blue:pow(184, 2)/pow(255,2) alpha:1]];
        [couponSendButton setMediumHighColor:[UIColor colorWithRed:116.0/255 green:135.0/255 blue:159.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(116, 2)/pow(255,2) green:pow(135, 2)/pow(255,2) blue:pow(159, 2)/pow(255,2) alpha:1]];
        [couponSendButton setMediumLowColor:[UIColor colorWithRed:108.0/255 green:128.0/255 blue:154.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(108, 2)/pow(255,2) green:pow(128, 2)/pow(255,2) blue:pow(154, 2)/pow(255,2) alpha:1]];
        [couponSendButton setLowColor:[UIColor colorWithRed:89.0/255 green:112.0/255 blue:142.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(89, 2)/pow(255,2) green:pow(112, 2)/pow(255,2) blue:pow(142, 2)/pow(255,2) alpha:1]];
        
        [couponGetButton setTitle:NSLocalizedStringFromTable(@"MPbuy",@"BeintooLocalizable", nil) forState:UIControlStateNormal];
        [couponGetButton setTextSize:[NSNumber numberWithInt:15]];
        [couponGetButton setHighColor:[UIColor colorWithRed:156.0/255 green:168.0/255 blue:184.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(156, 2)/pow(255,2) green:pow(168, 2)/pow(255,2) blue:pow(184, 2)/pow(255,2) alpha:1]];
        [couponGetButton setMediumHighColor:[UIColor colorWithRed:116.0/255 green:135.0/255 blue:159.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(116, 2)/pow(255,2) green:pow(135, 2)/pow(255,2) blue:pow(159, 2)/pow(255,2) alpha:1]];
        [couponGetButton setMediumLowColor:[UIColor colorWithRed:108.0/255 green:128.0/255 blue:154.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(108, 2)/pow(255,2) green:pow(128, 2)/pow(255,2) blue:pow(154, 2)/pow(255,2) alpha:1]];
        [couponGetButton setLowColor:[UIColor colorWithRed:89.0/255 green:112.0/255 blue:142.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(89, 2)/pow(255,2) green:pow(112, 2)/pow(255,2) blue:pow(142, 2)/pow(255,2) alpha:1]];
        
        selectedDictionary          = [marketplaceContent objectAtIndex:[sender tag]];
        couponDescription.text      = [[marketplaceContent objectAtIndex:[sender tag]] objectForKey:@"description"];
        couponName.text             = [[marketplaceContent objectAtIndex:[sender tag]] objectForKey:@"name"];
        couponEnddate.text          = [NSString stringWithFormat:@"%@ %@", NSLocalizedStringFromTable(@"endDate", @"BeintooLocalizable", nil), [[marketplaceContent objectAtIndex:[sender tag]] objectForKey:@"enddate"]];
        if ([Beintoo isVirtualCurrencyStored]) {
            couponBedollars.text    = [NSString stringWithFormat:@"%@: %@", [Beintoo getVirtualCurrencyName], [[marketplaceContent objectAtIndex:[sender tag]] objectForKey:@"virtualCurrencyPrice"]];
        }
        else {
            couponBedollars.text    = [NSString stringWithFormat:@"%@: %@", NSLocalizedStringFromTable(@"bedollars", @"BeintooLocalizable", @"Marketplace"), [[marketplaceContent objectAtIndex:[sender tag]] objectForKey:@"bedollars"]];
        }
        
        
        couponGetButton.tag         = [sender tag];
        couponSendButton.tag        = [sender tag];
        
        [couponActivity startAnimating];
        
        [self showWithAnimationForView:couponView withTag:[sender tag]];
        
        BImageDownload *download        = [[[BImageDownload alloc] init] autorelease];
        download.delegate               = self;
        download.urlString              = [[marketplaceContent objectAtIndex:[sender tag]] objectForKey:@"imageUrl"];
        download.tag                    = 1111;
        couponImageView.image           = download.image;
        
    }
    @catch (NSException *exception) {
        NSLog(@"Exception on buy button clicked, %@", exception);
    }
}


- (void)showWithAnimationForView:(UIView *)_animView withTag:(int)_senderTag{
    [UIView beginAnimations:@"showBuyCoupon" context:nil];
    [UIView setAnimationDuration:0.4];
    [UIView setAnimationDelegate:self];

    _animView.alpha = 1.0f;
    
    [UIView commitAnimations];
}

- (void)hideWithAnimationForView:(UIView *)_animView{
    [UIView beginAnimations:@"hideBuyCoupon" context:nil];
    [UIView setAnimationDuration:0.4];
    [UIView setAnimationDelegate:self];
    
    _animView.alpha = 0.0f;
    
    [UIView commitAnimations];
}

- (IBAction)closeDialog:(id)sender{
    
    [table reloadData];
    [buttonsArray replaceObjectAtIndex:[sender tag] withObject:@"Hidden"];
    [self hideWithAnimationForView:couponView];
    
    for (UIView *_subviews in [couponView subviews]){
        [_subviews removeFromSuperview];
    }
    
}

- (IBAction)buyCoupon:(id)sender{
    @try {
        NSString *getRealURLWithLocation    = [NSString stringWithString:[selectedDictionary objectForKey:@"showURL"]];
        NSString *locationParams            = [Beintoo getUserLocationForURL];
        if (locationParams != nil) {
            getRealURLWithLocation          = [getRealURLWithLocation stringByAppendingString:locationParams];
        }
        NSString *elementsToSend            = [NSString stringWithFormat:@"&guid=%@", [Beintoo getPlayerID]];
        getRealURLWithLocation              = [getRealURLWithLocation stringByAppendingString:elementsToSend];
        
        if ([Beintoo isVirtualCurrencyStored]){
            // Developer's Currency Stored
            float currentCurrencyAmount     = [Beintoo getVirtualCurrencyBalance];
            float currentCost               = [[[marketplaceContent objectAtIndex:[sender tag]] objectForKey:@"virtualCurrencyPrice"] floatValue];
            float totalCurrentCurrencyAmount = currentCurrencyAmount - currentCost;
            
           
            
            if (totalCurrentCurrencyAmount < 0){
                //No currency available for player or user
                 float missingMoney = [[[marketplaceContent objectAtIndex:[sender tag]] objectForKey:@"virtualCurrencyPrice"] floatValue] - [Beintoo getVirtualCurrencyBalance];
                
                noMoneyMessage.text         = [NSString stringWithFormat:NSLocalizedStringFromTable(@"MPnoMoneyToGetCoupon", @"BeintooLocalizable", @"Marketplace"), missingMoney, [Beintoo getVirtualCurrencyName]];
                
                noMoneyCouponDescription.text = [[marketplaceContent objectAtIndex:[sender tag]] objectForKey:@"description"];
                noMoneyCouponName.text      = [[marketplaceContent objectAtIndex:[sender tag]] objectForKey:@"name"];
                noMoneyCouponEnddate.text   = [NSString stringWithFormat:@"%@ %@", NSLocalizedStringFromTable(@"endDate", @"BeintooLocalizable", nil),  [[marketplaceContent objectAtIndex:[sender tag]] objectForKey:@"enddate"]];
                noMoneyCouponCost.text      = [NSString stringWithFormat:@"%@: %@", [Beintoo getVirtualCurrencyName], [[marketplaceContent objectAtIndex:[sender tag]] objectForKey:@"virtualCurrencyPrice"]];
                
                [self showWithAnimationForView:couponView withTag:[sender tag]];
                
                BImageDownload *download        = [[[BImageDownload alloc] init] autorelease];
                download.delegate               = self;
                download.urlString              = [[marketplaceContent objectAtIndex:[sender tag]] objectForKey:@"imageUrl"];
                download.tag                    = 2222;
                noMoneyImageView.image          = download.image;
                
                [couponView addSubview:noMoneySubView];
                [noMoneySubView setCenter:CGPointMake(couponView.center.x, couponView.center.y)];
                
                [self showWithAnimationForView:couponView withTag:0];
            
            }
            else {
                
                [Beintoo setVirtualCurrencyBalance:totalCurrentCurrencyAmount];
            
                getRealURLWithLocation          = [getRealURLWithLocation stringByAppendingFormat:@"&developer_user_guid=%@", [Beintoo getDeveloperUserId]];
                vgoodShowVC.urlToOpen           = getRealURLWithLocation;
                vgoodShowVC.caller              = @"MarketplaceList";
                vgoodShowVC.callerIstanceMP     = self;
                [self.navigationController pushViewController:vgoodShowVC animated:YES];
                
            }
        }
        else {
            //No Delevoper's Currency Stored, let's use Bedollars
            float currentCurrencyAmount = [[[Beintoo getUserIfLogged] objectForKey:@"bedollars"] floatValue];
            float currentCost           = [[[marketplaceContent objectAtIndex:[sender tag]] objectForKey:@"bedollars"] floatValue];
            float totalCurrentCurrencyAmount = currentCurrencyAmount - currentCost;
            
            if (![Beintoo isUserLogged]){
                //It's a player, he has no bedollars
                [self showFeatureSignupView];
            }
            else {
                //It's a user, he may own Bedollars
                if (totalCurrentCurrencyAmount < 0){
                    //It's a user, he miss Bedollars to buy the coupon
                    float missingMoney = [[[marketplaceContent objectAtIndex:[sender tag]] objectForKey:@"bedollars"] floatValue] - [[[Beintoo getUserIfLogged] objectForKey:@"bedollars"] floatValue];
                    
                    noMoneyMessage.text             = [NSString stringWithFormat:NSLocalizedStringFromTable(@"MPnoMoneyToGetCoupon", @"BeintooLocalizable", @"Marketplace"), missingMoney, NSLocalizedStringFromTable(@"bedollars", @"BeintooLocalizable", @"Marketplace")]; 
                    
                    noMoneyCouponDescription.text   = [[marketplaceContent objectAtIndex:[sender tag]] objectForKey:@"description"];
                    noMoneyCouponName.text          = [[marketplaceContent objectAtIndex:[sender tag]] objectForKey:@"name"];
                    noMoneyCouponEnddate.text       = [NSString stringWithFormat:@"%@ %@", NSLocalizedStringFromTable(@"endDate", @"BeintooLocalizable", nil), [[marketplaceContent objectAtIndex:[sender tag]] objectForKey:@"enddate"]];
                    noMoneyCouponCost.text          = [NSString stringWithFormat:@"%@: %@", [Beintoo getVirtualCurrencyName], [[marketplaceContent objectAtIndex:[sender tag]] objectForKey:@"bedollars"]];
                    
                    [self showWithAnimationForView:couponView withTag:[sender tag]];
                    
                    BImageDownload *download        = [[[BImageDownload alloc] init] autorelease];
                    download.delegate               = self;
                    download.urlString              = [[marketplaceContent objectAtIndex:[sender tag]] objectForKey:@"imageUrl"];
                    download.tag                    = 2222;
                    noMoneyImageView.image          = download.image;
                    
                    [couponView addSubview:noMoneySubView];
                    [noMoneySubView setCenter:CGPointMake(couponView.center.x, couponView.center.y)];
                    
                    [self showWithAnimationForView:couponView withTag:0];
                }
                else {
                    //It's a user, he has Bedollars to buy the coupon
                                        
                    vgoodShowVC.urlToOpen           = getRealURLWithLocation;
                    vgoodShowVC.caller              = @"MarketplaceList";
                    vgoodShowVC.callerIstanceMP     = self;
                    [self.navigationController pushViewController:vgoodShowVC animated:YES];
                }
            }
        }
       // [getRealURLWithLocation release];
        
    }
    @catch (NSException *exception) {
        NSLog(@"Exception on popup buy button clicked, %@", exception);
    }
}

- (IBAction)sendAsGift:(id)sender{
   
    @try {
        if ([Beintoo isVirtualCurrencyStored]){
            // Developer's Currency Stored
            float currentCurrencyAmount         = [Beintoo getVirtualCurrencyBalance];
            float currentCost                   = [[[marketplaceContent objectAtIndex:[sender tag]] objectForKey:@"virtualCurrencyPrice"] floatValue];
            float totalCurrentCurrencyAmount    = currentCurrencyAmount - currentCost;
            
            if (![Beintoo isUserLogged]){
                //He's a player, he has no friends --> show Sign Up message
                [self showFeatureSignupView];
            }
            else {
                //He's a user, he has friends
                if (totalCurrentCurrencyAmount < 0){
                    
                    //User with no currency available
                    float missingMoney          = [[[marketplaceContent objectAtIndex:[sender tag]] objectForKey:@"virtualCurrencyPrice"] floatValue] - [Beintoo getVirtualCurrencyBalance];
                    
                    noMoneyMessage.text         = [NSString stringWithFormat:@"You Miss %.0f %@ to get this coupon", missingMoney, [Beintoo getVirtualCurrencyName]];
                    
                    noMoneyCouponDescription.text = [[marketplaceContent objectAtIndex:[sender tag]] objectForKey:@"description"];
                    noMoneyCouponName.text      = [[marketplaceContent objectAtIndex:[sender tag]] objectForKey:@"name"];
                    noMoneyCouponEnddate.text   = [NSString stringWithFormat:@"%@ %@", NSLocalizedStringFromTable(@"endDate", @"BeintooLocalizable", nil),  [[marketplaceContent objectAtIndex:[sender tag]] objectForKey:@"enddate"]];
                    noMoneyCouponCost.text      = [NSString stringWithFormat:@"%@: %@", [Beintoo getVirtualCurrencyName], [[marketplaceContent objectAtIndex:[sender tag]] objectForKey:@"virtualCurrencyPrice"]];
                    
                    [self showWithAnimationForView:couponView withTag:[sender tag]];
                    
                    BImageDownload *download        = [[[BImageDownload alloc] init] autorelease];
                    download.delegate               = self;
                    download.urlString              = [[marketplaceContent objectAtIndex:[sender tag]] objectForKey:@"imageUrl"];
                    download.tag                    = 2222;
                    noMoneyImageView.image          = download.image;
                    
                    [couponView addSubview:noMoneySubView];
                    [noMoneySubView setCenter:CGPointMake(couponView.center.x, couponView.center.y)];
                    
                    [self showWithAnimationForView:couponView withTag:0];
                    
                }
                else {
                    //User with currency available
                    
                    options = [NSDictionary dictionaryWithObjectsAndKeys:selectedDictionary, @"vGood", @"MarketplaceSendAsAGift", @"caller", self, @"callerVC", nil];
                    
                    friendsListVC.startingOptions   = options;
                    needsToReloadData               = NO;
                    friendsListVC.caller            = @"MarketplaceList";
                    friendsListVC.callerIstance     = self;
                    
                    [self.navigationController pushViewController:friendsListVC animated:YES];
                }
            }
        }
        else {
            //No Delevoper's Currency Stored, let's use Bedollars
            float currentCurrencyAmount             = [[[Beintoo getUserIfLogged] objectForKey:@"bedollars"] floatValue];
            float currentCost                       = [[[marketplaceContent objectAtIndex:[sender tag]] objectForKey:@"bedollars"] floatValue];
            float totalCurrentCurrencyAmount        = currentCurrencyAmount - currentCost;
            
            if (![Beintoo isUserLogged]){
                //It's a player, he has no bedollars
                [self showFeatureSignupView];
            }
            else {
                //It's a user, he may own Bedollars
                if (totalCurrentCurrencyAmount < 0){
                    //It's a user, he miss Bedollars to buy the coupon
                    float missingMoney              = [[[marketplaceContent objectAtIndex:[sender tag]] objectForKey:@"virtualCurrencyPrice"] floatValue] - [Beintoo getVirtualCurrencyBalance];
                    
                    noMoneyMessage.text             = [NSString stringWithFormat:@"You Miss %.0f Bedollars to get this coupon", missingMoney];
                    
                    noMoneyCouponDescription.text   = [[marketplaceContent objectAtIndex:[sender tag]] objectForKey:@"description"];
                    noMoneyCouponName.text          = [[marketplaceContent objectAtIndex:[sender tag]] objectForKey:@"name"];
                    noMoneyCouponEnddate.text       = [NSString stringWithFormat:@"%@ %@", NSLocalizedStringFromTable(@"endDate", @"BeintooLocalizable", nil), [[marketplaceContent objectAtIndex:[sender tag]] objectForKey:@"enddate"]];
                    noMoneyCouponCost.text          = [NSString stringWithFormat:@"%@: %@", NSLocalizedStringFromTable(@"bedollars", @"BeintooLocalizable", @"Marketplace"), [[marketplaceContent objectAtIndex:[sender tag]] objectForKey:@"bedollars"]];
                    
                    [self showWithAnimationForView:couponView withTag:[sender tag]];
                    
                    BImageDownload *download        = [[[BImageDownload alloc] init] autorelease];
                    download.delegate               = self;
                    download.urlString              = [[marketplaceContent objectAtIndex:[sender tag]] objectForKey:@"imageUrl"];
                    download.tag                    = 2222;
                    noMoneyImageView.image          = download.image;
                    
                    [couponView addSubview:noMoneySubView];
                    [noMoneySubView setCenter:CGPointMake(couponView.center.x, couponView.center.y)];
                    
                    [self showWithAnimationForView:couponView withTag:0];
                }
                else {
                    //It's a user, he has Bedollars to buy the coupon
                    //options           = [[NSDictionary alloc] init];
                    options = [NSDictionary dictionaryWithObjectsAndKeys:selectedDictionary, @"vGood", @"MarketplaceSendAsAGift", @"caller", self, @"callerVC", nil];
                    
                    friendsListVC.startingOptions   = options;
                    needsToReloadData               = NO;
                    friendsListVC.caller            = @"MarketplaceList";
                    friendsListVC.callerIstance     = self;
                    
                    [self.navigationController pushViewController:friendsListVC animated:YES];
                    
                }
            }
        }
        
    }
    @catch (NSException *exception) {
        NSLog(@"Exception on send as a gift popup button clicked, %@", exception);
    }
}

- (void)tryBeintoo{	
    
    @try {
        if ([BeintooNetwork connectedToNetwork]) {
            [BLoadingView startFullScreenActivity:self.view];
            [loginNavController popToRootViewControllerAnimated:NO];                
        }
        [_user getUserByUDID];
    }
    @catch (NSException * e) {
    }
}

- (void)showFeatureSignupView{
    UIView *featureView         = [[BSignupLayouts getBeintooDashboardViewForLockedFeatureMarketplaceWithFrame:CGRectMake(30, 70, 290, 220) andButtonActionSelector:@selector(tryBeintoo) fromSender:self] retain];
    featureView.tag             = 3333;
    featureView.alpha           = 0.0f;
    [self.view addSubview:featureView];
    [self.view bringSubviewToFront:featureView];
    
    [UIView beginAnimations:@"showSignupPopup" context:nil];
    [UIView setAnimationDuration:0.4];
    [UIView setAnimationDelegate:self];
    
    featureView.alpha           = 1.0f;
    
    [UIView commitAnimations];
    
    [featureView release];
    
}


- (void)dismissFeatureSignupView{
    
    UIView *featureView = [self.view viewWithTag:3333];
    [featureView removeFromSuperview];
}

#pragma mark -
#pragma mark BImageDownload Delegate Methods

- (void)bImageDownloadDidFinishDownloading:(BImageDownload *)download{
    
    if (download.tag == 2222){
        noMoneyImageView.image          = download.image;
        [noMoneyActivity stopAnimating];
        download.delegate               = nil;
    }
    else if (download.tag == 1111){
        couponImageView.image           = download.image;
        [couponActivity stopAnimating];
        download.delegate               = nil;
    }
    else if (download.tag != 1111){
        @try {
             
            NSUInteger index            = [marketplaceImages indexOfObject:download]; 
            NSUInteger indices[]        = {0, index};
            NSIndexPath *path           = [[NSIndexPath alloc] initWithIndexes:indices length:2];
            [table reloadRowsAtIndexPaths:[NSArray arrayWithObject:path] withRowAnimation:UITableViewRowAnimationNone];
            [path release];
            
            BImageCache *imageCache = [[[BImageCache alloc] init] autorelease];
            [imageCache addRemoteFileToCache:download.urlString withData:UIImagePNGRepresentation(download.image)];
            
            download.delegate           = nil;
        }
        @catch (NSException *exception) {
            NSLog(@"BeintooImageException: %@", exception);
        }
    }
}

- (void)bImageDownload:(BImageDownload *)download didFailWithError:(NSError *)error{
    NSLog(@"BeintooImageError: %@", [error localizedDescription]);
}

- (void)showTable{
    [UIView beginAnimations:@"showTable" context:nil];
    [UIView setAnimationDuration:0.4];
    [UIView setAnimationDelegate:self];
    
    table.frame = CGRectMake(table.frame.origin.x, table.frame.origin.y, table.frame.size.width, 0);
    
    [UIView commitAnimations];
}

- (void)hideTable{
    [UIView beginAnimations:@"hideTable" context:nil];
    [UIView setAnimationDuration:0.4];
    [UIView setAnimationDelegate:self];
    
    table.frame = CGRectMake(table.frame.origin.x, table.frame.origin.y, table.frame.size.width, 0);
    
    [UIView commitAnimations];
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    BGradientView *_headerView  = [[BGradientView alloc] initWithGradientType:GRADIENT_HEADER];
    _headerView.frame           = CGRectMake(0, 0, self.view.frame.size.width, 35);
    _headerView.backgroundColor = [UIColor clearColor];
    
    UIView *_topBorder = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 1)];
    _topBorder.backgroundColor = [UIColor colorWithWhite:0.0 alpha:1.0];
    
    [_headerView addSubview:_topBorder];
    
    if (currentKind == SUB_CATEGORY_KIND){
        BButton *_backButton = [[BButton alloc] initWithFrame:CGRectMake(10, 4, 100, 25)];
        
        [_backButton setTitle:NSLocalizedStringFromTable(@"back", @"BeintooLocalizable", nil) forState:UIControlStateNormal];
        [_backButton setTextSize:[NSNumber numberWithInt:15]];
        [_backButton setHighColor:[UIColor colorWithRed:156.0/255 green:168.0/255 blue:184.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(156, 2)/pow(255,2) green:pow(168, 2)/pow(255,2) blue:pow(184, 2)/pow(255,2) alpha:1]];
        [_backButton setMediumHighColor:[UIColor colorWithRed:116.0/255 green:135.0/255 blue:159.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(116, 2)/pow(255,2) green:pow(135, 2)/pow(255,2) blue:pow(159, 2)/pow(255,2) alpha:1]];
        [_backButton setMediumLowColor:[UIColor colorWithRed:108.0/255 green:128.0/255 blue:154.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(108, 2)/pow(255,2) green:pow(128, 2)/pow(255,2) blue:pow(154, 2)/pow(255,2) alpha:1]];
        [_backButton setLowColor:[UIColor colorWithRed:89.0/255 green:112.0/255 blue:142.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(89, 2)/pow(255,2) green:pow(112, 2)/pow(255,2) blue:pow(142, 2)/pow(255,2) alpha:1]];
        
        [_backButton addTarget:self action:@selector(backToCategories) forControlEvents:UIControlStateNormal];
        [_backButton addTarget:self action:@selector(backToCategories) forControlEvents:UIControlStateHighlighted];
        [_backButton addTarget:self action:@selector(backToCategories) forControlEvents:UIControlStateSelected];
        
        [_headerView addSubview:_backButton];

    }
    else {
        UILabel *_descriptionLabel          = [[UILabel alloc] initWithFrame:CGRectMake(10, 4, 170, 25)];
        _descriptionLabel.backgroundColor   = [UIColor clearColor];
        _descriptionLabel.textAlignment     = UITextAlignmentLeft;
        _descriptionLabel.text              = NSLocalizedStringFromTable(@"MPorderByPrice", @"BeintooLocalizable", nil);
        _descriptionLabel.textColor         = [UIColor colorWithWhite:0.2 alpha:1.0];
        _descriptionLabel.font              = [UIFont systemFontOfSize:13];
        
        [_headerView addSubview:_descriptionLabel];
    }
    
    BButton *_descOrder = [[BButton alloc] initWithFrame:CGRectMake(_headerView.frame.size.width - 105, 4, 45, 25)];
    
    UIImageView *_imageView = [[UIImageView alloc] initWithFrame:CGRectMake(12.5, 5.5, 19, 14)];
    _imageView.image = [UIImage imageNamed:@"arrow_down.png"];
    _imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    [_descOrder addSubview:_imageView];
    [_imageView release];
   
    [_descOrder setHighColor:[UIColor colorWithRed:156.0/255 green:168.0/255 blue:184.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(156, 2)/pow(255,2) green:pow(168, 2)/pow(255,2) blue:pow(184, 2)/pow(255,2) alpha:1]];
    [_descOrder setMediumHighColor:[UIColor colorWithRed:116.0/255 green:135.0/255 blue:159.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(116, 2)/pow(255,2) green:pow(135, 2)/pow(255,2) blue:pow(159, 2)/pow(255,2) alpha:1]];
    [_descOrder setMediumLowColor:[UIColor colorWithRed:108.0/255 green:128.0/255 blue:154.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(108, 2)/pow(255,2) green:pow(128, 2)/pow(255,2) blue:pow(154, 2)/pow(255,2) alpha:1]];
    [_descOrder setLowColor:[UIColor colorWithRed:89.0/255 green:112.0/255 blue:142.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(89, 2)/pow(255,2) green:pow(112, 2)/pow(255,2) blue:pow(142, 2)/pow(255,2) alpha:1]];
        
    _descOrder.tag = 1;
    
     
    
    [_headerView addSubview:_descOrder];
    
    
    BButton *_ascOrder = [[BButton alloc] initWithFrame:CGRectMake(_descOrder.frame.origin.x + _descOrder.frame.size.width + 5, 4, 45, 25)];
    
    _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(14.5, 5.5, 19, 14)];
    _imageView.image = [UIImage imageNamed:@"arrow_up.png"];
    _imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    [_ascOrder addSubview:_imageView];
    [_imageView release];
    
    [_ascOrder setHighColor:[UIColor colorWithRed:156.0/255 green:168.0/255 blue:184.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(156, 2)/pow(255,2) green:pow(168, 2)/pow(255,2) blue:pow(184, 2)/pow(255,2) alpha:1]];
    [_ascOrder setMediumHighColor:[UIColor colorWithRed:116.0/255 green:135.0/255 blue:159.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(116, 2)/pow(255,2) green:pow(135, 2)/pow(255,2) blue:pow(159, 2)/pow(255,2) alpha:1]];
    [_ascOrder setMediumLowColor:[UIColor colorWithRed:108.0/255 green:128.0/255 blue:154.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(108, 2)/pow(255,2) green:pow(128, 2)/pow(255,2) blue:pow(154, 2)/pow(255,2) alpha:1]];
    [_ascOrder setLowColor:[UIColor colorWithRed:89.0/255 green:112.0/255 blue:142.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(89, 2)/pow(255,2) green:pow(112, 2)/pow(255,2) blue:pow(142, 2)/pow(255,2) alpha:1]];
    
    _ascOrder.tag = 2;
    
    if (currentSorting == SORT_PRICE){
         
    }
    else {
        
    }
    
    [_headerView addSubview:_ascOrder];
    
    if (currentSorting == SORT_PRICE) {
        
        [_ascOrder addTarget:self action:@selector(searchMarketplaceContentForCurrentSorting:) forControlEvents:UIControlStateNormal];
        [_ascOrder addTarget:self action:@selector(searchMarketplaceContentForCurrentSorting:) forControlEvents:UIControlStateHighlighted];
        [_ascOrder addTarget:self action:@selector(searchMarketplaceContentForCurrentSorting:) forControlEvents:UIControlStateSelected]; 
        
        [_ascOrder setHighColor:[UIColor colorWithRed:156.0/255 green:168.0/255 blue:184.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(156, 2)/pow(255,2) green:pow(168, 2)/pow(255,2) blue:pow(184, 2)/pow(255,2) alpha:1]];
        [_ascOrder setMediumHighColor:[UIColor colorWithRed:116.0/255 green:135.0/255 blue:159.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(116, 2)/pow(255,2) green:pow(135, 2)/pow(255,2) blue:pow(159, 2)/pow(255,2) alpha:1]];
        [_ascOrder setMediumLowColor:[UIColor colorWithRed:108.0/255 green:128.0/255 blue:154.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(108, 2)/pow(255,2) green:pow(128, 2)/pow(255,2) blue:pow(154, 2)/pow(255,2) alpha:1]];
        [_ascOrder setLowColor:[UIColor colorWithRed:89.0/255 green:112.0/255 blue:142.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(89, 2)/pow(255,2) green:pow(112, 2)/pow(255,2) blue:pow(142, 2)/pow(255,2) alpha:1]];
        
        [_descOrder addTarget:self action:nil forControlEvents:UIControlStateNormal];
        [_descOrder addTarget:self action:nil forControlEvents:UIControlStateHighlighted];
        [_descOrder addTarget:self action:nil forControlEvents:UIControlStateSelected];
        
        [_descOrder setHighColor:[UIColor colorWithWhite:0.80f alpha:1] andRollover:[UIColor colorWithWhite:0.80f alpha:1]];
        [_descOrder setMediumHighColor:[UIColor colorWithWhite:0.80f alpha:1] andRollover:[UIColor colorWithWhite:0.80f alpha:1]];
        [_descOrder setMediumLowColor:[UIColor colorWithWhite:0.80f alpha:1] andRollover:[UIColor colorWithWhite:0.80f alpha:1]];
        [_descOrder setLowColor:[UIColor colorWithWhite:0.80f alpha:1] andRollover:[UIColor colorWithWhite:0.80f alpha:1]];
        
    }
    else if (currentSorting == SORT_PRICE_ASC) {
        
        [_ascOrder addTarget:self action:nil forControlEvents:UIControlStateNormal];
        [_ascOrder addTarget:self action:nil forControlEvents:UIControlStateHighlighted];
        [_ascOrder addTarget:self action:nil forControlEvents:UIControlStateSelected]; 
        
        [_ascOrder setHighColor:[UIColor colorWithWhite:0.80f alpha:1] andRollover:[UIColor colorWithWhite:0.80f alpha:1]];
        [_ascOrder setMediumHighColor:[UIColor colorWithWhite:0.80f alpha:1] andRollover:[UIColor colorWithWhite:0.80f alpha:1]];
        [_ascOrder setMediumLowColor:[UIColor colorWithWhite:0.80f alpha:1] andRollover:[UIColor colorWithWhite:0.80f alpha:1]];
        [_ascOrder setLowColor:[UIColor colorWithWhite:0.80f alpha:1] andRollover:[UIColor colorWithWhite:0.80f alpha:1]];
        
        [_descOrder addTarget:self action:@selector(searchMarketplaceContentForCurrentSorting:) forControlEvents:UIControlStateNormal];
        [_descOrder addTarget:self action:@selector(searchMarketplaceContentForCurrentSorting:) forControlEvents:UIControlStateHighlighted];
        [_descOrder addTarget:self action:@selector(searchMarketplaceContentForCurrentSorting:) forControlEvents:UIControlStateSelected]; 
        
        [_descOrder setHighColor:[UIColor colorWithRed:156.0/255 green:168.0/255 blue:184.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(156, 2)/pow(255,2) green:pow(168, 2)/pow(255,2) blue:pow(184, 2)/pow(255,2) alpha:1]];
        [_descOrder setMediumHighColor:[UIColor colorWithRed:116.0/255 green:135.0/255 blue:159.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(116, 2)/pow(255,2) green:pow(135, 2)/pow(255,2) blue:pow(159, 2)/pow(255,2) alpha:1]];
        [_descOrder setMediumLowColor:[UIColor colorWithRed:108.0/255 green:128.0/255 blue:154.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(108, 2)/pow(255,2) green:pow(128, 2)/pow(255,2) blue:pow(154, 2)/pow(255,2) alpha:1]];
        [_descOrder setLowColor:[UIColor colorWithRed:89.0/255 green:112.0/255 blue:142.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(89, 2)/pow(255,2) green:pow(112, 2)/pow(255,2) blue:pow(142, 2)/pow(255,2) alpha:1]];
        
    }
    
    return _headerView;
        
}

- (float)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if (currentKind == CATEGORY_KIND || currentKind == KIND_AROUND_ME)
        return 0;
    else 
        return 33;

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	
    if ([marketplaceContent count] == 0)
        return 1;
    else if (isLoadMoreActive == YES){ 
        return [marketplaceContent count] + 1;
    }
    else 
        return [marketplaceContent count];
}

- (float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 75;

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
	int _gradientType = (indexPath.row % 2) ? GRADIENT_CELL_HEAD : GRADIENT_CELL_BODY;
    
    BTableViewCell *cell = (BTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil || TRUE) {
        
        cell = [[[BTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier andGradientType:_gradientType] autorelease];
    }
    
	@try {
         if (indexPath.row == 0){
             UIView *vi = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 0.5)];
             vi.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.70f];
             vi.autoresizingMask = UIViewAutoresizingFlexibleWidth;
             [cell addSubview:vi];
             [vi release];
             
             vi = [[UIView alloc] initWithFrame:CGRectMake(0, 0.5, 320, 1)];
             vi.backgroundColor = [UIColor whiteColor];
             [cell addSubview:vi];
             [vi release];
             
         }
          
         if ([marketplaceContent count] == 0){
             
             cell.selectionStyle        = UITableViewCellSelectionStyleNone;
             
             UILabel *label             = [[UILabel alloc] initWithFrame:CGRectMake(10, 25, 300, 25)];
             label.backgroundColor      = [UIColor clearColor];
             label.text                 = NSLocalizedStringFromTable(@"MPnoAvailableCoupons", @"BeintooLocalizable", nil); 
             label.font                 = [UIFont systemFontOfSize:14];
             label.textAlignment        = UITextAlignmentCenter;
             [cell addSubview:label];
             [label release];
             
        }
         else if ((isLoadMoreActive == YES) && (indexPath.row == totalRows)){
             
             cell.selectionStyle        = UITableViewCellSelectionStyleGray;
             
             UILabel *label             = [[UILabel alloc] initWithFrame:CGRectMake(60, 27.5, 200, 20)];
             label.backgroundColor      = [UIColor clearColor];
             label.text                 = NSLocalizedStringFromTable(@"loadmoreButton", @"BeintooLocalizable", nil); 
             label.font                 = [UIFont systemFontOfSize:14];
             label.textAlignment        = UITextAlignmentCenter;
             [cell addSubview:label];
             [label release];
             
             activity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
             activity.frame = CGRectMake(70, 27.5, 20, 20);
             [activity setHidesWhenStopped:YES];
             [activity stopAnimating];
             [cell addSubview:activity];
             
         }
         else {
             
             cell.selectionStyle = UITableViewCellSelectionStyleGray;
             
             int delta = 0;
             if ([[marketplaceContent objectAtIndex:indexPath.row] objectForKey:@"distance"]){
                 delta = -7;
             }
             
             CGSize result = [[[marketplaceContent objectAtIndex:indexPath.row] objectForKey:@"name"] sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(165, 32) lineBreakMode:UILineBreakModeWordWrap];
             
             UILabel *nameLabel = [[UILabel alloc] init];
             if (currentKind == CATEGORY_KIND){
                 nameLabel.frame        = CGRectMake(75, 27, 167, 20);
                 nameLabel.font             = [UIFont systemFontOfSize:17];
             }
             else {
                 if (result.height <= 18){
                     nameLabel.frame        = CGRectMake(75, 75-30-36+4 + delta, 167, 34);
                 }
                 else {
                     nameLabel.frame       = CGRectMake(75, 75-30-34 + delta, 167, 34);
                 }
                 nameLabel.font             = [UIFont systemFontOfSize:14];
             }
             
             nameLabel.text             = [[marketplaceContent objectAtIndex:indexPath.row] objectForKey:@"name"];
             nameLabel.textAlignment    = UITextAlignmentLeft;
             
             nameLabel.backgroundColor  = [UIColor clearColor];
             nameLabel.numberOfLines    = 0;
             nameLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
             
             [cell addSubview:nameLabel];
             [nameLabel release];
             
             
             UIImageView *imageViewItem = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 65, 65)];
             @try {
                 if ([[marketplaceImages objectAtIndex:indexPath.row] isKindOfClass:[NSString class]]){
                     imageViewItem.image        = [UIImage imageWithContentsOfFile:[marketplaceImages objectAtIndex:indexPath.row]];
                 }
                 else {
                     BImageDownload *download   = [marketplaceImages objectAtIndex:indexPath.row];
                     imageViewItem.image        = download.image;
                     
                 }
             }
             @catch (NSException * e) {
                 //NSLog(@"Exception on marketplace table view image imple");
             }
             imageViewItem.contentMode  = UIViewContentModeScaleAspectFit;
             imageViewItem.center       = CGPointMake(37, 37);
             [cell addSubview:imageViewItem];
             [imageViewItem release];

             if (![[buttonsArray objectAtIndex:indexPath.row] isEqualToString:@"no"]){
                
                 UILabel *descriptionLabel;
                 
                 if (result.height <= 18){
                     descriptionLabel         = [[UILabel alloc] initWithFrame:CGRectMake(75, 40 + delta, 167, 18)];                 
                 }
                 else {
                     descriptionLabel         = [[UILabel alloc] initWithFrame:CGRectMake(75, 45 + delta, 167, 18)];
                 }
                 
                 descriptionLabel.text              = [[marketplaceContent objectAtIndex:indexPath.row] objectForKey:@"description"];
                 descriptionLabel.textAlignment     = UITextAlignmentLeft;
                 descriptionLabel.font              = [UIFont systemFontOfSize:10];
                 descriptionLabel.backgroundColor   = [UIColor clearColor];
                 descriptionLabel.textColor         = [UIColor colorWithWhite:0.40 alpha:1.0];
                 descriptionLabel.autoresizingMask  = UIViewAutoresizingFlexibleWidth;
                 [cell addSubview:descriptionLabel];
                 
                 
                 if ([[marketplaceContent objectAtIndex:indexPath.row] objectForKey:@"distance"]){
                     UILabel *distanceLabel;
                     
                     if (result.height <= 18){
                         distanceLabel         = [[UILabel alloc] initWithFrame:CGRectMake(75, 57 + delta, 175, 16)];                 
                     }
                     else {
                         distanceLabel         = [[UILabel alloc] initWithFrame:CGRectMake(75, 61 + delta, 175, 16)];
                         
                     }
                     
                     float miglia = 0.621371192 * ([[[marketplaceContent objectAtIndex:indexPath.row] objectForKey:@"distance"] floatValue]/1000);
                     
                     distanceLabel.text              = [NSString stringWithFormat:@"%@: %.02f Km / %.02f M", NSLocalizedStringFromTable(@"MPdistance", @"BeintooLocalizable", nil), [[[marketplaceContent objectAtIndex:indexPath.row] objectForKey:@"distance"] floatValue]/1000 , miglia];
                     distanceLabel.textAlignment     = UITextAlignmentLeft;
                     distanceLabel.font              = [UIFont systemFontOfSize:10];
                     distanceLabel.backgroundColor   = [UIColor clearColor];
                     distanceLabel.textColor        = [UIColor colorWithWhite:0.40 alpha:1.0];
                     distanceLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
                     [cell addSubview:distanceLabel];
                 }
                 
                 NSString *cost;
                 NSString *currency;
                 
                 
                 CGSize expectedSize = [[Beintoo getVirtualCurrencyName] sizeWithFont:[UIFont boldSystemFontOfSize:12.0f] constrainedToSize:CGSizeMake(65, 36) lineBreakMode:UILineBreakModeWordWrap];
                 int gamma = 0;
                 if (expectedSize.height < 19){
                     gamma = 15;
                     
                 }
                 
                 BButton *button = [[BButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 75, 12 + gamma/2, 65, 50 - gamma)];
                
                 UIImageView *sendButtonImageView    = [[UIImageView alloc] initWithFrame:CGRectMake(button.frame.size.width - 23, (button.frame.size.height/2) - 8.8, 17, 17)];
                 sendButtonImageView.backgroundColor = [UIColor clearColor];
                 sendButtonImageView.contentMode     = UIViewContentModeScaleAspectFit;
                 [button addSubview:sendButtonImageView];
                 
                 UILabel *currencyLabel = [[UILabel alloc] initWithFrame:CGRectMake(2, 16 - gamma/9, 61, 36 - gamma)];
                 
                 UILabel *costLabel = [[UILabel alloc] init];
                 
                 if ([Beintoo isVirtualCurrencyStored]){
                     button.frame = CGRectMake(self.view.frame.size.width - 75, 12 + gamma/2, 65, 50 - gamma);
                     costLabel.frame    = CGRectMake(0, 2, 65, 14);
                     costLabel.textAlignment = UITextAlignmentCenter;
                     cost               = [NSString stringWithFormat:@"%@", [[marketplaceContent objectAtIndex:indexPath.row] objectForKey:@"virtualCurrencyPrice"]];
                     currency           = [NSString stringWithFormat:@"%@", [Beintoo getVirtualCurrencyName]];
                     sendButtonImageView.hidden = YES;
                     currencyLabel.hidden = NO;
                     //Controllare se la currency dell'utente supera il costo del coupon
                     if ([Beintoo getVirtualCurrencyBalance] >= [[[marketplaceContent objectAtIndex:indexPath.row] objectForKey:@"virtualCurrencyPrice"] floatValue]){
                         //Bottoni attivati
                         costLabel.textColor = [UIColor whiteColor];
                         currencyLabel.textColor = [UIColor whiteColor];
                        
                         [button setHighColor:[UIColor colorWithRed:156.0/255 green:168.0/255 blue:184.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(156, 2)/pow(255,2) green:pow(168, 2)/pow(255,2) blue:pow(184, 2)/pow(255,2) alpha:1]];
                         [button setMediumHighColor:[UIColor colorWithRed:116.0/255 green:135.0/255 blue:159.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(116, 2)/pow(255,2) green:pow(135, 2)/pow(255,2) blue:pow(159, 2)/pow(255,2) alpha:1]];
                         [button setMediumLowColor:[UIColor colorWithRed:108.0/255 green:128.0/255 blue:154.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(108, 2)/pow(255,2) green:pow(128, 2)/pow(255,2) blue:pow(154, 2)/pow(255,2) alpha:1]];
                         [button setLowColor:[UIColor colorWithRed:89.0/255 green:112.0/255 blue:142.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(89, 2)/pow(255,2) green:pow(112, 2)/pow(255,2) blue:pow(142, 2)/pow(255,2) alpha:1]];
                         
                         costLabel.shadowColor                  = [UIColor colorWithWhite:0.0 alpha:1.0];
                         costLabel.shadowOffset                 = CGSizeMake(0, -1);
                         currencyLabel.shadowColor                  = [UIColor colorWithWhite:0.0 alpha:1.0];
                         currencyLabel.shadowOffset                 = CGSizeMake(0, -1);
                         
                     }
                     else {
                        //Bottoni disattivati
                        costLabel.textColor          = [UIColor grayColor];
                        currencyLabel.textColor      = [UIColor grayColor];
                        [button setHighColor:[UIColor colorWithWhite:0.80f alpha:1] andRollover:[UIColor colorWithWhite:0.80f alpha:1]];
                        [button setMediumHighColor:[UIColor colorWithWhite:0.80f alpha:1] andRollover:[UIColor colorWithWhite:0.80f alpha:1]];
                        [button setMediumLowColor:[UIColor colorWithWhite:0.80f alpha:1] andRollover:[UIColor colorWithWhite:0.80f alpha:1]];
                        [button setLowColor:[UIColor colorWithWhite:0.80f alpha:1] andRollover:[UIColor colorWithWhite:0.80f alpha:1]];
                        
                         costLabel.shadowColor                  = [UIColor colorWithWhite:1.0 alpha:1.0];
                         costLabel.shadowOffset                 = CGSizeMake(0, -1);
                         currencyLabel.shadowColor                  = [UIColor colorWithWhite:1.0 alpha:1.0];
                         currencyLabel.shadowOffset                 = CGSizeMake(0, -1);
                     }
                 }
                 else {
                     button.frame = CGRectMake(self.view.frame.size.width - 75, 19.5, 65, 35);
                     costLabel.frame = CGRectMake(0, (button.frame.size.height/2) - 7, 60, 14);
                     costLabel.textAlignment = UITextAlignmentRight;
                     currencyLabel.hidden           = YES;
                     currency                       = [NSString stringWithFormat:@""];
                     sendButtonImageView.hidden     = NO;
                     sendButtonImageView.frame = CGRectMake(button.frame.size.width - 23, (button.frame.size.height/2) - 8.8, 17, 17);
                     
                     CGSize size = [[NSString stringWithFormat:@"%@", [[marketplaceContent objectAtIndex:indexPath.row] objectForKey:@"bedollars"]] sizeWithFont:[UIFont boldSystemFontOfSize:14.0] constrainedToSize:CGSizeMake(60, 14)];
                     
                     if ([[[Beintoo getUserIfLogged] objectForKey:@"bedollars"] floatValue] >= [[[marketplaceContent objectAtIndex:indexPath.row] objectForKey:@"bedollars"] floatValue] || ![Beintoo isUserLogged]){
                         
                         [button setHighColor:[UIColor colorWithRed:156.0/255 green:168.0/255 blue: 184.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(156, 2)/pow(255,2) green:pow(168, 2)/pow(255,2) blue:pow(184, 2)/pow(255,2) alpha:1]];
                         [button setMediumHighColor:[UIColor colorWithRed:116.0/255 green:135.0/255 blue:159.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(116, 2)/pow(255,2) green:pow(135, 2)/pow(255,2) blue:pow(159, 2)/pow(255,2) alpha:1]];
                         [button setMediumLowColor:[UIColor colorWithRed:108.0/255 green:128.0/255 blue:154.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(108, 2)/pow(255,2) green:pow(128, 2)/pow(255,2) blue:pow(154, 2)/pow(255,2) alpha:1]];
                         [button setLowColor:[UIColor colorWithRed:89.0/255 green:112.0/255 blue:142.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(89, 2)/pow(255,2) green:pow(112, 2)/pow(255,2) blue:pow(142, 2)/pow(255,2) alpha:1]];
                        
                         cost                           = [NSString stringWithFormat:@"%@", [[marketplaceContent objectAtIndex:indexPath.row] objectForKey:@"bedollars"]];
                         
                         costLabel.textColor            = [UIColor whiteColor];
                         sendButtonImageView.image      = [UIImage imageNamed:@"B_white.png"];
                         costLabel.shadowColor                  = [UIColor colorWithWhite:0.0 alpha:1.0];
                         costLabel.shadowOffset                 = CGSizeMake(0, -1);
                         
                     }
                     else {
                           
                         [button setHighColor:[UIColor colorWithWhite:0.80f alpha:1] andRollover:[UIColor colorWithWhite:0.80f alpha:1]];
                         [button setMediumHighColor:[UIColor colorWithWhite:0.80f alpha:1] andRollover:[UIColor colorWithWhite:0.80f alpha:1]];
                         [button setMediumLowColor:[UIColor colorWithWhite:0.80f alpha:1] andRollover:[UIColor colorWithWhite:0.80f alpha:1]];
                         [button setLowColor:[UIColor colorWithWhite:0.80f alpha:1] andRollover:[UIColor colorWithWhite:0.80f alpha:1]];
                         
                         cost                           = [NSString stringWithFormat:@"%@", [[marketplaceContent objectAtIndex:indexPath.row] objectForKey:@"bedollars"]];
                         costLabel.textColor            = [UIColor grayColor];
                         currencyLabel.textColor        = [UIColor grayColor];
                         sendButtonImageView.image      = [UIImage imageNamed:@"B_grey.png"];
                         
                         costLabel.shadowColor                  = [UIColor colorWithWhite:1.0 alpha:1.0];
                         costLabel.shadowOffset                 = CGSizeMake(0, -1);
                        
                    }
                     costLabel.frame = CGRectMake(56/2 - size.width/2, costLabel.frame.origin.y + 0.3, size.width, 14);
                     sendButtonImageView.frame = CGRectMake(costLabel.frame.origin.x + costLabel.frame.size.width - 1.5, sendButtonImageView.frame.origin.y + 0.5, sendButtonImageView.frame.size.width, sendButtonImageView.frame.size.height);
                 }
                 
                 costLabel.backgroundColor              = [UIColor clearColor];
                 costLabel.text                         = cost;
                 costLabel.textAlignment                = UITextAlignmentCenter;
                 costLabel.font                         = [UIFont boldSystemFontOfSize:14.0f];
                 
                 [button addSubview:costLabel];
                 [costLabel release];
                 
                 currencyLabel.backgroundColor          = [UIColor clearColor];
                 currencyLabel.text                     = currency;
                 currencyLabel.textAlignment            = UITextAlignmentCenter;
                 currencyLabel.font                     = [UIFont boldSystemFontOfSize:12.0f];
                 currencyLabel.numberOfLines            = 0;
                 
                 [button addSubview:currencyLabel];
                 [currencyLabel release];
                 
                 [button addTarget:self action:@selector(clickedButton:) forControlEvents:UIControlStateNormal];
                 [button addTarget:self action:@selector(clickedButton:) forControlEvents:UIControlStateSelected];
                 [button addTarget:self action:@selector(clickedButton:) forControlEvents:UIControlStateHighlighted];
                 
                 button.autoresizingMask                = UIViewAutoresizingFlexibleRightMargin;
                 button.tag                             = indexPath.row;
                
                 BButton *buttonHidden                  = [[BButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 75, button.frame.origin.y, 65, button.frame.size.height)];
                 [buttonHidden setTitle:NSLocalizedStringFromTable(@"MPbuy", @"BeintooLocalizable", nil) forState:UIControlStateNormal];
                 [buttonHidden addTarget:self action:@selector(clickedBuyButton:) forControlEvents:UIControlStateNormal];
                 [buttonHidden addTarget:self action:@selector(clickedBuyButton:) forControlEvents:UIControlStateHighlighted];
                 [buttonHidden addTarget:self action:@selector(clickedBuyButton:) forControlEvents:UIControlStateSelected];
                 
                 [buttonHidden setHighColor:[UIColor colorWithRed:159.0/255.0 green:187.0/255.0 blue:17.0/255.0 alpha:0.80] andRollover:[UIColor colorWithRed:pow(159.0, 2)/pow(255.0,2) green:pow(187.0, 2)/pow(255.0,2) blue:pow(17.0, 2)/pow(255.0,2) alpha:1.0]];
                 [buttonHidden setMediumHighColor:[UIColor colorWithRed:159.0/255.0 green:187.0/255.0 blue:17.0/255.0 alpha:0.80] andRollover:[UIColor colorWithRed:pow(159.0, 2)/pow(255.0,2) green:pow(187.0, 2)/pow(255.0,2) blue:pow(17.0, 2)/pow(255.0,2) alpha:1.0]];
                 [buttonHidden setMediumLowColor:[UIColor colorWithRed:159.0/255.0 green:187.0/255.0 blue:17.0/255.0 alpha:1.0] andRollover:[UIColor colorWithRed:pow(159.0, 2)/pow(255.0,2) green:pow(187.0, 2)/pow(255.0,2) blue:pow(17.0, 2)/pow(255.0,2) alpha:1.0]];
                 [buttonHidden setLowColor:[UIColor colorWithRed:159.0/255.0 green:187.0/255.0 blue:17.0/255.0 alpha:1.0] andRollover:[UIColor colorWithRed:pow(159.0, 2)/pow(255.0,2) green:pow(187.0, 2)/pow(255.0,2) blue:pow(17.0, 2)/pow(255.0,2) alpha:1.0]];
                 
                 buttonHidden.autoresizingMask = UIViewAutoresizingFlexibleRightMargin;
                 [buttonHidden setButtonTextSize:14];
                 buttonHidden.tag                   = indexPath.row;
                 
                 if ([[buttonsArray objectAtIndex:indexPath.row] isEqualToString:@"Hidden"] == YES){
                     [buttonHidden setHidden:YES];
                     [button setHidden:NO];
                 }
                 else {
                     [buttonHidden setHidden:NO];
                     [button setHidden:YES];
                 }
                 
                 [cell addSubview:button];
                 [cell addSubview:buttonHidden];
                 
                 [button release];
                 [buttonHidden release];
             }
         }
    }
	@catch (NSException * e) {
		NSLog(@"Exception on marketplace table view");
	} 
         
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([currentKind isEqualToString:CATEGORY_KIND]){
        if (![marketplaceContent count] == 0){
            if ([[buttonsArray objectAtIndex:indexPath.row] isEqualToString:@"no"]){
                    
                [BLoadingView startFullScreenActivity:self.view];
                isNewSearch = YES;
                if (isNewSearch == YES){
                    totalRows = 0;
                }
            
                currentKind = SUB_CATEGORY_KIND;
                currentSorting = SORT_PRICE;
                currentCategory = [[NSString stringWithFormat:@"%@", [[marketplaceContent objectAtIndex:indexPath.row] objectForKey:@"id"]] copy];
                
                [_marketplace getMarketplaceContentForKind:KIND_NATIONAL andCategory:[[marketplaceContent objectAtIndex:indexPath.row] objectForKey:@"id"] andStart:totalRows andNumberOfRows:TOTAL_ROWS_INCREMENT andSorting:SORT_PRICE];
            }
        }
    }
    else {
        if ([marketplaceContent count] != 0){
            if (indexPath.row == totalRows){
                isNewSearch = NO;
                [activity startAnimating];
                [_marketplace getMarketplaceContentForKind:currentKind andStart:totalRows andNumberOfRows:TOTAL_ROWS_INCREMENT andSorting:currentSorting];
            }
            else {
            
                needsToReloadData = YES;
                marketplaceSelectedItemVC   =   [[BeintooMarketplaceSelectedItemVC alloc] initWithNibName:@"BeintooMarketplaceSelectedItemVC" bundle:[NSBundle mainBundle]];
                marketplaceSelectedItemVC.selectedVgood = [marketplaceContent objectAtIndex:indexPath.row];
                marketplaceSelectedItemVC.caller = @"MarketplaceList";
                marketplaceSelectedItemVC.callerIstance = self;
                [self.navigationController pushViewController:marketplaceSelectedItemVC animated:YES];
                
                [marketplaceSelectedItemVC release];
                marketplaceSelectedItemVC = nil;
            }
        }
    }
}

#pragma mark - Pull To Refresh TableView

- (void)reloadTableViewDataSource{
	
    isLoadMoreActive = YES;
    isNewSearch = YES;
    
    if (isNewSearch == YES){
        totalRows = 0;
        
    }
    
    @try {
        [BLoadingView stopActivity];
        
    }
    @catch (NSException *exception) {
        
    }
    //[BLoadingView startFullScreenActivity:self.view];
    
    if (mainSegmentedControl.selectedSegmentIndex == 1){
        [self showChildSegment];
        childSegmentedControl.hidden = NO;
        
        if (childSegmentedControl.selectedSegmentIndex == 0){
            //-------> Top Sales
            currentKind = KIND_NATIONAL_TOPSOLD;
            [_marketplace getMarketplaceContentForKind:KIND_NATIONAL_TOPSOLD andStart:totalRows andNumberOfRows:TOTAL_ROWS_INCREMENT andSorting:currentSorting];
        }
        else {
            //-------> Categories
            if (currentKind == CATEGORY_KIND){
                isLoadMoreActive = NO;
                currentKind = CATEGORY_KIND;
                [_marketplace getMarketplaceCategories];
            }
            else {
                isLoadMoreActive = YES;
                currentKind = SUB_CATEGORY_KIND;
               [_marketplace getMarketplaceContentForKind:KIND_NATIONAL andCategory:currentCategory andStart:totalRows andNumberOfRows:TOTAL_ROWS_INCREMENT andSorting:currentSorting];
            }
        }
    }
    else {
        if (mainSegmentedControl.selectedSegmentIndex == 0){
            
            currentKind = KIND_FEATURED;
            [_marketplace getMarketplaceContentForKind:KIND_FEATURED andStart:totalRows andNumberOfRows:TOTAL_ROWS_INCREMENT andSorting:currentSorting];
            
        }
        else if(mainSegmentedControl.selectedSegmentIndex == 2){
            
            currentKind = KIND_AROUND_ME;
            [_marketplace getMarketplaceContentForKind:KIND_AROUND_ME andStart:totalRows andNumberOfRows:TOTAL_ROWS_INCREMENT andSorting:currentSorting];
        }
    }
}


#pragma mark -
#pragma mark ScrollView Callbacks

- (void)dataSourceDidFinishLoadingNewData{
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:.3];
	[self.table setContentInset:UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f)];
	[UIView commitAnimations];
	
	[refreshHeaderView setState:EGOOPullRefreshNormal];
    
    [refreshHeaderView setCurrentDate];	
	//[super dataSourceDidFinishLoadingNewData];
    [self.table reloadData];
    _reloading = NO;
}

- (void)dataSourceLoadingError{
	
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:.3];
	[self.table setContentInset:UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f)];
	[UIView commitAnimations];
	
	[refreshHeaderView setState:EGOOPullRefreshNormal];
    
    [self.table reloadData];
     _reloading = NO;
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView{	
	
	if (scrollView.isDragging) {
		if (refreshHeaderView.state == EGOOPullRefreshPulling && scrollView.contentOffset.y > -65.0f && scrollView.contentOffset.y < 0.0f && !_reloading) {
			[refreshHeaderView setState:EGOOPullRefreshNormal];
		} else if (refreshHeaderView.state == EGOOPullRefreshNormal && scrollView.contentOffset.y < -65.0f && !_reloading) {
			[refreshHeaderView setState:EGOOPullRefreshPulling];
		}
	}
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
	
	if (scrollView.contentOffset.y <= - 65.0f && !_reloading) {
		_reloading = YES;
		[self reloadTableViewDataSource];
		[refreshHeaderView setState:EGOOPullRefreshLoading];
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:0.2];
		self.table.contentInset = UIEdgeInsetsMake(60.0f, 0.0f, 0.0f, 0.0f);
		[UIView commitAnimations];
    }
}


@end
