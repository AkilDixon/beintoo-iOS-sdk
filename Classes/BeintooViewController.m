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

- (IBAction)startBeintoo
{    
    /*
     *  Use 
     *  
     *  [Beintoo launchBeintoo]; 
     *  
     *  to directly launch the Dashboard
     */

    [Beintoo launchBeintoo];
}

- (IBAction)startMarketplace
{    
    /*
     *  Use 
     *
     *  [Beintoo launchBestore];
     *
     *  to directly launch the Bestore, avoiding the dashboard
     */
    
    [Beintoo launchBestore];
}

- (IBAction)playerLogin
{
	[Beintoo setPlayerDelegate:self];
    [Beintoo login];
}

- (IBAction)submitScore
{
	[Beintoo setPlayerDelegate:self];
    [Beintoo submitScore:1];
}

- (IBAction)submitScoreForContest
{
	[Beintoo setPlayerDelegate:nil];
	[Beintoo submitScore:1 forContest:@"default"]; // Here the contest name instead of "default"
}

- (IBAction)getScoreForContest
{
	[Beintoo setPlayerDelegate:self];
	[Beintoo getScore];
}

- (IBAction)getVgood
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
    [Beintoo giveBedollars:0.5 showNotification:YES withPosition:BeintooNotificationPositionTop];
}

- (IBAction)requestAd
{
    [Beintoo setAdDelegate:self];
	[Beintoo requestAndDisplayAdWithDeveloperUserGuid:nil];
}

- (IBAction)playerLogout{
	[Beintoo playerLogout];
    [self manageLocation];
}

- (IBAction)setMilan{
     
	// 45.467354,9.189377
    CLLocation *loc = [[CLLocation alloc] initWithLatitude:55.757 longitude:37.598];
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

#pragma mark -
#pragma mark Delegates

 /*
 ** Use the delegates callback to perform custom actions on your app
 ** Check the iOS Beintoo sdk documentation for more informations.
 */

// -------------- PLAYER LOGIN CALLBACKS
- (void)playerDidLoginWithResult:(NSDictionary *)result{
	NSLog(@"playerLogin result: %@", result);
    
    [self manageLocation];
}

- (void)playerDidFailLoginWithResult:(NSString *)error{
	NSLog(@"playerLogin error: %@",error);
    
}

// -------------- PLAYER LOGIN CALLBACKS
- (void)didCompleteBackgroundRegistration:(NSDictionary *)result{
    NSLog(@"Set User Callback -------> result %@", result);

}
- (void)didNotCompleteBackgroundRegistration{
    NSLog(@"Error in Set User Callback ------->");
    
}

// -------------- PLAYER SUBMITSORE CALLBACKS
- (void)playerDidSumbitScoreWithResult:(NSString *)result{
	NSLog(@"%@",result);
}
- (void)playerDidFailSubmitScoreWithError:(NSString *)error{
	NSLog(@"%@",error);
}

// -------------- PLAYER GETSCORE CALLBACKS
- (void)playerDidGetScoreWithResult:(NSDictionary *)result{
	NSLog(@"Beintoo: player getscore result: %@",result);
}

- (void)playerDidFailGetScoreWithError:(NSString *)error{
	NSLog(@"Beintoo: player getscore error: %@",error);
}

// -------------- ACHIEVEMENT SUBMIT CALLBACKS
- (void)didSubmitAchievementWithResult:(NSDictionary *)result{
	NSLog(@"Beintoo: achievement submitted with result: %@",result);
}
- (void)didFailToSubmitAchievementWithError:(NSString *)error{
	NSLog(@"Beintoo: achievement submit error: %@",error);
}

- (void)didGetAllUserAchievementsWithResult:(NSArray *)result{
    NSLog(@"Beintoo: achievement list: %@", result);
    
}

- (void)didGetAchievementStatus:(NSString *)_status andPercentage:(int)_percentage forAchievementId:(NSString *)_achievementId
{
    NSLog(@"Achieve %@ || status %@ || precentage %i", _achievementId, _status, _percentage);
}

// GIVE BEDOLLARS
- (void)didReceiveGiveBedollarsResponse:(NSDictionary *)result{
    NSLog(@"Give Bedollars response %@", result);
}

/**
 *** ADS callbacks
 **/

- (void)didBeintooGenerateAnAd:(BVirtualGood *)theAd
{
    BeintooLOG(@"Main View Controller, AD generated: %@", [theAd theGood]);
}

- (void)didBeintooFailToGenerateAnAdWithError:(NSDictionary *)error
{
    BeintooLOG(@"Main View Controller, AD generation error: %@", error);
}

/**
*** REWARD callbacks
**/

- (void)didBeintooGenerateAReward:(BVirtualGood *)theReward
{
    BeintooLOG(@"Main View Controller, Reward generated: %@", [theReward theGood]);
}

- (void)didBeintooFailToGenerateARewardWithError:(NSDictionary *)error
{
    BeintooLOG(@"Main View Controller, Reward generation error: %@", error);
}

- (void)beintooPrizeWillAppear{
    NSLog(@"Main View Controller --- Prize will Appear"); 
}

- (void)beintooPrizeDidAppear{
    NSLog(@"Main View Controller --- Prize did Appear");
}

- (void)beintooPrizeWillDisappear{
    NSLog(@"Main View Controller --- Prize will Disappear");
}

- (void)beintooPrizeDidDisappear{
    NSLog(@"Main View Controller --- Prize did Disappear");
}

- (void)beintooPrizeAlertWillAppear{
    NSLog(@"Main View Controller --- Prize alert will Appear");
}

- (void)beintooPrizeAlertDidDisappear{
    NSLog(@"Main View Controller --- Prize alert did Disappear");
}

- (void)beintooPrizeAlertWillDisappear{
    NSLog(@"Main View Controller --- Prize alert will Disappear");
}

- (void)beintooPrizeAlertDidAppear{
    NSLog(@"Main View Controller --- Prize alert did Appear");
}

- (void)userDidTapOnClosePrize{
    NSLog(@"Main View Controller --- Tapped on close Prize");
}

- (void)userDidTapOnThePrize{
    NSLog(@"Main View Controller --- Tapped on Prize");
}

- (void)buttonsCustomization{
    
    [playerLogin setHighColor:[UIColor colorWithRed:136.0/255 green:148.0/255 blue:164.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(156, 2)/pow(255,2) green:pow(168, 2)/pow(255,2) blue:pow(184, 2)/pow(255,2) alpha:1]];
	[playerLogin setMediumHighColor:[UIColor colorWithRed:106.0/255 green:125.0/255 blue:149.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(116, 2)/pow(255,2) green:pow(135, 2)/pow(255,2) blue:pow(159, 2)/pow(255,2) alpha:1]];
	[playerLogin setMediumLowColor:[UIColor colorWithRed:98.0/255 green:118.0/255 blue:144.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(108, 2)/pow(255,2) green:pow(128, 2)/pow(255,2) blue:pow(154, 2)/pow(255,2) alpha:1]];
    [playerLogin setLowColor:[UIColor colorWithRed:79.0/255 green:102.0/255 blue:132.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(89, 2)/pow(255,2) green:pow(112, 2)/pow(255,2) blue:pow(142, 2)/pow(255,2) alpha:1]];
    [playerLogin setTextSize:[NSNumber numberWithInt:14]];
    
    [logout setHighColor:[UIColor colorWithRed:136.0/255 green:148.0/255 blue:164.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(156, 2)/pow(255,2) green:pow(168, 2)/pow(255,2) blue:pow(184, 2)/pow(255,2) alpha:1]];
	[logout setMediumHighColor:[UIColor colorWithRed:106.0/255 green:125.0/255 blue:149.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(116, 2)/pow(255,2) green:pow(135, 2)/pow(255,2) blue:pow(159, 2)/pow(255,2) alpha:1]];
	[logout setMediumLowColor:[UIColor colorWithRed:98.0/255 green:118.0/255 blue:144.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(108, 2)/pow(255,2) green:pow(128, 2)/pow(255,2) blue:pow(154, 2)/pow(255,2) alpha:1]];
    [logout setLowColor:[UIColor colorWithRed:79.0/255 green:102.0/255 blue:132.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(89, 2)/pow(255,2) green:pow(112, 2)/pow(255,2) blue:pow(142, 2)/pow(255,2) alpha:1]];
    [logout setTextSize:[NSNumber numberWithInt:14]];
    
    [getVgood setHighColor:[UIColor colorWithRed:136.0/255 green:148.0/255 blue:164.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(156, 2)/pow(255,2) green:pow(168, 2)/pow(255,2) blue:pow(184, 2)/pow(255,2) alpha:1]];
	[getVgood setMediumHighColor:[UIColor colorWithRed:106.0/255 green:125.0/255 blue:149.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(116, 2)/pow(255,2) green:pow(135, 2)/pow(255,2) blue:pow(159, 2)/pow(255,2) alpha:1]];
	[getVgood setMediumLowColor:[UIColor colorWithRed:98.0/255 green:118.0/255 blue:144.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(108, 2)/pow(255,2) green:pow(128, 2)/pow(255,2) blue:pow(154, 2)/pow(255,2) alpha:1]];
    [getVgood setLowColor:[UIColor colorWithRed:79.0/255 green:102.0/255 blue:132.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(89, 2)/pow(255,2) green:pow(112, 2)/pow(255,2) blue:pow(142, 2)/pow(255,2) alpha:1]];
    [getVgood setTextSize:[NSNumber numberWithInt:14]];
    
    [submitScore setHighColor:[UIColor colorWithRed:136.0/255 green:148.0/255 blue:164.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(156, 2)/pow(255,2) green:pow(168, 2)/pow(255,2) blue:pow(184, 2)/pow(255,2) alpha:1]];
	[submitScore setMediumHighColor:[UIColor colorWithRed:106.0/255 green:125.0/255 blue:149.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(116, 2)/pow(255,2) green:pow(135, 2)/pow(255,2) blue:pow(159, 2)/pow(255,2) alpha:1]];
	[submitScore setMediumLowColor:[UIColor colorWithRed:98.0/255 green:118.0/255 blue:144.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(108, 2)/pow(255,2) green:pow(128, 2)/pow(255,2) blue:pow(154, 2)/pow(255,2) alpha:1]];
    [submitScore setLowColor:[UIColor colorWithRed:79.0/255 green:102.0/255 blue:132.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(89, 2)/pow(255,2) green:pow(112, 2)/pow(255,2) blue:pow(142, 2)/pow(255,2) alpha:1]];
    [submitScore setTextSize:[NSNumber numberWithInt:14]];
    
    [submitScoreForContest setHighColor:[UIColor colorWithRed:136.0/255 green:148.0/255 blue:164.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(156, 2)/pow(255,2) green:pow(168, 2)/pow(255,2) blue:pow(184, 2)/pow(255,2) alpha:1]];
	[submitScoreForContest setMediumHighColor:[UIColor colorWithRed:106.0/255 green:125.0/255 blue:149.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(116, 2)/pow(255,2) green:pow(135, 2)/pow(255,2) blue:pow(159, 2)/pow(255,2) alpha:1]];
	[submitScoreForContest setMediumLowColor:[UIColor colorWithRed:98.0/255 green:118.0/255 blue:144.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(108, 2)/pow(255,2) green:pow(128, 2)/pow(255,2) blue:pow(154, 2)/pow(255,2) alpha:1]];
    [submitScoreForContest setLowColor:[UIColor colorWithRed:79.0/255 green:102.0/255 blue:132.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(89, 2)/pow(255,2) green:pow(112, 2)/pow(255,2) blue:pow(142, 2)/pow(255,2) alpha:1]];
    [submitScoreForContest setTextSize:[NSNumber numberWithInt:14]];
    
    [getScoreForContest setHighColor:[UIColor colorWithRed:136.0/255 green:148.0/255 blue:164.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(156, 2)/pow(255,2) green:pow(168, 2)/pow(255,2) blue:pow(184, 2)/pow(255,2) alpha:1]];
	[getScoreForContest setMediumHighColor:[UIColor colorWithRed:106.0/255 green:125.0/255 blue:149.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(116, 2)/pow(255,2) green:pow(135, 2)/pow(255,2) blue:pow(159, 2)/pow(255,2) alpha:1]];
	[getScoreForContest setMediumLowColor:[UIColor colorWithRed:98.0/255 green:118.0/255 blue:144.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(108, 2)/pow(255,2) green:pow(128, 2)/pow(255,2) blue:pow(154, 2)/pow(255,2) alpha:1]];
    [getScoreForContest setLowColor:[UIColor colorWithRed:79.0/255 green:102.0/255 blue:132.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(89, 2)/pow(255,2) green:pow(112, 2)/pow(255,2) blue:pow(142, 2)/pow(255,2) alpha:1]];
    [getScoreForContest setTextSize:[NSNumber numberWithInt:14]];
    
    [achievements setHighColor:[UIColor colorWithRed:136.0/255 green:148.0/255 blue:164.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(156, 2)/pow(255,2) green:pow(168, 2)/pow(255,2) blue:pow(184, 2)/pow(255,2) alpha:1]];
	[achievements setMediumHighColor:[UIColor colorWithRed:106.0/255 green:125.0/255 blue:149.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(116, 2)/pow(255,2) green:pow(135, 2)/pow(255,2) blue:pow(159, 2)/pow(255,2) alpha:1]];
	[achievements setMediumLowColor:[UIColor colorWithRed:98.0/255 green:118.0/255 blue:144.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(108, 2)/pow(255,2) green:pow(128, 2)/pow(255,2) blue:pow(154, 2)/pow(255,2) alpha:1]];
    [achievements setLowColor:[UIColor colorWithRed:79.0/255 green:102.0/255 blue:132.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(89, 2)/pow(255,2) green:pow(112, 2)/pow(255,2) blue:pow(142, 2)/pow(255,2) alpha:1]];
    [achievements setTextSize:[NSNumber numberWithInt:14]];
    
    [london setHighColor:[UIColor colorWithRed:10.0/255 green:90.0/255 blue:229.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(5, 2)/pow(255,2) green:pow(45, 2)/pow(255,2) blue:pow(116, 2)/pow(255,2) alpha:1]];
	[london setMediumHighColor:[UIColor colorWithRed:8.0/255 green:72.0/255 blue:183.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(5, 2)/pow(255,2) green:pow(45, 2)/pow(255,2) blue:pow(116, 2)/pow(255,2) alpha:1]];
	[london setMediumLowColor:[UIColor colorWithRed:8.0/255 green:72.0/255 blue:183.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(5, 2)/pow(255,2) green:pow(45, 2)/pow(255,2) blue:pow(116, 2)/pow(255,2) alpha:1]];
    [london setLowColor:[UIColor colorWithRed:7.0/255 green:64.0/255 blue:163.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(5, 2)/pow(255,2) green:pow(45, 2)/pow(255,2) blue:pow(116, 2)/pow(255,2) alpha:1]];
    [london setTextSize:[NSNumber numberWithInt:14]];
    
    [milan setHighColor:[UIColor colorWithRed:10.0/255 green:90.0/255 blue:229.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(5, 2)/pow(255,2) green:pow(45, 2)/pow(255,2) blue:pow(116, 2)/pow(255,2) alpha:1]];
	[milan setMediumHighColor:[UIColor colorWithRed:8.0/255 green:72.0/255 blue:183.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(5, 2)/pow(255,2) green:pow(45, 2)/pow(255,2) blue:pow(116, 2)/pow(255,2) alpha:1]];
	[milan setMediumLowColor:[UIColor colorWithRed:8.0/255 green:72.0/255 blue:183.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(5, 2)/pow(255,2) green:pow(45, 2)/pow(255,2) blue:pow(116, 2)/pow(255,2) alpha:1]];
    [milan setLowColor:[UIColor colorWithRed:7.0/255 green:64.0/255 blue:163.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(5, 2)/pow(255,2) green:pow(45, 2)/pow(255,2) blue:pow(116, 2)/pow(255,2) alpha:1]];
    [milan setTextSize:[NSNumber numberWithInt:14]];
    
    [sanFrancisco setHighColor:[UIColor colorWithRed:10.0/255 green:90.0/255 blue:229.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(5, 2)/pow(255,2) green:pow(45, 2)/pow(255,2) blue:pow(116, 2)/pow(255,2) alpha:1]];
	[sanFrancisco setMediumHighColor:[UIColor colorWithRed:8.0/255 green:72.0/255 blue:183.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(5, 2)/pow(255,2) green:pow(45, 2)/pow(255,2) blue:pow(116, 2)/pow(255,2) alpha:1]];
	[sanFrancisco setMediumLowColor:[UIColor colorWithRed:8.0/255 green:72.0/255 blue:183.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(5, 2)/pow(255,2) green:pow(45, 2)/pow(255,2) blue:pow(116, 2)/pow(255,2) alpha:1]];
    [sanFrancisco setLowColor:[UIColor colorWithRed:7.0/255 green:64.0/255 blue:163.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(5, 2)/pow(255,2) green:pow(45, 2)/pow(255,2) blue:pow(116, 2)/pow(255,2) alpha:1]];
    [sanFrancisco setTextSize:[NSNumber numberWithInt:14]];
    
    [giveBedollars setHighColor:[UIColor colorWithRed:136.0/255 green:148.0/255 blue:164.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(156, 2)/pow(255,2) green:pow(168, 2)/pow(255,2) blue:pow(184, 2)/pow(255,2) alpha:1]];
	[giveBedollars setMediumHighColor:[UIColor colorWithRed:106.0/255 green:125.0/255 blue:149.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(116, 2)/pow(255,2) green:pow(135, 2)/pow(255,2) blue:pow(159, 2)/pow(255,2) alpha:1]];
	[giveBedollars setMediumLowColor:[UIColor colorWithRed:98.0/255 green:118.0/255 blue:144.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(108, 2)/pow(255,2) green:pow(128, 2)/pow(255,2) blue:pow(154, 2)/pow(255,2) alpha:1]];
    [giveBedollars setLowColor:[UIColor colorWithRed:79.0/255 green:102.0/255 blue:132.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(89, 2)/pow(255,2) green:pow(112, 2)/pow(255,2) blue:pow(142, 2)/pow(255,2) alpha:1]];
    [giveBedollars setTextSize:[NSNumber numberWithInt:14]];
    
    [requestAd setHighColor:[UIColor colorWithRed:136.0/255 green:148.0/255 blue:164.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(156, 2)/pow(255,2) green:pow(168, 2)/pow(255,2) blue:pow(184, 2)/pow(255,2) alpha:1]];
	[requestAd setMediumHighColor:[UIColor colorWithRed:106.0/255 green:125.0/255 blue:149.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(116, 2)/pow(255,2) green:pow(135, 2)/pow(255,2) blue:pow(159, 2)/pow(255,2) alpha:1]];
	[requestAd setMediumLowColor:[UIColor colorWithRed:98.0/255 green:118.0/255 blue:144.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(108, 2)/pow(255,2) green:pow(128, 2)/pow(255,2) blue:pow(154, 2)/pow(255,2) alpha:1]];
    [requestAd setLowColor:[UIColor colorWithRed:79.0/255 green:102.0/255 blue:132.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(89, 2)/pow(255,2) green:pow(112, 2)/pow(255,2) blue:pow(142, 2)/pow(255,2) alpha:1]];
    [requestAd setTextSize:[NSNumber numberWithInt:14]];
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
