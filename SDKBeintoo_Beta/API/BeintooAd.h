/*******************************************************************************
 * Copyright 2012 Beintoo
 * Author Giuseppe Piazzese (gpiazzese@beintoo.com)
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
#import "BeintooDevice.h"

@class BAdWrapper;

@protocol BeintooAdDelegate;

@interface BeintooAd : NSObject <BeintooParserDelegate>
{
    Parser          *parser;
    id              delegate;
	
    NSString        *rest_resource;
    NSString        *display_rest_resource;
}

+ (void)requestAndDisplayAdWithDeveloperUserGuid:(NSString *)_developerUserGuid;
+ (void)requestAdWithDeveloperUserGuid:(NSString *)_developerUserGuid;

// Init methods

- (id)initWithDelegate:(id)_delegate;
+ (void)setDelegate:(id)_delegate;
- (NSString *)restResource;
- (NSString *)getDisplayRestResource;

+ (void)notifyAdGeneration:(BAdWrapper *)wrapper;
+ (void)notifyAdGenerationError:(NSDictionary *)error;

#ifdef BEINTOO_ARC_AVAILABLE
@property(nonatomic, retain) id delegate;
#else
@property(nonatomic, assign) id delegate;
#endif

@property(nonatomic,retain) Parser          *parser;

@end


@protocol BeintooAdDelegate <NSObject>
@optional

- (void)didBeintooGenerateAnAd:(BAdWrapper *)wrapper;
- (void)didBeintooFailToGenerateAnAd:(NSDictionary *)error;

@end