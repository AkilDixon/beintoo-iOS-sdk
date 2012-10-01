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

#import "BeintooAppDelegate.h"
#import "BeintooViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "Beintoo.h"

@implementation BeintooAppDelegate

@synthesize window;
@synthesize viewController;

#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {  
    
    /* 
     * You have to pass a settings dictionary with (see example below):

     * - BeintooActiveFeatures: the list of features that you want on your dashboard
     * - BeintooApplicationWindow: the key window of the app
     * - BeintooAppOrientation: the starting app orientation
     * - BeintooAchievementNotification: 1 or 0 respectively if you want the unlock achievement notifications or not
     * - BeintooLoginNotification: 1 or 0 respectively if you want the playerLogin notification or not
     * - BeintooScoreNotification: 1 or 0 respectively if you want the submitScore notification or not
     * - BeintooNoRewardNotification: 1 if you want a notification when no reward is retrieved, 0 if not
     * - BeintooForceRegistration: 1 if you want that the user will need to register to use all the features of Beintoo. 0 if you want to show a subset of features even for unregistered users (logged in through the [BeintooPlayer login]
     * - BeintooNotificationPosition: you can choose between BeintooNotificationPositionTop or BeintooNotificationPositionBottom
     */
    
    NSArray	*beintooFeatures = [NSArray arrayWithObjects:   BFEATURE_PROFILE, 
                                                            BFEATURE_MARKETPLACE, 
                                                            BFEATURE_LEADERBOARD, 
                                                            BFEATURE_WALLET, 
                                                            BFEATURE_CHALLENGES,          
                                                            BFEATURE_ACHIEVEMENTS,
                                                            BFEATURE_TIPSANDFORUM, nil];
	

	NSDictionary *beintooSettings = [[NSDictionary alloc] initWithObjectsAndKeys:
									 beintooFeatures,   BeintooActiveFeatures,
									 window,            BeintooApplicationWindow,
                                     [NSNumber numberWithInt:1], BeintooAchievementNotification,
                                     [NSNumber numberWithInt:1], BeintooLoginNotification,
                                     [NSNumber numberWithInt:1], BeintooScoreNotification,
                                     [NSNumber numberWithInt:0], BeintooNoRewardNotification,
                                     [NSNumber numberWithInt:0], BeintooDismissAfterRegistration,
                                     [NSNumber numberWithInt:0], BeintooForceRegistration,
                                     [NSNumber numberWithInt:BeintooNotificationPositionBottom], BeintooNotificationPosition,
									 [NSNumber numberWithInt:UIInterfaceOrientationPortrait],BeintooAppOrientation,
									 nil];

	sampleDelegate = [[BeintooDelegate alloc] init];
	
	[Beintoo initWithApiKey:your_apikey_here andApiSecret:nil andBeintooSettings:beintooSettings andMainDelegate:sampleDelegate];
    
    /*
     *
     *  If your app uses Virtual Currency, and you'd like to show your users the products of 
     *  Markeplaces converted on your Virtual Currency, you first have to store your Virtual
     *  Currency name, your unique user identifier, and optionally the user's balance (in 
     *  alternative, you can store this value before launching Beintoo Dashboard or Marketplace).
     * 
     *  Use the method
     * 
     *  [Beintoo setVirtualCurrencyName:your_virtual_currency_name forUserId:your_user_ID
     *      withBalance:user's_virtual_currency_balance];
     *
     *  Or in alternative, store your Virtual Currency name and the user ID
     *
     *  [Beintoo setVirtualCurrencyName:your_virtual_currency_name forUserId:your_user_ID];
     *
     *  and wherever or whenever user's virtual currency changes, stored the new balance in Beintoo
     *  by using the method
     *
     *  [Beintoo setVirtualCurrencyBalance:user's_virtual_currency_balance];
     *
     */
    
    /*  UNCOMMENT the line below to use Beintoo in our testing environment sandbox 
	*   
    *   [Beintoo switchBeintooToSandbox];
    *   
    *   Every user registered, every submit score and all the other operations will not be shown on
    *   real environment.
    *   COMMENT or DELETE that line, to start Beintoo on real environment.
    *   Rememeber to COMMENT or DELETE that line before submitting your app in App Store.
    *
    */
    
	[beintooSettings release];
	
    //[self.window addSubview:viewController.view];
    [self.window setRootViewController:viewController];
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    /*
     Called as part of  transition from the background to the inactive state: here you can undo many of the changes made on entering the background.
     */
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}


- (void)applicationWillTerminate:(UIApplication *)application {
}

#pragma mark -
#pragma mark Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    /*
     Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
     */
}

- (void)dealloc {
    [viewController release];
	[sampleDelegate release];
    [window release];
    [super dealloc];
}


@end
