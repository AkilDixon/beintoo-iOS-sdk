/*******************************************************************************
 * Copyright 2011 Beintoo - author gpiazzese@beintoo.com
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

#import "BeintooMarketplaceWebViewVC.h"

@implementation BeintooMarketplaceWebViewVC

- (void)viewDidLoad{
    [super viewDidLoad];
    
    int appOrientation = [Beintoo appOrientation];
	
	UIImageView *logo;
    
	if( !([BeintooDevice isiPad]) && 
       (appOrientation == UIInterfaceOrientationLandscapeLeft || appOrientation == UIInterfaceOrientationLandscapeRight) ){
		logo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bar_logo_34.png"]];
    }
	else { 
		logo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bar_logo.png"]];
    }
    
	self.navigationItem.titleView = logo;
	[logo release];
    
    UIBarButtonItem *barCloseBtn = [[UIBarButtonItem alloc] initWithCustomView:[self closeButton]];
    [self.navigationItem setRightBarButtonItem:barCloseBtn animated:YES];
    [barCloseBtn release];
    
    loadingIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
	loadingIndicator.hidesWhenStopped = YES;
    [webView addSubview:loadingIndicator];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    loadingIndicator.frame = CGRectMake((self.view.frame.size.width/2) - (loadingIndicator.frame.size.width/2), (self.view.frame.size.height/2) - (loadingIndicator.frame.size.height/2), loadingIndicator.frame.size.width, loadingIndicator.frame.size.height);
    [loadingIndicator startAnimating];
    
    if (![BeintooNetwork connectedToNetwork]){
        
        [loadingIndicator stopAnimating];
        
        [BeintooNetwork showNoConnectionAlert];
        
    }
    else {
        
        NSString *urlAddress;
        
        if ([Beintoo isOnPrivateSandbox])
            urlAddress      = [NSString stringWithFormat:@"https://sandbox-elb.beintoo.com/m/marketplace.html"]; 
        else 
            urlAddress      = [NSString stringWithFormat:@"https://www.beintoo.com/m/marketplace.html"];
        
        
        urlAddress          = [urlAddress stringByAppendingFormat:@"?apikey=%@", [Beintoo getApiKey]];
        
        if ([Beintoo getPlayerID])
            urlAddress          = [urlAddress stringByAppendingFormat:@"&guid=%@", [Beintoo getPlayerID]];
        
        CLLocation *loc     = [Beintoo getUserLocation];
        if (loc == nil || (loc.coordinate.latitude <= 0.01f && loc.coordinate.latitude >= -0.01f) 
            || (loc.coordinate.longitude <= 0.01f && loc.coordinate.longitude >= -0.01f)) {
            
        }
        else	
            urlAddress      = [urlAddress stringByAppendingFormat:@"&lat=%f&lng=%f&acc=%f", loc.coordinate.latitude,loc.coordinate.longitude,loc.horizontalAccuracy];	
        
        if ([Beintoo isVirtualCurrencyStored]){
            urlAddress      = [urlAddress stringByAppendingFormat:@"&developer_user_guid=%@&virtual_currency_amount=%f", [Beintoo getDeveloperUserId], [Beintoo getVirtualCurrencyBalance]];
        }
        
        //Create a URL object.
        NSURL *url = [NSURL URLWithString:urlAddress];
        
        //URL Requst Object
        NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
        
        webView.delegate = self;
        
        //Load the request in the UIWebView.
        [webView loadRequest:requestObj];
        
    }
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    
    @try {
        [loadingIndicator stopAnimating];
    }
    @catch (NSException *exception) {
        
    }
    
}

- (UIView *)closeButton{
    UIView *_vi             = [[UIView alloc] initWithFrame:CGRectMake(-25, 5, 35, 35)];
    
    UIImageView *_imageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 15, 15)];
    _imageView.image        = [UIImage imageNamed:@"bar_close_button.png"];
    _imageView.contentMode  = UIViewContentModeScaleAspectFit;
	
    UIButton *closeBtn      = [UIButton buttonWithType:UIButtonTypeCustom];
	closeBtn.frame          = CGRectMake(6, 6.5, 35, 35);
    [closeBtn addSubview:_imageView];
	[closeBtn addTarget:self action:@selector(closeBeintoo) forControlEvents:UIControlEventTouchUpInside];
    
    [_vi addSubview:closeBtn];
	
    return _vi;
}

-(void)closeBeintoo{
    [Beintoo dismissBeintoo];
}

- (void)webViewDidFinishLoad:(UIWebView *)_webView{
    [loadingIndicator stopAnimating];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
   [loadingIndicator stopAnimating];
}

- (void)webViewDidStartLoad:(UIWebView *)webView{
   
}

@end
