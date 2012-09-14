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
	BeintooLOG(@"Beintoo will appear!");
}

- (void)beintooDidAppear{
	BeintooLOG(@"Beintoo did appear!");
}

- (void)beintooWillDisappear{
	BeintooLOG(@"Beintoo will disappear!");
}

- (void)beintooDidDisappear{
	BeintooLOG(@"Beintoo did disappear!");
}

/* -----------------------------
 * Beintoo Reward
 * ----------------------------- */

- (void)didBeintooGenerateAVirtualGood:(BVirtualGood *)theVgood{
	if ([theVgood isMultiple]) {
		BeintooLOG(@"Multiple Vgood generated: %@",[theVgood theGoodsList]);
	}
	else {
		BeintooLOG(@"Single Vgood generated: %@",[theVgood theGood]);
	}
}

- (void)didBeintooFailToGenerateAVirtualGoodWithError:(NSDictionary *)error{
    BeintooLOG(@"Vgood generation error: %@",error);
}

/*
 * Reward Notifications
 */

- (void)beintooPrizeWillAppear{
	BeintooLOG(@"Prize will appear!");
}

- (void)beintooPrizeDidAppear{
	BeintooLOG(@"Prize did appear!");
}

- (void)beintooPrizeWillDisappear{
	BeintooLOG(@"Prize will disappear!");
}

- (void)beintooPrizeDidDisappear{
	BeintooLOG(@"Prize did disappear!");
}

- (void)beintooPrizeAlertWillAppear{
	BeintooLOG(@"alert will appear");
}
- (void)beintooPrizeAlertDidAppear{
	BeintooLOG(@"alert did appear");
}
- (void)beintooPrizeAlertWillDisappear{
	BeintooLOG(@"alert will disappear");

}
- (void)beintooPrizeAlertDidDisappear{
	BeintooLOG(@"alert did disappear");

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

@end
