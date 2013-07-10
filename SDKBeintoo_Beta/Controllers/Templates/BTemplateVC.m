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

#import "BTemplateVC.h"
#import "Beintoo.h"

@implementation BTemplateVC

@synthesize URL, type;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil urlToOpen:(NSString *)theURL
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.URL = theURL;
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
		
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Beintoo";
    
	self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:109.0/255 green:131.0/255 blue:160.0/255 alpha:1.0];

#if __IPHONE_OS_VERSION_MAX_VERSION >= BEINTOO_IOS_7_0
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
    {
        self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:109.0/255 green:131.0/255 blue:160.0/255 alpha:1.0];
        self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
        self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor]};
    }
    else {
        self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:109.0/255 green:131.0/255 blue:160.0/255 alpha:1.0];
    }
#else
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:109.0/255 green:131.0/255 blue:160.0/255 alpha:1.0];
#endif
    
	UIBarButtonItem *barCloseBtn = [[UIBarButtonItem alloc] initWithCustomView:[self closeButton]];
	[self.navigationItem setRightBarButtonItem:barCloseBtn animated:YES];
    
#ifdef BEINTOO_ARC_AVAILABLE
#else
    [barCloseBtn release];
#endif
		
	self.view.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
    
    webview = [[UIWebView alloc] initWithFrame:self.view.frame];
    webview.delegate = self;
    webview.scrollView.showsVerticalScrollIndicator = NO;
    webview.scrollView.showsHorizontalScrollIndicator = NO;
    webview.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
    [self.view addSubview:webview];
    
#ifdef BEINTOO_ARC_AVAILABLE
    [webview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:URL]]];
#else
    [webview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[URL retain]]]];
#endif

}

#pragma mark - WebViewDelegates

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)req navigationType:(UIWebViewNavigationType)navigationType
{
    NSMutableURLRequest *request = (NSMutableURLRequest *)req;
	
    NSURL *url = request.URL;
	
    if ( [[UIApplication sharedApplication] canOpenURL:url] && ![url.scheme isEqual:@"http"] && ![url.scheme isEqual:@"https"] ) {
        [[UIApplication sharedApplication] openURL:url];
        [BLoadingView stopActivity];
        
        [self closeBeintoo];
        
        return NO;
    }
    
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)theWebView
{
    [BLoadingView startActivity:self.view];
}

- (void)webViewDidFinishLoad:(UIWebView *)theWebView
{
	[BLoadingView stopActivity];
}

- (void)webView:(UIWebView *)wv didFailLoadWithError:(NSError *)error
{
    // Ignore NSURLErrorDomain error -999.
    if (error.code == NSURLErrorCancelled) return;
	
    // Ignore "Fame Load Interrupted" errors. Seen after app store links.
    if (error.code == 102 && [error.domain isEqual:@"WebKitErrorDomain"]) return;
	
	[BLoadingView stopActivity];
}

#pragma mark - Internal methods

- (UIView *)closeButton
{
    UIView *_vi = [[UIView alloc] initWithFrame:CGRectMake(-25, 5, 35, 35)];
    
    UIImageView *_imageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 15, 15)];
    _imageView.image = [UIImage imageNamed:@"bar_close_button.png"];
    _imageView.contentMode = UIViewContentModeScaleAspectFit;
	
    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
	closeBtn.frame = CGRectMake(6, 6.5, 35, 35);
    [closeBtn addSubview:_imageView];
	[closeBtn addTarget:self action:@selector(closeBeintoo) forControlEvents:UIControlEventTouchUpInside];
    
    [_vi addSubview:closeBtn];
	
    return _vi;
}

- (void)closeBeintoo
{
    if (type == REWARD)
        [Beintoo dismissRewardController];
    else if (type == AD)
        [Beintoo dismissAdController];
    else if (type == GIVE_BEDOLLARS)
        [Beintoo dismissGiveBedollarsController];
    else if (type == CUSTOM_TYPE)
        [Beintoo dismissController:self.navigationController];
}

#if __IPHONE_OS_VERSION_MIN_REQUIRED < BEINTOO_IOS_6_0
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}
#endif

- (void)dealloc {

#ifdef BEINTOO_ARC_AVAILABLE
#else
    [webview release];
    
    [super dealloc];
#endif

}

@end
