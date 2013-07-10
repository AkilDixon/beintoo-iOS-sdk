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

#import "BeintooEvent.h"
#import "Beintoo.h"

NSString *NSUDEventDictionary = @"BeintooNSUDEventDictionary";

@implementation BeintooEvent
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
    
    rest_resource = [[NSString alloc] initWithString:[NSString stringWithFormat:@"%@/event", [Beintoo getRestBaseUrl]]];
}

- (NSString *)restResource
{
	return rest_resource;
}

+ (void)setDelegate:(id)_delegate
{
	BeintooEvent *service   = [Beintoo beintooEventService];
	service.delegate = _delegate;
}

#pragma mark - API calls

+ (void)getEventWithAmountOfBedollars:(double)amount score:(double)score code:(NSString *)codeID unlockedList:(NSArray *)unlockedList
{
    if ([Beintoo getPlayer] == nil)
    {
        BeintooLOG(@"Get Event not executed, a player is needed.");
        return;
    }
    
    [Beintoo updateUserLocation];
    
    BeintooEvent *service = [Beintoo beintooEventService];
    
    NSString *res = [NSString stringWithFormat:@"%@", [service restResource]];
    res = [res stringByAppendingFormat:@"?guid=%@", [Beintoo getPlayerID]];
    
    if ([Beintoo getUserID])
        res = [res stringByAppendingFormat:@"&userExt=%@", [Beintoo getUserID]];
    
    CLLocation *location = [Beintoo getUserLocation];
	if (location != nil && (location.coordinate.latitude <= 0.01f || location.coordinate.latitude >= -0.01f)
		&& (location.coordinate.longitude <= 0.01f && location.coordinate.longitude >= -0.01f)) {
		res	= [res stringByAppendingFormat:@"&latitude=%f&longitude=%f&radius=%f",
               location.coordinate.latitude, location.coordinate.longitude, location.horizontalAccuracy];
    }
    
    // Send the current device timezone
    res = [res stringByAppendingFormat:@"&timeOffset=%i", [BeintooDevice getTimeOffset]];
	
    NSNumber *amountN = [NSNumber numberWithDouble:amount];
    if (amountN != nil)
        res = [res stringByAppendingFormat:@"&amount=%@", amountN];
    
    NSNumber *scoreN = [NSNumber numberWithDouble:score];
    if (scoreN != nil)
        res = [res stringByAppendingFormat:@"&score=%@", scoreN];
    
    for (NSString *codeID in unlockedList)
    {
        res = [res stringByAppendingFormat:@"&unlocked=%@", codeID];
    }
    
    // This is used only for purpose testing, retrieving a specific mission by ext ID
    //  res = [res  stringByAppendingFormat:@"&sandboxSpecificMission=%@", @"af256j4Hte5GedN4qXG8Uw0je3FEDz0TXWqhm2dV"];
    
    res = [res stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
	NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            [Beintoo getApiKey], @"apikey",
                            nil];
    
	[service.parser parsePageAtUrl:res withHeaders:params fromCaller:GET_EVENT];
}

+ (void)getEventWithAmountOfBedollars:(double)bedollars score:(double)score code:(NSString *)codeID
{
    // 1) check for unlockedMission
    
    /*NSArray *missionEvents = [BeintooMission checkUnlockedMissionsWithScore:score];
    
    // NSLog(@"missionEvents found: %@", [BeintooMission checkUnlockedMissionsWithScore:score]);
    if ([missionEvents count] > 0)
    {
        return;
    }*/
    
    //NSLog(@"Events found: %@", [self dictionarySavedEvent]);
    
    NSMutableArray *unlockedEvents = [self checkForUnlockedEventWithScore:score code:codeID];
    
    //NSLog(@"Events unlocked: %@", unlockedEvents);

    if ([unlockedEvents count] > 0)
    {
        BeintooLOG(@"Get Event: a threshold has been reached, calling Beintoo to get some content.");
        
        [BeintooEvent getEventWithAmountOfBedollars:bedollars score:score code:codeID unlockedList:unlockedEvents];
    }
    else
        BeintooLOG(@"Get Event: no threshold reached, waiting for next score to be submitted. (Thresholds are setup in your contests, check your Beintoo Developer panel)");
}

+ (NSMutableArray *)checkForUnlockedEventWithScore:(double)score code:(NSString *)codeID
{
    if ([Beintoo getPlayer] == nil)
        return FALSE;
    
    if (![Beintoo getPlayer].eventInfoBean)
        return FALSE;
    
    if (codeID == nil)
        codeID = @"null";
    
    NSMutableArray *unlockedEvents = [[NSMutableArray alloc] init];
    // create an event object containing the local stored event for the current codeID
    BEventObject *currentEvent;
    
    // get the list of the event threshold from the player wrapper
    NSArray *eventList = [Beintoo getPlayer].eventInfoBean;
    
    double maxTarget = 1;
    
    @try {
        if ([self getEventByCode:codeID] == nil)
        {
            currentEvent = [[BEventObject alloc] init];
            currentEvent.codeID = codeID;
            currentEvent.score = score;
            currentEvent.count = 1;
            [self saveEvent:currentEvent];
        }
        else
        {
            currentEvent = [self getEventByCode:codeID];
            currentEvent.count++;
            currentEvent.score += score;
            [self updateEvent:currentEvent];
        }
    }
    @catch (NSException *exception) {
        BeintooLOG(@"Exception on checkForUnlockedEventWithScore method, while retrieving current event, if it exists, %@", exception);
    }
    
    // iterate between all the events and
    
    @try {
        for (int i = 0; i < [eventList count]; i ++)
        {
            NSDictionary *targetEvent = [eventList objectAtIndex:i];
            if ([currentEvent.codeID isEqualToString:[targetEvent objectForKey:@"codeID"]])
            {
               // NSLog(@"found codeID row, %@", [targetEvent objectForKey:@"type"]);
                
                if ([[targetEvent objectForKey:@"type"] isEqualToString:BEventObjectTypeScore]) {
                    double nextThreshold = (currentEvent.score - score) + [[targetEvent objectForKey:@"val"] doubleValue] - fmod((currentEvent.score - score), [[targetEvent objectForKey:@"val"] doubleValue]);
                    
                    if (currentEvent.score >= nextThreshold)
                        [unlockedEvents addObject:[targetEvent objectForKey:@"event"]];
                    
                    // save the maximum common value of the same event by type, to clean the saved amount when reaching it
                    maxTarget *= [[targetEvent objectForKey:@"val"] doubleValue];
                    
                    //NSLog(@"val %f -- target %f", [[targetEvent objectForKey:@"val"] doubleValue], maxTarget);
                }
                else if ([[targetEvent objectForKey:@"type"] isEqualToString:BEventObjectTypeCount])
                {
                    //NSLog(@"val %f -- target %i", [[targetEvent objectForKey:@"val"] doubleValue], currentEvent.count);
                    
                    if (currentEvent.count >= [[targetEvent objectForKey:@"val"] doubleValue])
                    {
                        [unlockedEvents addObject:[targetEvent objectForKey:@"event"]];
                        currentEvent.count = 0;
                        
                        [self updateEvent:currentEvent];
                    }
                }
            }
        }
    }
    @catch (NSException *exception) {
        BeintooLOG(@"Exception on checkForUnlockedEventWithScore method, while checking unlocked events, %@", exception);
    }
    
    //NSLog(@"score %f -- maxTarget %f", currentEvent.score, maxTarget);
    
    @try {
        // if we reach the maximum common value between, we can reset the current event score
        if (currentEvent.score > maxTarget && maxTarget != 1)
        {
            currentEvent.score = currentEvent.score - maxTarget;
            [self updateEvent:currentEvent];
        }
    }
    @catch (NSException *exception) {
        BeintooLOG(@"Exception on checkForUnlockedEventWithScore method, while cleaning the current stored points, %@", exception);
    }
   
#ifdef BEINTOO_ARC_AVAILABLE
    return unlockedEvents;
#else
    return [unlockedEvents autorelease];
#endif
    
}

+ (NSMutableArray *)getSavedEvents
{
    @try
    {
        if ([[NSUserDefaults standardUserDefaults] objectForKey:NSUDEventDictionary])
        {
            return [NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:NSUDEventDictionary]];
        }
    }
    @catch (NSException *exception) {
        BeintooLOG(@"Exception on getSavedEvents method, %@", exception);
    }
    return nil;
}

+ (void)saveEvents:(NSMutableArray *)eventList
{
    @try
    {
        NSData *dataVal = [NSKeyedArchiver archivedDataWithRootObject:eventList];
        [[NSUserDefaults standardUserDefaults] setObject:dataVal forKey:NSUDEventDictionary];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    @catch (NSException *exception) {
        BeintooLOG(@"Exception on saveEvents method, %@", exception);
    }
}

+ (void)saveEvent:(BEventObject *)event
{
    @try
    {
        [self updateEvent:event];
    }
    @catch (NSException *exception) {
        BeintooLOG(@"Exception on saveEvent method, %@", exception);
    }
}

+ (BEventObject *)getEventByCode:(NSString *)codeID
{
    @try
    {
        
#ifdef BEINTOO_ARC_AVAILABLE
        NSMutableArray *eventList = [[NSMutableArray alloc] init];
#else
        NSMutableArray *eventList = [[[NSMutableArray alloc] init] autorelease];
#endif
        
        eventList = [self getSavedEvents];
        
        for (int i = 0; i < [eventList count]; i++)
        {
            BEventObject *localEvent = (BEventObject *)[eventList objectAtIndex:i];
            if (localEvent.codeID)
            {
                if ([localEvent.codeID isEqualToString:codeID])
                {
                    return localEvent;
                }
            }
        }
    }
    @catch (NSException *exception) {
        BeintooLOG(@"Exception on getEventByCode method, %@", exception);
    }
    
    return nil;
}

+ (void)updateEvent:(BEventObject *)event
{
    @try
    {
        
#ifdef BEINTOO_ARC_AVAILABLE
        NSMutableArray *eventList = [[NSMutableArray alloc] init];
#else
        NSMutableArray *eventList = [[[NSMutableArray alloc] init] autorelease];
#endif
        
        eventList = [self getSavedEvents];
        
        if ([self isEventAlreadySaved:event] == NO){
            [eventList addObject:event];
        }
        else
        {
            for (int i = 0; i < [eventList count]; i++)
            {
                BEventObject *localEvent = (BEventObject *)[eventList objectAtIndex:i];
                if (localEvent.codeID)
                {
                    if ([localEvent.codeID isEqualToString:event.codeID])
                    {
                        [eventList replaceObjectAtIndex:i withObject:event];
                    }
                }
            }
        }
    
        [self saveEvents:eventList];
    }
    @catch (NSException *exception) {
        BeintooLOG(@"Exception on updateEvent method, %@", exception);
    }
}

+ (BOOL)isEventAlreadySaved:(BEventObject *)event
{
    @try
    {
        
#ifdef BEINTOO_ARC_AVAILABLE
        NSMutableArray *eventList = [[NSMutableArray alloc] init];
#else
        NSMutableArray *eventList = [[[NSMutableArray alloc] init] autorelease];
#endif
        
        eventList = [self getSavedEvents];
        
        for (int i = 0; i < [eventList count]; i++)
        {
            BEventObject *localEvent = (BEventObject *)[eventList objectAtIndex:i];
            if (localEvent.codeID)
            {
                if ([localEvent.codeID isEqualToString:event.codeID])
                {
                    return TRUE;
                }
            }
        }
    }
    @catch (NSException *exception) {
        BeintooLOG(@"Exception on updateEvent method, %@", exception);
    }
    
    return FALSE;
}

+ (NSMutableArray *)dictionarySavedEvent
{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    
    @try
    {
        for (BEventObject *eventObj in [self getSavedEvents])
        {
            [array addObject:[eventObj dictionaryFromEventObject]];
        }
    }
    @catch (NSException *exception) {
        BeintooLOG(@"Exception on updateEvent method, %@", exception);
    }
    
#ifdef BEINTOO_ARC_AVAILABLE
    return array;
#else
    return [array autorelease];
#endif
    
}

+ (NSMutableArray *)eventsObjectsToDictionary:(NSMutableArray *)objToDictionary
{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    
    @try
    {
        for (BEventObject *eventObj in objToDictionary)
        {
            [array addObject:[eventObj dictionaryFromEventObject]];
        }
    }
    @catch (NSException *exception) {
        BeintooLOG(@"Exception on updateEvent method, %@", exception);
    }

#ifdef BEINTOO_ARC_AVAILABLE
    return array;
#else
    return [array autorelease];
#endif
    
}

#pragma mark - Parser Delegate

- (void)didFinishToParsewithResult:(NSDictionary *)result forCaller:(NSInteger)callerID
{
    switch (callerID) {
        case GET_EVENT:
        {
            if ([result objectForKey:@"message"] || ![result objectForKey:@"content"])
            {
                [BeintooEvent notifyEventGenerationError:[result objectForKey:@"message"]];
                return;
            }
            
            BeintooEvent *service = [Beintoo beintooEventService];
            id _delegate = service.delegate;
            
            BEventWrapper *eventWrapper = [[BEventWrapper alloc] initWithContentOfDictionary:result];
            
            [BeintooEvent notifyEventGeneration:eventWrapper];
            
            if ([eventWrapper.type isEqualToString:BEventWrapperTypeVGood])
            {
                BeintooReward *service = [Beintoo beintooRewardService];
                service.delegate = delegate;
                
                BRewardWrapper *reward = [[BRewardWrapper alloc] initWithContentOfDictionary:result];
                
                [BeintooReward notifyRewardGeneration:reward];
                
                [Beintoo showReward:reward withDelegate:_delegate];
                
#ifdef BEINTOO_ARC_AVAILABLE
#else
                [reward release];
#endif

            }
            else if ([eventWrapper.type isEqualToString:BEventWrapperTypeGiveBedollars])
            {
                if ([result objectForKey:@"message"] || ![result objectForKey:@"content"]) {
                    BeintooLOG(@"Beintoo: error in Give Bedollars call: %@", [result objectForKey:@"message"]);
                    
                    return;
                }
                
                BeintooApp *service = [Beintoo beintooAppService];
                service.delegate = delegate;
                
                BGiveBedollarsWrapper *wrapper = [[BGiveBedollarsWrapper alloc] initWithContentOfDictionary:result];
                
                [BeintooApp notifyGiveBedollarsGeneration:wrapper];
                
                [Beintoo showGiveBedollars:wrapper withDelegate:_delegate position:[Beintoo notificationPosition]];
                
#ifdef BEINTOO_ARC_AVAILABLE
#else
                [wrapper release];
#endif
                
            }
            /* else if ([eventWrapper.type isEqualToString:BEventWrapperTypeChallenge])
            {
                MISSION, are not already online
                
                if ([result objectForKey:@"message"]) {
                    BeintooLOG(@"Beintoo: error in Give Bedollars call: %@", [result objectForKey:@"message"]);
                    return;
                }
                
                BMissionWrapper *missionWrapper = [[BMissionWrapper alloc] initWithContentOfDictionary:(NSDictionary *)eventWrapper.missionWrapper];
                BMissionTemplate *mission = [[BMissionTemplate alloc] initWithMission:missionWrapper];
                
                [Beintoo showMission:mission delegate:callingDelegate];
                
            } */
            
#ifdef BEINTOO_ARC_AVAILABLE
#else
            [eventWrapper release];
#endif

        }
                 
            break;
            
        default:
            break;
    }
}

#pragma mark - Event notification delegates

+ (void)notifyEventGeneration:(BEventWrapper *)wrapper;
{
	[self notifyEventGenerationOnUserDelegate:wrapper];
    [self notifyEventGenerationOnMainDelegate:wrapper];
}

+ (void)notifyEventGenerationError:(NSDictionary *)_error
{
    [self notifyEventGenerationErrorOnUserDelegate:_error];
    [self notifyEventGenerationErrorOnMainDelegate:_error];
}

+ (void)notifyEventGenerationOnMainDelegate:(BEventWrapper *)wrapper;
{
	[Beintoo notifyEventGenerationOnMainDelegate:wrapper];
}

+ (void)notifyEventGenerationErrorOnMainDelegate:(NSDictionary *)_error
{
	[Beintoo notifyEventGenerationErrorOnMainDelegate:_error];
}

+ (void)notifyEventGenerationOnUserDelegate:(BEventWrapper *)wrapper;
{
	BeintooEvent *service = [Beintoo beintooEventService];
	id _delegate = service.delegate;
    
    if ([_delegate respondsToSelector:@selector(didGenerateAnEvent:)])
        [_delegate didGenerateAnEvent:wrapper];
}

+ (void)notifyEventGenerationErrorOnUserDelegate:(NSDictionary *)_error
{
	BeintooEvent *service = [Beintoo beintooEventService];
	id _delegate = service.delegate;
    
	if ([_delegate respondsToSelector:@selector(didFailToGenerateAnEvent:)])
        [_delegate didFailToGenerateAnEvent:_error];
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
