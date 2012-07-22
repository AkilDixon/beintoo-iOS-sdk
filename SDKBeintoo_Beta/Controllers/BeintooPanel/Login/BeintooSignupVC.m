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

//static NSString* kAppId = @"152837841401121";

@implementation BeintooSignupVC

@synthesize urlToOpen, registrationWebView, caller;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil urlToOpen:(NSString *)URL {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
		self.urlToOpen = URL;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.title = @"Beintoo";
	
	/* Loading indicator */
	loadingIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
	loadingIndicator.hidesWhenStopped = YES;
	[self.view addSubview:loadingIndicator];	
	
	// Registration View Initial Settings
	self.registrationWebView.delegate = self;
	self.registrationWebView.scalesPageToFit = YES;
	
	_player = [[BeintooPlayer alloc] init];
	_player.delegate = self;
}

- (void)viewWillAppear:(BOOL)animated{
    if ([BeintooDevice isiPad]) {
        [self setContentSizeForViewInPopover:CGSizeMake(320, 415)];
    }

    [loadingIndicator stopAnimating];
    loadingIndicator.center = CGPointMake((self.view.bounds.size.width/2)-5, (self.view.bounds.size.height/2)-30);
    
	NSHTTPCookie *cookie;
	NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
	
    // Here we delete all facebbok cookies, to prevent the auto-login of another user
	for (cookie in [storage cookies]) {
        if ([[cookie domain] isEqualToString:@".facebook.com"] || [[cookie name] isEqualToString:@"fbs_152837841401121"]) {
            [storage deleteCookie:cookie];
        }
	}
    
	
	//[_facebook logout:self];
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlToOpen]];
	[request setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
	[self.registrationWebView loadRequest:request];	
}

#pragma mark -
#pragma mark WebViewDelegates

- (void)webViewDidStartLoad:(UIWebView *)theWebView{
    [loadingIndicator startAnimating];}

- (void)webViewDidFinishLoad:(UIWebView *)theWebView{
    
    [loadingIndicator stopAnimating];
	
	@try {
		NSString *url = [[[theWebView request] URL] absoluteString];
		NSRange id_range		= [url rangeOfString:@"userext="];
		NSString *ext_id = nil;
		
		//NSLog(@"url :%@ \n\n",url);

		if( (id_range.location < 200) && ([url rangeOfString:@"#close"].location>200) && ([url rangeOfString:@"already_logged.html"].location>200) ) {
			ext_id = [url substringFromIndex:(id_range.location+id_range.length)];
			[_player login:ext_id];	
		}
	}
	@catch (NSException * e) {
	}
}

- (BOOL)webView:(UIWebView*)webView shouldStartLoadWithRequest:(NSURLRequest*)request navigationType:(UIWebViewNavigationType)navigationType{

	@try {
		NSString *url           = [[request URL] absoluteString];
		NSRange registr_ok		= [url rangeOfString:@"#close"]; // Welcome in beintoo (registration ok)
		NSRange logged_ok		= [url rangeOfString:@"#close_login"];    // Welcome back! You are now logged in
		//NSRange closeFacebook	= [url rangeOfString:@"error_reason=user_denied"];
		NSRange backButton		= [url rangeOfString:@"back"];			  // Already registered with this account, please go to login	
		
		if(registr_ok.location != NSNotFound){
			[_player getPlayerByGUID:[Beintoo getPlayerID]]; 
		}
		
		if (logged_ok.location != NSNotFound) {
			//[player getPlayerByGUID:[Beintoo getPlayerID]]; 
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
		if (backButton.location != NSNotFound) {
			[self.navigationController popViewControllerAnimated:YES];
		}
	}
	@catch (NSException * e) {
		//[_player logException:[NSString stringWithFormat:@"STACK: %@\n\nException: %@",[NSThread callStackSymbols],e]];

	}
	return YES;
}

#pragma mark Delegates
- (void)player:(BeintooPlayer *)player getPlayerByGUID:(NSDictionary *)result{
	[Beintoo setBeintooPlayer:result];	
	[_player login];
	[Beintoo setUserLogged:YES];
	
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

- (void)playerDidLogin:(BeintooPlayer *)player{
	if ([Beintoo getUserIfLogged] != nil) {
        
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
        
		/*if([BeintooDevice isiPad]){
			[Beintoo dismissIpadLogin];
		}else {
			[self dismissModalViewControllerAnimated:NO];
		}*/
	}
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return (interfaceOrientation == [Beintoo appOrientation]);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];    
}

- (void):(BOOL)animated {
    [super viewDidDisappear:animated];
	[self.registrationWebView loadHTMLString:@"<html><head></head><body></body></html>" baseURL:nil];
}

- (void)viewDidUnload {
    [super viewDidUnload];
}

- (void)viewWillDisappear:(BOOL)animated {
    @try {
		[BLoadingView stopActivity];
	}
	@catch (NSException * e) {
	}
}
- (void)dealloc {
	[_player release];
    [super dealloc];
}

@end
