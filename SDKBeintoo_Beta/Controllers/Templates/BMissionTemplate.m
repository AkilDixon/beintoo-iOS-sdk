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

#import "BMissionTemplate.h"
#import <QuartzCore/QuartzCore.h>
#import "Beintoo.h"

NSString *BeintooUrlSchemeWebviewAcceptMission  = @"#ios-acceptmission";
NSString *BeintooUrlSchemeWebviewRefuseMission  = @"#ios-refusemission";
NSString *BeintooUrlSchemeWebviewCloseView      = @"#ios-close";

@implementation BMissionTemplate

@synthesize delegate, prizeType, isVisible, globalDelegate, type, missionWrapper;

- (id)initWithMission:(BMissionWrapper *)_mission
{
	if (self = [super init]){
        recommWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        missionWrapper = _mission;
        
        NSLog(@"mission wrapper %@", _mission);
	}
    return self;
}

- (void)setPrizeContentWithWindowSize:(CGSize)windowSize
{
	isVisible   = YES;
    
    self.backgroundColor = [UIColor clearColor];
    self.layer.cornerRadius = 2;
	self.layer.borderColor  = [UIColor colorWithWhite:1 alpha:0.35].CGColor;
	self.layer.borderWidth  = 0;
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
	if (type == REWARD){
        CATransition *applicationLoadViewIn = [CATransition animation];
        [applicationLoadViewIn setDuration:0.7f];
        [applicationLoadViewIn setValue:@"load" forKey:@"name"];
        applicationLoadViewIn.removedOnCompletion = YES;
        [applicationLoadViewIn setType:kCATransitionMoveIn];
        applicationLoadViewIn.subtype = transitionEnterSubtype;
        applicationLoadViewIn.delegate = self;
        [applicationLoadViewIn setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
        [[self layer] addAnimation:applicationLoadViewIn forKey:@"Show"];
	}
	self.alpha = 1;
}

- (void)showWithAlphaAnimation
{
    if (type == REWARD){
        CATransition *applicationLoadViewIn = [CATransition animation];
        [applicationLoadViewIn setDuration:0.8f];
        [applicationLoadViewIn setValue:@"load" forKey:@"name"];
        applicationLoadViewIn.removedOnCompletion = YES;
        [applicationLoadViewIn setType:kCATransitionMoveIn];
        applicationLoadViewIn.subtype = kCATransitionFade;
        applicationLoadViewIn.delegate = self;
        [applicationLoadViewIn setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
        [[self layer] addAnimation:applicationLoadViewIn forKey:@"Show"];
    }
    
    self.alpha = 1;
}

- (void)showHtmlWithAlphaAnimation
{
    if (type == REWARD){
        CATransition *applicationLoadViewIn = [CATransition animation];
        [applicationLoadViewIn setDuration:0.7f];
        [applicationLoadViewIn setValue:@"load" forKey:@"name"];
        applicationLoadViewIn.removedOnCompletion = YES;
        [applicationLoadViewIn setType:kCATransitionMoveIn];
        applicationLoadViewIn.subtype = kCATransitionFade;
        applicationLoadViewIn.delegate = self;
        [applicationLoadViewIn setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
        [[self layer] addAnimation:applicationLoadViewIn forKey:@"Show"];
    }
    
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
    
    recommWebView.delegate = self;
    recommWebView.scalesPageToFit = NO;
    recommWebView.opaque = NO;
    recommWebView.backgroundColor = [UIColor clearColor];
    self.backgroundColor = [UIColor clearColor];
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 5.0)
        recommWebView.scrollView.scrollEnabled = NO;
    else {
        for (UIView *subview in [recommWebView subviews]){
            if ([subview isKindOfClass:[UIScrollView class]]){
                UIScrollView *_scrollSubView = (UIScrollView *)subview;
                _scrollSubView.scrollEnabled = NO;
            }
        }
    }
    
    [self addSubview:recommWebView];
    [self sendSubviewToBack:recommWebView];
    
    [recommWebView loadHTMLString:missionWrapper.content baseURL:nil];
}

- (void)removeViews
{
	for (UIView *subview in [self subviews]) {
		[subview removeFromSuperview];
	}
}

- (void)closeBanner
{
	self.alpha = 0;
	[self removeViews];
	[self removeFromSuperview];
    if ([[self delegate] respondsToSelector:@selector(userDidTapOnClosePrize)])
        [[self delegate] userDidTapOnClosePrize];
    
}

- (void)preparePrizeAlertOrientation:(CGRect)startingFrame
{
    NSLog(@"changed app or %i", [Beintoo appOrientation]);
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

#pragma mark - Webview delegates

- (void)webViewDidFinishLoad:(UIWebView *)theWebView
{
    [self showHtmlWithAlphaAnimation];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSMutableURLRequest *req    = (NSMutableURLRequest *)request;
    NSString *urlString         = [req.URL absoluteString];
    
    if ([urlString rangeOfString:BeintooUrlSchemeWebviewAcceptMission].location != NSNotFound)
    {
        // User accepted, save the mission on the device
        
        //[BeintooMission updateMission:self.missionWrapper];
       
        [self userDidFailToClickOnWebView];
    }
    
    if (navigationType == UIWebViewNavigationTypeLinkClicked  && ([urlString rangeOfString:BeintooUrlSchemeWebviewCloseView].location != NSNotFound)){
        
        if (type == REWARD){
            if ([[self delegate] respondsToSelector:@selector(userDidTapOnClosePrize)])
                [[self delegate] userDidTapOnClosePrize];
        }
        else if (type == AD){
            if ([[self delegate] respondsToSelector:@selector(userDidTapOnCloseAd)])
                [[self delegate] userDidTapOnCloseAd];
        }
        
        [self userDidFailToClickOnWebView];
        
        return NO;
    }
    
    if(navigationType == UIWebViewNavigationTypeOther && ([urlString rangeOfString:@"about:blank"].location != NSNotFound)){
        return YES;
    }
    
    if(type == REWARD && (navigationType == UIWebViewNavigationTypeLinkClicked || navigationType == UIWebViewNavigationTypeFormSubmitted)){
        
        
        
        return NO;
    }
    
    if(type == AD && (navigationType == UIWebViewNavigationTypeLinkClicked || navigationType == UIWebViewNavigationTypeFormSubmitted)){
        
        
        return NO;
    }
    
    return YES;
}

- (void)userClickedOnWebView
{
    [self setBackgroundColor:[UIColor colorWithRed:0.0/255 green:0.0/255 blue:0.0/255 alpha:0.7]];
    
    if (type == REWARD){
        if ([[self delegate] respondsToSelector:@selector(userDidTapOnThePrize)])
            [[self delegate] userDidTapOnThePrize];
    }
    else if (type == AD){
        if ([[self delegate] respondsToSelector:@selector(userDidTapOnTheAd)])
            [[self delegate] userDidTapOnTheAd];
    }
    
    [UIView animateWithDuration:0.4
                     animations:^(void){
                         self.alpha  = 0;
                     }
                     completion:^(BOOL finished){
                         self.isVisible = NO;
                         
                         [self removeViews];
                         [self removeFromSuperview];
                         
                         [Beintoo setLastGeneratedAd:nil];
                     }
     ];
}

- (void)userDidFailToClickOnWebView
{
    [recommWebView stopLoading];
    
    [UIView animateWithDuration:0.4
                     animations:^(void){
                         self.alpha  = 0;
                     }
                     completion:^(BOOL finished){
                         self.isVisible = NO;
                         
                         [self removeViews];
                         [self removeFromSuperview];
                         
                         [Beintoo setLastGeneratedAd:nil];
                     }
     ];
}

#ifdef BEINTOO_ARC_AVAILABLE
#else
- (void)dealloc {
    [super dealloc];
}
#endif

@end
