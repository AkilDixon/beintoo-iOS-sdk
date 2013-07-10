/*******************************************************************************
 * Copyright 2012 Beintoo
 * Author Giuseppe Piazzese (gpiazzese@beintoo.com)
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

#import "BeintooReward.h"
#import "Beintoo.h"

@implementation BeintooReward

@synthesize delegate, parser;

- (id)init
{
	if (self = [super init])
	{
        [self initElements];
    }
    return self;
}

- (id)initWithDelegate:(id)_delegate
{
	if (self = [super init])
	{
        [self initElements];
        [self setDelegate:_delegate];
    }
    return self;
}

- (void)initElements
{
    parser = [[Parser alloc] init];
    parser.delegate = self;
    
    rest_resource = [[NSString alloc] initWithString:[NSString stringWithFormat:@"%@/vgood/",[Beintoo getRestBaseUrl]]];
}

- (NSString *)restResource
{
	return rest_resource;
}

+ (void)setDelegate:(id)_delegate
{
	BeintooReward *service   = [Beintoo beintooRewardService];
	service.delegate = _delegate;
}

#pragma mark - Reward Notification

+ (void)showNotificationForNothingToDispatch
{
	// The main delegate is not called: a notification is shown and hidden by Beintoo on top of the app window
	// After the -showAchievementNotification, an animation is triggered and on complete the view is removed
    
#ifdef BEINTOO_ARC_AVAILABLE
    BMessageAnimated *_notification = [[BMessageAnimated alloc] init];
#else
    BMessageAnimated *_notification = [[[BMessageAnimated alloc] init] autorelease];
#endif
	
    UIWindow *appWindow = [Beintoo getAppWindow];
	
	[_notification setNotificationContentForNothingToDispatchWithWindowSize:appWindow.bounds.size];
	
	[appWindow addSubview:_notification];
	[_notification showNotification];
}

#pragma mark - Check for the availability of rewards

+ (void)checkRewardsCoverage
{
    [Beintoo updateUserLocation];
	CLLocation *loc	 = [Beintoo getUserLocation];
	
	NSString *res;
	BeintooReward *service = [Beintoo beintooRewardService];
    
	if (loc == nil || (loc.coordinate.latitude <= 0.01f && loc.coordinate.latitude >= -0.01f)
		|| (loc.coordinate.longitude <= 0.01f && loc.coordinate.longitude >= -0.01f)) {
		res = [NSString stringWithFormat:@"%@coverage", [service restResource]];
	}
	else
		res	= [NSString stringWithFormat:@"%@coverage?latitude=%f&longitude=%f&radius=%f",
               [service restResource], loc.coordinate.latitude, loc.coordinate.longitude, loc.horizontalAccuracy];
	
	NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            [Beintoo getApiKey], @"apikey",
                            [BeintooDevice getUDID], @"deviceUUID",
                            nil];
	[service.parser parsePageAtUrl:res withHeaders:params fromCaller:REWARD_CHECK_COVERAGE_CALLER_ID];
}

+ (void)isEligibleForReward
{
    if ([Beintoo getPlayerID] == nil){
        BeintooLOG(@"Is Eligible For Reward needs a Player ID, retry.");
        return;
    }
    
    [Beintoo updateUserLocation];
    
    BeintooReward *service = [Beintoo beintooRewardService];
    
    NSString *res;
    res = [NSString stringWithFormat:@"%@iseligible/byguid/%@", [service restResource], [Beintoo getPlayerID]];
    
    CLLocation *loc	 = [Beintoo getUserLocation];
	if (loc == nil || (loc.coordinate.latitude <= 0.01f && loc.coordinate.latitude >= -0.01f)
		|| (loc.coordinate.longitude <= 0.01f && loc.coordinate.longitude >= -0.01f)) {
		res	= [NSString stringWithFormat:@"%@?allowBanner=true&rows=1",  res];
	}
	else
		res	= [NSString stringWithFormat:@"%@?latitude=%f&longitude=%f&radius=%f&allowBanner=true&rows=1",
               res, loc.coordinate.latitude, loc.coordinate.longitude, loc.horizontalAccuracy];
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            [Beintoo getApiKey], @"apikey",
                            [BeintooDevice getUDID], @"deviceUUID",
                            nil];
    
    [service.parser parsePageAtUrl:res withHeaders:params fromCaller:REWARD_IS_ELIGIBLE_FOR_REWARD_CALLER_ID];
}

#pragma mark - Get Reward

+ (void)getReward
{
    [Beintoo updateUserLocation];
    
	NSString *guid = [Beintoo getPlayerID];
	CLLocation *loc	 = [Beintoo getUserLocation];
	
	if (guid == nil) {
		BeintooLOG(@"Beintoo: unable to generate a Reward. No player found.");
		return;
	}
	
	NSString *res;
	BeintooReward *service = [Beintoo beintooRewardService];
    
	if (loc == nil || (loc.coordinate.latitude <= 0.01f && loc.coordinate.latitude >= -0.01f)
		|| (loc.coordinate.longitude <= 0.01f && loc.coordinate.longitude >= -0.01f)) {
		res = [NSString stringWithFormat:@"%@byguid/%@?allowBanner=true&rows=1",[service restResource],guid];
	}
	else
		res	= [NSString stringWithFormat:@"%@byguid/%@?latitude=%f&longitude=%f&radius=%f&allowBanner=true&rows=1",
               [service restResource], guid, loc.coordinate.latitude,loc.coordinate.longitude,loc.horizontalAccuracy];
	
	NSDictionary *params;
    
    if ([BeintooDevice isASIdentifierSupported]){
        params  = [NSDictionary dictionaryWithObjectsAndKeys:
                   [Beintoo getApiKey], @"apikey",
                   [BeintooDevice getASIdentifier], @"iosaid",
                   [BeintooDevice isASIdentifierEnabledByUser], @"iosate",
                   nil];
    }
    else {
        params  = [NSDictionary dictionaryWithObjectsAndKeys:
                   [Beintoo getApiKey], @"apikey",
                   nil];
    }
    
    [service.parser parsePageAtUrl:res withHeaders:params fromCaller:REWARD_GET_CALLER_ID];
}

+ (void)getRewardWithDelegate:(id)_delegate
{
	NSString *guid = [Beintoo getPlayerID];
	
    if (guid == nil) {
		BeintooLOG(@"Beintoo: unable to generate a Reward. No player found.");
		return;
	}
    
    BeintooReward *service = [Beintoo beintooRewardService];
	service.delegate = _delegate;
	
    [self getReward];
}

+ (void)getRewardWithContest:(NSString *)contestID
{
    NSString *guid = [Beintoo getPlayerID];
	CLLocation *loc	 = [Beintoo getUserLocation];
	
	if (guid == nil) {
		BeintooLOG(@"Beintoo: unable to generate a Reward. No player found.");
		return;
	}
	
	NSString *res;
	BeintooReward *service = [Beintoo beintooRewardService];
    
	if (loc == nil || (loc.coordinate.latitude <= 0.01f && loc.coordinate.latitude >= -0.01f)
		|| (loc.coordinate.longitude <= 0.01f && loc.coordinate.longitude >= -0.01f)) {
		res = [NSString stringWithFormat:@"%@byguid/%@?allowBanner=true&rows=1",[service restResource],guid];
	}
	else
		res	= [NSString stringWithFormat:@"%@byguid/%@?latitude=%f&longitude=%f&radius=%f&allowBanner=true&rows=1",
               [service restResource],guid,loc.coordinate.latitude,loc.coordinate.longitude,loc.horizontalAccuracy];
	
    NSDictionary *params;
    if (!contestID) {
        
        if ([BeintooDevice isASIdentifierSupported]){
            params  = [NSDictionary dictionaryWithObjectsAndKeys:
                       [Beintoo getApiKey], @"apikey",
                       [BeintooDevice getASIdentifier], @"iosaid",
                       [BeintooDevice isASIdentifierEnabledByUser], @"iosate",
                       nil];
        }
        else {
            params  = [NSDictionary dictionaryWithObjectsAndKeys:
                       [Beintoo getApiKey], @"apikey",
                       nil];
        }
        
        BeintooLOG(@"Warning: you called getReward with a contestID, but the constestID you have provided is nil");
    }
    else{
        
        if ([BeintooDevice isASIdentifierSupported]){
            params  = [NSDictionary dictionaryWithObjectsAndKeys:
                       [Beintoo getApiKey], @"apikey",
                       contestID,@"codeID",
                       [BeintooDevice getASIdentifier], @"iosaid",
                       [BeintooDevice isASIdentifierEnabledByUser], @"iosate",
                       nil];
        }
        else {
            params  = [NSDictionary dictionaryWithObjectsAndKeys:
                       [Beintoo getApiKey], @"apikey",
                       contestID,@"codeID",
                       nil];
        }
    }
    
	[service.parser parsePageAtUrl:res withHeaders:params fromCaller:REWARD_GET_CALLER_ID];
}

#pragma mark - Reward notification delegates

+ (void)notifyRewardGeneration:(BRewardWrapper *)reward;
{
	[self notifyRewardGenerationOnUserDelegate:reward];
    [self notifyRewardGenerationOnMainDelegate:reward];
}

+ (void)notifyRewardGenerationError:(NSDictionary *)_error
{
	[self notifyRewardGenerationErrorOnUserDelegate:_error];
    [self notifyRewardGenerationErrorOnMainDelegate:_error];
}

+ (void)notifyRewardGenerationOnMainDelegate:(BRewardWrapper *)reward;
{
	[Beintoo notifyRewardGenerationOnMainDelegate:reward];
}

+ (void)notifyRewardGenerationErrorOnMainDelegate:(NSDictionary *)_error
{
	[Beintoo notifyRewardGenerationErrorOnMainDelegate:_error];
}

+ (void)notifyRewardGenerationOnUserDelegate:(BRewardWrapper *)reward;
{
	BeintooReward *service = [Beintoo beintooRewardService];
	id _delegate = service.delegate;
    
    if ([_delegate respondsToSelector:@selector(didBeintooGenerateAReward:)]) {
		[_delegate didBeintooGenerateAReward:reward];
	}
}

+ (void)notifyRewardGenerationErrorOnUserDelegate:(NSDictionary *)_error
{
	BeintooReward *service = [Beintoo beintooRewardService];
	id _delegate = service.delegate;
    
	if ([_delegate respondsToSelector:@selector(didBeintooFailToGenerateARewardWithError:)]) {
		[_delegate didBeintooFailToGenerateARewardWithError:_error];
	}
}

#pragma mark - Parser delegate

- (void)didFinishToParsewithResult:(NSDictionary *)result forCaller:(NSInteger)callerID
{
    switch (callerID){
            
        case REWARD_CHECK_COVERAGE_CALLER_ID:
        {
            BeintooReward *beintooReward = [Beintoo beintooRewardService];
            if ([result objectForKey:@"isCovered"]){
                
                if ([[result objectForKey:@"isCovered"] boolValue] == TRUE){
                    
                    if ([beintooReward.delegate respondsToSelector:@selector(beintooHasRewardsCoverage)]){
                        [beintooReward.delegate beintooHasRewardsCoverage];
                    }
                    return;
                }
            }
            
            if ([beintooReward.delegate respondsToSelector:@selector(beintooHasNotRewardsCoverage)])
                [beintooReward.delegate beintooHasNotRewardsCoverage];
            
        }
            break;
            
        case REWARD_IS_ELIGIBLE_FOR_REWARD_CALLER_ID:
        {
            BeintooReward *beintooReward = [Beintoo beintooRewardService];
            
            if ([result objectForKey:@"messageID"]){
                if ([[result objectForKey:@"messageID"] intValue] == 0){
                    
                    if ([beintooReward.delegate respondsToSelector:@selector(beintooPlayerIsEligibleForReward)]){
                        [beintooReward.delegate beintooPlayerIsEligibleForReward];
                    }
                    return;
                }
                else if ([[result objectForKey:@"messageID"] intValue] == B_USER_OVER_QUOTA_ERRORCODE){
                    
                    if ([beintooReward.delegate respondsToSelector:@selector(beintooPlayerIsNotEligibleForReward)]){
                        [beintooReward.delegate beintooPlayerIsNotEligibleForReward];
                    }
                    
                    if ([beintooReward.delegate respondsToSelector:@selector(beintooPlayerIsOverQuotaForReward)]){
                        [beintooReward.delegate beintooPlayerIsOverQuotaForReward];
                    }
                    return;
                }
                else if ([[result objectForKey:@"messageID"] intValue] == B_NOTHING_TO_DISPATCH_ERRORCODE || [[result objectForKey:@"messageID"] intValue] == -21){
                    
                    if ([beintooReward.delegate respondsToSelector:@selector(beintooPlayerIsNotEligibleForReward)]){
                        [beintooReward.delegate beintooPlayerIsNotEligibleForReward];
                    }
                    
                    if ([beintooReward.delegate respondsToSelector:@selector(beintooPlayerGotNothingToDispatchForReward)]){
                        [beintooReward.delegate beintooPlayerGotNothingToDispatchForReward];
                    }
                    return;
                }
            }
            
            if ([beintooReward.delegate respondsToSelector:@selector(beintooPlayerIsNotEligibleForReward)]){
                [beintooReward.delegate beintooPlayerIsNotEligibleForReward];
            }
            
        }
            break;
            
        case REWARD_GET_CALLER_ID:{  // -------------------- SINGLE NO DELEGATE
			@try {
                if ([result objectForKey:@"messageID"]) {
					// No vgood is generated. a notification is sent to the main delegate
					[BeintooReward notifyRewardGenerationError:result];
                    
                    if ([Beintoo showNoRewardNotification]) {
                        if (([[result objectForKey:@"messageID"] intValue] == B_NOTHING_TO_DISPATCH_ERRORCODE) ||
                            ([[result objectForKey:@"messageID"] intValue] == B_USER_OVER_QUOTA_ERRORCODE) ) {
                            [BeintooReward showNotificationForNothingToDispatch];
                        }
                    }
					return;
                }
				
                NSArray *vgoodList = [result objectForKey:@"vgoods"];
                
				if (vgoodList == nil || [vgoodList count] < 1) {
                    [BeintooReward notifyRewardGenerationError:result];
                    
                    if ([Beintoo showNoRewardNotification]) {
                        if (([[result objectForKey:@"messageID"] intValue] == B_NOTHING_TO_DISPATCH_ERRORCODE) ||
                            ([[result objectForKey:@"messageID"] intValue] == B_USER_OVER_QUOTA_ERRORCODE) ) {
                            [BeintooReward showNotificationForNothingToDispatch];
                        }
                    }
					return;
				}
                
                BRewardWrapper *reward = [[BRewardWrapper alloc] initWithContentOfDictionary:[vgoodList objectAtIndex:0]];
                
                [BeintooReward notifyRewardGeneration:reward];
                
                [Beintoo showReward:reward withDelegate:delegate];
                
#ifdef BEINTOO_ARC_AVAILABLE
#else
                [reward release];
#endif
            
            }
			@catch (NSException * e) {
			}
		}
			break;
			
		default:{
    
		}
			break;
	}
}

- (void)dealloc
{
    parser.delegate = nil;
    
#ifdef BEINTOO_ARC_AVAILABLE
#else
	[parser release];
	[rest_resource release];
    
	[super dealloc];
#endif
    
}

@end
