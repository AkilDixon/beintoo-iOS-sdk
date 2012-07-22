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

#import "BeintooMarketplaceSelectedItemVC.h"
#import "Beintoo.h"
#import "BPinAnnotation.h"
#import "BeintooMarketplaceCommentsVC.h"
#import "BeintooMapViewVC.h"
#import "BSignupLayouts.h"

@implementation BeintooMarketplaceSelectedItemVC
@synthesize selectedVgood, vgoodBedollarsLabel, vgoodEnddateLabel, vgoodNameLabel,nickLabel, bedollarsLabel, bigTitleLabel, descriptionLabel, mainView, localeStar1, localeStar2, localeStar3, localeStar4, localeStar5, callerIstance, caller, selectedFriend, vGoodToBeSentAsAGift;

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
    [loginVC release];
    [loginNavController release];
    [imgView release]; 
    [imgViewActivity release];
    [_beintooShowVgood release];
    [friendsListVC release];
    [_mapView release];
    [_comments release];
    [_user release];
    [_marketplace release];
    [_vgood release];
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
    
    _vgood                      =   [[BeintooVgood alloc] init];
    _marketplace                =   [[BeintooMarketplace alloc] init];
    _user                       =   [[BeintooUser alloc] init];
    
    loginVC                     = [[BeintooLoginVC alloc] initWithNibName:@"BeintooLoginVC" bundle:[NSBundle mainBundle]];
    
    UIColor *barColor           = [UIColor colorWithRed:108.0/255 green:128.0/255 blue:154.0/255 alpha:1.0];
	loginNavController          = [[UINavigationController alloc] initWithRootViewController:loginVC];
	[[loginNavController navigationBar] setTintColor:barColor];
    
    loginVC.caller = @"MarketplaceSelectedCoupon";
    
     _beintooShowVgood               = [[BeintooVGoodShowVC alloc] initWithNibName:@"BeintooVGoodShowVC" bundle:[NSBundle mainBundle]];
    friendsListVC                   = [[BeintooFriendsListVC alloc] initWithNibName:@"BeintooFriendsListVC" bundle:[NSBundle mainBundle]];
    
    _beintooShowVgood.caller = @"MarketplaceSelectedCoupon";
    
    [mainView setTopHeight:33.0f];
    [mainView setBodyHeight:416.0f];
    
    //-------> coupon view implementation <-------
    [couponSubView setTopHeight:28.0f];
	[couponSubView setBodyHeight:152.0f];
    
    //-------> no money coupon view implementation <-------
    [noMoneySubView setTopHeight:28.0f];
	[noMoneySubView setBodyHeight:152.0f];
    
    //------> Nav Controller Close Button
    UIBarButtonItem *barCloseBtn = [[UIBarButtonItem alloc] initWithCustomView:[BeintooMarketplaceVC closeButton]];
	[self.navigationItem setRightBarButtonItem:barCloseBtn animated:YES];
	[barCloseBtn release];

    couponYouAreGoingToBuyLabel.text = NSLocalizedStringFromTable(@"MPyouAreGoingToBuy", @"BeintooLocalizable", nil);
    
    //------> Update current stars with rating
    [self updateLocaleStars];
    
    scroll.backgroundColor      = [UIColor colorWithRed:108.0/255 green:128.0/255 blue:154.0/255 alpha:1];
    
    //------> Self View Buttons
    
    commentButton.tag           = 11;
    rateButton.tag              = 12;
    mapButton.tag               = 14;
    
    //------> Self View Vgood Image
    imgView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 39, 120, 120)];
    imgView.contentMode             = UIViewContentModeScaleAspectFit;
    [mainView addSubview:imgView];
    
    imgViewActivity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [imgViewActivity hidesWhenStopped];
    [imgViewActivity startAnimating];
    
    imgViewActivity.center = imgView.center;
    [mainView addSubview:imgViewActivity];
    
    BImageDownload *download        = [[[BImageDownload alloc] init] autorelease];
    download.delegate               = self;
    download.urlString              = [selectedVgood objectForKey:@"imageUrl"];
    download.tag                    = 3333;
    imgView.image                   = download.image;
    
    //------> Self View Labels
    
    vgoodNameLabel.text             = [selectedVgood objectForKey:@"name"];
    vgoodEnddateLabel.text          = [NSString stringWithFormat:@"%@ %@", NSLocalizedStringFromTable(@"endDate", @"BeintooLocalizable", nil), [selectedVgood objectForKey:@"enddate"]];
    if ([Beintoo isVirtualCurrencyStored]){
            vgoodBedollarsLabel.text        = [NSString stringWithFormat:@"%@: %@", [Beintoo getVirtualCurrencyName], [selectedVgood objectForKey:@"virtualCurrencyPrice"]];
    }
    else {
            vgoodBedollarsLabel.text        = [NSString stringWithFormat:@"%@: %@", NSLocalizedStringFromTable(@"bedollars", @"BeintooLocalizable", nil), [selectedVgood objectForKey:@"bedollars"]];
    }
    nickLabel.text                  = NSLocalizedStringFromTable(@"MPcredits", @"BeintooLocalizable", @"MarketplaceSelectedItem");
    
    if ([[selectedVgood objectForKey:@"vgoodPOIs"] count] > 0){
        if ([[[[selectedVgood objectForKey:@"vgoodPOIs"] objectAtIndex:0] objectForKey:@"place"] objectForKey:@"latitude"])
            mapButton.hidden    = NO;
        else
            mapButton.hidden    = YES;
    }
    else 
        mapButton.hidden        = YES;
    
    UIImageView *vi         = [[UIImageView alloc] initWithFrame:CGRectMake(15.5, 4, 20, 20)];
    vi.image                = [UIImage imageNamed:@"messages.png"];
    vi.contentMode          = UIViewContentModeScaleAspectFit;
    [commentButton addSubview:vi];
    [vi release];
    
    vi                      = [[UIImageView alloc] initWithFrame:CGRectMake(15.5, 4, 20, 20)];
    vi.image                = [UIImage imageNamed:@"rate.png"];
    vi.contentMode          = UIViewContentModeScaleAspectFit;
    [rateButton addSubview:vi];
    [vi release];
    
    UILabel *mapLabel           = [[UILabel alloc] initWithFrame:CGRectMake(6, 6, 40, 18)];
    mapLabel.backgroundColor    = [UIColor clearColor];
    mapLabel.textAlignment      = UITextAlignmentCenter;
    mapLabel.textColor          = [UIColor whiteColor];
    mapLabel.font               = [UIFont boldSystemFontOfSize:15];
    mapLabel.text               = @"MAP";
    
    [mapButton addSubview:mapLabel];
    [mapLabel release];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    for (UIView *_subviews in [rateView subviews]){
        [_subviews removeFromSuperview];
    }
    rateView.alpha = 0.0f;
    scroll.scrollEnabled = YES;
    
    if ([caller isEqualToString:@"MarketplaceSelectedCoupon"]){
        
        NSString *getRealURLWithLocation    = [NSString stringWithFormat:@"%@", [[self.vGoodToBeSentAsAGift objectForKey:@"vGood"] objectForKey:@"getRealURL"]];
        NSString *locationParams            = [Beintoo getUserLocationForURL];
        if (locationParams != nil) {
            getRealURLWithLocation          = [getRealURLWithLocation stringByAppendingString:locationParams];
        }
        
        NSString *elementsToSend            = [NSString stringWithFormat:@"&guid=%@", [Beintoo getPlayerID]];
        getRealURLWithLocation              = [getRealURLWithLocation stringByAppendingString:elementsToSend];
        
        if ([Beintoo isVirtualCurrencyStored]){
            float currentCurrencyAmount     = [Beintoo getVirtualCurrencyBalance];
            float currentCost               = [[[self.vGoodToBeSentAsAGift objectForKey:@"vGood"] objectForKey:@"virtualCurrencyPrice"] floatValue];
            float totalCurrentCurrencyAmount = currentCurrencyAmount - currentCost;
            
            [Beintoo setVirtualCurrencyBalance:totalCurrentCurrencyAmount];
            
            getRealURLWithLocation          = [getRealURLWithLocation stringByAppendingFormat:@"&developer_user_guid=%@", [Beintoo getDeveloperUserId]];
        }
        
        _beintooShowVgood.urlToOpen         = getRealURLWithLocation;
        //_beintooShowVgood.caller = @"MarketplaceList";
        //_beintooShowVgood.callerIstanceMP = self;
        [self.navigationController pushViewController:_beintooShowVgood animated:YES];
        
        caller                              = nil;
        selectedFriend                      = nil;
        vGoodToBeSentAsAGift                = nil;
        
       // [getRealURLWithLocation release];
    }
    
    if ([caller isEqualToString:@"MarketplaceList"]){
        callerIstance.needsToReloadData = NO;
    
    }
    
    _vgood.delegate                     =   self;
    _marketplace.delegate               =   self;
    _user.delegate                      =   self;
    
    if ([BeintooDevice isiPad]) {
        [self setContentSizeForViewInPopover:CGSizeMake(320, 415)];
    }
    
    rateView.alpha = 0;
    [self.view addSubview:rateView];
    
    [self dismissFeatureSignupView];
    
    if ([Beintoo isVirtualCurrencyStored]){
        bedollarsLabel.hidden       = NO;
        nickLabel.hidden            = NO;
        bedollarsLabel.text         = [NSString stringWithFormat:@"%@ %@", [NSString stringWithFormat:@"%.2f", [Beintoo getVirtualCurrencyBalance]], [Beintoo getVirtualCurrencyName]];
    }
    else{
        if (![Beintoo isUserLogged]){
            bedollarsLabel.hidden   = YES;
            nickLabel.hidden        = YES;
        }
        else {
            bedollarsLabel.hidden   = NO;
            nickLabel.hidden        = NO;
            @try {
                
                NSDictionary *currentUser = [Beintoo getUserIfLogged];
                
                if ([Beintoo isVirtualCurrencyStored]){
                    
                }
                else {
                    bedollarsLabel.text      = [NSString stringWithFormat:@"%@ %@",[currentUser objectForKey:@"bedollars"], NSLocalizedStringFromTable(@"bedollars", @"BeintooLocalizable", nil)];
                }
            }
            @catch (NSException *e) {
            }
        }
    }
    
    buyButton.alpha                 = 0.0f;
    sendButton.alpha                = 0.0f;
    commentButton.alpha             = 0.0f;
    rateButton.alpha                = 0.0f;
    mapButton.alpha                 = 0.0f;
    
    mainView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
    bigTitleLabel.text              = [selectedVgood objectForKey:@"name"];
    descriptionLabel.text           = [selectedVgood objectForKey:@"description"]; 
    
    CGSize result           = [[selectedVgood objectForKey:@"name"] sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake(self.view.frame.size.width - 20, 40) lineBreakMode:UILineBreakModeWordWrap];
    
    int delta;
    if (result.height <= 20)
        delta = +15;
    else
        delta = +10;
    
    bigTitleLabel.frame         = CGRectMake(bigTitleLabel.frame.origin.x, bigTitleLabel.frame.origin.y, bigTitleLabel.frame.size.width, result.height);
    
    result                      = [[selectedVgood objectForKey:@"description"] sizeWithFont:[UIFont systemFontOfSize:13] constrainedToSize:CGSizeMake(self.view.frame.size.width - 20, 5000) lineBreakMode:UILineBreakModeWordWrap];
    
    descriptionLabel.frame      = CGRectMake(descriptionLabel.frame.origin.x, bigTitleLabel.frame.origin.y + bigTitleLabel.frame.size.height + 5, scroll.frame.size.width - 20, result.height);
    vgoodEnddateLabel.textColor = [UIColor colorWithWhite:0.30f alpha:1];
    vgoodBedollarsLabel.textColor = [UIColor colorWithWhite:0.30f alpha:1];
    descriptionLabel.textColor  = [UIColor colorWithWhite:0.30f alpha:1];
    
    buyButton.frame = CGRectMake(buyButton.frame.origin.x, descriptionLabel.frame.size.height + descriptionLabel.frame.origin.y + 10, buyButton.frame.size.width, buyButton.frame.size.height);
    sendButton.frame = CGRectMake(sendButton.frame.origin.x, buyButton.frame.size.height + buyButton.frame.origin.y + 10, sendButton.frame.size.width, sendButton.frame.size.height);
    
    [mainView setBodyHeight:scroll.contentSize.height + mainView.topHeight + 15];
    
    if (![BeintooDevice isiPad]){
        
        if ([Beintoo appOrientation] == UIInterfaceOrientationLandscapeRight || 
            [Beintoo appOrientation] == UIInterfaceOrientationLandscapeLeft) {
            
            mainView.frame      = CGRectMake(0, 0, 480, sendButton.frame.origin.y + sendButton.frame.size.height + 20);
            rateView.frame      = CGRectMake(0, 0, 480, 288);
            scroll.contentSize  = CGSizeMake(self.view.frame.size.width, sendButton.frame.origin.y + sendButton.frame.size.height + 21);
        }
    }
    
    if ([Beintoo appOrientation] == UIInterfaceOrientationPortrait || [Beintoo appOrientation] == UIInterfaceOrientationPortraitUpsideDown || [BeintooDevice isiPad]){
        scroll.contentSize      = CGSizeMake(self.view.frame.size.width, sendButton.frame.origin.y + sendButton.frame.size.height + 21);
        if (scroll.contentSize.height < 436.0f) 
            mainView.frame      = CGRectMake(0, 0, self.view.frame.size.width, 436);
        else 
            mainView.frame      = CGRectMake(0, 0, self.view.frame.size.width, sendButton.frame.origin.y + sendButton.frame.size.height + 20);
    }
    mainView.clipsToBounds      = YES;

}


- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [self setButtonCustomization];
    [self loadRateView];
    
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

#pragma mark -
#pragma mark Beintoo private methods

- (void)tryBeintoo{	
    
    @try {
        if ([BeintooNetwork connectedToNetwork]) {
            [BLoadingView startFullScreenActivity:self.view];
            if([BeintooDevice isiPad]){ // --- iPad, we need to show the "Login Popover"
                [Beintoo launchIpadLogin];
            }else {
                [loginNavController popToRootViewControllerAnimated:NO]; 
            }
                           
        }
        [_user getUserByUDID];
    }
    @catch (NSException * e) {
    }
}

- (void)setButtonCustomization{
    
    for (UIView *_viewToBeRemoved in [sendButton subviews]){
        [_viewToBeRemoved removeFromSuperview];
    }
    for (UIView *_viewToBeRemoved in [buyButton subviews]){
        [_viewToBeRemoved removeFromSuperview];
    }
    
    //-------> Buy Button Labels and Image
    UILabel *leftLabelBuyButton         = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 140, 24)];
    leftLabelBuyButton.backgroundColor  = [UIColor clearColor];
    leftLabelBuyButton.textAlignment    = UITextAlignmentLeft;
    leftLabelBuyButton.font             = [UIFont systemFontOfSize:17];
    leftLabelBuyButton.text             = NSLocalizedStringFromTable(@"MPbuyItNow", @"BeintooLocalizable", nil);
    leftLabelBuyButton.adjustsFontSizeToFitWidth = YES;
    [buyButton addSubview:leftLabelBuyButton];
    
    UILabel *rightLabelBuyButton        = [[UILabel alloc] initWithFrame:CGRectMake(140, 10, 140, 24)];
    rightLabelBuyButton.backgroundColor = [UIColor clearColor];
    rightLabelBuyButton.textAlignment   = UITextAlignmentRight;
    rightLabelBuyButton.textColor       = [UIColor whiteColor];
    rightLabelBuyButton.font            = [UIFont boldSystemFontOfSize:17];
    rightLabelBuyButton.adjustsFontSizeToFitWidth = YES;
    [buyButton addSubview:rightLabelBuyButton];
    
    UIImageView *buyButtonImageView     = [[UIImageView alloc] initWithFrame:CGRectMake(278, 12.8, 20, 20)];
    buyButtonImageView.backgroundColor  = [UIColor clearColor];
    buyButtonImageView.contentMode      = UIViewContentModeScaleAspectFit;
    [buyButton addSubview:buyButtonImageView];
    
    //-------> Send Button Labels and Image
    UILabel *leftLabelSendButton        = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 140, 24)];
    leftLabelSendButton.backgroundColor = [UIColor clearColor];
    leftLabelSendButton.textAlignment   = UITextAlignmentLeft;
    leftLabelSendButton.textColor       = [UIColor whiteColor];
    leftLabelSendButton.font            = [UIFont systemFontOfSize:17];
    leftLabelSendButton.text            = NSLocalizedStringFromTable(@"MPsendAsAGift", @"BeintooLocalizable", nil);
    
    leftLabelSendButton.adjustsFontSizeToFitWidth = YES;
    [sendButton addSubview:leftLabelSendButton];
    
    UILabel *rightLabelSendButton       = [[UILabel alloc] initWithFrame:CGRectMake(140, 10, 140, 24)];
    rightLabelSendButton.backgroundColor = [UIColor clearColor];
    rightLabelSendButton.textAlignment  = UITextAlignmentRight;
    rightLabelSendButton.textColor      = [UIColor whiteColor];
    rightLabelSendButton.font           = [UIFont boldSystemFontOfSize:17];
    rightLabelSendButton.adjustsFontSizeToFitWidth = YES;
    
    [sendButton addSubview:rightLabelSendButton];
    
    
    UIImageView *sendButtonImageView    = [[UIImageView alloc] initWithFrame:CGRectMake(278, 12.8, 20, 20)];
    sendButtonImageView.backgroundColor = [UIColor clearColor];
    sendButtonImageView.contentMode     = UIViewContentModeScaleAspectFit;
    [sendButton addSubview:sendButtonImageView];
    
    leftLabelBuyButton.textColor        = [UIColor whiteColor];
    rightLabelBuyButton.textColor       = [UIColor whiteColor];
    buyButtonImageView.image            = [UIImage imageNamed:@"B_white.png"];
    
    leftLabelBuyButton.textColor        = [UIColor whiteColor];
    leftLabelSendButton.textColor       = [UIColor whiteColor];
    sendButtonImageView.image           = [UIImage imageNamed:@"B_white.png"];
    
    
    if ([Beintoo isVirtualCurrencyStored]){
        //-----> Activate buttons and manage currency
        
        rightLabelBuyButton.text           = [NSString stringWithFormat:@"%@ %@", [selectedVgood objectForKey:@"virtualCurrencyPrice"], [Beintoo getVirtualCurrencyName]];
        
        rightLabelSendButton.text           = [NSString stringWithFormat:@"%@ %@", [selectedVgood objectForKey:@"virtualCurrencyPrice"], [Beintoo getVirtualCurrencyName]];
        
        buyButtonImageView.hidden = YES;
        sendButtonImageView.hidden = YES;
        
       if ([Beintoo getVirtualCurrencyBalance] >= [[selectedVgood objectForKey:@"virtualCurrencyPrice"] floatValue]){
            
           [buyButton setHighColor:[UIColor colorWithRed:156.0/255 green:168.0/255 blue:184.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(156, 2)/pow(255,2) green:pow(168, 2)/pow(255,2) blue:pow(184, 2)/pow(255,2) alpha:1]];
           [buyButton setMediumHighColor:[UIColor colorWithRed:116.0/255 green:135.0/255 blue:159.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(116, 2)/pow(255,2) green:pow(135, 2)/pow(255,2) blue:pow(159, 2)/pow(255,2) alpha:1]];
           [buyButton setMediumLowColor:[UIColor colorWithRed:108.0/255 green:128.0/255 blue:154.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(108, 2)/pow(255,2) green:pow(128, 2)/pow(255,2) blue:pow(154, 2)/pow(255,2) alpha:1]];
           [buyButton setLowColor:[UIColor colorWithRed:89.0/255 green:112.0/255 blue:142.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(89, 2)/pow(255,2) green:pow(112, 2)/pow(255,2) blue:pow(142, 2)/pow(255,2) alpha:1]];

           [sendButton setHighColor:[UIColor colorWithRed:156.0/255 green:168.0/255 blue:184.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(156, 2)/pow(255,2) green:pow(168, 2)/pow(255,2) blue:pow(184, 2)/pow(255,2) alpha:1]];
           [sendButton setMediumHighColor:[UIColor colorWithRed:116.0/255 green:135.0/255 blue:159.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(116, 2)/pow(255,2) green:pow(135, 2)/pow(255,2) blue:pow(159, 2)/pow(255,2) alpha:1]];
           [sendButton setMediumLowColor:[UIColor colorWithRed:108.0/255 green:128.0/255 blue:154.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(108, 2)/pow(255,2) green:pow(128, 2)/pow(255,2) blue:pow(154, 2)/pow(255,2) alpha:1]];
           [sendButton setLowColor:[UIColor colorWithRed:89.0/255 green:112.0/255 blue:142.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(89, 2)/pow(255,2) green:pow(112, 2)/pow(255,2) blue:pow(142, 2)/pow(255,2) alpha:1]];
            
        }
        else {
            [buyButton setHighColor:[UIColor colorWithWhite:0.80f alpha:1] andRollover:[UIColor colorWithWhite:0.80f alpha:1]];
            [buyButton setMediumHighColor:[UIColor colorWithWhite:0.80f alpha:1] andRollover:[UIColor colorWithWhite:0.80f alpha:1]];
            [buyButton setMediumLowColor:[UIColor colorWithWhite:0.80f alpha:1] andRollover:[UIColor colorWithWhite:0.80f alpha:1]];
            [buyButton setLowColor:[UIColor colorWithWhite:0.80f alpha:1] andRollover:[UIColor colorWithWhite:0.80f alpha:1]];
            
            [sendButton setHighColor:[UIColor colorWithWhite:0.80f alpha:1] andRollover:[UIColor colorWithWhite:0.80f alpha:1]];
            [sendButton setMediumHighColor:[UIColor colorWithWhite:0.80f alpha:1] andRollover:[UIColor colorWithWhite:0.80f alpha:1]];
            [sendButton setMediumLowColor:[UIColor colorWithWhite:0.80f alpha:1] andRollover:[UIColor colorWithWhite:0.80f alpha:1]];
            [sendButton setLowColor:[UIColor colorWithWhite:0.80f alpha:1] andRollover:[UIColor colorWithWhite:0.80f alpha:1]];
            
            leftLabelBuyButton.textColor        = [UIColor grayColor];
            rightLabelBuyButton.textColor       = [UIColor grayColor];
            buyButton.backgroundColor           = [UIColor colorWithWhite:0.80f alpha:1];
            
            leftLabelSendButton.textColor       = [UIColor grayColor];
            rightLabelSendButton.textColor      = [UIColor grayColor];
            sendButton.backgroundColor          = [UIColor colorWithWhite:0.80f alpha:1];
        }
    }
    else {
        
      /*  rightLabelSendButton.frame              = CGRectMake(140, 12.5, 110, 20);
        rightLabelBuyButton.frame               = CGRectMake(140, 12.5, 110, 20);*/

        rightLabelBuyButton.text                = [NSString stringWithFormat:@"%@", [selectedVgood objectForKey:@"bedollars"]];
        
        rightLabelSendButton.text               = [NSString stringWithFormat:@"%@", [selectedVgood objectForKey:@"bedollars"]];
        
        buyButtonImageView.hidden               = NO;
        sendButtonImageView.hidden              = NO;
        
        if ([[[Beintoo getUserIfLogged] objectForKey:@"bedollars"] floatValue] >= [[selectedVgood objectForKey:@"bedollars"] floatValue] || ![Beintoo isUserLogged]){
           
            [buyButton setHighColor:[UIColor colorWithRed:156.0/255 green:168.0/255 blue:184.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(156, 2)/pow(255,2) green:pow(168, 2)/pow(255,2) blue:pow(184, 2)/pow(255,2) alpha:1]];
            [buyButton setMediumHighColor:[UIColor colorWithRed:116.0/255 green:135.0/255 blue:159.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(116, 2)/pow(255,2) green:pow(135, 2)/pow(255,2) blue:pow(159, 2)/pow(255,2) alpha:1]];
            [buyButton setMediumLowColor:[UIColor colorWithRed:108.0/255 green:128.0/255 blue:154.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(108, 2)/pow(255,2) green:pow(128, 2)/pow(255,2) blue:pow(154, 2)/pow(255,2) alpha:1]];
            [buyButton setLowColor:[UIColor colorWithRed:89.0/255 green:112.0/255 blue:142.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(89, 2)/pow(255,2) green:pow(112, 2)/pow(255,2) blue:pow(142, 2)/pow(255,2) alpha:1]];
            
            leftLabelBuyButton.textColor        = [UIColor whiteColor];
            rightLabelBuyButton.textColor       = [UIColor whiteColor];
            buyButton.userInteractionEnabled    = YES;
            buyButtonImageView.image            = [UIImage imageNamed:@"B_white.png"];
            
            [sendButton setHighColor:[UIColor colorWithRed:156.0/255 green:168.0/255 blue:184.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(156, 2)/pow(255,2) green:pow(168, 2)/pow(255,2) blue:pow(184, 2)/pow(255,2) alpha:1]];
            [sendButton setMediumHighColor:[UIColor colorWithRed:116.0/255 green:135.0/255 blue:159.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(116, 2)/pow(255,2) green:pow(135, 2)/pow(255,2) blue:pow(159, 2)/pow(255,2) alpha:1]];
            [sendButton setMediumLowColor:[UIColor colorWithRed:108.0/255 green:128.0/255 blue:154.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(108, 2)/pow(255,2) green:pow(128, 2)/pow(255,2) blue:pow(154, 2)/pow(255,2) alpha:1]];
            [sendButton setLowColor:[UIColor colorWithRed:89.0/255 green:112.0/255 blue:142.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(89, 2)/pow(255,2) green:pow(112, 2)/pow(255,2) blue:pow(142, 2)/pow(255,2) alpha:1]];
            
            leftLabelBuyButton.textColor        = [UIColor whiteColor];
            leftLabelSendButton.textColor       = [UIColor whiteColor];
            sendButton.userInteractionEnabled   = YES;
            sendButtonImageView.image           = [UIImage imageNamed:@"B_white.png"];
        }
        else {
            [buyButton setHighColor:[UIColor colorWithWhite:0.80f alpha:1] andRollover:[UIColor colorWithWhite:0.80f alpha:1]];
            [buyButton setMediumHighColor:[UIColor colorWithWhite:0.80f alpha:1] andRollover:[UIColor colorWithWhite:0.80f alpha:1]];
            [buyButton setMediumLowColor:[UIColor colorWithWhite:0.80f alpha:1] andRollover:[UIColor colorWithWhite:0.80f alpha:1]];
            [buyButton setLowColor:[UIColor colorWithWhite:0.80f alpha:1] andRollover:[UIColor colorWithWhite:0.80f alpha:1]];
            
            [sendButton setHighColor:[UIColor colorWithWhite:0.80f alpha:1] andRollover:[UIColor colorWithWhite:0.80f alpha:1]];
            [sendButton setMediumHighColor:[UIColor colorWithWhite:0.80f alpha:1] andRollover:[UIColor colorWithWhite:0.80f alpha:1]];
            [sendButton setMediumLowColor:[UIColor colorWithWhite:0.80f alpha:1] andRollover:[UIColor colorWithWhite:0.80f alpha:1]];
            [sendButton setLowColor:[UIColor colorWithWhite:0.80f alpha:1] andRollover:[UIColor colorWithWhite:0.80f alpha:1]];
            
            leftLabelBuyButton.textColor        = [UIColor grayColor];
            rightLabelBuyButton.textColor       = [UIColor grayColor];
            buyButton.backgroundColor           = [UIColor colorWithWhite:0.80f alpha:1];
            buyButtonImageView.image            = [UIImage imageNamed:@"B_grey.png"];
            buyButtonImageView.backgroundColor  = [UIColor clearColor];
            
            leftLabelSendButton.textColor       = [UIColor grayColor];
            rightLabelSendButton.textColor      = [UIColor grayColor];
            sendButton.backgroundColor          = [UIColor colorWithWhite:0.80f alpha:1];
            sendButtonImageView.image           = [UIImage imageNamed:@"B_grey.png"];
            sendButtonImageView.backgroundColor = [UIColor clearColor];
        }
    }
    
    [leftLabelBuyButton release];
    [rightLabelBuyButton release];
    [leftLabelSendButton release];
    [rightLabelSendButton release];
    [buyButtonImageView release];
    [sendButtonImageView release];
        
    [commentButton setHighColor:[UIColor colorWithRed:156.0/255 green:168.0/255 blue:184.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(156, 2)/pow(255,2) green:pow(168, 2)/pow(255,2) blue:pow(184, 2)/pow(255,2) alpha:1]];
    [commentButton setMediumHighColor:[UIColor colorWithRed:116.0/255 green:135.0/255 blue:159.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(116, 2)/pow(255,2) green:pow(135, 2)/pow(255,2) blue:pow(159, 2)/pow(255,2) alpha:1]];
    [commentButton setMediumLowColor:[UIColor colorWithRed:108.0/255 green:128.0/255 blue:154.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(108, 2)/pow(255,2) green:pow(128, 2)/pow(255,2) blue:pow(154, 2)/pow(255,2) alpha:1]];
    [commentButton setLowColor:[UIColor colorWithRed:89.0/255 green:112.0/255 blue:142.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(89, 2)/pow(255,2) green:pow(112, 2)/pow(255,2) blue:pow(142, 2)/pow(255,2) alpha:1]];
    
    [rateButton setHighColor:[UIColor colorWithRed:156.0/255 green:168.0/255 blue:184.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(156, 2)/pow(255,2) green:pow(168, 2)/pow(255,2) blue:pow(184, 2)/pow(255,2) alpha:1]];
    [rateButton setMediumHighColor:[UIColor colorWithRed:116.0/255 green:135.0/255 blue:159.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(116, 2)/pow(255,2) green:pow(135, 2)/pow(255,2) blue:pow(159, 2)/pow(255,2) alpha:1]];
    [rateButton setMediumLowColor:[UIColor colorWithRed:108.0/255 green:128.0/255 blue:154.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(108, 2)/pow(255,2) green:pow(128, 2)/pow(255,2) blue:pow(154, 2)/pow(255,2) alpha:1]];
    [rateButton setLowColor:[UIColor colorWithRed:89.0/255 green:112.0/255 blue:142.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(89, 2)/pow(255,2) green:pow(112, 2)/pow(255,2) blue:pow(142, 2)/pow(255,2) alpha:1]];
    
    [mapButton setHighColor:[UIColor colorWithRed:156.0/255 green:168.0/255 blue:184.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(156, 2)/pow(255,2) green:pow(168, 2)/pow(255,2) blue:pow(184, 2)/pow(255,2) alpha:1]];
    [mapButton setMediumHighColor:[UIColor colorWithRed:116.0/255 green:135.0/255 blue:159.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(116, 2)/pow(255,2) green:pow(135, 2)/pow(255,2) blue:pow(159, 2)/pow(255,2) alpha:1]];
    [mapButton setMediumLowColor:[UIColor colorWithRed:108.0/255 green:128.0/255 blue:154.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(108, 2)/pow(255,2) green:pow(128, 2)/pow(255,2) blue:pow(154, 2)/pow(255,2) alpha:1]];
    [mapButton setLowColor:[UIColor colorWithRed:89.0/255 green:112.0/255 blue:142.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(89, 2)/pow(255,2) green:pow(112, 2)/pow(255,2) blue:pow(142, 2)/pow(255,2) alpha:1]];
    
    [sendRateButton setHighColor:[UIColor colorWithRed:156.0/255 green:168.0/255 blue:184.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(156, 2)/pow(255,2) green:pow(168, 2)/pow(255,2) blue:pow(184, 2)/pow(255,2) alpha:1]];
    [sendRateButton setMediumHighColor:[UIColor colorWithRed:116.0/255 green:135.0/255 blue:159.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(116, 2)/pow(255,2) green:pow(135, 2)/pow(255,2) blue:pow(159, 2)/pow(255,2) alpha:1]];
    [sendRateButton setMediumLowColor:[UIColor colorWithRed:108.0/255 green:128.0/255 blue:154.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(108, 2)/pow(255,2) green:pow(128, 2)/pow(255,2) blue:pow(154, 2)/pow(255,2) alpha:1]];
    [sendRateButton setLowColor:[UIColor colorWithRed:89.0/255 green:112.0/255 blue:142.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(89, 2)/pow(255,2) green:pow(112, 2)/pow(255,2) blue:pow(142, 2)/pow(255,2) alpha:1]];
    
    _comments           = [[BeintooMarketplaceCommentsVC alloc] initWithNibName:@"BeintooMarketplaceCommentsVC" bundle:[NSBundle mainBundle]]; 
    
    _mapView            = [[BeintooMapViewVC alloc] initWithNibName:@"BeintooMapViewVC" bundle:[NSBundle mainBundle]]; 
    
    [couponGetButton setHighColor:[UIColor colorWithRed:156.0/255 green:168.0/255 blue:184.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(156, 2)/pow(255,2) green:pow(168, 2)/pow(255,2) blue:pow(184, 2)/pow(255,2) alpha:1]];
    [couponGetButton setMediumHighColor:[UIColor colorWithRed:116.0/255 green:135.0/255 blue:159.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(116, 2)/pow(255,2) green:pow(135, 2)/pow(255,2) blue:pow(159, 2)/pow(255,2) alpha:1]];
    [couponGetButton setMediumLowColor:[UIColor colorWithRed:108.0/255 green:128.0/255 blue:154.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(108, 2)/pow(255,2) green:pow(128, 2)/pow(255,2) blue:pow(154, 2)/pow(255,2) alpha:1]];
    [couponGetButton setLowColor:[UIColor colorWithRed:89.0/255 green:112.0/255 blue:142.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(89, 2)/pow(255,2) green:pow(112, 2)/pow(255,2) blue:pow(142, 2)/pow(255,2) alpha:1]];
    
    [couponSendButton setHighColor:[UIColor colorWithRed:156.0/255 green:168.0/255 blue:184.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(156, 2)/pow(255,2) green:pow(168, 2)/pow(255,2) blue:pow(184, 2)/pow(255,2) alpha:1]];
    [couponSendButton setMediumHighColor:[UIColor colorWithRed:116.0/255 green:135.0/255 blue:159.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(116, 2)/pow(255,2) green:pow(135, 2)/pow(255,2) blue:pow(159, 2)/pow(255,2) alpha:1]];
    [couponSendButton setMediumLowColor:[UIColor colorWithRed:108.0/255 green:128.0/255 blue:154.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(108, 2)/pow(255,2) green:pow(128, 2)/pow(255,2) blue:pow(154, 2)/pow(255,2) alpha:1]];
    [couponSendButton setLowColor:[UIColor colorWithRed:89.0/255 green:112.0/255 blue:142.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(89, 2)/pow(255,2) green:pow(112, 2)/pow(255,2) blue:pow(142, 2)/pow(255,2) alpha:1]];
    
    [couponGetButton setButtonTextSize:14];
    [couponGetButton setTitle:NSLocalizedStringFromTable(@"MPbuy", @"BeintooLocalizable", nil) forState:UIControlStateNormal];
    
    [couponSendButton setButtonTextSize:14];
    [couponSendButton setTitle:NSLocalizedStringFromTable(@"MPsendAsAGift", @"BeintooLocalizable", nil) forState:UIControlStateNormal];
    
    [self showWithAnimationForView:buyButton withTag:0];
    [self showWithAnimationForView:sendButton withTag:0];
    [self showWithAnimationForView:commentButton withTag:0];
    [self showWithAnimationForView:rateButton withTag:0];
    [self showWithAnimationForView:mapButton withTag:0];
        
    buttonInitialized                   = YES;
    
    UIImageView *rateImgViews           = [[UIImageView alloc] initWithFrame:CGRectMake(6.5, 6.5, 15, 15)];
    rateImgViews.backgroundColor        = [UIColor clearColor];
    rateImgViews.image                  = [UIImage imageNamed:@"exit.png"];
    rateImgViews.contentMode            = UIViewContentModeScaleAspectFit;
    [couponCloseButton addSubview:rateImgViews];
    [rateImgViews release];
    
    rateImgViews                        = [[UIImageView alloc] initWithFrame:CGRectMake(6.5, 6.5, 15, 15)];
    rateImgViews.backgroundColor        = [UIColor clearColor];
    rateImgViews.image                  = [UIImage imageNamed:@"exit.png"];
    rateImgViews.contentMode            = UIViewContentModeScaleAspectFit;
    [noMoneyCloseButton addSubview:rateImgViews];
    [rateImgViews release];
    
}

- (void)loadRateView{
    
    [rateSubView setTopHeight:28.0f];
    [rateSubView setBodyHeight:137.0f];
    
     UIImageView *rateImgViews           = [[UIImageView alloc] initWithFrame:CGRectMake(2.5, 2.5, 15, 15)];
     rateImgViews.backgroundColor        = [UIColor clearColor];
     rateImgViews.image                  = [UIImage imageNamed:@"exit.png"];
     rateImgViews.contentMode            = UIViewContentModeScaleAspectFit;
     [starcloseButton addSubview:rateImgViews];
     [rateImgViews release];
    
    [sendRateButton setTitle:NSLocalizedStringFromTable(@"MPsendRate", @"BeintooLocalizable", nil) forState:UIControlStateNormal];
    [sendRateButton setTextSize:[NSNumber numberWithInt:15]];
    
    [starButton1 setImage:[UIImage imageNamed:@"star_grey.png"] forState:UIControlStateNormal];
    [starButton1 setImage:[UIImage imageNamed:@"star_blue.png"] forState:UIControlStateSelected];
    [starButton1 setImage:[UIImage imageNamed:@"star_grey.png"] forState:UIControlStateHighlighted];
    
    [starButton2 setImage:[UIImage imageNamed:@"star_grey.png"] forState:UIControlStateNormal];
    [starButton2 setImage:[UIImage imageNamed:@"star_blue.png"] forState:UIControlStateSelected];
    [starButton2 setImage:[UIImage imageNamed:@"star_grey.png"] forState:UIControlStateHighlighted];
    
    [starButton3 setImage:[UIImage imageNamed:@"star_grey.png"] forState:UIControlStateNormal];
    [starButton3 setImage:[UIImage imageNamed:@"star_blue.png"] forState:UIControlStateSelected];
    [starButton3 setImage:[UIImage imageNamed:@"star_grey.png"] forState:UIControlStateHighlighted];
    
    [starButton4 setImage:[UIImage imageNamed:@"star_grey.png"] forState:UIControlStateNormal];
    [starButton4 setImage:[UIImage imageNamed:@"star_blue.png"] forState:UIControlStateSelected];
    [starButton4 setImage:[UIImage imageNamed:@"star_grey.png"] forState:UIControlStateHighlighted];
    
    [starButton5 setImage:[UIImage imageNamed:@"star_grey.png"] forState:UIControlStateNormal];
    [starButton5 setImage:[UIImage imageNamed:@"star_blue.png"] forState:UIControlStateSelected];
    [starButton5 setImage:[UIImage imageNamed:@"star_grey.png"] forState:UIControlStateHighlighted];

}

- (void)clearStars{
    [starButton1 setSelected:NO];
    [starButton2 setSelected:NO];
    [starButton3 setSelected:NO];
    [starButton4 setSelected:NO];
    [starButton5 setSelected:NO];
}

+ (UIButton *)closeButton{
	UIImage *closeImg   = [UIImage imageNamed:@"bar_close.png"];
	UIButton *closeBtn  = [UIButton buttonWithType:UIButtonTypeCustom];
	[closeBtn setImage:closeImg forState:UIControlStateNormal];
	closeBtn.frame      = CGRectMake(0,0, closeImg.size.width+7, closeImg.size.height);
	[closeBtn addTarget:self action:@selector(closeBeintoo) forControlEvents:UIControlEventTouchUpInside];
	return closeBtn;
}

+ (void)closeBeintoo{
	[Beintoo dismissBeintoo];
}

- (void)showFeatureSignupView{
    UIView *featureView             = [[BSignupLayouts getBeintooDashboardViewForLockedFeatureMarketplaceWithFrame:CGRectMake(30, 70, 290, 220) andButtonActionSelector:@selector(tryBeintoo) fromSender:self] retain];
    featureView.tag                 = 3333;
    featureView.alpha               = 0.0f;
    [self.view addSubview:featureView];
    [self.view bringSubviewToFront:featureView];
    
    [UIView beginAnimations:@"showSignupPopup" context:nil];
    [UIView setAnimationDuration:0.4];
    [UIView setAnimationDelegate:self];
    
    featureView.alpha               = 1.0f;
    
    [UIView commitAnimations];
    
    [featureView release];
    
}

- (void)dismissFeatureSignupView{
    
    UIView *featureView = [self.view viewWithTag:3333];
    [featureView removeFromSuperview];
    scroll.scrollEnabled = YES;
}

- (void)showWithAnimationForView:(UIView *)_animView withTag:(int)_senderTag{
    [self.view addSubview:_animView];
    [UIView beginAnimations:@"showDialog" context:nil];
    [UIView setAnimationDuration:0.4];
    [UIView setAnimationDelegate:self];
    
    _animView.alpha = 1.0f;
    
    [UIView commitAnimations];
}

- (void)hideWithAnimationForView:(UIView *)_animView{
    [UIView beginAnimations:@"hideDialog" context:nil];
    [UIView setAnimationDuration:0.4];
    [UIView setAnimationDelegate:self];
    
    _animView.alpha = 0.0f;
    
    [UIView commitAnimations];
    
}

- (void)updateLocaleStars{
    
    if ([selectedVgood objectForKey:@"rating"]){
        if ([[NSString stringWithFormat:@"%@", [selectedVgood objectForKey:@"rating"]] isEqualToString:[NSString stringWithFormat:@"%i", 1]]){
            [localeStar1 setImage:[UIImage imageNamed:@"star_blue.png"]];
            [localeStar2 setImage:[UIImage imageNamed:@"star_grey.png"]];
            [localeStar3 setImage:[UIImage imageNamed:@"star_grey.png"]];
            [localeStar4 setImage:[UIImage imageNamed:@"star_grey.png"]];
            [localeStar5 setImage:[UIImage imageNamed:@"star_grey.png"]];
            
        }
        else if ([[NSString stringWithFormat:@"%@", [selectedVgood objectForKey:@"rating"]] isEqualToString:[NSString stringWithFormat:@"%i", 2]]){
            [localeStar1 setImage:[UIImage imageNamed:@"star_blue.png"]];
            [localeStar2 setImage:[UIImage imageNamed:@"star_blue.png"]];
            [localeStar3 setImage:[UIImage imageNamed:@"star_grey.png"]];
            [localeStar4 setImage:[UIImage imageNamed:@"star_grey.png"]];
            [localeStar5 setImage:[UIImage imageNamed:@"star_grey.png"]];
            
        }
        else if ([[NSString stringWithFormat:@"%@", [selectedVgood objectForKey:@"rating"]] isEqualToString:[NSString stringWithFormat:@"%i", 3]]){
            [localeStar1 setImage:[UIImage imageNamed:@"star_blue.png"]];
            [localeStar2 setImage:[UIImage imageNamed:@"star_blue.png"]];
            [localeStar3 setImage:[UIImage imageNamed:@"star_blue.png"]];
            [localeStar4 setImage:[UIImage imageNamed:@"star_grey.png"]];
            [localeStar5 setImage:[UIImage imageNamed:@"star_grey.png"]];
        }
        else if ([[NSString stringWithFormat:@"%@", [selectedVgood objectForKey:@"rating"]] isEqualToString:[NSString stringWithFormat:@"%i", 4]]){
            [localeStar1 setImage:[UIImage imageNamed:@"star_blue.png"]];
            [localeStar2 setImage:[UIImage imageNamed:@"star_blue.png"]];
            [localeStar3 setImage:[UIImage imageNamed:@"star_blue.png"]];
            [localeStar4 setImage:[UIImage imageNamed:@"star_blue.png"]];
            [localeStar5 setImage:[UIImage imageNamed:@"star_grey.png"]];
        }
        else if ([[NSString stringWithFormat:@"%@", [selectedVgood objectForKey:@"rating"]] isEqualToString:[NSString stringWithFormat:@"%i", 5]]){
            [localeStar1 setImage:[UIImage imageNamed:@"star_blue.png"]];
            [localeStar2 setImage:[UIImage imageNamed:@"star_blue.png"]];
            [localeStar3 setImage:[UIImage imageNamed:@"star_blue.png"]];
            [localeStar4 setImage:[UIImage imageNamed:@"star_blue.png"]];
            [localeStar5 setImage:[UIImage imageNamed:@"star_blue.png"]];
        }
        else {
            [localeStar1 setImage:[UIImage imageNamed:@"star_grey.png"]];
            [localeStar2 setImage:[UIImage imageNamed:@"star_grey.png"]];
            [localeStar3 setImage:[UIImage imageNamed:@"star_grey.png"]];
            [localeStar4 setImage:[UIImage imageNamed:@"star_grey.png"]];
            [localeStar5 setImage:[UIImage imageNamed:@"star_grey.png"]];
        }
        
    }
    else {
        [localeStar1 setImage:[UIImage imageNamed:@"star_grey.png"]];
        [localeStar2 setImage:[UIImage imageNamed:@"star_grey.png"]];
        [localeStar3 setImage:[UIImage imageNamed:@"star_grey.png"]];
        [localeStar4 setImage:[UIImage imageNamed:@"star_grey.png"]];
        [localeStar5 setImage:[UIImage imageNamed:@"star_grey.png"]];
    }
    
}

- (IBAction)clickedButton:(id)sender{
    
    scroll.scrollEnabled = NO;
    //NSLog(@" center size %@", NSStringFromCGPoint(rateView.center));
    
    rateView.frame = CGRectMake(scroll.contentOffset.x, scroll.contentOffset.y, rateView.frame.size.width, rateView.frame.size.height);
    
   
    
    if ([Beintoo isVirtualCurrencyStored]){
        // Developer's Currency Stored
        float currentCurrencyAmount         = [Beintoo getVirtualCurrencyBalance];
        float currentCost                   = [[selectedVgood objectForKey:@"virtualCurrencyPrice"] floatValue];
        float totalCurrentCurrencyAmount    = currentCurrencyAmount - currentCost;
        
        if (totalCurrentCurrencyAmount < 0){
            //No currency available for player or user
            float missingMoney = [[selectedVgood objectForKey:@"virtualCurrencyPrice"] floatValue] - [Beintoo getVirtualCurrencyBalance];
            
            noMoneyMessage.text             = [NSString stringWithFormat:NSLocalizedStringFromTable(@"MPnoMoneyToGetCoupon", @"BeintooLocalizable", @"Marketplace"), missingMoney, [Beintoo getVirtualCurrencyName]]; 
            
            noMoneyCouponDescription.text   = [selectedVgood objectForKey:@"description"];
            noMoneyCouponName.text          = [selectedVgood objectForKey:@"name"];
            noMoneyCouponEnddate.text       = [NSString stringWithFormat:@"%@ %@", NSLocalizedStringFromTable(@"endDate", @"BeintooLocalizable", nil),  [selectedVgood objectForKey:@"enddate"]];
            noMoneyCouponCost.text          = [NSString stringWithFormat:@"%@: %@", [Beintoo getVirtualCurrencyName], [selectedVgood objectForKey:@"virtualCurrencyPrice"]];
            
            [noMoneyActivity startAnimating];
            
            [self showWithAnimationForView:rateView withTag:[sender tag]];
            
            BImageDownload *download        = [[[BImageDownload alloc] init] autorelease];
            download.delegate               = self;
            download.urlString              = [selectedVgood objectForKey:@"imageUrl"];
            download.tag                    = 2222;
            noMoneyImageView.image          = download.image;
            
            [rateView addSubview:noMoneySubView];
            [noMoneySubView setCenter:CGPointMake(rateView.frame.size.width/2, rateView.frame.size.height/2)];
            [self showWithAnimationForView:rateView withTag:0];
        
        }
        else {
            
            [rateView addSubview:couponSubView];
            [couponSubView setCenter:CGPointMake(rateView.frame.size.width/2, rateView.frame.size.height/2)];
            
            couponDescription.text          = [selectedVgood objectForKey:@"description"];
            couponName.text                 = [selectedVgood objectForKey:@"name"];
            couponEnddate.text              = [NSString stringWithFormat:@"%@ %@", NSLocalizedStringFromTable(@"endDate", @"BeintooLocalizable", nil),[selectedVgood objectForKey:@"enddate"]];
            
            couponBedollars.text            = [NSString stringWithFormat:@"%@: %@", [Beintoo getVirtualCurrencyName], [selectedVgood objectForKey:@"virtualCurrencyPrice"]];
            
            [couponActivity startAnimating];
            
            [self showWithAnimationForView:rateView withTag:[sender tag]];
            
            BImageDownload *download        = [[[BImageDownload alloc] init] autorelease];
            download.delegate               = self;
            download.urlString              = [selectedVgood objectForKey:@"imageUrl"];
            download.tag                    = 1111;
            couponImageView.image           = download.image;
        }
    }
    else {
        //No Delevoper's Currency Stored, let's use Bedollars
        float currentCurrencyAmount         = [[[Beintoo getUserIfLogged] objectForKey:@"bedollars"] floatValue];
        float currentCost                   = [[selectedVgood objectForKey:@"bedollars"] floatValue];
        float totalCurrentCurrencyAmount    = currentCurrencyAmount - currentCost;
        
        if (![Beintoo isUserLogged]){
            //It's a player, he has no bedollars
            [self showFeatureSignupView];
        }
        else {
            //It's a user, he may own Bedollars
            if (totalCurrentCurrencyAmount < 0){
                //It's a user, he miss Bedollars to buy the coupon
                float missingMoney          = [[selectedVgood objectForKey:@"bedollars"] floatValue] - [[[Beintoo getUserIfLogged] objectForKey:@"bedollars"] floatValue];
                
                noMoneyMessage.text         = [NSString stringWithFormat:NSLocalizedStringFromTable(@"MPnoMoneyToGetCoupon", @"BeintooLocalizable", @"Marketplace"), missingMoney, NSLocalizedStringFromTable(@"bedollars", @"BeintooLocalizable", nil)]; 
                
                noMoneyCouponDescription.text = [selectedVgood objectForKey:@"description"];
                noMoneyCouponName.text      = [selectedVgood objectForKey:@"name"];
                noMoneyCouponEnddate.text   = [NSString stringWithFormat:@"%@ %@", NSLocalizedStringFromTable(@"endDate", @"BeintooLocalizable", nil), [selectedVgood objectForKey:@"enddate"]];
                noMoneyCouponCost.text      = [NSString stringWithFormat:@"%@: %@", NSLocalizedStringFromTable(@"bedollars", @"BeintooLocalizable", nil), [selectedVgood objectForKey:@"bedollars"]];
                
                [noMoneyActivity startAnimating];
                
                [self showWithAnimationForView:rateView withTag:[sender tag]];
                
                BImageDownload *download        = [[[BImageDownload alloc] init] autorelease];
                download.delegate               = self;
                download.urlString              = [selectedVgood objectForKey:@"imageUrl"];
                download.tag                    = 2222;
                noMoneyImageView.image          = download.image;
                
                [rateView addSubview:noMoneySubView];
                [noMoneySubView setCenter:CGPointMake(rateView.frame.size.width/2, rateView.frame.size.height/2)];
                
                [self showWithAnimationForView:rateView withTag:0];
            }
            else {
                //It's a user, he has Bedollars to buy the coupon
                [Beintoo setVirtualCurrencyBalance:totalCurrentCurrencyAmount];
                
                [rateView addSubview:couponSubView];
               [couponSubView setCenter:CGPointMake(rateView.frame.size.width/2, rateView.frame.size.height/2)];
                
                couponDescription.text          = [selectedVgood objectForKey:@"description"];
                couponName.text                 = [selectedVgood objectForKey:@"name"];
                couponEnddate.text              = [NSString stringWithFormat:@"%@ %@", NSLocalizedStringFromTable(@"endDate", @"BeintooLocalizable", nil), [selectedVgood objectForKey:@"enddate"]];
                if ([Beintoo isVirtualCurrencyStored]) {
                    couponBedollars.text        = [NSString stringWithFormat:@"%@: %@", [Beintoo getVirtualCurrencyName], [selectedVgood objectForKey:@"bedollars"]];
                }
                else {
                    couponBedollars.text        = [NSString stringWithFormat:@"%@: %@", NSLocalizedStringFromTable(@"bedollars", @"BeintooLocalizable", nil), [selectedVgood objectForKey:@"bedollars"]];
                }
                
                [couponActivity startAnimating];
                [self showWithAnimationForView:rateView withTag:[sender tag]];
                
                BImageDownload *download        = [[[BImageDownload alloc] init] autorelease];
                download.delegate               = self;
                download.urlString              = [selectedVgood objectForKey:@"imageUrl"];
                download.tag                    = 1111;
                couponImageView.image           = download.image;
                 
            }
        }
    }
    
    [self manageCoupon:sender];
}


- (IBAction)manageCoupon:(id)sender{
    
    if ([sender tag] == 444){
        [couponSendButton setHidden:YES];
        [couponGetButton setHidden:NO];
    }
    else if ([sender tag] == 555){
        [couponSendButton setHidden:NO];
        [couponGetButton setHidden:YES];
    }
}

- (IBAction)buyCoupon:(id)sender{
    
    //rateView.frame = CGRectMake(scroll.contentOffset.x, scroll.contentOffset.y, rateView.frame.size.width, rateView.frame.size.height);
    
    NSString *getRealURLWithLocation    = [selectedVgood objectForKey:@"showURL"];
    NSString *locationParams            = [Beintoo getUserLocationForURL];
    if (locationParams != nil) {
        getRealURLWithLocation          = [getRealURLWithLocation stringByAppendingString:locationParams];
    }
    
    NSString *elementsToSend            = [NSString stringWithFormat:@"&guid=%@", [Beintoo getPlayerID]];
    getRealURLWithLocation              = [getRealURLWithLocation stringByAppendingString:elementsToSend];
    
    if ([Beintoo isVirtualCurrencyStored]){
        // Developer's Currency Stored
        float currentCurrencyAmount     = [Beintoo getVirtualCurrencyBalance];
        float currentCost               = [[selectedVgood objectForKey:@"virtualCurrencyPrice"] floatValue];
        float totalCurrentCurrencyAmount = currentCurrencyAmount - currentCost;
        
        if (totalCurrentCurrencyAmount < 0){
            //No currency available for player or user
            float missingMoney = [[selectedVgood objectForKey:@"virtualCurrencyPrice"] floatValue] - [Beintoo getVirtualCurrencyBalance];
            
            noMoneyMessage.text         = [NSString stringWithFormat:NSLocalizedStringFromTable(@"MPnoMoneyToGetCoupon", @"BeintooLocalizable", @"Marketplace"), missingMoney, [Beintoo getVirtualCurrencyName]]; 
            
            noMoneyCouponDescription.text = [selectedVgood objectForKey:@"description"];
            noMoneyCouponName.text      = [selectedVgood objectForKey:@"name"];
            noMoneyCouponEnddate.text   = [NSString stringWithFormat:@"%@ %@", NSLocalizedStringFromTable(@"endDate", @"BeintooLocalizable", nil), [selectedVgood objectForKey:@"enddate"]];
            noMoneyCouponCost.text      = [NSString stringWithFormat:@"%@: %@", [Beintoo getVirtualCurrencyName], [selectedVgood objectForKey:@"virtualCurrencyPrice"]];
            
            [self showWithAnimationForView:rateView withTag:[sender tag]];
            
            BImageDownload *download        = [[[BImageDownload alloc] init] autorelease];
            download.delegate               = self;
            download.urlString              = [selectedVgood objectForKey:@"imageUrl"];
            download.tag                    = 2222;
            noMoneyImageView.image          = download.image;
            
            [rateView addSubview:noMoneySubView];
            [noMoneySubView setCenter:CGPointMake(rateView.frame.size.width/2, rateView.frame.size.height/2)];            
            [self showWithAnimationForView:rateView withTag:0];
            
        }
        else {
            
            [Beintoo setVirtualCurrencyBalance:totalCurrentCurrencyAmount];
            
            getRealURLWithLocation          = [getRealURLWithLocation stringByAppendingFormat:@"&developer_user_guid=%@", [Beintoo getDeveloperUserId]];
            
            _beintooShowVgood.urlToOpen         =  getRealURLWithLocation;
            /*_beintooShowVgood.caller        = @"MarketplaceSelectedCoupon";
            _beintooShowVgood.callerIstanceMP = self; */
            [self.navigationController pushViewController:_beintooShowVgood animated:YES];
            
        }
    }
    else {
        //No Delevoper's Currency Stored, let's use Bedollars
        float currentCurrencyAmount         = [[[Beintoo getUserIfLogged] objectForKey:@"bedollars"] floatValue];
        float currentCost                   = [[selectedVgood objectForKey:@"bedollars"] floatValue];
        float totalCurrentCurrencyAmount    = currentCurrencyAmount - currentCost;
        
        if (![Beintoo isUserLogged]){
            //It's a player, he has no bedollars
            [self showFeatureSignupView];
        }
        else {
            //It's a user, he may own Bedollars
            if (totalCurrentCurrencyAmount < 0){
                //It's a user, he miss Bedollars to buy the coupon
                float missingMoney          = [[selectedVgood objectForKey:@"bedollars"] floatValue] - [[[Beintoo getUserIfLogged] objectForKey:@"bedollars"] floatValue];
                
                noMoneyMessage.text         = [NSString stringWithFormat:NSLocalizedStringFromTable(@"MPnoMoneyToGetCoupon", @"BeintooLocalizable", @"Marketplace"), missingMoney, NSLocalizedStringFromTable(@"bedollars", @"BeintooLocalizable", nil)]; 
                
                noMoneyCouponDescription.text = [selectedVgood objectForKey:@"description"];
                noMoneyCouponName.text      = [selectedVgood objectForKey:@"name"];
                noMoneyCouponEnddate.text   = [NSString stringWithFormat:@"%@ %@", NSLocalizedStringFromTable(@"endDate", @"BeintooLocalizable", nil), [selectedVgood objectForKey:@"enddate"]];
                noMoneyCouponCost.text      = [NSString stringWithFormat:@"%@: %@",NSLocalizedStringFromTable(@"bedollars", @"BeintooLocalizable", nil), [selectedVgood objectForKey:@"bedollars"]];
                
                [self showWithAnimationForView:rateView withTag:[sender tag]];
                
                BImageDownload *download        = [[[BImageDownload alloc] init] autorelease];
                download.delegate               = self;
                download.urlString              = [selectedVgood objectForKey:@"imageUrl"];
                download.tag                    = 2222;
                noMoneyImageView.image          = download.image;
                
                [rateView addSubview:noMoneySubView];
                [noMoneySubView setCenter:CGPointMake(rateView.frame.size.width/2, rateView.frame.size.height/2)];
                
                [self showWithAnimationForView:rateView withTag:0];
            }
            else {
                //It's a user, he has Bedollars to buy the coupon
                
                _beintooShowVgood.urlToOpen         = getRealURLWithLocation;
                /*_beintooShowVgood.caller = @"MarketplaceCoupon";
                _beintooShowVgood.callerIstanceMP = self;*/
                [self.navigationController pushViewController:_beintooShowVgood animated:YES];
                          }
        }
    }
   // [getRealURLWithLocation release];
}

- (IBAction)sendAsGift:(id)sender{
    
    
    
    if ([Beintoo isVirtualCurrencyStored]){
        // Developer's Currency Stored
        float currentCurrencyAmount         = [Beintoo getVirtualCurrencyBalance];
        float currentCost                   = [[selectedVgood objectForKey:@"virtualCurrencyPrice"] floatValue];
        float totalCurrentCurrencyAmount    = currentCurrencyAmount - currentCost;
        
        if (![Beintoo isUserLogged]){
            //He's a player, he has no friends --> show Sign Up message
            [self showFeatureSignupView];
        }
        else {
            //He's a user, he has friends
            if (totalCurrentCurrencyAmount < 0){
                
                //User with no currency available
                float missingMoney          = [[selectedVgood objectForKey:@"virtualCurrencyPrice"] floatValue] - [Beintoo getVirtualCurrencyBalance];
                                
                noMoneyMessage.text         = [NSString stringWithFormat:NSLocalizedStringFromTable(@"MPnoMoneyToGetCoupon", @"BeintooLocalizable", @"Marketplace"), missingMoney, [Beintoo getVirtualCurrencyName]]; 
                
                noMoneyCouponDescription.text = [selectedVgood objectForKey:@"description"];
                noMoneyCouponName.text      = [selectedVgood objectForKey:@"name"];
                noMoneyCouponEnddate.text   = [NSString stringWithFormat:@"%@ %@", NSLocalizedStringFromTable(@"endDate", @"BeintooLocalizable", nil), [selectedVgood objectForKey:@"enddate"]];
                noMoneyCouponCost.text      = [NSString stringWithFormat:@"%@: %@", [Beintoo getVirtualCurrencyName], [selectedVgood objectForKey:@"virtualCurrencyPrice"]];
                
                [self showWithAnimationForView:rateView withTag:[sender tag]];
                
                BImageDownload *download        = [[[BImageDownload alloc] init] autorelease];
                download.delegate               = self;
                download.urlString              = [selectedVgood objectForKey:@"imageUrl"];
                download.tag                    = 2222;
                noMoneyImageView.image          = download.image;
                
                [rateView addSubview:noMoneySubView];
                [noMoneySubView setCenter:CGPointMake(rateView.frame.size.width/2, rateView.frame.size.height/2)];
                
                [self showWithAnimationForView:rateView withTag:0];
                
            }
            else {
                //User with currency available
                               
                NSDictionary *options           = [NSDictionary dictionaryWithObjectsAndKeys:selectedVgood, @"vGood", @"MarketplaceSendAsAGift", @"caller", self, @"callerVC", nil];
                
                friendsListVC.startingOptions   = options;
                //needsToReloadData = NO;
                friendsListVC.caller            = @"MarketplaceSelectedCoupon";
                friendsListVC.callerIstanceSC   = self; 
                
                [self.navigationController pushViewController:friendsListVC animated:YES];
                [friendsListVC release];
                friendsListVC = nil;
            }
            
        }
    }
    else {
        //No Delevoper's Currency Stored, let's use Bedollars
        float currentCurrencyAmount         = [[[Beintoo getUserIfLogged] objectForKey:@"bedollars"] floatValue];
        float currentCost                   = [[selectedVgood objectForKey:@"bedollars"] floatValue];
        float totalCurrentCurrencyAmount    = currentCurrencyAmount - currentCost;
        
        if (![Beintoo isUserLogged]){
            //It's a player, he has no bedollars
            [self showFeatureSignupView];
        }
        else {
            //It's a user, he may own Bedollars
            if (totalCurrentCurrencyAmount < 0){
                //It's a user, he miss Bedollars to buy the coupon
                float missingMoney          = [[selectedVgood objectForKey:@"virtualCurrencyPrice"] floatValue] - [Beintoo getVirtualCurrencyBalance];
                
                noMoneyMessage.text         = [NSString stringWithFormat:NSLocalizedStringFromTable(@"MPnoMoneyToGetCoupon", @"BeintooLocalizable", @"Marketplace"), missingMoney, NSLocalizedStringFromTable(@"bedollars", @"BeintooLocalizable", nil)];
                
                noMoneyCouponDescription.text = [selectedVgood objectForKey:@"description"];
                noMoneyCouponName.text      = [selectedVgood objectForKey:@"name"];
                noMoneyCouponEnddate.text   = [NSString stringWithFormat:@"%@ %@", NSLocalizedStringFromTable(@"endDate", @"BeintooLocalizable", nil), [selectedVgood objectForKey:@"enddate"]];
                noMoneyCouponCost.text      = [NSString stringWithFormat:@"%@: %@", NSLocalizedStringFromTable(@"bedollars", @"BeintooLocalizable", nil), [selectedVgood objectForKey:@"bedollars"]];
                
                [self showWithAnimationForView:rateView withTag:[sender tag]];
                
                BImageDownload *download        = [[[BImageDownload alloc] init] autorelease];
                download.delegate               = self;
                download.urlString              = [selectedVgood objectForKey:@"imageUrl"];
                download.tag                    = 2222;
                noMoneyImageView.image          = download.image;
                
                [rateView addSubview:noMoneySubView];
                [noMoneySubView setCenter:CGPointMake(rateView.frame.size.width/2, rateView.frame.size.height/2)];
                [self showWithAnimationForView:rateView withTag:0];
            }
            else {
                //It's a user, he has Bedollars to buy the coupon
                NSDictionary *options           = [NSDictionary dictionaryWithObjectsAndKeys:selectedVgood, @"vGood", @"MarketplaceSendAsAGift", @"caller", self, @"callerVC", nil];
                
                friendsListVC.startingOptions   = options;
                //needsToReloadData = NO;
                friendsListVC.caller            = @"MarketplaceSelectedCoupon";
                friendsListVC.callerIstanceSC   = self;
                
                [self.navigationController pushViewController:friendsListVC animated:YES];
            }
        }
    }
}


#pragma mark -
#pragma mark IBActions

- (IBAction)changeStarCondition:(id)sender{
    int senderTag = [sender tag];
    switch (senderTag) {
        case 51:
            [starButton1 setSelected:YES];
            [starButton2 setSelected:NO];
            [starButton3 setSelected:NO];
            [starButton4 setSelected:NO];
            [starButton5 setSelected:NO];
            break;
        case 52:
            [starButton1 setSelected:YES];
            [starButton2 setSelected:YES];
            [starButton3 setSelected:NO];
            [starButton4 setSelected:NO];
            [starButton5 setSelected:NO];
            break;
        case 53:
            [starButton1 setSelected:YES];
            [starButton2 setSelected:YES];
            [starButton3 setSelected:YES];
            [starButton4 setSelected:NO];
            [starButton5 setSelected:NO];
            break;
        case 54:
            [starButton1 setSelected:YES];
            [starButton2 setSelected:YES];
            [starButton3 setSelected:YES];
            [starButton4 setSelected:YES];
            [starButton5 setSelected:NO];
            break;
        case 55:
            [starButton1 setSelected:YES];
            [starButton2 setSelected:YES];
            [starButton3 setSelected:YES];
            [starButton4 setSelected:YES];
            [starButton5 setSelected:YES];
            break;
            
        default:
            break;
    }
}

- (IBAction)sendRate:(id)sender{
    if (starButton1.isSelected == YES){
        int rating = 0;
        if (starButton1.isSelected == YES)
            rating++;
        if (starButton2.isSelected == YES)
            rating++;
        if (starButton3.isSelected == YES)
            rating++;
        if (starButton4.isSelected == YES)
            rating++;
        if (starButton5.isSelected == YES)
            rating++;
        
        [BLoadingView startActivity:rateView];
        [_vgood setRatingForVgoodId:[selectedVgood objectForKey:@"id"] andUser:[Beintoo getUserID] withRate:rating];
    }
    else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedStringFromTable(@"MPwarning", @"BeintooLocalizable", nil) message:NSLocalizedStringFromTable(@"MPnoStarsSelected", @"BeintooLocalizable", nil) delegate:self cancelButtonTitle:NSLocalizedStringFromTable(@"ok", @"BeintooLocalizable", nil) otherButtonTitles: nil];
        alert.tag           = 90;
        [alert show];
        [alert release];
    }
}

- (IBAction)openDialog:(id)sender{
    int senderTag = [sender tag];
    rateView.frame = CGRectMake(scroll.contentOffset.x, scroll.contentOffset.y, rateView.frame.size.width, rateView.frame.size.height);
    scroll.scrollEnabled = NO;
    
    switch (senderTag) {
        case 11:
            
            if (![Beintoo isUserLogged]){
    
                [self showFeatureSignupView];
                    
            }
            else {
                _comments.selectedVgood = selectedVgood;
                [self.navigationController pushViewController:_comments animated:YES];
            }
            break;
        case 12:
            
            if (![Beintoo isUserLogged]){
                
                [self showFeatureSignupView];
                
            }
            else {
                
                [rateView addSubview:rateSubView];
                [rateSubView setCenter:CGPointMake(rateView.frame.size.width/2, rateView.frame.size.height/2)];
               // [rateSubView setCenter:CGPointMake(rateView.center.x, rateView.center.y)];
                [self showWithAnimationForView:rateView withTag:0];
            }
            break;
        case 13:
            
            break;
        case 14:
            
            _mapView.selectedVgood  = selectedVgood;
            _mapView.mapImage       = imgView.image;
            [self.navigationController pushViewController:_mapView animated:YES];
           
            break;
            
        default:
            break;
    }
    
}

- (IBAction)closeDialog:(id)sender{
    int senderTag = [sender tag];
    switch (senderTag) {
        case 21:
            //[self dismissKeyboard];
            //[self hideTextView];
           // [self hideWithAnimationForView:commentsView];
            //[scrollView setUserInteractionEnabled:YES];
            break;
        case 22:
            [self hideWithAnimationForView:rateView];
            [self clearStars];
            
            //[rateView removeFromSuperview];
           // [scrollView setUserInteractionEnabled:YES];
            break;
        case 23:
            //[self hideWithAnimationForView:commentsView];
            break;
        case 24:
            //[self hideWithAnimationForView:mapView];
            break;
            
        default:
            break;
    }
    scroll.scrollEnabled = YES;
    
    for(UIView *subview in [rateView subviews]) {
        [subview removeFromSuperview];
    }
}


#pragma mark -
#pragma mark BImageDownload Delegate Methods

- (void)bImageDownloadDidFinishDownloading:(BImageDownload *)download{
    if (download.tag == 2222){
        noMoneyImageView.image          = download.image;
        [noMoneyActivity stopAnimating];
        download.delegate               = nil;
    }
    else if (download.tag == 3333){
        imgView.image                   = download.image;
        [imgViewActivity stopAnimating];
        download.delegate               = nil;
    }
    else if (download.tag == 1111){
        couponImageView.image           = download.image;
        [couponActivity stopAnimating];
        download.delegate               = nil;
    }
    
}
- (void)bImageDownload:(BImageDownload *)download didFailWithError:(NSError *)error{
    NSLog(@"BeintooImageError: %@", [error localizedDescription]);
}


#pragma  mark - Beintoo callbacks

- (void)didSetRating:(NSDictionary *)result{
    
    [BLoadingView stopActivity];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:NSLocalizedStringFromTable(@"MPratingSent", @"BeintooLocalizable", nil) delegate:self cancelButtonTitle:nil otherButtonTitles:NSLocalizedStringFromTable(@"ok", @"BeintooLocalizable", nil), nil];
    alert.tag = 91;
    [alert show];
    [alert release];
    
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
    }	
}

#pragma mark -
#pragma mark AlertView

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex { 
    
    if (buttonIndex == 0){
        if (alertView.tag == 91){
            [self hideWithAnimationForView:rateView];
            scroll.scrollEnabled = YES;
        }
    }
}


@end
