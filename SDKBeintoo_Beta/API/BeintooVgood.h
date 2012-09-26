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

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "Parser.h"
#import "BeintooPlayer.h"
#import "BVirtualGood.h"

#define TO_BE_CONVERTED 40
#define CONVERTED		41

#define B_NOTHING_TO_DISPATCH_ERRORCODE -10
#define B_USER_OVER_QUOTA_ERRORCODE     -11

@protocol BeintooVgoodDelegate;

@interface BeintooVgood : NSObject <BeintooParserDelegate>{
	
	Parser                  *parser;
	BeintooPlayer           *_player;
	id <BeintooVgoodDelegate> delegate;
	BOOL                    isMultipleVgood;
	BOOL                    isRecommendation;
	
	NSString                *rest_resource;
    NSString                *display_rest_resource;
	
	id callingDelegate;
    
    BVirtualGood            *vgood;
    BVirtualGood            *adContent;
}

+ (void)getSingleVirtualGood;
+ (void)getMultipleVirtualGood;
+ (void)getSingleVirtualGoodWithContest:(NSString *)contestID;
+ (void)getMultipleVirtualGoodWithContest:(NSString *)contestID;
+ (void)getSingleVirtualGoodWithDelegate:(id)_delegate;
+ (void)getMultipleVirtualGoodWithDelegate:(id)_delegate;

+ (void)getAd;

// Private vgoods
+ (void)getPlayerPrivateVgoods;
+ (void)assignToPlayerPrivateVgood:(NSString *)vgoodID;
+ (void)removeFromPlayerPrivateVgood:(NSString *)vgoodID;

+ (void)notifyVGoodGenerationOnUserDelegate;
+ (void)notifyVGoodGenerationErrorOnUserDelegate:(NSDictionary *)_errorDict;
+ (void)showNotificationForNothingToDispatch;

- (NSString *)restResource;
- (NSString *)getDisplayRestResource;
+ (void)setVgoodDelegate:(id)_caller;

/* --- VGOODS ---- */
- (void)showGoodsByUserForState:(int)state;
- (void)showGoodsByPlayerForState:(int)state;
- (void)sendGoodWithID:(NSString *)good_id asGiftToUser:(NSString *)ext_id_to;
- (void)acceptGoodWithId:(NSString *)good_id;

/* --- MARKETPLACE VGOODS ---- */
- (void)setRatingForVgoodId:(NSString *)_vgoodId andUser:(NSString *)_userExt withRate:(int)_rating;
- (void)getCommentListForVgoodId:(NSString *)_vgoodId;
- (void)setCommentForVgoodId:(NSString *)_vgoodId andUser:(NSString *)_userExt withComment:(NSString *)_comment;

/* --- MARKETPLACE --- */
- (void)sellVGood:(NSString *)vGood_Id;
- (void)showGoodsToBuy;
- (void)showGoodsToBuyFeatured;
- (void)buyGoodFromUser:(NSString *)vGood_Id;
- (void)buyGoodFeatured:(NSString *)vGood_Id;

@property(nonatomic, assign) id <BeintooVgoodDelegate> delegate;
@property(nonatomic, assign) id  callingDelegate;
@property(nonatomic,retain) NSDictionary    *generatedVGood;
@property(nonatomic,retain) Parser          *parser;
@property(nonatomic,retain) BVirtualGood    *vgood;
@property(nonatomic,retain) BVirtualGood    *adContent;

@end


@protocol BeintooVgoodDelegate <NSObject>

@optional
- (void)didGenerateVgood:(BOOL)isVgoodGenerated withResult:(BeintooVgood *)theVgood;
- (void)didGetAllvGoods:(NSArray *)vGoodList;
- (void)didSendVGoodAsGift:(BOOL)result;
- (void)didAcceptVgood;

- (void)beintooHasRewardsCoverage;
- (void)beintooHasNotRewardsCoverage;

- (void)beintooPlayerIsEligibleForReward;
- (void)beintooPlayerIsNotEligibleForReward;
- (void)beintooPlayerIsOverQuotaForReward;
- (void)beintooPlayerGotNothingToDispatchForReward;

- (void)didGetAllPrivateVgoods:(NSArray *)privateVgoodList;
- (void)didAssignPrivateVgoodToPlayerWithResult:(NSDictionary *)result;
- (void)didRemovePrivateVgoodToPlayerWithResult:(NSDictionary *)result;

- (void)didSetRating:(NSDictionary *)result;
- (void)didGetCommentsList:(NSMutableArray *)result;
- (void)didSetCommentForVgood:(NSDictionary *)result;

// MARKETPLACE
- (void)didSellVGood:(BOOL)result;
- (void)didGetVGoodsToBuy:(NSArray *)vGoodList;
- (void)didBuyVgoodWithResult:(NSDictionary *)goodBought;

@end
