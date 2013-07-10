/*******************************************************************************
 * Copyright 2013 Beintoo - author gpiazzese@beintoo.com
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

#import "BeintooWebview.h"
#import "Beintoo.h"

@interface BeintooWebview ()

@end

@implementation BeintooWebview
@synthesize url, openSection;

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
    
    self.view.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
    
    webview = [[UIWebView alloc] initWithFrame:self.view.frame];
    webview.delegate = self;
    webview.scrollView.showsVerticalScrollIndicator = NO;
    webview.scrollView.showsHorizontalScrollIndicator = NO;
    webview.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
    [self.view addSubview:webview];
    
    NSString *urlString = [NSString stringWithFormat:@"http://static.beintoo.com/sdk/webviews/v3.0.0/index.html"]; // http://static.beintoo.com/sdk/webviews/test/test.html"]; // //
    
    urlString = [urlString stringByAppendingFormat:@"?apikey=%@&udid=%@&v=%@&platform=%@", [Beintoo getApiKey], [BeintooDevice getUDID], [Beintoo currentVersion], @"ios"];
    
    if ([Beintoo isOnPrivateSandbox])
        urlString = [urlString stringByAppendingFormat:@"&apisandbox=true"];
    
    if ([Beintoo getPlayer] != nil)
        urlString = [urlString stringByAppendingFormat:@"&guid=%@", [Beintoo getPlayerID]];
    
    if ([Beintoo isUserLogged])
        urlString = [urlString stringByAppendingFormat:@"&userext=%@", [Beintoo getUserID]];
    
    if (self.openSection != nil)
        urlString = [urlString stringByAppendingFormat:@"&gotoview=%@", openSection];
    
    // Start the loader
    [BLoadingView startActivity:self.view];
    
    // Open the webivew
    NSURL *URL = [[NSURL alloc] init];
    
    if ([url length] > 0)
        URL = [NSURL URLWithString:url];
    else {
        // Enable the timer
        timer = [NSTimer scheduledTimerWithTimeInterval:60.0 target:self selector:@selector(displayConnectionErrorAlert) userInfo:nil repeats:NO];
        
#ifdef BEINTOO_ARC_AVAILABLE
#else
        [timer retain];
#endif
        
        URL = [NSURL URLWithString:urlString];
    }

    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:URL];
    
    [webview loadRequest:request];
    
#ifdef BEINTOO_ARC_AVAILABLE
    
#else
    [request release];
#endif
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Webview delegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSString *stringURL = [[request URL] absoluteString];
    
    return [BCustomUrlScheme webview:webView action:stringURL timer:timer controller:self.navigationController];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    BeintooLOG(@"Error in webpage %@", error);
}

#pragma mark - Internal methods

- (void)close
{
    [self invalidateTimer];
    [Beintoo dismissView:self.navigationController];
}

- (void)invalidateTimer
{
    if (timer != nil)
    {
        if ([timer isValid])
        {
            [timer invalidate];
            timer = nil;
        }
    }
}

- (void)displayConnectionErrorAlert
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedStringFromTable(@"forgotPasswordAlertTitleError", @"BeintooLocalizable", nil) message:NSLocalizedStringFromTable(@"connectionError", @"BeintooLocalizable", nil) delegate:self cancelButtonTitle:NSLocalizedStringFromTable(@"ok", @"BeintooLocalizable", nil) otherButtonTitles:nil];
    alert.tag = 1;
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 1)
    {
        [self close];
    }
}

#pragma mark - memory management

- (void)dealloc
{
    
#ifdef BEINTOO_ARC_AVAILABLE
    
#else
    [webview release];
    
    [super dealloc];
#endif
    
}

@end
