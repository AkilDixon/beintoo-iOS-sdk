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

// Frameworks
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <QuartzCore/QuartzCore.h>

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= BEINTOO_IOS_6_0
    #import <AdSupport/AdSupport.h>
#endif

// APIs
#import "BeintooPlayer.h"
#import "BeintooMission.h"
#import "BLoadingView.h"
#import "BeintooUser.h"
#import "BeintooAchievements.h"
#import "BeintooBestore.h"
#import "BeintooApp.h"
#import "BeintooAd.h"
#import "BeintooReward.h"
#import "BeintooEvent.h"

// Commons
#import "BeintooMacros.h"
#import "BeintooNetwork.h"
#import "BeintooDevice.h"
#import "BImageDownload.h"
#import "BGradientView.h"
#import "BButton.h"
#import "BeintooGraphic.h"
#import "BeintooMainDelegate.h"
#import "BMessageAnimated.h"
#import "BeintooUrlParser.h"
#import "BAnimatedNotificationQueue.h"

// Wrappers
#import "BPlayerWrapper.h"
#import "BUserWrapper.h"
#import "BMissionWrapper.h"
#import "BRewardWrapper.h"
#import "BAdWrapper.h"
#import "BGiveBedollarsWrapper.h"

// Beintoo Webview with custom url schemes
#import "BeintooWebview.h"
#import "BCustomUrlScheme.h"

// Templates
#import "BTemplate.h"
#import "BTemplateGiveBedollars.h"
#import "BMissionTemplate.h"

// Templates Controllers
#import "BTemplateVC.h"

// Beintoo Navigation Controllers
#import "BeintooMainController.h"

// BeintooActiveFeatures : NSArray
extern NSString *BeintooActiveFeatures;
extern NSString *BeintooAppOrientation;
extern NSString *BeintooForceRegistration;
extern NSString *BeintooApplicationWindow;
extern NSString *BeintooAchievementNotification;
extern NSString *BeintooLoginNotification;
extern NSString *BeintooScoreNotification;
extern NSString *BeintooNoRewardNotification;
extern NSString *BeintooNotificationPosition;
extern NSString *BeintooDismissAfterRegistration;
extern NSString *BeintooTryBeintooWithRewardImage;
extern NSInteger BeintooNotificationPositionTop;
extern NSInteger BeintooNotificationPositionBottom; 
extern NSString *BeintooAppStatusBarHidden;

extern NSString *BeintooSdkVersion;
extern NSString *BeintooPlatform;

extern NSString *BeintooNotificationSignupClosed;
extern NSString *BeintooNotificationOrientationChanged;
extern NSString *BeintooNotificationReloadDashboard;
extern NSString *BeintooNotificationReloadFriendsList;
extern NSString *BeintooNotificationChallengeSent;
extern NSString *BeintooNotificationCloseBPickerView;

extern NSString *BNSDefLastLoggedPlayers;
extern NSString *BNSDefLoggedPlayer;
extern NSString *BNSDefLoggedUser;
extern NSString *BNSDefIsUserLogged;

@class BeintooVC;

@interface Beintoo : NSObject
{	
	id <BeintooMainDelegate> mainDelegate;

	NSString			*apiKey;
	NSString			*apiSecret;
	NSString			*deviceID;
	NSString			*restBaseUrl;
    NSString			*displayBaseUrl;
    
	int					appOrientation;
	BOOL				isOnSandbox;
    BOOL                isOnPrivateSandbox;
    BOOL                showAchievementNotification;
    BOOL                showLoginNotification;
    BOOL                showScoreNotification;
    BOOL                showNoRewardNotification;
    BOOL                statusBarHiddenOnApp;

    dispatch_queue_t                beintooDispatchQueue;

    NSInteger                       notificationPosition;
	CLLocation                      *userLocation;
	CLLocationManager               *locationManager;
    
    BAnimatedNotificationQueue      *notificationQueue;
	
    UIWindow                        *applicationWindow;
	BeintooPlayer                   *beintooPlayerService;
    BeintooUser                     *beintooUserService;
	BeintooAchievements             *beintooAchievementsService;
    BeintooBestore                  *beintooBestoreService;
    BeintooApp                      *beintooAppService;
    BeintooAd                       *beintooAdService;
    BeintooReward                   *beintooRewardService;
    BeintooEvent                    *beintooEventService;
    BeintooMission                  *beintooMissionService;
	
    NSDictionary                    *lastRetrievedMission;

    BAdWrapper                      *lastGeneratedAd;
    
	BTemplateGiveBedollars          *giveBedollarsView;
    BMessageAnimated                *notificationView;
	
    BeintooMainController           *mainController;
    BeintooMainController           *mainAdController;
    BeintooMainController           *mainGbController;

    BeintooWebview                  *beintooWebView;
}

#pragma mark - Init Beintoo

+ (void)initWithApiKey:(NSString *)_apikey andApiSecret:(NSString *)_apisecret andBeintooSettings:(NSDictionary *)_settings andMainDelegate:(id<BeintooMainDelegate>)beintooMainDelegate;

#pragma mark - Player methods

+ (void)login;
+ (void)submitScore:(int)score __attribute__((deprecated()));
+ (void)submitScore:(int)score forContest:(NSString *)contestID __attribute__((deprecated()));
+ (void)submitScore:(int)score forContest:(NSString *)contestID withThreshold:(int)threshold __attribute__((deprecated()));
+ (void)submitScoreAndGetRewardForScore:(int)score andContest:(NSString *)codeID withThreshold:(int)threshold __attribute__((deprecated()));
+ (int)getThresholdScoreForCurrentPlayerWithContest:(NSString *)codeID;
+ (void)getScore __attribute__((deprecated()));
+ (void)playerLogout;

#pragma mark - Give Bedollars methods

+ (void)giveBedollars:(float)amount showNotification:(BOOL)showNotification withPosition:(int)position;

#pragma mark - Reward methods

+ (void)getReward;
+ (void)getRewardWithDelegate:(id)_delegate;
+ (void)getRewardWithContest:(NSString *)contestID;

#pragma mark - Ads methods

+ (void)requestAndDisplayAdWithDeveloperUserGuid:(NSString *)_developerUserGuid;
+ (void)requestAdWithDeveloperUserGuid:(NSString *)_developerUserGuid;

#pragma mark - Achievements methods

+ (void)unlockAchievement:(NSString *)achievementID;
+ (void)unlockAchievement:(NSString *)achievementID showNotification:(BOOL)showNotification;
+ (void)setAchievement:(NSString *)achievementID withPercentage:(int)percentage;
+ (void)setAchievement:(NSString *)achievementID withPercentage:(int)percentage showNotification:(BOOL)showNotification;
+ (void)setAchievement:(NSString *)achievementID withScore:(int)score;
+ (void)incrementAchievement:(NSString *)achievementID withScore:(int)score;
+ (void)unlockAchievementsInBackground:(NSArray *)achievementArray;
+ (void)getAchievementStatusAndPercentage:(NSString *)achievementID;

// BY OBJECT ID

+ (void)unlockAchievementByObjectID:(NSString *)objectID showNotification:(BOOL)showNotification;
+ (void)setAchievementByObjectID:(NSString *)objectID withPercentage:(int)percentage showNotification:(BOOL)showNotification;
+ (void)unlockAchievementsByObjectIDInBackground:(NSArray *)achievementArray;

#pragma mark - Set Delegates methods

+ (void)setPlayerDelegate:(id)delegate;
+ (void)setUserDelegate:(id)delegate;
+ (void)setAchievementsDelegate:(id)delegate;
+ (void)setRewardDelegate:(id)delegate;
+ (void)setAppDelegate:(id)delegate;
+ (void)setAdDelegate:(id)delegate;

#pragma mark - Launch and Dismiss methods

+ (void)launchBestore __attribute__((deprecated("use [Beintoo openBestore] instead")));
+ (void)launchBeintoo __attribute__((deprecated("use [Beintoo openDashboard] instead")));

+ (void)openDashboard;
+ (void)openBestore;
+ (void)openSignup;
+ (void)openMissions;
+ (void)openView:(NSString *)view orURL:(NSString *)URL;

+ (void)dismissView:(id)controller;

+ (void)displayAd;
+ (void)displayAdWithDelegate:(id<BeintooTemplateDelegate>)_beintooPrizeDelegate;

+ (void)showMission:(BMissionTemplate *)mission;
+ (void)showMission:(BMissionTemplate *)mission delegate:(id <BMissionTemplateDelegate>)delegate;

#pragma mark - Reward methods

+ (void)showReward:(BRewardWrapper *)reward;
+ (void)showReward:(BRewardWrapper *)reward withDelegate:()_delegate;
+ (void)hideReward:(BTemplate *)reward;

+ (void)reward:(BTemplate *)reward launchRewardControllerWithURL:(NSString *)URL;
+ (void)dismissRewardController;

#pragma mark - Ad methods

+ (void)showAd:(BAdWrapper *)wrapper;
+ (void)showAd:(BAdWrapper *)wrapper withDelegate:()_delegate;
+ (void)hideAd:(BTemplate *)template;

+ (void)ad:(BTemplate *)template launchRewardControllerWithURL:(NSString *)URL;
+ (void)dismissAdController;

#pragma mark - Give Bedollars methods

+ (void)showGiveBedollars:(BGiveBedollarsWrapper *)wrapper withDelegate:(id<BTemplateGiveBedollarsDelegate>)delegate position:(int)position;
+ (void)hideGiveBedollars:(BTemplateGiveBedollars *)template;

+ (void)giveBedollars:(BTemplateGiveBedollars *)template launchControllerWithURL:(NSString *)URL;
+ (void)dismissGiveBedollarsController;

#pragma mark - Custom Browser

+ (void)launchControllerWithURL:(NSString *)URL;
+ (void)dismissController:(id)navController;

#pragma mark - Global Services

+ (BeintooReward *)beintooRewardService;
+ (BeintooPlayer *)beintooPlayerService;
+ (BeintooUser *)beintooUserService;
+ (BeintooAchievements *)beintooAchievementService;
+ (BeintooBestore *)beintooBestoreService;
+ (BeintooApp *)beintooAppService;
+ (BeintooAd *)beintooAdService;
+ (BeintooEvent *)beintooEventService;
+ (BeintooMission *)beintooMissionService;

#pragma mark - Global Controllers

+ (UIViewController *)getMainController;
+ (BMessageAnimated *)getNotificationView;

#pragma mark - Private Methods

+ (UIWindow *)getAppWindow;
+ (int)appOrientation;
+ (id<BeintooMainDelegate>)getMainDelegate;
+ (dispatch_queue_t)beintooDispatchQueue;
+ (BAnimatedNotificationQueue *)getNotificationQueue;
+ (NSString *)currentVersion;
+ (NSString *)platform;
+ (NSInteger)notificationPosition;
+ (BPlayerWrapper *)getPlayer;
+ (BUserWrapper *)getUserIfLogged;
+ (NSDictionary *)getAppVgoodThresholds;
+ (NSString *)getRestBaseUrl;
+ (NSString *)getDisplayBaseUrl;
+ (NSString *)getApiKey;
+ (NSString *)getPlayerID;
+ (NSString *)getUserID;
+ (NSString *)getUserLocationForURL;
+ (CLLocation *)getUserLocation;

+ (void)updateUserLocation;
+ (void)changeBeintooOrientation:(int)_orientation;
+ (void)eventuallyUpdateDisplayedContent;

+ (BAdWrapper *)getLastGeneratedAd;

+ (void)setLastGeneratedAd:(BAdWrapper *)wrapper;
+ (void)setBeintooPlayer:(BPlayerWrapper *)_player;
+ (void)_setUserLocation:(CLLocation *)_location;

+ (BOOL)isUserLogged;
+ (BOOL)showAchievementNotification;
+ (BOOL)showLoginNotification;
+ (BOOL)showScoreNotification;
+ (BOOL)showNoRewardNotification;
+ (BOOL)isOnSandbox;
+ (BOOL)isOnPrivateSandbox;
+ (BOOL)userHasAllowedLocationServices;
+ (BOOL)isAdReady;
+ (BOOL)isStatusBarHiddenOnApp;

+ (void)switchBeintooToSandbox;
+ (void)_privateSandbox;

#pragma mark - Notifications

+ (void)adControllerDidAppear;
+ (void)adControllerDidDisappear;
+ (void)notifyAdGenerationOnMainDelegate:(BAdWrapper *)ad;
+ (void)notifyAdGenerationErrorOnMainDelegate:(NSDictionary *)_error;

+ (void)beintooWillAppear;
+ (void)beintooDidAppear;
+ (void)beintooWillDisappear;
+ (void)beintooDidDisappear;

+ (void)notifyRewardGenerationOnMainDelegate:(BRewardWrapper *)reward;
+ (void)notifyRewardGenerationErrorOnMainDelegate:(NSDictionary *)_error;

+ (void)notifyGiveBedollarsGenerationOnMainDelegate:(BGiveBedollarsWrapper *)wrapper;
+ (void)notifyGiveBedollarsGenerationErrorOnMainDelegate:(NSDictionary *)_error;

+ (void)notifyEventGenerationOnMainDelegate:(BEventWrapper *)wrapper;
+ (void)notifyEventGenerationErrorOnMainDelegate:(NSDictionary *)_error;

+ (void)giveBedollarsControllerDidAppear;
+ (void)giveBedollarsControllerDidDisappear;

#pragma mark - Post Notifications

+ (void)postNotificationBeintooUserDidLogin;
+ (void)postNotificationBeintooUserDidSignup;

#pragma mark - Shutdown and release

+ (void)shutdownBeintoo;

@end
