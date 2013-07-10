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

@class BRewardWrapper, BVirtualGood, BGiveBedollarsWrapper, BEventWrapper, BAdWrapper;

@protocol BeintooMainDelegate <NSObject>

@optional

- (void)beintooWillAppear;

- (void)beintooDidAppear;

- (void)beintooWillDisappear;

- (void)beintooDidDisappear;


/* ---------------------------------------------------------------------
 * Reward
 * --------------------------------------------------------------------- */

- (void)beintooPrizeWillAppear __attribute__((deprecated("use 'beintooRewardWillAppear:' instead")));

- (void)beintooPrizeDidAppear __attribute__((deprecated("use 'beintooRewardDidAppear:' instead")));

- (void)beintooPrizeWillDisappear __attribute__((deprecated("use 'beintooRewardWillDisappear:' instead")));

- (void)beintooPrizeDidDisappear __attribute__((deprecated("use 'beintooRewardDidDisappear:' instead")));


- (void)beintooPrizeAlertWillAppear __attribute__((deprecated("use 'beintooRewardControllerWillAppear:' instead")));

- (void)beintooPrizeAlertDidAppear __attribute__((deprecated("use 'beintooRewardControllerDidAppear:' instead")));

- (void)beintooPrizeAlertWillDisappear __attribute__((deprecated("use 'beintooRewardControllerWillDisappear:' instead")));

- (void)beintooPrizeAlertDidDisappear __attribute__((deprecated("use 'beintooRewardControllerDidDisappear:' instead")));



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

- (void)didBeintooGenerateAVirtualGood:(BVirtualGood *)theVgood __attribute__((deprecated("use 'didBeintooGenerateAReward:' instead")));

- (void)didBeintooFailToGenerateAVirtualGoodWithError:(NSDictionary *)error __attribute__((deprecated("use 'didBeintooFailToGenerateARewardWithError:' instead")));


/* ---------------------------------------------------------------------
 * Ad
 * --------------------------------------------------------------------- */

- (void)beintooAdWillAppear;

- (void)beintooAdDidAppear;

- (void)beintooAdWillDisappear;

- (void)beintooAdDidDisappear;


- (void)beintooAdControllerWillAppear;

- (void)beintooAdControllerDidAppear;

- (void)beintooAdControllerWillDisappear;

- (void)beintooAdControllerDidDisappear;


- (void)didBeintooGenerateAnAd:(BAdWrapper *)ad;

- (void)didBeintooFailToGenerateAnAdWithError:(NSDictionary *)error;


/* ---------------------------------------------------------------------
 * User Login/Singup Delegates
 * --------------------------------------------------------------------- */

- (void)beintooUserDidLogin;

- (void)beintooUserDidSignup;

- (void)userDidLogin;

- (void)userDidSignup;

/* ---------------------------------------------------------------------
 * Give Bedollars
 * --------------------------------------------------------------------- */

- (void)beintooGiveBedollarsWillAppear;

- (void)beintooGiveBedollarsDidAppear;

- (void)beintooGiveBedollarsWillDisappear;

- (void)beintooGiveBedollarsDidDisappear;


- (void)beintooGiveBedollarsControllerWillAppear;

- (void)beintooGiveBedollarsControllerDidAppear;

- (void)beintooGiveBedollarsControllerWillDisappear;

- (void)beintooGiveBedollarsControllerDidDisappear;


- (void)didReceiveGiveBedollarsResponse:(BGiveBedollarsWrapper *)wrapper;

- (void)didFailToPerformGiveBedollars:(NSDictionary *)error;

/* ---------------------------------------------------------------------
** Event Delegates
** --------------------------------------------------------------------- */

- (void)didGenerateAnEvent:(BEventWrapper *)wrapper;

- (void)didFailToGenerateAnEvent:(NSDictionary *)error;

@end
