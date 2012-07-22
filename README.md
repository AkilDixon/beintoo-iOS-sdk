The Beintoo iOS sdk allows you to integrate Beintoo into your iPhone iOS applications.
The integration of Beintoo is extremely easy, in few steps you will be able to monetize and start engaging your users with social gaming features.

Getting Started
===============

__Integrate with an existing application__
-----------

To integrate Beintoo with an existing application, follow these steps:

1. Download the last version of the SDK from GitHub:

 	https://github.com/Beintoo/beintoo-iOS-sdk

2. Did you get your apikey? If not, register your application on Beintoo (http://www.beintoo.com/business). Simply register and create a your app from the developer dashboard to obtain your apikey.

3. Copy the entire SDKBeintoo_Beta folder inside your Xcode project. Simply drag and drop the folder into your application's project and check "Copy items into destination group's folder" when Xcode asks.
	
	 Make sure that these frameworks are included to respect the library dependencies: 
	* CoreLocation.framework
 	* QuartzCore.framework
 	* CFNetwork.framework
	* SystemConfiguration.framework
	* MapKit.framework

4. Import the BeintooApp headers in your initial viewcontroller:
 	
		#import "Beintoo.h"

5. 	Initialize the BeintooApp object. To inizialize Beintoo you need to call the init method:

		[Beintoo initWithApiKey:your_apikey andApiSecret:nil andBeintooSettings:beintooSetting andMainDelegate:sampleDelegate];

	Params:
   	- your_apikey 
   	- sampleDelegate: this is where Beintoo will send you notifications. 
   	- beintooSettings: a dictionary with your settings for Beintoo. 
		
			NSDictionary *beintooSettings = [[NSDictionary alloc] initWithObjectsAndKeys:
						     beintooFeatures,BeintooActiveFeatures,
						     window,BeintooApplicationWindow,
		                     [NSNumber numberWithInt:1],BeintooAchievementNotification,
		                     [NSNumber numberWithInt:1],BeintooLoginNotification,
		                     [NSNumber numberWithInt:1],BeintooScoreNotification,
		                     [NSNumber numberWithInt:1],BeintooNoRewardNotification,
		                     [NSNumber numberWithInt:1],BeintooDismissAfterRegistration,
		                     [NSNumber numberWithInt:0],BeintooForceRegistration,
		                     [NSNumber numberWithInt:BeintooNotificationPositionBottom], BeintooNotificationPosition,
						     [NSNumber numberWithInt:UIInterfaceOrientationPortrait],BeintooAppOrientation, nil];
  
 
 
__Important__  
If your compiler enables Automatic Reference Counting (ARC) you should turn off ARC for every file of the Beintoo SDK.
Go to your project settings, under Build Phases > Compile Sources
Select the files you want ARC disabled and add -fno-objc-arc compiler flags. You can set flags for multiple files in one shot by selecting the files then hitting “Enter” key.

Check the sample Xcode project for a lot of examples on how to use all the Beintoo features.  


API Description
===============

See our iOS SDK Documentation http://documentation.beintoo.com/home/ios-sdk for more information on the SDK methods and protocols.