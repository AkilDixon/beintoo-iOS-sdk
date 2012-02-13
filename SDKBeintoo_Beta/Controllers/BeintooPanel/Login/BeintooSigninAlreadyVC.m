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

#import "BeintooSigninAlreadyVC.h"
#import "Beintoo.h"
#import <QuartzCore/QuartzCore.h>

@implementation BeintooSigninAlreadyVC

@synthesize caller;

- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.title = NSLocalizedStringFromTable(@"login",@"BeintooLocalizable",@"Login");
	
	registrationVC      = [BeintooSignupVC alloc];
	registrationFBVC    = [BeintooSignupVC alloc];
	
	scrollView.contentSize = CGSizeMake(self.view.bounds.size.width, 440);
	scrollView.backgroundColor = [UIColor colorWithRed:108.0/255 green:128.0/255 blue:154.0/255 alpha:1];
	scrollView.exclusiveTouch = NO;

	[beintooView setTopHeight:60];
	[beintooView setBodyHeight:440];
	[beintooView setIsScrollView:YES];
		
	title1.text = NSLocalizedStringFromTable(@"no_fb_login1",@"BeintooLocalizable",@"");
	title2.text = NSLocalizedStringFromTable(@"no_fb_login2",@"BeintooLocalizable",@"");
	    
	user			 = [[BeintooUser alloc] init];
	user.delegate	 = self;
	_player			 = [[BeintooPlayer alloc]init];
	_player.delegate = self;
	
	
	UIImage *closeImg = [UIImage imageNamed:@"bar_close.png"];
	UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
	[closeBtn setImage:closeImg forState:UIControlStateNormal];
	closeBtn.frame = CGRectMake(0,0, closeImg.size.width+7, closeImg.size.height);
	[closeBtn addTarget:self action:@selector(closeBeintoo) forControlEvents:UIControlEventTouchUpInside];
	UIBarButtonItem *barCloseBtn = [[UIBarButtonItem alloc] initWithCustomView:closeBtn];
	[self.navigationItem setRightBarButtonItem:barCloseBtn animated:YES];
	[barCloseBtn release];
	
	eTF.delegate = self;
	pTF.delegate = self;
	
	[loginButton setHighColor:[UIColor colorWithRed:156.0/255 green:168.0/255 blue:184.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(156, 2)/pow(255,2) green:pow(168, 2)/pow(255,2) blue:pow(184, 2)/pow(255,2) alpha:1]];
	[loginButton setMediumHighColor:[UIColor colorWithRed:116.0/255 green:135.0/255 blue:159.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(116, 2)/pow(255,2) green:pow(135, 2)/pow(255,2) blue:pow(159, 2)/pow(255,2) alpha:1]];
	[loginButton setMediumLowColor:[UIColor colorWithRed:108.0/255 green:128.0/255 blue:154.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(108, 2)/pow(255,2) green:pow(128, 2)/pow(255,2) blue:pow(154, 2)/pow(255,2) alpha:1]];
    [loginButton setLowColor:[UIColor colorWithRed:89.0/255 green:112.0/255 blue:142.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(89, 2)/pow(255,2) green:pow(112, 2)/pow(255,2) blue:pow(142, 2)/pow(255,2) alpha:1]];
	[loginButton setTitle:NSLocalizedStringFromTable(@"loginOn",@"BeintooLocalizable",@"") forState:UIControlStateNormal];
	[loginButton setButtonTextSize:20];
}

- (void)viewDidAppear:(BOOL)animated{
}

- (void)viewWillAppear:(BOOL)animated{
    if ([BeintooDevice isiPad]) {
        [self setContentSizeForViewInPopover:CGSizeMake(320, 415)];
    }
	eTF.text = @"";
	//[eTF becomeFirstResponder];
	pTF.text = @"";
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
	[textField resignFirstResponder];
	return YES;
}


- (IBAction)login{
	
	if (![BeintooNetwork connectedToNetwork]) {
		[BeintooNetwork showNoConnectionAlert];
		return;
	}
	
	[user getUserByM:eTF.text andP:pTF.text];
	if ([pTF isFirstResponder]){
		[pTF resignFirstResponder];
	}else if ([eTF isFirstResponder]) {
		[eTF resignFirstResponder];
	}
    
    [BLoadingView startActivity:self.view];
}

- (void)loginOK{
    
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

#pragma mark -
#pragma mark UserDelegate
- (void)didGetUserByMail:(NSDictionary *)result{
    [BLoadingView stopActivity];
    
	if ([result objectForKey:@"id"]==nil) {
		UIAlertView *errorAV = [[UIAlertView alloc] initWithTitle:NSLocalizedStringFromTable(@"loginError",@"BeintooLocalizable",@"") 
														  message:NSLocalizedStringFromTable(@"loginErrorMsg",@"BeintooLocalizable",@"") 
														 delegate:self 
												cancelButtonTitle:@"Ok" 
												otherButtonTitles:nil];
		[errorAV show];
		[errorAV release];
	}
	if ([result objectForKey:@"id"]!=nil) {
		UIAlertView *successAV = [[UIAlertView alloc] initWithTitle:NSLocalizedStringFromTable(@"loginSuccess",@"BeintooLocalizable",@"") 
														  message:NSLocalizedStringFromTable(@"loginSuccessMsg",@"BeintooLocalizable",@"") 
														 delegate:self 
												cancelButtonTitle:@"Ok" 
												otherButtonTitles:nil];
		successAV.tag = 321;
		[successAV show];
		[successAV release];
		[_player login:[result objectForKey:@"id"]];
	}
}

#pragma mark -
#pragma mark alertViewDelegate

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex{ 
	if (buttonIndex == 0) { 
		if (alertView.tag == 321) {
			[self loginOK];
		}
		[alertView dismissWithClickedButtonIndex:0 animated:YES];
	}
}

- (void)playerDidLogin:(BeintooPlayer *)player{
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return NO;
}

- (void)viewDidUnload {
    [super viewDidUnload];
}

- (void)dealloc {
	[user release];
	[_player release];
	[registrationVC release];
    [super dealloc];
}

@end
