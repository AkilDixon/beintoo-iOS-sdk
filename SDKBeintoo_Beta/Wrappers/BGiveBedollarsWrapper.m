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

#import "BGiveBedollarsWrapper.h"
#import "objc/runtime.h"

@implementation BGiveBedollarsWrapper
@synthesize app, value, content, creationdate, reason;

- (id)initWithCoder:(NSCoder *)coder
{
    self = [super init];
    if (self)
    {
        reason          = ([coder decodeObjectForKey:@"reason"]) ? [[coder decodeObjectForKey:@"reason"] copy] : nil;
        content         = ([coder decodeObjectForKey:@"content"]) ? [[coder decodeObjectForKey:@"content"] copy] : nil;
        creationdate    = ([coder decodeObjectForKey:@"creationdate"]) ? [[coder decodeObjectForKey:@"creationdate"] copy] : nil;
        app             = ([coder decodeObjectForKey:@"app"]) ? [[coder decodeObjectForKey:@"app"] copy] : nil;
        value           = ([coder decodeObjectForKey:@"value"]) ? [NSNumber numberWithDouble:[[[coder decodeObjectForKey:@"value"] copy] doubleValue]] : nil;
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder
{
    if (content != nil)
        [coder encodeObject:content forKey:@"content"];
    
    if (reason != nil)
        [coder encodeObject:reason forKey:@"reason"];
    
    if (creationdate != nil)
        [coder encodeObject:creationdate forKey:@"creationdate"];
    
    if (app != nil)
        [coder encodeObject:app forKey:@"app"];
    
    if (value != nil)
        [coder encodeObject:value forKey:@"value"];
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
    BGiveBedollarsWrapper *object = [[BGiveBedollarsWrapper alloc] init];
    
    object.content          = (object.content != nil) ? [self.content copyWithZone:zone] : nil;
    object.reason           = (object.reason != nil) ? [self.reason copyWithZone:zone] : nil;
    object.creationdate     = (object.creationdate != nil) ? [self.creationdate copyWithZone:zone] : nil;
    object.app              = (object.app != nil) ? [self.app copyWithZone:zone] : nil;
    object.value            = (object.value != nil) ? [self.value copyWithZone:zone] : nil;
    
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
	[reason release];
    [creationdate release];
    [app release];
    [value release];
    
    [super dealloc];
#endif
    
}

@end
