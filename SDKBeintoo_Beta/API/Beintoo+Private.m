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

static Beintoo* _sharedBeintoo              = nil;
static NSString	*apiBaseUrl                 = @"https://api.beintoo.com/api/rest";
static NSString	*sandboxBaseUrl             = @"https://sandbox-elb.beintoo.com/api/rest";

static NSString	*displayBaseUrl             = @"http://display.beintoo.com/api/rest";
static NSString	*sandboxDisplayBaseUrl      = @"http://display-sand.beintoo.com/api/rest";

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
NSString *BNSDefLastLoggedPlayers           = @"beintooLastLoggedPlayers"; 
NSString *BNSDefLoggedPlayer                = @"NSLoggedPlayer";
NSString *BNSDefLoggedUser                  = @"NSLoggedUser";
NSString *BNSDefIsUserLogged                = @"beintooIsUserLogged";
NSString *BNSDefForceTryBeintoo             = @"beintooIsForceTryBeintoo";
NSString *BNSDefUserAgent                   = @"beintooDeviceUserAgent";
NSString *BNSDefDeveloperCurrencyName       = @"beintooDeveloperCurrencyName";
NSString *BNSDefDeveloperCurrencyValue      = @"beintooDeveloperCurrencyValue";
NSString *BNSDefDeveloperLoggedUserId       = @"beintooDeveloperLoggedUserId";
NSString *BNSDefUserFriends                 = @"beintooUserFriends";

NSString *BeintooSdkVersion                 = @"3.0.0beta-ios";
NSString *BeintooPlatform                   = @"iOS";

NSString *BeintooNotificationSignupClosed           = @"BeintooSignupClosed";
NSString *BeintooNotificationOrientationChanged     = @"BeintooOrientationChanged";
NSString *BeintooNotificationReloadDashboard        = @"BeintooReloadDashboard";
NSString *BeintooNotificationReloadFriendsList      = @"BeintooReloadFriendsList";
NSString *BeintooNotificationChallengeSent          = @"BeintooChallengeSent";
NSString *BeintooNotificationCloseBPickerView       = @"BeintooCloseBPickerView";

#pragma mark - Init methods

+ (Beintoo *)sharedInstance
{
	@synchronized([Beintoo class]){
		return _sharedBeintoo;
	}
}

+ (id)alloc
{
	@synchronized([Beintoo class])
	{
		NSAssert(_sharedBeintoo == nil, @"Attempted to allocate a second instance of Beintoo singleton.");
		_sharedBeintoo = [super alloc];
		return _sharedBeintoo;
	}
	return nil;
}

+ (id)init
{
    if (self == [super init])
	{
	}
    return self;
}

+ (void)createSharedBeintoo
{
	
#ifdef BEINTOO_ARC_AVAILABLE
    @autoreleasepool {
#else
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
#endif
	
	_sharedBeintoo = [[Beintoo alloc] init];
	Beintoo *beintooInstance	= [Beintoo sharedInstance];
	
	beintooInstance->apiKey                 = [[NSString alloc] init];
	beintooInstance->apiSecret              = [[NSString alloc] init];
	beintooInstance->locationManager        = [[CLLocationManager alloc] init];
	beintooInstance->userLocation           = nil;
    
    beintooInstance->notificationView       = [[BMessageAnimated alloc] init];
    beintooInstance->lastRetrievedMission   = [[NSDictionary alloc] init];
    
    beintooInstance->notificationQueue      = [[BAnimatedNotificationQueue alloc] init];
 
    beintooInstance->beintooDispatchQueue   = dispatch_queue_create("com.Beintoo.beintooQueue", NULL);
    
#ifdef BEINTOO_ARC_AVAILABLE
    }
#else
    [pool release];
#endif
	
}

+ (BOOL)isBeintooInitialized
{
	if ([Beintoo sharedInstance] != nil) {
		return YES;
	}
	return NO;
}

+ (void)setApiKey:(NSString *)_apikey andApisecret:(NSString *)_apisecret
{
	Beintoo *beintooInstance	= [Beintoo sharedInstance];
    
#ifdef BEINTOO_ARC_AVAILABLE
    beintooInstance->apiKey		= _apikey;
	beintooInstance->apiSecret	= _apisecret;
#else
    beintooInstance->apiKey		= [_apikey retain];
    beintooInstance->apiSecret	= [_apisecret retain];
#endif
	
}

+ (void)initBeintooSettings:(NSDictionary *)_settings{
    if (_settings == nil || [_settings count] == 0)
        return;
    
    if ([_settings objectForKey:BeintooAppOrientation])
        [Beintoo setAppOrientation:(int)[[_settings objectForKey:BeintooAppOrientation] intValue]];
    
    if ([_settings objectForKey:BeintooNotificationPosition])
        [Beintoo setNotificationPosition:(NSInteger)[[_settings objectForKey:BeintooNotificationPosition] integerValue]];
    
    if ([_settings objectForKey:BeintooApplicationWindow])
        [Beintoo setApplicationWindow:(UIWindow *)[_settings objectForKey:BeintooApplicationWindow]];
    
    if ([_settings objectForKey:BeintooLoginNotification])
        [Beintoo setShowLoginNotification:(UIWindow *)[_settings objectForKey:BeintooLoginNotification]];
    
    if ([_settings objectForKey:BeintooAchievementNotification])
        [Beintoo setShowAchievementNotificatio:(UIWindow *)[_settings objectForKey:BeintooAchievementNotification]];
    
    if ([_settings objectForKey:BeintooNoRewardNotification])
        [Beintoo setShowNoRewardNotification:(UIWindow *)[_settings objectForKey:BeintooNoRewardNotification]];
}

+ (void)setShowAchievementNotificatio:(BOOL)_value
{
    [Beintoo sharedInstance]->showAchievementNotification = _value;
}

+ (void)setShowLoginNotification:(BOOL)_value
{
    [Beintoo sharedInstance]->showLoginNotification = _value;
}

+ (void)setShowScoreNotification:(BOOL)_value
{
    [Beintoo sharedInstance]->showScoreNotification = _value;
}

+ (void)setShowNoRewardNotification:(BOOL)_value
{
    [Beintoo sharedInstance]->showNoRewardNotification = _value;
}

+ (void)setNotificationPosition:(NSInteger)_value
{
    [Beintoo sharedInstance]->notificationPosition  = _value;
}

+ (void)initLocallySavedScoresArray
{
	if ([[NSUserDefaults standardUserDefaults] objectForKey:@"locallySavedScores"] == nil) {
		[[NSUserDefaults standardUserDefaults] setObject:[NSMutableArray arrayWithCapacity:1] forKey:@"locallySavedScores"];
		[[NSUserDefaults standardUserDefaults] synchronize];
	}
}

+ (void)initLocallySavedAchievementsArray
{
	if ([[NSUserDefaults standardUserDefaults] objectForKey:@"locallySavedAchievements"] == nil) {
		[[NSUserDefaults standardUserDefaults] setObject:[NSMutableArray arrayWithCapacity:1] forKey:@"locallySavedAchievements"];
		[[NSUserDefaults standardUserDefaults] synchronize];
	}
}

+ (void)initUserAgent
{
    UIWebView   *webView = [[UIWebView alloc] initWithFrame:CGRectZero];
    NSString *userAgent = [webView stringByEvaluatingJavaScriptFromString:@"navigator.userAgent"];
    
#ifdef BEINTOO_ARC_AVAILABLE
#else
    [webView release];
#endif
    
    [[NSUserDefaults standardUserDefaults] setObject:userAgent forKey:BNSDefUserAgent];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark - API Services

+ (void)initAPI
{
	[Beintoo sharedInstance]->restBaseUrl = apiBaseUrl;
    [Beintoo sharedInstance]->displayBaseUrl = displayBaseUrl;
	[Beintoo sharedInstance]->isOnSandbox = NO;
    [Beintoo sharedInstance]->isOnPrivateSandbox = NO;
}

+ (void)initPlayerService
{
	if ([Beintoo sharedInstance]->beintooPlayerService != nil) {

#ifdef BEINTOO_ARC_AVAILABLE
        [Beintoo sharedInstance]->beintooPlayerService = nil;
#else
        [[Beintoo sharedInstance]->beintooPlayerService release];
#endif
        
	}
    [Beintoo sharedInstance]->beintooPlayerService = [[BeintooPlayer alloc] init];
	BeintooLOG(@"Player API service Initialized at URL: %@", [[Beintoo sharedInstance]->beintooPlayerService restResource]);
}

+ (void)initUserService
{
	if ([Beintoo sharedInstance]->beintooUserService != nil) {
        
#ifdef BEINTOO_ARC_AVAILABLE
        [Beintoo sharedInstance]->beintooUserService = nil;
#else
        [[Beintoo sharedInstance]->beintooUserService release];
#endif
        
    }
    
	[Beintoo sharedInstance]->beintooUserService = [[BeintooUser alloc] init];
	BeintooLOG(@"User API service Initialized at URL: %@", [[Beintoo sharedInstance]->beintooUserService restResource]);
}

+ (void)initAchievementsService
{
	if ([Beintoo sharedInstance]->beintooAchievementsService != nil) {
        
#ifdef BEINTOO_ARC_AVAILABLE
        [Beintoo sharedInstance]->beintooAchievementsService = nil;
#else
        [[Beintoo sharedInstance]->beintooAchievementsService release];
#endif
        
	}
    
	[Beintoo sharedInstance]->beintooAchievementsService = [[BeintooAchievements alloc] init];
	BeintooLOG(@"Achievements API service Initialized at URL: %@",[[Beintoo sharedInstance]->beintooAchievementsService restResource]);
}

+ (void)initBestoreService{
	if ([Beintoo sharedInstance]->beintooBestoreService != nil) {
        
#ifdef BEINTOO_ARC_AVAILABLE
        [Beintoo sharedInstance]->beintooBestoreService = nil;
#else
        [[Beintoo sharedInstance]->beintooBestoreService release];
#endif
        
	}
	[Beintoo sharedInstance]->beintooBestoreService = [[BeintooBestore alloc] init];
	BeintooLOG(@"Bestore API service Initialized at URL: %@",[[Beintoo sharedInstance]->beintooBestoreService restResource]);
}

+ (void)initAppService{
	if ([Beintoo sharedInstance]->beintooAppService != nil) {
        
#ifdef BEINTOO_ARC_AVAILABLE
        [Beintoo sharedInstance]->beintooAppService = nil;
#else
        [[Beintoo sharedInstance]->beintooAppService release];
#endif
        
	}
	[Beintoo sharedInstance]->beintooAppService = [[BeintooApp alloc] init];
	BeintooLOG(@"App API service Initialized at URL: %@", [[Beintoo sharedInstance]->beintooAppService restResource]);
}

+ (void)initAdService{
	if ([Beintoo sharedInstance]->beintooAdService != nil) {
        
#ifdef BEINTOO_ARC_AVAILABLE
        [Beintoo sharedInstance]->beintooAdService = nil;
#else
        [[Beintoo sharedInstance]->beintooAdService release];
#endif
        
	}
	[Beintoo sharedInstance]->beintooAdService = [[BeintooAd alloc] init];
	BeintooLOG(@"Ad API service Initialized at URL: %@", [[Beintoo sharedInstance]->beintooAdService restResource]);
}

+ (void)initRewardService{
	if ([Beintoo sharedInstance]->beintooRewardService != nil) {
        
#ifdef BEINTOO_ARC_AVAILABLE
        [Beintoo sharedInstance]->beintooRewardService = nil;
#else
        [[Beintoo sharedInstance]->beintooRewardService release];
#endif
        
	}
	[Beintoo sharedInstance]->beintooRewardService = [[BeintooReward alloc] init];
	BeintooLOG(@"Reward API service Initialized at URL: %@", [[Beintoo sharedInstance]->beintooRewardService restResource]);
}

+ (void)initEventService{
	if ([Beintoo sharedInstance]->beintooEventService != nil) {
        
#ifdef BEINTOO_ARC_AVAILABLE
        [Beintoo sharedInstance]->beintooEventService = nil;
#else
        [[Beintoo sharedInstance]->beintooEventService release];
#endif
        
	}
	[Beintoo sharedInstance]->beintooEventService = [[BeintooEvent alloc] init];
	BeintooLOG(@"Event API service Initialized at URL: %@", [[Beintoo sharedInstance]->beintooEventService restResource]);
}

+ (void)initMissionService{
	if ([Beintoo sharedInstance]->beintooMissionService != nil) {
        
#ifdef BEINTOO_ARC_AVAILABLE
        [Beintoo sharedInstance]->beintooMissionService = nil;
#else
        [[Beintoo sharedInstance]->beintooMissionService release];
#endif
        
	}
	[Beintoo sharedInstance]->beintooMissionService = [[BeintooMission alloc] init];
	BeintooLOG(@"Mission API service Initialized at URL: %@", [[Beintoo sharedInstance]->beintooMissionService restResource]);
}

#pragma mark - Init Controllers

+ (void)initControllers
{
	[Beintoo initMainController];
    [Beintoo initMainAdController];
    [Beintoo initMainGbController];
}

+ (void)initMainController
{
	Beintoo *beintooInstance                        = [Beintoo sharedInstance];
	beintooInstance->mainController                 = [[BeintooMainController alloc] init];
	beintooInstance->mainController.view.alpha      = 0;
}

+ (void)initMainAdController
{
	Beintoo *beintooInstance                        = [Beintoo sharedInstance];
	beintooInstance->mainAdController               = [[BeintooMainController alloc] init];
	beintooInstance->mainAdController.view.alpha    = 0;
}

+ (void)initMainGbController
{
	Beintoo *beintooInstance                        = [Beintoo sharedInstance];
	beintooInstance->mainGbController               = [[BeintooMainController alloc] init];
	beintooInstance->mainGbController.view.alpha    = 0;
}

#pragma mark - Private methods

+ (void)setAppOrientation:(int)_appOrientation{
    
    if ([Beintoo sharedInstance]->appOrientation != _appOrientation)
    {
        [Beintoo sharedInstance]->appOrientation = _appOrientation;
        BeintooLOG(@"Beintoo: new App orientation set: %d", [Beintoo sharedInstance]->appOrientation);
        
        [[NSNotificationCenter defaultCenter] postNotificationName:BeintooNotificationOrientationChanged object:self];
    }
}
     
+ (void)setApplicationWindow:(UIWindow *)_window
{
	if (_window != nil) {
		[Beintoo sharedInstance]->applicationWindow = _window;
	}
}

+ (UIWindow *)getApplicationWindow
{
	if ([Beintoo sharedInstance]->applicationWindow != nil) {
		return [Beintoo sharedInstance]->applicationWindow;
	}
	
	NSArray *developerApplicationWindows = [[UIApplication sharedApplication] windows];
	
	NSAssert([developerApplicationWindows count] > 0, @"Beintoo - To launch Beintoo your application needs at least one window!");
	UIWindow* appKeyWindow = [[UIApplication sharedApplication] keyWindow];
	if (!appKeyWindow){
		BeintooLOG(@"Beintoo - No keyWindow found on this app. Beintoo will use the first UIWindow on the stack of app windows."); 
		appKeyWindow = [developerApplicationWindows objectAtIndex:0];
	}
	return appKeyWindow;
}

+ (void)_setIsStatusBarHiddenOnApp:(BOOL)_value
{
    [Beintoo sharedInstance]->statusBarHiddenOnApp = _value;
}

#pragma mark - Production/Sandbox environments

+ (void)switchToSandbox
{
	BeintooLOG(@"Beintoo: Going to sandbox");
    [Beintoo sharedInstance]->restBaseUrl = apiBaseUrl;
    [Beintoo sharedInstance]->displayBaseUrl = displayBaseUrl;
	[Beintoo sharedInstance]->isOnSandbox = YES;
    [Beintoo sharedInstance]->isOnPrivateSandbox = NO;
	[Beintoo initPlayerService];
    [Beintoo initUserService];
	[Beintoo initAchievementsService];
    [Beintoo initBestoreService];
    [Beintoo initAppService];
    [Beintoo initAdService];
    [Beintoo initRewardService];
    [Beintoo initEventService];
    [Beintoo initMissionService];
}

+ (void)privateSandbox
{
	BeintooLOG(@"Beintoo: Going to private sandbox");
	[Beintoo sharedInstance]->restBaseUrl = sandboxBaseUrl;
    [Beintoo sharedInstance]->displayBaseUrl = sandboxDisplayBaseUrl;
	[Beintoo sharedInstance]->isOnPrivateSandbox = YES;
    [Beintoo sharedInstance]->isOnSandbox = NO;
	[Beintoo initPlayerService];
    [Beintoo initUserService];
	[Beintoo initAchievementsService];
    [Beintoo initBestoreService];
    [Beintoo initAppService];
    [Beintoo initAdService];
    [Beintoo initRewardService];
    [Beintoo initEventService];
    [Beintoo initMissionService];
}

+ (void)production
{
	BeintooLOG(@"Beintoo: Going to production");
    [self initAPI];
	[Beintoo initPlayerService];
    [Beintoo initUserService];
	[Beintoo initAchievementsService];
    [Beintoo initBestoreService];
    [Beintoo initAppService];
    [Beintoo initAdService];
    [Beintoo initRewardService];
    [Beintoo initEventService];
    [Beintoo initMissionService];
}

#pragma mark - StatusBar management

+ (void)manageStatusBarOnLaunch
{
    [Beintoo _setIsStatusBarHiddenOnApp:[[UIApplication sharedApplication] isStatusBarHidden]];
    
    if (![BeintooDevice isiPad]){
        if (![Beintoo isStatusBarHiddenOnApp]){
            if([[UIApplication sharedApplication] respondsToSelector:@selector(setStatusBarHidden: withAnimation:)]) {
                [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
            }else{
                [[UIApplication sharedApplication] setStatusBarHidden:YES];
            }
            BeintooLOG(@"Beintoo Status Bar Management: status bar temporarily hidden");
        }
    }
}

+ (void)manageStatusBarOnDismiss
{
    if (![BeintooDevice isiPad]){
        if (![Beintoo isStatusBarHiddenOnApp]){
            if([[UIApplication sharedApplication] respondsToSelector:@selector(setStatusBarHidden: withAnimation:)]) {
                [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
            }else{
                [[UIApplication sharedApplication] setStatusBarHidden:NO];
            }
            BeintooLOG(@"Beintoo Status Bar Management: status bar is visible again");
        }
    }
}

#pragma mark - Launch and Dismiss methods

+ (void)_openDashboard
{
    [Beintoo openView:BCUrlSectionDashboard orURL:nil];
}

+ (void)_openBestore
{
    [Beintoo _openView:BCUrlSectionBestore orURL:nil];
}

+ (void)_openSignup
{
    [Beintoo _openView:BCUrlSectionSignup orURL:nil];
}

+ (void)_openMissions
{
    [Beintoo _openView:BCUrlSectionMissions orURL:nil];
}

+ (void)_openView:(NSString *)view orURL:(NSString *)URL
{
    if ([BeintooNetwork connectedToNetwork] == NO)
    {
        [BeintooNetwork showNoConnectionAlert];
        return;
    }
    
    // Let's hode the status bar, if needed
    [Beintoo manageStatusBarOnLaunch];
    
	BeintooWebview *beintooWebView      = [BeintooWebview alloc];
    
    // Check if it is the case of opening a Beintoo buildin url or a custom URL
    if (view != nil)
        beintooWebView.openSection          = view;
    else if (URL != nil)
        beintooWebView.url  = URL;
    
    beintooWebView                      = [beintooWebView init];
    
    BeintooMainController *controller = [BeintooMainController alloc];
    controller   = [controller initWithRootViewController:beintooWebView];
    [controller setNavigationBarHidden:YES];
    
#ifdef BEINTOO_ARC_AVAILABLE
    
#else
    [beintooWebView release];
#endif
    
    UIViewController *rootController = [Beintoo getApplicationWindow].rootViewController;
    if ([UIApplication sharedApplication].keyWindow.rootViewController.presentedViewController != nil)
    {
        rootController = [UIApplication sharedApplication].keyWindow.rootViewController.presentedViewController;
        controller.type = NAV_TYPE_CHILD;
    }
    else {
        controller.type = NAV_TYPE_MAIN;
    }
    
    // Let's call the Will Appear delegate
    if (controller.type == NAV_TYPE_MAIN)
        [Beintoo  beintooWillAppear];
    
    for (UIView *subview in [Beintoo getApplicationWindow].subviews)
    {
        if ( [subview isKindOfClass:[BTemplate class]] || [subview isKindOfClass:[BTemplateGiveBedollars class]] || [subview isKindOfClass:[BMissionTemplate class]] )
        {
            [subview removeFromSuperview];
        }
    }
    
    /*
    **  Let's present the controller
    **  check for iOS 6.0 or greater selector presentViewController:animated:completion:
    */
    
    if ([rootController respondsToSelector:@selector(presentViewController:animated:completion:)])
    {
        [rootController presentViewController:controller animated:YES
                                                                      completion:^(void){
                                                                          
                                                                          if (controller.type == NAV_TYPE_MAIN)
                                                                              [Beintoo  beintooDidAppear];
                                                                      }];
    }
    else {
        [rootController presentModalViewController:controller animated:YES];
        
        if (controller.type == NAV_TYPE_MAIN)
            [Beintoo  beintooDidAppear];
    }
}

+ (void)_dismissView:(id)controller
{
    // Let's show the status bar, if needed
    [Beintoo manageStatusBarOnDismiss];
    
    BeintooMainController *rootController = (BeintooMainController *)controller;
    
    if (rootController.type == NAV_TYPE_MAIN)
        [Beintoo  beintooWillDisappear];
    
    /*
    **  Let's dismiss the controller
    **  check for iOS 6.0 or greater selector dismissViewControllerAnimated:completion:
    */
    
	if ([rootController respondsToSelector:@selector(dismissViewControllerAnimated:completion:)]){
        [rootController dismissViewControllerAnimated:YES
                                            completion:^(void){
                                                if (rootController.type == NAV_TYPE_MAIN)
                                                    [Beintoo beintooDidDisappear];
                                            }
         ];
    }
    else
    {
        [rootController dismissModalViewControllerAnimated:YES];
        
        if (rootController.type == NAV_TYPE_MAIN)
            [Beintoo beintooDidDisappear];
    }
    
#ifdef BEINTOO_ARC_AVAILABLE
    
#else
    [controller release];
#endif
    
}

#pragma mark - Reward methods

+ (void)_showReward:(BRewardWrapper *)reward
{
    id<BeintooMainDelegate> _mainDelegate = [Beintoo sharedInstance]->mainDelegate;
    
    BTemplate *_prizeView = [[BTemplate alloc] initWithReward:reward];
    
    if ([_mainDelegate respondsToSelector:@selector(beintooRewardWillAppear)]) {
        [_mainDelegate beintooRewardWillAppear];
    }
    
    [_prizeView setPrizeContentWithWindowSize:[Beintoo getApplicationWindow].bounds.size];
    [[Beintoo getApplicationWindow] addSubview:_prizeView];
   
    if ([_mainDelegate respondsToSelector:@selector(beintooRewardDidAppear)]) {
        [_mainDelegate beintooRewardDidAppear];
    }
    
    [_prizeView setIsVisible:YES];
}

+ (void)_showReward:(BRewardWrapper *)reward withDelegate:(id)_delegate
{
    id<BeintooMainDelegate> _mainDelegate = [Beintoo sharedInstance]->mainDelegate;
    
    BTemplate	*_prizeView = [[BTemplate alloc] initWithReward:reward];
    _prizeView.delegate = _delegate;
    
    if (_prizeView.isVisible == NO){
        
        if ([_mainDelegate respondsToSelector:@selector(beintooRewardWillAppear)]) {
            [_mainDelegate beintooRewardWillAppear];
        }
        
        if ([_delegate respondsToSelector:@selector(beintooRewardWillAppear)]) {
            [_delegate beintooRewardWillAppear];
        }
        
        [_prizeView setPrizeContentWithWindowSize:[Beintoo getApplicationWindow].bounds.size];
        [[Beintoo getApplicationWindow] addSubview:_prizeView];
        
        if ([_mainDelegate respondsToSelector:@selector(beintooRewardDidAppear)]) {
            [_mainDelegate beintooRewardDidAppear];
        }

        if ([_delegate respondsToSelector:@selector(beintooRewardDidAppear)]) {
            [_delegate beintooRewardDidAppear];
        }
        
        [_prizeView setIsVisible:YES];
    }
}

+ (void)_hideReward:(BTemplate *)reward
{
    id<BeintooMainDelegate> _mainDelegate = [Beintoo sharedInstance]->mainDelegate;
    
    BTemplate *_prizeView = reward;
    id _delegate = _prizeView.delegate;
    
   if ([_mainDelegate respondsToSelector:@selector(beintooRewardWillDisappear)]) {
        [_mainDelegate beintooRewardWillDisappear];
    }
    
    if ([_delegate respondsToSelector:@selector(beintooRewardWillDisappear)]) {
        [_delegate beintooRewardWillDisappear];
    }
    
    if ([_mainDelegate respondsToSelector:@selector(beintooRewardDidDisappear)]) {
        [_mainDelegate beintooRewardDidDisappear];
    }
    
    if ([_delegate respondsToSelector:@selector(beintooRewardDidDisappear)]) {
        [_delegate beintooRewardDidDisappear];
    }
}

+ (void)_reward:(BTemplate *)reward launchRewardControllerWithURL:(NSString *)URL
{
	[Beintoo manageStatusBarOnLaunch];
    
    BeintooMainController *mainNavigatorController          = [BeintooMainController alloc];
    
    BTemplateVC *templateVC = [BTemplateVC alloc];
    templateVC.URL = URL;
    templateVC.type = REWARD;
    templateVC = [templateVC init];
    
    mainNavigatorController = [mainNavigatorController initWithRootViewController:templateVC];
    mainNavigatorController.templateVC = templateVC;
    mainNavigatorController.template = reward;
    
    [Beintoo sharedInstance]->mainController = mainNavigatorController;
    
    id<BeintooMainDelegate>	  _mainDelegate         = [Beintoo sharedInstance]->mainDelegate;
    
    if ([[reward globalDelegate] respondsToSelector:@selector(beintooRewardControllerWillAppear)]) {
		[[reward globalDelegate] beintooRewardControllerWillAppear];
	}
	
    if ([_mainDelegate respondsToSelector:@selector(beintooRewardControllerWillAppear)]) {
		[_mainDelegate beintooRewardControllerWillAppear];
	}
    
    UIViewController *controller = [Beintoo getApplicationWindow].rootViewController;
    if ([UIApplication sharedApplication].keyWindow.rootViewController.presentedViewController != nil)
    {
        controller = [UIApplication sharedApplication].keyWindow.rootViewController.presentedViewController;
    }
    
    for (UIView *subview in [Beintoo getApplicationWindow].subviews)
    {
        if ( [subview isKindOfClass:[BTemplate class]] || [subview isKindOfClass:[BTemplateGiveBedollars class]] || [subview isKindOfClass:[BMissionTemplate class]] )
        {
            [subview removeFromSuperview];
        }
    }
    
    if ([controller respondsToSelector:@selector(presentViewController:animated:completion:)])
    {
        [controller presentViewController:mainNavigatorController animated:YES
                                                                      completion:^(void){
                                                                          
                                                                          if ([[reward globalDelegate] respondsToSelector:@selector(beintooRewardControllerDidAppear)]) {
                                                                              [[reward globalDelegate] beintooRewardControllerDidAppear];
                                                                          }
                                                                          
                                                                          if ([_mainDelegate respondsToSelector:@selector(beintooRewardControllerDidAppear)]) {
                                                                              [_mainDelegate beintooRewardControllerDidAppear];
                                                                          }
                                                                      }];
    }
    else
    {
        [controller presentModalViewController:mainNavigatorController animated:YES];
        
        if ([[reward globalDelegate] respondsToSelector:@selector(beintooRewardControllerDidAppear)]) {
            [[reward globalDelegate] beintooRewardControllerDidAppear];
        }
        
        if ([_mainDelegate respondsToSelector:@selector(beintooRewardControllerDidAppear)]) {
            [_mainDelegate beintooRewardControllerDidAppear];
        }
    }
}

+ (void)_dismissRewardController
{
    // Let's show the status bar, if needed
    [Beintoo manageStatusBarOnDismiss];
    
    BeintooMainController *_mainController = [Beintoo sharedInstance]->mainController;
    BTemplate *template = _mainController.template;
    
    id<BeintooMainDelegate> _mainDelegate         = [Beintoo sharedInstance]->mainDelegate;
    
    if ([[template globalDelegate] respondsToSelector:@selector(beintooRewardControllerWillDisappear)]) {
		[[template globalDelegate] beintooRewardControllerWillDisappear];
	}
	
    if ([_mainDelegate respondsToSelector:@selector(beintooRewardControllerWillDisappear)]) {
		[_mainDelegate beintooRewardControllerWillDisappear];
	}
    
    /*
     **  Let's dismiss the controller
     **  check for iOS 6.0 or greater selector dismissViewControllerAnimated:completion:
     */
    
	if ([_mainController respondsToSelector:@selector(dismissViewControllerAnimated:completion:)]){
        [_mainController dismissViewControllerAnimated:YES
                                            completion:^(void){
                                                if ([[template globalDelegate] respondsToSelector:@selector(beintooRewardControllerDidDisappear)]) {
                                                    [[template globalDelegate] beintooRewardControllerDidDisappear];
                                                }
                                                
                                                if ([_mainDelegate respondsToSelector:@selector(beintooRewardControllerDidDisappear)]) {
                                                    [_mainDelegate beintooRewardControllerDidDisappear];
                                                }
                                            }
         ];
    }
    else
    {
        [_mainController dismissModalViewControllerAnimated:YES];
        
        if ([[template globalDelegate] respondsToSelector:@selector(beintooRewardControllerDidDisappear)]) {
            [[template globalDelegate] beintooRewardControllerDidDisappear];
        }
        
        if ([_mainDelegate respondsToSelector:@selector(beintooRewardControllerDidDisappear)]) {
            [_mainDelegate beintooRewardControllerDidDisappear];
        }
    }
    
#ifdef BEINTOO_ARC_AVAILABLE
    
#else
    [_mainController release];
#endif
    
}

#pragma mark - Ad methods

+ (void)_showAd:(BAdWrapper *)wrapper
{
    id<BeintooMainDelegate> _mainDelegate = [Beintoo sharedInstance]->mainDelegate;
    
    BTemplate *_prizeView = [[BTemplate alloc] initWithAd:wrapper];
    
    if ([_mainDelegate respondsToSelector:@selector(beintooAdWillAppear)]) {
        [_mainDelegate beintooAdWillAppear];
    }
    
    [_prizeView setPrizeContentWithWindowSize:[Beintoo getApplicationWindow].bounds.size];
    [[Beintoo getApplicationWindow] addSubview:_prizeView];
    
    if ([_mainDelegate respondsToSelector:@selector(beintooAdDidAppear)]) {
        [_mainDelegate beintooAdDidAppear];
    }
    
    [_prizeView setIsVisible:YES];
}

+ (void)_showAd:(BAdWrapper *)wrapper withDelegate:(id)_delegate
{
    id<BeintooMainDelegate> _mainDelegate = [Beintoo sharedInstance]->mainDelegate;
    
    BTemplate *_prizeView = [[BTemplate alloc] initWithAd:wrapper];
    _prizeView.delegate = _delegate;
    
    if (_prizeView.isVisible == NO){
        
        if ([_mainDelegate respondsToSelector:@selector(beintooAdWillAppear)]) {
            [_mainDelegate beintooAdWillAppear];
        }
        
        if ([_delegate respondsToSelector:@selector(beintooAdWillAppear)]) {
            [_delegate beintooAdWillAppear];
        }
        
        [_prizeView setPrizeContentWithWindowSize:[Beintoo getApplicationWindow].bounds.size];
        [[Beintoo getApplicationWindow] addSubview:_prizeView];
        
        if ([_mainDelegate respondsToSelector:@selector(beintooAdDidAppear)]) {
            [_mainDelegate beintooAdDidAppear];
        }
        
        if ([_delegate respondsToSelector:@selector(beintooAdDidAppear)]) {
            [_delegate beintooAdDidAppear];
        }
        
        [_prizeView setIsVisible:YES];
    }
}

+ (void)_hideAd:(BTemplate *)template
{
    id<BeintooMainDelegate> _mainDelegate = [Beintoo sharedInstance]->mainDelegate;
    
    BTemplate	*_prizeView = template;
    id _delegate = _prizeView.delegate;
    
    if ([_mainDelegate respondsToSelector:@selector(beintooAdWillDisappear)]) {
        [_mainDelegate beintooAdWillDisappear];
    }
    
    if ([_delegate respondsToSelector:@selector(beintooAdWillDisappear)]) {
        [_delegate beintooAdWillDisappear];
    }
    
    if ([_mainDelegate respondsToSelector:@selector(beintooAdDidDisappear)]) {
        [_mainDelegate beintooAdDidDisappear];
    }
    
    if ([_delegate respondsToSelector:@selector(beintooAdDidDisappear)]) {
        [_delegate beintooAdDidDisappear];
    }
    
    [Beintoo sharedInstance]->lastGeneratedAd = nil;
}

+ (void)_ad:(BTemplate *)template launchAdControllerWithURL:(NSString *)URL
{
	[Beintoo manageStatusBarOnLaunch];
    
    BeintooMainController *mainNavigatorController          = [BeintooMainController alloc];
    
    BTemplateVC *templateVC = [BTemplateVC alloc];
    templateVC.URL = URL;
    templateVC.type = AD;
    templateVC = [templateVC init];
    
    mainNavigatorController = [mainNavigatorController initWithRootViewController:templateVC];
    mainNavigatorController.templateVC = templateVC;
    mainNavigatorController.template = template;
    
    [Beintoo sharedInstance]->mainAdController = mainNavigatorController;
    
    id<BeintooMainDelegate>	  _mainDelegate         = [Beintoo sharedInstance]->mainDelegate;
    
    if ([[template globalDelegate] respondsToSelector:@selector(beintooAdControllerWillAppear)]) {
		[[template globalDelegate] beintooAdControllerWillAppear];
	}
	
    if ([_mainDelegate respondsToSelector:@selector(beintooAdControllerWillAppear)]) {
		[_mainDelegate beintooAdControllerWillAppear];
	}
    
    UIViewController *controller = [Beintoo getApplicationWindow].rootViewController;
    if ([UIApplication sharedApplication].keyWindow.rootViewController.presentedViewController != nil)
    {
        controller = [UIApplication sharedApplication].keyWindow.rootViewController.presentedViewController;
    }
    
    for (UIView *subview in [Beintoo getApplicationWindow].subviews)
    {
        if ( [subview isKindOfClass:[BTemplate class]] || [subview isKindOfClass:[BTemplateGiveBedollars class]] || [subview isKindOfClass:[BMissionTemplate class]] )
        {
            [subview removeFromSuperview];
        }
    }
    
    if ([controller respondsToSelector:@selector(presentViewController:animated:completion:)])
    {
        [controller presentViewController:mainNavigatorController animated:YES
                                                                      completion:^(void){
                                                                          
                                                                          if ([[template globalDelegate] respondsToSelector:@selector(beintooAdControllerDidAppear)]) {
                                                                              [[template globalDelegate] beintooAdControllerDidAppear];
                                                                          }
                                                                          
                                                                          if ([_mainDelegate respondsToSelector:@selector(beintooAdControllerDidAppear)]) {
                                                                              [_mainDelegate beintooAdControllerDidAppear];
                                                                          }
                                                                      }];
    }
    else {
        [controller presentModalViewController:mainNavigatorController animated:YES];
        
        if ([[template globalDelegate] respondsToSelector:@selector(beintooAdControllerDidAppear)]) {
            [[template globalDelegate] beintooAdControllerDidAppear];
        }
        
        if ([_mainDelegate respondsToSelector:@selector(beintooAdControllerDidAppear)]) {
            [_mainDelegate beintooAdControllerDidAppear];
        }
    }
    
    [Beintoo sharedInstance]->lastGeneratedAd = nil;
}

+ (void)_dismissAdController
{
    // Let's show the status bar, if needed
    [Beintoo manageStatusBarOnDismiss];
    
    BeintooMainController *_mainController = [Beintoo sharedInstance]->mainAdController;
    BTemplate *template = _mainController.template;
    
    id<BeintooMainDelegate> _mainDelegate         = [Beintoo sharedInstance]->mainDelegate;
    
    if ([[template globalDelegate] respondsToSelector:@selector(beintooAdControllerWillDisappear)]) {
		[[template globalDelegate] beintooAdControllerWillDisappear];
	}
	
    if ([_mainDelegate respondsToSelector:@selector(beintooAdControllerWillDisappear)]) {
		[_mainDelegate beintooAdControllerWillDisappear];
	}
    
    /*
     **  Let's dismiss the controller
     **  check for iOS 6.0 or greater selector dismissViewControllerAnimated:completion:
     */
    
	if ([_mainController respondsToSelector:@selector(dismissViewControllerAnimated:completion:)]){
        [_mainController dismissViewControllerAnimated:YES
                                            completion:^(void){
                                                if ([[template globalDelegate] respondsToSelector:@selector(beintooAdControllerDidDisappear)]) {
                                                    [[template globalDelegate] beintooAdControllerDidDisappear];
                                                }
                                                
                                                if ([_mainDelegate respondsToSelector:@selector(beintooAdControllerDidDisappear)]) {
                                                    [_mainDelegate beintooAdControllerDidDisappear];
                                                }
                                            }
         ];
    }
    else
    {
        [_mainController dismissModalViewControllerAnimated:YES];
        
        if ([[template globalDelegate] respondsToSelector:@selector(beintooAdControllerDidDisappear)]) {
            [[template globalDelegate] beintooAdControllerDidDisappear];
        }
        
        if ([_mainDelegate respondsToSelector:@selector(beintooAdControllerDidDisappear)]) {
            [_mainDelegate beintooAdControllerDidDisappear];
        }
    }
    
#ifdef BEINTOO_ARC_AVAILABLE
    
#else
    [_mainController release];
    [template release];
#endif
    
}

#pragma mark - Give Bedollars methods

+ (void)_showGiveBedollars:(BGiveBedollarsWrapper *)wrapper withDelegate:(id)delegate position:(int)position
{
    id<BeintooMainDelegate> _mainDelegate = [Beintoo sharedInstance]->mainDelegate;
	
    BTemplateGiveBedollars *template = [[BTemplateGiveBedollars alloc] initWithContent:wrapper];
    
    if (template.isVisible == NO){
        template.notificationPosition = position;
        template.globalDelegate = delegate;
        
        if ([delegate respondsToSelector:@selector(beintooGiveBedollarsWillAppear)]) {
            [delegate beintooGiveBedollarsWillAppear];
        }
        
        if ([_mainDelegate respondsToSelector:@selector(beintooGiveBedollarsWillAppear)]) {
            [_mainDelegate beintooGiveBedollarsWillAppear];
        }
        
        [template setPrizeContentWithWindowSize:[Beintoo getApplicationWindow].bounds.size];
        [[Beintoo getApplicationWindow] addSubview:template];
        
        if ([delegate respondsToSelector:@selector(beintooGiveBedollarsDidAppear)]) {
            [delegate beintooGiveBedollarsDidAppear];
        }
        
        if ([_mainDelegate respondsToSelector:@selector(beintooGiveBedollarsDidAppear)]) {
            [_mainDelegate beintooGiveBedollarsDidAppear];
        }
        [template setIsVisible:YES];
    }
}

+ (void)_hideGiveBedollars:(BTemplateGiveBedollars *)template
{    
    id<BeintooMainDelegate> _mainDelegate = [Beintoo sharedInstance]->mainDelegate;
    
    BTemplateGiveBedollars *_prizeView = template;
    id _delegate = _prizeView.delegate;
    
    if ([_delegate respondsToSelector:@selector(beintooGiveBedollarsWillDisappear)]) {
		[_delegate beintooGiveBedollarsWillDisappear];
	}
    
    if ([_mainDelegate respondsToSelector:@selector(beintooGiveBedollarsWillDisappear)]) {
		[_mainDelegate beintooGiveBedollarsWillDisappear];
	}
    
	if ([_delegate respondsToSelector:@selector(beintooGiveBedollarsDidDisappear)]) {
		[_delegate beintooGiveBedollarsDidDisappear];
	}
    
	if ([_mainDelegate respondsToSelector:@selector(beintooGiveBedollarsDidDisappear)]) {
		[_mainDelegate beintooGiveBedollarsDidDisappear];
	}
}

+ (void)_giveBedollars:(BTemplateGiveBedollars *)template launchControllerWithURL:(NSString *)URL
{
    [Beintoo manageStatusBarOnLaunch];
    
    BeintooMainController *mainNavigatorController          = [BeintooMainController alloc];
    
    BTemplateVC *templateVC = [BTemplateVC alloc];
    templateVC.URL = URL;
    templateVC.type = GIVE_BEDOLLARS;
    templateVC = [templateVC init];
    
    mainNavigatorController = [mainNavigatorController initWithRootViewController:templateVC];
    mainNavigatorController.templateVC = templateVC;
    mainNavigatorController.templateGB = template;
    
    [Beintoo sharedInstance]->mainGbController = mainNavigatorController;
    
    id<BeintooMainDelegate>	  _mainDelegate         = [Beintoo sharedInstance]->mainDelegate;
    id delegate = [template delegate];
    
    if ([delegate respondsToSelector:@selector(beintooGiveBedollarsControllerWillAppear)]) {
		[delegate beintooGiveBedollarsControllerWillAppear];
	}
	
    if ([_mainDelegate respondsToSelector:@selector(beintooGiveBedollarsControllerWillAppear)]) {
		[_mainDelegate beintooGiveBedollarsControllerWillAppear];
	}
    
    UIViewController *controller = [Beintoo getApplicationWindow].rootViewController;
    if ([UIApplication sharedApplication].keyWindow.rootViewController.presentedViewController != nil)
    {
        controller = [UIApplication sharedApplication].keyWindow.rootViewController.presentedViewController;
    }
    
    for (UIView *subview in [Beintoo getApplicationWindow].subviews)
    {
        if ( [subview isKindOfClass:[BTemplate class]] || [subview isKindOfClass:[BTemplateGiveBedollars class]] || [subview isKindOfClass:[BMissionTemplate class]] )
        {
            [subview removeFromSuperview];
        }
    }
    
    if ([controller respondsToSelector:@selector(presentViewController:animated:completion:)])
    {
        [controller presentViewController:mainNavigatorController animated:YES
                                                                      completion:^(void){
                                                                          
                                                                          if ([delegate respondsToSelector:@selector(beintooGiveBedollarsControllerDidAppear)]) {
                                                                              [delegate beintooGiveBedollarsControllerDidAppear];
                                                                          }
                                                                          
                                                                          if ([_mainDelegate respondsToSelector:@selector(beintooGiveBedollarsControllerDidAppear)]) {
                                                                              [_mainDelegate beintooGiveBedollarsControllerDidAppear];
                                                                          }
                                                                      }];
    }
    else {
        [controller presentModalViewController:mainNavigatorController animated:YES];
        
        if ([delegate respondsToSelector:@selector(beintooGiveBedollarsControllerDidAppear)]) {
            [delegate beintooGiveBedollarsControllerDidAppear];
        }
        
        if ([_mainDelegate respondsToSelector:@selector(beintooGiveBedollarsControllerDidAppear)]) {
            [_mainDelegate beintooGiveBedollarsControllerDidAppear];
        }
    }
}

+ (void)_giveBedollarsDismissController
{
    // Let's show the status bar, if needed
    [Beintoo manageStatusBarOnDismiss];
    
    BeintooMainController *_mainController = [Beintoo sharedInstance]->mainGbController;
    BTemplateGiveBedollars *template = _mainController.templateGB;
    
    id<BeintooMainDelegate> _mainDelegate         = [Beintoo sharedInstance]->mainDelegate;
    
    if ([[template globalDelegate] respondsToSelector:@selector(beintooGiveBedollarsControllerWillDisappear)]) {
		[[template globalDelegate] beintooGiveBedollarsControllerWillDisappear];
	}
	
    if ([_mainDelegate respondsToSelector:@selector(beintooGiveBedollarsControllerWillDisappear)]) {
		[_mainDelegate beintooGiveBedollarsControllerWillDisappear];
	}
    
    /*
     **  Let's dismiss the controller
     **  check for iOS 6.0 or greater selector dismissViewControllerAnimated:completion:
     */
    
	if ([_mainController respondsToSelector:@selector(dismissViewControllerAnimated:completion:)]){
        [_mainController dismissViewControllerAnimated:YES
                                            completion:^(void){
                                                if ([[template globalDelegate] respondsToSelector:@selector(beintooGiveBedollarsControllerDidDisappear)]) {
                                                    [[template globalDelegate] beintooGiveBedollarsControllerDidDisappear];
                                                }
                                                
                                                if ([_mainDelegate respondsToSelector:@selector(beintooGiveBedollarsControllerDidDisappear)]) {
                                                    [_mainDelegate beintooGiveBedollarsControllerDidDisappear];
                                                }
                                            }
         ];
    }
    else
    {
        [_mainController dismissModalViewControllerAnimated:YES];
        
        if ([[template globalDelegate] respondsToSelector:@selector(beintooGiveBedollarsControllerDidDisappear)]) {
            [[template globalDelegate] beintooGiveBedollarsControllerDidDisappear];
        }
        
        if ([_mainDelegate respondsToSelector:@selector(beintooGiveBedollarsControllerDidDisappear)]) {
            [_mainDelegate beintooGiveBedollarsControllerDidDisappear];
        }
    }
    
#ifdef BEINTOO_ARC_AVAILABLE
    
#else
    [_mainController release];
    [template release];
#endif
    
}

+ (void)_launchMission:(BMissionTemplate *)_mission delegate:(id<BMissionTemplateDelegate>)_delegate
{
    //id<BeintooMainDelegate> _mainDelegate = [Beintoo sharedInstance]->mainDelegate;
	
    BMissionTemplate *mission               = _mission;
    id <BMissionTemplateDelegate> delegate  = _delegate;
    
    if (mission.isVisible == NO){
        mission.globalDelegate = delegate;
        
        /* if ([delegate respondsToSelector:@selector(beintooPrizeAlertWillAppear)]) {
            [delegate beintooPrizeAlertWillAppear];
        }
        
        if ([_mainDelegate respondsToSelector:@selector(beintooPrizeAlertWillAppear)]) {
            [_mainDelegate beintooPrizeAlertWillAppear];
        } */
        
        [mission setPrizeContentWithWindowSize:[Beintoo getApplicationWindow].bounds.size];
        [[Beintoo getApplicationWindow] addSubview:mission];
        [mission show];
        
       /* if ([_beintooPrizeDelegate respondsToSelector:@selector(beintooPrizeAlertDidAppear)]) {
            [_beintooPrizeDelegate beintooPrizeAlertDidAppear];
        }
        
        if ([_mainDelegate respondsToSelector:@selector(beintooPrizeAlertDidAppear)]) {
            [_mainDelegate beintooPrizeAlertDidAppear];
        }*/
        
        [mission setIsVisible:YES];
    }
}

+ (void)_dismissMission
{
	id<BeintooMainDelegate> _mainDelegate = [Beintoo sharedInstance]->mainDelegate;
    
    [Beintoo manageStatusBarOnDismiss];
    
	if ([_mainDelegate respondsToSelector:@selector(beintooWillDisappear)]) {
		[_mainDelegate beintooWillDisappear];
	}
	
	//BeintooMainController *_mainController = [Beintoo sharedInstance]->mainController;
   // [_mainController hideMissionVgoodNavigationController];
}

#pragma mark - Native Browser with Custom URL

+ (void)_launchControllerWithURL:(NSString *)URL
{
	[Beintoo manageStatusBarOnLaunch];
    
    BTemplateVC *templateVC = [BTemplateVC alloc];
    templateVC.URL = URL;
    templateVC.type = CUSTOM_TYPE;
    templateVC = [templateVC init];
    
    BeintooMainController *mainNavigatorController          = [BeintooMainController alloc];
    mainNavigatorController = [mainNavigatorController initWithRootViewController:templateVC];
    mainNavigatorController.templateVC = templateVC;
    
    id<BeintooMainDelegate>	  _mainDelegate         = [Beintoo sharedInstance]->mainDelegate;
    
    UIViewController *controller = [Beintoo getApplicationWindow].rootViewController;
    if ([UIApplication sharedApplication].keyWindow.rootViewController.presentedViewController != nil)
    {
        controller = [UIApplication sharedApplication].keyWindow.rootViewController.presentedViewController;
    }
    else {
        [Beintoo beintooWillAppear];
    }
    
    for (UIView *subview in [Beintoo getApplicationWindow].subviews)
    {
        if ( [subview isKindOfClass:[BTemplate class]] || [subview isKindOfClass:[BTemplateGiveBedollars class]] || [subview isKindOfClass:[BMissionTemplate class]] )
        {
            [subview removeFromSuperview];
        }
    }
    
    if ([[Beintoo getApplicationWindow] respondsToSelector:@selector(presentViewController:animated:completion:)])
    {
        [controller presentViewController:mainNavigatorController animated:YES
                                                                      completion:^(void){
                                                                          if ([_mainDelegate respondsToSelector:@selector(beintooDidAppear)]) {
                                                                              [_mainDelegate beintooDidAppear];
                                                                          }
                                                                      }];
    }
    else
    {
        [controller presentModalViewController:mainNavigatorController animated:YES];
        
        if ([_mainDelegate respondsToSelector:@selector(beintooDidAppear)]) {
            [_mainDelegate beintooDidAppear];
        }
    }
}

+ (void)_dismissController:(id)controller
{
    // Let's show the status bar, if needed
    [Beintoo manageStatusBarOnDismiss];
    
    id<BeintooMainDelegate> _mainDelegate         = [Beintoo sharedInstance]->mainDelegate;
    
    if ([_mainDelegate respondsToSelector:@selector(beintooWillAppear)]) {
		[_mainDelegate beintooWillAppear];
	}
    
    /*
     **  Let's dismiss the controller
     **  check for iOS 6.0 or greater selector dismissViewControllerAnimated:completion:
     */
    
	if ([controller respondsToSelector:@selector(dismissViewControllerAnimated:completion:)]){
        [controller dismissViewControllerAnimated:YES
                                            completion:^(void){
                                                if ([_mainDelegate respondsToSelector:@selector(beintooDidDisappear)]) {
                                                    [_mainDelegate beintooDidDisappear];
                                                }
                                            }
         ];
    }
    else
    {
        [controller dismissModalViewControllerAnimated:YES];
        
        if ([_mainDelegate respondsToSelector:@selector(beintooDidDisappear)]) {
            [_mainDelegate beintooDidDisappear];
        }
    }
    
#ifdef BEINTOO_ARC_AVAILABLE
    
#else
    [controller release];
#endif
    
}

#pragma mark - Player/User

+ (void)_setBeintooPlayer:(BPlayerWrapper *)_player
{
    @try
    {
        NSData *dataVal = [NSKeyedArchiver archivedDataWithRootObject:_player];
        [[NSUserDefaults standardUserDefaults] setObject:dataVal forKey:BNSDefLoggedPlayer];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    @catch (NSException *exception) {
        BeintooLOG(@"Exception on storing player, %@", exception);
    }
}

+ (void)_playerLogout
{
	[[NSUserDefaults standardUserDefaults] setObject:nil forKey:BNSDefLoggedPlayer];
	[[NSUserDefaults standardUserDefaults] synchronize];
    
    NSHTTPCookie *cookie;
	NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
	
    // Here we delete all facebook cookies, to prevent the auto-login of another user
	for (cookie in [storage cookies]) {
        if ([[cookie domain] isEqualToString:@".facebook.com"] || [[cookie name] isEqualToString:@"fbs_152837841401121"]) {
            [storage deleteCookie:cookie];
        }
	}
    
    NSHTTPCookieStorage *cookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (NSHTTPCookie *each in cookieStorage.cookies) {
        [cookieStorage deleteCookie:each];
    }
}

+ (void)_setLastAd:(BAdWrapper *)wrapper
{
    if ([Beintoo sharedInstance]->lastGeneratedAd != nil) {
            
#ifdef BEINTOO_ARC_AVAILABLE
            
#else
        [[Beintoo sharedInstance]->lastGeneratedAd release];
#endif
            
    }
         
    [Beintoo sharedInstance]->lastGeneratedAd = wrapper;
}

+ (void)_beintooUserDidLogin
{
	id<BeintooMainDelegate> _mainDelegate = [Beintoo sharedInstance]->mainDelegate;
	if ([_mainDelegate respondsToSelector:@selector(beintooUserDidLogin)]) {
		[_mainDelegate beintooUserDidLogin];
	}
    
    if ([_mainDelegate respondsToSelector:@selector(userDidLogin)]) {
		[_mainDelegate userDidLogin];
	}
}

+ (void)_beintooUserDidSignup
{
	id<BeintooMainDelegate> _mainDelegate = [Beintoo sharedInstance]->mainDelegate;
	if ([_mainDelegate respondsToSelector:@selector(beintooUserDidSignup)]) {
		[_mainDelegate beintooUserDidSignup];
	}
    
    if ([_mainDelegate respondsToSelector:@selector(userDidSignup)]) {
		[_mainDelegate userDidSignup];
	}
}

#pragma mark - Location management

+ (void)_updateUserLocation
{
	BOOL isLocationServicesEnabled;
    
	CLLocationManager *_locationManager = [Beintoo sharedInstance]->locationManager;
	_locationManager.delegate = [Beintoo sharedInstance];
	
	if ([CLLocationManager respondsToSelector:@selector(locationServicesEnabled)]) {
		isLocationServicesEnabled = [CLLocationManager locationServicesEnabled];	       
	}
    
#if __IPHONE_OS_VERSION_MIN_REQUIRED < BEINTOO_IOS_4_0
    else {
        isLocationServicesEnabled = _locationManager.locationServicesEnabled;
	}
#endif
    
    if(!isLocationServicesEnabled){
        BeintooLOG(@"Beintoo - User has not accepted to use location services.");
        return;
    }
	[_locationManager startUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{    
    if([Beintoo sharedInstance]->userLocation != nil){
        
#ifdef BEINTOO_ARC_AVAILABLE
#else
        [[Beintoo sharedInstance]->userLocation release];
#endif
        
    }
    
#ifdef BEINTOO_ARC_AVAILABLE
    [Beintoo sharedInstance]->userLocation = newLocation;
#else
    [Beintoo sharedInstance]->userLocation = [newLocation retain];
#endif
    
	[manager stopUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
	BeintooLOG(@"Error in localizing player: %@", [error description]);
}

#pragma mark - Notifications

+ (void)_beintooWillAppear
{
	id<BeintooMainDelegate> _mainDelegate = [Beintoo sharedInstance]->mainDelegate;
	if ([_mainDelegate respondsToSelector:@selector(beintooWillAppear)]) {
		[_mainDelegate beintooWillAppear];
	}
}

+ (void)_beintooDidAppear
{
	id<BeintooMainDelegate> _mainDelegate = [Beintoo sharedInstance]->mainDelegate;
	if ([_mainDelegate respondsToSelector:@selector(beintooDidAppear)]) {
		[_mainDelegate beintooDidAppear];
	}
}

+ (void)_beintooWillDisappear
{
	id<BeintooMainDelegate> _mainDelegate = [Beintoo sharedInstance]->mainDelegate;
	if ([_mainDelegate respondsToSelector:@selector(beintooWillDisappear)]) {
		[_mainDelegate beintooWillDisappear];
	}
}

+ (void)_beintooDidDisappear
{
	id<BeintooMainDelegate> _mainDelegate = [Beintoo sharedInstance]->mainDelegate;
	if ([_mainDelegate respondsToSelector:@selector(beintooDidDisappear)]) {
		[_mainDelegate beintooDidDisappear];
	}
}

+ (void)_adControllerDidAppear
{
	id<BeintooMainDelegate> _mainDelegate = [Beintoo sharedInstance]->mainDelegate;
	if ([_mainDelegate respondsToSelector:@selector(beintooAdControllerDidAppear)]) {
		[_mainDelegate beintooAdControllerDidAppear];
	}
}

+ (void)_adControllerDidDisappear
{
	id<BeintooMainDelegate> _mainDelegate = [Beintoo sharedInstance]->mainDelegate;
	if ([_mainDelegate respondsToSelector:@selector(beintooAdControllerDidDisappear)]) {
		[_mainDelegate beintooAdControllerDidDisappear];
	}
}

+ (void)_giveBedollarsControllerDidAppear
{
	id<BeintooMainDelegate> _mainDelegate = [Beintoo sharedInstance]->mainDelegate;
	if ([_mainDelegate respondsToSelector:@selector(beintooGiveBedollarsControllerDidAppear)]) {
		[_mainDelegate beintooGiveBedollarsControllerDidAppear];
	}
}

+ (void)_giveBedollarsControllerDidDisappear
{
	id<BeintooMainDelegate> _mainDelegate = [Beintoo sharedInstance]->mainDelegate;
	if ([_mainDelegate respondsToSelector:@selector(beintooGiveBedollarsControllerDidDisappear)]) {
		[_mainDelegate beintooGiveBedollarsControllerDidDisappear];
	}
}

@end
