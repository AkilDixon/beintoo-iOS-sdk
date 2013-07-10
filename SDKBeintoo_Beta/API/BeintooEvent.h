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
#import "BEventObject.h"
#import "BEventWrapper.h"

@protocol BeintooEventDelegate;

extern NSString *NSUDEventDictionary;

@interface BeintooEvent : NSObject <BeintooParserDelegate>
{
    Parser          *parser;
    id              delegate;
    NSString        *rest_resource;
}

@property (nonatomic, retain) id        delegate;
@property (nonatomic, retain) Parser    *parser;

// Init methods

- (id)initWithDelegate:(id)_delegate;
- (NSString *)restResource;
+ (void)setDelegate:(id)_delegate;

//+ (void)getEventWithAmountOfBedollars:(double)amount score:(double)score code:(NSString *)codeID unlocked:(BOOL)unlocked;
+ (void)getEventWithAmountOfBedollars:(double)amount score:(double)score code:(NSString *)codeID;

+ (void)notifyEventGeneration:(BEventWrapper *)wrapper;
+ (void)notifyEventGenerationError:(NSDictionary *)_error;

@end

@protocol BeintooEventDelegate <NSObject>
@optional

- (void)didGenerateAnEvent:(BEventWrapper *)wrapper;
- (void)didFailToGenerateAnEvent:(NSDictionary *)error;

@end