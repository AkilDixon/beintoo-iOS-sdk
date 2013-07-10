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

extern NSString *BEventObjectTypeScore;
extern NSString *BEventObjectTypeCount;

@interface BEventObject : NSObject

@property (nonatomic, retain) NSString *codeID;
@property (nonatomic, assign) double score;
@property (nonatomic, assign) int count;

- (id)initWithContentOfDictionary:(NSDictionary *)dictionary;
- (NSDictionary *)dictionaryFromEventObject;

@end
