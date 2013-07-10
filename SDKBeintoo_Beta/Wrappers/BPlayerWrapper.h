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

#import <Foundation/Foundation.h>
#import "BeintooDevice.h"

@class BUserWrapper, GetEventInfoBean;

@interface BPlayerWrapper : NSObject
{}

- (id)initWithContentOfDictionary:(NSDictionary *)dictionary;
- (id)copyWithZone:(NSZone *)zone;
- (NSDictionary *)dictionaryFromSelf;

@property (nonatomic, retain) NSString *guid;
@property (nonatomic, retain) NSString *rank;

@property (nonatomic, retain) NSDictionary *language;
@property (nonatomic, retain) BUserWrapper *user;

@property (nonatomic, retain) NSNumber *minSubmitPerMarketplace;
@property (nonatomic, retain) NSNumber *unreadNotification;

@property (nonatomic, retain) NSArray *eventInfoBean;
@property (nonatomic, retain) NSDictionary *vgoodThreshold;

@end
