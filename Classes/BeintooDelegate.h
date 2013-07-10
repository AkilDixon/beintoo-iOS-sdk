/*******************************************************************************
 * Copyright 2011 Beintoo - author fmessina@beintoo.com
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
#import "BeintooMainDelegate.h"
#import "Beintoo.h"

@interface BeintooDelegate : NSObject <BeintooMainDelegate, BeintooEventDelegate, BeintooRewardDelegate, BeintooAppDelegate>
{
}

- (void)beintooWillAppear;
- (void)beintooDidAppear;
- (void)beintooWillDisappear;
- (void)beintooDidDisappear;


/* -------------------
 * REWARD
 * -------------------*/

- (void)beintooRewardWillAppear;
- (void)beintooRewardDidAppear;
- (void)beintooRewardWillDisappear;
- (void)beintooRewardDidDisappear;

- (void)beintooRewardControllerWillAppear;
- (void)beintooRewardControllerDidAppear;
- (void)beintooRewardControllerWillDisappear;
- (void)beintooRewardControllerDidDisappear;

- (void)didBeintooGenerateAReward:(BRewardWrapper *)reward;
- (void)didBeintooFailToGenerateARewardWithError:(NSDictionary *)error;

/* -------------------
 * AD
 * -------------------*/

- (void)beintooAdControllerWillAppear;
- (void)beintooAdControllerDidAppear;
- (void)beintooAdControllerWillDisappear;
- (void)beintooAdControllerDidDisappear;

- (void)beintooAdWillAppear;
- (void)beintooAdDidAppear;
- (void)beintooAdWillDisappear;
- (void)beintooAdDidDisappear;

- (void)didBeintooGenerateAnAd:(BRewardWrapper *)theAd;
- (void)didBeintooFailToGenerateAnAdWithError:(NSDictionary *)error;


@end
