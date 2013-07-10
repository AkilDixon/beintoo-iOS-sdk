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
#import "Parser.h"

@class BMissionWrapper;

@protocol BeintooMissionAPIDelegate;

extern NSString *NSUDMissionStoredArray;

@interface BeintooMission : NSObject <BeintooParserDelegate>
{
    Parser                      *parser;
	
    id <BeintooMissionAPIDelegate>  delegate;
	id callingDelegate;
    
    NSString                    *rest_resource;
}

@property (nonatomic, retain) id callingDelegate;
@property (nonatomic, retain) id <BeintooMissionAPIDelegate>  delegate;
@property (nonatomic, retain) Parser          *parser;

// Init methods

- (id)initWithDelegate:(id)_delegate;
- (NSString *)restResource;
+ (void)setDelegate:(id)_delegate;

/* + (void)initMission:(NSString *)missionID;

+ (NSArray *)checkUnlockedMissionsWithScore:(double)score;

+ (void)storeMissionList:(NSMutableArray *)eventList;
+ (NSMutableArray *)storedMissions;

+ (void)emptyMissionList;
+ (BOOL)isMissionAlreadySaved:(BMissionWrapper *)mission;
+ (BOOL)removeMission:(BMissionWrapper *)mission;
+ (void)updateMission:(BMissionWrapper *)mission;
+ (BMissionWrapper *)getMissionByID:(NSString *)missionID;
+ (void)saveMission:(BMissionWrapper *)mission;
*/

+ (NSMutableArray *)dictionarySavedEvent;

@end

@protocol BeintooMissionAPIDelegate <NSObject>
@optional

@end
