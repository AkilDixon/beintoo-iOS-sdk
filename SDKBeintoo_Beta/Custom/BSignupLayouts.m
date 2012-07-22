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

#import "BSignupLayouts.h"
#import <QuartzCore/QuartzCore.h>
#import "Beintoo.h"


@implementation BSignupLayouts

+ (UIView *)getBeintooDashboardSignupViewWithFrame:(CGRect)_frame andButtonActionSelector:(SEL)_selector fromSender:(id)_caller
{
   
    UIView  *signupView         = [[[UIView alloc] initWithFrame:_frame] autorelease];
    signupView.backgroundColor  = [UIColor whiteColor];
    
    UILabel *signupLabel        = [[UILabel alloc] initWithFrame:CGRectMake(10, 6, _frame.size.width-20, 50)];
    signupLabel.adjustsFontSizeToFitWidth = YES;
    signupLabel.backgroundColor = [UIColor clearColor];
    signupLabel.numberOfLines   = 3;
    signupLabel.font            = [UIFont systemFontOfSize:13];
    signupLabel.textColor       = [UIColor colorWithWhite:0 alpha:0.8];
    signupLabel.textAlignment   = UITextAlignmentCenter;
    signupLabel.text            = NSLocalizedStringFromTable(@"dashplayerhometext",@"BeintooLocalizable",@"Select A Friend");
    
    [signupView addSubview:signupLabel];
    [signupLabel release];
    
    BButton *signupButton       = [[BButton alloc] initWithFrame:CGRectMake(20, 65, 290, 43)];
    signupButton.center         = CGPointMake(_frame.size.width/2, 81);
    [signupButton setHighColor:[UIColor colorWithRed:156.0/255 green:168.0/255 blue:184.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(156, 2)/pow(255,2) green:pow(168, 2)/pow(255,2) blue:pow(184, 2)/pow(255,2) alpha:1]];
    [signupButton setMediumHighColor:[UIColor colorWithRed:116.0/255 green:135.0/255 blue:159.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(116, 2)/pow(255,2) green:pow(135, 2)/pow(255,2) blue:pow(159, 2)/pow(255,2) alpha:1]];
    [signupButton setMediumLowColor:[UIColor colorWithRed:108.0/255 green:128.0/255 blue:154.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(108, 2)/pow(255,2) green:pow(128, 2)/pow(255,2) blue:pow(154, 2)/pow(255,2) alpha:1]];
    [signupButton setLowColor:[UIColor colorWithRed:89.0/255 green:112.0/255 blue:142.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(89, 2)/pow(255,2) green:pow(112, 2)/pow(255,2) blue:pow(142, 2)/pow(255,2) alpha:1]];
    NSString *signupString = NSLocalizedStringFromTable(@"dashplayersignupnow",@"BeintooLocalizable",@"");
    [signupButton setTitle:[signupString uppercaseString] forState:UIControlStateNormal];
    [signupButton addTarget:_caller action:_selector forControlEvents:UIControlEventTouchUpInside];
    [signupButton setButtonTextSize:20];
    signupButton.layer.cornerRadius = 4;

    [signupView addSubview:signupButton];
    [signupButton release];
    
  
    UIView  *lowBorder1          = [[UIView alloc] initWithFrame:CGRectMake(0, _frame.size.height-2, _frame.size.width, 1)];
    lowBorder1.backgroundColor   = [UIColor colorWithWhite:0 alpha:0.4];
    UIView  *lowBorder2          = [[UIView alloc] initWithFrame:CGRectMake(0, _frame.size.height-1, _frame.size.width, 1)];
    lowBorder2.backgroundColor   = [UIColor colorWithWhite:0 alpha:0.1];
    
    [signupView addSubview:lowBorder1];
    [lowBorder1 release];
    [signupView addSubview:lowBorder2];
    [lowBorder2 release];

    return signupView;
}


+ (UIView *)getBeintooLeaderboardSignupViewWithFrame:(CGRect)_frame andButtonActionSelector:(SEL)_selector fromSender:(id)_caller{
    UIView  *signupView         = [[[UIView alloc] initWithFrame:_frame] autorelease];
    signupView.backgroundColor  = [UIColor whiteColor];
    
    UILabel *signupLabel        = [[UILabel alloc] initWithFrame:CGRectMake(10, 6, _frame.size.width-20, 33)];
    signupLabel.adjustsFontSizeToFitWidth = YES;
    signupLabel.backgroundColor = [UIColor clearColor];
    signupLabel.numberOfLines   = 2;
    signupLabel.font            = [UIFont systemFontOfSize:13];
    signupLabel.textColor       = [UIColor colorWithWhite:0 alpha:0.8];
    signupLabel.textAlignment   = UITextAlignmentCenter;
    signupLabel.text            = NSLocalizedStringFromTable(@"dashplayerleaderboardtext",@"BeintooLocalizable",@"Select A Friend");
    
    [signupView addSubview:signupLabel];
    [signupLabel release];
    
    BButton *signupButton       = [[BButton alloc] initWithFrame:CGRectMake(20, 48, 290, 35)];
    signupButton.center         = CGPointMake(_frame.size.width/2, 64);
    [signupButton setHighColor:[UIColor colorWithRed:156.0/255 green:168.0/255 blue:184.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(156, 2)/pow(255,2) green:pow(168, 2)/pow(255,2) blue:pow(184, 2)/pow(255,2) alpha:1]];
    [signupButton setMediumHighColor:[UIColor colorWithRed:116.0/255 green:135.0/255 blue:159.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(116, 2)/pow(255,2) green:pow(135, 2)/pow(255,2) blue:pow(159, 2)/pow(255,2) alpha:1]];
    [signupButton setMediumLowColor:[UIColor colorWithRed:108.0/255 green:128.0/255 blue:154.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(108, 2)/pow(255,2) green:pow(128, 2)/pow(255,2) blue:pow(154, 2)/pow(255,2) alpha:1]];
    [signupButton setLowColor:[UIColor colorWithRed:89.0/255 green:112.0/255 blue:142.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(89, 2)/pow(255,2) green:pow(112, 2)/pow(255,2) blue:pow(142, 2)/pow(255,2) alpha:1]];
    NSString *signupString = NSLocalizedStringFromTable(@"dashplayersignupnow",@"BeintooLocalizable",@"");
    [signupButton setTitle:[signupString uppercaseString] forState:UIControlStateNormal];
    [signupButton addTarget:_caller action:_selector forControlEvents:UIControlEventTouchUpInside];
    [signupButton setButtonTextSize:20];
    signupButton.layer.cornerRadius = 4;
    
    [signupView addSubview:signupButton];
    [signupButton release];
    
    
    UIView  *lowBorder1          = [[UIView alloc] initWithFrame:CGRectMake(0, _frame.size.height-2, _frame.size.width, 1)];
    lowBorder1.backgroundColor   = [UIColor colorWithWhite:0 alpha:0.4];
    UIView  *lowBorder2          = [[UIView alloc] initWithFrame:CGRectMake(0, _frame.size.height-1, _frame.size.width, 1)];
    lowBorder2.backgroundColor   = [UIColor colorWithWhite:0 alpha:0.1];
    
    [signupView addSubview:lowBorder1];
    [lowBorder1 release];
    [signupView addSubview:lowBorder2];
    [lowBorder2 release];
    
    return signupView;
}

+ (UIView *)getBeintooSignupViewForProfileWithFrame:(CGRect)_frame andButtonActionSelector:(SEL)_selector fromSender:(id)_caller{
    
    UIView *signupView          = [[BGradientView alloc] initWithFrame:_frame];
    signupView.backgroundColor  = [UIColor clearColor];
    
    UILabel *signupLabel        = [[UILabel alloc] initWithFrame:CGRectMake(5, 8, _frame.size.width-10, 33)];
    signupLabel.adjustsFontSizeToFitWidth = YES;
    signupLabel.backgroundColor = [UIColor clearColor];
    signupLabel.numberOfLines   = 2;
    signupLabel.font            = [UIFont systemFontOfSize:13];
    signupLabel.textColor       = [UIColor colorWithWhite:0 alpha:0.9];
    signupLabel.textAlignment   = UITextAlignmentLeft;
    signupLabel.text            = NSLocalizedStringFromTable(@"dashplayerprofiletext",@"BeintooLocalizable",@"");
    
    [signupView addSubview:signupLabel];
    [signupLabel release];
    
    BButton *signupButton       = [[BButton alloc] initWithFrame:CGRectMake(20, 48, 200, 30)];
    signupButton.center         = CGPointMake(_frame.size.width/2-5, 64);
    [signupButton setHighColor:[UIColor colorWithRed:156.0/255 green:168.0/255 blue:184.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(156, 2)/pow(255,2) green:pow(168, 2)/pow(255,2) blue:pow(184, 2)/pow(255,2) alpha:1]];
    [signupButton setMediumHighColor:[UIColor colorWithRed:116.0/255 green:135.0/255 blue:159.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(116, 2)/pow(255,2) green:pow(135, 2)/pow(255,2) blue:pow(159, 2)/pow(255,2) alpha:1]];
    [signupButton setMediumLowColor:[UIColor colorWithRed:108.0/255 green:128.0/255 blue:154.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(108, 2)/pow(255,2) green:pow(128, 2)/pow(255,2) blue:pow(154, 2)/pow(255,2) alpha:1]];
    [signupButton setLowColor:[UIColor colorWithRed:89.0/255 green:112.0/255 blue:142.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(89, 2)/pow(255,2) green:pow(112, 2)/pow(255,2) blue:pow(142, 2)/pow(255,2) alpha:1]];
    NSString *signupString = NSLocalizedStringFromTable(@"dashplayersignupnow",@"BeintooLocalizable",@"");
    [signupButton setTitle:[signupString uppercaseString] forState:UIControlStateNormal];
    [signupButton addTarget:_caller action:_selector forControlEvents:UIControlEventTouchUpInside];
    [signupButton setButtonTextSize:16];
    
    [signupView addSubview:signupButton];
    
    [signupButton release];
    
    return signupView;
}

// NOT USED NOW
+ (UIView *)getBeintooDashboardViewForLockedFeatureWithFrame:(CGRect)_frame andButtonActionSelector:(SEL)_selector fromSender:(UIViewController *)_caller andFeature:(NSDictionary *)_feature{
    
    UIView  *shadowView                 = [[UIView alloc] initWithFrame:_caller.view.bounds];
    shadowView.backgroundColor          = [UIColor colorWithWhite:0 alpha:0.5];
    
    UIView  *containerView              = [[UIView alloc] initWithFrame:_frame];
    // we center this subview at the center of the calling frame, shifted 20 pixel up
    containerView.center                = CGPointMake(_caller.view.bounds.size.width/2, (_caller.view.bounds.size.height/2 - 10));
    containerView.layer.borderColor     = [UIColor darkGrayColor].CGColor;
    containerView.layer.cornerRadius    = 1.0;
    containerView.layer.borderWidth     = 2.0;
    
    // ------------ FEATURE VIEW --------------------------
    BGradientView *featureView  = [[BGradientView alloc] initWithGradientType:GRADIENT_CELL_BODY];
    featureView.frame            = CGRectMake(0, 0, _frame.size.width, 160);
    
    UIImageView *iconImage      = [[UIImageView alloc] initWithFrame:CGRectMake(13, 20, 56, 56)];
    iconImage.image             = [UIImage imageNamed:[_feature objectForKey:@"featureImg"]];

    [featureView addSubview:iconImage];
    [iconImage release];
    
    // Close Button
    int closeBtnOffset      = 33;
    UIImage* closeBtnImg    = [UIImage imageNamed:@"popupCloseBtn.png"];
    UIButton* closeBtn      = [UIButton buttonWithType:UIButtonTypeCustom];
    closeBtn.alpha          = 0.8;
    [closeBtn setImage:closeBtnImg forState:UIControlStateNormal];
    [closeBtn setFrame:CGRectMake(_frame.size.width - closeBtnOffset, 7 ,
								  closeBtnImg.size.width, closeBtnImg.size.height)];
	
    [closeBtn addTarget:_caller action:@selector(dismissFeatureSignupView) forControlEvents:UIControlEventTouchUpInside];
    [featureView addSubview: closeBtn];

    
    UILabel *featureLabel        = [[UILabel alloc] initWithFrame:CGRectMake(80, 15, _frame.size.width-80, 25)];
    featureLabel.backgroundColor = [UIColor clearColor];
    featureLabel.numberOfLines   = 1;
    featureLabel.font            = [UIFont systemFontOfSize:18];
    featureLabel.textColor       = [UIColor colorWithWhite:0 alpha:1];
    featureLabel.textAlignment   = UITextAlignmentLeft;
    featureLabel.text            = [_feature objectForKey:@"featureName"];
    
    [featureView addSubview:featureLabel];
    [featureLabel release];
    
    UILabel *featureDesc        = [[UILabel alloc] initWithFrame:CGRectMake(80, 43, _frame.size.width-80, 40)];
    featureDesc.backgroundColor = [UIColor clearColor];
    featureDesc.numberOfLines   = 2;
    featureDesc.font            = [UIFont systemFontOfSize:13];
    featureDesc.textColor       = [UIColor colorWithWhite:0 alpha:0.7];
    featureDesc.textAlignment   = UITextAlignmentLeft;
    featureDesc.text            = @"Spiegazione 1";
    
    [featureView addSubview:featureDesc];
    [featureDesc release];
    
    UILabel *commentLabel        = [[UILabel alloc] initWithFrame:CGRectMake(13, 80, _frame.size.width-26, 60)];
    commentLabel.adjustsFontSizeToFitWidth = YES;
    commentLabel.backgroundColor = [UIColor clearColor];
    commentLabel.numberOfLines   = 3;
    commentLabel.font            = [UIFont systemFontOfSize:13];
    commentLabel.textColor       = [UIColor colorWithWhite:0 alpha:0.7];
    commentLabel.textAlignment   = UITextAlignmentLeft;
    commentLabel.text            = @"Registrati per avere la possibilità di utilizzare tutte le funzioni, tips tante belle cose da fare. E' gratis, prova ora";
    
    [featureView addSubview:commentLabel];
    [commentLabel release];
    
    [containerView addSubview:featureView];
    [featureView release];
    // ------------------------------------------------------
    
    // ------------------ SIGNUP VIEW -----------------------
    BGradientView *signupView   = [[BGradientView alloc] initWithGradientType:GRADIENT_BODY];
    signupView.frame            = CGRectMake(0, 160, _frame.size.width, _frame.size.height-160);
        
    BButton *signupButton       = [[BButton alloc] initWithFrame:CGRectMake(20, 55, 220, 35)];
    signupButton.center         = CGPointMake(_frame.size.width/2, 30);
    [signupButton setHighColor:[UIColor colorWithRed:156.0/255 green:168.0/255 blue:184.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(156, 2)/pow(255,2) green:pow(168, 2)/pow(255,2) blue:pow(184, 2)/pow(255,2) alpha:1]];
    [signupButton setMediumHighColor:[UIColor colorWithRed:116.0/255 green:135.0/255 blue:159.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(116, 2)/pow(255,2) green:pow(135, 2)/pow(255,2) blue:pow(159, 2)/pow(255,2) alpha:1]];
    [signupButton setMediumLowColor:[UIColor colorWithRed:108.0/255 green:128.0/255 blue:154.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(108, 2)/pow(255,2) green:pow(128, 2)/pow(255,2) blue:pow(154, 2)/pow(255,2) alpha:1]];
    [signupButton setLowColor:[UIColor colorWithRed:89.0/255 green:112.0/255 blue:142.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(89, 2)/pow(255,2) green:pow(112, 2)/pow(255,2) blue:pow(142, 2)/pow(255,2) alpha:1]];
    NSString *signupString = NSLocalizedStringFromTable(@"signup",@"BeintooLocalizable",@"");
    [signupButton setTitle:[signupString uppercaseString] forState:UIControlStateNormal];
    [signupButton addTarget:_caller action:_selector forControlEvents:UIControlEventTouchUpInside];
    [signupButton setButtonTextSize:18];
    
    [signupView addSubview:signupButton];
    [signupButton release];
    
    [containerView addSubview:signupView];
    [signupView release];
    // --------------------------------------------------------
    
    [shadowView addSubview:containerView];
    [containerView release];
    
    return shadowView;
}

#pragma mark - FEATURE LOCKED PROFILE

+ (UIView *)getBeintooDashboardViewForLockedFeatureProfileWithFrame:(CGRect)_frame andButtonActionSelector:(SEL)_selector fromSender:(UIViewController *)_caller{
    
    UIView  *shadowView                 = [[UIView alloc] initWithFrame:_caller.view.bounds];
    shadowView.backgroundColor          = [UIColor colorWithWhite:0 alpha:0.5];
    
    UIView  *containerView              = [[UIView alloc] initWithFrame:_frame];
    // we center this subview at the center of the calling frame, shifted 20 pixel up
    containerView.center                = CGPointMake(_caller.view.bounds.size.width/2, (_caller.view.bounds.size.height/2 - 10));
    containerView.layer.borderColor     = [UIColor darkGrayColor].CGColor;
    containerView.layer.cornerRadius    = 1.0;
    containerView.layer.borderWidth     = 2.0;
    
    // ------------ FEATURE VIEW --------------------------
    BGradientView *featureView  = [[BGradientView alloc] initWithGradientType:GRADIENT_CELL_BODY];
    featureView.frame            = CGRectMake(0, 0, _frame.size.width, 160);
    
    UIImageView *iconImage      = [[UIImageView alloc] initWithFrame:CGRectMake(13, 20, 56, 56)];
    iconImage.image             = [UIImage imageNamed:@"beintoo_profile.png"];
    
    [featureView addSubview:iconImage];
    [iconImage release];
    
    // Close Button
    int closeBtnOffset      = 33;
    UIImage* closeBtnImg    = [UIImage imageNamed:@"popupCloseBtn.png"];
    UIButton* closeBtn      = [UIButton buttonWithType:UIButtonTypeCustom];
    closeBtn.alpha          = 0.8;
    [closeBtn setImage:closeBtnImg forState:UIControlStateNormal];
    [closeBtn setFrame:CGRectMake(_frame.size.width - closeBtnOffset, 7 ,
								  closeBtnImg.size.width, closeBtnImg.size.height)];
	
    [closeBtn addTarget:_caller action:@selector(dismissFeatureSignupView) forControlEvents:UIControlEventTouchUpInside];
    [featureView addSubview: closeBtn];
    
    
    UILabel *featureLabel        = [[UILabel alloc] initWithFrame:CGRectMake(80, 15, _frame.size.width-80, 25)];
    featureLabel.backgroundColor = [UIColor clearColor];
    featureLabel.numberOfLines   = 1;
    featureLabel.font            = [UIFont systemFontOfSize:18];
    featureLabel.textColor       = [UIColor colorWithWhite:0 alpha:1];
    featureLabel.textAlignment   = UITextAlignmentLeft;
    featureLabel.text            = NSLocalizedStringFromTable(@"profile",@"BeintooLocalizable",@"");
    
    [featureView addSubview:featureLabel];
    [featureLabel release];
    
    UILabel *featureDesc        = [[UILabel alloc] initWithFrame:CGRectMake(80, 43, _frame.size.width-80, 40)];
    featureDesc.adjustsFontSizeToFitWidth = YES;
    featureDesc.backgroundColor = [UIColor clearColor];
    featureDesc.numberOfLines   = 2;
    featureDesc.font            = [UIFont systemFontOfSize:13];
    featureDesc.textColor       = [UIColor colorWithWhite:0 alpha:0.7];
    featureDesc.textAlignment   = UITextAlignmentLeft;
    featureDesc.text            = NSLocalizedStringFromTable(@"profileDesc",@"BeintooLocalizable",@"");
    
    [featureView addSubview:featureDesc];
    [featureDesc release];
    
    UILabel *commentLabel        = [[UILabel alloc] initWithFrame:CGRectMake(13, 80, _frame.size.width-26, 60)];
    commentLabel.adjustsFontSizeToFitWidth = YES;
    commentLabel.backgroundColor = [UIColor clearColor];
    commentLabel.numberOfLines   = 3;
    commentLabel.font            = [UIFont systemFontOfSize:13];
    commentLabel.textColor       = [UIColor colorWithWhite:0 alpha:0.7];
    commentLabel.textAlignment   = UITextAlignmentLeft;
    commentLabel.text            = NSLocalizedStringFromTable(@"dashplayerprofiletext",@"BeintooLocalizable",@"");
    
    [featureView addSubview:commentLabel];
    [commentLabel release];
    
    [containerView addSubview:featureView];
    [featureView release];
    // ------------------------------------------------------
    
    // ------------------ SIGNUP VIEW -----------------------
    BGradientView *signupView   = [[BGradientView alloc] initWithGradientType:GRADIENT_BODY];
    signupView.frame            = CGRectMake(0, 160, _frame.size.width, _frame.size.height-160);
    
    BButton *signupButton       = [[BButton alloc] initWithFrame:CGRectMake(20, 55, 220, 35)];
    signupButton.center         = CGPointMake(_frame.size.width/2, 30);
    [signupButton setHighColor:[UIColor colorWithRed:156.0/255 green:168.0/255 blue:184.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(156, 2)/pow(255,2) green:pow(168, 2)/pow(255,2) blue:pow(184, 2)/pow(255,2) alpha:1]];
    [signupButton setMediumHighColor:[UIColor colorWithRed:116.0/255 green:135.0/255 blue:159.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(116, 2)/pow(255,2) green:pow(135, 2)/pow(255,2) blue:pow(159, 2)/pow(255,2) alpha:1]];
    [signupButton setMediumLowColor:[UIColor colorWithRed:108.0/255 green:128.0/255 blue:154.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(108, 2)/pow(255,2) green:pow(128, 2)/pow(255,2) blue:pow(154, 2)/pow(255,2) alpha:1]];
    [signupButton setLowColor:[UIColor colorWithRed:89.0/255 green:112.0/255 blue:142.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(89, 2)/pow(255,2) green:pow(112, 2)/pow(255,2) blue:pow(142, 2)/pow(255,2) alpha:1]];
    NSString *signupString = NSLocalizedStringFromTable(@"dashplayersignupnow",@"BeintooLocalizable",@"");
    [signupButton setTitle:[signupString uppercaseString] forState:UIControlStateNormal];
    [signupButton addTarget:_caller action:_selector forControlEvents:UIControlEventTouchUpInside];
    [signupButton setButtonTextSize:18];
    
    [signupView addSubview:signupButton];
    [signupButton release];
    
    [containerView addSubview:signupView];
    [signupView release];
    // --------------------------------------------------------
    
    [shadowView addSubview:containerView];
    [containerView release];
    
    return shadowView;
}

#pragma mark - FEATURE LOCKED MARKETPLACE

+ (UIView *)getBeintooDashboardViewForLockedFeatureMarketplaceWithFrame:(CGRect)_frame andButtonActionSelector:(SEL)_selector fromSender:(UIViewController *)_caller{
    
    UIView  *shadowView                 = [[UIView alloc] initWithFrame:_caller.view.bounds];
    shadowView.backgroundColor          = [UIColor colorWithWhite:0 alpha:0.5];
    
    UIView  *containerView              = [[UIView alloc] initWithFrame:_frame];
    // we center this subview at the center of the calling frame, shifted 20 pixel up
    containerView.center                = CGPointMake(_caller.view.bounds.size.width/2, (_caller.view.bounds.size.height/2 - 10));
    containerView.layer.borderColor     = [UIColor darkGrayColor].CGColor;
    containerView.layer.cornerRadius    = 1.0;
    containerView.layer.borderWidth     = 2.0;
    
    // ------------ FEATURE VIEW --------------------------
    BGradientView *featureView  = [[BGradientView alloc] initWithGradientType:GRADIENT_CELL_BODY];
    featureView.frame            = CGRectMake(0, 0, _frame.size.width, 160);
    
    UIImageView *iconImage      = [[UIImageView alloc] initWithFrame:CGRectMake(13, 20, 56, 56)];
    iconImage.image             = [UIImage imageNamed:@"beintoo_marketplace.png"];
    
    [featureView addSubview:iconImage];
    [iconImage release];
    
    // Close Button
    int closeBtnOffset      = 33;
    UIImage* closeBtnImg    = [UIImage imageNamed:@"popupCloseBtn.png"];
    UIButton* closeBtn      = [UIButton buttonWithType:UIButtonTypeCustom];
    closeBtn.alpha          = 0.8;
    [closeBtn setImage:closeBtnImg forState:UIControlStateNormal];
    [closeBtn setFrame:CGRectMake(_frame.size.width - closeBtnOffset, 7 ,
								  closeBtnImg.size.width, closeBtnImg.size.height)];
	
    [closeBtn addTarget:_caller action:@selector(dismissFeatureSignupView) forControlEvents:UIControlEventTouchUpInside];
    [featureView addSubview: closeBtn];
    
    
    UILabel *featureLabel        = [[UILabel alloc] initWithFrame:CGRectMake(80, 15, _frame.size.width-80, 25)];
    featureLabel.backgroundColor = [UIColor clearColor];
    featureLabel.numberOfLines   = 1;
    featureLabel.font            = [UIFont systemFontOfSize:18];
    featureLabel.textColor       = [UIColor colorWithWhite:0 alpha:1];
    featureLabel.textAlignment   = UITextAlignmentLeft;
    featureLabel.text            = NSLocalizedStringFromTable(@"MPmarketplaceTitle",@"BeintooLocalizable",@"");
    
    [featureView addSubview:featureLabel];
    [featureLabel release];
    
    UILabel *featureDesc        = [[UILabel alloc] initWithFrame:CGRectMake(80, 43, _frame.size.width-80, 40)];
    featureDesc.adjustsFontSizeToFitWidth = YES;
    featureDesc.backgroundColor = [UIColor clearColor];
    featureDesc.numberOfLines   = 2;
    featureDesc.font            = [UIFont systemFontOfSize:13];
    featureDesc.textColor       = [UIColor colorWithWhite:0 alpha:0.7];
    featureDesc.textAlignment   = UITextAlignmentLeft;
    featureDesc.text            = NSLocalizedStringFromTable(@"MPdescription",@"BeintooLocalizable",@"");
    
    [featureView addSubview:featureDesc];
    [featureDesc release];
    
    UILabel *commentLabel        = [[UILabel alloc] initWithFrame:CGRectMake(13, 80, _frame.size.width-26, 60)];
    commentLabel.adjustsFontSizeToFitWidth = YES;
    commentLabel.backgroundColor = [UIColor clearColor];
    commentLabel.numberOfLines   = 3;
    commentLabel.font            = [UIFont systemFontOfSize:13];
    commentLabel.textColor       = [UIColor colorWithWhite:0 alpha:0.7];
    commentLabel.textAlignment   = UITextAlignmentLeft;
    commentLabel.text            = NSLocalizedStringFromTable(@"MPtextDescriptionLong",@"BeintooLocalizable",@"");
    
    [featureView addSubview:commentLabel];
    [commentLabel release];
    
    [containerView addSubview:featureView];
    [featureView release];
    // ------------------------------------------------------
    
    // ------------------ SIGNUP VIEW -----------------------
    BGradientView *signupView   = [[BGradientView alloc] initWithGradientType:GRADIENT_BODY];
    signupView.frame            = CGRectMake(0, 160, _frame.size.width, _frame.size.height-160);
    
    BButton *signupButton       = [[BButton alloc] initWithFrame:CGRectMake(20, 55, 220, 35)];
    signupButton.center         = CGPointMake(_frame.size.width/2, 30);
    [signupButton setHighColor:[UIColor colorWithRed:156.0/255 green:168.0/255 blue:184.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(156, 2)/pow(255,2) green:pow(168, 2)/pow(255,2) blue:pow(184, 2)/pow(255,2) alpha:1]];
    [signupButton setMediumHighColor:[UIColor colorWithRed:116.0/255 green:135.0/255 blue:159.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(116, 2)/pow(255,2) green:pow(135, 2)/pow(255,2) blue:pow(159, 2)/pow(255,2) alpha:1]];
    [signupButton setMediumLowColor:[UIColor colorWithRed:108.0/255 green:128.0/255 blue:154.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(108, 2)/pow(255,2) green:pow(128, 2)/pow(255,2) blue:pow(154, 2)/pow(255,2) alpha:1]];
    [signupButton setLowColor:[UIColor colorWithRed:89.0/255 green:112.0/255 blue:142.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(89, 2)/pow(255,2) green:pow(112, 2)/pow(255,2) blue:pow(142, 2)/pow(255,2) alpha:1]];
    NSString *signupString = NSLocalizedStringFromTable(@"dashplayersignupnow",@"BeintooLocalizable",@"");
    [signupButton setTitle:[signupString uppercaseString] forState:UIControlStateNormal];
    [signupButton addTarget:_caller action:_selector forControlEvents:UIControlEventTouchUpInside];
    [signupButton setButtonTextSize:18];
    
    [signupView addSubview:signupButton];
    [signupButton release];
    
    [containerView addSubview:signupView];
    [signupView release];
    // --------------------------------------------------------
    
    [shadowView addSubview:containerView];
    [containerView release];
    
    return shadowView;
}

#pragma mark - FEATURE LOCKED CHALLENGES

+ (UIView *)getBeintooDashboardViewForLockedFeatureChallengesWithFrame:(CGRect)_frame andButtonActionSelector:(SEL)_selector fromSender:(UIViewController *)_caller{
    
    UIView  *shadowView                 = [[UIView alloc] initWithFrame:_caller.view.bounds];
    shadowView.backgroundColor          = [UIColor colorWithWhite:0 alpha:0.5];
    
    UIView  *containerView              = [[UIView alloc] initWithFrame:_frame];
    // we center this subview at the center of the calling frame, shifted 20 pixel up
    containerView.center                = CGPointMake(_caller.view.bounds.size.width/2, (_caller.view.bounds.size.height/2 - 10));
    containerView.layer.borderColor     = [UIColor darkGrayColor].CGColor;
    containerView.layer.cornerRadius    = 1.0;
    containerView.layer.borderWidth     = 2.0;
    
    // ------------ FEATURE VIEW --------------------------
    BGradientView *featureView  = [[BGradientView alloc] initWithGradientType:GRADIENT_CELL_BODY];
    featureView.frame            = CGRectMake(0, 0, _frame.size.width, 160);
    
    UIImageView *iconImage      = [[UIImageView alloc] initWithFrame:CGRectMake(13, 20, 56, 56)];
    iconImage.image             = [UIImage imageNamed:@"beintoo_challenges.png"];
    
    [featureView addSubview:iconImage];
    [iconImage release];
    
    // Close Button
    int closeBtnOffset      = 33;
    UIImage* closeBtnImg    = [UIImage imageNamed:@"popupCloseBtn.png"];
    UIButton* closeBtn      = [UIButton buttonWithType:UIButtonTypeCustom];
    closeBtn.alpha          = 0.8;
    [closeBtn setImage:closeBtnImg forState:UIControlStateNormal];
    [closeBtn setFrame:CGRectMake(_frame.size.width - closeBtnOffset, 7 ,
								  closeBtnImg.size.width, closeBtnImg.size.height)];
	
    [closeBtn addTarget:_caller action:@selector(dismissFeatureSignupView) forControlEvents:UIControlEventTouchUpInside];
    [featureView addSubview: closeBtn];
    
    
    UILabel *featureLabel        = [[UILabel alloc] initWithFrame:CGRectMake(80, 15, _frame.size.width-80, 25)];
    featureLabel.backgroundColor = [UIColor clearColor];
    featureLabel.numberOfLines   = 1;
    featureLabel.font            = [UIFont systemFontOfSize:18];
    featureLabel.textColor       = [UIColor colorWithWhite:0 alpha:1];
    featureLabel.textAlignment   = UITextAlignmentLeft;
    featureLabel.text            = NSLocalizedStringFromTable(@"challenges",@"BeintooLocalizable",@"");
    
    [featureView addSubview:featureLabel];
    [featureLabel release];
    
    UILabel *featureDesc        = [[UILabel alloc] initWithFrame:CGRectMake(80, 43, _frame.size.width-80, 40)];
    featureDesc.adjustsFontSizeToFitWidth = YES;
    featureDesc.backgroundColor = [UIColor clearColor];
    featureDesc.numberOfLines   = 2;
    featureDesc.font            = [UIFont systemFontOfSize:13];
    featureDesc.textColor       = [UIColor colorWithWhite:0 alpha:0.7];
    featureDesc.textAlignment   = UITextAlignmentLeft;
    featureDesc.text            = NSLocalizedStringFromTable(@"challengesDesc",@"BeintooLocalizable",@"");
    
    [featureView addSubview:featureDesc];
    [featureDesc release];
    
    UILabel *commentLabel        = [[UILabel alloc] initWithFrame:CGRectMake(13, 80, _frame.size.width-26, 60)];
    commentLabel.adjustsFontSizeToFitWidth = YES;
    commentLabel.backgroundColor = [UIColor clearColor];
    commentLabel.numberOfLines   = 3;
    commentLabel.font            = [UIFont systemFontOfSize:13];
    commentLabel.textColor       = [UIColor colorWithWhite:0 alpha:0.7];
    commentLabel.textAlignment   = UITextAlignmentLeft;
    commentLabel.text            = NSLocalizedStringFromTable(@"dashplayerchallengestext",@"BeintooLocalizable",@"");
    
    [featureView addSubview:commentLabel];
    [commentLabel release];
    
    [containerView addSubview:featureView];
    [featureView release];
    // ------------------------------------------------------
    
    // ------------------ SIGNUP VIEW -----------------------
    BGradientView *signupView   = [[BGradientView alloc] initWithGradientType:GRADIENT_BODY];
    signupView.frame            = CGRectMake(0, 160, _frame.size.width, _frame.size.height-160);
    
    BButton *signupButton       = [[BButton alloc] initWithFrame:CGRectMake(20, 55, 220, 35)];
    signupButton.center         = CGPointMake(_frame.size.width/2, 30);
    [signupButton setHighColor:[UIColor colorWithRed:156.0/255 green:168.0/255 blue:184.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(156, 2)/pow(255,2) green:pow(168, 2)/pow(255,2) blue:pow(184, 2)/pow(255,2) alpha:1]];
    [signupButton setMediumHighColor:[UIColor colorWithRed:116.0/255 green:135.0/255 blue:159.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(116, 2)/pow(255,2) green:pow(135, 2)/pow(255,2) blue:pow(159, 2)/pow(255,2) alpha:1]];
    [signupButton setMediumLowColor:[UIColor colorWithRed:108.0/255 green:128.0/255 blue:154.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(108, 2)/pow(255,2) green:pow(128, 2)/pow(255,2) blue:pow(154, 2)/pow(255,2) alpha:1]];
    [signupButton setLowColor:[UIColor colorWithRed:89.0/255 green:112.0/255 blue:142.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(89, 2)/pow(255,2) green:pow(112, 2)/pow(255,2) blue:pow(142, 2)/pow(255,2) alpha:1]];
    NSString *signupString = NSLocalizedStringFromTable(@"dashplayersignupnow",@"BeintooLocalizable",@"");
    [signupButton setTitle:[signupString uppercaseString] forState:UIControlStateNormal];
    [signupButton addTarget:_caller action:_selector forControlEvents:UIControlEventTouchUpInside];
    [signupButton setButtonTextSize:18];
    
    [signupView addSubview:signupButton];
    [signupButton release];
    
    [containerView addSubview:signupView];
    [signupView release];
    // --------------------------------------------------------
    
    [shadowView addSubview:containerView];
    [containerView release];
    
    return shadowView;
}


#pragma mark - FEATURE LOCKED TIPS&FORUM

+ (UIView *)getBeintooDashboardViewForLockedFeatureTipsAndForumWithFrame:(CGRect)_frame andButtonActionSelector:(SEL)_selector fromSender:(UIViewController *)_caller{
    
    UIView  *shadowView                 = [[UIView alloc] initWithFrame:_caller.view.bounds];
    shadowView.backgroundColor          = [UIColor colorWithWhite:0 alpha:0.5];
    
    UIView  *containerView              = [[UIView alloc] initWithFrame:_frame];
    // we center this subview at the center of the calling frame, shifted 20 pixel up
    containerView.center                = CGPointMake(_caller.view.bounds.size.width/2, (_caller.view.bounds.size.height/2 - 10));
    containerView.layer.borderColor     = [UIColor darkGrayColor].CGColor;
    containerView.layer.cornerRadius    = 1.0;
    containerView.layer.borderWidth     = 2.0;
    
    // ------------ FEATURE VIEW --------------------------
    BGradientView *featureView  = [[BGradientView alloc] initWithGradientType:GRADIENT_CELL_BODY];
    featureView.frame            = CGRectMake(0, 0, _frame.size.width, 160);
    
    UIImageView *iconImage      = [[UIImageView alloc] initWithFrame:CGRectMake(13, 20, 56, 56)];
    iconImage.image             = [UIImage imageNamed:@"beintoo_forum.png"];
    
    [featureView addSubview:iconImage];
    [iconImage release];
    
    // Close Button
    int closeBtnOffset      = 33;
    UIImage* closeBtnImg    = [UIImage imageNamed:@"popupCloseBtn.png"];
    UIButton* closeBtn      = [UIButton buttonWithType:UIButtonTypeCustom];
    closeBtn.alpha          = 0.8;
    [closeBtn setImage:closeBtnImg forState:UIControlStateNormal];
    [closeBtn setFrame:CGRectMake(_frame.size.width - closeBtnOffset, 7 ,
								  closeBtnImg.size.width, closeBtnImg.size.height)];
	
    [closeBtn addTarget:_caller action:@selector(dismissFeatureSignupView) forControlEvents:UIControlEventTouchUpInside];
    [featureView addSubview: closeBtn];
    
    
    UILabel *featureLabel        = [[UILabel alloc] initWithFrame:CGRectMake(80, 15, _frame.size.width-80, 25)];
    featureLabel.backgroundColor = [UIColor clearColor];
    featureLabel.numberOfLines   = 1;
    featureLabel.font            = [UIFont systemFontOfSize:18];
    featureLabel.textColor       = [UIColor colorWithWhite:0 alpha:1];
    featureLabel.textAlignment   = UITextAlignmentLeft;
    featureLabel.text            = NSLocalizedStringFromTable(@"tipsandforum",@"BeintooLocalizable",@"");
    
    [featureView addSubview:featureLabel];
    [featureLabel release];
    
    UILabel *featureDesc        = [[UILabel alloc] initWithFrame:CGRectMake(80, 43, _frame.size.width-80, 40)];
    featureDesc.adjustsFontSizeToFitWidth = YES;
    featureDesc.backgroundColor = [UIColor clearColor];
    featureDesc.numberOfLines   = 2;
    featureDesc.font            = [UIFont systemFontOfSize:13];
    featureDesc.textColor       = [UIColor colorWithWhite:0 alpha:0.7];
    featureDesc.textAlignment   = UITextAlignmentLeft;
    featureDesc.text            = NSLocalizedStringFromTable(@"tipsandforumDesc",@"BeintooLocalizable",@"");
    
    [featureView addSubview:featureDesc];
    [featureDesc release];
    
    UILabel *commentLabel        = [[UILabel alloc] initWithFrame:CGRectMake(13, 80, _frame.size.width-26, 60)];
    commentLabel.backgroundColor = [UIColor clearColor];
    commentLabel.adjustsFontSizeToFitWidth = YES;
    commentLabel.numberOfLines   = 3;
    commentLabel.font            = [UIFont systemFontOfSize:13];
    commentLabel.textColor       = [UIColor colorWithWhite:0 alpha:0.7];
    commentLabel.textAlignment   = UITextAlignmentLeft;
    commentLabel.text            = NSLocalizedStringFromTable(@"dashplayerforumtips",@"BeintooLocalizable",@"");
    
    [featureView addSubview:commentLabel];
    [commentLabel release];
    
    [containerView addSubview:featureView];
    [featureView release];
    // ------------------------------------------------------
    
    // ------------------ SIGNUP VIEW -----------------------
    BGradientView *signupView   = [[BGradientView alloc] initWithGradientType:GRADIENT_BODY];
    signupView.frame            = CGRectMake(0, 160, _frame.size.width, _frame.size.height-160);
    
    BButton *signupButton       = [[BButton alloc] initWithFrame:CGRectMake(20, 55, 220, 35)];
    signupButton.center         = CGPointMake(_frame.size.width/2, 30);
    [signupButton setHighColor:[UIColor colorWithRed:156.0/255 green:168.0/255 blue:184.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(156, 2)/pow(255,2) green:pow(168, 2)/pow(255,2) blue:pow(184, 2)/pow(255,2) alpha:1]];
    [signupButton setMediumHighColor:[UIColor colorWithRed:116.0/255 green:135.0/255 blue:159.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(116, 2)/pow(255,2) green:pow(135, 2)/pow(255,2) blue:pow(159, 2)/pow(255,2) alpha:1]];
    [signupButton setMediumLowColor:[UIColor colorWithRed:108.0/255 green:128.0/255 blue:154.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(108, 2)/pow(255,2) green:pow(128, 2)/pow(255,2) blue:pow(154, 2)/pow(255,2) alpha:1]];
    [signupButton setLowColor:[UIColor colorWithRed:89.0/255 green:112.0/255 blue:142.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(89, 2)/pow(255,2) green:pow(112, 2)/pow(255,2) blue:pow(142, 2)/pow(255,2) alpha:1]];
    NSString *signupString = NSLocalizedStringFromTable(@"dashplayersignupnow",@"BeintooLocalizable",@"");
    [signupButton setTitle:[signupString uppercaseString] forState:UIControlStateNormal];
    [signupButton addTarget:_caller action:_selector forControlEvents:UIControlEventTouchUpInside];
    [signupButton setButtonTextSize:18];
    
    [signupView addSubview:signupButton];
    [signupButton release];
    
    [containerView addSubview:signupView];
    [signupView release];
    // --------------------------------------------------------
    
    [shadowView addSubview:containerView];
    [containerView release];
    
    return shadowView;
}

@end

