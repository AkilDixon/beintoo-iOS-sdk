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

#import "BUserWrapper.h"
#import "objc/runtime.h"

@implementation BUserWrapper
@synthesize userid, userimg, usersmallimg, bedollars, bescore, gender, isverified, language, lastupdate, level, locale, messages, name, nickname, pendingFriendRequest, unreadMessages;

- (id)initWithCoder:(NSCoder *)coder
{
    self = [super init];
    if (self)
    {
        userid          = ([coder decodeObjectForKey:@"id"]) ? [[coder decodeObjectForKey:@"id"] copy] : nil;
        userimg         = ([coder decodeObjectForKey:@"userimg"]) ? [[coder decodeObjectForKey:@"userimg"] copy] : nil;
        usersmallimg    = ([coder decodeObjectForKey:@"usersmallimg"]) ? [[coder decodeObjectForKey:@"usersmallimg"] copy] : nil;
        language        = ([coder decodeObjectForKey:@"language"]) ? [[coder decodeObjectForKey:@"language"] copy] : nil;
        lastupdate      = ([coder decodeObjectForKey:@"lastupdate"]) ? [[coder decodeObjectForKey:@"lastupdate"] copy] : nil;
        locale          = ([coder decodeObjectForKey:@"locale"]) ? [[coder decodeObjectForKey:@"locale"] copy] : nil;
        name            = ([coder decodeObjectForKey:@"name"]) ? [[coder decodeObjectForKey:@"name"] copy] : nil;
        nickname        = ([coder decodeObjectForKey:@"nickname"]) ? [[coder decodeObjectForKey:@"nickname"] copy] : nil;
        
        bedollars       = ([coder decodeObjectForKey:@"bedollars"]) ? [[NSNumber numberWithDouble:[[coder decodeObjectForKey:@"bedollars"] doubleValue]] copy] : nil;
        bescore         = ([coder decodeObjectForKey:@"bescore"]) ? [[NSNumber numberWithDouble:[[coder decodeObjectForKey:@"bescore"] doubleValue]] copy] : nil;
        level           = ([coder decodeObjectForKey:@"level"]) ? [[NSNumber numberWithDouble:[[coder decodeObjectForKey:@"level"] intValue]] copy] : nil;
        messages        = ([coder decodeObjectForKey:@"messages"]) ? [[NSNumber numberWithDouble:[[coder decodeObjectForKey:@"messages"] intValue]] copy] : nil;
        unreadMessages  = ([coder decodeObjectForKey:@"unreadMessages"]) ? [[NSNumber numberWithDouble:[[coder decodeObjectForKey:@"unreadMessages"] intValue]] copy] : nil;
        pendingFriendRequest    = ([coder decodeObjectForKey:@"pendingFriendRequest"]) ? [[NSNumber numberWithDouble:[[coder decodeObjectForKey:@"pendingFriendRequest"] intValue]] copy] : nil;
        gender                  = ([coder decodeObjectForKey:@"gender"]) ? [[NSNumber numberWithDouble:[[coder decodeObjectForKey:@"gender"] intValue]] copy] : nil;
        isverified              = ([coder decodeObjectForKey:@"isverified"]) ? [[NSNumber numberWithDouble:[[coder decodeObjectForKey:@"isverified"] boolValue]] copy] : nil;
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder
{
    if (userid != nil)
        [coder encodeObject:userid forKey:@"userid"];
    
    if (userimg != nil)
        [coder encodeObject:userimg forKey:@"userimg"];
    
    if (usersmallimg != nil)
        [coder encodeObject:usersmallimg forKey:@"usersmallimg"];
    
    if (language != nil)
        [coder encodeObject:language forKey:@"language"];
    
    if (lastupdate != nil)
        [coder encodeObject:lastupdate forKey:@"lastupdate"];
    
    if (locale != nil)
        [coder encodeObject:locale forKey:@"locale"];
    
    if (name != nil)
        [coder encodeObject:name forKey:@"name"];
    
    if (nickname != nil)
        [coder encodeObject:nickname forKey:@"nickname"];
    
    if (bedollars != nil)
        [coder encodeObject:bedollars forKey:@"bedollars"];
    
    if (bescore != nil)
        [coder encodeObject:bescore forKey:@"bescore"];
    
    if (level != nil)
        [coder encodeObject:level forKey:@"level"];
    
    if (messages != nil)
        [coder encodeObject:messages forKey:@"messages"];
    
    if (unreadMessages != nil)
        [coder encodeObject:unreadMessages forKey:@"unreadMessages"];
    
    if (pendingFriendRequest != nil)
        [coder encodeObject:pendingFriendRequest forKey:@"pendingFriendRequest"];
    
    if (gender != nil)
        [coder encodeObject:gender forKey:@"gender"];
    
    if (isverified != nil)
        [coder encodeObject:isverified forKey:@"isverified"];
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
    if ([key isEqualToString:@"id"])
        userid = value;
}

- (id)copyWithZone:(NSZone *)zone
{
    BUserWrapper *object = [[BUserWrapper alloc] init];
    
    object.userid           = (object.userid != nil) ? [self.userid copyWithZone:zone] : nil;
    object.userimg          = (object.userimg != nil) ? [self.userimg copyWithZone:zone] : nil;
    object.usersmallimg     = (object.usersmallimg != nil) ? [self.usersmallimg copyWithZone:zone] : nil;
    object.language         = (object.language != nil) ? [self.language copyWithZone:zone] : nil;
    object.lastupdate       = (object.lastupdate != nil) ? [self.lastupdate copyWithZone:zone] : nil;
    object.locale           = (object.locale != nil) ? [self.locale copyWithZone:zone] : nil;
    object.name             = (object.name != nil) ? [self.name copyWithZone:zone] : nil;
    object.nickname         = (object.nickname != nil) ? [self.nickname copyWithZone:zone] : nil;
    
    object.bedollars        = (object.bedollars != nil) ? [self.bedollars copyWithZone:zone] : nil;
    
    object.bescore                  = (object.bescore != nil) ? [self.bescore copyWithZone:zone] : nil;
    object.level                    = (object.level != nil) ? [self.level copyWithZone:zone] : nil;
    object.messages                 = (object.messages != nil) ? [self.messages copyWithZone:zone] : nil;
    object.unreadMessages           = (object.unreadMessages != nil) ? [self.unreadMessages copyWithZone:zone] : nil;
    object.pendingFriendRequest     = (object.pendingFriendRequest != nil) ? [self.pendingFriendRequest copyWithZone:zone] : nil;
    object.gender                   = (object.gender != nil) ? [self.gender copyWithZone:zone] : nil;
    object.isverified               = (object.isverified != nil) ? [self.isverified copyWithZone:zone] : nil;
    
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
	[userid release];
	[userimg release];
    [usersmallimg release];
    [language release];
    [lastupdate release];
    [locale release];
    [name release];
    [nickname release];
    
    [bedollars release];
	[bescore release];
    [level release];
    [messages release];
    [unreadMessages release];
    [pendingFriendRequest release];
    [gender release];
    [isverified release];
    
    [super dealloc];
#endif
    
}

@end
