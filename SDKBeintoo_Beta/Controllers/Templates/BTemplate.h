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

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "BeintooDevice.h"

#define TEMPLATE_TYPE_REWARD  1000
#define TEMPLATE_TYPE_AD      1001

@class BRewardWrapper, BAdWrapper;

@protocol BeintooTemplateDelegate;

@interface BTemplate : UIView <UIWebViewDelegate>{
	
	NSString		*transitionEnterSubtype;
	NSString		*transitionExitSubtype;
	
    BOOL            isVisible;
	int				prizeType;
	
	id <BeintooTemplateDelegate> delegate;
    id <BeintooTemplateDelegate> globalDelegate;
    
    CGSize windowSizeRect;
    
    UIWebView *recommWebView;
    
    BRewardWrapper  *reward;
    BAdWrapper      *ad;
}

#ifdef BEINTOO_ARC_AVAILABLE
@property(nonatomic, retain) id <BeintooTemplateDelegate> delegate;
@property(nonatomic, retain) id <BeintooTemplateDelegate> globalDelegate;
#else
@property(nonatomic, assign) id <BeintooTemplateDelegate> delegate;
@property(nonatomic, assign) id <BeintooTemplateDelegate> globalDelegate;
#endif

@property(nonatomic, retain) BRewardWrapper  *reward;
@property(nonatomic, retain) BAdWrapper      *ad;
@property(nonatomic, assign) BOOL isVisible;
@property(nonatomic, assign) int type;

- (id)initWithReward:(BRewardWrapper *)wrapper;
- (id)initWithAd:(BAdWrapper *)wrapper;

- (void)removeViews;
- (void)show;
- (void)showWithAlphaAnimation;
- (void)drawPrize;
- (void)showHtmlWithAlphaAnimation;
- (void)setPrizeContentWithWindowSize:(CGSize)windowSize;
- (void)preparePrizeAlertOrientation:(CGRect)startingFrame;

@end

@protocol BeintooTemplateDelegate <NSObject>

@optional

- (void)beintooRewardHasBeenClosed;
- (void)beintooRewardHasBeenTapped;

- (void)beintooAdHasBeenClosed;
- (void)beintooAdHasBeenTapped;

- (void)beintooRewardControllerWillAppear;
- (void)beintooRewardControllerDidAppear;
- (void)beintooRewardControllerWillDisappear;
- (void)beintooRewardControllerDidDisappear;

- (void)beintooRewardWillAppear;
- (void)beintooRewardDidAppear;
- (void)beintooRewardWillDisappear;
- (void)beintooRewardDidDisappear;

- (void)beintooAdWillAppear;
- (void)beintooAdDidAppear;
- (void)beintooAdDidDisappear;
- (void)beintooAdWillDisappear;

- (void)beintooAdControllerWillAppear;
- (void)beintooAdControllerDidAppear;
- (void)beintooAdControllerDidDisappear;
- (void)beintooAdControllerWillDisappear;

@end

