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
#import <CoreLocation/CoreLocation.h>
#import "Parser.h"

#define TO_BE_CONVERTED 40
#define CONVERTED		41

#define B_NOTHING_TO_DISPATCH_ERRORCODE -10
#define B_USER_OVER_QUOTA_ERRORCODE     -11

@class BRewardWrapper;

@protocol BeintooRewardDelegate;

@interface BeintooReward : NSObject <BeintooParserDelegate>
{
	Parser                      *parser;
	id                          delegate;
    NSString                    *rest_resource;
}

+ (void)getReward;
+ (void)getRewardWithDelegate:(id)_delegate;
+ (void)getRewardWithContest:(NSString *)contestID;

+ (void)checkRewardsCoverage;
+ (void)isEligibleForReward;

+ (void)notifyRewardGeneration:(BRewardWrapper *)reward;
+ (void)notifyRewardGenerationError:(NSDictionary *)_error;

// Init methods

- (id)initWithDelegate:(id)_delegate;
- (NSString *)restResource;
+ (void)setDelegate:(id)_delegate;

#ifdef BEINTOO_ARC_AVAILABLE
@property(nonatomic, retain) id delegate;
#else
@property(nonatomic, assign) id delegate;
#endif

@property(nonatomic, retain) Parser  *parser;

@end


@protocol BeintooRewardDelegate <NSObject>

@optional

- (void)didBeintooGenerateAReward:(BRewardWrapper *)reward;
- (void)didBeintooFailToGenerateARewardWithError:(NSDictionary *)error;

- (void)beintooHasRewardsCoverage;
- (void)beintooHasNotRewardsCoverage;

- (void)beintooPlayerIsEligibleForReward;
- (void)beintooPlayerIsNotEligibleForReward;
- (void)beintooPlayerIsOverQuotaForReward;
- (void)beintooPlayerGotNothingToDispatchForReward;

@end
