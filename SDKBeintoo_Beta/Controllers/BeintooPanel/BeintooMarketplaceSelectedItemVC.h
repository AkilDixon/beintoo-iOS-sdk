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


#import <UIKit/UIKit.h>
#import "Beintoo.h"
#import "BImageDownload.h"

@class BeintooMarketplaceCommentsVC, BeintooMapViewVC, BeintooVGoodShowVC, BeintooMarketplaceVC, BeintooFriendsListVC;

@interface BeintooMarketplaceSelectedItemVC : UIViewController <BImageDownloadDelegate, BeintooVgoodDelegate, BeintooMarketplaceDelegate, BeintooUserDelegate, CLLocationManagerDelegate> {
    
    BeintooMarketplace              *_marketplace;
    BeintooVgood                    *_vgood;
    BeintooMarketplaceCommentsVC    *_comments;
    BeintooMapViewVC                *_mapView;
    BeintooUser                     *_user;
    UINavigationController          *loginNavController;
    BeintooLoginVC                  *loginVC;
    BeintooVGoodShowVC              *_beintooShowVgood;
    BeintooFriendsListVC            *friendsListVC;

    UIView                          *signupViewForPlayers;
    
    IBOutlet BView          *mainView;
    IBOutlet UILabel        *nickLabel;
    IBOutlet UILabel        *bedollarsLabel;
    IBOutlet UILabel        *vgoodNameLabel;
    IBOutlet UILabel        *vgoodBedollarsLabel;
    IBOutlet UILabel        *vgoodEnddateLabel;
    UIImageView             *imgView;
    UIActivityIndicatorView *imgViewActivity;
    IBOutlet UILabel        *bigTitleLabel;
    IBOutlet UILabel        *descriptionLabel;
    IBOutlet UIScrollView   *scroll;
    BOOL                    buttonInitialized;
    
    IBOutlet BButton        *buyButton;
    IBOutlet BButton        *sendButton;
    IBOutlet BButton        *commentButton;
    IBOutlet BButton        *rateButton;
    IBOutlet BButton        *fanButton;
    IBOutlet BButton        *shareButton;
    IBOutlet BButton        *mapButton;
    
    // ------> stars on base view <-------
    IBOutlet UIImageView        *localeStar1;
    IBOutlet UIImageView        *localeStar2;
    IBOutlet UIImageView        *localeStar3;
    IBOutlet UIImageView        *localeStar4;
    IBOutlet UIImageView        *localeStar5;
    
    // ------> rate view <-------
    IBOutlet UIView         *rateView;
    IBOutlet BView          *rateSubView;
    IBOutlet UIButton       *starButton1;
    IBOutlet UIButton       *starButton2;
    IBOutlet UIButton       *starButton3;
    IBOutlet UIButton       *starButton4;
    IBOutlet UIButton       *starButton5;
    IBOutlet UIButton       *starcloseButton;
    IBOutlet BButton        *sendRateButton;
    
    // ------> get coupon view <-------
    IBOutlet BView          *couponSubView;
    IBOutlet BButton        *couponCloseButton;
    IBOutlet BButton        *couponGetButton;
    IBOutlet BButton        *couponSendButton;
    IBOutlet UIImageView    *couponImageView;
    IBOutlet UILabel        *couponName;
    IBOutlet UILabel        *couponDescription;
    IBOutlet UILabel        *couponEnddate;
    IBOutlet UILabel        *couponBedollars;
    IBOutlet UILabel        *couponYouAreGoingToBuyLabel;
    IBOutlet UIActivityIndicatorView    *couponActivity;
    
    // ------> can't get coupon view <-------
    IBOutlet BView          *noMoneySubView;
    IBOutlet BButton        *noMoneyCloseButton;
    IBOutlet UIImageView    *noMoneyImageView;
    IBOutlet UILabel        *noMoneyCouponName;
    IBOutlet UILabel        *noMoneyCouponDescription;
    IBOutlet UILabel        *noMoneyCouponEnddate;
    IBOutlet UILabel        *noMoneyCouponCost;
    IBOutlet UILabel        *noMoneyMessage;
    IBOutlet UIActivityIndicatorView    *noMoneyActivity;

}

@property (nonatomic,retain) NSMutableDictionary    *selectedVgood;

@property (nonatomic,retain) IBOutlet BView          *mainView;
@property (nonatomic,retain) IBOutlet UILabel        *nickLabel;
@property (nonatomic,retain) IBOutlet UILabel        *bedollarsLabel;
@property (nonatomic,retain) IBOutlet UILabel        *vgoodNameLabel;
@property (nonatomic,retain) IBOutlet UILabel        *vgoodBedollarsLabel;
@property (nonatomic,retain) IBOutlet UILabel        *vgoodEnddateLabel;
@property (nonatomic,retain) IBOutlet UILabel        *bigTitleLabel;
@property (nonatomic,retain) IBOutlet UILabel        *descriptionLabel;

@property (nonatomic,retain) IBOutlet UIImageView        *localeStar1;
@property (nonatomic,retain) IBOutlet UIImageView        *localeStar2;
@property (nonatomic,retain) IBOutlet UIImageView        *localeStar3;
@property (nonatomic,retain) IBOutlet UIImageView        *localeStar4;
@property (nonatomic,retain) IBOutlet UIImageView        *localeStar5;

@property (nonatomic,retain) BeintooMarketplaceVC       *callerIstance;
@property (nonatomic,retain) NSString                   *caller;
@property(nonatomic, retain) NSString                   *selectedFriend;
@property(nonatomic, retain) NSDictionary               *vGoodToBeSentAsAGift;

- (IBAction)changeStarCondition:(id)sender;
- (IBAction)openDialog:(id)sender;
- (IBAction)closeDialog:(id)sender;
- (IBAction)sendRate:(id)sender;
- (IBAction)clickedButton:(id)sender;
- (IBAction)manageCoupon:(id)sender;
- (IBAction)buyCoupon:(id)sender;
- (IBAction)sendAsGift:(id)sender;

- (void)showWithAnimationForView:(UIView *)_animView withTag:(int)_senderTag;
- (void)hideWithAnimationForView:(UIView *)_animView;
- (void)clearStars;
- (void)updateLocaleStars;
- (void)setButtonCustomization;
- (void)loadRateView;
- (void)showFeatureSignupView;
- (void)dismissFeatureSignupView;

@end
