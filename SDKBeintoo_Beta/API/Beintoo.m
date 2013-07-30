/*******************************************************************************
 * Copyright 2012 Beintoo
 * Author Giuseppe Piazzese (gpiazzese@beintoo.com)
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

#import "Beintoo.h"
#import "Beintoo+Private.h"

@implementation Beintoo

#pragma mark - Init Beintoo

+ (void)initWithApiKey:(NSString *)_apikey andApiSecret:(NSString *)_apisecret 
										   andBeintooSettings:(NSDictionary *)_settings 
										   andMainDelegate:(id<BeintooMainDelegate>)beintooMainDelegate
{
	if ([Beintoo sharedInstance]) { 
		return; // -- Beintoo already initialized -- //
	}
    
    [Beintoo createSharedBeintoo];
	Beintoo *beintooInstance = [Beintoo sharedInstance];
	
	beintooInstance->mainDelegate = beintooMainDelegate;
	
	[Beintoo initAPI];
	[Beintoo setApiKey:_apikey andApisecret:_apisecret];
	[Beintoo initLocallySavedScoresArray];
	[Beintoo initLocallySavedAchievementsArray];
    [Beintoo initUserAgent];
    
	[Beintoo initPlayerService];
    [Beintoo initUserService];
	[Beintoo initAchievementsService];
    [Beintoo initBestoreService];
    [Beintoo initAppService];
    [Beintoo initAdService];
    [Beintoo initRewardService];
    [Beintoo initEventService];
    [Beintoo initMissionService];
	
	// Settings initialization
	[Beintoo initBeintooSettings:_settings];
}

#pragma mark - Player methods

+ (void)login
{
    [BeintooPlayer login];
}

+ (void)submitScore:(int)score
{
    [BeintooPlayer submitScore:score];
}

+ (void)submitScore:(int)score forContest:(NSString *)contestID
{
    [BeintooPlayer submitScore:score forContest:contestID];
}

+ (void)submitScore:(int)score forContest:(NSString *)contestID withThreshold:(int)threshold
{
    [BeintooPlayer submitScoreAndGetRewardForScore:score andContest:contestID withThreshold:threshold];
}

+ (void)submitScoreAndGetRewardForScore:(int)score andContest:(NSString *)codeID withThreshold:(int)threshold
{
    [BeintooPlayer submitScoreAndGetRewardForScore:score andContest:codeID withThreshold:threshold];
}

+ (int)getThresholdScoreForCurrentPlayerWithContest:(NSString *)codeID
{
    return [BeintooPlayer getThresholdScoreForCurrentPlayerWithContest:codeID];
}

+ (void)getScore
{
    [BeintooPlayer getScore];
}

#pragma mark - Give Bedollars methods

+ (void)giveBedollars:(float)amount showNotification:(BOOL)showNotification withPosition:(int)position
{
    [BeintooApp giveBedollars:amount showNotification:showNotification withPosition:position];
}

#pragma mark - Rewards methods

+ (void)getReward
{
    [BeintooReward getReward];
}

+ (void)getRewardWithDelegate:(id)_delegate
{
    [BeintooReward getRewardWithDelegate:_delegate];
}

+ (void)getRewardWithContest:(NSString *)contestID
{
    [BeintooReward getRewardWithContest:contestID];
}

#pragma mark - Request AD methods

+ (void)requestAndDisplayAdWithDeveloperUserGuid:(NSString *)_developerUserGuid
{
    [BeintooAd requestAndDisplayAdWithDeveloperUserGuid:nil];
}

+ (void)requestAdWithDeveloperUserGuid:(NSString *)_developerUserGuid
{
    [BeintooAd requestAdWithDeveloperUserGuid:nil];
}

#pragma mark - Give Bedollars methods

+ (void)showGiveBedollars:(BGiveBedollarsWrapper *)wrapper withDelegate:(id)delegate position:(int)position
{
    [Beintoo _showGiveBedollars:wrapper withDelegate:delegate position:position];
}

+ (void)hideGiveBedollars:(BTemplateGiveBedollars *)template
{
    [Beintoo _hideGiveBedollars:template];
}

+ (void)giveBedollars:(BTemplateGiveBedollars *)template launchControllerWithURL:(NSString *)URL
{
    [Beintoo _giveBedollars:template launchControllerWithURL:URL];
}

+ (void)dismissGiveBedollarsController
{
    [Beintoo _giveBedollarsDismissController];
}

#pragma mark - Custom Browser

+ (void)launchControllerWithURL:(NSString *)URL
{
    [Beintoo _launchControllerWithURL:URL];
}

+ (void)dismissController:(id)navController
{
    [Beintoo _dismissController:navController];
}

#pragma mark - Achievements methods

+ (void)unlockAchievement:(NSString *)achievementID
{
    [BeintooAchievements unlockAchievement:achievementID];
}

+ (void)unlockAchievement:(NSString *)achievementID showNotification:(BOOL)showNotification
{
    [Beintoo unlockAchievement:achievementID showNotification:showNotification];
}

+ (void)setAchievement:(NSString *)achievementID withPercentage:(int)percentage {
    [Beintoo setAchievement:achievementID withPercentage:percentage];
}

+ (void)setAchievement:(NSString *)achievementID withPercentage:(int)percentage showNotification:(BOOL)showNotification{
    [Beintoo setAchievement:achievementID withPercentage:percentage showNotification:showNotification];
}

+ (void)setAchievement:(NSString *)achievementID withScore:(int)score
{
    [BeintooAchievements setAchievement:achievementID withScore:score];
}

+ (void)incrementAchievement:(NSString *)achievementID withScore:(int)score
{
    [BeintooAchievements incrementAchievement:achievementID withScore:score];
}

+ (void)getAchievementStatusAndPercentage:(NSString *)achievementID
{
    [BeintooAchievements getAchievementStatusAndPercentage:achievementID];
}

// BY OBJECT ID

+ (void)unlockAchievementByObjectID:(NSString *)objectID showNotification:(BOOL)showNotification
{
    [BeintooAchievements unlockAchievementByObjectID:objectID showNotification:showNotification];
}

+ (void)setAchievementByObjectID:(NSString *)objectID withPercentage:(int)percentage showNotification:(BOOL)showNotification
{
    [BeintooAchievements setAchievementByObjectID:objectID withPercentage:percentage showNotification:showNotification];
}

+ (void)unlockAchievementsInBackground:(NSArray *)achievementArray
{
    [BeintooAchievements unlockAchievementsInBackground:achievementArray];
}

+ (void)unlockAchievementsByObjectIDInBackground:(NSArray *)achievementArray
{
    [BeintooAchievements unlockAchievementsByObjectIDInBackground:achievementArray];
}

#pragma mark - Set Delegates methods

+ (void)setPlayerDelegate:(id)delegate
{
    [BeintooPlayer setDelegate:delegate];
}

+ (void)setUserDelegate:(id)delegate
{
    [BeintooUser setDelegate:delegate];
}

+ (void)setAchievementsDelegate:(id)delegate
{
    [BeintooAchievements setDelegate:delegate];
}

+ (void)setRewardDelegate:(id)delegate
{
    [BeintooReward setDelegate:delegate];
}

+ (void)setAppDelegate:(id)delegate
{
    [BeintooApp setDelegate:delegate];
}

+ (void)setAdDelegate:(id)delegate
{
    [BeintooAd setDelegate:delegate];
}

#pragma mark - Launch and Dismiss methods

+ (void)launchBestore
{
    [Beintoo openBestore];
}

+ (void)launchBeintoo
{
    [Beintoo openDashboard];
}

+ (void)openDashboard
{
    [Beintoo _openDashboard];
}

+ (void)openBestore
{
    [Beintoo _openBestore];
}

+ (void)openSignup
{
    [Beintoo _openSignup];
}

+ (void)openMissions
{
    [Beintoo _openMissions];
}

+ (void)openView:(NSString *)view orURL:(NSString *)URL
{
    [Beintoo _openView:view orURL:URL];
}

+ (void)dismissView:(id)controller
{
    [Beintoo _dismissView:controller];
}

+ (void)displayAd{
    if ([Beintoo isAdReady]){
        [Beintoo _showAd:[Beintoo sharedInstance]->lastGeneratedAd withDelegate:nil];
    }
    else
        BeintooLOG(@"No Ad ready to go, try to request for a new one!");
}

+ (void)displayAdWithDelegate:(id<BeintooTemplateDelegate>)delegate
{
    //[Beintoo _launchAdWithDelegate:delegate];
}

+ (void)showMission:(BMissionTemplate *)mission
{
    [Beintoo _launchMission:mission delegate:nil];
}

+ (void)showMission:(BMissionTemplate *)mission delegate:(id <BMissionTemplateDelegate>)delegate
{
    [Beintoo _launchMission:mission delegate:delegate];
}

#pragma mark - Reward methods

+ (void)showReward:(BRewardWrapper *)wrapper
{
    [self _showReward:wrapper];
}

+ (void)showReward:(BRewardWrapper *)wrapper withDelegate:(id)_delegate
{
    [self _showReward:wrapper withDelegate:_delegate];
}

+ (void)hideReward:(BTemplate *)template
{
    [self _hideReward:template];
}

+ (void)reward:(BTemplate *)template launchRewardControllerWithURL:(NSString *)URL;
{
    [Beintoo _reward:template launchRewardControllerWithURL:URL];
}

+ (void)dismissRewardController
{
    [Beintoo _dismissRewardController];
}

#pragma mark - Ad methods

+ (void)showAd:(BAdWrapper *)wrapper
{
    [self _showAd:wrapper];
}

+ (void)showAd:(BAdWrapper *)wrapper withDelegate:(id<BeintooTemplateDelegate>)_delegate
{
    [self _showAd:wrapper withDelegate:_delegate];
}

+ (void)hideAd:(BTemplate *)template
{
    [self _hideAd:template];
}

+ (void)ad:(BTemplate *)template launchRewardControllerWithURL:(NSString *)URL;
{
    [Beintoo _ad:template launchAdControllerWithURL:URL];
}

+ (void)dismissAdController
{
    [Beintoo _dismissAdController];
}

#pragma mark - Global Services

+ (BeintooPlayer *)beintooPlayerService{
	return [Beintoo sharedInstance]->beintooPlayerService;
}

+ (BeintooUser *)beintooUserService{
	return [Beintoo sharedInstance]->beintooUserService;
}

+ (BeintooAchievements *)beintooAchievementService{
	return [Beintoo sharedInstance]->beintooAchievementsService;
}

+ (BeintooBestore *)beintooBestoreService{
    return [Beintoo sharedInstance]->beintooBestoreService;
}

+ (BeintooApp *)beintooAppService{
    return [Beintoo sharedInstance]->beintooAppService;
}

+ (BeintooAd *)beintooAdService{
    return [Beintoo sharedInstance]->beintooAdService;
}

+ (BeintooReward *)beintooRewardService
{
    return [Beintoo sharedInstance]->beintooRewardService;
}

+ (BeintooEvent *)beintooEventService
{
    return [Beintoo sharedInstance]->beintooEventService;
}

+ (BeintooMission *)beintooMissionService
{
    return [Beintoo sharedInstance]->beintooMissionService;
}

#pragma mark - Global Controllers

+ (UIViewController *)getMainController{
	return [Beintoo sharedInstance]->mainController;
}

+ (BAnimatedNotificationQueue *)getNotificationQueue
{
    return [Beintoo sharedInstance]->notificationQueue;
}

#pragma mark - Private Methods

+ (dispatch_queue_t)beintooDispatchQueue
{
    return [Beintoo sharedInstance]->beintooDispatchQueue;
}

+ (id<BeintooMainDelegate>)getMainDelegate{
	return [Beintoo sharedInstance]->mainDelegate;
}

+ (NSString *)getApiKey
{
	return [Beintoo sharedInstance]->apiKey;
}
								
+ (NSString *)currentVersion{
	return BeintooSdkVersion;
}

+ (NSString *)platform{
	return BeintooPlatform;
}

+ (NSInteger)notificationPosition
{
    return [Beintoo sharedInstance]->notificationPosition;
}

+ (BOOL)isStatusBarHiddenOnApp
{
    return [Beintoo sharedInstance]->statusBarHiddenOnApp;
}

+ (BOOL)isOnSandbox{
	if ([Beintoo sharedInstance]) {
		return [Beintoo sharedInstance]->isOnSandbox;
	}
	return NO;
}

+ (BOOL)isOnPrivateSandbox{
	if ([Beintoo sharedInstance]) {
		return [Beintoo sharedInstance]->isOnPrivateSandbox;
	}
	return NO;
}

+ (void)_privateSandbox
{
	[Beintoo privateSandbox];
}

+ (void)_setUserLocation:(CLLocation *)_location{
	[Beintoo sharedInstance]->userLocation = _location;
}

+ (BOOL)userHasAllowedLocationServices{
	
#if __IPHONE_OS_VERSION_MIN_REQUIRED < BEINTOO_IOS_4_0
    CLLocationManager *_locationManager = [Beintoo sharedInstance]->locationManager;
#endif
	BOOL isLocationServicesEnabled;
    
    if ([CLLocationManager respondsToSelector:@selector(locationServicesEnabled)]) {
		isLocationServicesEnabled = [CLLocationManager locationServicesEnabled];	
	}
#if __IPHONE_OS_VERSION_MIN_REQUIRED < BEINTOO_IOS_4_0
    else {
		isLocationServicesEnabled = _locationManager.locationServicesEnabled;
	}
#endif
    
	return isLocationServicesEnabled;
}

+ (BPlayerWrapper *)getPlayer{
    @try
    {
        if ([[NSUserDefaults standardUserDefaults] objectForKey:BNSDefLoggedPlayer])
        {
            /**
            *** Patch for older versions using NSDictionary type of BeintooPlayer, we have to replace it with the BPlayerWrapper object
            **/
            
            if ([[[NSUserDefaults standardUserDefaults] objectForKey:BNSDefLoggedPlayer] isKindOfClass:[NSDictionary class]])
            {
                BPlayerWrapper *player = [[BPlayerWrapper alloc] initWithContentOfDictionary:[[NSUserDefaults standardUserDefaults] objectForKey:BNSDefLoggedPlayer]];
                [Beintoo setBeintooPlayer:player];
                
            }
            
            return [NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:BNSDefLoggedPlayer]];
        }
    }
    @catch (NSException *exception) {
        BeintooLOG(@"Exception on getting Player from stored preferences, %@", exception);
    }
    
    return nil;
}

+ (void)setBeintooPlayer:(BPlayerWrapper *)_player{
	[self _setBeintooPlayer:_player];
}

+ (void)playerLogout{
	[self _playerLogout];
}

+ (BUserWrapper *)getUserIfLogged
{
    @try
    {
        if ([Beintoo isUserLogged])
        {
            return [Beintoo getPlayer].user;
        }
    }
    @catch (NSException *exception) {
        BeintooLOG(@"Exception on getting User from stored preferences, %@", exception);
    }
    
	return nil;
}

+ (BOOL)isUserLogged{
    @try
    {
        if ([Beintoo getPlayer] != nil)
        {
            BPlayerWrapper *player = [Beintoo getPlayer];
            
            if (player.user != nil)
            {
                BUserWrapper *user = player.user;
                
                if (user.userid)
                    return TRUE;
            }
        }
    }
    @catch (NSException *exception) {
        BeintooLOG(@"Exception on getting User from stored preferences, %@", exception);
    }
    
	return FALSE;
}

+ (BAdWrapper *)getLastGeneratedAd{
	@synchronized(self){
#ifdef BEINTOO_ARC_AVAILABLE
        return [Beintoo sharedInstance]->lastGeneratedAd;
#else
        return [[Beintoo sharedInstance]->lastGeneratedAd retain];
#endif
	}
}

+ (BOOL)isAdReady{
    if ([Beintoo sharedInstance]->lastGeneratedAd != nil)
        return YES;
    else
        return NO;
}

+ (NSDictionary *)getAppVgoodThresholds{
    if ([Beintoo getPlayer] != nil)
        return [Beintoo getPlayer].vgoodThreshold;
        
    return nil;
}

#pragma mark - Common methods

+ (void)setLastGeneratedAd:(BAdWrapper *)wrapper{
	@synchronized(self){
		[self _setLastAd:wrapper];
	}
}

+ (int)appOrientation{
	return [Beintoo sharedInstance]->appOrientation;
}

+ (void)changeBeintooOrientation:(int)_orientation{
	if ([Beintoo isBeintooInitialized]) {
		[Beintoo setAppOrientation:_orientation];
       
        /*
        ** Need to alert Reward or other container about the changes of the orientation with a delay,
        ** elsewhere the - (void)eventuallyUpdateDisplayedContent; method will be performed faster than the [Beintoo setAppOrientation:_orientation];
        */
        
        [self performSelector:@selector(eventuallyUpdateDisplayedContent) withObject:nil afterDelay:0.1];
    }
}

+ (void)eventuallyUpdateDisplayedContent
{
    /* BPrize	*_prizeView = [Beintoo sharedInstance]->prizeView;
    if (_prizeView.alpha == 1){
        [_prizeView preparePrizeAlertOrientation:_prizeView.frame];
    }
    
    BPrize	*_adView = [Beintoo sharedInstance]->adView;
    if (_adView.alpha == 1){
        [_adView preparePrizeAlertOrientation:_adView.frame];
    } */
}

+ (NSString *)getRestBaseUrl{
	return [Beintoo sharedInstance]->restBaseUrl;
}

+ (NSString *)getDisplayBaseUrl{
	return [Beintoo sharedInstance]->displayBaseUrl;
}

+ (NSString *)getPlayerID{
    BPlayerWrapper *_beintooPlayer = [Beintoo getPlayer];
	if(_beintooPlayer != nil)
    {
        return _beintooPlayer.guid;
	}
	return nil;
}

+ (NSString *)getUserID{
	BUserWrapper *_beintooUser = [Beintoo getUserIfLogged];
    if(_beintooUser != nil)
    {
        return _beintooUser.userid;
	}
	return nil;	
}

+ (void)switchBeintooToSandbox{
	[Beintoo switchToSandbox];
	BeintooLOG(@"------------------------------------- Beintoo Sandbox ON -------------------------------------");
}

+ (NSString *)getUserLocationForURL{
	CLLocation *loc = [Beintoo getUserLocation];
	NSString *locationForURL = nil;
	
	if (loc == nil || (loc.coordinate.latitude <= 0.01f && loc.coordinate.latitude >= -0.01f) 
		|| (loc.coordinate.longitude <= 0.01f && loc.coordinate.longitude >= -0.01f)){
		return nil;
	}
	locationForURL = [NSString stringWithFormat:@"&lat=%f&lng=%f&acc=%f",loc.coordinate.latitude,
					  loc.coordinate.longitude,loc.horizontalAccuracy];
	return locationForURL;
}

+ (UIWindow *)getAppWindow{
	return [Beintoo getApplicationWindow];
}

+ (BMessageAnimated *)getNotificationView{
	return [Beintoo sharedInstance]->notificationView;
}

+ (BOOL)showAchievementNotification{
    return [Beintoo sharedInstance]->showAchievementNotification;
}

+ (BOOL)showLoginNotification{
    return [Beintoo sharedInstance]->showLoginNotification;
}

+ (BOOL)showScoreNotification{
    return [Beintoo sharedInstance]->showScoreNotification;
}

+ (BOOL)showNoRewardNotification{
    return [Beintoo sharedInstance]->showNoRewardNotification;
}

+ (void)updateUserLocation{
	[self _updateUserLocation];
}

+ (CLLocation *)getUserLocation{
	return [Beintoo sharedInstance]->userLocation;
}

#pragma mark - Notifications

+ (void)notifyRewardGenerationOnMainDelegate:(BRewardWrapper *)reward{
	
    id<BeintooMainDelegate> _mainDelegate = [Beintoo sharedInstance]->mainDelegate;
	
	if ([_mainDelegate respondsToSelector:@selector(didBeintooGenerateAReward:)]) {
		[_mainDelegate didBeintooGenerateAReward:reward];
	}
}

+ (void)notifyRewardGenerationErrorOnMainDelegate:(NSDictionary *)_error{
	id<BeintooMainDelegate> _mainDelegate = [Beintoo sharedInstance]->mainDelegate;
	
	if ([_mainDelegate respondsToSelector:@selector(didBeintooFailToGenerateARewardWithError:)]) {
		[_mainDelegate didBeintooFailToGenerateARewardWithError:_error];
	}
}

+ (void)notifyGiveBedollarsGenerationOnMainDelegate:(BGiveBedollarsWrapper *)wrapper
{
    id<BeintooMainDelegate> _mainDelegate = [Beintoo sharedInstance]->mainDelegate;
	
	if ([_mainDelegate respondsToSelector:@selector(didReceiveGiveBedollarsResponse:)]) {
		[_mainDelegate didReceiveGiveBedollarsResponse:wrapper];
	}
}

+ (void)notifyGiveBedollarsGenerationErrorOnMainDelegate:(NSDictionary *)_error
{
    id<BeintooMainDelegate> _mainDelegate = [Beintoo sharedInstance]->mainDelegate;
	
	if ([_mainDelegate respondsToSelector:@selector(didFailToPerformGiveBedollarsWithResponse:)]) {
		[_mainDelegate didFailToPerformGiveBedollars:_error];
	}
}

+ (void)notifyEventGenerationOnMainDelegate:(BEventWrapper *)wrapper
{
    id<BeintooMainDelegate> _mainDelegate = [Beintoo sharedInstance]->mainDelegate;
	
	if ([_mainDelegate respondsToSelector:@selector(didGenerateAnEvent:)]) {
		[_mainDelegate didGenerateAnEvent:wrapper];
	}
}

+ (void)notifyEventGenerationErrorOnMainDelegate:(NSDictionary *)_error
{
    id<BeintooMainDelegate> _mainDelegate = [Beintoo sharedInstance]->mainDelegate;
	
	if ([_mainDelegate respondsToSelector:@selector(didFailToGenerateAnEvent:)]) {
		[_mainDelegate didFailToGenerateAnEvent:_error];
	}
}

+ (void)notifyAdGenerationOnMainDelegate:(BAdWrapper *)wrapper{
	id<BeintooMainDelegate> _mainDelegate = [Beintoo sharedInstance]->mainDelegate;
	
	if ([_mainDelegate respondsToSelector:@selector(didBeintooGenerateAnAd:)]) {
		[_mainDelegate didBeintooGenerateAnAd:wrapper];
	}
}

+ (void)notifyAdGenerationErrorOnMainDelegate:(NSDictionary *)_error{
	id<BeintooMainDelegate> _mainDelegate = [Beintoo sharedInstance]->mainDelegate;
	
	if ([_mainDelegate respondsToSelector:@selector(didBeintooFailToGenerateAnAdWithError:)]) {
		[_mainDelegate didBeintooFailToGenerateAnAdWithError:_error];
	}
}

+ (void)beintooWillAppear{
	[Beintoo _beintooWillAppear];
}

+ (void)beintooDidAppear{
	[Beintoo _beintooDidAppear];
}

+ (void)beintooWillDisappear{
	[Beintoo _beintooWillDisappear];
}

+ (void)beintooDidDisappear{
	[Beintoo _beintooDidDisappear];
}

+ (void)adControllerDidAppear{
	[Beintoo _adControllerDidAppear];
}

+ (void)adControllerDidDisappear{
	[Beintoo _adControllerDidDisappear];
}

+ (void)giveBedollarsControllerDidAppear{
	[Beintoo _giveBedollarsControllerDidAppear];
}

+ (void)giveBedollarsControllerDidDisappear{
	[Beintoo _giveBedollarsControllerDidDisappear];
}

#pragma mark - Post Notifications

+ (void)postNotificationBeintooUserDidLogin{
	[Beintoo _beintooUserDidLogin];
}

+ (void)postNotificationBeintooUserDidSignup{
	[Beintoo _beintooUserDidSignup];
}

#pragma mark - Shutdown and release

+ (void)shutdownBeintoo{
	
	Beintoo *beintooInstance = [Beintoo sharedInstance];

	if (beintooInstance == nil){
		return;
	}
    
#ifdef BEINTOO_ARC_AVAILABLE
#else
    /* --------------------------------------------- */
	[beintooInstance->apiKey release];
	beintooInstance->apiKey = nil;
	/* --------------------------------------------- */
	[beintooInstance->apiSecret release];
	beintooInstance->apiSecret = nil;
	/* --------------------------------------------- */
	[beintooInstance->locationManager release];
	beintooInstance->locationManager = nil;
	/* --------------------------------------------- */
	[beintooInstance->userLocation release];
	beintooInstance->userLocation = nil;
	/* --------------------------------------------- */
	[beintooInstance->notificationView release];
	beintooInstance->notificationView = nil;
	/* --------------------------------------------- */
	[beintooInstance->mainController release];
	beintooInstance->mainController = nil;
	/* --------------------------------------------- */
	[[Beintoo sharedInstance]->beintooPlayerService release];
	[Beintoo sharedInstance]->beintooPlayerService = nil;
    /* --------------------------------------------- */
	[[Beintoo sharedInstance]->beintooUserService release];
	[Beintoo sharedInstance]->beintooUserService = nil;
	/* --------------------------------------------- */
	[beintooInstance->beintooAchievementsService release];
	beintooInstance->beintooAchievementsService = nil;
    /* --------------------------------------------- */
    [beintooInstance->beintooBestoreService release];
    beintooInstance->beintooBestoreService = nil;
    /* --------------------------------------------- */
	
	[beintooInstance release];
#endif
    
    beintooInstance = nil;
}

- (void)dealloc
{
    
#ifdef BEINTOO_ARC_AVAILABLE
#else
	[super dealloc];

#endif

}

@end
