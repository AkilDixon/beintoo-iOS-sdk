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

#import <UIKit/UIKit.h>
#import "BeintooPlayer.h"
#import "BeintooUser.h"

#define POPUP_DETACH	44
#define POPUP_LOGOUT	55
#define POPUP_FRIENDS	66

@class BView, BGradientView, BButton, BTableView, BeintooMessagesVC, BeintooFriendsListVC, BeintooNewMessageVC, BeintooBalanceVC,BeintooFriendActionsVC,BeintooAllianceActionsVC,BGradientView,BeintooLoginVC;

@interface BeintooProfileVC : UIViewController <UITableViewDelegate,UIActionSheetDelegate,BeintooUserDelegate,BeintooPlayerDelegate> {
	
	IBOutlet UIScrollView *scrollView;
	IBOutlet BView		 *profileView;
	IBOutlet BTableView  *scoresTable;
	IBOutlet UILabel	 *nickname;
	IBOutlet UILabel	 *beDollars;
	IBOutlet UILabel	 *level;
	IBOutlet UILabel	 *levelTitle;
    IBOutlet UILabel     *bedollarsTitle;
	IBOutlet UIImageView *userImg;
	IBOutlet UILabel	 *noScoreLabel;
	IBOutlet BButton	 *logoutButton;
	IBOutlet BButton	 *detachButton;
	IBOutlet BButton	 *newMessageButton;
    
	
	IBOutlet BGradientView *toolbarView;
	IBOutlet UILabel	   *friendsToolbarLabel;
	IBOutlet UILabel	   *balanceToolbarLabel;
	IBOutlet UILabel	   *messagesToolbarLabel;
	IBOutlet UILabel	   *unreadMessagesLabel;
    IBOutlet UILabel       *alliancesLabel;
	
	BeintooMessagesVC		*messagesVC;
	BeintooNewMessageVC		*newMessageVC;
	BeintooBalanceVC		*balanceVC;
	BeintooFriendActionsVC	*friendActionsVC;
    BeintooAllianceActionsVC *alliancesActionVC;
	
	NSMutableArray		 *listOfContests;
	NSDictionary		 *allScores;
	NSDictionary		 *startingOptions;
	BOOL				 isAFriendProfile;

	BeintooPlayer *_player;
	BeintooUser	  *_user;
		
    BOOL isAlreadyLogging;
    
	NSMutableArray *arrayWithScoresForAllContests;
	NSMutableArray *allContests;
	NSMutableArray *allScoresForContest;
	NSMutableArray *feedNameLists;
    
    BeintooLoginVC                  *loginVC;
    UINavigationController          *loginNavController;
    UIView                          *signupViewForPlayers;
}

- (IBAction)logout;
- (IBAction)detachUserFromDevice;
- (void)logoutUser;
- (IBAction)openMessages;
- (IBAction)openFriends;
- (IBAction)openBalance;
- (IBAction)openAlliances;

// If is a friend profile
- (IBAction)sendMessage;

- (NSString *)translateLevel:(NSNumber *)levelNumber;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil andOptions:(NSDictionary *)options;

@property(nonatomic,retain) NSMutableArray	*sectionScores;
@property(nonatomic,retain) NSDictionary	*allScores;
@property(nonatomic,retain) NSDictionary	*startingOptions;
@property(nonatomic,retain) NSMutableArray	*allContests;
@property(nonatomic,retain) NSMutableArray	*allScoresForContest;
@property(nonatomic,retain) NSMutableArray	*arrayWithScoresForAllContests;

@end
