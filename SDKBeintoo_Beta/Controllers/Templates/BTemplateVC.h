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

#define REWARD          100
#define AD              101
#define GIVE_BEDOLLARS  102
#define CUSTOM_TYPE     103

@interface BTemplateVC : UIViewController <UIWebViewDelegate>{

    UIWebView		*webview;
	NSString		*URL;	
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil urlToOpen:(NSString *)theURL;

- (UIButton *)closeButton;
- (void)closeBeintoo;

@property (nonatomic, retain) NSString *URL;
@property (nonatomic, assign) int type;

@end
