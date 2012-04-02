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

#import "BPrize.h"
#import <QuartzCore/QuartzCore.h>
#import "BButton.h"
#import "Beintoo.h"

@implementation BPrize

@synthesize beintooLogo, prizeImg, prizeThumb, textLabel, detailedTextLabel, delegate, prizeType, isVisible, globalDelegate;

-(id)init {
	if (self = [super init]){
        self.textLabel = [[UILabel alloc] init];
	}
    return self;
}

- (void)setPrizeContentWithWindowSize:(CGSize)windowSize{
	firstTouch = YES;
    
	self.backgroundColor = [UIColor colorWithRed:0.0/255 green:0.0/255 blue:0.0/255 alpha:0.7];
	self.layer.cornerRadius = 2;
	self.layer.borderColor  = [UIColor colorWithWhite:1 alpha:0.35].CGColor;
	self.layer.borderWidth  = 0;
	self.alpha = 0;
    
	BVirtualGood *lastVgood = [Beintoo getLastGeneratedVGood];
	
	self.frame = CGRectZero;
	
    windowSizeRect = windowSize;
    
	// Banner frame initialization: a vgood frame is a little bit smaller than a recommendation
	int _prizeType = PRIZE_GOOD;
    //CGRect vgoodFrame = CGRectMake(5, windowSize.height-ALERT_HEIGHT_VGOOD, 310, ALERT_HEIGHT_VGOOD);
    CGRect vgoodFrame = CGRectMake(0, 0, windowSize.width, windowSize.height);
    
    if ([lastVgood isRecommendation]) {
		_prizeType = PRIZE_RECOMMENDATION;
       // vgoodFrame = CGRectMake(1, windowSize.height-(ALERT_HEIGHT_RECOMMENDATION + RECOMMENDATION_TEXTHEIGHT), 318, ALERT_HEIGHT_RECOMMENDATION + RECOMMENDATION_TEXTHEIGHT);
        
		if ([lastVgood isHTMLRecommendation]) {
			_prizeType = PRIZE_RECOMMENDATION_HTML;
           // vgoodFrame = CGRectMake(0, 0, windowSize.width, windowSize.height);
		}
	}
    
    prizeType = _prizeType;
	
	[self setFrame:vgoodFrame];
    
	[self preparePrizeAlertOrientation:vgoodFrame];
}

- (void)show{
	
    isVisible = YES;
    
	CATransition *applicationLoadViewIn = [CATransition animation];
	[applicationLoadViewIn setDuration:0.7f];
	[applicationLoadViewIn setValue:@"load" forKey:@"name"];
	applicationLoadViewIn.removedOnCompletion = YES;
	[applicationLoadViewIn setType:kCATransitionMoveIn];
	applicationLoadViewIn.subtype = transitionEnterSubtype;
	applicationLoadViewIn.delegate = self;
	[applicationLoadViewIn setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
	[[self layer] addAnimation:applicationLoadViewIn forKey:@"Show"];
	
	self.alpha = 1;
}

- (void)showWithAlphaAnimation{
    
    isVisible = YES;
    
    CATransition *applicationLoadViewIn = [CATransition animation];
    [applicationLoadViewIn setDuration:0.8f];
    [applicationLoadViewIn setValue:@"load" forKey:@"name"];
    applicationLoadViewIn.removedOnCompletion = YES;
    [applicationLoadViewIn setType:kCATransitionMoveIn];
    applicationLoadViewIn.subtype = kCATransitionFade;
    applicationLoadViewIn.delegate = self;
    [applicationLoadViewIn setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [[self layer] addAnimation:applicationLoadViewIn forKey:@"Show"];
    
    self.alpha = 1;
    
}

- (void)showHtmlWithAlphaAnimation{
    
    isVisible = YES;
    
    CATransition *applicationLoadViewIn = [CATransition animation];
    [applicationLoadViewIn setDuration:0.7f];
    [applicationLoadViewIn setValue:@"load" forKey:@"name"];
    applicationLoadViewIn.removedOnCompletion = YES;
    [applicationLoadViewIn setType:kCATransitionMoveIn];
    applicationLoadViewIn.subtype = kCATransitionFade;
    applicationLoadViewIn.delegate = self;
    [applicationLoadViewIn setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [[self layer] addAnimation:applicationLoadViewIn forKey:@"Show"];
    
    self.alpha = 1;
    
}

- (void)animationDidStop:(CAAnimation *)animation finished:(BOOL)flag{
	if ([[animation valueForKey:@"name"] isEqualToString:@"load"]) {
	}
}

- (void)drawPrize{
	
    BVirtualGood *lastVgood = [Beintoo getLastGeneratedVGood];
    
    [self removeViews];
	[self setThumbnail:lastVgood.vGoodImageData];
	
   
    
    // Custom reward text. If there is a text on the retrieved good is shown, otherwise we use the default text
    
    if ([lastVgood.theGood objectForKey:@"rewardText"] != nil) {
        self.textLabel.text = [lastVgood.theGood objectForKey:@"rewardText"];
    }
    else{
        self.textLabel.text = NSLocalizedStringFromTable(@"vgoodMessageBanner",@"BeintooLocalizable",@"Pending");
    }
	self.textLabel.font = [UIFont systemFontOfSize:13];
	self.textLabel.numberOfLines = 4;
	self.textLabel.textAlignment = UITextAlignmentLeft;
    self.textLabel.backgroundColor = [UIColor clearColor];
	self.textLabel.textColor = [UIColor whiteColor];
	
    
	// -- normal vgood:			we need to add two label to give details.
	// -- recommendation:		the thumbnail frame will be extended to cover all the prizeAlert
	// -- html recommendation:	we add a small webview as subview, then we load the html content on it
   // self.textLabel.frame = CGRectMake(65, windowSizeRect.height/2 - self.textLabel.frame.size.height, windowSizeRect.width - 70, 54);
    
    if (prizeType == PRIZE_GOOD) {  
        
        self.textLabel.frame = CGRectMake(65, ([self bounds].size.height/2 - 54/2), [self bounds].size.width - 70, 54);
       [self addSubview:self.textLabel];
        
        // --- CLOSE BUTTON --- //
        UIImage *closeImg = [UIImage imageNamed:@"prizeCloseBtn.png"];
        closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [closeBtn setImage:closeImg forState:UIControlStateNormal];
        closeBtn.frame = CGRectMake([self bounds].size.width - 20, textLabel.frame.origin.y - 7, closeImg.size.width, closeImg.size.height+6);
    
        [closeBtn addTarget:self action:@selector(closeBanner) forControlEvents:UIControlEventTouchUpInside];
        closeBtn.contentMode = UIViewContentModeRedraw;
        [self addSubview:closeBtn];
        [self bringSubviewToFront:closeBtn];
        // -------------------- //
        [self showWithAlphaAnimation];
        
    }
    else if (prizeType == PRIZE_RECOMMENDATION){
        self.textLabel.frame = CGRectMake(0, (prizeThumb.frame.origin.y) - 54, [self bounds].size.width, 54);
        self.textLabel.textAlignment = UITextAlignmentCenter;
        [self addSubview:self.textLabel];
        
        // --- CLOSE BUTTON --- //
        UIImage *closeImg = [UIImage imageNamed:@"prizeCloseBtn.png"];
        closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [closeBtn setImage:closeImg forState:UIControlStateNormal];
        closeBtn.frame = CGRectMake([self bounds].size.width - 20, prizeThumb.frame.origin.y - 12, closeImg.size.width, closeImg.size.height+6);
        
        [closeBtn addTarget:self action:@selector(closeBanner) forControlEvents:UIControlEventTouchUpInside];
        closeBtn.contentMode = UIViewContentModeRedraw;
        [self addSubview:closeBtn];
        [self bringSubviewToFront:closeBtn];
        // -------------------- //
        [self showWithAlphaAnimation];
    
    }
	else if (prizeType == PRIZE_RECOMMENDATION_HTML) {
        
        UIWebView *recommWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0, RECOMMENDATION_TEXTHEIGHT, [self bounds].size.width-1, [self bounds].size.height-(RECOMMENDATION_TEXTHEIGHT))];
        NSString *vgoodUrl = [[[lastVgood theGood] objectForKey:@"content"] stringByReplacingOccurrencesOfString:@"<html>" withString:@""];
        vgoodUrl = [vgoodUrl stringByReplacingOccurrencesOfString:@"<body>" withString:@"<body style=\"font-family:'Lucida Sans Unicode', 'Lucida Grande', sans-serif \">"];
        
        vgoodUrl = [vgoodUrl stringByReplacingOccurrencesOfString:@"<head>" withString:@"<head> <meta name=\"viewport\" content=\"width=300;height=480;user-scalable=yes;initial-scale=1.0;\">"];
        
        NSString *content = [NSString stringWithFormat:@"<!DOCTYPE html PUBLIC \"-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd\"> <html xmlns=\"http://www.w3.org/1999/xhtml\">%@ </body>", vgoodUrl];
        
        [recommWebView loadHTMLString:content baseURL:nil];
        
        recommWebView.delegate = self;
        recommWebView.scalesPageToFit = NO;
        recommWebView.backgroundColor = [UIColor clearColor];
        
		[self addSubview:recommWebView];
		[self sendSubviewToBack:recommWebView];
        
        NSString *rewardText;
        if ([lastVgood.theGood objectForKey:@"rewardText"] != nil) {
            rewardText = [lastVgood.theGood objectForKey:@"rewardText"];
        }
        else{
            rewardText = NSLocalizedStringFromTable(@"vgoodMessageAd", @"BeintooLocalizable", @"Pending");
        }
        UILabel *recommendationLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width-1, RECOMMENDATION_TEXTHEIGHT)];
        recommendationLabel.text            = rewardText;
        recommendationLabel.font            = [UIFont systemFontOfSize:14];
        recommendationLabel.textAlignment   = UITextAlignmentCenter;
        recommendationLabel.backgroundColor = [UIColor clearColor];
        recommendationLabel.textColor       = [UIColor whiteColor];
        
        [self addSubview:recommendationLabel];
        [recommendationLabel release];
        
        // --- CLOSE BUTTON --- //
        //UIImage *closeImg = [UIImage imageNamed:@"bar_close.png"];
        UIImage *closeImg = [UIImage imageNamed:@"prizeCloseBtn.png"];
        closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [closeBtn setImage:closeImg forState:UIControlStateNormal];
        [closeBtn addTarget:self action:@selector(closeBanner) forControlEvents:UIControlEventTouchUpInside];
        closeBtn.contentMode = UIViewContentModeRedraw;
        [self addSubview:closeBtn];
        [self bringSubviewToFront:closeBtn];
        // -------------------- //
    }
}

- (void)removeViews {
	for (UIView *subview in [self subviews]) {
		[subview removeFromSuperview];
	}
}

- (void)closeBanner{
	self.alpha = 0;
	[self removeViews];
	[self removeFromSuperview];
    if ([[self delegate] respondsToSelector:@selector(userDidTapOnClosePrize)])
        [[self delegate] userDidTapOnClosePrize];
    
    isVisible = NO;
}

- (void)setThumbnail:(NSData *)imgData{
    
    BVirtualGood *lastVgood = [Beintoo getLastGeneratedVGood];
    
	if (prizeType == PRIZE_GOOD) {
		self.prizeThumb = [[UIImageView alloc] initWithFrame:CGRectMake(8, ([self bounds].size.height/2 - 54/2), 54, 54)];
		[self.prizeThumb setImage:[UIImage imageWithData:imgData]];
		[self addSubview:self.prizeThumb];
		[self.prizeThumb release];	
	}
	if (prizeType == PRIZE_RECOMMENDATION) {
		prizeThumb.alpha = 1;
		self.prizeThumb = [[UIImageView alloc] initWithFrame:CGRectMake(10, 
                                                                        ([self bounds].size.height/2 - 50/2), 
                                                                        [self bounds].size.width-20, 
                                                                        50)];//self.bounds.size.height- RECOMMENDATION_TEXTHEIGHT)]
		[self.prizeThumb setImage:[UIImage imageWithData:imgData]];
		[self addSubview:self.prizeThumb];
		[self.prizeThumb release];		
        
        NSString *rewardText;
        if ([lastVgood.theGood objectForKey:@"rewardText"] != nil) {
            rewardText = [lastVgood.theGood objectForKey:@"rewardText"];
        }
        else{
            rewardText = NSLocalizedStringFromTable(@"vgoodMessageAd", @"BeintooLocalizable",@"Pending");
        }
        UILabel *recommendationLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.textLabel.frame.origin.y, self.bounds.size.width-1, RECOMMENDATION_TEXTHEIGHT)];
        recommendationLabel.text            = rewardText;
        recommendationLabel.font            = [UIFont systemFontOfSize:14];
        recommendationLabel.textAlignment   = UITextAlignmentCenter;
        recommendationLabel.backgroundColor = [UIColor clearColor];
       // recommendationLabel.textColor       = [UIColor colorWithRed:86.0/255.0 green:86.0/255.0 blue:86.0/255.0 alpha:1.0];
        recommendationLabel.textColor       = [UIColor whiteColor];
       // [self addSubview:recommendationLabel];
        [recommendationLabel release];
	}
}

- (void)preparePrizeAlertOrientation:(CGRect)startingFrame{
    
    self.alpha = 0;
    
	self.transform = CGAffineTransformMakeRotation(DegreesToRadians(0));
	CGRect windowFrame	 = [[Beintoo getAppWindow] bounds];
    
    int alertHeight;
    
    switch (prizeType) {
        case PRIZE_RECOMMENDATION:
            alertHeight = ALERT_HEIGHT_RECOMMENDATION * 1.6;
            break;
        case PRIZE_RECOMMENDATION_HTML:
            alertHeight = ALERT_HEIGHT_RECOMMENDATION_HTML + RECOMMENDATION_TEXTHEIGHT;
            break;
        case PRIZE_GOOD:
            alertHeight = ALERT_HEIGHT_VGOOD * 1.1;
            break;
        default:
            alertHeight = ALERT_HEIGHT_VGOOD * 1.1;
            break;
    }
    
   
    
	if ([Beintoo appOrientation] == UIInterfaceOrientationLandscapeLeft) {
		self.frame = startingFrame;
		self.transform = CGAffineTransformMakeRotation(DegreesToRadians(-90.0));
        
        CGRect vgoodFrame = CGRectMake(0, 0, windowSizeRect.width, windowSizeRect.height);
        [self setFrame:vgoodFrame];
       /* if (prizeType == PRIZE_RECOMMENDATION_HTML){
            CGRect vgoodFrame = CGRectMake(0, 0, windowSizeRect.width, windowSizeRect.height);
            [self setFrame:vgoodFrame];
        
        }
        else {
            
            if ([Beintoo notificationPosition] == BeintooNotificationPositionBottom) {
              //  self.center = CGPointMake(windowFrame.size.width-(alertHeight/2.f), windowFrame.size.height/2.f) ;
                transitionEnterSubtype = kCATransitionFromRight;
                transitionExitSubtype  = kCATransitionFromLeft;
            }
            else if([Beintoo notificationPosition] == BeintooNotificationPositionTop){
               // self.center = CGPointMake((alertHeight/2.f), windowFrame.size.height/2.f) ;
                transitionEnterSubtype = kCATransitionFromLeft;
                transitionExitSubtype  = kCATransitionFromRight;
            }
        }*/
	}
    
	else if ([Beintoo appOrientation] == UIInterfaceOrientationLandscapeRight) {
		self.frame = startingFrame;
		self.transform = CGAffineTransformMakeRotation(DegreesToRadians(90.0));
        
        CGRect vgoodFrame = CGRectMake(0, 0, windowSizeRect.width, windowSizeRect.height);
        [self setFrame:vgoodFrame];
       /* if (prizeType == PRIZE_RECOMMENDATION_HTML){
            
        
        }
        else {
            if ([Beintoo notificationPosition] == BeintooNotificationPositionBottom) {
               // self.center = CGPointMake((alertHeight/2), windowFrame.size.height/2) ;
                transitionEnterSubtype = kCATransitionFromLeft;
                transitionExitSubtype  = kCATransitionFromRight;
            }
            else if([Beintoo notificationPosition] == BeintooNotificationPositionTop){
               // self.center = CGPointMake(windowFrame.size.width-(alertHeight/2.f), windowFrame.size.height/2) ;
                transitionEnterSubtype = kCATransitionFromRight;
                transitionExitSubtype  = kCATransitionFromLeft;
            }
        }*/
        
	}
	else if ([Beintoo appOrientation] == UIInterfaceOrientationPortrait) {
		self.transform = CGAffineTransformMakeRotation(DegreesToRadians(0));
		self.frame = startingFrame;	
        
        CGRect vgoodFrame = CGRectMake(0, 0, windowSizeRect.width, windowSizeRect.height);
        [self setFrame:vgoodFrame];
        
       /* if (prizeType == PRIZE_RECOMMENDATION_HTML){
          
        }
        else {
            if ([Beintoo notificationPosition] == BeintooNotificationPositionBottom) {
               // self.center = CGPointMake(windowFrame.size.width/2, windowFrame.size.height-(alertHeight/2.f));
                transitionEnterSubtype = kCATransitionFromTop;
                transitionExitSubtype  = kCATransitionFromBottom;
            }
            else if([Beintoo notificationPosition] == BeintooNotificationPositionTop){
                //self.center = CGPointMake(windowFrame.size.width/2, (alertHeight/2.f));
                transitionEnterSubtype = kCATransitionFromBottom;
                transitionExitSubtype  = kCATransitionFromTop;
            }
        }*/
        
	}
	
	else if ([Beintoo appOrientation] == UIInterfaceOrientationPortraitUpsideDown) {
		self.transform = CGAffineTransformMakeRotation(DegreesToRadians(180));
		self.frame = startingFrame;
        
        CGRect vgoodFrame = CGRectMake(0, 0, windowSizeRect.width, windowSizeRect.height);
        [self setFrame:vgoodFrame];
        
       /* if (prizeType == PRIZE_RECOMMENDATION_HTML){
            
        }
        else {
            if ([Beintoo notificationPosition] == BeintooNotificationPositionBottom) {
               // self.center = CGPointMake(windowFrame.size.width/2, (alertHeight/2.f));
                transitionEnterSubtype = kCATransitionFromBottom;
                transitionExitSubtype  = kCATransitionFromTop;
            }
            else if([Beintoo notificationPosition] == BeintooNotificationPositionTop){
             //   self.center = CGPointMake(windowFrame.size.width/2, windowFrame.size.height-(alertHeight/2.f));
                transitionEnterSubtype = kCATransitionFromTop;
                transitionExitSubtype  = kCATransitionFromBottom;
            }
        }*/
	}
    
    
    [self performSelectorOnMainThread:@selector(drawPrize) withObject:nil waitUntilDone:YES];
    
}

- (void)webViewDidFinishLoad:(UIWebView *)theWebView {
    
    CGRect frame = theWebView.frame;
    frame.size.height = 1;
    theWebView.frame = frame;
    CGSize fittingSize = [theWebView sizeThatFits:CGSizeZero];
    CGPoint fittingPosition;
    
    if ([Beintoo appOrientation] == UIInterfaceOrientationPortrait || [Beintoo appOrientation] == UIInterfaceOrientationPortraitUpsideDown){
        fittingSize = CGSizeMake(fittingSize.width - 20, fittingSize.height);
        fittingPosition = CGPointMake(windowSizeRect.width/2 - fittingSize.width/2, windowSizeRect.height/2 - fittingSize.height/2);
        closeBtn.frame = CGRectMake(windowSizeRect.width - 28, fittingPosition.y - 10, 20+6, 20+6);
        
    }
    else {
        fittingSize = CGSizeMake(fittingSize.width - 40, fittingSize.height);
        fittingPosition = CGPointMake(windowSizeRect.height/2 - fittingSize.width/2, windowSizeRect.width/2 - fittingSize.height/2);
        closeBtn.frame = CGRectMake(windowSizeRect.height - 33, fittingPosition.y - 10, 20+6, 20+6);
    }
    
    frame.size = fittingSize;
    frame.origin = fittingPosition;
    theWebView.frame = frame;
    
    [self showHtmlWithAlphaAnimation];
    
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{   
	if (firstTouch && (prizeType == PRIZE_GOOD || prizeType == PRIZE_RECOMMENDATION) ) {
		[self setBackgroundColor:[UIColor colorWithRed:50.0/255 green:50.0/255 blue:50.0/255 alpha:0.7]];
		if (prizeType == PRIZE_RECOMMENDATION) {
			self.prizeThumb.alpha = 0.7;
		}
	}
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    [self setBackgroundColor:[UIColor colorWithRed:0.0/255 green:0.0/255 blue:0.0/255 alpha:0.7]];
    if ([[self delegate] respondsToSelector:@selector(userDidTapOnThePrize)])
        [[self delegate] userDidTapOnThePrize];
    
    self.alpha  = 0;
    
    firstTouch = YES;
    
    [self removeViews];
    [self removeFromSuperview];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    
    NSMutableURLRequest *req    = (NSMutableURLRequest *)request;
    NSString *urlString         = [req.URL absoluteString];    
    
    if(navigationType == UIWebViewNavigationTypeOther && ([urlString rangeOfString:@"about:blank"].location != NSNotFound)){
        return YES;
    }
    
    if(navigationType == UIWebViewNavigationTypeLinkClicked || navigationType == UIWebViewNavigationTypeOther){
        
        NSString *nexageURLToOpen = @"http://";
        if ([urlString rangeOfString:nexageURLToOpen].location != NSNotFound) {
            // We have to open a nexage URL on the webView
            [Beintoo getLastGeneratedVGood].getItRealURL = urlString;
            [self userClickedOnWebView];
        }
        else{
            [self userDidFailToClickOnWebView];
        }
        return NO;
    }
    return YES;
}

// WEB VIEW related methods

- (void)userClickedOnWebView{
    [self setBackgroundColor:[UIColor colorWithRed:0.0/255 green:0.0/255 blue:0.0/255 alpha:0.7]];
    if ([[self delegate] respondsToSelector:@selector(userDidTapOnThePrize)])
        [[self delegate] userDidTapOnThePrize];
    
	self.alpha  = 0;
    
	firstTouch = YES;
    
    [self removeViews];
	[self removeFromSuperview];
}

- (void)userDidFailToClickOnWebView{
	self.alpha = 0;
	[self removeViews];
	[self removeFromSuperview];
    
}

- (void)dealloc {
    [self.textLabel release];
    [super dealloc];
}

@end
