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
#import "BeintooDevice.h"

// PLAYER:from 1 to 29
#define PLAYER_LOGIN_CALLER_ID                  1
#define PLAYER_SSCORE_NOCONT_CALLER_ID          2
#define PLAYER_SSCORE_CONT_CALLER_ID            3
#define PLAYER_GSCORE_ALL_CALLER_ID             4
#define PLAYER_GSCORE_CONT_CALLER_ID            5
#define PLAYER_LOGINwDELEG_CALLER_ID            6
#define PLAYER_GPLAYERBYUSER_CALLER_ID          7
#define PLAYER_GALLSCORES_CALLER_ID             8
#define PLAYER_GPLAYERBYGUID_CALLER_ID          9
#define PLAYER_GSCOREFORCONT_CALLER_ID          10
#define PLAYER_SETBALANCE_CALLER_ID             11
#define PLAYER_FORCE_SSCORE_CALLER_ID           12
#define PLAYER_SSCORE_OFFLINE_CALLER_ID         13
#define PLAYER_BACKGROUND_LOGIN_CALLER_ID       14

// USER:from 30 to 59
#define USER_GUSERBYMP_CALLER_ID                30
#define USER_GUSERBYUDID_CALLER_ID              31
#define USER_SHOWCHALLENGES_CALLER_ID           32
#define USER_CHALLENGEREQ_CALLER_ID             33
#define USER_GFRIENDS_CALLER_ID                 34
#define USER_REMOVEUDID_CALLER_ID               35
#define USER_GUSER_CALLER_ID                    36
#define USER_GETBALANCE_CALLER_ID               37
#define USER_GETBYQUERY_CALLER_ID               38
#define USER_SENDFRIENDSHIP_CALLER_ID           39
#define USER_GETFRIENDSHIP_CALLER_ID            40
#define	USER_REGISTER_CALLER_ID                 41
#define	USER_NICKUPDATE_CALLER_ID               42
#define USER_CHALLENGEPREREQ_CALLER_ID          43
#define USER_BACKGROUND_REGISTER_CALLER_ID      44
#define USER_GIVE_BEDOLLARS_CALLER_ID           45 // deprecated
#define USER_FORGOT_PASSWORD_CALLER_ID          46
#define	USER_SEND_UNFRIENDSHIP_CALLER_ID        47

// REWARD:from 60 to 79

#define REWARD_GET_CALLER_ID                    60
#define REWARD_CHECK_COVERAGE_CALLER_ID         61
#define REWARD_IS_ELIGIBLE_FOR_REWARD_CALLER_ID 62

// APP:from 90 to 99
#define APP_GTOPSCORES_CALLER_ID                90
#define APP_GCONTESTFORAPP_CALLER_ID            91
#define APP_LOG_EXCEPTION                       92

// NOTIFICATION: from 140 to 149
#define NOTIFICATION_GETLIST_CALLER_ID           140
#define NOTIFICATION_SETREAD_CALLER_ID           141

//MARKETPLACE: from 150 to 160
#define MARKETPLACE_GET_CONTENT_CALLER_ID               150
#define MARKETPLACE_GET_CATEGORY_CONTENT_CALLER_ID      151
#define MARKETPLACE_GET_CATEGORIES_CALLER_ID            152

// ACHIEVEMENTS:from 200 to 229
#define ACHIEVEMENTS_GET_CALLER_ID                                  200
#define ACHIEVEMENTS_SUBMIT_PERCENT_ID                              201
#define ACHIEVEMENTS_SUBMIT_SCORE_ID                                202
#define ACHIEVEMENTS_GETSUBMITPERCENT_CALLER_ID                     203
#define ACHIEVEMENTS_GETSUBMITSCORE_CALLER_ID                       204
#define ACHIEVEMENTS_GETINCREMENTSCORE_CALLER_ID                    205
#define ACHIEVEMENTS_GET_PRIVATE_CALLER_ID                          206
#define ACHIEVEMENTS_GETSUBMITPERCENT_CUSTOM_NOTIFICATION_CALLER_ID 207
#define ACHIEVEMENTS_SUBMIT_PERCENT_CUSTOM_NOTIFICATION_ID          208
#define ACHIEVEMENTS_BACKGROUND_ARRAY_ID                            209
#define ACHIEVEMENTS_BACKGROUND_ARRAY_OBJECTID_ID                   210
#define ACHIEVEMENTS_GET_BACKGROUND_ARRAY_ID                        211
#define ACHIEVEMENTS_GET_BACKGROUND_ARRAY_OBJECTID_ID               212
#define ACHIEVEMENTS_GET_SUBMIT_BY_OBJECTID_ID                      213
#define ACHIEVEMENTS_SUBMIT_BY_OBJECTID_ID                          214

// APPS: from 230 to 249
#define APPS_GIVE_BEDOLLARS_CALLER_ID                               230

// APPS: from 250 to 270
#define ADS_REQUEST                                                 250
#define ADS_REQUEST_AND_DISPLAY                                     251

// EVENTS: from 300 to 320

#define GET_EVENT               300

// MISSIONS: from 320 to 340

#define MISSION_INIT            320
#define MISSION_OVER            321
#define MISSION_ACCEPT          322
#define MISSION_RUNNING        323

@protocol BeintooParserDelegate;

@interface Parser : NSObject
{	
    NSMutableData	*responseData;
	NSInteger       callerID;
	id              result;
	id <BeintooParserDelegate> delegate;
}

- (void)parsePageAtUrl:(NSString *)URL withHeaders:(NSDictionary *)headers fromCaller:(int)caller;
- (void)parsePageAtUrlWithPOST:(NSString *)URL withHeaders:(NSDictionary *)headers fromCaller:(int)caller;
- (void)parsePageAtUrlWithPOST:(NSString *)URL withHeaders:(NSDictionary *)headers withHTTPBody:(NSString *)httpBody fromCaller:(int)caller;
- (id)blockerParsePageAtUrl:(NSString *)URL withHeaders:(NSDictionary *)headers;
- (NSString *)createJSONFromObject:(id)object;
- (void)retrievedWebPage:(NSMutableURLRequest *)_request;
- (void)parsingEnd:(NSDictionary *)theResult;

#ifdef BEINTOO_ARC_AVAILABLE
@property(nonatomic, strong) id <BeintooParserDelegate> delegate;
@property(nonatomic, strong) id result;
#else
@property(nonatomic, assign) id <BeintooParserDelegate> delegate;
@property(nonatomic, assign) id result;
#endif

@property(nonatomic, assign) NSInteger callerID;
@property(nonatomic, retain) NSString *webpage;

@end

@protocol BeintooParserDelegate <NSObject>
@optional
- (void)didFinishToParsewithResult:(NSDictionary *)result forCaller:(NSInteger)callerID;
@end
