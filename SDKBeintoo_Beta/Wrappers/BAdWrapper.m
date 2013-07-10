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

#import "BAdWrapper.h"
#import "objc/runtime.h"

@implementation BAdWrapper
@synthesize bedollars, content, contentType, enddate, isBanner, name, rewardText, startdate;

- (id)initWithCoder:(NSCoder *)coder
{
    self = [super init];
    if (self)
    {
        content         = ([coder decodeObjectForKey:@"content"]) ? [[coder decodeObjectForKey:@"content"] copy] : nil;
        contentType     = ([coder decodeObjectForKey:@"contentType"]) ? [[coder decodeObjectForKey:@"contentType"] copy] : nil;
        name            = ([coder decodeObjectForKey:@"name"]) ? [[coder decodeObjectForKey:@"name"] copy] : nil;
        rewardText      = ([coder decodeObjectForKey:@"rewardText"]) ? [[coder decodeObjectForKey:@"rewardText"] copy] : nil;
        
        enddate         = ([coder decodeObjectForKey:@"enddate"]) ? [[coder decodeObjectForKey:@"enddate"] copy] : nil;
        startdate       = ([coder decodeObjectForKey:@"startdate"]) ? [[coder decodeObjectForKey:@"startdate"] copy] : nil;
        
        bedollars       = ([coder decodeObjectForKey:@"bedollars"]) ? [NSNumber numberWithDouble:[[[coder decodeObjectForKey:@"bedollars"] copy] doubleValue]] : nil;
        isBanner        = ([coder decodeObjectForKey:@"isBanner"]) ? [NSNumber numberWithDouble:[[[coder decodeObjectForKey:@"isBanner"] copy] boolValue]] : nil;
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder
{
    if (content != nil)
        [coder encodeObject:content forKey:@"content"];
    
    if (contentType != nil)
        [coder encodeObject:contentType forKey:@"contentType"];
    
    if (name != nil)
        [coder encodeObject:name forKey:@"name"];
    
    if (rewardText != nil)
        [coder encodeObject:rewardText forKey:@"rewardText"];
    
    if (enddate != nil)
        [coder encodeObject:enddate forKey:@"enddate"];
    
    if (startdate != nil)
        [coder encodeObject:startdate forKey:@"startdate"];
    
    if (bedollars != nil)
        [coder encodeObject:bedollars forKey:@"bedollars"];
    
    if (isBanner != nil)
        [coder encodeObject:isBanner forKey:@"isBanner"];
}

- (id)initWithContentOfDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
        
        [self setValuesForKeysWithDictionary:dictionary];
    }
    return self;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    // add here keys not present in the API Wrapper
}

- (id)copyWithZone:(NSZone *)zone
{
    BAdWrapper *object = [[BAdWrapper alloc] init];
    
    object.content          = (object.content != nil) ? [self.content copyWithZone:zone] : nil;
    object.contentType      = (object.contentType != nil) ? [self.contentType copyWithZone:zone] : nil;
    object.name             = (object.name != nil) ? [self.name copyWithZone:zone] : nil;
    object.rewardText       = (object.rewardText != nil) ? [self.rewardText copyWithZone:zone] : nil;
    object.enddate          = (object.enddate != nil) ? [self.enddate copyWithZone:zone] : nil;
    object.startdate        = (object.startdate != nil) ? [self.startdate copyWithZone:zone] : nil;
    object.bedollars        = (object.bedollars != nil) ? [self.bedollars copyWithZone:zone] : nil;
    object.isBanner         = (object.isBanner != nil) ? [self.isBanner copyWithZone:zone] : nil;
    
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

#pragma mark - Dealloc

- (void)dealloc
{
    
#ifdef BEINTOO_ARC_AVAILABLE
#else
	[content release];
	[contentType release];
    [name release];
    [rewardText release];
    [enddate release];
    [startdate release];
    [bedollars release];
    [isBanner release];
    
    [super dealloc];
#endif
    
}

@end