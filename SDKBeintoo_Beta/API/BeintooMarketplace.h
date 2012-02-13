//
//  BeintooMarketplace.h
//  SampleBeintoo
//
//  Created by Giuseppe Piazzese on 17/01/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//


#define KIND_FEATURED           @"FEATURED"
#define KIND_NATIONAL           @"NATIONAL"
#define KIND_NATIONAL_TOPSOLD   @"NATIONAL_TOPSOLD"
#define CATEGORY_KIND           @"CATEGORY"
#define SUB_CATEGORY_KIND       @"SUB_CATEGORY"
#define KIND_AROUND_ME          @"AROUNDME"

#define SORT_DISTANCE           @"DISTANCE"
#define SORT_PRICE              @"PRICE" // <---- PRICE_DESC
#define SORT_PRICE_ASC          @"PRICE_ASC"

#import <Foundation/Foundation.h>
#import "Parser.h"

@protocol BeintooMarketplaceDelegate;

@interface BeintooMarketplace : NSObject <BeintooParserDelegate> {

    id <BeintooMarketplaceDelegate> delegate;
	Parser *parser;
	
	NSString *rest_resource;
    NSString *rest_resource_vgood;
}

- (NSString *)restResource;

- (void)getMarketplaceContentForKind:(NSString *)_kind andStart:(int)_start andNumberOfRows:(int)_rows andSorting:(NSString *)_sorting;
- (void)getMarketplaceContentForKind:(NSString *)_kind andCategory:(NSString *)_category andStart:(int)_start andNumberOfRows:(int)_rows andSorting:(NSString *)_sorting;
- (void)getMarketplaceCategories;

@property(nonatomic, assign) id <BeintooMarketplaceDelegate> delegate;
@property(nonatomic,retain) Parser *parser;

    
@end

@protocol BeintooMarketplaceDelegate <NSObject>

@optional
- (void)didMarketplaceGotContent:(NSMutableArray *)result;
- (void)didMarketplaceGotCategories:(NSMutableArray *)result;
- (void)didMarketplaceGotCategoryContent:(NSMutableArray *)result;

- (void)didNotMarketplaceGotCategoryContent;
- (void)didNotMarketplaceGotCategories;
- (void)didNotMarketplaceGotContent;


@end
