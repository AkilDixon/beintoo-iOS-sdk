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

#import "BeintooDevice.h"
#import "Beintoo.h"
#import "UIDevice+IdentifierAddition.h"
#import "NSString+MD5Addition.h"

@implementation BeintooDevice

- (id)init
{
	if (self = [super init])
	{
	}
    return self;
}

+ (BOOL)isiPad
{
	return (CGRectGetMaxX([[UIScreen mainScreen] bounds]) >= 768);
}

+ (NSString *)getUDID
{
    NSString *identifier = @"";
    
    if ([BeintooDevice isASIdentifierSupported])
        identifier = [BeintooDevice getASIdentifier];
    else
    {
        /*
         ** Note: Mac Address will be 02:00:00:00:00:00 on iOS >= 7.0
         **
         ** We enter in this case only if iOS current version in lower than 6.0
         */
        
        identifier = [[NSString stringWithFormat:@"%@beintooios", [BeintooDevice getMacAddress]] stringFromMD5];
    }
    
    return identifier;
}

+ (NSString *)getMacAddress
{
	return [[UIDevice currentDevice] _getMacAddress];
}

+ (NSString *)getISOLanguage
{
	NSString   *language = [[NSLocale preferredLanguages] objectAtIndex:0];
	if ([language length] == 2) {
		return language;
	}
	return nil;
}

+ (NSString *)getFormattedTimestampNow
{
    //Create the dateformatter object
#ifdef BEINTOO_ARC_AVAILABLE
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
#else
    NSDateFormatter* formatter = [[[NSDateFormatter alloc] init] autorelease];
#endif
	
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];	
	//Get the string date
	NSString* timeStamp = [formatter stringFromDate:[NSDate date]];		
	return timeStamp;
}

+ (int)elapsedHoursSinceTimestamp:(NSString *)_timestamp
{
    
#ifdef BEINTOO_ARC_AVAILABLE
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
#else
    NSDateFormatter* formatter = [[[NSDateFormatter alloc] init] autorelease];
#endif
    
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        
    if (!_timestamp) {
        return 100000;   // No timestamp, we return a very big number of hours (to say like infinite)
    }
    NSDate *timestampDate = [formatter dateFromString:_timestamp];
    NSDate *nowDate = [NSDate date];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:(kCFCalendarUnitHour) fromDate:timestampDate toDate:nowDate options:0];
    NSInteger hour = [components hour];
    return hour;
}


+ (NSString *)getASIdentifier
{

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= BEINTOO_IOS_6_0
    if ([ASIdentifierManager sharedManager])
        return [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
#endif
    
    return nil;
}

+ (NSString *)isASIdentifierEnabledByUser
{
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= BEINTOO_IOS_6_0
    if ([ASIdentifierManager sharedManager]){
        if ([[ASIdentifierManager sharedManager] isAdvertisingTrackingEnabled] == TRUE)
            return @"true";
    }
#endif
    
    return @"false";
}

+ (BOOL)isASIdentifierSupported
{
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= BEINTOO_IOS_6_0
    if ([ASIdentifierManager sharedManager])
        return TRUE;
#endif

    return FALSE;
}


+ (NSString *)getSystemVersion
{
    if ([[UIDevice currentDevice] respondsToSelector:@selector(systemVersion)])
        return [[UIDevice currentDevice] systemVersion];
    
    return nil;
}

+ (NSString *)getDeviceType
{
    if ([[UIDevice currentDevice] respondsToSelector:@selector(model)])
        return [[UIDevice currentDevice] model];
    
    return nil;
}

+ (int)getTimeOffset
{
    return [NSTimeZone systemTimeZone].secondsFromGMT;
}

+ (NSString *)currentTimezone
{
    return [NSString stringWithFormat:@"%@", [NSTimeZone localTimeZone]];
}

+ (NSDictionary *)screenSize
{
    CGRect screenBound = [[UIScreen mainScreen] bounds];
    CGSize screenSize = screenBound.size;
    CGFloat screenWidth = screenSize.width;
    CGFloat screenHeight = screenSize.height;
    
    NSString *screenWstring = [NSString stringWithFormat:@"%f", screenWidth];
    NSString *screenHstring = [NSString stringWithFormat:@"%f", screenHeight];
    
    
    return [NSDictionary dictionaryWithObjectsAndKeys:
            screenWstring, @"width",
            screenHstring, @"height",
            nil];
}

#ifdef BEINTOO_ARC_AVAILABLE
#else
- (void)dealloc {
    [super dealloc];
}
#endif

@end
