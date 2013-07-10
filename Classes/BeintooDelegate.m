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

#import "BeintooDelegate.h"
#import "Beintoo.h"

@implementation BeintooDelegate

/* -----------------------------------------
 * BeintooPanel
 * ----------------------------------------- */

- (void)beintooWillAppear{
	BeintooLOG(@"Main Delegate: Beintoo will appear!");
}

- (void)beintooDidAppear{
	BeintooLOG(@"Main Delegate: Beintoo did appear!");
}

- (void)beintooWillDisappear{
	BeintooLOG(@"Main Delegate: Beintoo will disappear!");
}

- (void)beintooDidDisappear{
	BeintooLOG(@"Main Delegate: Beintoo did disappear!");
}

/* -----------------------------
 * Beintoo Reward
 * ----------------------------- */

- (void)didBeintooGenerateAReward:(BRewardWrapper *)reward
{
    BeintooLOG(@"Main Delegate: Reward generated: %@", [reward dictionaryFromSelf]);
}

- (void)didBeintooFailToGenerateARewardWithError:(NSDictionary *)error
{
    BeintooLOG(@"Main Delegate: Reward generation error: %@", error);
}

- (void)beintooRewardHasBeenClosed{
    NSLog(@"Main Delegate: beintoo Reward HasBeenClosed");
}

- (void)beintooRewardHasBeenTapped{
    NSLog(@"Main Delegate: beintoo RewardHasBeenTapped");
}

/*
 * Reward Notifications
 */

- (void)beintooRewardWillAppear{
	BeintooLOG(@"Main Delegate: Reward will appear!");
}

- (void)beintooRewardDidAppear{
	BeintooLOG(@"Main Delegate: Reward did appear!");
}

- (void)beintooRewardWillDisappear{
	BeintooLOG(@"Main Delegate: Reward will disappear!");
}

- (void)beintooRewardDidDisappear{
	BeintooLOG(@"Main Delegate: Reward did disappear!");
}

- (void)beintooRewardControllerWillAppear{
	BeintooLOG(@"Main Delegate: RewardController will appear");
}

- (void)beintooRewardControllerDidAppear{
	BeintooLOG(@"Main Delegate: RewardController did appear");
}

- (void)beintooRewardControllerWillDisappear{
	BeintooLOG(@"Main Delegate: RewardController will disappear");

}
- (void)beintooRewardControllerDidDisappear{
	BeintooLOG(@"Main Delegate: RewardController did disappear");
}

/*
** Ad Notifications
*/

- (void)beintooAdWillAppear{
	BeintooLOG(@"Main Delegate: Ad will appear!");
}

- (void)beintooAdDidAppear{
	BeintooLOG(@"Main Delegate: Ad did appear!");
}

- (void)beintooAdDidDisappear{
	BeintooLOG(@"Main Delegate: Ad did disappear!");
}

- (void)beintooAdWillDisappear{
	BeintooLOG(@"Main Delegate: Ad will disappear!");
}

- (void)beintooAdControllerWillAppear{
	BeintooLOG(@"Main Delegate: Ad Controller will appear!");
}

- (void)beintooAdControllerDidAppear;{
	BeintooLOG(@"Main Delegate: Ad Controller did appear!");
}

- (void)beintooAdControllerDidDisappear{
	BeintooLOG(@"Main Delegate: Ad Controller did disappear!");
}

- (void)beintooAdControllerWillDisappear{
	BeintooLOG(@"Main Delegate: Ad Controller will disappear!");
}

- (void)didBeintooGenerateAnAd:(BVirtualGood *)theAd{
    BeintooLOG(@"Main Delegate: New Ad has been generated!");
}

- (void)didBeintooFailToGenerateAnAdWithError:(NSDictionary *)error{
    BeintooLOG(@"Main Delegate: Failed while generating a new Ad!");
}

/* ---------------------------
 * Give Bedollars
 * --------------------------- */

- (void)beintooGiveBedollarsWillAppear{
	BeintooLOG(@"Main Delegate: Give Bedollars will appear!");
}

- (void)beintooGiveBedollarsDidAppear{
	BeintooLOG(@"Main Delegate: Give Bedollars did appear!");
}

- (void)beintooGiveBedollarsWillDisappear{
	BeintooLOG(@"Main Delegate: Give Bedollars will disappear!");
}

- (void)beintooGiveBedollarsDidDisappear{
	BeintooLOG(@"Main Delegate: Give Bedollars did disappear!");
}

- (void)beintooGiveBedollarsControllerWillAppear{
	BeintooLOG(@"Main Delegate: Give Bedollars Controller will appear");
}

- (void)beintooGiveBedollarsControllerDidAppear{
	BeintooLOG(@"Main Delegate: Give Bedollars Controller did appear");
}

- (void)beintooGiveBedollarsControllerWillDisappear{
	BeintooLOG(@"Main Delegate: Give Bedollars Controller will disappear");
}

- (void)beintooGiveBedollarsControllerDidDisappear{
	BeintooLOG(@"Main Delegate: Give Bedollars Controller did disappear");
}

- (void)didReceiveGiveBedollarsResponse:(BGiveBedollarsWrapper *)wrapper
{
    BeintooLOG(@"Main Delegate: Give Bedollars response %@", [wrapper dictionaryFromSelf]);
}

- (void)didFailToPerformGiveBedollars:(NSDictionary *)error
{
    BeintooLOG(@"Main Delegate: Give Bedollars generation error %@", error);
}

/* ---------------------------
 * Beintoo Mission
 * --------------------------- */

- (void)didBeintooGetAMission:(NSDictionary *)theMission{
    BeintooLOG(@"Beintoo mission %@",theMission);
    
}
- (void)didBeintooFailToGetAMission:(NSDictionary *)error{
    BeintooLOG(@"Beintoo mission generation error %@",error);    
}


/* ---------------------------
 * Beintoo Event
 * --------------------------- */

- (void)didGenerateAnEvent:(BEventWrapper *)wrapper
{
    BeintooLOG(@"Main Delegate: generated an Event %@", [wrapper dictionaryFromSelf]);
}
- (void)didFailToGenerateAnEvent:(NSDictionary *)error{
    BeintooLOG(@"Main Delegate: Event generation error %@",error);
}

@end
