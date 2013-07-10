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

#import "BeintooMainController.h"
#import "Beintoo.h"

@implementation BeintooMainController
@synthesize templateVC, template, templateGB, type;

- (id)init
{
	if (self = [super init])
    {
        templateVC  = [[BTemplateVC alloc] init];
        template    = [[BTemplate alloc] init];
        templateGB  = [[BTemplateGiveBedollars alloc] init];        
    }
    return self;
}

#if __IPHONE_OS_VERSION_MIN_REQUIRED < BEINTOO_IOS_6_0
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}
#endif

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= BEINTOO_IOS_6_0
- (BOOL)shouldAutorotate
{
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAll;
}
#endif

- (void)dealloc {
    
#ifdef BEINTOO_ARC_AVAILABLE
#else
    [templateVC release];
    [template release];
    [templateGB release];
    
	[super dealloc];
#endif
    
}

@end
