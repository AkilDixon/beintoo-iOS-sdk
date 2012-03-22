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
	NSLog(@"Beintoo will appear!");
}

- (void)beintooDidAppear{
	NSLog(@"Beintoo did appear!");
}

- (void)beintooWillDisappear{
	NSLog(@"Beintoo will disappear!");
}

- (void)beintooDidDisappear{
	NSLog(@"Beintoo did disappear!");
}

/* -----------------------------
 * Beintoo Reward
 * ----------------------------- */

- (void)didBeintooGenerateAVirtualGood:(BVirtualGood *)theVgood{
	if ([theVgood isMultiple]) {
		NSLog(@"Multiple Vgood generated: %@",[theVgood theGoodsList]);
	}
	else {
		NSLog(@"Single Vgood generated: %@",[theVgood theGood]);
	}
}

- (void)didBeintooFailToGenerateAVirtualGoodWithError:(NSDictionary *)error{
    NSLog(@"Vgood generation error: %@",error);
}

/*
 * Reward Notifications
 */

- (void)beintooPrizeWillAppear{
	NSLog(@"Prize will appear!");
}

- (void)beintooPrizeDidAppear{
	NSLog(@"Prize did appear!");
}

- (void)beintooPrizeWillDisappear{
	NSLog(@"Prize will disappear!");
}

- (void)beintooPrizeDidDisappear{
	NSLog(@"Prize did disappear!");
}

- (void)beintooPrizeAlertWillAppear{
	NSLog(@"alert will appear");
}
- (void)beintooPrizeAlertDidAppear{
	NSLog(@"alert did appear");
}
- (void)beintooPrizeAlertWillDisappear{
	NSLog(@"alert will disappear");

}
- (void)beintooPrizeAlertDidDisappear{
	NSLog(@"alert did disappear");

}

/* ---------------------------
 * Beintoo Mission
 * --------------------------- */

- (void)didBeintooGetAMission:(NSDictionary *)theMission{
    NSLog(@"Beintoo mission %@",theMission);
    
}
- (void)didBeintooFailToGetAMission:(NSDictionary *)error{
    NSLog(@"Beintoo mission generation error %@",error);    
}

@end
