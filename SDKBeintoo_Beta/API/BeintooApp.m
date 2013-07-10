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

#import "BeintooApp.h"
#import "Beintoo.h"

@implementation BeintooApp

@synthesize delegate, parser, showGiveBedollarsNotification, notificationPosition;

#pragma mark - Init 

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

#pragma mark - Methods 

- (void)initElements
{
    parser          = [[Parser alloc] init];
    parser.delegate = self;
    rest_resource   = [[NSString alloc] initWithString:[NSString stringWithFormat:@"%@/app/", [Beintoo getRestBaseUrl]]];
}

- (NSString *)restResource
{
	return rest_resource;
}

+ (void)setDelegate:(id)_caller
{
	BeintooApp *appService  = [Beintoo beintooAppService];
	appService.delegate     = _caller;
}

#pragma mark - API Calls

+ (void)giveBedollars:(float)amount showNotification:(BOOL)showNotification withPosition:(int)position
{
    if ([Beintoo getPlayerID] == nil){
        BeintooLOG(@"Give Bedollars: no player logged");
        return;
    }
    
    if (!amount){
        BeintooLOG(@"Give Bedollars: no amount provided");
        return;
    }
    
    [Beintoo updateUserLocation];
	CLLocation *loc	 = [Beintoo getUserLocation];
    
    BeintooApp *appService = [Beintoo beintooAppService];
	
    appService.showGiveBedollarsNotification = showNotification;
    appService.notificationPosition = position;
    
    NSString *res               = [NSString stringWithFormat:@"%@givebedollars", appService.restResource];
	NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   [Beintoo getApiKey], @"apikey",
                                   [Beintoo getPlayerID], @"guid",
                                   nil];
    
    NSString *httpBody = [NSString stringWithFormat:@"amount=%f", amount];
    
    if (loc == nil || (loc.coordinate.latitude <= 0.01f && loc.coordinate.latitude >= -0.01f)
		|| (loc.coordinate.longitude <= 0.01f && loc.coordinate.longitude >= -0.01f)) {
	}
	else
		httpBody	= [httpBody stringByAppendingFormat:@"&latitude=%f&longitude=%f&radius=%f",
                       loc.coordinate.latitude, loc.coordinate.longitude, loc.horizontalAccuracy];
    
    [appService.parser parsePageAtUrlWithPOST:res withHeaders:params withHTTPBody:httpBody fromCaller:USER_GIVE_BEDOLLARS_CALLER_ID];
}

- (void)giveBedollars:(float)amount showNotification:(BOOL)showNotification
{
    if ([Beintoo getPlayerID] == nil){
        BeintooLOG(@"Give Bedollars: no player logged");
        return;
    }
    
    if (!amount){
        BeintooLOG(@"Give Bedollars: no amount provided");
        return;
    }
    
    [Beintoo updateUserLocation];
	CLLocation *loc	 = [Beintoo getUserLocation];
    
    showGiveBedollarsNotification = showNotification;
    
    NSString *res		 = [NSString stringWithFormat:@"%@givebedollars/%@", rest_resource, [Beintoo getUserID]];
	NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   [Beintoo getApiKey], @"apikey",
                                   nil];
    
    NSString *httpBody = [NSString stringWithFormat:@"amount=%f", amount];
    
    if (loc == nil || (loc.coordinate.latitude <= 0.01f && loc.coordinate.latitude >= -0.01f)
		|| (loc.coordinate.longitude <= 0.01f && loc.coordinate.longitude >= -0.01f)) {
	}
	else
		httpBody	= [httpBody stringByAppendingFormat:@"&latitude=%f&longitude=%f&radius=%f",
                       loc.coordinate.latitude, loc.coordinate.longitude, loc.horizontalAccuracy];
    
    [parser parsePageAtUrlWithPOST:res withHeaders:params withHTTPBody:httpBody fromCaller:USER_GIVE_BEDOLLARS_CALLER_ID];
}

#pragma mark - Parser delegate response

- (void)didFinishToParsewithResult:(NSDictionary *)result forCaller:(NSInteger)callerID
{
    switch (callerID){
		case USER_GIVE_BEDOLLARS_CALLER_ID:{
            
            if ([result objectForKey:@"message"] || ![result objectForKey:@"content"]) {
				
                [BeintooApp notifyGiveBedollarsGenerationError:[result objectForKey:@"message"]];
                
                return;
            }
            
            if (showGiveBedollarsNotification == YES){
                
                BGiveBedollarsWrapper *wrapper = [[BGiveBedollarsWrapper alloc] initWithContentOfDictionary:result];
                
                [BeintooApp notifyGiveBedollarsGeneration:wrapper];
                
                BeintooApp *service = [Beintoo beintooAppService];
                id _delegate = service.delegate;
                
                [Beintoo showGiveBedollars:wrapper withDelegate:_delegate position:notificationPosition];
                
#ifdef BEINTOO_ARC_AVAILABLE
#else
                [wrapper release];
#endif

            }
		}
			break;
    }
}

#pragma mark - GB notification delegates

+ (void)notifyGiveBedollarsGeneration:(BGiveBedollarsWrapper *)wrapper;
{
	[self notifyGiveBedollarsGenerationOnUserDelegate:wrapper];
    [self notifyGiveBedollarsGenerationOnMainDelegate:wrapper];
}

+ (void)notifyGiveBedollarsGenerationError:(NSDictionary *)_error
{
    BeintooLOG(@"Beintoo: error in Give Bedollars call: %@", _error);
    
	[self notifyGiveBedollarsGenerationErrorOnUserDelegate:_error];
    [self notifyGiveBedollarsGenerationErrorOnMainDelegate:_error];
}

+ (void)notifyGiveBedollarsGenerationOnMainDelegate:(BGiveBedollarsWrapper *)wrapper;
{
	[Beintoo notifyGiveBedollarsGenerationOnMainDelegate:wrapper];
}

+ (void)notifyGiveBedollarsGenerationErrorOnMainDelegate:(NSDictionary *)_error
{
	[Beintoo notifyGiveBedollarsGenerationErrorOnMainDelegate:_error];
}

+ (void)notifyGiveBedollarsGenerationOnUserDelegate:(BGiveBedollarsWrapper *)wrapper;
{
	BeintooApp *service = [Beintoo beintooAppService];
	id _delegate = service.delegate;
    
    if ([_delegate respondsToSelector:@selector(didReceiveGiveBedollarsResponse:)])
        [_delegate didReceiveGiveBedollarsResponse:wrapper];
}

+ (void)notifyGiveBedollarsGenerationErrorOnUserDelegate:(NSDictionary *)_error
{
	BeintooApp *service = [Beintoo beintooAppService];
	id _delegate = service.delegate;
    
	if ([_delegate respondsToSelector:@selector(didFailToPerformGiveBedollars:)])
        [_delegate didFailToPerformGiveBedollars:_error];
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
