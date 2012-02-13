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

#import "BeintooSigninFacebookVC.h"
#import "Beintoo.h"


@implementation BeintooSigninFacebookVC

- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.title		 = NSLocalizedStringFromTable(@"login",@"BeintooLocalizable",@"Login");
	titleLabel1.text = NSLocalizedStringFromTable(@"loginOn",@"BeintooLocalizable",@"login");
	titleLabel2.text = NSLocalizedStringFromTable(@"orCreateAccount",@"BeintooLocalizable",@"orCrete");
	
	registrationVC = [BeintooSignupVC alloc];// initWithNibName:@"BeintooSignupVC" bundle:[NSBundle mainBundle] urlToOpen:newUserURL];
	
	self.navigationItem.hidesBackButton = NO;
	if ([[Beintoo getLastLoggedPlayers] count]<1) {
		self.navigationItem.hidesBackButton = YES;
	}
	
	[beintooView setTopHeight:65];
	[beintooView setBodyHeight:362];
	
	_player = [[BeintooPlayer alloc] init];
	
	UIImage *closeImg = [UIImage imageNamed:@"bar_close.png"];
	UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
	[closeBtn setImage:closeImg forState:UIControlStateNormal];
	closeBtn.frame = CGRectMake(0,0, closeImg.size.width+7, closeImg.size.height);
	[closeBtn addTarget:self action:@selector(closeBeintoo) forControlEvents:UIControlEventTouchUpInside];
	UIBarButtonItem *barCloseBtn = [[UIBarButtonItem alloc] initWithCustomView:closeBtn];
	[self.navigationItem setRightBarButtonItem:barCloseBtn animated:YES];
	[barCloseBtn release];
	
	[loginButton setHighColor:[UIColor colorWithRed:156.0/255 green:168.0/255 blue:184.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(156, 2)/pow(255,2) green:pow(168, 2)/pow(255,2) blue:pow(184, 2)/pow(255,2) alpha:1]];
	[loginButton setMediumHighColor:[UIColor colorWithRed:116.0/255 green:135.0/255 blue:159.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(116, 2)/pow(255,2) green:pow(135, 2)/pow(255,2) blue:pow(159, 2)/pow(255,2) alpha:1]];
	[loginButton setMediumLowColor:[UIColor colorWithRed:108.0/255 green:128.0/255 blue:154.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(108, 2)/pow(255,2) green:pow(128, 2)/pow(255,2) blue:pow(154, 2)/pow(255,2) alpha:1]];
    [loginButton setLowColor:[UIColor colorWithRed:89.0/255 green:112.0/255 blue:142.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(89, 2)/pow(255,2) green:pow(112, 2)/pow(255,2) blue:pow(142, 2)/pow(255,2) alpha:1]];
	[loginButton setTitle:NSLocalizedStringFromTable(@"login",@"BeintooLocalizable",@"Login button") forState:UIControlStateNormal];
	
	[newUserButton setHighColor:[UIColor colorWithRed:156.0/255 green:168.0/255 blue:184.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(156, 2)/pow(255,2) green:pow(168, 2)/pow(255,2) blue:pow(184, 2)/pow(255,2) alpha:1]];
	[newUserButton setMediumHighColor:[UIColor colorWithRed:116.0/255 green:135.0/255 blue:159.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(116, 2)/pow(255,2) green:pow(135, 2)/pow(255,2) blue:pow(159, 2)/pow(255,2) alpha:1]];
	[newUserButton setMediumLowColor:[UIColor colorWithRed:108.0/255 green:128.0/255 blue:154.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(108, 2)/pow(255,2) green:pow(128, 2)/pow(255,2) blue:pow(154, 2)/pow(255,2) alpha:1]];
    [newUserButton setLowColor:[UIColor colorWithRed:89.0/255 green:112.0/255 blue:142.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(89, 2)/pow(255,2) green:pow(112, 2)/pow(255,2) blue:pow(142, 2)/pow(255,2) alpha:1]];
	[newUserButton setTitle:NSLocalizedStringFromTable(@"newUser",@"BeintooLocalizable",@"New User") forState:UIControlStateNormal];
}

- (void)viewWillAppear:(BOOL)animated{
    if ([BeintooDevice isiPad]) {
        [self setContentSizeForViewInPopover:CGSizeMake(320, 415)];
    }
}

- (IBAction)newUserWithFB{	
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
		
	NSString *newUserURL;
	
	if ([Beintoo isOnPrivateSandbox]) {
		newUserURL = [NSString stringWithFormat:@"https://sandbox-elb.beintoo.com/connect.html?signup=facebook&apikey=%@&guid=%@&display=touch&redirect_uri=http://sandbox.beintoo.com/m/landing_register_ok.html&logged_uri=http://sandbox.beintoo.com/m/landing_logged.html",
						[Beintoo getApiKey],
						[Beintoo getPlayerID]];
	}
	else {
		newUserURL = [NSString stringWithFormat:@"http://www.beintoo.com/connect.html?signup=facebook&apikey=%@&guid=%@&display=touch&redirect_uri=http://www.beintoo.com/m/landing_register_ok.html&logged_uri=http://www.beintoo.com/m/landing_logged.html",
						[Beintoo getApiKey],
						[Beintoo getPlayerID]];
	}
	[registrationVC initWithNibName:@"BeintooSignupVC" bundle:[NSBundle mainBundle] urlToOpen:newUserURL];
	[self.navigationController pushViewController:registrationVC animated:YES];
}

- (IBAction)loginFB{
	
	if (![BeintooNetwork connectedToNetwork]) {
		[BeintooNetwork showNoConnectionAlert];
		return;
	}
	
	NSString *loginFB;
	
	if ([Beintoo isOnPrivateSandbox]) {
		loginFB = [NSString stringWithFormat:@"https://sandbox-elb.beintoo.com/connect.html?signup=facebook&apikey=%@&display=touch&redirect_uri=http://sandbox.beintoo.com/m/landing_register_ok.html&logged_uri=http://sandbox.beintoo.com/m/landing_welcome.html",
				   [Beintoo getApiKey]];
	}
	else {
		loginFB = [NSString stringWithFormat:@"http://www.beintoo.com/connect.html?signup=facebook&apikey=%@&display=touch&redirect_uri=http://www.beintoo.com/m/landing_register_ok.html&logged_uri=http://www.beintoo.com/m/landing_welcome.html",
				   [Beintoo getApiKey]];
	}

	[registrationVC initWithNibName:@"BeintooSignupVC" bundle:[NSBundle mainBundle] urlToOpen:loginFB];
	[self.navigationController pushViewController:registrationVC animated:YES];		
}

-(void)closeBeintoo{
	
    if([BeintooDevice isiPad]){
		[Beintoo dismissIpadLogin];
	}else {
		[self dismissModalViewControllerAnimated:YES];
	}
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return (interfaceOrientation == [Beintoo appOrientation]);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
    [super viewDidUnload];
}

- (void)dealloc {
	[_player release];
    [super dealloc];
}

@end
