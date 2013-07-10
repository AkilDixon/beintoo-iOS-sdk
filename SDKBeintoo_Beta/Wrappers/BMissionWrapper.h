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
#import "BPlayerWrapper.h"
#import <CoreLocation/CoreLocation.h>
#import "BeintooDevice.h"

extern int BMissionWrapperScoreTypeBestPerformance;
extern int BMissionWrapperScoreTypeIncremental;

@interface BMissionWrapper : NSObject
{

}

@property (nonatomic, retain) NSString *missionExtId;
@property (nonatomic, retain) NSString *content;
@property (nonatomic, retain) NSString *contentType;
@property (nonatomic, retain) NSString *codeID;

@property (nonatomic, retain) BPlayerWrapper *player;
@property (nonatomic, retain) NSDictionary *vgood;
@property (nonatomic, retain) NSDictionary *brand;

@property (nonatomic, retain) NSNumber *lat;
@property (nonatomic, retain) NSNumber *lng;
@property (nonatomic, retain) NSNumber *radius;
@property (nonatomic, retain) CLLocation *location;

@property (nonatomic, retain) NSNumber *score;
@property (nonatomic, retain) NSNumber *scoreType;
@property (nonatomic, retain) NSNumber *currentScore;

@property (nonatomic, retain) NSString *startDate;
@property (nonatomic, retain) NSString *endDate;

- (NSDictionary *)dictionaryFromSelf;
- (id)initWithContentOfDictionary:(NSDictionary *)dictionary;
- (id)copyWithZone:(NSZone *)zone;

@end
