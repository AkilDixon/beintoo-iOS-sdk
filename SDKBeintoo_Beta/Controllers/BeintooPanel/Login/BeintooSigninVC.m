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

#import "BeintooSigninVC.h"
#import "Beintoo.h"
#import <QuartzCore/QuartzCore.h>

@implementation BeintooSigninVC

@synthesize nickname, caller;

- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.title = NSLocalizedStringFromTable(@"signup",@"BeintooLocalizable",@"Login");
	
	registrationVC	 = [BeintooSignupVC alloc];
	registrationFBVC = [BeintooSignupVC alloc];
	alreadyRegisteredSigninVC = [[BeintooSigninAlreadyVC alloc] initWithNibName:@"BeintooSigninAlreadyVC" bundle:[NSBundle mainBundle]];
	
	nickname = [[NSString alloc] init];
	
    [beintooView setTopHeight:0];
	[beintooView setBodyHeight:480];
	[beintooView setIsScrollView:YES];
    
	scrollView.contentSize = CGSizeMake(self.view.bounds.size.width, 440);
	scrollView.backgroundColor = [UIColor colorWithRed:108.0/255 green:128.0/255 blue:154.0/255 alpha:1];
    [scrollView setContentOffset:CGPointMake(0, 0) animated:NO];
			
	self.navigationItem.hidesBackButton = NO;
	if ([[Beintoo getLastLoggedPlayers] count]<1) {
		self.navigationItem.hidesBackButton = YES;
	}
	
	user			= [[BeintooUser alloc] init];
	user.delegate	= self;
	_player			= [[BeintooPlayer alloc]init];
	_player.delegate = self;
	
	
	UIImage *closeImg = [UIImage imageNamed:@"bar_close.png"];
	UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
	[closeBtn setImage:closeImg forState:UIControlStateNormal];
	closeBtn.frame = CGRectMake(0,0, closeImg.size.width+7, closeImg.size.height);
	[closeBtn addTarget:self action:@selector(closeBeintoo) forControlEvents:UIControlEventTouchUpInside];
	UIBarButtonItem *barCloseBtn = [[UIBarButtonItem alloc] initWithCustomView:closeBtn];
	[self.navigationItem setRightBarButtonItem:barCloseBtn animated:YES];
	[barCloseBtn release];	
	
	emailTF.delegate = self;
	nickTF.delegate = self;
    
    emailTF.text = @"";
	emailTF.placeholder = @"email";
	emailTF.hidden = NO;
	title1.text = NSLocalizedStringFromTable(@"enteremail",@"BeintooLocalizable",@"");
	title1.numberOfLines = 2;
	title1.textAlignment = UITextAlignmentCenter;
	
	[newUserButton setHighColor:[UIColor colorWithRed:156.0/255 green:168.0/255 blue:184.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(156, 2)/pow(255,2) green:pow(168, 2)/pow(255,2) blue:pow(184, 2)/pow(255,2) alpha:1]];
	[newUserButton setMediumHighColor:[UIColor colorWithRed:116.0/255 green:135.0/255 blue:159.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(116, 2)/pow(255,2) green:pow(135, 2)/pow(255,2) blue:pow(159, 2)/pow(255,2) alpha:1]];
	[newUserButton setMediumLowColor:[UIColor colorWithRed:108.0/255 green:128.0/255 blue:154.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(108, 2)/pow(255,2) green:pow(128, 2)/pow(255,2) blue:pow(154, 2)/pow(255,2) alpha:1]];
    [newUserButton setLowColor:[UIColor colorWithRed:89.0/255 green:112.0/255 blue:142.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(89, 2)/pow(255,2) green:pow(112, 2)/pow(255,2) blue:pow(142, 2)/pow(255,2) alpha:1]];
	[newUserButton setButtonTextSize:20];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    newUserButton.clipsToBounds = YES;
    
    if ([BeintooDevice isiPad]) {
        [self setContentSizeForViewInPopover:CGSizeMake(320, 415)];
    }
    
    if (![BeintooDevice isiPad]) {
        if ([Beintoo appOrientation] == UIInterfaceOrientationLandscapeRight || 
            [Beintoo appOrientation] == UIInterfaceOrientationLandscapeLeft) {
            beintooView.frame = CGRectMake(0, 0, 480,450);
        }
        else{
            beintooView.frame = CGRectMake(0, 0, 320,440);
        }
    }
    
    self.navigationItem.hidesBackButton = NO;
	if ([[Beintoo getLastLoggedPlayers] count] < 1) {
		self.navigationItem.hidesBackButton = YES;
	}


	disclaimer.text = NSLocalizedStringFromTable(@"registrationDisclaim",@"BeintooLocalizable",@"Login");
	
	[newUserButton setTitle:NSLocalizedStringFromTable(@"startBtn",@"BeintooLocalizable",@"") forState:UIControlStateNormal];
	[newUserButton removeTarget:self action:@selector(confirmNickname) forControlEvents:UIControlEventTouchUpInside];
	[newUserButton addTarget:self action:@selector(newUser) forControlEvents:UIControlEventTouchUpInside];
	
	[loginWithDifferent setTitle:NSLocalizedStringFromTable(@"loginExistingBtn",@"BeintooLocalizable",@"") forState:UIControlStateNormal];
	[loginWithDifferent setTitle:NSLocalizedStringFromTable(@"loginExistingBtn",@"BeintooLocalizable",@"") forState:UIControlStateHighlighted];
	[loginWithDifferent setTitle:NSLocalizedStringFromTable(@"loginExistingBtn",@"BeintooLocalizable",@"") forState:UIControlStateSelected];

	nickTF.text = @"";
	nickTF.hidden = YES;
	
	loginWithDifferent.hidden = NO;
	facebookButton.hidden = NO;
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
    
    if (![BeintooDevice isiPad]) {
        if ([Beintoo appOrientation] == UIInterfaceOrientationLandscapeRight || 
            [Beintoo appOrientation] == UIInterfaceOrientationLandscapeLeft) {
            beintooView.frame = CGRectMake(0, 0, 480,450);
        }
        else{
            beintooView.frame = CGRectMake(0, 0, 320,440);
        }
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
	[textField resignFirstResponder];
	return YES;
}


- (IBAction)loginWithDifferent{
	[self.navigationController pushViewController:alreadyRegisteredSigninVC animated:YES];
}


#pragma mark -
#pragma mark newUser Process

- (IBAction)newUser{
	
	if (![BeintooNetwork connectedToNetwork]) {
		[BeintooNetwork showNoConnectionAlert];
		return;
	}
	
	NSString *userEmail = emailTF.text;
	if (![self NSStringIsValidEmail:userEmail]) {
		
		UIAlertView *errorAV = [[UIAlertView alloc] initWithTitle:NSLocalizedStringFromTable(@"loginError",@"BeintooLocalizable",@"") 
														  message:NSLocalizedStringFromTable(@"regEmailErrorMessage",@"BeintooLocalizable",@"") 
														 delegate:self 
												cancelButtonTitle:@"Ok" 
												otherButtonTitles:nil];
		[errorAV show];
		[errorAV release];
		return;
	}
		  
	[self generatePlayerIfNotExists];
		
	NSRange range	= [userEmail rangeOfString:@"@"];
	self.nickname	= [userEmail substringToIndex:range.location];
	
	[BLoadingView startActivity:self.view];

	[user registerUserToGuid:[Beintoo getPlayerID] withEmail:userEmail nickname:self.nickname password:nil name:nil country:nil address:nil gender:nil sendGreetingsEmail:YES];
}

#pragma mark -
#pragma mark Player-User Delegates

- (void)didCompleteRegistration:(NSDictionary *)result{
    if ([result objectForKey:@"message"] != nil) {
        [BLoadingView stopActivity];
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Beintoo" message:NSLocalizedStringFromTable(@"useralreadyregistered",@"BeintooLocalizable",@"")  delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [av show];
        [av release];
    }
    else{
        NSString *newUserID = [result objectForKey:@"id"];
        
        if (newUserID!=nil) {
            [_player login:newUserID];
        }
    }
}

- (void)playerDidLogin:(BeintooPlayer *)player{
   
    if ([Beintoo getUserID]!=nil) {
		[BLoadingView stopActivity];
		[self startNickAnimation];
	}
    else{
        [BLoadingView stopActivity];
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Beintoo" message:NSLocalizedStringFromTable(@"useralreadyregistered",@"BeintooLocalizable",@"")  delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [av show];
        [av release];
    }
}

- (void)confirmNickname{
	NSString *newNickname = emailTF.text;
	[BLoadingView startActivity:self.view];
	[user updateUser:[Beintoo getUserID] withNickname:newNickname];
	[emailTF resignFirstResponder];
}

- (void)didCompleteUserNickUpdate:(NSDictionary *)result{

	if ([result objectForKey:@"message"]==nil) {
		// Dismiss login
		if ([caller isEqualToString:@"MarketplaceList"] || [caller isEqualToString:@"MarketplaceSelectedCoupon"]){
            if([BeintooDevice isiPad]){
                [Beintoo dismissIpadLogin];
            }
            else {
                [self dismissModalViewControllerAnimated:YES];
            }
        }
		else if([BeintooDevice isiPad]){
            if ([Beintoo dismissBeintooOnRegistrationEnd]) {
                [Beintoo dismissBeintoo];
            }
            else{
                [Beintoo dismissIpadLogin];
            }
		}else {
            if ([Beintoo dismissBeintooOnRegistrationEnd]) {
                [Beintoo dismissBeintooNotAnimated];
                [self dismissModalViewControllerAnimated:YES];
            }
            else{
                [self dismissModalViewControllerAnimated:YES];
            }
		}
        
	}
}

#pragma mark -
#pragma mark emailValidation

- (BOOL)NSStringIsValidEmail:(NSString *)email{
	NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@(?:[A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}";
	NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
	BOOL isValid = [emailTest evaluateWithObject:email];
	
	return isValid;	
}

#pragma mark -
#pragma mark nicknameAnimation

- (void)startNickAnimation{
	
	CATransition *signFormAnimation = [CATransition animation];
	[signFormAnimation setDuration:0.3f];
	[signFormAnimation setValue:@"formAnimationStart" forKey:@"name"];
	signFormAnimation.removedOnCompletion = YES;
	[signFormAnimation setType:kCATransitionPush];
	signFormAnimation.subtype = kCATransitionFromRight;
	signFormAnimation.delegate = self;
	[signFormAnimation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
	emailTF.alpha = 0;
	title1.alpha = 0;
	[[emailTF layer] addAnimation:signFormAnimation forKey:nil];
	[[title1 layer] addAnimation:signFormAnimation forKey:nil];
}

- (void)closeNickAnimation{
	CATransition *signFormAnimation = [CATransition animation];
	[signFormAnimation setDuration:0.3f];
	[signFormAnimation setValue:@"formAnimationDisappear" forKey:@"name"];
	signFormAnimation.removedOnCompletion = YES;
	[signFormAnimation setType:kCATransitionPush];
	signFormAnimation.subtype = kCATransitionFromRight;
	signFormAnimation.delegate = self;
	[signFormAnimation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
	emailTF.alpha = 1;
	title1.alpha = 1;
	[[emailTF layer] addAnimation:signFormAnimation forKey:@"Show"];
	[[title1 layer] addAnimation:signFormAnimation forKey:nil];

	emailTF.text = self.nickname;
	title1.text = NSLocalizedStringFromTable(@"confirmNickname",@"BeintooLocalizable",@"");
	[newUserButton setTitle:NSLocalizedStringFromTable(@"confirmNickBtn",@"BeintooLocalizable",@"") forState:UIControlStateNormal];
	[newUserButton removeTarget:self action:@selector(newUser) forControlEvents:UIControlEventTouchUpInside];
	[newUserButton addTarget:self action:@selector(confirmNickname) forControlEvents:UIControlEventTouchUpInside];
	
	loginWithDifferent.hidden = YES;
	facebookButton.hidden = YES;
}

- (void)animationDidStop:(CAAnimation *)animation finished:(BOOL)flag{
	if ([[animation valueForKey:@"name"] isEqualToString:@"formAnimationStart"]) {
		[self closeNickAnimation];
	}
}

#pragma mark -
#pragma mark LoginFacebook

- (IBAction)loginFB{
	
	if (![BeintooNetwork connectedToNetwork]) {
		[BeintooNetwork showNoConnectionAlert];
		return;
	}
	
	[self generatePlayerIfNotExists];
	
	NSString *loginFBURL;

	if ([Beintoo isOnPrivateSandbox]) {
		loginFBURL = [NSString stringWithFormat:@"http://sandbox.beintoo.com/connect.html?signup=facebook&apikey=%@&guid=%@&display=touch&redirect_uri=http://sandbox.beintoo.com/m/landing_register_ok.html&logged_uri=http://sandbox.beintoo.com/m/landing_logged.html",
					  [Beintoo getApiKey],
					  [Beintoo getPlayerID]];
	}
	else {
		loginFBURL = [NSString stringWithFormat:@"https://www.beintoo.com/connect.html?signup=facebook&apikey=%@&guid=%@&display=touch&redirect_uri=https://www.beintoo.com/m/landing_register_ok.html&logged_uri=https://www.beintoo.com/m/landing_logged.html",
					  [Beintoo getApiKey],
					  [Beintoo getPlayerID]];
	}
	
	
	[registrationFBVC initWithNibName:@"BeintooSignupVC" bundle:[NSBundle mainBundle] urlToOpen:loginFBURL];
	[self.navigationController pushViewController:registrationFBVC animated:YES];
}

#pragma mark -
#pragma mark GeneratePlayer

- (void)generatePlayerIfNotExists{
	if ([Beintoo getPlayerID]==nil) {
		NSDictionary *anonymPlayer = [_player blockingLogin:@""];
		if ([anonymPlayer objectForKey:@"guid"]==nil) {
			// This is a critical point, if the anonymPlayer is == nil, we're going to register an invalid user
			// We prevent this checking if we received a valid guid.
			
			[BeintooNetwork showNoConnectionAlert];
			return;
		}
		else 
			[Beintoo setBeintooPlayer:anonymPlayer];
	}
}

-(void)closeBeintoo{
    
    if ([caller isEqualToString:@"MarketplaceList"] || [caller isEqualToString:@"MarketplaceSelectedCoupon"]){
        if([BeintooDevice isiPad]){
            [Beintoo dismissIpadLogin];
        }
        else {
            [self dismissModalViewControllerAnimated:YES];
        }
    }
    else if([BeintooDevice isiPad]){
		[Beintoo dismissIpadLogin];
	}else {
		[self dismissModalViewControllerAnimated:YES];
	}
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return (interfaceOrientation == [Beintoo appOrientation]);
}

- (void)viewWillDisappear:(BOOL)animated{

    @try {
		[BLoadingView stopActivity];
	}
	@catch (NSException * e) {
	}

	if ([emailTF isFirstResponder]) {
		[emailTF resignFirstResponder];
	}
	
	if ([nickTF isFirstResponder]) {
		[nickTF resignFirstResponder];
	}
}

- (void)viewDidUnload {
    [super viewDidUnload];
}

- (void)dealloc {
	[user release];
	[_player release];
	[registrationVC release];
	[nickname release];
	[alreadyRegisteredSigninVC release];
    [super dealloc];
}

@end
