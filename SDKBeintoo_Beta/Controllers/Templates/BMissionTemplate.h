//
//  BMissionTemplate.m
//  SampleBeintoo
//
//  Created by Giuseppe Piazzese on 06/06/13.
//
//

#import "BMissionTemplate.h"
#import "BeintooDevice.h"

#define PRIZE_GOOD					1
#define PRIZE_RECOMMENDATION		2
#define PRIZE_RECOMMENDATION_HTML	3

#define ALERT_HEIGHT_RECOMMENDATION_HTML	70
#define ALERT_HEIGHT_RECOMMENDATION         50
#define ALERT_HEIGHT_VGOOD                  69
#define RECOMMENDATION_TEXTHEIGHT           25

#define REWARD  100
#define AD      101

extern NSString *BeintooUrlSchemeWebviewAcceptMission;
extern NSString *BeintooUrlSchemeWebviewRefuseMission;
extern NSString *BeintooUrlSchemeWebviewCloseView;

@class BMissionWrapper;

@protocol BMissionTemplateDelegate;

@interface BMissionTemplate : UIView <UIWebViewDelegate>
{
	NSString		*transitionEnterSubtype;
	NSString		*transitionExitSubtype;
	BOOL            isVisible;
	int				prizeType;
	
	id <BMissionTemplateDelegate> delegate;
    id <BMissionTemplateDelegate> globalDelegate;
    
    CGSize windowSizeRect;
    
    UIWebView *recommWebView;
}

#ifdef BEINTOO_ARC_AVAILABLE
@property(nonatomic, retain) id <BMissionTemplateDelegate> delegate;
@property(nonatomic, retain) id <BMissionTemplateDelegate> globalDelegate;
#else
@property(nonatomic, assign) id <BMissionTemplateDelegate> delegate;
@property(nonatomic, assign) id <BMissionTemplateDelegate> globalDelegate;
#endif

@property (nonatomic, retain) BMissionWrapper *missionWrapper;
@property (nonatomic) int prizeType;
@property (nonatomic, assign) BOOL isVisible;
@property (nonatomic) int type;

- (id)initWithMission:(BMissionWrapper *)_mission;

- (void)show;
- (void)showWithAlphaAnimation;
- (void)drawPrize;
- (void)showHtmlWithAlphaAnimation;
- (void)setPrizeContentWithWindowSize:(CGSize)windowSize;
- (void)preparePrizeAlertOrientation:(CGRect)startingFrame;

- (void)userClickedOnWebView;
- (void)userDidFailToClickOnWebView;

@end

@protocol BMissionTemplateDelegate <NSObject>

@optional

- (void)userDidTapOnThePrize;
- (void)userDidTapOnClosePrize;

- (void)userDidTapOnTheAd;
- (void)userDidTapOnCloseAd;

- (void)beintooPrizeWillAppear;
- (void)beintooPrizeDidAppear;
- (void)beintooPrizeDidDisappear;
- (void)beintooPrizeWillDisappear;

- (void)beintooPrizeAlertWillAppear;
- (void)beintooPrizeAlertDidAppear;
- (void)beintooPrizeAlertDidDisappear;
- (void)beintooPrizeAlertWillDisappear;

- (void)beintooAdWillAppear;
- (void)beintooAdDidAppear;
- (void)beintooAdDidDisappear;
- (void)beintooAdWillDisappear;

- (void)beintooAdControllerWillAppear;
- (void)beintooAdControllerDidAppear;
- (void)beintooAdControllerDidDisappear;
- (void)beintooAdControllerWillDisappear;

@end
