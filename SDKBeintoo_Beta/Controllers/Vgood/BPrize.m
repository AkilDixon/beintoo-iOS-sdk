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

@synthesize beintooLogo,prizeImg,prizeThumb,textLabel,detailedTextLabel,delegate,prizeType;

-(id)init {
	if (self = [super init]){
		
	}
    return self;
}

- (void)setPrizeContentWithWindowSize:(CGSize)windowSize{
	firstTouch = YES;
	
	self.backgroundColor = [UIColor colorWithRed:0.0/255 green:0.0/255 blue:0.0/255 alpha:0.7];
	self.layer.cornerRadius = 2;
	self.layer.borderColor  = [UIColor colorWithWhite:1 alpha:0.8].CGColor;
	self.layer.borderWidth  = 0;
	
	BVirtualGood *lastVgood = [Beintoo getLastGeneratedVGood];
	
	self.frame = CGRectZero;
	
	// Banner frame initialization: a vgood frame is a little bit smaller than a recommendation
	int _prizeType = PRIZE_GOOD;
	CGRect vgoodFrame = CGRectMake(5, windowSize.height-ALERT_HEIGHT_VGOOD, 
                                   310, ALERT_HEIGHT_VGOOD);
    
	if ([lastVgood isRecommendation]) {
		_prizeType = PRIZE_RECOMMENDATION;
        vgoodFrame = CGRectMake(1, windowSize.height-(ALERT_HEIGHT_RECOMMENDATION + RECOMMENDATION_TEXTHEIGHT),  
                                318, ALERT_HEIGHT_RECOMMENDATION + RECOMMENDATION_TEXTHEIGHT);

		if ([lastVgood isHTMLRecommendation]) {
			_prizeType = PRIZE_RECOMMENDATION_HTML;
            vgoodFrame = CGRectMake(1,  windowSize.height - (ALERT_HEIGHT_RECOMMENDATION_HTML + RECOMMENDATION_TEXTHEIGHT), 
                                    318, ALERT_HEIGHT_RECOMMENDATION_HTML + RECOMMENDATION_TEXTHEIGHT);
		}
	}
	prizeType = _prizeType;
	
	[self setFrame:vgoodFrame];

	[self preparePrizeAlertOrientation:vgoodFrame];
}

- (void)show{
	
	self.alpha = 0;
		
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

- (void)animationDidStop:(CAAnimation *)animation finished:(BOOL)flag{
	if ([[animation valueForKey:@"name"] isEqualToString:@"load"]) {
	}
}


- (void)drawPrize{
	
	BVirtualGood *lastVgood = [Beintoo getLastGeneratedVGood];

	[self removeViews];
	[self setThumbnail:lastVgood.vGoodImageData];	
		
	self.textLabel = [[UILabel alloc] initWithFrame:CGRectMake(68, 5, [self bounds].size.width-90, 55)];
    
    // Custom reward text. If there is a text on the retrieved good is shown, otherwise we use the default text
    
    if ([lastVgood.theGood objectForKey:@"rewardText"]!=nil) {
        self.textLabel.text = [lastVgood.theGood objectForKey:@"rewardText"];
    }
    else{
        self.textLabel.text = NSLocalizedStringFromTable(@"vgoodMessageBanner",@"BeintooLocalizable",@"Pending");
    }
	self.textLabel.font = [UIFont systemFontOfSize:13];
	self.textLabel.numberOfLines = 4;
	self.textLabel.textAlignment = UITextAlignmentCenter;
	self.textLabel.backgroundColor = [UIColor clearColor];
	self.textLabel.textColor = [UIColor colorWithWhite:1 alpha:1];
	[self.textLabel release];
		
	// -- normal vgood:			we need to add two label to give details.
	// -- recommendation:		the thumbnail frame will be extended to cover all the prizeAlert
	// -- html recommendation:	we add a small webview as subview, then we load the html content on it
	
	if (prizeType == PRIZE_GOOD) {  
		[self addSubview:self.textLabel];
	}
	else if (prizeType == PRIZE_RECOMMENDATION_HTML) {
		UIWebView *recommWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0, RECOMMENDATION_TEXTHEIGHT, [self bounds].size.width-1, [self bounds].size.height-(RECOMMENDATION_TEXTHEIGHT))];
        		
		[recommWebView loadHTMLString:[[lastVgood theGood] objectForKey:@"content"] baseURL:nil];

        recommWebView.delegate = self;
        recommWebView.scalesPageToFit = NO;
        recommWebView.backgroundColor = [UIColor clearColor];
        
		//recommWebView.userInteractionEnabled = NO; // this will make the UIWebView transparent to touchess
		[self addSubview:recommWebView];
		[self sendSubviewToBack:recommWebView];
        
        NSString *rewardText;
        if ([lastVgood.theGood objectForKey:@"rewardText"]!=nil) {
            rewardText = [lastVgood.theGood objectForKey:@"rewardText"];
        }
        else{
            rewardText = NSLocalizedStringFromTable(@"vgoodMessageAd",@"BeintooLocalizable",@"Pending");
        }
        UILabel *recommendationLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width-1, RECOMMENDATION_TEXTHEIGHT)];
        recommendationLabel.text            = rewardText;
        recommendationLabel.font            = [UIFont systemFontOfSize:14];
        recommendationLabel.textAlignment   = UITextAlignmentCenter;
        recommendationLabel.backgroundColor = [UIColor clearColor];
        recommendationLabel.textColor       = [UIColor whiteColor];

        [self addSubview:recommendationLabel];
        [recommendationLabel release];
	}
	
	// --- CLOSE BUTTON --- //
	//UIImage *closeImg = [UIImage imageNamed:@"bar_close.png"];
	UIImage *closeImg = [UIImage imageNamed:@"prizeCloseBtn.png"];
	closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
	[closeBtn setImage:closeImg forState:UIControlStateNormal];
	closeBtn.frame = CGRectMake([self bounds].size.width-27,0,closeImg.size.width+10, closeImg.size.height+6);
	[closeBtn addTarget:self action:@selector(closeBanner) forControlEvents:UIControlEventTouchUpInside];
	closeBtn.contentMode = UIViewContentModeRedraw;
	[self addSubview:closeBtn];
	[self bringSubviewToFront:closeBtn];
	// -------------------- //
	
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
	[[self delegate] userDidTapOnClosePrize];
}

- (void)setThumbnail:(NSData *)imgData{

    BVirtualGood *lastVgood = [Beintoo getLastGeneratedVGood];
    
	if (prizeType == PRIZE_GOOD) {
		self.prizeThumb = [[UIImageView alloc] initWithFrame:CGRectMake(8, 8, 53, 53)];
		[self.prizeThumb setImage:[UIImage imageWithData:imgData]];
		[self addSubview:self.prizeThumb];
		[self.prizeThumb release];	
	}
	if (prizeType == PRIZE_RECOMMENDATION) {
		prizeThumb.alpha = 1;
		self.prizeThumb = [[UIImageView alloc] initWithFrame:CGRectMake(1, 
                                                                        RECOMMENDATION_TEXTHEIGHT, 
                                                                        [self bounds].size.width-1, 
                                                                        50)];//self.bounds.size.height- RECOMMENDATION_TEXTHEIGHT)]
		[self.prizeThumb setImage:[UIImage imageWithData:imgData]];
		[self addSubview:self.prizeThumb];
		[self.prizeThumb release];		
        
        NSString *rewardText;
        if ([lastVgood.theGood objectForKey:@"rewardText"]!=nil) {
            rewardText = [lastVgood.theGood objectForKey:@"rewardText"];
        }
        else{
            rewardText = NSLocalizedStringFromTable(@"vgoodMessageAd",@"BeintooLocalizable",@"Pending");
        }
        UILabel *recommendationLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width-1, RECOMMENDATION_TEXTHEIGHT)];
        recommendationLabel.text            = rewardText;
        recommendationLabel.font            = [UIFont systemFontOfSize:14];
        recommendationLabel.textAlignment   = UITextAlignmentCenter;
        recommendationLabel.backgroundColor = [UIColor clearColor];
        recommendationLabel.textColor       = [UIColor whiteColor];
        
        [self addSubview:recommendationLabel];
        [recommendationLabel release];
	}
}

- (void)preparePrizeAlertOrientation:(CGRect)startingFrame{
	self.transform = CGAffineTransformMakeRotation(DegreesToRadians(0));
	CGRect windowFrame	 = [[Beintoo getAppWindow] bounds];
    
    int alertHeight;
    
    switch (prizeType) {
        case PRIZE_RECOMMENDATION:
            alertHeight = ALERT_HEIGHT_RECOMMENDATION * 1.6;
            break;
        case PRIZE_RECOMMENDATION_HTML:
            alertHeight = ALERT_HEIGHT_RECOMMENDATION_HTML * 1.6;
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
		//self.center = CGPointMake(windowFrame.size.width-(alertHeight/2.f), windowFrame.size.height/2.f) ;
        
        if ([Beintoo notificationPosition] == BeintooNotificationPositionBottom) {
            self.center = CGPointMake(windowFrame.size.width-(alertHeight/2.f), windowFrame.size.height/2.f) ;
            transitionEnterSubtype = kCATransitionFromRight;
            transitionExitSubtype  = kCATransitionFromLeft;
        }
        else if([Beintoo notificationPosition] == BeintooNotificationPositionTop){
            self.center = CGPointMake((alertHeight/2.f), windowFrame.size.height/2.f) ;
            transitionEnterSubtype = kCATransitionFromLeft;
            transitionExitSubtype  = kCATransitionFromRight;
        }
	}
    
	else if ([Beintoo appOrientation] == UIInterfaceOrientationLandscapeRight) {
		self.frame = startingFrame;
		self.transform = CGAffineTransformMakeRotation(DegreesToRadians(90.0));
		//self.center = CGPointMake(1+(alertHeight/2), windowFrame.size.height/2) ;
        
        if ([Beintoo notificationPosition] == BeintooNotificationPositionBottom) {
            self.center = CGPointMake((alertHeight/2), windowFrame.size.height/2) ;
            transitionEnterSubtype = kCATransitionFromLeft;
            transitionExitSubtype  = kCATransitionFromRight;
        }
        else if([Beintoo notificationPosition] == BeintooNotificationPositionTop){
            self.center = CGPointMake(windowFrame.size.width-(alertHeight/2.f), windowFrame.size.height/2) ;
            transitionEnterSubtype = kCATransitionFromRight;
            transitionExitSubtype  = kCATransitionFromLeft;
        }

	}
	else if ([Beintoo appOrientation] == UIInterfaceOrientationPortrait) {
		self.transform = CGAffineTransformMakeRotation(DegreesToRadians(0));
		self.frame = startingFrame;	
		//self.center = CGPointMake(windowFrame.size.width/2, windowFrame.size.height-(alertHeight/2.f));
        
        if ([Beintoo notificationPosition] == BeintooNotificationPositionBottom) {
            self.center = CGPointMake(windowFrame.size.width/2, windowFrame.size.height-(alertHeight/2.f));
            transitionEnterSubtype = kCATransitionFromTop;
            transitionExitSubtype  = kCATransitionFromBottom;
        }
        else if([Beintoo notificationPosition] == BeintooNotificationPositionTop){
            self.center = CGPointMake(windowFrame.size.width/2, (alertHeight/2.f));
            transitionEnterSubtype = kCATransitionFromBottom;
            transitionExitSubtype  = kCATransitionFromTop;
        }

	}
	
	else if ([Beintoo appOrientation] == UIInterfaceOrientationPortraitUpsideDown) {
		self.transform = CGAffineTransformMakeRotation(DegreesToRadians(180));
		self.frame = startingFrame;	
		//self.center = CGPointMake(windowFrame.size.width/2, 1+(alertHeight/2.f));
        
        if ([Beintoo notificationPosition] == BeintooNotificationPositionBottom) {
            self.center = CGPointMake(windowFrame.size.width/2, (alertHeight/2.f));
            transitionEnterSubtype = kCATransitionFromBottom;
            transitionExitSubtype  = kCATransitionFromTop;
        }
        else if([Beintoo notificationPosition] == BeintooNotificationPositionTop){
            self.center = CGPointMake(windowFrame.size.width/2, windowFrame.size.height-(alertHeight/2.f));
            transitionEnterSubtype = kCATransitionFromTop;
            transitionExitSubtype  = kCATransitionFromBottom;
        }
	}

    [self performSelectorOnMainThread:@selector(drawPrize) withObject:nil waitUntilDone:YES];
	//[self drawPrize];
}

- (void)webViewDidFinishLoad:(UIWebView *)theWebView {
    int newHeight    = [[theWebView stringByEvaluatingJavaScriptFromString: @"document.height"] intValue];
    theWebView.frame = CGRectMake(theWebView.frame.origin.x, theWebView.frame.origin.y, theWebView.frame.size.width, newHeight);
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
    if (prizeType == PRIZE_GOOD || prizeType == PRIZE_RECOMMENDATION) {
        [self setBackgroundColor:[UIColor colorWithRed:0.0/255 green:0.0/255 blue:0.0/255 alpha:0.7]];
        [[self delegate] userDidTapOnThePrize];
        self.alpha  = 0;
        
        firstTouch = YES;
        
        [self removeViews];
        [self removeFromSuperview];
    }
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    
    NSMutableURLRequest *req    = (NSMutableURLRequest *)request;
    NSString *urlString         = [req.URL absoluteString];    
    
    //self.frame = CGRectMake(0, 0, 320, 446);
    //[self setNeedsDisplay];
    //return  YES;

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
    [super dealloc];
}

@end
