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

#import "BeintooVGoodShowVC.h"
#import "Beintoo.h"

@implementation BeintooVGoodShowVC

@synthesize urlToOpen, caller, callerIstance, callerIstanceMP;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil urlToOpen:(NSString *)URL {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
		self.urlToOpen = URL;
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
		
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.title = @"Beintoo";
    
    beintooPlayer = [[BeintooPlayer alloc] init];
	
	if (self.navigationItem != nil) {
		UIBarButtonItem *barCloseBtn = [[UIBarButtonItem alloc] initWithCustomView:[self closeButton]];
        [self.navigationItem setRightBarButtonItem:barCloseBtn animated:YES];
        [barCloseBtn release];
	}
	
	loadingIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
	loadingIndicator.hidesWhenStopped = YES;
	[self.view addSubview:loadingIndicator];
		
	vGoodWebView.delegate = self;
	vGoodWebView.scalesPageToFit = YES;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    beintooPlayer.delegate = self;
    
    [loadingIndicator stopAnimating];
    	
    if ([BeintooDevice isiPad]) {
        [self setContentSizeForViewInPopover:CGSizeMake(320, 415)];
    }
	
	loadingIndicator.center = CGPointMake((self.view.bounds.size.width/2)-5, (self.view.bounds.size.height/2)-30);
	
	/*
	 *  Check if the vgood is pushed from a multipleVgoodVC, if yes hides back button.
	 */
    NSArray *VCArray = self.navigationController.viewControllers;
    for (int i=0; i<[VCArray count]; i++) {
        if ([[VCArray objectAtIndex:i] isKindOfClass:[BeintooMultipleVgoodVC class]]) {
            [self.navigationItem setHidesBackButton:YES];
        }
    }
	
    if ([Beintoo getLastGeneratedVGood].openInBrowser == NO)
        urlToOpen = [urlToOpen stringByAppendingFormat:@"&os_source=ios"];
    
	[vGoodWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlToOpen]]];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    
    beintooPlayer.delegate = nil;
}

#pragma mark -
#pragma mark webViewDelegates

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)req navigationType:(UIWebViewNavigationType)navigationType {
    
    
    NSMutableURLRequest *request = (NSMutableURLRequest *)req;
	
    NSURL *url = request.URL;
	NSString *urlString = [url path];
	
    NSURL *urlToGetParams = request.URL;
	NSString *urlStringToGet = [urlToGetParams absoluteString];
    
    if ([urlString isEqualToString:@"/m/set_app_and_redirect.html"]) {
        
        BeintooUrlParser *urlParser = [[BeintooUrlParser alloc] initWithURLString:urlStringToGet];
        
        if ([urlParser valueForVariable:@"guid"])
            [beintooPlayer getPlayerByGUID:[urlParser valueForVariable:@"guid"]];
        
        [urlParser release];
    }
    
    didOpenTheRecommendation = NO;
	
    if (![url.scheme isEqual:@"http"] && ![url.scheme isEqual:@"https"]) {
		// ******** Remember that this will NOT work on the simulator ******* //
		if ([[UIApplication sharedApplication]canOpenURL:url]) {
			[[UIApplication sharedApplication]openURL:url];
			[loadingIndicator stopAnimating];
			didOpenTheRecommendation = YES;
			if (didOpenTheRecommendation) {
				[Beintoo dismissRecommendation];
			}
			
			return NO;
		}
	}
    return YES; 
}

- (void)player:(BeintooPlayer *)player getPlayerByGUID:(NSDictionary *)result{
    if (![[result objectForKey:@"kind"] isEqualToString:@"error"]) {
        if ([result objectForKey:@"guid"] != nil) {
            
            NSString *playerGUID	= [result objectForKey:@"guid"];
            NSString *playerUser	= [result objectForKey:@"user"];
            
            if (playerUser != nil && playerGUID != nil) {	
                [Beintoo setUserLogged:YES];
            }
            [Beintoo setBeintooPlayer:result];
            
            // Alliance check
            if ([result objectForKey:@"alliance"] != nil) {
                [BeintooAlliance setUserWithAlliance:YES];
            }else{
                [BeintooAlliance setUserWithAlliance:NO];
            }
        }
    }
}

- (void)webViewDidStartLoad:(UIWebView *)theWebView{
	[loadingIndicator startAnimating];
}
- (void)webViewDidFinishLoad:(UIWebView *)theWebView{
	[loadingIndicator stopAnimating];
}

- (void)webView:(UIWebView *)wv didFailLoadWithError:(NSError *)error {
    // Ignore NSURLErrorDomain error -999.
    if (error.code == NSURLErrorCancelled) return;
	
    // Ignore "Fame Load Interrupted" errors. Seen after app store links.
    if (error.code == 102 && [error.domain isEqual:@"WebKitErrorDomain"]) return;
	
	[loadingIndicator stopAnimating];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (void)setIsFromWallet:(BOOL)value{
	isFromWallet = value;
}

- (UIButton *)closeButton{
	UIImage *closeImg = [UIImage imageNamed:@"bar_close.png"];
	UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
	[closeBtn setImage:closeImg forState:UIControlStateNormal];
	closeBtn.frame = CGRectMake(0,0, closeImg.size.width+7, closeImg.size.height);
	[closeBtn addTarget:self action:@selector(closeBeintoo) forControlEvents:UIControlEventTouchUpInside];
	return closeBtn;
}

-(void)closeBeintoo{
	if (isFromWallet) { 
		[Beintoo dismissBeintoo];
	}
    else if ([caller isEqualToString:@"MarketplaceList"] == YES || [caller isEqualToString:@"MarketplaceSelectedCoupon"] == YES){
        [Beintoo dismissBeintoo];
    }
    else {
		[Beintoo dismissPrize];
	}
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return NO;
}

- (void)viewWillDisappear:(BOOL)animated {
	[vGoodWebView loadHTMLString:@"<html><head></head><body></body></html>" baseURL:nil];
}

#ifdef UI_USER_INTERFACE_IDIOM
- (void)setRecommendationPopoverController:(UIPopoverController *)_recommPopover{
	recommendPopoverController = _recommPopover;
}
#endif

- (void)dealloc {
    [loadingIndicator release];
    [beintooPlayer release];
    [super dealloc];
}


@end
