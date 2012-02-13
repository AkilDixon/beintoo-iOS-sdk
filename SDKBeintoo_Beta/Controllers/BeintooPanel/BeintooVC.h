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
#import <UIKit/UIKit.h>
#import "Beintoo.h"
#import "BeintooUser.h"
#import "BeintooPlayer.h"

@class BView,BeintooNavigationController,BButton,BTableView,BeintooVgood,BeintooLoginVC,
	BeintooProfileVC,BeintooLeaderboardVC,BeintooWalletVC,BeintooChallengesVC,BeintooAchievementsVC,BeintooMessagesVC,BeintooBrowserVC,BGradientView, BeintooNotificationListVC, BeintooMarketplaceVC;

@interface BeintooVC : UIViewController <UITableViewDelegate,UITableViewDataSource,BeintooPlayerDelegate,BeintooUserDelegate> {
	    
    // --> TryBeintoo Gamefy Portrait
    IBOutlet BView          *tryBeintooPortrait;
	IBOutlet UIImageView    *tryBeintooImage;
    IBOutlet UIImageView    *tryBeintooFeaturesImage;
    IBOutlet UIView         *tryBeintooBodyView;
    IBOutlet UILabel        *descLabel1;
    IBOutlet UILabel		*titleLabel1;
    IBOutlet BButton		*button1;
	IBOutlet BButton		*button2;
    IBOutlet UILabel        *beintooUrl;
    
    // --> TryBeintoo Gamefy Landscape
    IBOutlet BView          *tryBeintooLandscape;
    IBOutlet UIImageView    *tryBeintooImageLandscape;
    IBOutlet UIImageView    *tryBeintooFeaturesImageLandscape;
    IBOutlet UIView         *tryBeintooBodyViewLandscape;
    IBOutlet UILabel        *descLabel1Landscape;
    IBOutlet UILabel		*titleLabel1Landscape;
    IBOutlet BButton		*button1Landscape;
	IBOutlet BButton		*button2Landscape;
    
    // --> TryBeintoo Monetize Portrait
    IBOutlet BView          *tryBeintooPortraitMonetize;
	IBOutlet UIImageView    *tryBeintooImageMonetize;
    IBOutlet UIImageView    *tryBeintooFeaturesImageMonetize;
    IBOutlet UIView         *tryBeintooBodyViewMonetize;
    IBOutlet UILabel        *descLabel1Monetize;
    IBOutlet UILabel		*titleLabel1Monetize;
    IBOutlet BButton		*button1Monetize;
	IBOutlet BButton		*button2Monetize;
    IBOutlet UILabel        *tryBeintooHeaderPortraitMonetize;
    IBOutlet UILabel        *beintooUrlMonetize;
    
    // --> TryBeintoo Monetize Landscape
    IBOutlet BView          *tryBeintooLandscapeMonetize;
    IBOutlet UIImageView    *tryBeintooImageLandscapeMonetize;
    IBOutlet UIImageView    *tryBeintooFeaturesImageLandscapeMonetize;
    IBOutlet UIView         *tryBeintooBodyViewLandscapeMonetize;
    IBOutlet UILabel        *titleLabel1LandscapeMonetize;
    IBOutlet UILabel		*descLabel1LandscapeMonetize;
    IBOutlet BButton		*button1LandscapeMonetize;
	IBOutlet BButton		*button2LandscapeMonetize;
    IBOutlet UILabel        *tryBeintooHeaderLandscapeMonetize;

    BView                   *tryBeintooView;
	IBOutlet BView			*homeView;
	IBOutlet UILabel		*userNick;
	IBOutlet BTableView		*homeTable;
	IBOutlet UILabel		*bedollars;
    
    // Notifications views
    IBOutlet BGradientView  *notificationView;
    IBOutlet BGradientView  *notificationLogoView;
    IBOutlet UILabel        *notificationLogoLabel;
    IBOutlet UILabel        *notificationMainLabel;
    IBOutlet BGradientView  *notificationNumbersView;
    IBOutlet UILabel        *notificationNumbersLabel;

	
	BOOL isBeintoo;
    BOOL homeTablePlayerAnimationPerformed;
    BOOL isAlreadyLogging;
    BOOL isNotificationCenterOpen;
    
    UIView                  *signupViewForPlayers;
    
	NSMutableArray			*retrievedPlayersArray;
	NSMutableArray			*featuresArray;
	UIViewController		*homeSender;
	BeintooNavigationController	*homeNavController;
	UINavigationController	*loginNavController;
    UINavigationController	*notificationNavController;

    
#ifdef UI_USER_INTERFACE_IDIOM    
	UIPopoverController		*popOverController;
	UIPopoverController		*loginPopoverController;
    UIPopoverController     *notificationPopover;
#endif
	
	BeintooPlayer               *beintooPlayer;
	BeintooUser                 *_user;
	BeintooLoginVC              *loginVC;
	BeintooProfileVC            *beintooProfileVC;
	BeintooLeaderboardVC        *beintooLeaderboardVC;
	BeintooWalletVC             *beintooWalletVC;
	BeintooChallengesVC         *beintooChallengesVC;
	BeintooAchievementsVC       *beintooAchievementsVC;
	BeintooMessagesVC           *messagesVC;
    BeintooBrowserVC            *tipsAndForumVC;
    BeintooNotificationListVC   *beintooNotificationListVC;
    BeintooMarketplaceVC        *marketplaceVC;
}

// Beintoo Initializer 
- (void)setBeintooFeatures:(NSArray *)_featuresArray;

+ (UIButton *)closeButton;
   
- (IBAction)tryBeintoo;
- (IBAction)close;

@property(nonatomic,retain) BeintooPlayer *beintooPlayer;
@property(nonatomic,retain) UINavigationController *loginNavController;
@property(nonatomic,retain) NSMutableArray *retrievedPlayersArray;
@property(nonatomic,assign) BOOL isNotificationCenterOpen;
@property(nonatomic,retain) BeintooLoginVC *loginVC;
@property(nonatomic,retain) NSMutableArray	*featuresArray;

#ifdef UI_USER_INTERFACE_IDIOM
@property(nonatomic,retain) UIPopoverController *popOverController;
@property(nonatomic,retain) UIPopoverController *loginPopoverController;
#endif

@end
