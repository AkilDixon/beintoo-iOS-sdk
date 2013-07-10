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

#import <UIKit/UIKit.h>
#import "Beintoo.h"

@interface BeintooViewController : UIViewController <BeintooPlayerDelegate, BeintooUserDelegate, BeintooAchievementsDelegate, BeintooAppDelegate, BeintooAdDelegate, BeintooRewardDelegate, BeintooTemplateDelegate, BeintooEventDelegate /*, ZBarReaderDelegate*/>{
	
    //---> Buttons
    IBOutlet BButton *playerLoginButton;
    IBOutlet BButton *logoutButton;
    IBOutlet BButton *achievementButton;
    IBOutlet BButton *rewardButton;
    IBOutlet BButton *giveBedollarsButton;
    IBOutlet BButton *requestAdButton;
    IBOutlet BButton *getEventButton;
    
    IBOutlet BButton *london;
    IBOutlet BButton *milan;
    IBOutlet BButton *sanFrancisco;
    
    IBOutlet UIView     *lightLondon;
    IBOutlet UIView     *lightSanFrancisco;
    IBOutlet UIView     *lightMilan;
    
    IBOutlet UIScrollView *scroll;
    
    BeintooUser         *_user;
}

- (IBAction)openDashboard;
- (IBAction)playerLogin;
- (IBAction)getReward;
- (IBAction)playerLogout;
- (IBAction)submitAchievement;
- (IBAction)giveBedollars;
- (IBAction)requestAd;
- (IBAction)getEvent;

- (IBAction)setMilan;
- (IBAction)setSanFrancisco;
- (IBAction)setLondon;

@end

