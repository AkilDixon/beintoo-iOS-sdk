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

@protocol BeintooAchievementsDelegate;

NSString *currentGlobalAchievementId;

@interface BeintooAchievements : NSObject <BeintooParserDelegate>{
	
	id <BeintooAchievementsDelegate> delegate;
	Parser *parser;
	
	id callingDelegate;
	NSString *rest_resource;
	
	// current Achievement informations
	NSString *currentAchievementID;
	int currentPercentage;
	int currentScore;
    
    
}

- (NSString *)restResource;

+ (void)unlockAchievement:(NSString *)_achievementID;
+ (void)setAchievement:(NSString *)_achievementID withPercentage:(int)_percentageFromZeroTo100;
+ (void)setAchievement:(NSString *)_achievementID withScore:(int)_score;
+ (void)incrementAchievement:(NSString *)_achievementID withScore:(int)_score;
+ (void)notifyAchievementSubmitSuccessWithResult:(NSDictionary *)result;
+ (void)notifyAchievementSubmitErrorWithResult:(NSString *)error;
+ (void)setAchievementDelegate:(id)_caller;
+ (void)getAchievementStatusAndPercentage:(NSString *)_achievementId;

+ (void)saveUnlockedAchievementLocally:(NSDictionary *)_theAchievement;
+ (NSMutableArray *)getAllLocalAchievements;
+ (BOOL)checkIfAchievementIsSavedLocally:(NSString *)_achievementID;
+ (void)resetAllLocallyAchievementsUnlocked;

// Internal API
- (void)getAchievementsForCurrentUser;

// Achievement notification
+ (void)showNotificationForUnlockedAchievement:(NSDictionary *)_achievement;
+ (void)showNotificationForUnlockedAchievement:(NSDictionary *)_achievement withMissionAchievement:(NSDictionary *)_missionAchiev;


@property(nonatomic, assign) id <BeintooAchievementsDelegate> delegate;
@property(nonatomic, assign) id  callingDelegate;
@property(nonatomic,retain) Parser *parser;
@property(nonatomic,retain) NSString *currentAchievementID;
@property(nonatomic,assign) int currentPercentage;
@property(nonatomic,assign) int currentScore;

@end

@protocol BeintooAchievementsDelegate <NSObject>

@optional
- (void)didGetAllUserAchievementsWithResult:(NSArray *)result;
- (void)didSubmitAchievementWithResult:(NSDictionary *)result;
- (void)didFailToSubmitAchievementWithError:(NSString *)error;
- (void)didGetAchievementStatus:(NSString *)_status andPercentage:(int)_percentage forAchievementId:(NSString *)_achievementId;
@end


