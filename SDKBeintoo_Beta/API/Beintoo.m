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

#import "Beintoo.h"
#import "Beintoo+Private.h"


@implementation Beintoo

NSString *BNSDefIsUserLogged;

+ (void)initWithApiKey:(NSString *)_apikey andApiSecret:(NSString *)_apisecret 
										   andBeintooSettings:(NSDictionary *)_settings 
										   andMainDelegate:(id<BeintooMainDelegate>)beintooMainDelegate{
	
	if ([Beintoo sharedInstance]) { 
		return; // -- Beintoo already initialized -- //
	}
	
	[Beintoo createSharedBeintoo];
	Beintoo *beintooInstance = [Beintoo sharedInstance];
	
	beintooInstance->mainDelegate = beintooMainDelegate;
	
	[beintooInstance initDelegates];
	
	[Beintoo initAPI];
	[Beintoo setApiKey:_apikey andApisecret:_apisecret];
	[Beintoo initLocallySavedScoresArray];
	[Beintoo initLocallySavedAchievementsArray];
    [Beintoo initUserAgent];
	[Beintoo initPlayerService];
    [Beintoo initUserService];
	[Beintoo initVgoodService];
	[Beintoo initAchievementsService];
    [Beintoo initMissionService];
    [Beintoo initMarketplaceService];
	
	// Settings initialization
	[Beintoo initBeintooSettings:_settings];

	// Beintoo main controllers initialization
	[Beintoo initMainNavigationController];
	[Beintoo initMainController];
	[Beintoo initVgoodNavigationController];
	[Beintoo initiPadController];
	
	// Popover initialization
    if ([BeintooDevice isiPad]) {
        [Beintoo initPopoversForiPad];
    }
}

+ (void)launchBeintoo{
	[Beintoo _launchBeintooOnApp];
}

+ (void)launchBeintooOnAppWithVirtualCurrencyBalance:(float)_value{
	[Beintoo _launchBeintooOnAppWithDeveloperCurrencyValue:_value];
}

+ (void)launchMarketplace{
    [Beintoo _launchMarketplaceOnApp];
}

+ (void)launchMarketplaceOnAppWithVirtualCurrencyBalance:(float)_value{
	[Beintoo _launchMarketplaceOnAppWithDeveloperCurrencyValue:_value];
}

+ (void)launchWallet{
	[Beintoo _launchWalletOnApp];
}
+ (void)launchLeaderboard{
	[Beintoo _launchLeaderboardOnApp];
}
+ (void)launchPrize{
	[Beintoo _launchPrizeOnApp];
}

+ (void)launchPrizeOnAppWithDelegate:(id<BeintooPrizeDelegate>)_beintooPrizeDelegate{
    [Beintoo _launchPrizeOnAppWithDelegate:_beintooPrizeDelegate];
}

+ (void)launchMission{
    [Beintoo _launchMissionOnApp];
}

+ (void)launchIpadLogin{
	[Beintoo _launchIpadLogin];
}

+ (void)dismissIpadLogin{
	[Beintoo _dismissIpadLogin];
}

+ (NSString *)getApiKey{

	return [Beintoo sharedInstance]->apiKey;
}

+ (NSArray *)getFeatureList{
	return [Beintoo sharedInstance]->featuresArray;
}

+ (NSArray *)getLastLoggedPlayers{
	Beintoo *beintooInstance = [Beintoo sharedInstance];
	return [beintooInstance->lastLoggedPlayers retain];	
}

+ (NSDictionary *)getLastRetrievedMission{
    return [Beintoo sharedInstance]->lastRetrievedMission;
}

+ (void)setLastRetrievedMission:(NSDictionary *)_mission{
    [Beintoo sharedInstance]->lastRetrievedMission = [_mission retain];
}
								
+ (NSString *)currentVersion{
	return @"2.8.16beta-ios";
}

+ (NSInteger)notificationPosition{
    return [Beintoo sharedInstance]->notificationPosition;
}

+ (BOOL)isUserLogged{
	return [[NSUserDefaults standardUserDefaults] boolForKey:BNSDefIsUserLogged];
}

+ (BOOL)isRegistrationForced{
	return [Beintoo sharedInstance]->forceRegistration;
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
+ (BOOL)dismissBeintooOnRegistrationEnd{
    return [Beintoo sharedInstance]->dismissBeintooAfterRegistration;
}
+ (BOOL)isStatusBarHiddenOnApp{
    return [Beintoo sharedInstance]->statusBarHiddenOnApp;
}

+ (BOOL)isTryBeintooForced{
    return [Beintoo sharedInstance]->forceTryBeintoo;
}
+ (BOOL)isOnSandbox{
	if ([Beintoo sharedInstance]) {
		return [Beintoo sharedInstance]->isOnSandbox;
	}
	return NO;
}
+ (BOOL)isTryBeintooImageTypeReward{
    return [Beintoo sharedInstance]->tryBeintooImageTypeReward;
}

+ (BOOL)isOnPrivateSandbox{
	if ([Beintoo sharedInstance]) {
		return [Beintoo sharedInstance]->isOnPrivateSandbox;
	}
	return NO;
}

+ (void)_setUserLocation:(CLLocation *)_location{
	[Beintoo sharedInstance]->userLocation = _location;
}

+ (BOOL)userHasAllowedLocationServices{
	CLLocationManager *_locationManager = [Beintoo sharedInstance]->locationManager;
	BOOL isLocationServicesEnabled;
	
	if ([CLLocationManager respondsToSelector:@selector(locationServicesEnabled)]) {
		isLocationServicesEnabled = [CLLocationManager locationServicesEnabled];	
	}else {
		isLocationServicesEnabled = _locationManager.locationServicesEnabled;
	}
	return isLocationServicesEnabled;
}

+ (void)setUserLogged:(BOOL)isLoggedValue{
	[[NSUserDefaults standardUserDefaults] setBool:isLoggedValue forKey:BNSDefIsUserLogged];
	if (!isLoggedValue) {
		[Beintoo _playerLogout];
	}
}

+ (NSString *)getMissionTimestamp{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"LastSeenMissionTimestamp"];
}
+ (void)setMissionTimestamp:(NSString *)_timestamp{
    [[NSUserDefaults standardUserDefaults] setObject:_timestamp forKey:@"LastSeenMissionTimestamp"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


+ (UIViewController *)getMainController{
	return [Beintoo sharedInstance]->mainController;
}
+ (BeintooNavigationController *)getMainNavigationController{
	return [Beintoo sharedInstance]->mainNavigationController;
}
+ (BeintooVgoodNavController *)getVgoodNavigationController{
	return [Beintoo sharedInstance]->vgoodNavigationController;
}

// -----------------------------------
// Beintoo Player
// -----------------------------------
+ (NSDictionary *)getPlayer{
	return [[NSUserDefaults standardUserDefaults]objectForKey:BNSDefLoggedPlayer];
}

+ (void)setBeintooPlayer:(NSDictionary *)_player{
	[self _setBeintooPlayer:_player];
}

+ (void)playerLogout{
	[self _playerLogout];
}

// -----------------------------------
// Beintoo User
// -----------------------------------

+ (NSDictionary *)getUserIfLogged{
	return [[NSUserDefaults standardUserDefaults]objectForKey:BNSDefLoggedUser];
}
+ (void)setBeintooUser:(NSDictionary *)_user{
	[self _setBeintooUser:_user];
}

// -----------------------------------
// Virtual Good
// -----------------------------------

+ (BVirtualGood *)getLastGeneratedVGood{
	@synchronized(self){
		return [[Beintoo sharedInstance]->lastGeneratedGood retain];
	}
}

#pragma mark - Thresholds

+ (NSDictionary *)getAppVgoodThresholds{
    return [[Beintoo getPlayer] objectForKey:@"vgoodThreshold"];
}

+ (BeintooVgood *)beintooVgoodService{
	return [Beintoo sharedInstance]->beintooVgoodService;
}

+ (BeintooPlayer *)beintooPlayerService{
	return [Beintoo sharedInstance]->beintooPlayerService;
}

+ (BeintooUser *)beintooUserService{
	return [Beintoo sharedInstance]->beintooUserService;
}

+ (BeintooAchievements *)beintooAchievementService{
	return [Beintoo sharedInstance]->beintooAchievementsService;
}

+ (BeintooMission *)beintooMissionService{
    return [Beintoo sharedInstance]->beintooMissionService;
}

+ (BeintooMarketplace *)beintooMarketplaceService{
    return [Beintoo sharedInstance]->beintooMarketplaceService;
}

// -----------------------------------
// Devolper's Custom Virtual Currency
// -----------------------------------

+ (void)setVirtualCurrencyName:(NSString *)_name{
    [Beintoo _setDeveloperCurrencyName:_name];
}

+ (NSString *)getVirtualCurrencyName{
    return [Beintoo _getDeveloperCurrencyName];
}

+ (void)setVirtualCurrencyBalance:(float)_value{
    [Beintoo _setDeveloperCurrencyValue:_value];
}

+ (float)getVirtualCurrencyBalance{
    return [Beintoo _getDeveloperCurrencyValue];
}

+ (void)setDeveloperUserId:(NSString *)_id{
    [Beintoo _setDeveloperUserId:_id];
}

+ (NSString *)getDeveloperUserId{
    return [Beintoo _getDeveloperUserId];
}

+ (void)setDeveloperUserId:(NSString *)_userId withBalance:(float)_value{
    [Beintoo _setDeveloperCurrencyValue:_value];
    [Beintoo _setDeveloperUserId:_userId];
}

+ (void)setVirtualCurrencyName:(NSString *)_name forUserId:(NSString *)_userId withBalance:(float)_value{
    [Beintoo _setDeveloperCurrencyName:_name];
    [Beintoo _setDeveloperCurrencyValue:_value];
    [Beintoo _setDeveloperUserId:_userId];
}

+ (void)removeStoredVirtualCurrency{
    [Beintoo _removeStoredCurrencyAndUser];
}

+ (BOOL)isVirtualCurrencyStored{
    return [Beintoo _isCurrencyStored];
}

+ (void)setLastGeneratedVgood:(BVirtualGood *)_theVGood{
	@synchronized(self){
		[self _setLastVgood:_theVGood];
	}
}

+ (int)appOrientation{
	return [Beintoo sharedInstance]->appOrientation;
}

+ (void)changeBeintooOrientation:(int)_orientation{
	if ([Beintoo isBeintooInitialized]) {
		[Beintoo setAppOrientation:_orientation];
        
        BPrize	*_prizeView = [Beintoo sharedInstance]->prizeView;
        if (_prizeView.alpha == 1){
            [_prizeView preparePrizeAlertOrientation:_prizeView.frame];
        }
	}
}

+ (NSString *)getRestBaseUrl{
	return [Beintoo sharedInstance]->restBaseUrl;
}

+ (NSString *)getPlayerID{
	NSDictionary *_beintooPlayer = [Beintoo getPlayer];
	if(_beintooPlayer!= nil){
		return [_beintooPlayer objectForKey:@"guid"];
	}
	return nil;
}
+ (NSString *)getUserID{
	NSDictionary *_beintooUser = [Beintoo getUserIfLogged];
	if(_beintooUser!= nil){
		return [_beintooUser objectForKey:@"id"];
	}
	return nil;	
}

+ (void)switchBeintooToSandbox{
	[Beintoo switchToSandbox];
	NSLog(@"------------------------------------- Beintoo Sandbox ON -------------------------------------");
}

#pragma mark - Dispatch Queue

+ (dispatch_queue_t)beintooDispatchQueue{
    return [Beintoo sharedInstance]->beintooDispatchQueue;
}

#pragma mark -
#pragma mark DelegateNotifications

+ (void)notifyVGoodGenerationOnMainDelegate{
	id<BeintooMainDelegate> _mainDelegate = [Beintoo sharedInstance]->mainDelegate;
	
	if ([_mainDelegate respondsToSelector:@selector(didBeintooGenerateAVirtualGood:)]) {
		[_mainDelegate didBeintooGenerateAVirtualGood:[Beintoo sharedInstance]->lastGeneratedGood];
	}	
}

+ (void)notifyVGoodGenerationErrorOnMainDelegate:(NSDictionary *)_error{
	id<BeintooMainDelegate> _mainDelegate = [Beintoo sharedInstance]->mainDelegate;
	
	if ([_mainDelegate respondsToSelector:@selector(didBeintooFailToGenerateAVirtualGoodWithError:)]) {
		[_mainDelegate didBeintooFailToGenerateAVirtualGoodWithError:_error];
	}	
}

+ (void)notifyRetrievedMisionOnMainDelegateWithMission:(NSDictionary *)_mission{
    id<BeintooMainDelegate> _mainDelegate = [Beintoo sharedInstance]->mainDelegate;
	
	if ([_mainDelegate respondsToSelector:@selector(didBeintooGetAMission:)]) {
		[_mainDelegate didBeintooGetAMission:_mission];
	}	
}

+ (void)notifyRetrievedMisionErrorOnMainDelegateWithMission:(NSDictionary *)_error{
    id<BeintooMainDelegate> _mainDelegate = [Beintoo sharedInstance]->mainDelegate;
	
	if ([_mainDelegate respondsToSelector:@selector(didBeintooFailToGetAMission:)]) {
		[_mainDelegate didBeintooFailToGetAMission:_error];
	}	
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

+ (BeintooVC *)getBeintooPanelRootViewController{
	return [Beintoo sharedInstance]->beintooPanelRootViewController;
}
+ (UIWindow *)getAppWindow{
	return [Beintoo getApplicationWindow];
}
+ (BMessageAnimated *)getNotificationView{
	return [Beintoo sharedInstance]->notificationView;
}

+ (id<BeintooMainDelegate>)getMainDelegate{
	return [Beintoo sharedInstance]->mainDelegate;
}

+ (void)updateUserLocation{
	[self _updateUserLocation];
}
+ (CLLocation *)getUserLocation{
	return [Beintoo sharedInstance]->userLocation;
}

+ (void)setLastLoggedPlayers:(NSArray *)_players{
	[Beintoo _setLastLoggedPlayers:_players];
}

+ (void)dismissBeintoo{
	[Beintoo _dismissBeintoo];
}

+ (void)dismissBeintooNotAnimated{
    [Beintoo _dismissBeintooNotAnimated];
}

+ (void)dismissMission{
	[Beintoo _dismissMission];
}

+ (void)dismissPrize{
	[Beintoo _dismissPrize];
}

+ (void)dismissRecommendation{
	[Beintoo _dismissRecommendation];
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
+ (void)prizeDidAppear{
	[Beintoo _prizeDidAppear];
}
+ (void)prizeDidDisappear{
	[Beintoo _prizeDidDisappear];
}

+ (void)shutdownBeintoo{
	
	Beintoo *beintooInstance = [Beintoo sharedInstance];

	if (beintooInstance == nil){
		return;
	}
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
	[beintooInstance->lastGeneratedGood release];
	beintooInstance->lastGeneratedGood = nil;
	/* --------------------------------------------- */
	[beintooInstance->lastLoggedPlayers release];
	beintooInstance->lastLoggedPlayers = nil;
	/* --------------------------------------------- */
	[beintooInstance->prizeView release];
	beintooInstance->prizeView = nil;
    /* --------------------------------------------- */
	[beintooInstance->lastRetrievedMission release];
	beintooInstance->lastRetrievedMission = nil;
    /* --------------------------------------------- */
	[beintooInstance->missionView release];
	beintooInstance->missionView = nil;
	/* --------------------------------------------- */
	[beintooInstance->notificationView release];
	beintooInstance->notificationView = nil;
	/* --------------------------------------------- */
	[beintooInstance->mainNavigationController release];
	beintooInstance->mainNavigationController = nil;
	/* --------------------------------------------- */
	[beintooInstance->vgoodNavigationController release];
	beintooInstance->vgoodNavigationController = nil;
	/* --------------------------------------------- */
	[beintooInstance->mainController release];
	beintooInstance->mainController = nil;
	/* --------------------------------------------- */
	[beintooInstance->featuresArray release];
	beintooInstance->featuresArray = nil;
	/* --------------------------------------------- */  
	[beintooInstance->beintooPanelRootViewController release];  // Released
	beintooInstance->beintooPanelRootViewController = nil;
    /* --------------------------------------------- */  
	[beintooInstance->beintooMarketplaceViewController release];  // Released
	beintooInstance->beintooMarketplaceViewController = nil;
	/* --------------------------------------------- */  
	[beintooInstance->beintooWalletViewController release];  // Released
	beintooInstance->beintooWalletViewController = nil;
    /* --------------------------------------------- */  
	[beintooInstance->beintooLeaderboardVC release];  // Released
	beintooInstance->beintooLeaderboardVC = nil;
    /* --------------------------------------------- */  
	[beintooInstance->beintooLeaderboardWithContestVC release];  // Released
	beintooInstance->beintooLeaderboardWithContestVC = nil;
	/* --------------------------------------------- */  
	[beintooInstance->beintooWalletViewController release];  // Released
	beintooInstance->beintooWalletViewController = nil;
    /* --------------------------------------------- */  
	[beintooInstance->beintooLeaderboardVC release];  // Released
	beintooInstance->beintooLeaderboardVC = nil;
    /* --------------------------------------------- */  
	[beintooInstance->beintooLeaderboardWithContestVC release];  // Released
	beintooInstance->beintooLeaderboardWithContestVC = nil;
	/* --------------------------------------------- */
	[[Beintoo sharedInstance]->beintooPlayerService release];
	[Beintoo sharedInstance]->beintooPlayerService = nil;
    /* --------------------------------------------- */
	[[Beintoo sharedInstance]->beintooUserService release];
	[Beintoo sharedInstance]->beintooUserService = nil;
	/* --------------------------------------------- */
	[beintooInstance->beintooVgoodService release];
	beintooInstance->beintooVgoodService = nil;	
	/* --------------------------------------------- */
	[beintooInstance->beintooAchievementsService release];
	beintooInstance->beintooAchievementsService = nil;
    /* --------------------------------------------- */
    [beintooInstance->beintooMissionService release];
    beintooInstance->beintooMissionService = nil;
    /* --------------------------------------------- */
    /* --------------------------------------------- */
    [beintooInstance->beintooMarketplaceService release];
    beintooInstance->beintooMarketplaceService = nil;
    /* --------------------------------------------- */
	
	[beintooInstance release];
	beintooInstance = nil;
}


- (void)dealloc{	
	[super dealloc];
}


@end
