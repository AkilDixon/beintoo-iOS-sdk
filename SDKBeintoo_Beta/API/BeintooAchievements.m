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

#import "BeintooAchievements.h"
#import "Beintoo.h"

@implementation BeintooAchievements

@synthesize delegate,parser,callingDelegate,currentAchievementID,currentPercentage,currentScore;

-(id)init {
	if (self = [super init])
	{
        parser = [[Parser alloc] init];
		parser.delegate = self;
		
		currentAchievementID = [[NSString alloc] init];
		
		rest_resource = [[NSString alloc] initWithString:[NSString stringWithFormat:@"%@/achievement/",[Beintoo getRestBaseUrl]]];
	}
    return self;
}

- (NSString *)restResource{
	return rest_resource;
}

+ (void)setAchievementDelegate:(id)_caller{
	BeintooAchievements *achievementsService    = [Beintoo beintooAchievementService];
	achievementsService.callingDelegate         = _caller;
}

#pragma mark -
#pragma mark Achievement Notification

// [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"locallySavedAchievements"];

+ (void)showNotificationForUnlockedAchievement:(NSDictionary *)_achievement{
    
	// The main delegate is not called: a notification is shown and hidden by Beintoo on top of the app window
	// After the -showAchievementNotification, an animation is triggered and on complete the view is removed
	BMessageAnimated *_notification = [[[BMessageAnimated alloc] init] autorelease];
	UIWindow *appWindow             = [Beintoo getAppWindow];
    	
	[_notification setNotificationContentForAchievement:_achievement WithWindowSize:appWindow.bounds.size];
	
	[appWindow addSubview:_notification];
	[_notification showNotification];
}

+ (void)showNotificationForUnlockedAchievement:(NSDictionary *)_achievement withMissionAchievement:(NSDictionary *)_missionAchiev{
    BMessageAnimated *_notification = [[[BMessageAnimated alloc] init] autorelease];
    UIWindow *appWindow             = [Beintoo getAppWindow];
    
    [_notification setNotificationContentForAchievement:_achievement andMissionAchievement:_missionAchiev WithWindowSize:appWindow.bounds.size];
	
	[appWindow addSubview:_notification];
	[_notification showNotification];
}

#pragma mark -
#pragma mark API

+ (void)unlockAchievement:(NSString *)_achievementID{
    [BeintooAchievements setAchievement:_achievementID withPercentage:100];
}

+ (void)setAchievement:(NSString *)_achievementID withPercentage:(int)_percentageFromZeroTo100{
	
	NSString *playerID	 = [Beintoo getPlayerID];
	BeintooAchievements *achievementsService = [Beintoo beintooAchievementService];
	
	if (playerID == nil) {
		[BeintooAchievements notifyAchievementSubmitErrorWithResult:[NSString stringWithFormat:@"Can't submit achievement %@: no player logged.",_achievementID]];
		return;
	}
	
	BOOL isTheAchievementAlreadyUlocked = [BeintooAchievements checkIfAchievementIsSavedLocally:_achievementID];
	if (isTheAchievementAlreadyUlocked) {
		[BeintooAchievements notifyAchievementSubmitErrorWithResult:[NSString stringWithFormat:@"Achievement %@ already unlocked.",_achievementID]];
		return;
	}
		
	// Before we asked for the player achievements before to submit:
	// if the user has unlocked the _achievementID achievement, then update the locally saved achievement
	// and return. Otherwise submit the achievement to the server.
	achievementsService.currentAchievementID = _achievementID;
	achievementsService.currentPercentage =_percentageFromZeroTo100;
	
	NSString *res		 = [NSString stringWithFormat:@"%@",[achievementsService restResource]];
	NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:[Beintoo getApiKey],@"apikey",playerID,@"guid",nil];
	[achievementsService.parser parsePageAtUrl:res withHeaders:params fromCaller:ACHIEVEMENTS_GETSUBMITPERCENT_CALLER_ID];	
}

+ (void)setAchievement:(NSString *)_achievementID withScore:(int)_score{
	
	NSString *playerID	 = [Beintoo getPlayerID];
	BeintooAchievements *achievementsService = [Beintoo beintooAchievementService];
	
	if (playerID == nil) {
		[BeintooAchievements notifyAchievementSubmitErrorWithResult:[NSString stringWithFormat:@"Can't submit achievement %@: no player logged.",_achievementID]];
		return;
	}
	
	BOOL isTheAchievementAlreadyUlocked = [BeintooAchievements checkIfAchievementIsSavedLocally:_achievementID];
	if (isTheAchievementAlreadyUlocked) {
		[BeintooAchievements notifyAchievementSubmitErrorWithResult:[NSString stringWithFormat:@"Achievement %@ already unlocked.",_achievementID]];
		return;
	}
		
	// Before we asked for the player achievements before to submit:
	// if the user has unlocked the _achievementID achievement, then update the locally saved achievement
	// and return. Otherwise submit the achievement to the server.
	achievementsService.currentAchievementID = _achievementID;
	achievementsService.currentScore =_score;
	
	NSString *res		 = [NSString stringWithFormat:@"%@",[achievementsService restResource]];
	NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:[Beintoo getApiKey],@"apikey",playerID,@"guid",nil];
	[achievementsService.parser parsePageAtUrl:res withHeaders:params fromCaller:ACHIEVEMENTS_GETSUBMITSCORE_CALLER_ID];	
}

+ (void)incrementAchievement:(NSString *)_achievementID withScore:(int)_score{
	NSString *playerID	 = [Beintoo getPlayerID];
	BeintooAchievements *achievementsService = [Beintoo beintooAchievementService];

	if (playerID == nil) {
		[BeintooAchievements notifyAchievementSubmitErrorWithResult:[NSString stringWithFormat:@"Can't submit achievement %@: no player logged.",_achievementID]];
		return;
	}
	
	BOOL isTheAchievementAlreadyUlocked = [BeintooAchievements checkIfAchievementIsSavedLocally:_achievementID];
	if (isTheAchievementAlreadyUlocked) {
		[BeintooAchievements notifyAchievementSubmitErrorWithResult:[NSString stringWithFormat:@"Achievement %@ already unlocked.",_achievementID]];
		return;
	}
	
	// Before we asked for the player achievements before to submit:
	// if the user has unlocked the _achievementID achievement, then update the locally saved achievement
	// and return. Otherwise submit the achievement to the server.
	achievementsService.currentAchievementID = _achievementID;
	achievementsService.currentScore =_score;
	
	NSString *res		 = [NSString stringWithFormat:@"%@",[achievementsService restResource]];
	NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:[Beintoo getApiKey],@"apikey",playerID,@"guid",nil];
	[achievementsService.parser parsePageAtUrl:res withHeaders:params fromCaller:ACHIEVEMENTS_GETINCREMENTSCORE_CALLER_ID];			
}

+ (void)notifyAchievementSubmitSuccessWithResult:(NSDictionary *)result{
	BeintooAchievements *achievementsService = [Beintoo beintooAchievementService];
	id _callingDelegate = achievementsService.callingDelegate;
	
	if ([_callingDelegate respondsToSelector:@selector(didSubmitAchievementWithResult:)]) {
		[_callingDelegate didSubmitAchievementWithResult:result];
	}	
}	

+ (void)notifyAchievementSubmitErrorWithResult:(NSString *)error{
	BeintooAchievements *achievementsService = [Beintoo beintooAchievementService];
	id _callingDelegate = achievementsService.callingDelegate;
	
	if ([_callingDelegate respondsToSelector:@selector(didFailToSubmitAchievementWithError:)]) {
		[_callingDelegate didFailToSubmitAchievementWithError:error];
	}		
}


#pragma mark -
#pragma mark internal API

- (void)getAchievementsForCurrentUser{
	NSString *playerID	 = [Beintoo getPlayerID];
	
	NSString *res		 = [NSString stringWithFormat:@"%@",rest_resource];
	NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:[Beintoo getApiKey],@"apikey",playerID,@"guid",nil];
	[parser parsePageAtUrl:res withHeaders:params fromCaller:ACHIEVEMENTS_GET_CALLER_ID];
}

#pragma mark -
#pragma mark Locally Saved Achievements

+ (void)saveUnlockedAchievementLocally:(NSDictionary *)_theAchievement{
	NSMutableArray *currentAchievemList = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"locallySavedAchievements"]];
	
	if (![BeintooAchievements checkIfAchievementIsSavedLocally:[[_theAchievement objectForKey:@"achievement"]objectForKey:@"id"]]) {
		[currentAchievemList addObject:_theAchievement];
	}
	[[NSUserDefaults standardUserDefaults] setObject:currentAchievemList forKey:@"locallySavedAchievements"];
	[[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSMutableArray *)getAllLocalAchievements{
	return [[NSUserDefaults standardUserDefaults] objectForKey:@"locallySavedAchievements"];
}

+ (BOOL)checkIfAchievementIsSavedLocally:(NSString *)_achievementID{
	NSMutableArray *currentAchievemList = [[NSUserDefaults standardUserDefaults] objectForKey:@"locallySavedAchievements"];

	for (NSDictionary *achievement in currentAchievemList) {
		if ([[[achievement objectForKey:@"achievement"]objectForKey:@"id"] isEqualToString:_achievementID]) {
			return YES;
		}
	}
	return NO;
}

+ (void)resetAllLocallyAchievementsUnlocked{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"locallySavedAchievements"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


#pragma mark -
#pragma mark Parser Delegate

- (void)didFinishToParsewithResult:(NSDictionary *)result forCaller:(NSInteger)callerID{	
	BeintooAchievements *achievementsService = [Beintoo beintooAchievementService];

	switch (callerID){
		case ACHIEVEMENTS_GET_CALLER_ID:{
						
			if ([[self delegate] respondsToSelector:@selector(didGetAllUserAchievementsWithResult:)])
				[[self delegate] didGetAllUserAchievementsWithResult:(NSArray *)result];
		}
			break;
		
		case ACHIEVEMENTS_GETSUBMITPERCENT_CALLER_ID:{
			
			if ([result respondsToSelector:@selector(objectForKey:)]) { // ERROR - notify the error to the developer
				if ([result objectForKey:@"message"]!=nil) {
					[BeintooAchievements notifyAchievementSubmitErrorWithResult:[result objectForKey:@"message"]];
				}
			}
			else{
				// ------ First step: we check if among the achievements retrieved is included the one sumbitted by the developer
				NSDictionary *alreadyExistingAchievement = nil; 

				for (NSDictionary *currentAchievement in result) {
					if ([[[currentAchievement objectForKey:@"achievement"] objectForKey:@"id"] isEqualToString:achievementsService.currentAchievementID]) {
						alreadyExistingAchievement = currentAchievement;
					}
				}	
				if (alreadyExistingAchievement != nil) { 
					// ------ Achievement to submit found on the list of achievements of the player
					NSString *status  = [alreadyExistingAchievement objectForKey:@"status"];
					
					if ([status isEqualToString:@"UNLOCKED"]) {

							// ---------- If it is already unlocked, we save it locally, notify the "error" to the developer and return
							[BeintooAchievements saveUnlockedAchievementLocally:alreadyExistingAchievement];
							[BeintooAchievements notifyAchievementSubmitErrorWithResult:[NSString stringWithFormat:@"Achievement %@ already unlocked.",achievementsService.currentAchievementID]];
							break;
					}
					else { 
						// ----------- Otherwise, if the achievement is not unlocked, we proceed to call the sumbit achievement API
						NSString *playerID	 = [Beintoo getPlayerID];
						NSString *res		 = [NSString stringWithFormat:@"%@%@",[achievementsService restResource],achievementsService.currentAchievementID];
						NSString *httpBody   = [NSString stringWithFormat:@"percentage=%d",achievementsService.currentPercentage]; 
						
						NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:[Beintoo getApiKey],@"apikey",playerID,@"guid",[BeintooDevice getUDID],@"deviceUUID",nil];
						[achievementsService.parser parsePageAtUrlWithPOST:res withHeaders:params withHTTPBody:httpBody fromCaller:ACHIEVEMENTS_SUBMIT_PERCENT_ID];
					}
				}
				else {  // --------------- Achievement not found on the user achievement list, proceeding to submit to API
					NSString *playerID	 = [Beintoo getPlayerID];
					NSString *res		 = [NSString stringWithFormat:@"%@%@",[achievementsService restResource],achievementsService.currentAchievementID];
					NSString *httpBody   = [NSString stringWithFormat:@"percentage=%d",achievementsService.currentPercentage]; 
					
					NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:[Beintoo getApiKey],@"apikey",
                                            playerID,@"guid",[BeintooDevice getUDID],@"deviceUUID",nil];
					[achievementsService.parser parsePageAtUrlWithPOST:res withHeaders:params withHTTPBody:httpBody fromCaller:ACHIEVEMENTS_SUBMIT_PERCENT_ID];
				}
			}
		}
			break;
			
		case ACHIEVEMENTS_SUBMIT_PERCENT_ID:{
			
            if ([result objectForKey:@"message"]!=nil) {  // ERROR - notify the error to the developer
                [BeintooAchievements notifyAchievementSubmitErrorWithResult:[result objectForKey:@"message"]];
            }
			else {
                
                [BeintooAchievements notifyAchievementSubmitSuccessWithResult:result];
                
                BOOL isMissionOver              = FALSE;
                BOOL isAchievemUnlocked         = FALSE;
                BOOL isAchievementOnSponsored   = FALSE;
                
                NSDictionary        *achievementToShow;
                NSDictionary        *achievementToCompleteMission;
                NSMutableArray      *playerAchievements;
                NSMutableArray      *sponsoredAchievements;
                NSMutableArray      *allUnlockedAchievements = [NSMutableArray array];;
                NSDictionary        *mission = [result objectForKey:@"mission"];
                
                if (mission) {
                    [Beintoo setLastRetrievedMission:mission];
                    playerAchievements      = [mission objectForKey:@"playerAchievements"];
                    sponsoredAchievements   = [mission objectForKey:@"sponsoredAchievements"];
                    if ([[mission objectForKey:@"status"] isEqualToString:@"OVER"]) {
                        isMissionOver = TRUE;
                    }
                }
                
                // To Show the unlock notification of the achievement ----- *** DA SISTEMARE PER ACHIEVEM A CASCATA!!
                // In questo momento ne visualizza solo uno, il primo, non a cascata
				if ([[result objectForKey:@"playerAchievements"] count]>0) {
					NSDictionary *firstAchievem = [[result objectForKey:@"playerAchievements"] objectAtIndex:0];
					
                    if ([[firstAchievem objectForKey:@"status"] isEqualToString:@"UNLOCKED"]) {
                        isAchievemUnlocked = TRUE;
                        achievementToShow  = [firstAchievem objectForKey:@"achievement"];
                        
                        // Here we check (if there is a mission) for the achievement id on the sponsoredAchievements.
                        // We need to know the name of the app and the 
                        // If the achievement is in the "sponsoredAch array", we take the name of the app of the first achievement in the 
                        // "playerAchievements array". if not, we take the name of the app of the first achievem in "sponsoredAchiev" array
                        
                        if (mission) {
                            for (NSDictionary *achiev in sponsoredAchievements) {
                                if ([[achiev objectForKey:@"id"] isEqualToString:achievementsService.currentAchievementID]) {
                                    isAchievementOnSponsored = TRUE;
                                }
                            }
                            if (isAchievementOnSponsored) {
                                achievementToCompleteMission = [playerAchievements objectAtIndex:0];
                            }else{
                                achievementToCompleteMission = [sponsoredAchievements objectAtIndex:0];
                            }
                        }
					}
				}	
                
                // To save all the achievements unlocked locally
				for (NSDictionary *currentAchievement in [result objectForKey:@"playerAchievements"]) {
					NSString *status  = [currentAchievement objectForKey:@"status"];
					
					if ([status isEqualToString:@"UNLOCKED"]) {
						// ---------- If there is an unlocked achievement on the list, we save it locally
						[BeintooAchievements saveUnlockedAchievementLocally:currentAchievement];
                        [allUnlockedAchievements addObject:currentAchievement];
						break;
					}			
				}
                
                // Next TODO ** instead of "achievementToShow" put "allUnlockedAchievements" to show 
                //                      ALL the achievements unlocked
                if (mission && !isMissionOver && isAchievemUnlocked && [Beintoo showAchievementNotification]) {
                    [BeintooAchievements showNotificationForUnlockedAchievement:achievementToShow withMissionAchievement:achievementToCompleteMission];
                    
                }
                else if (isMissionOver && [Beintoo showAchievementNotification]) {
                    [Beintoo launchMission];
                }
                else if (isAchievemUnlocked && !mission){
                    // Normal achievement complete notification
                    [BeintooAchievements showNotificationForUnlockedAchievement:achievementToShow];
                }
                
            }			

            
            /*if ([result respondsToSelector:@selector(objectForKey:)]) { // ERROR - notify the error to the developer
				if ([result objectForKey:@"message"]!=nil) {
					[BeintooAchievements notifyAchievementSubmitErrorWithResult:[result objectForKey:@"message"]];
				}
			}	
			else {
				[BeintooAchievements notifyAchievementSubmitSuccessWithResult:result];
				
				// TO Show the unlock notification of the achievement ----- *** DA SISTEMARE PER ACHIEVEM A CASCATA!!
				if ([result count]>0) {
					NSDictionary *firstAchievem = [(NSArray *)result objectAtIndex:0];
					NSDictionary *firstAchievementDict = [firstAchievem objectForKey:@"achievement"];
					if ([[firstAchievem objectForKey:@"status"] isEqualToString:@"UNLOCKED"]) {
						[BeintooAchievements showNotificationForUnlockedAchievement:firstAchievementDict];
					} 
				}				
				
				for (NSDictionary *currentAchievement in result) {
					NSString *status  = [currentAchievement objectForKey:@"status"];
					
					if ([status isEqualToString:@"UNLOCKED"]) {
						// ---------- If there is an unlocked achievement on the list, we save it locally
						[BeintooAchievements saveUnlockedAchievementLocally:currentAchievement];
						break;
					}			
				}
			}*/
		}
			break;
			
		case ACHIEVEMENTS_GETSUBMITSCORE_CALLER_ID:{	
			
			if ([result respondsToSelector:@selector(objectForKey:)]) { // ERROR - notify the error to the developer
				if ([result objectForKey:@"message"]!=nil) {
					[BeintooAchievements notifyAchievementSubmitErrorWithResult:[result objectForKey:@"message"]];
				}
			}
			else{
				// ------ First step: we check if among the achievements retrieved is included the one sumbitted by the developer
				NSDictionary *alreadyExistingAchievement = nil; 
				for (NSDictionary *currentAchievement in result) {
					if ([[[currentAchievement objectForKey:@"achievement"] objectForKey:@"id"] isEqualToString:achievementsService.currentAchievementID]) {
						alreadyExistingAchievement = currentAchievement;
					}
				}	
				if (alreadyExistingAchievement != nil) { 
					// ------ Achievement to submit found on the list of achievements of the player
					
					NSString *status  = [alreadyExistingAchievement objectForKey:@"status"];
					
					if ([status isEqualToString:@"UNLOCKED"]) {
						// ---------- If it is already unlocked, we save it locally, notify the "error" to the developer and return
						[BeintooAchievements saveUnlockedAchievementLocally:alreadyExistingAchievement];
						[BeintooAchievements notifyAchievementSubmitErrorWithResult:[NSString stringWithFormat:@"Achievement %@ already unlocked.",achievementsService.currentAchievementID]];
						break;
					}
					else { 
						// ----------- Otherwise, if the achievement is not unlocked, we proceed to call the sumbit achievement API
						NSString *playerID	 = [Beintoo getPlayerID];
						NSString *res		 = [NSString stringWithFormat:@"%@%@",[achievementsService restResource],achievementsService.currentAchievementID];
						NSString *httpBody   = [NSString stringWithFormat:@"value=%d",achievementsService.currentScore]; 
						
						NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:[Beintoo getApiKey],@"apikey",playerID,@"guid",[BeintooDevice getUDID],@"deviceUUID",nil];
						[achievementsService.parser parsePageAtUrlWithPOST:res withHeaders:params withHTTPBody:httpBody fromCaller:ACHIEVEMENTS_SUBMIT_SCORE_ID];
					}
				}
				else { // --------------- Achievement not found on the user achievement list, proceeding to submit to API
					NSString *playerID	 = [Beintoo getPlayerID];
					NSString *res		 = [NSString stringWithFormat:@"%@%@",[achievementsService restResource],achievementsService.currentAchievementID];
					NSString *httpBody   = [NSString stringWithFormat:@"value=%d",achievementsService.currentScore]; 
					
					NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:[Beintoo getApiKey],@"apikey",
                                            playerID,@"guid",[BeintooDevice getUDID],@"deviceUUID",nil];
					[achievementsService.parser parsePageAtUrlWithPOST:res withHeaders:params withHTTPBody:httpBody fromCaller:ACHIEVEMENTS_SUBMIT_SCORE_ID];
				}
			}
		}
			break;
			
		case ACHIEVEMENTS_GETINCREMENTSCORE_CALLER_ID:{	
			// INCREMENT
			if ([result respondsToSelector:@selector(objectForKey:)]) { // ERROR - notify the error to the developer
				if ([result objectForKey:@"message"]!=nil) {
					[BeintooAchievements notifyAchievementSubmitErrorWithResult:[result objectForKey:@"message"]];
				}
			}
			else{
				// ------ First step: we check if among the achievements retrieved is included the one sumbitted by the developer
				NSDictionary *alreadyExistingAchievement = nil; 
				for (NSDictionary *currentAchievement in result) {
					if ([[[currentAchievement objectForKey:@"achievement"] objectForKey:@"id"] isEqualToString:achievementsService.currentAchievementID]) {
						alreadyExistingAchievement = currentAchievement;
					}
				}	
				if (alreadyExistingAchievement != nil) { 
					// ------ Achievement to submit found on the list of achievements of the player
					NSString *status  = [alreadyExistingAchievement objectForKey:@"status"];
					
					if ([status isEqualToString:@"UNLOCKED"]) {
						// ---------- If it is already unlocked, we save it locally, notify the "error" to the developer and return
						[BeintooAchievements saveUnlockedAchievementLocally:alreadyExistingAchievement];
						[BeintooAchievements notifyAchievementSubmitErrorWithResult:[NSString stringWithFormat:@"Achievement %@ already unlocked.",achievementsService.currentAchievementID]];
						break;
					}
					else { 
						// ----------- Otherwise, if the achievement is not unlocked, we proceed to call the sumbit achievement API
						NSString *playerID	 = [Beintoo getPlayerID];
						NSString *res		 = [NSString stringWithFormat:@"%@%@",[achievementsService restResource],achievementsService.currentAchievementID];
						NSString *httpBody   = [NSString stringWithFormat:@"value=%d&increment=true",achievementsService.currentScore]; 
						
						NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:[Beintoo getApiKey],@"apikey",playerID,@"guid",[BeintooDevice getUDID],@"deviceUUID",nil];
						[achievementsService.parser parsePageAtUrlWithPOST:res withHeaders:params withHTTPBody:httpBody fromCaller:ACHIEVEMENTS_SUBMIT_SCORE_ID];
					}
				}
				else { // --------------- Achievement not found on the user achievement list, proceeding to submit to API
					NSString *playerID	 = [Beintoo getPlayerID];
					NSString *res		 = [NSString stringWithFormat:@"%@%@",[achievementsService restResource],achievementsService.currentAchievementID];
					NSString *httpBody   = [NSString stringWithFormat:@"value=%d&increment=true",achievementsService.currentScore]; 
					
					NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:[Beintoo getApiKey],@"apikey",playerID,@"guid",[BeintooDevice getUDID],@"deviceUUID",nil];
					[achievementsService.parser parsePageAtUrlWithPOST:res withHeaders:params withHTTPBody:httpBody fromCaller:ACHIEVEMENTS_SUBMIT_SCORE_ID];
				}
			}
			
		}
			break;
			
		case ACHIEVEMENTS_SUBMIT_SCORE_ID:{
            
            if ([result objectForKey:@"message"]!=nil) {  // ERROR - notify the error to the developer
                [BeintooAchievements notifyAchievementSubmitErrorWithResult:[result objectForKey:@"message"]];
            }
			else {
                
                [BeintooAchievements notifyAchievementSubmitSuccessWithResult:result];
                
                BOOL isMissionOver              = FALSE;
                BOOL isAchievemUnlocked         = FALSE;
                BOOL isAchievementOnSponsored   = FALSE;
                
                NSDictionary        *achievementToShow;
                NSDictionary        *achievementToCompleteMission;
                NSMutableArray      *playerAchievements;
                NSMutableArray      *sponsoredAchievements;
                NSMutableArray      *allUnlockedAchievements = [NSMutableArray array];;
                NSDictionary        *mission = [result objectForKey:@"mission"];
                
                if (mission) {
                    [Beintoo setLastRetrievedMission:mission];
                    playerAchievements      = [mission objectForKey:@"playerAchievements"];
                    sponsoredAchievements   = [mission objectForKey:@"sponsoredAchievements"];
                    if ([[mission objectForKey:@"status"] isEqualToString:@"OVER"]) {
                        isMissionOver = TRUE;
                    }
                }

                // To Show the unlock notification of the achievement ----- *** DA SISTEMARE PER ACHIEVEM A CASCATA!!
                // In questo momento ne visualizza solo uno, il primo, non a cascata
				if ([[result objectForKey:@"playerAchievements"] count]>0) {
					NSDictionary *firstAchievem = [[result objectForKey:@"playerAchievements"] objectAtIndex:0];
					
                    if ([[firstAchievem objectForKey:@"status"] isEqualToString:@"UNLOCKED"]) {
                        isAchievemUnlocked = TRUE;
                        achievementToShow  = [firstAchievem objectForKey:@"achievement"];

                        // Here we check (if there is a mission) for the achievement id on the sponsoredAchievements.
                        // We need to know the name of the app and the 
                        // If the achievement is in the "sponsoredAch array", we take the name of the app of the first achievement in the 
                        // "playerAchievements array". if not, we take the name of the app of the first achievem in "sponsoredAchiev" array
                        
                        if (mission) {
                            for (NSDictionary *achiev in sponsoredAchievements) {
                                if ([[achiev objectForKey:@"id"] isEqualToString:achievementsService.currentAchievementID]) {
                                    isAchievementOnSponsored = TRUE;
                                }
                            }
                            if (isAchievementOnSponsored) {
                                achievementToCompleteMission = [playerAchievements objectAtIndex:0];
                            }else{
                                achievementToCompleteMission = [sponsoredAchievements objectAtIndex:0];
                            }
                        }
					}
				}	
				                
                // To save all the achievements unlocked locally
				for (NSDictionary *currentAchievement in [result objectForKey:@"playerAchievements"]) {
					NSString *status  = [currentAchievement objectForKey:@"status"];
					
					if ([status isEqualToString:@"UNLOCKED"]) {
						// ---------- If there is an unlocked achievement on the list, we save it locally
						[BeintooAchievements saveUnlockedAchievementLocally:currentAchievement];
                        [allUnlockedAchievements addObject:currentAchievement];
						break;
					}			
				}
            
                // Next TODO ** instead of "achievementToShow" put "allUnlockedAchievements" to show 
                //                      ALL the achievements unlocked
                if (mission && !isMissionOver && isAchievemUnlocked && [Beintoo showAchievementNotification]) {
                    // DA CREARE QUESTO METODO PER 
                    [BeintooAchievements showNotificationForUnlockedAchievement:achievementToShow withMissionAchievement:achievementToCompleteMission];

                }
                else if (isMissionOver && [Beintoo showAchievementNotification]) {
                    [Beintoo launchMission];
                }
                else if (isAchievemUnlocked && !mission){
                    // Normal achievement complete notification
                    [BeintooAchievements showNotificationForUnlockedAchievement:achievementToShow];
                }
                
            }			
		}
			break;
		default:{
			//statements
		}
			break;
	}	
}

- (void)dealloc {
	[parser release];
	[rest_resource release];
	[currentAchievementID release];
	[super dealloc];
}



@end
