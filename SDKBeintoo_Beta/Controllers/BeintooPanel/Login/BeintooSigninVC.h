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
#import "BeintooPlayer.h"
#import "BeintooUser.h"

@class BeintooSignupVC;
@class BButton;
@class BView;
@class BeintooPlayer;
@class BeintooSigninAlreadyVC;

@interface BeintooSigninVC : UIViewController <UITextFieldDelegate,BeintooPlayerDelegate,BeintooUserDelegate,UIAlertViewDelegate> {

	IBOutlet UIScrollView *scrollView;
	IBOutlet BView		 *beintooView;
	IBOutlet UITextField *emailTF;
	IBOutlet UITextField *nickTF;
	IBOutlet UILabel	 *title1;
	IBOutlet UITextView	 *disclaimer;
	IBOutlet UIButton	 *facebookButton;
	IBOutlet BButton	 *newUserButton;
	IBOutlet UIButton	 *loginWithDifferent;
	
	BeintooUser		*user;
	BeintooPlayer	*_player;
	BeintooSignupVC *registrationVC;
	BeintooSignupVC *registrationFBVC;
	BeintooSigninAlreadyVC *alreadyRegisteredSigninVC;
	NSString		*newUSerURL;
	NSString		*nickname;
}

- (IBAction)newUser;
- (void)startNickAnimation;
- (BOOL)NSStringIsValidEmail:(NSString *)email;
- (IBAction)loginWithDifferent;
- (IBAction)loginFB;
- (void)generatePlayerIfNotExists;


@property(nonatomic,retain) NSString *nickname;
@property(nonatomic,retain) NSString *caller;

@end
