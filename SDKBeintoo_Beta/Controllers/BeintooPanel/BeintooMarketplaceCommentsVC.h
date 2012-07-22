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
#import "BRefreshTableHeaderView.h"

@interface BeintooMarketplaceCommentsVC : UIViewController <BeintooVgoodDelegate, BImageDownloadDelegate> {

    BeintooVgood            *_vgood;
    NSMutableArray          *commentsArray;
    NSMutableArray          *imagesArray;
    
    UIToolbar				*keyboardToolbar;
    BOOL					keyboardIsShown;
	BOOL					isAccessoryInputViewNotSupported;
    BOOL                    isTextViewShown;
    
    BRefreshTableHeaderView *refreshHeaderView;
	BOOL _reloading;

    // ------> comments view <-------
    IBOutlet BView          *commentsView;
    IBOutlet BButton        *commentsNewButton;
    IBOutlet BButton        *commentsSendButton;
    IBOutlet UITextView     *textView;
    IBOutlet BTableView     *table;
    IBOutlet UILabel        *writeNewMessageLabel;
    UIImageView             *newMessageImageButton;
    
}

@property (nonatomic,retain) NSMutableDictionary    *selectedVgood;
@property (nonatomic,retain) IBOutlet BTableView     *table;

//** Pull Down To Refresh
@property(assign,getter=isReloading) BOOL reloading;
@property(nonatomic,readonly) BRefreshTableHeaderView *refreshHeaderView;

- (void)reloadTableViewDataSource;
- (void)dataSourceDidFinishLoadingNewData;
//**

- (IBAction)createNewComment:(id)sender;
- (void)showTextView;
- (void)hideTextView;
- (void)keyboardWillShow:(NSNotification *)aNotification;
- (void)keyboardWillHide:(NSNotification *)aNotification;
- (void)moveTextViewForKeyboard:(NSNotification*)aNotification up:(BOOL)up;
- (void)dismissKeyboard;

- (void)didGetCommentsList:(NSMutableArray *)result;

@end
