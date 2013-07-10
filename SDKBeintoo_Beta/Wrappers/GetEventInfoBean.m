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

#import "GetEventInfoBean.h"
#import "objc/runtime.h"

@implementation GetEventInfoBean
@synthesize codeID, count, score;

#pragma mark - Init methods

- (id)initWithCoder:(NSCoder *)coder
{
    self = [super init];
    if (self)
    {
        codeID  = ([coder decodeObjectForKey:@"value"]) ? [[coder decodeObjectForKey:@"codeID"] copy] : nil;
        count   = ([coder decodeObjectForKey:@"value"]) ? [NSNumber numberWithDouble:[[[coder decodeObjectForKey:@"count"] copy] intValue]] : nil;
        score   = ([coder decodeObjectForKey:@"value"]) ? [NSNumber numberWithDouble:[[[coder decodeObjectForKey:@"score"] copy] doubleValue]] : nil;
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder
{
    if (codeID != nil)
        [coder encodeObject:codeID forKey:@"codeID"];
    
    if (count != nil)
        [coder encodeObject:count forKey:@"count"];
    
    if (score != nil)
        [coder encodeObject:score forKey:@"score"];
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
    GetEventInfoBean *object = [[GetEventInfoBean alloc] init];
    
    object.codeID           = (object.codeID != nil) ? [self.codeID copyWithZone:zone] : nil;
    object.count            = (object.count != nil) ? [self.count copyWithZone:zone] : nil;
    object.score            = (object.score != nil) ? [self.score copyWithZone:zone] : nil;
    
    return object;
}

#pragma mark - private methods

- (NSArray *)ivars
{
    // For debug purpose, print name and type of ivars
    
    NSMutableArray *ivarsDict = [[NSMutableArray alloc] init];
    
    unsigned int _count;
    Ivar *ivars = class_copyIvarList([self class], &_count);
    for(int i = 0; i < _count; i++)
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
	[codeID release];
	[count release];
    [score release];
    
    [super dealloc];
#endif
    
}

@end