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

#import "BPlayerWrapper.h"
#import "objc/runtime.h"
#import "BUserWrapper.h"

@implementation BPlayerWrapper
@synthesize guid, language, minSubmitPerMarketplace, rank, unreadNotification, user, eventInfoBean, vgoodThreshold;

- (id)initWithCoder:(NSCoder *)coder
{
    self = [super init];
    if (self)
    {
        guid            = ([coder decodeObjectForKey:@"guid"]) ? [[coder decodeObjectForKey:@"guid"] copy] : nil;
        language        = ([coder decodeObjectForKey:@"language"]) ? [[coder decodeObjectForKey:@"language"] copy] : nil;
        rank            = ([coder decodeObjectForKey:@"rank"]) ? [[coder decodeObjectForKey:@"rank"] copy] : nil;
        
        if ([[coder decodeObjectForKey:@"user"] isKindOfClass:[NSDictionary class]])
            user    = [[BUserWrapper alloc] initWithContentOfDictionary:[[coder decodeObjectForKey:@"user"] copy]];
        else
            user    = [[coder decodeObjectForKey:@"user"] copy];
        
        eventInfoBean   = ([coder decodeObjectForKey:@"eventInfoBean"]) ? [[coder decodeObjectForKey:@"eventInfoBean"] copy] : nil;
        vgoodThreshold  = ([coder decodeObjectForKey:@"vgoodThreshold"]) ? [[coder decodeObjectForKey:@"vgoodThreshold"] copy] : nil;
        
        minSubmitPerMarketplace     = ([coder decodeObjectForKey:@"minSubmitPerMarketplace"]) ? [[NSNumber numberWithDouble:[[coder decodeObjectForKey:@"minSubmitPerMarketplace"] doubleValue]] copy] : nil; 
        unreadNotification          = ([coder decodeObjectForKey:@"unreadNotification"]) ? [[NSNumber numberWithDouble:[[coder decodeObjectForKey:@"unreadNotification"] doubleValue]] copy] : nil;
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder
{
    if (guid != nil)
        [coder encodeObject:guid forKey:@"guid"];
    
    if (language != nil)
        [coder encodeObject:language forKey:@"language"];
    
    if (rank != nil)
        [coder encodeObject:rank forKey:@"rank"];
    
    if (user != nil)
        [coder encodeObject:user forKey:@"user"];
    
    if (eventInfoBean != nil)
        [coder encodeObject:eventInfoBean forKey:@"eventInfoBean"];
    
    if (vgoodThreshold != nil)
        [coder encodeObject:vgoodThreshold forKey:@"vgoodThreshold"];
    
    if (minSubmitPerMarketplace != nil)
        [coder encodeObject:minSubmitPerMarketplace forKey:@"minSubmitPerMarketplace"];
    
    if (unreadNotification != nil)
        [coder encodeObject:unreadNotification forKey:@"unreadNotification"];
}

- (id)initWithContentOfDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self)
    {
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
    BPlayerWrapper *object = [[BPlayerWrapper alloc] init];
    
    object.guid             = (object.guid != nil) ? [self.guid copyWithZone:zone] : nil;
    object.language         = (object.language != nil) ? [self.language copyWithZone:zone] : nil;
    object.rank             = (object.rank != nil) ? [self.rank copyWithZone:zone] : nil;
    object.user             = (object.user != nil) ? [self.user copyWithZone:zone] : nil;
    object.eventInfoBean    = (object.eventInfoBean != nil) ? [self.eventInfoBean copyWithZone:zone] : nil;
    object.vgoodThreshold   = (object.vgoodThreshold != nil) ? [self.vgoodThreshold copyWithZone:zone] : nil;
    object.minSubmitPerMarketplace  = (object.minSubmitPerMarketplace != nil) ? [self.minSubmitPerMarketplace copyWithZone:zone] : nil;
    object.unreadNotification       = (object.unreadNotification != nil) ? [self.unreadNotification copyWithZone:zone] : nil;
    
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
	[guid release];
	[language release];
    [rank release];
    [user release];
    [eventInfoBean release];
    [vgoodThreshold release];
    [minSubmitPerMarketplace release];
    [unreadNotification release];
    
    [super dealloc];
#endif
    
}

@end
