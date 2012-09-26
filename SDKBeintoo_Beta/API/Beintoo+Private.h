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

#import <Foundation/Foundation.h>
#import "Beintoo.h"

#define HOURS_TO_SHOW_TRYBEINTOO   24*7

@interface Beintoo (Private) <CLLocationManagerDelegate,
#ifdef UI_USER_INTERFACE_IDIOM 
UIPopoverControllerDelegate,
#endif 
BeintooPrizeDelegate, BeintooMissionViewDelegate> 

+ (Beintoo *)sharedInstance;
+ (UIWindow *)getApplicationWindow;
+ (void)setApiKey:(NSString *)_apikey andApisecret:(NSString *)_apisecret;
+ (void)createSharedBeintoo;
+ (void)setAppOrientation:(int)_appOrientation;
+ (void)setForceRegistration:(BOOL)_value;
+ (void)setShowAchievementNotificatio:(BOOL)_value;
+ (void)setShowLoginNotification:(BOOL)_value;
+ (void)setShowScoreNotification:(BOOL)_value;
+ (void)setShowNoRewardNotification:(BOOL)_value;
+ (void)setForceTryBeintoo:(BOOL)_value;
+ (void)setDismissBeintooAfterRegistration:(BOOL)_value;
+ (void)setTryBeintooImageTypeReward:(BOOL)_value;
+ (void)setNotificationPosition:(NSInteger)_value;
+ (void)initAPI;
+ (void)initMainAdController;
+ (void)initPlayerService;
+ (void)initUserService;
+ (void)initVgoodService;
+ (void)initAchievementsService;
+ (void)initBestoreService;
+ (void)initMainController;
+ (void)initVgoodNavigationController;
+ (void)initMainNavigationController;
+ (void)initAdNavigationController;
+ (void)initiPadController;
+ (void)initPopoversForiPad;
+ (void)switchToSandbox;
+ (void)privateSandbox;
+ (void)_launchBeintooOnApp;
+ (void)_launchBeintooOnAppWithDeveloperCurrencyValue:(float)_value;
+ (void)_launchNotificationsOnApp;
+ (void)_launchMarketplaceOnApp;
+ (void)_launchMarketplaceOnAppWithDeveloperCurrencyValue:(float)_value;
+ (void)_launchWalletOnApp;
+ (void)_launchLeaderboardOnApp;
+ (void)_launchAchievementsOnApp;
+ (void)_launchPrizeOnApp;
+ (void)_launchPrizeOnAppWithDelegate:(id<BeintooPrizeDelegate>)_beintooPrizeDelegate;
+ (void)_launchAd;
+ (void)_launchAdWithDelegate:(id<BeintooPrizeDelegate>)_beintooPrizeDelegate;
+ (void)_launchMissionOnApp;
+ (void)_launchSignupOnApp;
+ (void)_launchPrivateSignupOnApp;
+ (void)_launchPrivateNotificationsOnApp;
+ (void)_launchIpadLogin;
+ (void)_dismissIpadLogin;
+ (void)_launchIpadNotifications;
+ (void)_dismissIpadNotifications;
+ (void)_dismissBeintoo;
+ (void)_dismissBeintoo:(int)type;
+ (void)_dismissBeintooNotAnimated;
+ (void)_dismissPrize;
+ (void)_dismissAd;
+ (void)_dismissMission;
+ (void)_dismissRecommendation;
+ (void)_updateUserLocation;
+ (void)initBeintooSettings:(NSDictionary *)_settings;
+ (void)initLocallySavedScoresArray;
+ (void)initLocallySavedAchievementsArray;
+ (void)initUserAgent;
+ (void)_setBeintooPlayer:(NSDictionary *)_player;
+ (void)_setBeintooUser:(NSDictionary *)_user;
+ (void)_setLastVgood:(BVirtualGood *)_vgood;
+ (void)_setLastAd:(BVirtualGood *)_ad;
+ (void)_setLastLoggedPlayers:(NSArray *)_players;
+ (void)_playerLogout;
+ (void)_beintooDidAppear;
+ (void)_beintooWillDisappear;
+ (void)_beintooDidDisappear;
+ (void)_prizeDidAppear;
+ (void)_prizeDidDisappear;
+ (void)setApplicationWindow:(UIWindow *)_window;
+ (BOOL)isBeintooInitialized;
+ (NSString *)getLastTimeForTryBeintooShowTimestamp;
+ (void)setLastTimeForTryBeintooShowTimestamp:(NSString *)_value;
+ (void)_setBeintooUserFriends:(NSArray *)friends;
+ (NSArray *)_getBeintooUserFriends;
+ (BOOL)_isAFriendOfMine:(NSString *)_friendID;

- (void)initDelegates;

//--> Currency Management
+ (void)_setDeveloperCurrencyName:(NSString *)_name;
+ (NSString *)_getDeveloperCurrencyName; 
+ (void)_setDeveloperUserId:(NSString *)_id;
+ (NSString *)_getDeveloperUserId;
+ (void)_setDeveloperCurrencyValue:(float)_value;
+ (float)_getDeveloperCurrencyValue;
+ (void)_removeStoredCurrencyAndUser;
+ (BOOL)_isCurrencyStored;
+ (BOOL)_isLoggedUserIdStored;
// <--

+ (void)manageStatusBarOnLaunch;
+ (void)manageStatusBarOnDismiss;
+ (void)_setIsStatusBarHiddenOnApp:(BOOL)_value;

+ (void)_beintooUserDidLogin;
+ (void)_beintooUserDidSignup;

+ (void)_adControllerDidAppear;
+ (void)_adControllerDidDisappear;

@end
