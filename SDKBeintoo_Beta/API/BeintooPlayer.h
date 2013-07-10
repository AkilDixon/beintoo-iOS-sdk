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
#import "Parser.h"
#import "BeintooDevice.h"

#define LOGIN_NO_PLAYER	  2
#define LOGIN_NO_ERROR	  0

@class BeintooUser, BScore, BPlayerWrapper;

@protocol BeintooPlayerDelegate;

@interface BeintooPlayer : NSObject <BeintooParserDelegate>
{	
	id <BeintooPlayerDelegate> delegate;
    id callingDelegate;
    
	int loginError;
	Parser *parser;
	
    NSString *rest_resource;
	NSString *app_rest_resource;
}

+ (void)setPlayerDelegate:(id)_caller;
+ (void)setDelegate:(id)_delegate;
- (NSString *)restResource;

+ (void)login;

+ (void)setBalance:(int)_playerBalance forContest:(NSString *)_contest;

// ---------------------------------------------------------------------------------------

+ (void)notifyPlayerLoginSuccessWithResult:(NSDictionary *)result;
+ (void)notifyPlayerLoginErrorWithResult:(NSString *)result;
+ (void)notifySubmitScoreSuccessWithResult:(NSString *)result;
+ (void)notifySubmitScoreErrorWithResult:(NSString *)error;
+ (void)notifyPlayerGetScoreSuccessWithResult:(NSDictionary *)result;
+ (void)notifyPlayerGetScoreErrorWithResult:(NSString *)error;	
+ (void)notifyPlayerSetBalanceSuccessWithResult:(NSString *)result;
+ (void)notifyPlayerSetBalanceErrorWithResult:(NSString *)error;	

// DEPRECATED methods
+ (void)submitScore:(int)_score __attribute__((deprecated()));
+ (void)submitScore:(int)_score forContest:(NSString *)_contestName __attribute__((deprecated()));
+ (void)submitScoreAndGetRewardForScore:(int)_score andContest:(NSString *)_contestName withThreshold:(int)_threshold __attribute__((deprecated()));
+ (void)getScore __attribute__((deprecated()));

// ----------- Internal API -------------------
- (void)login;
- (void)login:(NSString *)userid;
- (NSDictionary *)blockingLogin:(NSString *)userid;
- (void)getPlayerByGUID:(NSString *)guid;
- (void)getPlayerByUserID:(NSString *)userID;
- (void)backgroundLogin:(NSString *)userid;
- (void)getAllScores __attribute__((deprecated()));

- (int)loginError;

// Notifications
+ (void)showNotificationForSubmitScore;
+ (void)showNotificationForLogin;

// Player Score Threshold methods
+ (int)getVgoodThresholdScoreForPlayerKey:(NSString *)_playerKey;
+ (void)setVgoodThresholdScoreForPlayerKey:(NSString *)_playerKey andScore:(int)_score;
+ (void)resetVgoodThresholdScoreForPlayerKey:(NSString *)_playerKey andScore:(int)_score;
+ (int)getThresholdScoreForCurrentPlayerWithContest:(NSString *)codeID;
+ (void)resetVgoodThresholdScoreForContest:(NSString *)_codeId;
    
// Offline SubmitScore handlers
+ (void)addScoreToLocallySavedScores:(NSString *)scoreValue forContest:(NSString *)codeID;
+ (void)flushLocallySavedScore;
+ (void)submitScoreForOfflineScores:(NSString *)scores;

#ifdef BEINTOO_ARC_AVAILABLE
@property(nonatomic, strong) id <BeintooPlayerDelegate> delegate;
@property(nonatomic, strong) id  callingDelegate;
@property(nonatomic, strong) Parser *parser;
#else
@property(nonatomic, assign) id <BeintooPlayerDelegate> delegate;
@property(nonatomic, assign) id  callingDelegate;
@property(nonatomic, retain) Parser *parser;
#endif

@end

@protocol BeintooPlayerDelegate <NSObject>

@optional

- (void)playerDidLoginWithResult:(NSDictionary *)result;
- (void)playerDidFailLoginWithResult:(NSString *)error;
- (void)playerDidSumbitScoreWithResult:(NSString *)result;
- (void)playerDidFailSubmitScoreWithError:(NSString *)error;
- (void)playerDidGetScoreWithResult:(NSDictionary *)result;
- (void)playerDidFailGetScoreWithError:(NSString *)error;
- (void)playerDidSetBalanceWithResult:(NSString *)result;
- (void)playerDidFailSetBalanceWithError:(NSString *)error;
- (void)playerDidBackgroundLoginWithResult:(NSDictionary *)result;
- (void)playerDidCompleteBackgroundLogin:(NSDictionary *)result;
- (void)playerDidNotCompleteBackgroundLogin;

- (void)playerDidLogin:(BeintooPlayer *)player;
- (void)player:(BeintooPlayer *)player didSubmitScorewithResult:(NSString *)result andPoints:(NSString *)points;
- (void)appDidGetTopScoreswithResult:(NSDictionary *)result;
- (void)appDidGetContestsForApp:(NSArray *)result;
- (void)didgetPlayerByUser:(NSDictionary *)result;
- (void)player:(BeintooPlayer *)player getPlayerByGUID:(NSDictionary *)result;

- (void)player:(BeintooPlayer *)player didGetAllScores:(NSDictionary *)result;

@end

