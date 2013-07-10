/*******************************************************************************
 * Copyright 2013 Beintoo - author gpiazzese@beintoo.com
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

#import "BeintooMission.h"
#import "Beintoo.h"
#import "BMissionWrapper.h"

NSString *NSUDMissionStoredArray = @"BeintooNSUDMissionStoredArray";

@implementation BeintooMission
@synthesize callingDelegate, delegate, parser;

- (id)init
{
	if (self = [super init])
	{
        parser = [[Parser alloc] init];
		parser.delegate = self;
        
		rest_resource = [[NSString alloc] initWithString:[NSString stringWithFormat:@"%@/mission", [Beintoo getRestBaseUrl]]];
	}
    return self;
}

- (id)initWithDelegate:(id)_delegate
{
    id instance = [self init];
    delegate = _delegate;
    
    return instance;
}

- (NSString *)restResource
{
	return rest_resource;
}

+ (void)setDelegate:(id)_delegate
{
	BeintooMission *service   = [Beintoo beintooMissionService];
	service.callingDelegate = _delegate;
}

#pragma mark - API calls

+ (void)initMission:(NSString *)missionID
{
    if ([Beintoo getPlayer] == nil)
        return;
    
    BeintooMission *service = [Beintoo beintooMissionService];
    
    NSString *res = [NSString stringWithFormat:@"%@/init", [service restResource]];
    if([missionID length] > 0)
        res = [res stringByAppendingFormat:@"/%@", missionID];
    
    NSString *httpBody = [NSString stringWithFormat:@"guid=%@", [Beintoo getPlayerID]];
    
    CLLocation *location = [Beintoo getUserLocation];
	if (location != nil && (location.coordinate.latitude <= 0.01f || location.coordinate.latitude >= -0.01f)
		&& (location.coordinate.longitude <= 0.01f && location.coordinate.longitude >= -0.01f)) {
		httpBody	= [httpBody stringByAppendingFormat:@"&latitude=%f&longitude=%f&radius=%f",
               location.coordinate.latitude, location.coordinate.longitude, location.horizontalAccuracy];
    }
	
    res = [res stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
	NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            [Beintoo getApiKey], @"apikey",
                            nil];
    
	[service.parser parsePageAtUrlWithPOST:res withHeaders:params withHTTPBody:httpBody fromCaller:MISSION_INIT];
}

+ (void)missionOver:(NSString *)missionID
{
    if ([Beintoo getPlayer] == nil)
        return;
    
    BeintooMission *service = [Beintoo beintooMissionService];
    
    NSString *res = [NSString stringWithFormat:@"%@/over/%@", [service restResource], missionID];
    NSString *httpBody = [res stringByAppendingFormat:@"guid=%@", [Beintoo getPlayerID]];
    
    CLLocation *location = [Beintoo getUserLocation];
	if (location != nil && (location.coordinate.latitude <= 0.01f || location.coordinate.latitude >= -0.01f)
		&& (location.coordinate.longitude <= 0.01f && location.coordinate.longitude >= -0.01f)) {
		httpBody	= [res stringByAppendingFormat:@"&latitude=%f&longitude=%f&radius=%f",
                       location.coordinate.latitude, location.coordinate.longitude, location.horizontalAccuracy];
    }
	
    httpBody = [res stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
	NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            [Beintoo getApiKey], @"apikey",
                            nil];
    
	[service.parser parsePageAtUrlWithPOST:res withHeaders:params withHTTPBody:httpBody fromCaller:MISSION_OVER];
}

+ (void)missionAccept:(NSString *)missionID
{
    if ([Beintoo getPlayer] == nil)
        return;
    
    BeintooMission *service = [Beintoo beintooMissionService];
    
    NSString *res = [NSString stringWithFormat:@"%@/accept/%@", [service restResource], missionID];
    NSString *httpBody = [res stringByAppendingFormat:@"guid=%@", [Beintoo getPlayerID]];
    
    CLLocation *location = [Beintoo getUserLocation];
	if (location != nil && (location.coordinate.latitude <= 0.01f || location.coordinate.latitude >= -0.01f)
		&& (location.coordinate.longitude <= 0.01f && location.coordinate.longitude >= -0.01f)) {
		httpBody	= [res stringByAppendingFormat:@"&latitude=%f&longitude=%f&radius=%f",
                       location.coordinate.latitude, location.coordinate.longitude, location.horizontalAccuracy];
    }
	
    httpBody = [res stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
	NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            [Beintoo getApiKey], @"apikey",
                            nil];
    
	[service.parser parsePageAtUrlWithPOST:res withHeaders:params withHTTPBody:httpBody fromCaller:MISSION_ACCEPT];
}

+ (void)runningMission
{
    if ([Beintoo getPlayer] == nil)
        return;
    
    BeintooMission *service = [Beintoo beintooMissionService];
    
    NSString *res = [NSString stringWithFormat:@"%@/running", [service restResource]];
    NSString *httpBody = [NSString stringWithFormat:@"guid=%@", [Beintoo getPlayerID]];
    
    CLLocation *location = [Beintoo getUserLocation];
	if (location != nil && (location.coordinate.latitude <= 0.01f || location.coordinate.latitude >= -0.01f)
		&& (location.coordinate.longitude <= 0.01f && location.coordinate.longitude >= -0.01f)) {
		httpBody	= [httpBody stringByAppendingFormat:@"&latitude=%f&longitude=%f&radius=%f",
                       location.coordinate.latitude, location.coordinate.longitude, location.horizontalAccuracy];
    }
	
    httpBody = [httpBody stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
	NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            [Beintoo getApiKey], @"apikey",
                            nil];
    
	[service.parser parsePageAtUrlWithPOST:res withHeaders:params withHTTPBody:httpBody fromCaller:MISSION_RUNNING];
}

+ (void)acceptMission
{
    
}

#pragma mark - Parser Delegate

- (void)didFinishToParsewithResult:(NSDictionary *)result forCaller:(NSInteger)callerID
{
    //NSLog(@"result %@", result);
    
    BMissionWrapper *mObject = [[BMissionWrapper alloc] initWithContentOfDictionary:result];
    NSLog(@"result single mission %@", [mObject dictionaryFromSelf]);
    
    switch (callerID) {
        case MISSION_INIT:
        {
            
            [BeintooMission updateMission:mObject];
            
            NSLog(@"result total saved %@", [BeintooMission dictionarySavedEvent]);
            
        }
           break;
            
        case MISSION_ACCEPT:
            
            break;
            
        case MISSION_OVER:
            
            break;
            
        case MISSION_RUNNING:
            
            break;
            
        default:
            break;
    }

}

#pragma mark - Check Unlocked Mission

+ (NSArray *)checkUnlockedMissionsWithScore:(double)score
{
    NSMutableArray *unlockedMissions = [[NSMutableArray alloc] init];
    NSMutableArray *storedMissions = [self storedMissions];
    
    NSLog(@"mission stored %@", [BeintooMission dictionarySavedEvent]);
    
    for (int i = 0; i < [storedMissions count]; i++)
    {
        BMissionWrapper *obj = (BMissionWrapper *)[storedMissions objectAtIndex:i];
        
        CLLocation *currentLocation = [Beintoo getUserLocation];
        
        BOOL isUnlocked = TRUE;
        
        BeintooLOG(@"checking distance %@", obj.location);
        
        // Check for distance unlocking
        if (currentLocation != nil && obj.location != nil)
        {
            BeintooLOG(@"checking distance %f on radius %f", [obj.location distanceFromLocation:currentLocation], obj.location.horizontalAccuracy);
            if ([obj.location distanceFromLocation:currentLocation] <= obj.location.horizontalAccuracy)
            {
                isUnlocked &= TRUE;
                
                BeintooLOG(@"Unlocked the mission, distance reason");
            }
            else
            {
                isUnlocked &= FALSE;
                
                BeintooLOG(@"Not unlocked mission in distance reason");
            }
        }
        
        // Check for date unlocking
        if (obj.startDate != nil && obj.endDate != nil)
        {
            NSDate *currDate = [NSDate date]; // [NSDate date] returns UTC date
            
            NSDateFormatter *df = [[NSDateFormatter alloc] init];
            [df setDateFormat:@"d-MMM-y HH:mm:ss"];
            NSLocale *gbLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_GB"];
            [df setLocale:gbLocale];
            [df setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
            
            NSDate *sDate = [df dateFromString:obj.startDate];
            
            NSDate *eDate = [df dateFromString:obj.endDate];
            
            BeintooLOG(@"checking dates: starting %@ -- now %@ -- end %@", sDate, currDate, eDate);
            
            if ([sDate compare:currDate] == NSOrderedAscending && [eDate compare:currDate] == NSOrderedDescending)
            {
                isUnlocked &= TRUE;
                
                BeintooLOG(@"Unlocked the mission, date reason");
            }
            else
            {
                isUnlocked &= FALSE;
                
                BeintooLOG(@"Not unlocked mission in date reason");
            }
        }
        
        if (obj.score != nil)
        {
            BeintooLOG(@"checking score type: current is %@ -- %i", obj.scoreType, BMissionWrapperScoreTypeIncremental);
            if ([obj.scoreType intValue] == BMissionWrapperScoreTypeIncremental)
            {
               // BeintooLOG(@"checking score: tot %f -- limit %f", [obj.currentScore doubleValue] + score, [obj.score doubleValue]);
                if ([obj.currentScore doubleValue] + score >= [obj.score doubleValue])
                {
                    isUnlocked &= TRUE;
                    
                    BeintooLOG(@"Unlocked the mission, score reason");
                }
                else
                {
                    isUnlocked &= FALSE;
                    
                    BeintooLOG(@"Not unlocked the mission, score reason, update score");
                    
                    obj.currentScore = [NSNumber numberWithDouble:([obj.currentScore doubleValue] + score)];
                    [self updateMission:obj];
                }
            }
            else if ([obj.scoreType intValue] == BMissionWrapperScoreTypeBestPerformance)
            {
                BeintooLOG(@"checking score: tot %f -- limit %f", score, [obj.score doubleValue]);
                
                if (score >= [obj.score doubleValue])
                {
                    isUnlocked &= TRUE;
                    
                    BeintooLOG(@"Unlocked the mission, score reason");
                }
                else
                {
                    isUnlocked &= FALSE;
                    
                    BeintooLOG(@"Not unlocked the mission, score reason");
                }
            }
        }
        
        if (isUnlocked == TRUE)
        {
            [unlockedMissions addObject:obj];
            [self removeMission:obj];
        }
    }
    
    BeintooLOG(@"Unlocked array contains: %@", unlockedMissions);
    
    return unlockedMissions;
}

#pragma mark - Storing Missions into Preferences

+ (NSMutableArray *)storedMissions
{
    @try
    {
        if ([[NSUserDefaults standardUserDefaults] objectForKey:NSUDMissionStoredArray])
        {
            if ([NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:NSUDMissionStoredArray]])
                return [NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:NSUDMissionStoredArray]];
            else
                return [[NSMutableArray alloc] init];
        }
    }
    @catch (NSException *exception) {
        BeintooLOG(@"Exception on storedMissions method, %@", exception);
    }
    
    return [[NSMutableArray alloc] init];
}

+ (void)storeMissionList:(NSMutableArray *)eventList
{
    @try
    {
        NSData *dataVal = [NSKeyedArchiver archivedDataWithRootObject:eventList];
        [[NSUserDefaults standardUserDefaults] setObject:dataVal forKey:NSUDMissionStoredArray];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    @catch (NSException *exception) {
        BeintooLOG(@"Exception on storeMissionList method, %@", exception);
    }
}

+ (void)emptyMissionList
{
    @try
    {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:NSUDMissionStoredArray];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    @catch (NSException *exception) {
        BeintooLOG(@"Exception on emptyMissionList method, %@", exception);
    }
}

+ (void)saveMission:(BMissionWrapper *)mission
{
    @try
    {
        [self updateMission:mission];
    }
    @catch (NSException *exception) {
        BeintooLOG(@"Exception on saveMission method, %@", exception);
    }
}

+ (BMissionWrapper *)getMissionByID:(NSString *)missionID
{
    @try
    {
        NSMutableArray *list = [[NSMutableArray alloc] init];
        list = [self storedMissions];
        
        for (int i = 0; i < [list count]; i++)
        {
            BMissionWrapper *localObj = (BMissionWrapper *)[list objectAtIndex:i];
            if (localObj.codeID)
            {
                if ([localObj.missionExtId isEqualToString:missionID])
                {
                    return [localObj copy];
                }
            }
        }
    }
    @catch (NSException *exception) {
        BeintooLOG(@"Exception on getEventByCode method, %@", exception);
    }
    
    return nil;
}

+ (void)updateMission:(BMissionWrapper *)mission
{
    @try
    {
        NSMutableArray *list = [[NSMutableArray alloc] init];
        list = [self storedMissions];
        
        if ([self isMissionAlreadySaved:mission] == NO){
            [list addObject:mission];
        }
        else
        {
            for (int i = 0; i < [list count]; i++)
            {
                BMissionWrapper *localObj = (BMissionWrapper *)[list objectAtIndex:i];
                if (localObj.missionExtId)
                {
                    if ([localObj.missionExtId isEqualToString:mission.missionExtId])
                    {
                        [list replaceObjectAtIndex:i withObject:mission];
                    }
                }
            }
        }
        
        [self storeMissionList:list];
    }
    @catch (NSException *exception) {
        BeintooLOG(@"Exception on updateMission method, %@", exception);
    }
}

+ (BOOL)removeMission:(BMissionWrapper *)mission
{
    @try
    {
        NSMutableArray *list = [[NSMutableArray alloc] init];
        list = [self storedMissions];
        
        [list removeObject:mission];
        
        [self storeMissionList:list];
    }
    @catch (NSException *exception) {
        BeintooLOG(@"Exception on removeMission method, %@", exception);
    }
    
    return FALSE;
}

+ (BOOL)isMissionAlreadySaved:(BMissionWrapper *)mission
{
    @try
    {
        NSMutableArray *list = [[NSMutableArray alloc] init];
        list = [self storedMissions];
        
        for (int i = 0; i < [list count]; i++)
        {
            BMissionWrapper *localObj = (BMissionWrapper *)[list objectAtIndex:i];
            if (localObj.missionExtId)
            {
                if ([localObj.missionExtId isEqualToString:mission.missionExtId])
                {
                    return TRUE;
                }
            }
        }
    }
    @catch (NSException *exception) {
        BeintooLOG(@"Exception on isMissionAlreadySaved method, %@", exception);
    }
    
    return FALSE;
}

+ (NSMutableArray *)dictionarySavedEvent
{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    
    @try
    {
        for (BMissionWrapper *obj in [self storedMissions])
        {
            [array addObject:[obj dictionaryFromSelf]];
        }
    }
    @catch (NSException *exception) {
        BeintooLOG(@"Exception on updateEvent method, %@", exception);
    }
    
    return array;
}

+ (NSDictionary *)dictionaryFromObject:(BMissionWrapper *)object
{
    return [object dictionaryFromSelf];
}

#pragma mark - Dealloc

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
