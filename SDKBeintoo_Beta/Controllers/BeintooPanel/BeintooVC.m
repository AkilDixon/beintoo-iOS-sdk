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

#import "BeintooVC.h"
#import <QuartzCore/QuartzCore.h>

@implementation BeintooVC

@synthesize beintooPlayer,loginNavController,retrievedPlayersArray,loginVC,featuresArray,isNotificationCenterOpen;

#ifdef UI_USER_INTERFACE_IDIOM
@synthesize popOverController,loginPopoverController;
#endif

-(id)init {
	if (self != nil) {		
	}
	return self;
}

#pragma mark -
#pragma mark BeintooInitialization

- (void)setBeintooFeatures:(NSArray *)_featuresArray{
	// initial clean
	[self.featuresArray removeAllObjects];
	
	for (NSString *elem in _featuresArray) {
		NSMutableDictionary *panelElement = [[NSMutableDictionary alloc]init];
        [panelElement setObject:elem forKey:@"featureKey"];
		@try {
			if ([elem isEqualToString:@"Profile"]){
				[panelElement setObject:NSLocalizedStringFromTable(@"profile",@"BeintooLocalizable",@"") forKey:@"featureName"];
				[panelElement setObject:NSLocalizedStringFromTable(@"profileDesc",@"BeintooLocalizable",@"see your stats") forKey:@"featureDesc"];
				[panelElement setObject:@"beintoo_profile.png" forKey:@"featureImg"];
				[panelElement setObject:beintooProfileVC forKey:@"featureVC"];
			}
            if ([elem isEqualToString:@"Marketplace"]){
				[panelElement setObject:NSLocalizedStringFromTable(@"MPmarketplaceTitle",@"BeintooLocalizable", nil) forKey:@"featureName"];
				[panelElement setObject:NSLocalizedStringFromTable(@"MPdescription",@"BeintooLocalizable", nil) forKey:@"featureDesc"];
				[panelElement setObject:@"beintoo_marketplace.png" forKey:@"featureImg"];
				//[panelElement setObject:marketplaceVC forKey:@"featureVC"];
                [panelElement setObject:beintooMarketplaceWebViewVC forKey:@"featureVC"];
			}
			if ([elem isEqualToString:@"Leaderboard"]){
				[panelElement setObject:NSLocalizedStringFromTable(@"leaderboard",@"BeintooLocalizable",@"") forKey:@"featureName"];
				[panelElement setObject:NSLocalizedStringFromTable(@"leaderboardDesc",@"BeintooLocalizable",@"see the global scoring") forKey:@"featureDesc"];
				[panelElement setObject:@"beintoo_leaderboard.png" forKey:@"featureImg"];
				[panelElement setObject:beintooLeaderboardVC forKey:@"featureVC"];
			}
			if ([elem isEqualToString:@"Wallet"]){
				[panelElement setObject:NSLocalizedStringFromTable(@"wallet",@"BeintooLocalizable",@"") forKey:@"featureName"];
				[panelElement setObject:NSLocalizedStringFromTable(@"walletDesc",@"BeintooLocalizable",@"manage your virtual goods") forKey:@"featureDesc"];
				[panelElement setObject:@"beintoo_wallet.png" forKey:@"featureImg"];
				[panelElement setObject:beintooWalletVC forKey:@"featureVC"];
			}
			if ([elem isEqualToString:@"Challenges"]){
				[panelElement setObject:NSLocalizedStringFromTable(@"challenges",@"BeintooLocalizable",@"") forKey:@"featureName"];
				[panelElement setObject:NSLocalizedStringFromTable(@"challengesDesc",@"BeintooLocalizable",@"manage your challenges") forKey:@"featureDesc"];
				[panelElement setObject:@"beintoo_challenges.png" forKey:@"featureImg"];
				[panelElement setObject:beintooChallengesVC forKey:@"featureVC"];
			}
			if ([elem isEqualToString:@"Achievements"]){
				[panelElement setObject:NSLocalizedStringFromTable(@"achievements",@"BeintooLocalizable",@"") forKey:@"featureName"];
				[panelElement setObject:NSLocalizedStringFromTable(@"achievementsDesc",@"BeintooLocalizable",@"") forKey:@"featureDesc"];
				[panelElement setObject:@"beintoo_achievements.png" forKey:@"featureImg"];
				[panelElement setObject:beintooAchievementsVC forKey:@"featureVC"];
			}
            if ([elem isEqualToString:@"TipsAndForum"]){
				[panelElement setObject:NSLocalizedStringFromTable(@"tipsandforum",@"BeintooLocalizable",@"") forKey:@"featureName"];
				[panelElement setObject:NSLocalizedStringFromTable(@"tipsandforumDesc",@"BeintooLocalizable",@"") forKey:@"featureDesc"];
				[panelElement setObject:@"beintoo_forum.png" forKey:@"featureImg"];
				[panelElement setObject:tipsAndForumVC forKey:@"featureVC"];
			}
			
		}
		@catch (NSException * e){ 
            NSLog(@"Beintoo Error: Check your Beintoo feature settings, %@",e);
        }
		[self.featuresArray addObject:panelElement];
		[panelElement release];
	}
}

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
    if ([Beintoo getBeintooPanelRootViewController].isNotificationCenterOpen) {
        if ([BeintooDevice isiPad]) {
            // do something
        }else{
            [[Beintoo getBeintooPanelRootViewController] dismissModalViewControllerAnimated:YES];
        }
    }
    else{
        [Beintoo dismissBeintoo];
    }
}

#pragma mark -
#pragma mark UIViewController

- (void)viewDidLoad {
	[super viewDidLoad];
    
    // ----------- User service initialization ---------------
	_user           = [[BeintooUser alloc]init];
	beintooPlayer   = [[BeintooPlayer alloc]init];
	
    // ----------- Setup notification view to receive single taps --------------
    UITapGestureRecognizer *singleTapGestureRecognizer = [[UITapGestureRecognizer alloc]
                                                          initWithTarget:self action:@selector(handleNotificationSingleTap:)];
    singleTapGestureRecognizer.numberOfTapsRequired = 1;
    [notificationView addGestureRecognizer:singleTapGestureRecognizer];
    [singleTapGestureRecognizer release];
    
	// ----------- ViewControllers initialization ------------
	self.loginVC            = [[BeintooLoginVC alloc] initWithNibName:@"BeintooLoginVC" bundle:[NSBundle mainBundle]];
	beintooProfileVC        = [[BeintooProfileVC alloc]initWithNibName:@"BeintooProfileVC" bundle:[NSBundle mainBundle]];
    marketplaceVC           = [[BeintooMarketplaceVC alloc] initWithNibName:@"BeintooMarketplaceVC" bundle:[NSBundle mainBundle]];
    beintooMarketplaceWebViewVC = [[BeintooMarketplaceWebViewVC alloc] initWithNibName:@"BeintooMarketplaceWebViewVC" bundle:[NSBundle mainBundle]]; 
    
	beintooLeaderboardVC    = [[BeintooLeaderboardVC alloc]initWithNibName:@"BeintooLeaderboardVC" bundle:[NSBundle mainBundle]];
	beintooWalletVC         = [[BeintooWalletVC alloc]initWithNibName:@"BeintooWalletVC" bundle:[NSBundle mainBundle]];
	beintooChallengesVC     = [[BeintooChallengesVC alloc]initWithNibName:@"BeintooChallengesVC" bundle:[NSBundle mainBundle]];
	beintooAchievementsVC   = [[BeintooAchievementsVC alloc]initWithNibName:@"BeintooAchievementsVC" bundle:[NSBundle mainBundle]];
	messagesVC              = [[BeintooMessagesVC alloc] initWithNibName:@"BeintooMessagesVC" bundle:[NSBundle mainBundle] andOptions:nil];
    tipsAndForumVC          = [[BeintooBrowserVC alloc] initWithNibName:@"BeintooBrowserVC" bundle:[NSBundle mainBundle] urlToOpen:nil];
    [tipsAndForumVC setAllowCloseWebView:YES];
    
    featuresArray = [[NSMutableArray alloc] init];		
	[self setBeintooFeatures:[Beintoo getFeatureList]];
	
	homeNavController = [Beintoo getMainNavigationController];
	
	UIColor *barColor		= [UIColor colorWithRed:108.0/255 green:128.0/255 blue:154.0/255 alpha:1.0];
	self.loginNavController = [[UINavigationController alloc] initWithRootViewController:self.loginVC];
	[[self.loginNavController navigationBar] setTintColor:barColor];
    
	//self.title = @"Beintoo";
		
	[homeView setTopHeight:33.0f];
	[homeView setBodyHeight:444.0f];	
    homeView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;

    [notificationView setGradientType:GRADIENT_FOOTER_LIGHT];
    
    [notificationLogoView setGradientType:GRADIENT_NOTIF_CELL];
    notificationLogoView.layer.cornerRadius = 12.5f;
    notificationLogoView.layer.masksToBounds = YES;
    notificationLogoView.layer.borderColor = [[UIColor colorWithWhite:0 alpha:0.3] CGColor];
    notificationLogoView.layer.borderWidth = 0.5f;
    
    [notificationNumbersView setGradientType:GRADIENT_NOTIF_CELL];
    notificationNumbersView.layer.cornerRadius = 8.5f;
    notificationNumbersView.layer.masksToBounds = YES;
    notificationNumbersView.layer.borderColor = [[UIColor colorWithWhite:0 alpha:0.3] CGColor];
    notificationNumbersView.layer.borderWidth = 0.5f;

	homeTable.rowHeight = 70;
	homeTable.delegate = self;
	homeTable.dataSource = self;
        
    // TRY BEINTOO
    // ---------------------------------------------- Gamefy Portrait
    [tryBeintooPortrait setTopHeight:94.0f];
    [tryBeintooPortrait setBodyHeight:360.0f];
    tryBeintooPortrait.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    titleLabel1.text = NSLocalizedStringFromTable(@"tryBeintooTitleGamefy",@"BeintooLocalizable",@"Beintoo transforms");
    descLabel1.text = NSLocalizedStringFromTable(@"tryBeintooDescGamefy",@"BeintooLocalizable",@"");
    
    [button1 setHighColor:[UIColor colorWithRed:136.0/255 green:148.0/255 blue:164.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(156, 2)/pow(255,2) green:pow(168, 2)/pow(255,2) blue:pow(184, 2)/pow(255,2) alpha:1]];
	[button1 setMediumHighColor:[UIColor colorWithRed:106.0/255 green:125.0/255 blue:149.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(116, 2)/pow(255,2) green:pow(135, 2)/pow(255,2) blue:pow(159, 2)/pow(255,2) alpha:1]];
	[button1 setMediumLowColor:[UIColor colorWithRed:98.0/255 green:118.0/255 blue:144.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(108, 2)/pow(255,2) green:pow(128, 2)/pow(255,2) blue:pow(154, 2)/pow(255,2) alpha:1]];
    [button1 setLowColor:[UIColor colorWithRed:79.0/255 green:102.0/255 blue:132.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(89, 2)/pow(255,2) green:pow(112, 2)/pow(255,2) blue:pow(142, 2)/pow(255,2) alpha:1]];
	[button1 setTitle:NSLocalizedStringFromTable(@"tryBeintooAcceptButton",@"BeintooLocalizable",@"Try beintoo") forState:UIControlStateNormal];
	[button1 setButtonTextSize:20];
	
	[button2 setHighColor:[UIColor colorWithRed:176.0/255 green:188.0/255 blue:204.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(156, 2)/pow(255,2) green:pow(168, 2)/pow(255,2) blue:pow(184, 2)/pow(255,2) alpha:1]];
	[button2 setMediumHighColor:[UIColor colorWithRed:156.0/255 green:168.0/255 blue:190.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(116, 2)/pow(255,2) green:pow(135, 2)/pow(255,2) blue:pow(159, 2)/pow(255,2) alpha:1]];
	[button2 setMediumLowColor:[UIColor colorWithRed:152.0/255 green:164.0/255 blue:186.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(108, 2)/pow(255,2) green:pow(128, 2)/pow(255,2) blue:pow(154, 2)/pow(255,2) alpha:1]];
    [button2 setLowColor:[UIColor colorWithRed:119.0/255 green:142.0/255 blue:172.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(89, 2)/pow(255,2) green:pow(112, 2)/pow(255,2) blue:pow(142, 2)/pow(255,2) alpha:1]];
	[button2 setTitle:NSLocalizedStringFromTable(@"tryBeintooRefuseButton",@"BeintooLocalizable",@"no Thanks") forState:UIControlStateNormal];
	[button2 setButtonTextSize:15];

    // --------------------------------------------------------------- Gamefy Landscape
    
    [tryBeintooLandscape setTopHeight:84.0f];
    [tryBeintooLandscape setBodyHeight:342.0f];
    tryBeintooLandscape.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height);
    tryBeintooLandscape.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    titleLabel1Landscape.text = NSLocalizedStringFromTable(@"tryBeintooTitleGamefy",@"BeintooLocalizable", nil);
    descLabel1Landscape.text = NSLocalizedStringFromTable(@"tryBeintooDescGamefy",@"BeintooLocalizable", nil);

    [button1Landscape setHighColor:[UIColor colorWithRed:126.0/255 green:138.0/255 blue:154.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(156, 2)/pow(255,2) green:pow(168, 2)/pow(255,2) blue:pow(184, 2)/pow(255,2) alpha:1]];
	[button1Landscape setMediumHighColor:[UIColor colorWithRed:96.0/255 green:115.0/255 blue:139.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(116, 2)/pow(255,2) green:pow(135, 2)/pow(255,2) blue:pow(159, 2)/pow(255,2) alpha:1]];
	[button1Landscape setMediumLowColor:[UIColor colorWithRed:88.0/255 green:108.0/255 blue:134.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(108, 2)/pow(255,2) green:pow(128, 2)/pow(255,2) blue:pow(154, 2)/pow(255,2) alpha:1]];
    [button1Landscape setLowColor:[UIColor colorWithRed:89.0/255 green:92.0/255 blue:122.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(89, 2)/pow(255,2) green:pow(112, 2)/pow(255,2) blue:pow(142, 2)/pow(255,2) alpha:1]];
	[button1Landscape setTitle:NSLocalizedStringFromTable(@"tryBeintooAcceptButton",@"BeintooLocalizable",@"Try beintoo") forState:UIControlStateNormal];
	[button1Landscape setButtonTextSize:20];
	
	[button2Landscape setHighColor:[UIColor colorWithRed:176.0/255 green:188.0/255 blue:204.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(156, 2)/pow(255,2) green:pow(168, 2)/pow(255,2) blue:pow(184, 2)/pow(255,2) alpha:1]];
	[button2Landscape setMediumHighColor:[UIColor colorWithRed:156.0/255 green:168.0/255 blue:190.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(116, 2)/pow(255,2) green:pow(135, 2)/pow(255,2) blue:pow(159, 2)/pow(255,2) alpha:1]];
	[button2Landscape setMediumLowColor:[UIColor colorWithRed:152.0/255 green:164.0/255 blue:186.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(108, 2)/pow(255,2) green:pow(128, 2)/pow(255,2) blue:pow(154, 2)/pow(255,2) alpha:1]];
    [button2Landscape setLowColor:[UIColor colorWithRed:119.0/255 green:142.0/255 blue:172.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(89, 2)/pow(255,2) green:pow(112, 2)/pow(255,2) blue:pow(142, 2)/pow(255,2) alpha:1]];
	/*[button2Landscape setTitle:NSLocalizedStringFromTable(@"tryBeintooRefuseButton",@"BeintooLocalizable",@"no Thanks") forState:UIControlStateNormal];
    [button2Landscape setNumberOfLines:0];
	[button2Landscape setButtonTextSize:13];*/
    
    UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(2.5, 0, button2Landscape.frame.size.width - 5, 38)];
    textLabel.numberOfLines = 2;
    textLabel.backgroundColor = [UIColor clearColor];
    textLabel.textAlignment = UITextAlignmentCenter;
    textLabel.textColor = [UIColor colorWithWhite:1.0 alpha:1.0];
    textLabel.text = NSLocalizedStringFromTable(@"tryBeintooRefuseButton",@"BeintooLocalizable",@"no Thanks");
    textLabel.font = [UIFont systemFontOfSize:13];
    [textLabel setOpaque:YES];
    textLabel.shadowColor = [UIColor blackColor];
    textLabel.shadowOffset = CGSizeMake(0, -1);
    [button2Landscape addSubview:textLabel];
    [textLabel release];
    
    // ---------------------------------------------- Monetize Portrait
    [tryBeintooPortraitMonetize setTopHeight:94.0f];
    [tryBeintooPortraitMonetize setBodyHeight:360.0f];
    tryBeintooPortraitMonetize.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    tryBeintooHeaderPortraitMonetize.text = NSLocalizedStringFromTable(@"tryBeintooHeader", @"BeintooLocalizable", nil);
    tryBeintooHeaderPortraitMonetize.adjustsFontSizeToFitWidth = YES;
    titleLabel1Monetize.text = NSLocalizedStringFromTable(@"tryBeintooTitle",@"BeintooLocalizable",@"Beintoo transforms");
    titleLabel1Monetize.adjustsFontSizeToFitWidth = YES;
    descLabel1Monetize.text = NSLocalizedStringFromTable(@"tryBeintooDescCurrency",@"BeintooLocalizable",@"Beintoo transforms");
    descLabel1Monetize.adjustsFontSizeToFitWidth = YES;
    
    [button1Monetize setHighColor:[UIColor colorWithRed:136.0/255 green:148.0/255 blue:164.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(156, 2)/pow(255,2) green:pow(168, 2)/pow(255,2) blue:pow(184, 2)/pow(255,2) alpha:1]];
	[button1Monetize setMediumHighColor:[UIColor colorWithRed:106.0/255 green:125.0/255 blue:149.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(116, 2)/pow(255,2) green:pow(135, 2)/pow(255,2) blue:pow(159, 2)/pow(255,2) alpha:1]];
	[button1Monetize setMediumLowColor:[UIColor colorWithRed:98.0/255 green:118.0/255 blue:144.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(108, 2)/pow(255,2) green:pow(128, 2)/pow(255,2) blue:pow(154, 2)/pow(255,2) alpha:1]];
    [button1Monetize setLowColor:[UIColor colorWithRed:79.0/255 green:102.0/255 blue:132.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(89, 2)/pow(255,2) green:pow(112, 2)/pow(255,2) blue:pow(142, 2)/pow(255,2) alpha:1]];
	[button1Monetize setTitle:NSLocalizedStringFromTable(@"tryBeintooAcceptButton",@"BeintooLocalizable",@"Try beintoo") forState:UIControlStateNormal];
	[button1Monetize setButtonTextSize:20];
	
	[button2Monetize setHighColor:[UIColor colorWithRed:176.0/255 green:188.0/255 blue:204.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(156, 2)/pow(255,2) green:pow(168, 2)/pow(255,2) blue:pow(184, 2)/pow(255,2) alpha:1]];
	[button2Monetize setMediumHighColor:[UIColor colorWithRed:156.0/255 green:168.0/255 blue:190.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(116, 2)/pow(255,2) green:pow(135, 2)/pow(255,2) blue:pow(159, 2)/pow(255,2) alpha:1]];
	[button2Monetize setMediumLowColor:[UIColor colorWithRed:152.0/255 green:164.0/255 blue:186.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(108, 2)/pow(255,2) green:pow(128, 2)/pow(255,2) blue:pow(154, 2)/pow(255,2) alpha:1]];
    [button2Monetize setLowColor:[UIColor colorWithRed:119.0/255 green:142.0/255 blue:172.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(89, 2)/pow(255,2) green:pow(112, 2)/pow(255,2) blue:pow(142, 2)/pow(255,2) alpha:1]];
	[button2Monetize setTitle:NSLocalizedStringFromTable(@"tryBeintooRefuseButton",@"BeintooLocalizable",@"no Thanks") forState:UIControlStateNormal];
	[button2Monetize setButtonTextSize:15];
    
    
    // --------------------------------------------------------------- Monetize Landscape
    
    [tryBeintooLandscapeMonetize setTopHeight:84.0f];
    [tryBeintooLandscapeMonetize setBodyHeight:342.0f];
    tryBeintooLandscapeMonetize.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    tryBeintooLandscapeMonetize.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height);
    tryBeintooHeaderLandscapeMonetize.text = NSLocalizedStringFromTable(@"tryBeintooHeader", @"BeintooLocalizable", nil);
    tryBeintooHeaderLandscapeMonetize.adjustsFontSizeToFitWidth = YES;
    titleLabel1LandscapeMonetize.text = NSLocalizedStringFromTable(@"tryBeintooTitle",@"BeintooLocalizable",@"Beintoo transforms");
    titleLabel1LandscapeMonetize.adjustsFontSizeToFitWidth = YES;
    descLabel1LandscapeMonetize.text = NSLocalizedStringFromTable(@"tryBeintooDescCurrency",@"BeintooLocalizable",@"Beintoo transforms");
    descLabel1LandscapeMonetize.adjustsFontSizeToFitWidth = YES;
    
    [button1LandscapeMonetize setHighColor:[UIColor colorWithRed:126.0/255 green:138.0/255 blue:154.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(156, 2)/pow(255,2) green:pow(168, 2)/pow(255,2) blue:pow(184, 2)/pow(255,2) alpha:1]];
	[button1LandscapeMonetize setMediumHighColor:[UIColor colorWithRed:96.0/255 green:115.0/255 blue:139.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(116, 2)/pow(255,2) green:pow(135, 2)/pow(255,2) blue:pow(159, 2)/pow(255,2) alpha:1]];
	[button1LandscapeMonetize setMediumLowColor:[UIColor colorWithRed:88.0/255 green:108.0/255 blue:134.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(108, 2)/pow(255,2) green:pow(128, 2)/pow(255,2) blue:pow(154, 2)/pow(255,2) alpha:1]];
    [button1LandscapeMonetize setLowColor:[UIColor colorWithRed:89.0/255 green:92.0/255 blue:122.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(89, 2)/pow(255,2) green:pow(112, 2)/pow(255,2) blue:pow(142, 2)/pow(255,2) alpha:1]];
	[button1LandscapeMonetize setTitle:NSLocalizedStringFromTable(@"tryBeintooAcceptButton",@"BeintooLocalizable",@"Try beintoo") forState:UIControlStateNormal];
	[button1LandscapeMonetize setButtonTextSize:20];
	
	[button2LandscapeMonetize setHighColor:[UIColor colorWithRed:176.0/255 green:188.0/255 blue:204.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(156, 2)/pow(255,2) green:pow(168, 2)/pow(255,2) blue:pow(184, 2)/pow(255,2) alpha:1]];
	[button2LandscapeMonetize setMediumHighColor:[UIColor colorWithRed:156.0/255 green:168.0/255 blue:190.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(116, 2)/pow(255,2) green:pow(135, 2)/pow(255,2) blue:pow(159, 2)/pow(255,2) alpha:1]];
	[button2LandscapeMonetize setMediumLowColor:[UIColor colorWithRed:152.0/255 green:164.0/255 blue:186.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(108, 2)/pow(255,2) green:pow(128, 2)/pow(255,2) blue:pow(154, 2)/pow(255,2) alpha:1]];
    [button2LandscapeMonetize setLowColor:[UIColor colorWithRed:119.0/255 green:142.0/255 blue:172.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(89, 2)/pow(255,2) green:pow(112, 2)/pow(255,2) blue:pow(142, 2)/pow(255,2) alpha:1]];
	/*[button2LandscapeMonetize setTitle:NSLocalizedStringFromTable(@"tryBeintooRefuseButton",@"BeintooLocalizable",@"no Thanks") forState:UIControlStateNormal];
	[button2LandscapeMonetize setButtonTextSize:13]; */
    [button2LandscapeMonetize setNumberOfLines:0];
    textLabel = [[UILabel alloc] initWithFrame:CGRectMake(2.5, 1.5, button2LandscapeMonetize.frame.size.width - 5, 35)];
    textLabel.numberOfLines = 2;
    textLabel.backgroundColor = [UIColor clearColor];
    textLabel.textAlignment = UITextAlignmentCenter;
    textLabel.textColor = [UIColor colorWithWhite:1.0 alpha:1.0];
    textLabel.text = NSLocalizedStringFromTable(@"tryBeintooRefuseButton",@"BeintooLocalizable",@"no Thanks");
    textLabel.font = [UIFont systemFontOfSize:13];
    textLabel.shadowColor = [UIColor blackColor];
    textLabel.shadowOffset = CGSizeMake(0, -1);
    [button2LandscapeMonetize addSubview:textLabel];
    [textLabel release];
    
    // end of trybeintoo settings --------------------------------------------------------------------------------
    
	UIBarButtonItem *barCloseBtn = [[UIBarButtonItem alloc] initWithCustomView:[BeintooVC closeButton]];
	[self.navigationItem setRightBarButtonItem:barCloseBtn animated:YES];
	[barCloseBtn release];
    
    // Notifications
    notificationMainLabel.text = NSLocalizedStringFromTable(@"notifications",@"BeintooLocalizable",@"no Thanks");
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];

	if ([BeintooDevice isiPad]) {
        [self setContentSizeForViewInPopover:CGSizeMake(320, 415)];
    }
    
    if ([BeintooDevice isiPad]) {
        beintooUrl.frame = CGRectMake(beintooUrl.frame.origin.x, 387, beintooUrl.frame.size.width, beintooUrl.frame.size.height);
        beintooUrlMonetize.frame = CGRectMake(beintooUrlMonetize.frame.origin.x, 387, beintooUrlMonetize.frame.size.width, beintooUrlMonetize.frame.size.height);
    }
    else {
        beintooUrl.frame = CGRectMake(beintooUrl.frame.origin.x, 395, beintooUrl.frame.size.width, beintooUrl.frame.size.height);
        beintooUrlMonetize.frame = CGRectMake(beintooUrlMonetize.frame.origin.x, 395, beintooUrlMonetize.frame.size.width, beintooUrlMonetize.frame.size.height);
    }
                                
    //Add new try Beintoo if needed
    [[self.view viewWithTag:7777] removeFromSuperview];
    [tryBeintooView removeFromSuperview];
    if ([Beintoo isTryBeintooImageTypeReward]){  // IsImageTypeReward?
        if ([Beintoo appOrientation] == UIInterfaceOrientationPortraitUpsideDown || [Beintoo appOrientation] == UIInterfaceOrientationPortrait || [BeintooDevice isiPad]){
            tryBeintooView = tryBeintooPortraitMonetize;
            //[self.view addSubview:tryBeintooLandscapeMonetize];
        }
        else {
            tryBeintooView = tryBeintooLandscapeMonetize;
            //[self.view addSubview:tryBeintooLandscapeMonetize];
        }
    }
    else { 
        if ([Beintoo appOrientation] == UIInterfaceOrientationPortraitUpsideDown || [Beintoo appOrientation] == UIInterfaceOrientationPortrait || [BeintooDevice isiPad]){
            tryBeintooView = tryBeintooPortrait;
            //[self.view addSubview:tryBeintooPortrait];
        }
        else {
            tryBeintooView = tryBeintooLandscape;
        }
    }
    [self.view addSubview:tryBeintooView];
    
    tryBeintooView.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height);
    //tryBeintooView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    

    _user.delegate          = self;	
	beintooPlayer.delegate  = self;	

    isNotificationCenterOpen = NO;
    isAlreadyLogging         = NO;
    
    // --------------- forum&tips url
    if ([Beintoo isUserLogged]) {
        NSString *tipsUrl = [NSString stringWithFormat:@"http://appsforum.beintoo.com/?apikey=%@&userExt=%@#main",
                             [Beintoo getApiKey],[Beintoo getUserID]];
        [tipsAndForumVC setUrlToOpen:tipsUrl];
    }

    if (signupViewForPlayers != nil) {
        signupViewForPlayers = nil;
        [signupViewForPlayers release];
    }
    
    [[self.view viewWithTag:1111] removeFromSuperview];
    signupViewForPlayers = [[BSignupLayouts getBeintooDashboardSignupViewWithFrame:CGRectMake(0, 0 , self.view.bounds.size.width, 110) andButtonActionSelector:@selector(tryBeintoo) fromSender:self] retain];
    signupViewForPlayers.tag = 1111;
    [self.view addSubview:signupViewForPlayers];
    
    /*
	 * BeintooLogo + TRY BEINTOO settings
	 */
	int appOrientation = [Beintoo appOrientation];
	
	UIImageView *logo;
	if( !([BeintooDevice isiPad]) && 
        (appOrientation == UIInterfaceOrientationLandscapeLeft || appOrientation == UIInterfaceOrientationLandscapeRight) ){
		logo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bar_logo_34.png"]];
        
	}
	else { 
		logo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bar_logo.png"]];
	}
    	
	self.navigationItem.titleView = logo;
	[logo release];
	
    [tryBeintooView setNeedsDisplay];
    tryBeintooView.userInteractionEnabled = YES;
    
    if ([[Beintoo getPlayer] objectForKey:@"unreadNotification"] != nil) {
        notificationNumbersLabel.text = [NSString stringWithFormat:@"%@", [[Beintoo getPlayer] objectForKey:@"unreadNotification"]];
    }else{
        notificationNumbersLabel.text = @"0";
    }

	if ((![Beintoo isUserLogged] && [Beintoo isRegistrationForced]) || ![Beintoo getPlayerID] || (![Beintoo isUserLogged] && [Beintoo isTryBeintooForced])) {
        /*
         *  ------------------  Try Beintoo ---------------------
         */
        [tryBeintooView setHidden:NO];
        tryBeintooView.userInteractionEnabled = YES;
        homeTable.userInteractionEnabled = NO;
        [signupViewForPlayers setHidden:YES];
	}
	else {        
        [tryBeintooView setHidden:YES];
        [signupViewForPlayers setHidden:YES];
        homeTable.userInteractionEnabled = YES;
		[homeTable deselectRowAtIndexPath:[homeTable indexPathForSelectedRow] animated:NO];

        if (![Beintoo isUserLogged]) { 
            /*
             * ------------------- Dashboard for player! -----------------------
             */
            [signupViewForPlayers setHidden:NO];
            
            if(!homeTablePlayerAnimationPerformed){
                CGRect currentFrame = homeTable.frame;
                homeTable.frame = CGRectMake(currentFrame.origin.x, currentFrame.origin.y + 77, currentFrame.size.width, currentFrame.size.height - 77);
                homeTablePlayerAnimationPerformed = YES;
            }
        }
        else{
            /*
             * ------------------- Dashboard for users! -----------------------
             */
            @try {
                [signupViewForPlayers setHidden:YES];
                
                NSDictionary *currentUser = [Beintoo getUserIfLogged];
                
                userNick.text		= [currentUser objectForKey:@"nickname"];
                bedollars.text      = [NSString stringWithFormat:@"%.2f Bedollars", [[currentUser objectForKey:@"bedollars"] floatValue]];
                
                if(homeTablePlayerAnimationPerformed){
                    CGRect currentFrame = homeTable.frame;
                    homeTable.frame = CGRectMake(currentFrame.origin.x, currentFrame.origin.y - 77, currentFrame.size.width, currentFrame.size.height + 77);
                    homeTablePlayerAnimationPerformed = NO;
                }
            }
            @catch (NSException * e) {
            }
            
            if ([Beintoo getPlayerID] != nil && [Beintoo isUserLogged]) {
                [beintooPlayer getPlayerByGUID:[Beintoo getPlayerID]];
            }
        }
        [homeTable reloadData];
	}
}

#pragma mark - Taps Gesture 

- (void)handleNotificationSingleTap:(UITapGestureRecognizer *)sender{

    beintooNotificationListVC   = [[BeintooNotificationListVC alloc] init];    
    notificationNavController = [[UINavigationController alloc] initWithRootViewController:beintooNotificationListVC];
    
    UIColor *barColor		= [UIColor colorWithRed:108.0/255 green:128.0/255 blue:154.0/255 alpha:1.0];
    [[notificationNavController navigationBar] setTintColor:barColor];
	
    isNotificationCenterOpen    = YES;
    
    if ([BeintooDevice isiPad]) {
        [self.navigationController pushViewController:beintooNotificationListVC animated:YES];
    }
    else{
        [self presentModalViewController:notificationNavController animated:YES];
    }
    
    [beintooNotificationListVC release];
    [notificationNavController release];
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.featuresArray count];
}

- (float)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 38;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return notificationView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	NSString *CellIdentifier = [NSString stringWithFormat:@"Cell%d",indexPath.row];

	int _gradientType = (indexPath.row % 2) ? GRADIENT_CELL_HEAD : GRADIENT_CELL_BODY;
	
	BTableViewCell *cell = (BTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[BTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier andGradientType:_gradientType] autorelease];
    }
    
    float alphaValueForCell = 1.0;
    if (![Beintoo isUserLogged]) {
        NSString *featureName = [[self.featuresArray objectAtIndex:indexPath.row] objectForKey:@"featureKey"];
        if([featureName isEqualToString:@"TipsAndForum"] || [featureName isEqualToString:@"Challenges"]){
            alphaValueForCell = 0.4;
        }
    }
    
	@try {
		cell.textLabel.text				= [[self.featuresArray objectAtIndex:indexPath.row] objectForKey:@"featureName"];
		cell.textLabel.font				= [UIFont systemFontOfSize:18];
        cell.textLabel.alpha            = alphaValueForCell;
        
		cell.detailTextLabel.text		= [[self.featuresArray objectAtIndex:indexPath.row] objectForKey:@"featureDesc"];
        cell.detailTextLabel.alpha      = alphaValueForCell;
        
		cell.imageView.image			= [UIImage imageNamed:[[self.featuresArray objectAtIndex:indexPath.row] objectForKey:@"featureImg"]];
        cell.imageView.alpha            = alphaValueForCell;
	}
	@catch (NSException * e){
		//[beintooPlayer logException:[NSString stringWithFormat:@"STACK: %@\n\nException: %@",[NSThread callStackSymbols],e]];
	}

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (![Beintoo isUserLogged]) {
        
        /*
         *  If the user is not logged, some features are disables. 
         *  When one of those feature is selected, a subview is added to go to the signup.
         */
        
        NSString *featureName = [[self.featuresArray objectAtIndex:indexPath.row] objectForKey:@"featureKey"];
        if([featureName isEqualToString:@"TipsAndForum"]){
            UIView *featureView = [[BSignupLayouts getBeintooDashboardViewForLockedFeatureTipsAndForumWithFrame:CGRectMake(30, 70, 290, 220) andButtonActionSelector:@selector(tryBeintoo) fromSender:self] retain];
            featureView.tag = 3333;
            [self.view addSubview:featureView];
            [self.view bringSubviewToFront:featureView];
            [featureView release];
            [homeTable deselectRowAtIndexPath:[homeTable indexPathForSelectedRow] animated:YES];
        }
        else if([featureName isEqualToString:@"Challenges"]){
            UIView *featureView = [[BSignupLayouts getBeintooDashboardViewForLockedFeatureChallengesWithFrame:CGRectMake(30, 70, 290, 220) andButtonActionSelector:@selector(tryBeintoo) fromSender:self] retain];
            featureView.tag = 3333;
            [self.view addSubview:featureView];
            [self.view bringSubviewToFront:featureView];
            [featureView release];
            [homeTable deselectRowAtIndexPath:[homeTable indexPathForSelectedRow] animated:YES];

        }
        else{
            [[Beintoo getMainNavigationController] pushViewController:[[self.featuresArray objectAtIndex:indexPath.row] objectForKey:@"featureVC"] animated:YES];   
        }
    }
    else{
        [[Beintoo getMainNavigationController] pushViewController:[[self.featuresArray objectAtIndex:indexPath.row] objectForKey:@"featureVC"] animated:YES];   
    }
}  

#pragma mark -
#pragma mark IBActions

- (IBAction)tryBeintoo{	
    if (!isAlreadyLogging) {
        isAlreadyLogging = YES;
        @try {
            if ([BeintooNetwork connectedToNetwork]) {
                if ([Beintoo isRegistrationForced]) {
                    [BLoadingView startActivity:tryBeintooView];
                }
                else{
                    [BLoadingView startActivity:homeView];
                }
                
                [self.loginNavController popToRootViewControllerAnimated:NO];
                
            }
            [_user getUserByUDID];
        }
        @catch (NSException * e) {
        }
    }
}

-(IBAction)close{
    if (isNotificationCenterOpen) {
        if ([BeintooDevice isiPad]) {
            // Do something
        }else{
            [self dismissModalViewControllerAnimated:YES];
        }
    }
    else{
        [Beintoo dismissBeintoo];
    }
}

#pragma mark -
#pragma mark player delegate

- (void)didGetUserByUDID:(NSMutableArray *)result{
	@synchronized(self){
        //  if (self.isViewLoaded && self.view.window) { // This is to prevent to try to present the Login controller if the user closes      
        // Beintoo and the getUsesByUdid is still running for some reason. Presenting a 
        // modal from a ViewController which is not visible will lead to a crash
        
        [Beintoo setLastLoggedPlayers:[(NSArray *)result retain]];
        tryBeintooView.userInteractionEnabled = NO;
        
        [BLoadingView stopActivity]; 
        if([BeintooDevice isiPad]){ // --- iPad, we need to show the "Login Popover"
            [Beintoo launchIpadLogin];
        }
        else if ([BeintooNetwork connectedToNetwork]){
            [self presentModalViewController:self.loginNavController animated:YES];
        }
        isAlreadyLogging = NO;
        //}
    }	
}

- (void)player:(BeintooPlayer *)player getPlayerByGUID:(NSDictionary *)result{
	@try {
        if ([result objectForKey:@"user"]!=nil) {
			[Beintoo setBeintooPlayer:result];
			userNick.text  = [[Beintoo getUserIfLogged]objectForKey:@"nickname"];
			bedollars.text = [NSString stringWithFormat:@"%.2f Bedollars",[[[Beintoo getUserIfLogged] objectForKey:@"bedollars"] floatValue]];
			
			[BeintooMessage setTotalMessages:[[result objectForKey:@"user"]objectForKey:@"messages"]];
			[BeintooMessage setUnreadMessages:[[result objectForKey:@"user"]objectForKey:@"unreadMessages"]];

            // Alliance check
            if ([result objectForKey:@"alliance"] != nil) {
                [BeintooAlliance setUserWithAlliance:YES];
            }else{
                [BeintooAlliance setUserWithAlliance:NO];
            }
            
            // Notification Checking 
            if ([result objectForKey:@"unreadNotification"] != nil) {
                notificationNumbersLabel.text = [NSString stringWithFormat:@"%@", [result objectForKey:@"unreadNotification"]];
            }
		}
	}
	@catch (NSException * e) {
	}
}

- (void)dismissFeatureSignupView{
    UIView *featureView = [self.view viewWithTag:3333];
    [featureView removeFromSuperview];
}

#ifdef UI_USER_INTERFACE_IDIOM
- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController {
	[Beintoo dismissBeintoo];
}
#endif

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
    [super viewDidUnload];
}

- (void)viewWillDisappear:(BOOL)animated {
    @try {
		[BLoadingView stopActivity];
	}
	@catch (NSException * e) {
	}
}

- (void)viewDidDisappear:(BOOL)animated{
    _user.delegate         = nil;  
    beintooPlayer.delegate = nil;  
    
    @try {
        
        UIView *featureView = [self.view viewWithTag:3333];
        UIView *signupView  = [self.view viewWithTag:1111];
        [featureView removeFromSuperview];
        [signupView removeFromSuperview];
	}
	@catch (NSException * e) {
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return (interfaceOrientation == [Beintoo appOrientation]);
}

- (void)dealloc {
	[beintooPlayer release];
	[_user release];
	[featuresArray release];
	[messagesVC release];
	[beintooProfileVC release];
	[beintooLeaderboardVC release];
	[beintooWalletVC release];
	[beintooChallengesVC release];
	[beintooAchievementsVC release];
    [tipsAndForumVC release];
	[loginVC release];
    [signupViewForPlayers release];
    [marketplaceVC release];
    [beintooMarketplaceWebViewVC release];
    [beintooMarketplaceWebViewVC release];
	[super dealloc];
}

@end
