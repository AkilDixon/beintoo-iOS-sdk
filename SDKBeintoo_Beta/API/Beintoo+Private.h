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

@interface Beintoo (Private) <CLLocationManagerDelegate, BTemplateGiveBedollarsDelegate>

#pragma mark - Init methods

+ (void)setApiKey:(NSString *)_apikey andApisecret:(NSString *)_apisecret;
+ (void)createSharedBeintoo;
+ (Beintoo *)sharedInstance;

+ (BOOL)isBeintooInitialized;

+ (void)initBeintooSettings:(NSDictionary *)_settings;
+ (void)initLocallySavedScoresArray;
+ (void)initLocallySavedAchievementsArray;
+ (void)initUserAgent;

#pragma mark - Common methods

+ (void)setApplicationWindow:(UIWindow *)_window;
+ (void)setAppOrientation:(int)_appOrientation;
+ (void)setNotificationPosition:(NSInteger)position;
+ (void)setShowAchievementNotificatio:(BOOL)_value;
+ (void)setShowLoginNotification:(BOOL)_value;
+ (void)setShowScoreNotification:(BOOL)_value;
+ (void)setShowNoRewardNotification:(BOOL)_value;

#pragma mark - API Services

+ (void)initAPI;
+ (void)initPlayerService;
+ (void)initUserService;
+ (void)initAchievementsService;
+ (void)initBestoreService;
+ (void)initAppService;
+ (void)initAdService;
+ (void)initRewardService;
+ (void)initEventService;
+ (void)initMissionService;

#pragma mark - Init Controllers

+ (void)initControllers;
+ (void)initMainController;
+ (void)initMainAdController;
+ (void)initMainGbController;

#pragma mark - Production/Sandbox environments

+ (void)switchToSandbox;
+ (void)privateSandbox;

#pragma mark - Launch and Dismiss methods

+ (void)_openDashboard;
+ (void)_openBestore;
+ (void)_openSignup;
+ (void)_openMissions;
+ (void)_openView:(NSString *)view orURL:(NSString *)URL;

+ (void)_dismissView:(id)controller;

+ (void)_launchMission:(BMissionTemplate *)_mission delegate:(id<BMissionTemplateDelegate>)_delegate;   

#pragma mark - Reward methods

+ (void)_showReward:(BRewardWrapper *)reward;
+ (void)_showReward:(BRewardWrapper *)reward withDelegate:(id)_delegate;
+ (void)_hideReward:(BTemplate *)reward;

+ (void)_reward:(BTemplate *)reward launchRewardControllerWithURL:(NSString *)URL;

+ (void)_dismissRewardController;

#pragma mark - Ad methods

+ (void)_setLastAd:(BAdWrapper *)_ad;

+ (void)_showAd:(BAdWrapper *)wrapper;
+ (void)_showAd:(BAdWrapper *)wrapper withDelegate:(id<BeintooTemplateDelegate>)_delegate;
+ (void)_hideAd:(BTemplate *)template;

+ (void)_ad:(BTemplate *)template launchAdControllerWithURL:(NSString *)URL;
+ (void)_dismissAdController;

#pragma mark - Give Bedollars methods
    
+ (void)_showGiveBedollars:(BGiveBedollarsWrapper *)wrapper withDelegate:(id<BTemplateGiveBedollarsDelegate>)delegate position:(int)position;
+ (void)_hideGiveBedollars:(BTemplateGiveBedollars *)template;

+ (void)_giveBedollars:(BTemplateGiveBedollars *)template launchControllerWithURL:(NSString *)URL;
+ (void)_giveBedollarsDismissController;

#pragma mark - Custom Browser

+ (void)_launchControllerWithURL:(NSString *)URL;
+ (void)_dismissController:(id)navController;

#pragma mark - Private methods

+ (UIWindow *)getApplicationWindow;
+ (void)_setBeintooPlayer:(BPlayerWrapper *)_player;

+ (void)_playerLogout;

#pragma mark - Location management

+ (void)_updateUserLocation;

#pragma mark - StatusBar management

+ (void)manageStatusBarOnLaunch;
+ (void)manageStatusBarOnDismiss;
+ (void)_setIsStatusBarHiddenOnApp:(BOOL)_value;

#pragma mark - Notifications

+ (void)_beintooUserDidLogin;
+ (void)_beintooUserDidSignup;

+ (void)_adControllerDidAppear;
+ (void)_adControllerDidDisappear;

+ (void)_giveBedollarsControllerDidAppear;
+ (void)_giveBedollarsControllerDidDisappear;

+ (void)_beintooWillAppear;
+ (void)_beintooDidAppear;
+ (void)_beintooWillDisappear;
+ (void)_beintooDidDisappear;

@end
