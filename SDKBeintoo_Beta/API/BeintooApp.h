/*******************************************************************************
 * Copyright 2012 Beintoo
 * Author Giuseppe Piazzese (gpiazzese@beintoo.com)
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
#import "BeintooPlayer.h"
#import "Parser.h"
#import "BGiveBedollarsWrapper.h"

@protocol BeintooAppDelegate, BGiveBedollarsWrapper;

@interface BeintooApp : NSObject <BeintooParserDelegate>
{
    id              delegate;
	Parser          *parser;
	
	NSString        *rest_resource;
    NSString        *app_rest_resource;
    
    int             notificationPosition;
    BOOL            showGiveBedollarsNotification;
}

#ifdef BEINTOO_ARC_AVAILABLE
@property (nonatomic, strong) id delegate;
@property (nonatomic, strong) Parser *parser;
#else
@property (nonatomic, assign) id delegate;
@property (nonatomic, retain) Parser *parser;
#endif

@property (nonatomic, assign) BOOL          showGiveBedollarsNotification;
@property (nonatomic, assign) int           notificationPosition;

- (id)initWithDelegate:(id)_delegate;

- (NSString *)restResource;
+ (void)setDelegate:(id)_caller;

+ (void)giveBedollars:(float)amount showNotification:(BOOL)showNotification withPosition:(int)position;
- (void)giveBedollars:(float)amount showNotification:(BOOL)showNotification;

+ (void)notifyGiveBedollarsGeneration:(BGiveBedollarsWrapper *)wrapper;
+ (void)notifyGiveBedollarsGenerationError:(NSDictionary *)_error;

@end

@protocol BeintooAppDelegate <NSObject>

@optional
- (void)didReceiveGiveBedollarsResponse:(BGiveBedollarsWrapper *)wrapper;
- (void)didFailToPerformGiveBedollars:(NSDictionary *)error;

@end
