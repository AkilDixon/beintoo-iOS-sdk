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
#import "BeintooMarketplace.h"
#import "BImageDownload.h"
#import "Beintoo.h"
#import "BRefreshTableHeaderView.h"

#define TOTAL_ROWS_INCREMENT              25

@class BeintooMarketplace, BView, BTableView, BeintooMarketplaceSelectedItemVC, BeintooProfileVC;

@interface BeintooMarketplaceVC : UIViewController <UITableViewDelegate, BeintooMarketplaceDelegate, BeintooUserDelegate, BImageDownloadDelegate, BeintooVgoodDelegate> {
    
    IBOutlet UISegmentedControl         *mainSegmentedControl;
    IBOutlet UISegmentedControl         *childSegmentedControl;
    IBOutlet BTableView                 *table;
    IBOutlet BView                      *homeView;
    IBOutlet UILabel                    *nickLabel;
    IBOutlet UILabel                    *bedollarsLabel;
    IBOutlet BButton                    *magnifierButton;
    IBOutlet UIView                     *bodyView;
    BeintooMarketplace                  *_marketplace;
    BeintooUser                         *_user;
    BeintooVgood                        *_vgood;
    
    BeintooMarketplaceSelectedItemVC    *marketplaceSelectedItemVC;
    UINavigationController              *loginNavController;
    BeintooLoginVC                      *loginVC;
    BeintooVGoodShowVC                  *vgoodShowVC;
    BeintooFriendsListVC                *friendsListVC;
    
    NSMutableArray                      *marketplaceContent;
    NSMutableArray                      *marketplaceImages;
    NSMutableArray                      *buttonsArray;
    
    NSDictionary                        *selectedDictionary;
    NSDictionary                        *options;
    NSString                            *currentKind;
    NSString                            *currentSorting;
    NSString                            *currentCategory;
    
    int currentSistemVersion;
    
    BOOL                                isViewAlreadyForUser;
    int                                 totalRows;
    BOOL                                isLoadMoreActive;
    BOOL                                isNewSearch;
    UIActivityIndicatorView             *activity;
    
    BRefreshTableHeaderView             *refreshHeaderView;
	BOOL                                _reloading;
    
    // ------> get coupon view <-------
    IBOutlet UIView                     *couponView;
    IBOutlet BView                      *couponSubView;
    IBOutlet BButton                    *couponCloseButton;
    IBOutlet BButton                    *couponGetButton;
    IBOutlet BButton                    *couponSendButton;
    IBOutlet UIImageView                *couponImageView;
    IBOutlet UILabel                    *couponName;
    IBOutlet UILabel                    *couponDescription;
    IBOutlet UILabel                    *couponEnddate;
    IBOutlet UILabel                    *couponBedollars;
    IBOutlet UILabel                    *couponYouAreGoingToBuyLabel;
    IBOutlet UIActivityIndicatorView    *couponActivity;
    
    // ------> can't get coupon view <-------
    IBOutlet BView                      *noMoneySubView;
    IBOutlet BButton                    *noMoneyCloseButton;
    IBOutlet UIImageView                *noMoneyImageView;
    IBOutlet UILabel                    *noMoneyCouponName;
    IBOutlet UILabel                    *noMoneyCouponDescription;
    IBOutlet UILabel                    *noMoneyCouponEnddate;
    IBOutlet UILabel                    *noMoneyCouponCost;
    IBOutlet UILabel                    *noMoneyMessage;
    IBOutlet UIActivityIndicatorView    *noMoneyActivity;

}

@property(nonatomic, retain) NSDictionary                       *selectedDictionary; 
@property(nonatomic, retain) IBOutlet BTableView                *table;
@property(nonatomic, retain) NSString                           *caller;
@property(nonatomic, retain) NSString                           *selectedFriend;
@property(nonatomic, retain) NSDictionary                       *selectedVgood;
@property(nonatomic, retain) IBOutlet UISegmentedControl        *mainSegmentedControl;
@property(nonatomic, retain) IBOutlet UISegmentedControl        *childSegmentedControl;
@property(nonatomic, retain) IBOutlet BView                     *homeView;
@property(nonatomic, retain) IBOutlet UILabel                   *nickLabel;
@property(nonatomic, retain) IBOutlet UILabel                   *bedollarsLabel;
@property(nonatomic, retain) IBOutlet BButton                   *magnifierButton;
@property(nonatomic, retain) IBOutlet UIView                    *bodyView;
@property(nonatomic, retain) IBOutlet UIView                    *couponView;
@property(nonatomic, retain) IBOutlet BView                     *couponSubView;
@property(nonatomic, retain) IBOutlet BButton                   *couponCloseButton;
@property(nonatomic, retain) IBOutlet BButton                   *couponGetButton;
@property(nonatomic, retain) IBOutlet BButton                   *couponSendButton;
@property(nonatomic, retain) IBOutlet UIImageView               *couponImageView;
@property(nonatomic, retain) IBOutlet UILabel                   *couponName;
@property(nonatomic, retain) IBOutlet UILabel                   *couponDescription;
@property(nonatomic, retain) IBOutlet UILabel                   *couponEnddate;
@property(nonatomic, retain) IBOutlet UILabel                   *couponBedollars;
@property(nonatomic, retain) IBOutlet UILabel                   *couponYouAreGoingToBuyLabel;
@property(nonatomic, retain) IBOutlet UIActivityIndicatorView   *couponActivity;
@property(nonatomic, retain) IBOutlet BView                     *noMoneySubView;
@property(nonatomic, retain) IBOutlet BButton                   *noMoneyCloseButton;
@property(nonatomic, retain) IBOutlet UIImageView               *noMoneyImageView;
@property(nonatomic, retain) IBOutlet UILabel                   *noMoneyCouponName;
@property(nonatomic, retain) IBOutlet UILabel                   *noMoneyCouponDescription;
@property(nonatomic, retain) IBOutlet UILabel                   *noMoneyCouponEnddate;
@property(nonatomic, retain) IBOutlet UILabel                   *noMoneyCouponCost;
@property(nonatomic, retain) IBOutlet UILabel                   *noMoneyMessage;
@property(nonatomic, retain) IBOutlet UIActivityIndicatorView   *noMoneyActivity;

- (IBAction)clickedButton:(id)sender;
- (IBAction)clickedBuyButton:(id)sender;
- (IBAction)changeMainSegmentedValue;
- (IBAction)closeDialog:(id)sender;
- (IBAction)buyCoupon:(id)sender;
- (IBAction)sendAsGift:(id)sender;

//** Pull Down To Refresh
@property(assign,getter=isReloading) BOOL reloading;
@property(nonatomic,readonly) BRefreshTableHeaderView *refreshHeaderView;
@property(nonatomic, assign) BOOL needsToReloadData;

- (void)reloadTableViewDataSource;
- (void)dataSourceDidFinishLoadingNewData;
- (void)dataSourceLoadingError;
//**

#ifdef UI_USER_INTERFACE_IDIOM
@property(nonatomic,retain) UIPopoverController *popOverController;
@property(nonatomic,retain) UIPopoverController *loginPopoverController;
#endif

- (void)showChildSegment;
- (void)hideChildSegment;
- (void)hideChildDidStop;
- (void)showWithAnimationForView:(UIView *)_animView withTag:(int)_senderTag;
- (void)hideWithAnimationForView:(UIView *)_animView;
- (void)showFeatureSignupView;
- (void)dismissFeatureSignupView;
+ (UIView *)closeButton;
+ (void)closeBeintoo;

- (void)didMarketplaceGotContent:(NSMutableArray *)result;
- (void)didNotMarketplaceGotContent;
- (void)didNotMarketplaceGotCategoryContent;
- (void)didMarketplaceGotCategories:(NSMutableArray *)result;
- (void)didNotMarketplaceGotCategories;
- (void)didGetUserByUDID:(NSMutableArray *)result;

- (void)searchMarketplaceContentForCurrentSorting:(id)sender;

@end
