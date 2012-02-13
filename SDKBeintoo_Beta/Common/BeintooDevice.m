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

@implementation BeintooDevice

-(id)init {
	if (self = [super init])
	{
	}
    return self;
}


+ (BOOL)isiPad{
	return (CGRectGetMaxX([[UIScreen mainScreen] bounds]) >= 768);
}

+ (NSString *)getUDID{
	return [[UIDevice currentDevice] uniqueDeviceIdentifier];
}

+ (NSString *)getISOLanguage{
	NSString   *language = [[NSLocale preferredLanguages] objectAtIndex:0];
	if ([language length]==2) {
		return language;
	}
	return nil;
}

+ (NSString *)getFormattedTimestampNow{
    //Create the dateformatter object	
	NSDateFormatter* formatter = [[[NSDateFormatter alloc] init] autorelease];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];	
	//Get the string date
	NSString* timeStamp = [formatter stringFromDate:[NSDate date]];		
	return timeStamp;
}

+ (int)elapsedHoursSinceTimestamp:(NSString *)_timestamp{
    
    NSDateFormatter* formatter = [[[NSDateFormatter alloc] init] autorelease];
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

/*
 + (BOOL)devoParsare:(NSString *)tipo orePassate:(int)ore{
 
 NSDictionary *dictTabParser;
 NSDate *mydate = [NSDate date];
 NSTimeInterval secondsInHours = -ore * 60 * 60;
 NSDate *dateDueOreFa = [mydate dateByAddingTimeInterval:secondsInHours];
 
 NSDateFormatter* formatter = [[[NSDateFormatter alloc] init] autorelease];
 [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
 NSString *timestampDueOreFa = [formatter stringFromDate:dateDueOreFa];
 
 myVolantinoAppDelegate *appDelegate = (myVolantinoAppDelegate *)[[UIApplication sharedApplication] delegate];
 DBManager *dbMngr = [appDelegate getDBManager];
 
 // Leggo timestamp dal DB
 [dbMngr returnLastTimestamp:tipo];
 dictTabParser = [dbMngr returnDictionary];
 
 if (dictTabParser == nil) {
 return TRUE;
 }
 
 NSString *timestamp = [dictTabParser objectForKey:@"timestamp"];
 if ([timestamp compare:timestampDueOreFa] == NSOrderedAscending) {
 return TRUE;
 }
 // Se non devo scaricare nulla di nuovo
 return FALSE;
 }
 */


- (void)dealloc {
    [super dealloc];
}

@end
