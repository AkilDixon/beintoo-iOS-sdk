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

#import "Beintoo+Private.h"

@implementation Beintoo (Private)

static Beintoo* _sharedBeintoo = nil;
static NSString	*apiBaseUrl		= @"https://api.beintoo.com/api/rest";
static NSString	*sandboxBaseUrl = @"https://sandbox-elb.beintoo.com/api/rest";

NSString *BeintooActiveFeatures             = @"ActiveFeatures";
NSString *BeintooAppOrientation             = @"AppOrientation";
NSString *BeintooForceRegistration          = @"ForceRegistration";
NSString *BeintooApplicationWindow          = @"ApplicationWindow";
NSString *BeintooAchievementNotification    = @"BeintooAchievementNotification";
NSString *BeintooLoginNotification          = @"BeintooLoginNotification";
NSString *BeintooScoreNotification          = @"BeintooScoreNotification";
NSString *BeintooNoRewardNotification       = @"BeintooNoRewardNotification";
NSString *BeintooNotificationPosition       = @"BeintooNotificationPosition";
NSString *BeintooDismissAfterRegistration   = @"BeintooDismissAfterRegistration";
NSString *BeintooTryBeintooWithRewardImage  = @"BeintooTryBeintooWithRewardImage";

NSInteger BeintooNotificationPositionTop    = 1;
NSInteger BeintooNotificationPositionBottom = 2;

// BNS = BeintooNSUserDefaults
NSString *BNSDefLastLoggedPlayers	= @"beintooLastLoggedPlayers"; 
NSString *BNSDefLoggedPlayer		= @"NSLoggedPlayer";
NSString *BNSDefLoggedUser			= @"NSLoggedUser";
NSString *BNSDefIsUserLogged	    = @"beintooIsUserLogged";
NSString *BNSDefForceTryBeintoo     = @"beintooIsForceTryBeintoo";
NSString *BNSDefUserAgent           = @"beintooDeviceUserAgent";
NSString *BNSDefDeveloperCurrencyName   = @"beintooDeveloperCurrencyName";
NSString *BNSDefDeveloperCurrencyValue  = @"beintooDeveloperCurrencyValue";
NSString *BNSDefDeveloperLoggedUserId   = @"beintooDeveloperLoggedUserId";

+ (Beintoo *)sharedInstance{
	@synchronized([Beintoo class]){
		return _sharedBeintoo;
	}
}

+ (id)alloc{
	@synchronized([Beintoo class])
	{
		NSAssert(_sharedBeintoo == nil, @"Attempted to allocate a second instance of Beintoo singleton.");
		_sharedBeintoo = [super alloc];
		return _sharedBeintoo;
	}
	return nil;
}

+(id)init {
	if (self = [super init])
	{
	}
    return self;
}

+ (void)createSharedBeintoo{
	
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	
	[[Beintoo alloc] init];
	Beintoo *beintooInstance	= [Beintoo sharedInstance];
	
	beintooInstance->apiKey                 = [[NSString alloc] init];
	beintooInstance->apiSecret              = [[NSString alloc] init];
	beintooInstance->locationManager        = [[CLLocationManager alloc] init];
	beintooInstance->userLocation           = nil;
    //beintooInstance->lastGeneratedGood      = [[BVirtualGood alloc] init];
	beintooInstance->prizeView              = [[BPrize alloc] init];
    beintooInstance->missionView            = [[BMissionView alloc] init];
	beintooInstance->lastLoggedPlayers      = [[NSArray alloc] init];
	beintooInstance->featuresArray          = [[NSArray alloc] init];
	beintooInstance->notificationView       = [[BMessageAnimated alloc]init];
    beintooInstance->lastRetrievedMission   = [[NSDictionary alloc] init];
    beintooInstance->beintooDispatchQueue   = dispatch_queue_create("com.Beintoo.beintooQueue", NULL);

    beintooInstance->beintooPanelRootViewController     = [[BeintooVC alloc] init];
    beintooInstance->beintooMarketplaceViewController   = [[BeintooMarketplaceVC alloc] init];
    beintooInstance->beintooWalletViewController        = [[BeintooWalletVC alloc] init];
    beintooInstance->beintooLeaderboardWithContestVC    = [[BeintooLeaderboardContestVC alloc] init];
    beintooInstance->beintooLeaderboardVC               = [[BeintooLeaderboardVC alloc] init];

	[pool release];
}

+ (BOOL)isBeintooInitialized{
	if ([Beintoo sharedInstance] != nil) {
		return YES;
	}
	return NO;
}

+ (NSString *)getLastTimeForTryBeintooShowTimestamp{
    return [[NSUserDefaults standardUserDefaults] objectForKey:BNSDefForceTryBeintoo];
}
+ (void)setLastTimeForTryBeintooShowTimestamp:(NSString *)_value{
    [[NSUserDefaults standardUserDefaults] setObject:_value forKey:BNSDefForceTryBeintoo];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark -
#pragma mark Initialization

+ (void)setApiKey:(NSString *)_apikey andApisecret:(NSString *)_apisecret{
	Beintoo *beintooInstance	= [Beintoo sharedInstance];
	beintooInstance->apiKey		= [_apikey retain];
	beintooInstance->apiSecret	= [_apisecret retain];
}

+ (void)initMainController{
	Beintoo *beintooInstance                    = [Beintoo sharedInstance];
	beintooInstance->mainController             = [[BeintooMainController alloc] init];
	beintooInstance->mainController.view.alpha  = 0;
}

+ (void)initMainNavigationController{
	Beintoo *beintooInstance                    = [Beintoo sharedInstance];
	beintooInstance->mainNavigationController   = [[BeintooNavigationController alloc] init];
    
    //beintooInstance->mainNavigationController   = [[BeintooNavigationController alloc] initWithRootViewController:beintooInstance->beintooPanelRootViewController];
	[[beintooInstance->mainNavigationController navigationBar] setTintColor:[UIColor colorWithRed:108.0/255 green:128.0/255 blue:154.0/255 alpha:1.0]];
}

+ (void)initVgoodNavigationController{
	// This navigation controller is not initialized with a Root Controller. 
	// The root controller will change based on the type of vgood (Single, Multiple, Recommendation)
	Beintoo *beintooInstance = [Beintoo sharedInstance];
	beintooInstance->vgoodNavigationController = [BeintooVgoodNavController alloc];
	[[beintooInstance->vgoodNavigationController navigationBar] setTintColor:[UIColor colorWithRed:108.0/255 green:128.0/255 blue:154.0/255 alpha:1.0]];	
}

+ (void)initiPadController{
	Beintoo *beintooInstance = [Beintoo sharedInstance];
	beintooInstance->ipadController = [[BeintooiPadController alloc] init];
	beintooInstance->ipadController.view.alpha = 0;
}

+ (void)initVgoodService{
	
	if ([Beintoo sharedInstance]->beintooVgoodService != nil) {
		[[Beintoo sharedInstance]->beintooVgoodService release];
		//[Beintoo sharedInstance]->beintooVgoodService = nil;
	}
	[Beintoo sharedInstance]->beintooVgoodService = [[BeintooVgood alloc] init];
	NSLog(@"Vgood API service Initialized at URL: %@",[[Beintoo sharedInstance]->beintooVgoodService restResource]);
}

+ (void)initPlayerService{
	if ([Beintoo sharedInstance]->beintooPlayerService != nil) {
		[[Beintoo sharedInstance]->beintooPlayerService release];
		//[Beintoo sharedInstance]->beintooPlayerService = nil;
	}
	[Beintoo sharedInstance]->beintooPlayerService = [[BeintooPlayer alloc] init];
	NSLog(@"Player API service Initialized at URL: %@",[[Beintoo sharedInstance]->beintooPlayerService restResource]);
}

+ (void)initUserService{
	if ([Beintoo sharedInstance]->beintooUserService != nil) {
		[[Beintoo sharedInstance]->beintooUserService release];
		//[Beintoo sharedInstance]->beintooPlayerService = nil;
	}
	[Beintoo sharedInstance]->beintooUserService = [[BeintooUser alloc] init];
	NSLog(@"User API service Initialized at URL: %@", [[Beintoo sharedInstance]->beintooUserService restResource]);
}


+ (void)initAchievementsService{
	if ([Beintoo sharedInstance]->beintooAchievementsService != nil) {
		[[Beintoo sharedInstance]->beintooAchievementsService release];
	}
	[Beintoo sharedInstance]->beintooAchievementsService = [[BeintooAchievements alloc] init];
	NSLog(@"Achievements API service Initialized at URL: %@",[[Beintoo sharedInstance]->beintooAchievementsService restResource]);
}

+ (void)initMissionService{
	if ([Beintoo sharedInstance]->beintooMissionService != nil) {
		[[Beintoo sharedInstance]->beintooMissionService release];
	}
	[Beintoo sharedInstance]->beintooMissionService = [[BeintooMission alloc] init];
	NSLog(@"Mission API service Initialized at URL: %@",[[Beintoo sharedInstance]->beintooMissionService restResource]);
}

+ (void)initMarketplaceService{
	if ([Beintoo sharedInstance]->beintooMarketplaceService != nil) {
		[[Beintoo sharedInstance]->beintooMarketplaceService release];
	}
	[Beintoo sharedInstance]->beintooMarketplaceService = [[BeintooMarketplace alloc] init];
	NSLog(@"Marketplace API service Initialized at URL: %@",[[Beintoo sharedInstance]->beintooMarketplaceService restResource]);
}


+ (void)initBeintooSettings:(NSDictionary *)_settings{
	Beintoo *beintooInstance = [Beintoo sharedInstance];
	
	[Beintoo setAppOrientation:(int)[[_settings objectForKey:BeintooAppOrientation] intValue]];
	[Beintoo setForceRegistration:(BOOL)[[_settings objectForKey:BeintooForceRegistration] boolValue]];
    [Beintoo setShowAchievementNotificatio:(BOOL)[[_settings objectForKey:BeintooAchievementNotification] boolValue]];
    [Beintoo setShowLoginNotification:(BOOL)[[_settings objectForKey:BeintooLoginNotification] boolValue]];
    [Beintoo setShowScoreNotification:(BOOL)[[_settings objectForKey:BeintooScoreNotification] boolValue]];
    [Beintoo setShowNoRewardNotification:(BOOL)[[_settings objectForKey:BeintooNoRewardNotification] boolValue]];
    [Beintoo setDismissBeintooAfterRegistration:(BOOL)[[_settings objectForKey:BeintooDismissAfterRegistration] boolValue]];
    [Beintoo setTryBeintooImageTypeReward:(BOOL)[[_settings objectForKey:BeintooTryBeintooWithRewardImage] boolValue]];

    [Beintoo setNotificationPosition:(NSInteger)[[_settings objectForKey:BeintooNotificationPosition] integerValue]];
            
	beintooInstance->featuresArray = (NSArray *)[[_settings objectForKey:BeintooActiveFeatures] copy];
	[Beintoo setApplicationWindow:(UIWindow *)[_settings objectForKey:BeintooApplicationWindow]];
}

+ (void)initPopoversForiPad{
	Beintoo *beintooInstance = [Beintoo sharedInstance];
	beintooInstance->homePopover = [NSClassFromString(@"UIPopoverController") alloc];
	beintooInstance->homePopover.delegate = [Beintoo sharedInstance];
	[beintooInstance->homePopover setPopoverContentSize:CGSizeMake(320, 455)];
	
	beintooInstance->loginPopover = [NSClassFromString(@"UIPopoverController") alloc];
	beintooInstance->loginPopover.delegate = [Beintoo sharedInstance];
	[beintooInstance->loginPopover setPopoverContentSize:CGSizeMake(320, 455)];	

	beintooInstance->vgoodPopover = [NSClassFromString(@"UIPopoverController") alloc];
	beintooInstance->vgoodPopover.delegate = [Beintoo sharedInstance];
	[beintooInstance->vgoodPopover setPopoverContentSize:CGSizeMake(320, 455)];	

	beintooInstance->recommendationPopover = [NSClassFromString(@"UIPopoverController") alloc];
	beintooInstance->recommendationPopover.delegate = [Beintoo sharedInstance];
	[beintooInstance->recommendationPopover setPopoverContentSize:CGSizeMake(320, 455)];
}


+ (void)setAppOrientation:(int)_appOrientation{
	[Beintoo sharedInstance]->appOrientation = _appOrientation;
	NSLog(@"Beintoo: new App orientation set: %d",[Beintoo sharedInstance]->appOrientation);
}

     
+ (void)setApplicationWindow:(UIWindow *)_window{
	if (_window != nil) {
		[Beintoo sharedInstance]->applicationWindow = _window;
	}
}

+ (UIWindow *)getApplicationWindow{
	if ([Beintoo sharedInstance]->applicationWindow != nil) {
		return [Beintoo sharedInstance]->applicationWindow;
	}
	
	NSArray *developerApplicationWindows = [[UIApplication sharedApplication] windows];
	
	NSAssert([developerApplicationWindows count] > 0, @"Beintoo - To launch Beintoo your application needs at least one window!");
	UIWindow* appKeyWindow = [[UIApplication sharedApplication] keyWindow];
	if (!appKeyWindow){
		NSLog(@"Beintoo - No keyWindow found on this app. Beintoo will use the first UIWindow on the stack of app windows."); 
		appKeyWindow = [developerApplicationWindows objectAtIndex:0];
	}
	return appKeyWindow;
}

+ (void)initLocallySavedScoresArray{
	if ([[NSUserDefaults standardUserDefaults] objectForKey:@"locallySavedScores"]==nil) {
		[[NSUserDefaults standardUserDefaults] setObject:[NSMutableArray arrayWithCapacity:1] forKey:@"locallySavedScores"];
		[[NSUserDefaults standardUserDefaults] synchronize];
	}
}
+ (void)initLocallySavedAchievementsArray{
	if ([[NSUserDefaults standardUserDefaults] objectForKey:@"locallySavedAchievements"]==nil) {
		[[NSUserDefaults standardUserDefaults] setObject:[NSMutableArray arrayWithCapacity:1] forKey:@"locallySavedAchievements"];
		[[NSUserDefaults standardUserDefaults] synchronize];
	}
}

+ (void)initUserAgent{
    UIWebView   *webView = [[UIWebView alloc] initWithFrame:CGRectZero];
    NSString *userAgent = [webView stringByEvaluatingJavaScriptFromString:@"navigator.userAgent"];
    [webView release];		
        
    [[NSUserDefaults standardUserDefaults] setObject:userAgent forKey:BNSDefUserAgent];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


+ (void)setForceRegistration:(BOOL)_value{
	[Beintoo sharedInstance]->forceRegistration = _value;
}

+ (void)setShowAchievementNotificatio:(BOOL)_value{
    [Beintoo sharedInstance]->showAchievementNotification = _value;
}

+ (void)setShowLoginNotification:(BOOL)_value{
    [Beintoo sharedInstance]->showLoginNotification = _value;
}

+ (void)setShowScoreNotification:(BOOL)_value{
    [Beintoo sharedInstance]->showScoreNotification = _value;
}
+ (void)setShowNoRewardNotification:(BOOL)_value{
    [Beintoo sharedInstance]->showNoRewardNotification = _value;
}
+ (void)setDismissBeintooAfterRegistration:(BOOL)_value{
    [Beintoo sharedInstance]->dismissBeintooAfterRegistration = _value;    
}
+ (void)setNotificationPosition:(NSInteger)_value{
    [Beintoo sharedInstance]->notificationPosition  = _value;
}
+ (void)setForceTryBeintoo:(BOOL)_value{
    [Beintoo sharedInstance]->forceTryBeintoo  = _value;
}

+ (void)setTryBeintooImageTypeReward:(BOOL)_value{
    [Beintoo sharedInstance]->tryBeintooImageTypeReward = _value;
}

+ (void)_setIsStatusBarHiddenOnApp:(BOOL)_value{
    [Beintoo sharedInstance]->statusBarHiddenOnApp = _value;
}

+ (void)initAPI{
	[Beintoo sharedInstance]->restBaseUrl = apiBaseUrl;
	[Beintoo sharedInstance]->isOnSandbox = NO;
    [Beintoo sharedInstance]->isOnPrivateSandbox = NO;
}

// -------------------------------------------------------------------------
// Be sure to shutdown and re-initialize every service already initialized 
// when you switch to sandbox. This is VERY important.
// -------------------------------------------------------------------------

+ (void)switchToSandbox{ 
	NSLog(@"Beintoo: Going to sandbox");
	[Beintoo sharedInstance]->isOnSandbox = YES;
    [Beintoo sharedInstance]->isOnPrivateSandbox = NO;
    [Beintoo initVgoodService];
	[Beintoo initPlayerService];
    [Beintoo initUserService];
	[Beintoo initAchievementsService];
    [Beintoo initMissionService];
    [Beintoo initMarketplaceService];
    
}

+ (void)privateSandbox{ 
	NSLog(@"Beintoo: Going to private sandbox");
	[Beintoo sharedInstance]->restBaseUrl = sandboxBaseUrl;
	[Beintoo sharedInstance]->isOnPrivateSandbox = YES;
    [Beintoo sharedInstance]->isOnSandbox = NO;
	[Beintoo initVgoodService];
	[Beintoo initPlayerService];
    [Beintoo initUserService];
	[Beintoo initAchievementsService];
    [Beintoo initMissionService];
    [Beintoo initMarketplaceService];
    
}

+ (void)production{ 
	NSLog(@"Beintoo: Going to production");
    [Beintoo sharedInstance]->isOnPrivateSandbox = NO;
    [Beintoo sharedInstance]->isOnSandbox = NO;
	[self initAPI];
	[Beintoo initVgoodService];
	[Beintoo initPlayerService];
    [Beintoo initUserService];
	[Beintoo initAchievementsService];
    [Beintoo initMissionService];
    [Beintoo initMarketplaceService];
}

#pragma mark - StatusBar management

+ (void)manageStatusBarOnLaunch{
    [Beintoo _setIsStatusBarHiddenOnApp:[[UIApplication sharedApplication] isStatusBarHidden]];
    
    if (![BeintooDevice isiPad]){
        if (![Beintoo isStatusBarHiddenOnApp]){
            if([[UIApplication sharedApplication] respondsToSelector:@selector(setStatusBarHidden: withAnimation:)]) {
                [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
            }else{
                [[UIApplication sharedApplication] setStatusBarHidden:YES];
            }
            NSLog(@"Beintoo Status Bar Management: status bar temporarily hidden");
        }
    }
}

+ (void)manageStatusBarOnDismiss{
   
    if (![BeintooDevice isiPad]){
        if (![Beintoo isStatusBarHiddenOnApp]){
            if([[UIApplication sharedApplication] respondsToSelector:@selector(setStatusBarHidden: withAnimation:)]) {
                [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
            }else{
                [[UIApplication sharedApplication] setStatusBarHidden:NO];
            }
            NSLog(@"Beintoo Status Bar Management: status bar is visible again");
        }
    }
}

+ (void)_launchBeintooOnApp{
	id<BeintooMainDelegate> _mainDelegate = [Beintoo sharedInstance]->mainDelegate;
    
    Beintoo *beintooInstance              = [Beintoo sharedInstance];
    
    beintooInstance->mainNavigationController.viewControllers = nil;
    
    [beintooInstance->mainNavigationController initWithRootViewController:beintooInstance->beintooPanelRootViewController];
	
	if ([_mainDelegate respondsToSelector:@selector(beintooWillAppear)]) {
		[_mainDelegate beintooWillAppear];
	}	
    
    /*
     *  We check if we have to show the tryBeintoo
     *  First time or every 7 week
     */

    NSString *lastTryBeintooTimestamp = [Beintoo getLastTimeForTryBeintooShowTimestamp];
    NSInteger hoursFromLastTs         = [BeintooDevice elapsedHoursSinceTimestamp:lastTryBeintooTimestamp];
    [Beintoo setForceTryBeintoo:NO];
    
    [Beintoo manageStatusBarOnLaunch];
    
    if (hoursFromLastTs > HOURS_TO_SHOW_TRYBEINTOO) {  // 7 days
        [Beintoo setForceTryBeintoo:YES];
        [Beintoo setLastTimeForTryBeintooShowTimestamp:[BeintooDevice getFormattedTimestampNow]];
    }
    // ---------------------------------------------
    
	if (![BeintooDevice isiPad]) { // ------------ iPhone-iPod
		BeintooNavigationController *_mainNavController = [Beintoo sharedInstance]->mainNavigationController;
				
		[_mainNavController prepareBeintooPanelOrientation];
		[[Beintoo getApplicationWindow] addSubview:_mainNavController.view];
		[_mainNavController show];
	}
	else {  // ----------- iPad
		BeintooiPadController *_iPadController = [Beintoo sharedInstance]->ipadController;
				
		[_iPadController preparePopoverOrientation]; 
		[[Beintoo getApplicationWindow] addSubview:_iPadController.view];
		[_iPadController showBeintooPopover];
	}
}

+ (void)_launchBeintooOnAppWithDeveloperCurrencyValue:(float)_value{
    [self _setDeveloperCurrencyValue:_value];
	[self _launchBeintooOnApp];
}

+ (void)_launchMarketplaceOnApp{
	id<BeintooMainDelegate> _mainDelegate = [Beintoo sharedInstance]->mainDelegate;
    
    Beintoo *beintooInstance                                  = [Beintoo sharedInstance];
    beintooInstance->mainNavigationController.viewControllers = nil;
    [beintooInstance->mainNavigationController initWithRootViewController:beintooInstance->beintooMarketplaceViewController];
    
    [Beintoo manageStatusBarOnLaunch];
    
	if ([_mainDelegate respondsToSelector:@selector(beintooWillAppear)]) {
		[_mainDelegate beintooWillAppear];
	}	
	
	if (![BeintooDevice isiPad]) { // ------------ iPhone-iPod        
        BeintooNavigationController *_mainNavController = [Beintoo sharedInstance]->mainNavigationController;
        
		[_mainNavController prepareBeintooPanelOrientation];
		[[Beintoo getApplicationWindow] addSubview:_mainNavController.view];
		[_mainNavController show];
	}
	else {  // ----------- iPad
		BeintooiPadController *_iPadController = [Beintoo sharedInstance]->ipadController;
        
		[_iPadController preparePopoverOrientation]; 
		[[Beintoo getApplicationWindow] addSubview:_iPadController.view];
		[_iPadController showBeintooPopover];
	}
    
    
}

+ (void)_launchMarketplaceOnAppWithDeveloperCurrencyValue:(float)_value{
    [self _setDeveloperCurrencyValue:_value];
	[self _launchMarketplaceOnApp];
}

+ (void)_launchWalletOnApp{
	id<BeintooMainDelegate> _mainDelegate = [Beintoo sharedInstance]->mainDelegate;

    Beintoo *beintooInstance                                  = [Beintoo sharedInstance];
    beintooInstance->mainNavigationController.viewControllers = nil;
    [beintooInstance->mainNavigationController initWithRootViewController:beintooInstance->beintooWalletViewController];

	if ([_mainDelegate respondsToSelector:@selector(beintooWillAppear)]) {
		[_mainDelegate beintooWillAppear];
	}	
	
    [Beintoo manageStatusBarOnLaunch];
    
	if (![BeintooDevice isiPad]) { // ------------ iPhone-iPod        
        BeintooNavigationController *_mainNavController = [Beintoo sharedInstance]->mainNavigationController;

		[_mainNavController prepareBeintooPanelOrientation];
		[[Beintoo getApplicationWindow] addSubview:_mainNavController.view];
		[_mainNavController show];
	}
	else {  // ----------- iPad
		BeintooiPadController *_iPadController = [Beintoo sharedInstance]->ipadController;
        
		[_iPadController preparePopoverOrientation]; 
		[[Beintoo getApplicationWindow] addSubview:_iPadController.view];
		[_iPadController showBeintooPopover];
	}
}

+ (void)_launchLeaderboardOnApp{
	id<BeintooMainDelegate> _mainDelegate = [Beintoo sharedInstance]->mainDelegate;
    
    Beintoo *beintooInstance                                  = [Beintoo sharedInstance];
    beintooInstance->mainNavigationController.viewControllers = nil;
    [beintooInstance->mainNavigationController initWithRootViewController:beintooInstance->beintooLeaderboardVC];
    
    [Beintoo manageStatusBarOnLaunch];
    
	if ([_mainDelegate respondsToSelector:@selector(beintooWillAppear)]) {
		[_mainDelegate beintooWillAppear];
	}	
	
	if (![BeintooDevice isiPad]) { // ------------ iPhone-iPod        
        BeintooNavigationController *_mainNavController = [Beintoo sharedInstance]->mainNavigationController;
        
		[_mainNavController prepareBeintooPanelOrientation];
		[[Beintoo getApplicationWindow] addSubview:_mainNavController.view];
		[_mainNavController show];
	}
	else {  // ----------- iPad
		BeintooiPadController *_iPadController = [Beintoo sharedInstance]->ipadController;
        
		[_iPadController preparePopoverOrientation]; 
		[[Beintoo getApplicationWindow] addSubview:_iPadController.view];
		[_iPadController showBeintooPopover];
	}
}

+ (void)_launchPrizeOnApp{
	id<BeintooMainDelegate> _mainDelegate = [Beintoo sharedInstance]->mainDelegate;
    
	BPrize	*_prizeView = [Beintoo sharedInstance]->prizeView;
	
	if ([_mainDelegate respondsToSelector:@selector(beintooPrizeAlertWillAppear)]) {
		[_mainDelegate beintooPrizeAlertWillAppear];
	}
	
	[_prizeView setPrizeContentWithWindowSize:[Beintoo getApplicationWindow].bounds.size];
	[[Beintoo getApplicationWindow] addSubview:_prizeView];
	
	if ([_mainDelegate respondsToSelector:@selector(beintooPrizeAlertDidAppear)]) {
		[_mainDelegate beintooPrizeAlertDidAppear];
	}	
}

+ (void)_launchPrizeOnAppWithDelegate:(id<BeintooPrizeDelegate>)_beintooPrizeDelegate{
    id<BeintooMainDelegate> _mainDelegate = [Beintoo sharedInstance]->mainDelegate;
	
    BPrize	*_prizeView = [Beintoo sharedInstance]->prizeView;
    _prizeView.globalDelegate = _beintooPrizeDelegate;
    
    if ([_beintooPrizeDelegate respondsToSelector:@selector(beintooPrizeAlertWillAppear)]) {
		[_beintooPrizeDelegate beintooPrizeAlertWillAppear];
	}
    
	if ([_mainDelegate respondsToSelector:@selector(beintooPrizeAlertWillAppear)]) {
		[_mainDelegate beintooPrizeAlertWillAppear];
	}
	
	[_prizeView setPrizeContentWithWindowSize:[Beintoo getApplicationWindow].bounds.size];
	[[Beintoo getApplicationWindow] addSubview:_prizeView];
    
    if ([_beintooPrizeDelegate respondsToSelector:@selector(beintooPrizeAlertDidAppear)]) {
		[_beintooPrizeDelegate beintooPrizeAlertDidAppear];
	}
    
	if ([_mainDelegate respondsToSelector:@selector(beintooPrizeAlertDidAppear)]) {
		[_mainDelegate beintooPrizeAlertDidAppear];
	}	
    
}

+ (void)_launchMissionOnApp{
    id<BeintooMainDelegate> _mainDelegate = [Beintoo sharedInstance]->mainDelegate;
	
    BMissionView	*_missionView = [Beintoo sharedInstance]->missionView;
	
    [Beintoo manageStatusBarOnLaunch];
    
	if ([_mainDelegate respondsToSelector:@selector(beintooWillAppear)]) {
		[_mainDelegate beintooWillAppear];
	}	
	
	[_missionView setMissionContentWithWindowSize:[Beintoo getApplicationWindow].bounds.size];
	[[Beintoo getApplicationWindow] addSubview:_missionView];
	[_missionView show];
	
	if ([_mainDelegate respondsToSelector:@selector(beintooDidAppear)]) {
		[_mainDelegate beintooDidAppear];
	}	
}

+ (void)_launchIpadLogin{
	if ([BeintooDevice isiPad]) {
		BeintooiPadController *_iPadController = [Beintoo sharedInstance]->ipadController;
		[_iPadController showLoginPopover];
	}
}
+ (void)_dismissIpadLogin{
	if ([BeintooDevice isiPad]) {
		BeintooiPadController *_iPadController = [Beintoo sharedInstance]->ipadController;
		[_iPadController hideLoginPopover];
	}	
}

+ (void)_dismissBeintoo{
	id<BeintooMainDelegate> _mainDelegate = [Beintoo sharedInstance]->mainDelegate;
    
	if ([_mainDelegate respondsToSelector:@selector(beintooWillDisappear)]) {
		[_mainDelegate beintooWillDisappear];
	}
		
    [Beintoo manageStatusBarOnDismiss];
    
	if (![BeintooDevice isiPad]) { // iPhone-iPod
				
		BeintooNavigationController *_mainController = [Beintoo sharedInstance]->mainNavigationController;
        [_mainController popToRootViewControllerAnimated:NO];
		[_mainController hide];
	}
	else {  // ----------- iPad
		
		BeintooiPadController *_iPadController = [Beintoo sharedInstance]->ipadController;
		[_iPadController.popoverController dismissPopoverAnimated:NO];
		if (_iPadController.isLoginOngoing) {
			[_iPadController.loginPopoverController dismissPopoverAnimated:NO];
		}
		[_iPadController hideBeintooPopover];
     
	}
}

/*
 * Dismiss not animated: immediately remove the Beintoo view (no animation, behaviour similar to 
 * [UIViewController dismissModalViewControllerAnimated:NO]
 */ 
+ (void)_dismissBeintooNotAnimated{

    [Beintoo manageStatusBarOnDismiss];

    id<BeintooMainDelegate> _mainDelegate = [Beintoo sharedInstance]->mainDelegate;
	
	if ([_mainDelegate respondsToSelector:@selector(beintooWillDisappear)]) {
		[_mainDelegate beintooWillDisappear];
	}
    
	if (![BeintooDevice isiPad]) { // iPhone-iPod
        
		BeintooNavigationController *_mainController = [Beintoo sharedInstance]->mainNavigationController;
		[_mainController hideNotAnimated];
	}
	else {  // ----------- iPad
		
		BeintooiPadController *_iPadController = [Beintoo sharedInstance]->ipadController;
		[_iPadController.popoverController dismissPopoverAnimated:NO];
		if (_iPadController.isLoginOngoing) {
			[_iPadController.loginPopoverController dismissPopoverAnimated:NO];
		}
		[_iPadController hideBeintooPopover];
	}
}

+ (void)_dismissMission{
	id<BeintooMainDelegate> _mainDelegate = [Beintoo sharedInstance]->mainDelegate;
    
    [Beintoo manageStatusBarOnDismiss];
    
	if ([_mainDelegate respondsToSelector:@selector(beintooWillDisappear)]) {
		[_mainDelegate beintooWillDisappear];
	}
	
	if (![BeintooDevice isiPad]) { // iPhone-iPodTouch
		BeintooMainController *_mainController = [Beintoo sharedInstance]->mainController;
		[_mainController hideMissionVgoodNavigationController];
	}
	else {  // ----------- iPad
		
		BeintooiPadController *_iPadController = [Beintoo sharedInstance]->ipadController;
		[_iPadController.vgoodPopoverController dismissPopoverAnimated:NO];
		[_iPadController hideMissionVgoodPopover];
	}
}

+ (void)_dismissPrize{
	id<BeintooMainDelegate> _mainDelegate = [Beintoo sharedInstance]->mainDelegate;
    
    [Beintoo manageStatusBarOnDismiss];
    
    BPrize	*_prizeView = [Beintoo sharedInstance]->prizeView;
    if ([[_prizeView globalDelegate] respondsToSelector:@selector(beintooPrizeWillDisappear)]) {
		[[_prizeView globalDelegate] beintooPrizeWillDisappear];
	}
    
	if ([_mainDelegate respondsToSelector:@selector(beintooPrizeWillDisappear)]) {
		[_mainDelegate beintooPrizeWillDisappear];
	}
	
	if (![BeintooDevice isiPad]) { // iPhone-iPodTouch
		BeintooMainController *_mainController = [Beintoo sharedInstance]->mainController;
		[_mainController hideVgoodNavigationController];
	}
	else {  // ----------- iPad
		
		BeintooiPadController *_iPadController = [Beintoo sharedInstance]->ipadController;
		[_iPadController.vgoodPopoverController dismissPopoverAnimated:NO];
		[_iPadController hideVgoodPopover];
        
	}
    
    if ([[_prizeView globalDelegate] respondsToSelector:@selector(beintooPrizeDidDisappear)]) {
		[[_prizeView globalDelegate] beintooPrizeDidDisappear];
	}
}

+ (void)_dismissRecommendation{
	id<BeintooMainDelegate> _mainDelegate = [Beintoo sharedInstance]->mainDelegate;
	
    [Beintoo manageStatusBarOnDismiss];
    
	if (![BeintooDevice isiPad]) { // iPhone-iPodTouch
		
		if ([_mainDelegate respondsToSelector:@selector(beintooPrizeWillDisappear)]) {
			[_mainDelegate beintooPrizeWillDisappear];
		}
		
		BeintooMainController *_mainController = [Beintoo sharedInstance]->mainController;
		_mainController.view.alpha = 0;
		[_mainController.view removeFromSuperview];
		
		if ([_mainDelegate respondsToSelector:@selector(beintooPrizeDidDisappear)]) {
			[_mainDelegate beintooPrizeDidDisappear];
		}
	}
}

+ (void)_beintooDidAppear{
	id<BeintooMainDelegate> _mainDelegate = [Beintoo sharedInstance]->mainDelegate;
	if ([_mainDelegate respondsToSelector:@selector(beintooDidAppear)]) {
		[_mainDelegate beintooDidAppear];
	}	
}

+ (void)_beintooWillDisappear{
	id<BeintooMainDelegate> _mainDelegate = [Beintoo sharedInstance]->mainDelegate;
	if ([_mainDelegate respondsToSelector:@selector(beintooWillDisappear)]) {
		[_mainDelegate beintooWillDisappear];
	}		
}


+ (void)_beintooDidDisappear{
	id<BeintooMainDelegate> _mainDelegate = [Beintoo sharedInstance]->mainDelegate;
	if ([_mainDelegate respondsToSelector:@selector(beintooDidDisappear)]) {
		[_mainDelegate beintooDidDisappear];
	}		
}

+ (void)_prizeDidAppear{
	id<BeintooMainDelegate> _mainDelegate = [Beintoo sharedInstance]->mainDelegate;
	if ([_mainDelegate respondsToSelector:@selector(beintooPrizeDidAppear)]) {
		[_mainDelegate beintooPrizeDidAppear];
	}	
}

+ (void)_prizeDidDisappear{
	id<BeintooMainDelegate> _mainDelegate = [Beintoo sharedInstance]->mainDelegate;
	if ([_mainDelegate respondsToSelector:@selector(beintooPrizeDidDisappear)]) {
		[_mainDelegate beintooPrizeDidDisappear];
	}		
}

#pragma mark -
#pragma mark Player - user

+ (void)_setBeintooPlayer:(NSDictionary *)_player{
	
	if (_player != nil && [_player objectForKey:@"guid"]!=nil) {
		[[NSUserDefaults standardUserDefaults] setObject:_player forKey:BNSDefLoggedPlayer];
		
		// If the player is connected to a user, we also set the user
		if ([_player objectForKey:@"user"]) {
			[[NSUserDefaults standardUserDefaults] setObject:[_player objectForKey:@"user"] forKey:BNSDefLoggedUser];
			[[NSUserDefaults standardUserDefaults] setBool:YES forKey:BNSDefIsUserLogged];
		}
		else {
			[[NSUserDefaults standardUserDefaults] setBool:NO forKey:BNSDefIsUserLogged];
		}
		[[NSUserDefaults standardUserDefaults] synchronize];
	}
}

+ (void)_playerLogout{
	[[NSUserDefaults standardUserDefaults] setBool:NO forKey:BNSDefIsUserLogged];
	[[NSUserDefaults standardUserDefaults] setObject:nil forKey:BNSDefLoggedPlayer];
	[[NSUserDefaults standardUserDefaults] setObject:nil forKey:BNSDefLoggedUser];
	[[NSUserDefaults standardUserDefaults] synchronize];
}

+ (void)_setBeintooUser:(NSDictionary *)_user{
	if (_user != nil && [_user objectForKey:@"id"]) {
		[[NSUserDefaults standardUserDefaults] setObject:_user forKey:BNSDefLoggedUser];
		[[NSUserDefaults standardUserDefaults] setBool:YES forKey:BNSDefIsUserLogged];
		[[NSUserDefaults standardUserDefaults] synchronize];
	}
}

+ (void)_setLastVgood:(BVirtualGood *)_vgood{
	// IMPOSTARE QUALCHE CONDIZIONE
    
    if ([Beintoo sharedInstance]->lastGeneratedGood != nil) {
        [[Beintoo sharedInstance]->lastGeneratedGood release];
    }
   
	[Beintoo sharedInstance]->lastGeneratedGood     = _vgood;
    
    //[_vgood release];
}

+ (void)_setLastLoggedPlayers:(NSArray *)_players{
	if ([_players count]<1) {
		return;
	}
	[Beintoo sharedInstance]->lastLoggedPlayers = _players;
	//[[NSUserDefaults standardUserDefaults] setObject:_players forKey:BNSDefLastLoggedPlayers];
}

- (void)initDelegates{
	[Beintoo sharedInstance]->prizeView.delegate    = self;
    [Beintoo sharedInstance]->missionView.delegate  = self;
}

#pragma mark - Developer's Currency Methods

+ (void)_setDeveloperCurrencyName:(NSString *)_name{
    [[NSUserDefaults standardUserDefaults] setObject:_name forKey:BNSDefDeveloperCurrencyName];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSString *)_getDeveloperCurrencyName{
    return [[NSUserDefaults standardUserDefaults] objectForKey:BNSDefDeveloperCurrencyName];
}

+ (void)_setDeveloperUserId:(NSString *)_id{
    [[NSUserDefaults standardUserDefaults] setObject:_id forKey:BNSDefDeveloperLoggedUserId];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSString *)_getDeveloperUserId{
    return [[NSUserDefaults standardUserDefaults] objectForKey:BNSDefDeveloperLoggedUserId];
}

+ (void)_setDeveloperCurrencyValue:(float)_value{
    [[NSUserDefaults standardUserDefaults] setFloat:_value forKey:BNSDefDeveloperCurrencyValue];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (float)_getDeveloperCurrencyValue{
    return [[NSUserDefaults standardUserDefaults] floatForKey:BNSDefDeveloperCurrencyValue];
}

+ (void)_removeStoredCurrencyAndUser{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:BNSDefDeveloperCurrencyName];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:BNSDefDeveloperCurrencyValue];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:BNSDefDeveloperLoggedUserId];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (void)_removeUserId{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:BNSDefDeveloperLoggedUserId];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (BOOL)_isCurrencyStored{
    if ([[NSUserDefaults standardUserDefaults] objectForKey:BNSDefDeveloperCurrencyName] != nil && [[[NSUserDefaults standardUserDefaults] objectForKey:BNSDefDeveloperCurrencyName] length] > 0)
        return YES;
    
    else 
        return NO;
}

+ (BOOL)_isLoggedUserIdStored{
    if ([[NSUserDefaults standardUserDefaults] objectForKey:BNSDefDeveloperLoggedUserId] != nil && [[[NSUserDefaults standardUserDefaults] objectForKey:BNSDefDeveloperLoggedUserId] length] > 0)
        return YES;
    
    else 
        return NO;
}

#pragma mark -
#pragma mark PopoverDelegate


#ifdef UI_USER_INTERFACE_IDIOM
- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController {
	[Beintoo _dismissBeintoo];
}
#endif

#pragma mark -
#pragma mark PrizeDelegate

- (void)userDidTapOnThePrize{
	
	BVirtualGood *lastVgood = [Beintoo getLastGeneratedVGood];
    [Beintoo manageStatusBarOnLaunch];
    
	BeintooVgoodNavController *iPadVgoodNavigatorController = [Beintoo getVgoodNavigationController];
	BeintooMainController *mainNavigatorController          = [Beintoo sharedInstance]->mainController;
	
    id<BeintooMainDelegate>	  _mainDelegate         = [Beintoo sharedInstance]->mainDelegate;
    
    mainNavigatorController.viewControllers     = nil;
    iPadVgoodNavigatorController.viewControllers    = nil;
	
	if ([lastVgood isRecommendation]) { // ----------  RECOMMENDATION ------------- //
		// Initialization of the Recommendation Controller with the recommendation URL
        
		[mainNavigatorController.recommendationVC initWithNibName:@"BeintooVGoodShowVC" bundle:[NSBundle mainBundle] urlToOpen:lastVgood.getItRealURL];
        if ([BeintooDevice isiPad]) {
            [iPadVgoodNavigatorController initWithRootViewController:mainNavigatorController.recommendationVC];
        }
        else{
            [mainNavigatorController initWithRootViewController:mainNavigatorController.recommendationVC];
        }
	}
	else if ([lastVgood isMultiple]) {  // ----------  MULTIPLE VGOOD ------------- //
		// Initialize the Multiple vgood Controller with the list of options
		NSArray *vgoodList = [Beintoo getLastGeneratedVGood].theGoodsList;
        
		[mainNavigatorController.multipleVgoodVC initWithNibName:@"BeintooMultipleVgoodVC" bundle:[NSBundle mainBundle] 
                                                      andOptions:[NSDictionary dictionaryWithObjectsAndKeys:vgoodList,@"vgoodArray",/*self.popoverVgoodController,@"popoverController",*/nil]];
        if ([BeintooDevice isiPad]) {
            [iPadVgoodNavigatorController initWithRootViewController:mainNavigatorController.multipleVgoodVC];
        }
        else{
            [mainNavigatorController initWithRootViewController:mainNavigatorController.multipleVgoodVC];
        }
	}
	else {								// ----------  SINGLE VGOOD ------------- //
		// Initialize the Single vgood Controller with the generated vgood
        
        mainNavigatorController.singleVgoodVC.theVirtualGood = [Beintoo getLastGeneratedVGood];
        if ([BeintooDevice isiPad]) {
            [iPadVgoodNavigatorController initWithRootViewController:mainNavigatorController.singleVgoodVC];
        }
        else{
            [mainNavigatorController initWithRootViewController:mainNavigatorController.singleVgoodVC];
        }
	}
    
    BPrize	*_prizeView = [Beintoo sharedInstance]->prizeView;
	if ([[_prizeView globalDelegate] respondsToSelector:@selector(beintooPrizeWillAppear)]) {
		[[_prizeView globalDelegate] beintooPrizeWillAppear];
	}
	
    if ([_mainDelegate respondsToSelector:@selector(beintooPrizeWillAppear)]) {
		[_mainDelegate beintooPrizeWillAppear];
	}
    
	
	if (![BeintooDevice isiPad]) { // --- iPhone,iPod
		[mainNavigatorController prepareBeintooVgoodOrientation];
		[[Beintoo getApplicationWindow] addSubview:mainNavigatorController.view];
		[mainNavigatorController showVgoodNavigationController];
	}
	else {  // --- iPad
		BeintooiPadController *_iPadController = [Beintoo sharedInstance]->ipadController;
		
		[_iPadController preparePopoverOrientation]; 
		[[Beintoo getApplicationWindow] addSubview:_iPadController.view];
		[_iPadController showVgoodPopoverWithVGoodController:iPadVgoodNavigatorController];
	}
    
    if ([[_prizeView globalDelegate] respondsToSelector:@selector(beintooPrizeDidAppear)]) {
		[[_prizeView globalDelegate] beintooPrizeDidAppear];
	}
}

- (void)userDidTapOnClosePrize{
    
    BPrize	*_prizeView = [Beintoo sharedInstance]->prizeView;
    if ([[_prizeView globalDelegate] respondsToSelector:@selector(beintooPrizeAlertWillDisappear)]) {
		[[_prizeView globalDelegate] beintooPrizeAlertWillDisappear];
	}
    
	BVirtualGood *lastVgood = [Beintoo getLastGeneratedVGood];
	id<BeintooMainDelegate> _mainDelegate = [Beintoo sharedInstance]->mainDelegate;
	if ([lastVgood isMultiple]) {
		
		@synchronized(self){
			BeintooVgood *_vgoodService = [Beintoo beintooVgoodService];
			[_vgoodService acceptGoodWithId:lastVgood.vGoodID];
		}
	}
	[Beintoo sharedInstance]->mainController.view.alpha = 0;
	
    
    
	if ([[_prizeView globalDelegate] respondsToSelector:@selector(beintooPrizeAlertDidDisappear)]) {
		[[_prizeView globalDelegate] beintooPrizeAlertDidDisappear];
	}
    
	if ([_mainDelegate respondsToSelector:@selector(beintooPrizeAlertDidDisappear)]) {
		[_mainDelegate beintooPrizeAlertDidDisappear];
	}
    
}


#pragma mark -
#pragma mark MissionView Delegate
- (void)userDidTapOnCloseMission{
    id<BeintooMainDelegate> _mainDelegate = [Beintoo sharedInstance]->mainDelegate;
    
    [Beintoo manageStatusBarOnDismiss];
    
    if ([_mainDelegate respondsToSelector:@selector(beintooDidDisappear)]) {
		[_mainDelegate beintooDidDisappear];
	}
}

- (void)userDidTapOnMissionGetItReal{
    NSDictionary *lastMission   = [Beintoo getLastRetrievedMission];
    NSString *getItRealUrl      = [[lastMission objectForKey:@"vgood"] objectForKey:@"getRealURL"];
	BeintooVgoodNavController *vgoodNavController = [Beintoo getVgoodNavigationController];
	BeintooMainController *_vgoodController = [Beintoo sharedInstance]->mainController;
    _vgoodController.viewControllers = nil;
    
	
    // Initialization of the Recommendation Controller with the recommendation URL
    [_vgoodController.webViewVC initWithNibName:@"BeintooWebViewVC" bundle:[NSBundle mainBundle] urlToOpen:getItRealUrl];
    if ([BeintooDevice isiPad]) {
        [vgoodNavController initWithRootViewController:_vgoodController.webViewVC];
    }
    else{
        [_vgoodController initWithRootViewController:_vgoodController.webViewVC];
    }
	
	if (![BeintooDevice isiPad]) { // --- iPhone,iPod
		[_vgoodController prepareBeintooVgoodOrientation];
		[[Beintoo getApplicationWindow] addSubview:_vgoodController.view];
		[_vgoodController showMissionVgoodNavigationController];
		
	}
	else {  // --- iPad
		BeintooiPadController *_iPadController = [Beintoo sharedInstance]->ipadController;
		[_iPadController preparePopoverOrientation]; 
		[[Beintoo getApplicationWindow] addSubview:_iPadController.view];
		[_iPadController showMissionVgoodPopoverWithVGoodController:vgoodNavController];
	}
}


#pragma mark -
#pragma mark GPS

+ (void)_updateUserLocation{
	BOOL isLocationServicesEnabled;
	CLLocationManager *_locationManager = [Beintoo sharedInstance]->locationManager;
	_locationManager.delegate = [Beintoo sharedInstance];
	
	if ([_locationManager respondsToSelector:@selector(locationServicesEnabled)]) {
		isLocationServicesEnabled = [_locationManager locationServicesEnabled];	       
	}else {
        isLocationServicesEnabled = _locationManager.locationServicesEnabled;
	}
	if(!isLocationServicesEnabled){	
		NSLog(@"Beintoo - User has not accepted to use location services.");
		return;
	}
	[_locationManager startUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation{
    
    if([Beintoo sharedInstance]->userLocation != nil){
        [[Beintoo sharedInstance]->userLocation release];
    }
    
	[Beintoo sharedInstance]->userLocation = [newLocation retain];
    
	[manager stopUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
	NSLog(@"Error in localizing player: %@", [error description]);
}



@end
