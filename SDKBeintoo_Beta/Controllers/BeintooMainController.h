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

#import <UIKit/UIKit.h>

@class BTemplateVC, BTemplate, BTemplateGiveBedollars;

// Main is the type of a controller presented as first layer of Beintoo, other controllers presented on Beintoo itself, will be child
// This is usefull to present n controllers upon themselves.
// Main controller will be the only one the will trigger the delegate callbacks

#define NAV_TYPE_MAIN         1
#define NAV_TYPE_CHILD        2

@interface BeintooMainController : UINavigationController
{
	NSString *transitionEnterSubtype;
	NSString *transitionExitSubtype;
    
    BTemplateVC *templateVC;
    BTemplate   *template;
    BTemplateGiveBedollars   *templateGB;
}

@property (nonatomic, retain) BTemplateVC *templateVC;
@property (nonatomic, retain) BTemplate *template;
@property (nonatomic, retain) BTemplateGiveBedollars *templateGB;
@property (nonatomic, assign) int type;


@end
