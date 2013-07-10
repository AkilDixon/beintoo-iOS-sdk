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

#import "BMissionWrapper.h"
#import "objc/runtime.h"

int BMissionWrapperScoreTypeBestPerformance     = 1;
int BMissionWrapperScoreTypeIncremental         = 2;

@implementation BMissionWrapper
@synthesize missionExtId, codeID, content, contentType, endDate, lat, lng, radius, score, scoreType, startDate, player, vgood, brand, location, currentScore;

- (id)initWithCoder:(NSCoder *)coder
{
    self = [super init];
    if (self)
    {
        
        self.score = [[NSNumber alloc] init];
        
        missionExtId = ([coder decodeObjectForKey:@"missionExtId"]) ? [[coder decodeObjectForKey:@"missionExtId"] copy] : nil;
        
        if ([coder decodeObjectForKey:@"player"])
        {
            if ([[coder decodeObjectForKey:@"player"] isKindOfClass:[NSDictionary class]])
                player = [[BPlayerWrapper alloc] initWithContentOfDictionary:[[coder decodeObjectForKey:@"player"] copy]];
            else
                player = [[coder decodeObjectForKey:@"player"] copy];
        }
        
        brand           = ([coder decodeObjectForKey:@"brand"]) ? [[coder decodeObjectForKey:@"brand"] copy] : nil;
        vgood           = ([coder decodeObjectForKey:@"vgood"]) ? [[coder decodeObjectForKey:@"vgood"] copy] : nil;
        content         = ([coder decodeObjectForKey:@"content"]) ? [[coder decodeObjectForKey:@"content"] copy] : nil;
        contentType     = ([coder decodeObjectForKey:@"contentType"]) ? [[coder decodeObjectForKey:@"contentType"] copy] : nil;
        codeID          = ([coder decodeObjectForKey:@"codeID"]) ? [[coder decodeObjectForKey:@"codeID"] copy] : nil;
        
        startDate       = ([coder decodeObjectForKey:@"startDate"]) ? [[coder decodeObjectForKey:@"startDate"] copy] : nil;
        endDate         = ([coder decodeObjectForKey:@"endDate"]) ? [[coder decodeObjectForKey:@"endDate"] copy] : nil;
        
        scoreType       = ([coder decodeObjectForKey:@"scoreType"]) ? [NSNumber numberWithInt:[[[coder decodeObjectForKey:@"scoreType"] copy] intValue]] : nil;
        score           = ([coder decodeObjectForKey:@"score"]) ? [NSNumber numberWithDouble:[[[coder decodeObjectForKey:@"score"] copy] doubleValue]] : nil;
        currentScore    = ([coder decodeObjectForKey:@"currentScore"]) ? [NSNumber numberWithDouble:[[[coder decodeObjectForKey:@"currentScore"] copy] doubleValue]] : nil;        
        location        = ([coder decodeObjectForKey:@"location"]) ? [[coder decodeObjectForKey:@"location"] copy] : nil;
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder
{
    if (missionExtId != nil)
        [coder encodeObject:missionExtId forKey:@"missionExtId"];
    
    if (player != nil)
        [coder encodeObject:player forKey:@"player"];
    
    if (brand != nil)
        [coder encodeObject:brand forKey:@"brand"];
    
    if (vgood != nil)
        [coder encodeObject:vgood forKey:@"vgood"];
    
    if (content != nil)
        [coder encodeObject:content forKey:@"content"];
    
    if (contentType != nil)
        [coder encodeObject:contentType forKey:@"contentType"];
    
    if (codeID != nil)
        [coder encodeObject:codeID forKey:@"codeID"];
    
    if (startDate != nil)
        [coder encodeObject:startDate forKey:@"startDate"];
    
    if (endDate != nil)
        [coder encodeObject:endDate forKey:@"endDate"];
    
    if (scoreType != nil)
        [coder encodeObject:scoreType forKey:@"scoreType"];
    
    if (score != nil)
        [coder encodeObject:score forKey:@"score"];
    
    if (currentScore != nil)
        [coder encodeObject:currentScore forKey:@"currentScore"];
    
    if (location != nil)
        [coder encodeObject:location forKey:@"location"];
} 

- (id)initWithContentOfDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
        
        [self setValuesForKeysWithDictionary:dictionary];
        
        if ([dictionary objectForKey:@"lat"] && [dictionary objectForKey:@"lng"] && [dictionary objectForKey:@"radius"])
        {
            CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake([[dictionary objectForKey:@"lat"] doubleValue], [[dictionary objectForKey:@"lng"] doubleValue]);
            CLLocationAccuracy accurancy = [[dictionary objectForKey:@"radius"] doubleValue];
            CLLocationDistance distance;
            CLLocationAccuracy verticalAccurancy;
            location = [[CLLocation alloc] initWithCoordinate:coordinate altitude:distance horizontalAccuracy:accurancy verticalAccuracy:verticalAccurancy timestamp:[NSDate date]];
        }
    }
    return self;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    // add here keys not present in the API Wrapper
}

- (id)copyWithZone:(NSZone *)zone
{
    BMissionWrapper *object = [[BMissionWrapper alloc] init];
    
    object.content          = (object.content != nil) ? [self.content copyWithZone:zone] : nil;
    object.contentType      = (object.contentType != nil) ? [self.contentType copyWithZone:zone] : nil;
    object.player           = (object.player != nil) ? [self.player copyWithZone:zone] : nil;
    object.missionExtId     = (object.missionExtId != nil) ? [self.missionExtId copyWithZone:zone] : nil;
    object.brand            = (object.brand != nil) ? [self.brand copyWithZone:zone] : nil;
    object.vgood            = (object.vgood != nil) ? [self.vgood copyWithZone:zone] : nil;
    object.codeID           = (object.codeID != nil) ? [self.codeID copyWithZone:zone] : nil;
    object.startDate        = (object.startDate != nil) ? [self.startDate copyWithZone:zone] : nil;
    object.endDate          = (object.endDate != nil) ? [self.endDate copyWithZone:zone] : nil;
    object.scoreType        = (object.scoreType != nil) ? [self.scoreType copyWithZone:zone] : nil;
    object.score            = (object.score != nil) ? [self.score copyWithZone:zone] : nil;
    object.currentScore     = (object.currentScore != nil) ? [self.currentScore copyWithZone:zone] : nil;
    object.location         = (object.location != nil) ? [self.location copyWithZone:zone] : nil;
    
    return object;
}

#pragma mark - private methods

- (NSArray *)ivars
{
    // For debug purpose, print name and type of ivars
    
    NSMutableArray *ivarsDict = [[NSMutableArray alloc] init];
    
    unsigned int count;
    Ivar *ivars = class_copyIvarList([self class], &count);
    for(int i = 0; i < count; i++)
    {
        Ivar ivar= ivars[i];
        const char* _name = ivar_getName(ivar);
        // const char* typeEncoding = ivar_getTypeEncoding(ivar);
        // [ivarsDict setObject: [NSString stringWithFormat: @"%s",typeEncoding] forKey: [NSString stringWithFormat: @"%s",name]];
        
        [ivarsDict addObject:[NSString stringWithFormat: @"%s", _name]];
    }
    free(ivars);
    
#ifdef BEINTOO_ARC_AVAILABLE
    return ivarsDict;
#else
	return [ivarsDict autorelease];
#endif
    
}

- (NSDictionary *)dictionaryFromSelf
{
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    for (NSString *key in [self ivars])
    {
        if ([self valueForKey:key])
            [dictionary setValue:[self valueForKey:key] forKey:key];
    }
    
#ifdef BEINTOO_ARC_AVAILABLE
    return dictionary;
#else
	return [dictionary autorelease];
#endif
    
}

@end
