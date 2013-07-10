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

@interface BGiveBedollarsWrapper : NSObject

@property (nonatomic, retain) NSDictionary *app;
@property (nonatomic, retain) NSNumber *value;
@property (nonatomic, retain) NSString *reason;
@property (nonatomic, retain) NSString *creationdate;
@property (nonatomic, retain) NSString *content;

- (id)initWithContentOfDictionary:(NSDictionary *)dictionary;
- (NSDictionary *)dictionaryFromSelf;
- (id)copyWithZone:(NSZone *)zone;

@end