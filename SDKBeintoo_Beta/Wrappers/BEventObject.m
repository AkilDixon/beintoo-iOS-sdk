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

#import "BEventObject.h"

@implementation BEventObject

NSString *BEventObjectTypeScore = @"SCORE";
NSString *BEventObjectTypeCount = @"COUNT";

@synthesize codeID, count, score;

- (id)initWithContentOfDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
        if ([dictionary objectForKey:@"codeID"])
            codeID = [dictionary objectForKey:@"codeID"];
        
        if ([dictionary objectForKey:@"count"])
            count = [[dictionary objectForKey:@"count"] intValue];
        
        if ([dictionary objectForKey:@"score"])
            score = [[dictionary objectForKey:@"score"] doubleValue];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)coder
{
    self = [super init];
    if (self)
    {
        codeID = [[coder decodeObjectForKey:@"codeID"] copy];
        count = [[[coder decodeObjectForKey:@"count"] copy] intValue];
        score = [[[coder decodeObjectForKey:@"score"] copy] doubleValue];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder
{
    if (codeID != nil)
        [coder encodeObject:codeID forKey:@"codeID"];
    
    if ([NSNumber numberWithInt:count] != nil)
        [coder encodeObject:[NSNumber numberWithInt:count] forKey:@"count"];
    
    if ([NSNumber numberWithInt:score] != nil)
        [coder encodeObject:[NSNumber numberWithInt:score] forKey:@"score"];
}

- (id)copyWithZone:(NSZone *)zone
{
    BEventObject *object = [[BEventObject alloc] init];
    
    object.codeID       = (self.codeID != nil) ? [self.codeID copyWithZone:zone] : nil;
    object.count        = (self.count) ? self.count : 0;
    object.score        = (self.score) ? self.score : 0;
    
    return object;
}

- (NSDictionary *)dictionaryFromEventObject
{
    return [NSDictionary dictionaryWithObjectsAndKeys:
                                codeID, @"codeID",
                                [NSNumber numberWithInt:score], @"score",
                                [NSNumber numberWithInt:count], @"count",
                                nil];
}


#pragma mark - Dealloc

- (void)dealloc
{
    
#ifdef BEINTOO_ARC_AVAILABLE
#else
	[codeID release];
    
    [super dealloc];
#endif
    
}

@end
