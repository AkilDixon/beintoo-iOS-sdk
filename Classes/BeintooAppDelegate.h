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
#import "BeintooDelegate.h"

@class BeintooViewController;

@interface BeintooAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    BeintooViewController *viewController;
	BeintooDelegate *sampleDelegate;
	
	// CREARE CLASSE BeintooDelegate .h e .m
	// in questo fare override dei metodi presenti in BeintooMainDelegate.h più usare <BeintooMainDelegate.m>
	// dichiarare qui oggetto di tipo BeintooDelegate
	// alloc+init nel appDelegate.m
	// passare l'oggetto all'init di Beintoo
	// release nel dealloc dell'appDelegate.m	
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet BeintooViewController *viewController;

@end

