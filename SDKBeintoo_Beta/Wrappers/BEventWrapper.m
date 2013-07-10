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

#import "BEventWrapper.h"
#import "objc/runtime.h"

NSString *BEventWrapperTypeVGood            = @"VGOOD";
NSString *BEventWrapperTypeGiveBedollars    = @"GIVEBEDOLLARS";
NSString *BEventWrapperTypeChallenge        = @"CHALLENGE";
NSString *BEventWrapperTypeHtml             = @"HTML";

@implementation BEventWrapper
@synthesize content, contentType, missionWrapper, type;

#pragma mark - Init methods

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

#pragma mark - Encoder methods

- (id)initWithCoder:(NSCoder *)coder
{
    self = [super init];
    if (self)
    {
        content         = ([coder decodeObjectForKey:@"id"]) ? [[coder decodeObjectForKey:@"content"] copy] : nil;
        contentType     = ([coder decodeObjectForKey:@"id"]) ? [[coder decodeObjectForKey:@"contentType"] copy] : nil;
        type            = ([coder decodeObjectForKey:@"id"]) ? [[coder decodeObjectForKey:@"type"] copy] : nil;
        
        if ([coder decodeObjectForKey:@"missionWrapper"])
        {
            if ([[coder decodeObjectForKey:@"missionWrapper"] isKindOfClass:[NSDictionary class]])
                missionWrapper = [[BMissionWrapper alloc] initWithContentOfDictionary:[[coder decodeObjectForKey:@"missionWrapper"] copy]];
            else
                missionWrapper = [[coder decodeObjectForKey:@"missionWrapper"] copy];
        }
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder
{
    if (content != nil)
        [coder encodeObject:content forKey:@"content"];
    
    if (contentType != nil)
        [coder encodeObject:contentType forKey:@"contentType"];
    
    if (type != nil)
        [coder encodeObject:type forKey:@"type"];
    
    if (missionWrapper != nil)
        [coder encodeObject:missionWrapper forKey:@"missionWrapper"];
}

- (id)copyWithZone:(NSZone *)zone
{
    BEventWrapper *object = [[BEventWrapper alloc] init];
    
    object.content              = (object.content != nil) ? [self.content copyWithZone:zone] : nil;
    object.contentType          = (object.contentType != nil) ? [self.contentType copyWithZone:zone] : nil;
    object.type                 = (object.type != nil) ? [self.type copyWithZone:zone] : nil;
    object.missionWrapper       = (object.missionWrapper != nil) ? [self.missionWrapper copyWithZone:zone] : nil;
    
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
    [type release];
    [missionWrapper release];
    
    [super dealloc];
#endif
    
}

@end
