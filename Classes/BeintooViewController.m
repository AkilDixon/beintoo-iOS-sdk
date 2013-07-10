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

#import "BeintooViewController.h"
#import "Beintoo.h"

@implementation BeintooViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //* This is just for testing: simulate other locations where marketplace is enabled
    [Beintoo updateUserLocation];
    
    //* SampleBeintoo buttons customization
	[self buttonsCustomization];
    
    scroll.contentSize = CGSizeMake(self.view.frame.size.width, 568);
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self manageLocation];
}

- (IBAction)openDashboard
{    
    /*
     *  Use this method to launch the Dashboard of Beintoo
     */

    [Beintoo openDashboard];
}

- (IBAction)playerLogin
{
	[Beintoo setPlayerDelegate:self];
    [Beintoo login];
}

- (IBAction)getReward
{
    [Beintoo setRewardDelegate:self];
	[Beintoo getReward];
}

- (IBAction)submitAchievement
{
	[Beintoo setAchievementsDelegate:self];
	
    // These are all possible ways to submit an achievement progress
	//[Beintoo setAchievement:@"w234567" withScore:10];
	//[Beintoo setAchievement:@"w234567" withPercentage:50];
	//[Beintoo incrementAchievement:@"123456789" withScore:5];
    //[Beintoo unlockAchievementsByObjectIDInBackground:[NSArray arrayWithObjects:@"test_exist", @"share_100_times", @"sharing_top", @"share_10", nil]];
    //[Beintoo unlockAchievementByObjectID:@"test_exist" showNotification:YES];
    //[Beintoo unlockAchievementsInBackground:[NSArray arrayWithObjects:@"w234567", @"asfdgh4365768sdgdsgsd", @"35467867sadfhgs",  nil]];
    //[Beintoo unlockAchievement:@"w234567" showNotification:YES];
    
    [Beintoo unlockAchievement:@"w234567"];
}

- (IBAction)giveBedollars{
    
    /* Give Bedollars method: give bedollars to user choosing one float value between 0 and 5 values.
    ** 
    ** Choose if a notification show be shown in case of successfull callback by YES, 
    ** else choose NO
    */
    
    [Beintoo setAppDelegate:self];
    [Beintoo giveBedollars:0.5 showNotification:YES withPosition:BeintooNotificationPositionBottom];
}

- (IBAction)requestAd
{
    [Beintoo setAdDelegate:self];
	[Beintoo requestAndDisplayAdWithDeveloperUserGuid:nil];
}

- (IBAction)getEvent
{
    [BeintooEvent setDelegate:self];
    [BeintooEvent getEventWithAmountOfBedollars:1 score:100 code:@"test"];
}

- (IBAction)playerLogout{
	[Beintoo playerLogout];
    [self manageLocation];
}

#pragma mark - Locations Button

- (IBAction)setMilan{
     
	// 45.467354,9.189377
    CLLocation *loc = [[CLLocation alloc] initWithLatitude:45.467354 longitude:9.189377];
    [Beintoo _setUserLocation:loc];
    
    [self manageLocation];
}

- (IBAction)setNewYork{
	// 40.719681,-73.997726
	CLLocation *loc = [[CLLocation alloc] initWithLatitude:40.719681 longitude:-73.997726];
    [Beintoo _setUserLocation:loc];
    
    [self manageLocation];
}
- (IBAction)setLondon{
	// 51.4925,-0.105057
    CLLocation *loc = [[CLLocation alloc] initWithLatitude:51.4925 longitude:-0.105057];
    
	//CLLocation *loc = [[CLLocation alloc] initWithLatitude:51.492500 longitude:-0.105057];
    [Beintoo _setUserLocation:loc];
    
    [self manageLocation];    
}

- (IBAction)setSanFrancisco{
	// 37.771258,-122.417564
	CLLocation *loc = [[CLLocation alloc] initWithLatitude:37.771258 longitude:-122.417564];
    [Beintoo _setUserLocation:loc];
    
    [self manageLocation];
}

#pragma mark - Delegates

 /*
 ** Use the delegates callback to perform custom actions on your app
 ** Check the iOS Beintoo sdk documentation for more informations.
 */

// -------------- PLAYER LOGIN CALLBACKS
- (void)playerDidLoginWithResult:(NSDictionary *)result{
	NSLog(@"Controller Delegate: playerLogin result: %@", result);
    
    [self manageLocation];
}

- (void)playerDidFailLoginWithResult:(NSString *)error{
	NSLog(@"Controller Delegate: playerLogin error: %@",error);
    
}

// -------------- PLAYER LOGIN CALLBACKS
- (void)didCompleteBackgroundRegistration:(NSDictionary *)result{
    NSLog(@"Controller Delegate: Set User Callback -------> result %@", result);

}
- (void)didNotCompleteBackgroundRegistration{
    NSLog(@"Controller Delegate: Error in Set User Callback ------->");
    
}

// -------------- PLAYER SUBMITSORE CALLBACKS
- (void)playerDidSumbitScoreWithResult:(NSString *)result{
	NSLog(@"Controller Delegate: %@",result);
}
- (void)playerDidFailSubmitScoreWithError:(NSString *)error{
	NSLog(@"Controller Delegate: %@",error);
}

// -------------- PLAYER GETSCORE CALLBACKS
- (void)playerDidGetScoreWithResult:(NSDictionary *)result{
	NSLog(@"Beintoo: player getscore result: %@",result);
}

- (void)playerDidFailGetScoreWithError:(NSString *)error{
	NSLog(@"Controller Delegate: Beintoo: player getscore error: %@",error);
}

// -------------- ACHIEVEMENT SUBMIT CALLBACKS
- (void)didSubmitAchievementWithResult:(NSDictionary *)result{
	NSLog(@"Controller Delegate: Beintoo: achievement submitted with result: %@",result);
}
- (void)didFailToSubmitAchievementWithError:(NSString *)error{
	NSLog(@"Controller Delegate: Beintoo: achievement submit error: %@",error);
}

- (void)didGetAllUserAchievementsWithResult:(NSArray *)result{
    NSLog(@"Controller Delegate: Beintoo: achievement list: %@", result);
}

- (void)didGetAchievementStatus:(NSString *)_status andPercentage:(int)_percentage forAchievementId:(NSString *)_achievementId
{
    NSLog(@"Controller Delegate: Achieve %@ || status %@ || precentage %i", _achievementId, _status, _percentage);
}

/**
*** Give Bedollars callbacks
**/

- (void)didReceiveGiveBedollarsResponse:(BGiveBedollarsWrapper *)wrapper
{
    NSLog(@"Controller Delegate: Give Bedollars response %@", [wrapper dictionaryFromSelf]);
}

- (void)didFailToPerformGiveBedollars:(NSDictionary *)error
{
    NSLog(@"Controller Delegate: failed to retrieve Give Bedollars %@", error);
}

/**
 *** ADS callbacks
 **/

- (void)didBeintooGenerateAnAd:(BAdWrapper *)wrapper
{
    BeintooLOG(@"Main View Controller, AD generated: %@", [wrapper dictionaryFromSelf]);
}

- (void)didBeintooFailToGenerateAnAdWithError:(NSDictionary *)error
{
    BeintooLOG(@"Main View Controller, AD generation error: %@", error);
}

/**
*** REWARD callbacks
**/

- (void)didBeintooGenerateAReward:(BRewardWrapper *)reward
{
    BeintooLOG(@"Controller Delegate:  Reward generated: %@", [reward dictionaryFromSelf]);
}

- (void)didBeintooFailToGenerateARewardWithError:(NSDictionary *)error
{
    BeintooLOG(@"Controller Delegate:  Reward generation error: %@", error);
}

- (void)beintooRewardWillAppear{
    NSLog(@"Controller Delegate:  Reward will Appear"); 
}

- (void)beintooRewardDidAppear{
    NSLog(@"Controller Delegate:  Reward did Appear");
}

- (void)beintooRewardWillDisappear{
    NSLog(@"Controller Delegate:  Reward will Disappear");
}

- (void)beintooRewardDidDisappear{
    NSLog(@"Controller Delegate:  Reward did Disappear");
}

- (void)beintooRewardControllerWillAppear{
    NSLog(@"Controller Delegate:  RewardController will Appear");
}

- (void)beintooRewardControllerDidDisappear{
    NSLog(@"Controller Delegate:  RewardController did Disappear");
}

- (void)beintooRewardControllerWillDisappear{
    NSLog(@"Controller Delegate:  RewardController will Disappear");
}

- (void)beintooRewardControllerDidAppear{
    NSLog(@"Controller Delegate:  RewardController did Appear");
}

- (void)beintooRewardHasBeenClosed{
    NSLog(@"Controller Delegate: beintooRewardHasBeenClosed");
}

- (void)beintooRewardHasBeenTapped{
    NSLog(@"Controller Delegate: beintooRewardHasBeenTapped");
}

- (void)beintooAdWillAppear{
    NSLog(@"Controller Delegate: Ad will Appear");
}

- (void)beintooAdDidAppear{
    NSLog(@"Controller Delegate: Ad did Appear");
}

- (void)beintooAdWillDisappear{
    NSLog(@"Controller Delegate: Ad will Disappear");
}

- (void)beintooAdDidDisappear{
    NSLog(@"Controller Delegate: Ad did Disappear");
}

- (void)beintooAdControllerWillAppear{
    NSLog(@"Controller Delegate: AdController will Appear");
}

- (void)beintooAdControllerDidDisappear{
    NSLog(@"Controller Delegate: AdController did Disappear");
}

- (void)beintooAdControllerWillDisappear{
    NSLog(@"Controller Delegate: AdController will Disappear");
}

- (void)beintooAdControllerDidAppear{
    NSLog(@"Controller Delegate: AdController did Appear");
}

- (void)beintooAdHasBeenClosed{
    NSLog(@"Controller Delegate: Tapped on close the ad");
}

- (void)beintooAdHasBeenTapped{
    NSLog(@"Controller Delegate: Tapped on the ad");
}

#pragma mark - Events delegates

- (void)didGenerateAnEvent:(BEventWrapper *)wrapper
{
    NSLog(@"Controller Delegate: an event has been generated, %@", [wrapper dictionaryFromSelf]);
}

- (void)didFailToGenerateAnEvent:(NSDictionary *)error
{
    NSLog(@"Controller Delegate: failed to generate an event, %@", error);
}

- (void)setButtonsCustomization:(BButton *)button
{
    [button setHighColor:[UIColor colorWithRed:136.0/255 green:148.0/255 blue:164.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(156, 2)/pow(255,2) green:pow(168, 2)/pow(255,2) blue:pow(184, 2)/pow(255,2) alpha:1]];
	[button setMediumHighColor:[UIColor colorWithRed:106.0/255 green:125.0/255 blue:149.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(116, 2)/pow(255,2) green:pow(135, 2)/pow(255,2) blue:pow(159, 2)/pow(255,2) alpha:1]];
	[button setMediumLowColor:[UIColor colorWithRed:98.0/255 green:118.0/255 blue:144.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(108, 2)/pow(255,2) green:pow(128, 2)/pow(255,2) blue:pow(154, 2)/pow(255,2) alpha:1]];
    [button setLowColor:[UIColor colorWithRed:79.0/255 green:102.0/255 blue:132.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(89, 2)/pow(255,2) green:pow(112, 2)/pow(255,2) blue:pow(142, 2)/pow(255,2) alpha:1]];
    [button setTextSize:[NSNumber numberWithInt:14]];
}

- (void)setButtonLocationsCustomization:(BButton *)button
{
    [button setHighColor:[UIColor colorWithRed:10.0/255 green:90.0/255 blue:229.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(5, 2)/pow(255,2) green:pow(45, 2)/pow(255,2) blue:pow(116, 2)/pow(255,2) alpha:1]];
	[button setMediumHighColor:[UIColor colorWithRed:8.0/255 green:72.0/255 blue:183.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(5, 2)/pow(255,2) green:pow(45, 2)/pow(255,2) blue:pow(116, 2)/pow(255,2) alpha:1]];
	[button setMediumLowColor:[UIColor colorWithRed:8.0/255 green:72.0/255 blue:183.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(5, 2)/pow(255,2) green:pow(45, 2)/pow(255,2) blue:pow(116, 2)/pow(255,2) alpha:1]];
    [button setLowColor:[UIColor colorWithRed:7.0/255 green:64.0/255 blue:163.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(5, 2)/pow(255,2) green:pow(45, 2)/pow(255,2) blue:pow(116, 2)/pow(255,2) alpha:1]];
    [button setTextSize:[NSNumber numberWithInt:13]];
}

- (void)buttonsCustomization
{    
    [self setButtonsCustomization:playerLoginButton];
    [self setButtonsCustomization:logoutButton];
    [self setButtonsCustomization:giveBedollarsButton];
    [self setButtonsCustomization:requestAdButton];
    [self setButtonsCustomization:rewardButton];
    [self setButtonsCustomization:achievementButton];
    [self setButtonsCustomization:getEventButton];
    
    [self setButtonLocationsCustomization:london];
    [self setButtonLocationsCustomization:milan];
    [self setButtonLocationsCustomization:sanFrancisco];
}

- (void)manageLocation{
    
    if ([Beintoo getUserLocation]){
        
        if ([Beintoo getUserLocation].coordinate.latitude == 45.467354 && [Beintoo getUserLocation].coordinate.longitude == 9.189377){
            
            //Milan
            NSLog(@"Location updated to: Milan");
            [lightLondon            setBackgroundColor:[UIColor redColor]];
            [lightSanFrancisco      setBackgroundColor:[UIColor redColor]];
            [lightMilan             setBackgroundColor:[UIColor greenColor]];
            
            return;
        }
        else if ([Beintoo getUserLocation].coordinate.latitude == 51.492500 && [Beintoo getUserLocation].coordinate.longitude == -0.105057){
            
            //London
            NSLog(@"Location updated to: London");
            [lightLondon            setBackgroundColor:[UIColor greenColor]];
            [lightSanFrancisco      setBackgroundColor:[UIColor redColor]];
            [lightMilan             setBackgroundColor:[UIColor redColor]];
            
            return;
        }
        else if ([Beintoo getUserLocation].coordinate.latitude == 37.771258 && [Beintoo getUserLocation].coordinate.longitude == -122.417564){
            
            //San Francesco
            NSLog(@"Location updated to: San Francesco");
            [lightLondon            setBackgroundColor:[UIColor redColor]];
            [lightSanFrancisco      setBackgroundColor:[UIColor greenColor]];
            [lightMilan             setBackgroundColor:[UIColor redColor]];
            
            return;
        }
    }

    [lightLondon            setBackgroundColor:[UIColor redColor]];
    [lightSanFrancisco      setBackgroundColor:[UIColor redColor]];
    [lightMilan             setBackgroundColor:[UIColor redColor]];
}

// ------------------------------------------
//  Update the Orientation of Beintoo here
// ------------------------------------------

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= BEINTOO_IOS_6_0
- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAll;
}

- (BOOL)shouldAutorotate
{
    [Beintoo changeBeintooOrientation:self.interfaceOrientation];
    return YES;
}
#endif

#if __IPHONE_OS_VERSION_MIN_REQUIRED < BEINTOO_IOS_6_0
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation{
    [Beintoo changeBeintooOrientation:toInterfaceOrientation];
    return YES;
}
#endif

@end
