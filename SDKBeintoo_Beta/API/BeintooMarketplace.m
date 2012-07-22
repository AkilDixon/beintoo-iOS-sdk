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

#import "BeintooMarketplace.h"
#import "Beintoo.h"

@implementation BeintooMarketplace

@synthesize parser, delegate;

-(id)init {
	if (self = [super init])
	{
        parser              = [[Parser alloc] init];
		parser.delegate     = self;
		rest_resource       = [[NSString alloc] initWithString:[NSString stringWithFormat:@"%@/marketplace", [Beintoo getRestBaseUrl]]];
        rest_resource_vgood = [[NSString alloc] initWithString:[NSString stringWithFormat:@"%@/vgood/",[Beintoo getRestBaseUrl]]];
	}
    return self;
}

- (NSString *)restResource{
	return rest_resource;
}

#pragma mark -
#pragma mark API

- (void)getMarketplaceContentForKind:(NSString *)_kind andStart:(int)_start andNumberOfRows:(int)_rows andSorting:(NSString *)_sorting{
	
    CLLocation *loc	 = [Beintoo getUserLocation];
	
	NSString *location_res;
    
	if (loc == nil || (loc.coordinate.latitude <= 0.01f && loc.coordinate.latitude >= -0.01f) 
		|| (loc.coordinate.longitude <= 0.01f && loc.coordinate.longitude >= -0.01f)) {
		location_res = [NSString stringWithFormat:@""];
	}
	else{   
        location_res	= [NSString stringWithFormat:@"latitude=%f&longitude=%f&radius=%f",
                           loc.coordinate.latitude,loc.coordinate.longitude,loc.horizontalAccuracy];
    } 
	
    NSString *res		 = [NSString stringWithFormat:@"%@?start=%i&rows=%i&type=%@&sort=%@&%@",rest_resource, _start, _rows, _kind, _sorting, location_res];
    
	NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:[Beintoo getApiKey], @"apikey", [Beintoo getPlayerID], @"guid", nil];
    
    //NSLog(@"res %@ andparams %@", res, params);
    
	[parser parsePageAtUrl:res withHeaders:params fromCaller:MARKETPLACE_GET_CONTENT_CALLER_ID];
}

- (void)getMarketplaceContentForKind:(NSString *)_kind andCategory:(NSString *)_category andStart:(int)_start andNumberOfRows:(int)_rows andSorting:(NSString *)_sorting{
	
    CLLocation *loc	 = [Beintoo getUserLocation];
	NSString *location_res;
    
	if (loc == nil || (loc.coordinate.latitude <= 0.01f && loc.coordinate.latitude >= -0.01f) 
		|| (loc.coordinate.longitude <= 0.01f && loc.coordinate.longitude >= -0.01f)) {
		location_res = [NSString stringWithFormat:@""];
	}
	else{   
        location_res	= [NSString stringWithFormat:@"latitude=%f&longitude=%f&radius=%f",
                           loc.coordinate.latitude,loc.coordinate.longitude,loc.horizontalAccuracy];
    } 
	
	NSString *res		 = [NSString stringWithFormat:@"%@?start=%i&rows=%i&type=%@&sort=%@&category=%@&%@", rest_resource, _start, _rows, _kind, _sorting, _category, location_res];
    
	NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:[Beintoo getApiKey], @"apikey", [Beintoo getPlayerID], @"guid", nil];
    
   // NSLog(@"res %@ andparams %@", res, params);
    
	[parser parsePageAtUrl:res withHeaders:params fromCaller:MARKETPLACE_GET_CATEGORY_CONTENT_CALLER_ID];
}

- (void)getMarketplaceCategories{
	
    NSString *res		 = [NSString stringWithFormat:@"%@show/categories", rest_resource_vgood];
    
	NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:[Beintoo getApiKey], @"apikey", [Beintoo getPlayerID], @"guid", nil];
    
    //NSLog(@"res %@ andparams %@", res, params);
    
	[parser parsePageAtUrl:res withHeaders:params fromCaller:MARKETPLACE_GET_CATEGORIES_CALLER_ID];
    
}


#pragma mark -
#pragma mark parser delegate response

- (void)didFinishToParsewithResult:(NSDictionary *)result forCaller:(NSInteger)callerID{	
	switch (callerID){
		case MARKETPLACE_GET_CONTENT_CALLER_ID:{
            
            //NSLog(@"resul marketplace %@", result);
            if ([result isKindOfClass:[NSMutableArray class]]) {
                if ([[self delegate] respondsToSelector:@selector(didMarketplaceGotContent:)]) {
                    [[self delegate] didMarketplaceGotContent:(NSMutableArray *)result];
                }
            }
            else {
                if ([[self delegate] respondsToSelector:@selector(didNotMarketplaceGotContent)]) {
                    [[self delegate] didNotMarketplaceGotContent];
                }
            }
		}
			break;
        
        case MARKETPLACE_GET_CATEGORY_CONTENT_CALLER_ID:{
            
           // NSLog(@"resul marketplace %@", result);
           if ([result isKindOfClass:[NSMutableArray class]]) {
                if ([[self delegate] respondsToSelector:@selector(didMarketplaceGotContent:)]) {
                    [[self delegate] didMarketplaceGotContent:(NSMutableArray *)result];
                }
            }
            else {
                if ([[self delegate] respondsToSelector:@selector(didNotMarketplaceGotCategoryContent)]) {
                    [[self delegate] didNotMarketplaceGotCategoryContent];
                }
            }
		}
			break;
            
        case MARKETPLACE_GET_CATEGORIES_CALLER_ID:{
            
            // NSLog(@"resul categories marketplace %@", result);
            if ([result isKindOfClass:[NSMutableArray class]]){
                if ([[self delegate] respondsToSelector:@selector(didMarketplaceGotCategories:)]) {
                    [[self delegate] didMarketplaceGotCategories:(NSMutableArray *)result];
                }
            }
            else {
                if ([[self delegate] respondsToSelector:@selector(didNotMarketplaceGotCategories)]) {
                    [[self delegate] didNotMarketplaceGotCategories];
                }
            }
		}
			break;
    }
}

- (void)dealloc {
	[parser release];
	[rest_resource release];
    [rest_resource_vgood release];
    [super dealloc];
}


@end
