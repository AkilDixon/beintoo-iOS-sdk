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

#import "BTemplate.h"
#import "Beintoo.h"

@implementation BTemplate
@synthesize delegate, isVisible, globalDelegate, type, reward, ad;

- (id)initWithReward:(BRewardWrapper *)wrapper
{
	if (self = [super init])
    {
        recommWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        
#ifdef BEINTOO_ARC_AVAILABLE
        reward = wrapper;
#else
        reward = [wrapper retain];
#endif
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationReceived:) name:BeintooNotificationOrientationChanged object:nil];
        
        type = TEMPLATE_TYPE_REWARD;
    }
    return self;
}

- (id)initWithAd:(BAdWrapper *)wrapper
{
	if (self = [super init])
    {
        recommWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        
#ifdef BEINTOO_ARC_AVAILABLE
        ad = wrapper;
#else
        ad = [wrapper retain];
#endif
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationReceived:) name:BeintooNotificationOrientationChanged object:nil];
        
        type = TEMPLATE_TYPE_AD;
    }
    return self;
}

- (void)notificationReceived:(NSNotification *)notification
{
    if (notification.name == BeintooNotificationOrientationChanged)
    {
        
        [UIView animateWithDuration:0.20
                         animations:^(void){
                             self.alpha  = 0;
                         }
                         completion:^(BOOL finished){
                             [self setPrizeContentWithWindowSize:[Beintoo getAppWindow].bounds.size];
                         }
         ];
    }
}

- (void)setPrizeContentWithWindowSize:(CGSize)windowSize
{
	isVisible   = YES;
    
    self.alpha = 0;
    
    self.frame = CGRectZero;
	
    windowSizeRect = windowSize;
    
    int statusBarOffset = 0;
    if ([Beintoo isStatusBarHiddenOnApp] == NO && [[UIApplication sharedApplication] isStatusBarHidden] == NO)
        statusBarOffset = 20;
    
	CGRect vgoodFrame = CGRectMake(0, statusBarOffset, windowSize.width, windowSize.height - statusBarOffset);
    
	prizeType = PRIZE_RECOMMENDATION_HTML;
	
	[self setFrame:vgoodFrame];
    [self preparePrizeAlertOrientation:vgoodFrame];
}

- (void)show
{
    CATransition *applicationLoadViewIn = [CATransition animation];
    [applicationLoadViewIn setDuration:0.5f];
    [applicationLoadViewIn setValue:@"load" forKey:@"name"];
    applicationLoadViewIn.removedOnCompletion = YES;
    [applicationLoadViewIn setType:kCATransitionMoveIn];
    applicationLoadViewIn.subtype = transitionEnterSubtype;
    applicationLoadViewIn.delegate = self;
    [applicationLoadViewIn setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [[self layer] addAnimation:applicationLoadViewIn forKey:@"Show"];
	
	self.alpha = 1;
}

- (void)showWithAlphaAnimation
{
    
    CATransition *applicationLoadViewIn = [CATransition animation];
    [applicationLoadViewIn setDuration:0.5f];
    [applicationLoadViewIn setValue:@"load" forKey:@"name"];
    applicationLoadViewIn.removedOnCompletion = YES;
    [applicationLoadViewIn setType:kCATransitionMoveIn];
    applicationLoadViewIn.subtype = kCATransitionFade;
    applicationLoadViewIn.delegate = self;
    [applicationLoadViewIn setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [[self layer] addAnimation:applicationLoadViewIn forKey:@"Show"];
    
    self.alpha = 1;
}

- (void)showHtmlWithAlphaAnimation
{
    CATransition *applicationLoadViewIn = [CATransition animation];
    [applicationLoadViewIn setDuration:0.5f];
    [applicationLoadViewIn setValue:@"load" forKey:@"name"];
    applicationLoadViewIn.removedOnCompletion = YES;
    [applicationLoadViewIn setType:kCATransitionMoveIn];
    applicationLoadViewIn.subtype = kCATransitionFade;
    applicationLoadViewIn.delegate = self;
    [applicationLoadViewIn setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [[self layer] addAnimation:applicationLoadViewIn forKey:@"Show"];
    
    self.alpha = 1;
}

- (void)animationDidStop:(CAAnimation *)animation finished:(BOOL)flag
{
	if ([[animation valueForKey:@"name"] isEqualToString:@"load"]) {
	}
}

- (void)drawPrize
{
    [self removeViews];
	
    int statusBarOffset = 0;
    if ([Beintoo isStatusBarHiddenOnApp] == NO && [[UIApplication sharedApplication] isStatusBarHidden] == NO)
        statusBarOffset = 20;
    
    recommWebView.frame = CGRectMake(0, statusBarOffset, self.frame.size.width, self.frame.size.height - statusBarOffset);
    
    if ([Beintoo appOrientation] == UIInterfaceOrientationLandscapeLeft || [Beintoo appOrientation] == UIInterfaceOrientationLandscapeRight)
        recommWebView.frame = CGRectMake(0, statusBarOffset, windowSizeRect.height, windowSizeRect.width - statusBarOffset);
    
    NSString *content;
    
    if (type == TEMPLATE_TYPE_REWARD)
        content = reward.content;
    if (type == TEMPLATE_TYPE_AD)
        content = ad.content;
    
    recommWebView.delegate = self;
    recommWebView.scalesPageToFit = NO;
    recommWebView.opaque = NO;
    recommWebView.backgroundColor = [UIColor clearColor];
    self.backgroundColor = [UIColor clearColor];
    
    [self addSubview:recommWebView];
    [self sendSubviewToBack:recommWebView];
    
    [recommWebView loadHTMLString:content baseURL:nil];
}

- (void)removeViews
{
	for (UIView *subview in [self subviews]) {
		[subview removeFromSuperview];
	}
}

- (void)preparePrizeAlertOrientation:(CGRect)startingFrame
{
    self.alpha = 0;
    self.transform = CGAffineTransformMakeRotation(DegreesToRadians(0));
	
    if ([Beintoo appOrientation] == UIInterfaceOrientationLandscapeLeft) {
		self.frame = startingFrame;
		self.transform = CGAffineTransformMakeRotation(DegreesToRadians(-90.0));
        
        CGRect vgoodFrame = CGRectMake(0, 0, windowSizeRect.width, windowSizeRect.height);
        [self setFrame:vgoodFrame];
	}
    else if ([Beintoo appOrientation] == UIInterfaceOrientationLandscapeRight) {
		self.frame = startingFrame;
		self.transform = CGAffineTransformMakeRotation(DegreesToRadians(90.0));
        
        CGRect vgoodFrame = CGRectMake(0, 0, windowSizeRect.width, windowSizeRect.height);
        [self setFrame:vgoodFrame];
	}
	else if ([Beintoo appOrientation] == UIInterfaceOrientationPortrait) {
		self.transform = CGAffineTransformMakeRotation(DegreesToRadians(0));
		self.frame = startingFrame;
        
        CGRect vgoodFrame = CGRectMake(0, 0, windowSizeRect.width, windowSizeRect.height);
        [self setFrame:vgoodFrame];
    }
	else if ([Beintoo appOrientation] == UIInterfaceOrientationPortraitUpsideDown) {
		self.transform = CGAffineTransformMakeRotation(DegreesToRadians(180));
		self.frame = startingFrame;
        
        CGRect vgoodFrame = CGRectMake(0, 0, windowSizeRect.width, windowSizeRect.height);
        [self setFrame:vgoodFrame];
    }
    
    [self drawPrize];
}

- (void)webViewDidFinishLoad:(UIWebView *)theWebView
{
    [self showHtmlWithAlphaAnimation];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSMutableURLRequest *req    = (NSMutableURLRequest *)request;
    NSString *urlString         = [req.URL absoluteString];
    
    if (navigationType == UIWebViewNavigationTypeLinkClicked  && ([urlString rangeOfString:@"#ios-close"].location != NSNotFound))
    {
        [self closeTemplate];
        
        return NO;
    }
    
    if(navigationType == UIWebViewNavigationTypeOther && ([urlString rangeOfString:@"about:blank"].location != NSNotFound)){
        return YES;
    }
    
    if( (navigationType == UIWebViewNavigationTypeLinkClicked || navigationType == UIWebViewNavigationTypeFormSubmitted)){
        
        [self openTemplateControllerWithURL:urlString];
        
        return NO;
    }
    
    return [BCustomUrlScheme webview:webView action:urlString timer:nil controller:nil];
}

- (void)openTemplateControllerWithURL:(NSString *)URL
{
    [self callTemplateHasBeenTappedDelegate];
    [self removeSelfFromSuperview];
    
    if (type == TEMPLATE_TYPE_REWARD)
        [Beintoo reward:self launchRewardControllerWithURL:URL];
    if (type == TEMPLATE_TYPE_AD)
        [Beintoo ad:self launchRewardControllerWithURL:URL];
}

- (void)closeTemplate
{
    [self callTemplareHasBeenClosedDelegate];
    [self removeSelfFromSuperview];
    
    if (type == TEMPLATE_TYPE_REWARD)
        [Beintoo hideReward:self];
    if (type == TEMPLATE_TYPE_AD)
        [Beintoo hideAd:self];
}

- (void)removeSelfFromSuperview
{
    [recommWebView stopLoading];
    
    [self setBackgroundColor:[UIColor colorWithRed:0.0/255 green:0.0/255 blue:0.0/255 alpha:0.7]];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:BeintooNotificationOrientationChanged object:nil];

    [UIView animateWithDuration:0.4
                     animations:^(void){
                         self.alpha  = 0;
                     }
                     completion:^(BOOL finished){
                         self.isVisible = NO;
                         
                         [self removeViews];
                         [self removeFromSuperview];
                     }
     ];
}

- (void)callTemplateHasBeenTappedDelegate
{
    if (type == TEMPLATE_TYPE_REWARD)
    {
        if ([[self delegate] respondsToSelector:@selector(beintooRewardHasBeenTapped)])
            [[self delegate] beintooRewardHasBeenTapped];
    }
    
    if (type == TEMPLATE_TYPE_AD)
    {
        if ([[self delegate] respondsToSelector:@selector(beintooAdHasBeenTapped)])
            [[self delegate] beintooAdHasBeenTapped];
    }
}

- (void)callTemplareHasBeenClosedDelegate
{
    if (type == TEMPLATE_TYPE_REWARD)
    {
        if ([[self delegate] respondsToSelector:@selector(beintooRewardHasBeenClosed)])
            [[self delegate] beintooRewardHasBeenClosed];
    }
    
    if (type == TEMPLATE_TYPE_AD)
    {
        if ([[self delegate] respondsToSelector:@selector(beintooAdHasBeenClosed)])
            [[self delegate] beintooAdHasBeenClosed];
    }
}

#ifdef BEINTOO_ARC_AVAILABLE
#else
- (void)dealloc {
    [recommWebView release];
    
    [super dealloc];
}
#endif

@end
