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

#import "BeintooBrowserVC.h"
#import "Beintoo.h"

@implementation BeintooBrowserVC

@synthesize urlToOpen;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil urlToOpen:(NSString *)URL {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
		self.urlToOpen = URL;
    }
    return self;
}

- (void)setAllowCloseWebView:(BOOL)_value{
    allowCloseWebViewAndDismissBeintoo = _value;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.title = @"Beintoo";
		
	loadingIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
	loadingIndicator.hidesWhenStopped = YES;
	[self.view addSubview:loadingIndicator];
		
	_webView.delegate = self;
	_webView.scalesPageToFit = YES;
    
    if (allowCloseWebViewAndDismissBeintoo) {
        UIBarButtonItem *barCloseBtn = [[UIBarButtonItem alloc] initWithCustomView:[self closeButton]];
		[self.navigationItem setRightBarButtonItem:barCloseBtn animated:YES];
		[barCloseBtn release];
    }
}

- (void)viewWillAppear:(BOOL)animated{
	[loadingIndicator stopAnimating];
	
    if ([BeintooDevice isiPad]) {
        [self setContentSizeForViewInPopover:CGSizeMake(320, 415)];
    }
	    
	if (![Beintoo isUserLogged])
		[self.navigationController popToRootViewControllerAnimated:NO];
	else {
        loadingIndicator.center = CGPointMake((self.view.bounds.size.width/2)-5, (self.view.bounds.size.height/2)-30);
        [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlToOpen]]];
    }
}

- (IBAction)back:(id)sender{
    [_webView goBack];
}
- (IBAction)forward:(id)sender{
    [_webView goForward];
}
- (IBAction)stop:(id)sender{
    [_webView stopLoading];
}
- (IBAction)refresh:(id)sender{
    [_webView reload];    
}

#pragma mark -
#pragma mark webViewDelegates

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)req navigationType:(UIWebViewNavigationType)navigationType {
    
    return YES; 
}

- (void)webViewDidStartLoad:(UIWebView *)theWebView{
	[loadingIndicator startAnimating];
}
- (void)webViewDidFinishLoad:(UIWebView *)theWebView{
	[loadingIndicator stopAnimating];
 }

- (void)webView:(UIWebView *)wv didFailLoadWithError:(NSError *)error {
	
	[loadingIndicator stopAnimating];
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
    [Beintoo dismissBeintoo];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return NO;
}

- (void)viewWillDisappear:(BOOL)animated {
	[_webView loadHTMLString:@"<html><head></head><body></body></html>" baseURL:nil];
}

- (void)viewDidDisappear:(BOOL)animated{
}

- (void)viewDidUnload {
    [super viewDidUnload];
}

- (void)dealloc {
    [super dealloc];
}


@end
