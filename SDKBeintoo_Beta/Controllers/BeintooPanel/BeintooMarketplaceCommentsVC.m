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

#import "BeintooMarketplaceCommentsVC.h"

@implementation BeintooMarketplaceCommentsVC
@synthesize selectedVgood, table;
@synthesize reloading=_reloading;
@synthesize refreshHeaderView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return NO;
}

- (void)dealloc{
    [keyboardToolbar release];
    [newMessageImageButton release];
    [commentsArray release];
    [imagesArray release];
    [_vgood release];
    [super dealloc];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
      self.navigationItem.title   = NSLocalizedStringFromTable(@"MPmarketplaceTitle",@"BeintooLocalizable",@"Marketplace");
    
    _vgood                      =   [[BeintooVgood alloc] init];
    
    //-------> Comments View implementation <-------
    textView.alpha              = 0.0f;
    textView.tag                = 60;
    
    commentsSendButton.alpha    = 0.0f;
    
    [commentsView setTopHeight:40.0f];
	[commentsView setBodyHeight:376.0f];
    
    commentsArray               =   [[NSMutableArray alloc] init];
    imagesArray                 =   [[NSMutableArray alloc] init];
    
    
    

    // Keyboard notifications
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) 
												 name:UIKeyboardWillShowNotification object:self.view.window];
	[[NSNotificationCenter defaultCenter] addObserver:self  selector:@selector(keyboardWillHide:) 
												 name:UIKeyboardWillHideNotification  object:self.view.window];
    keyboardIsShown = NO;
    writeNewMessageLabel.text  = NSLocalizedStringFromTable(@"MPwriteNewComment", @"BeintooLocalizable", nil);
    writeNewMessageLabel.textColor = [UIColor colorWithWhite:0.2 alpha:1.0];
	
	if (keyboardToolbar == nil) {
		keyboardToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 35)];
		keyboardToolbar.barStyle = UIBarStyleBlackOpaque;
        
		UIBarButtonItem *extraSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
		
		UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(dismissKeyboard)];
        
		[keyboardToolbar setItems:[[[NSArray alloc] initWithObjects:extraSpace,doneButton,nil] autorelease]];
		
		[doneButton release];
		[extraSpace release];
	}
	
	@try {
		if ([textView respondsToSelector:@selector(setInputAccessoryView:)])
			[textView setInputAccessoryView:keyboardToolbar];
		else
			isAccessoryInputViewNotSupported = YES;
	}
	@catch (NSException * e) {
		isAccessoryInputViewNotSupported = YES;
	}
    
    [commentsSendButton setTitle:NSLocalizedStringFromTable(@"MPsend", @"BeintooLocalizable", nil) forState:UIControlStateNormal];
    
    
    //------> Nav Controller Close Button
    UIBarButtonItem *barCloseBtn = [[UIBarButtonItem alloc] initWithCustomView:[BeintooMarketplaceVC closeButton]];
	[self.navigationItem setRightBarButtonItem:barCloseBtn animated:YES];
	[barCloseBtn release];
    
    //------> New Message Button
    newMessageImageButton = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    newMessageImageButton.image = [UIImage imageNamed:@"new_message_button_on.png"];
    newMessageImageButton.backgroundColor = [UIColor clearColor];
    newMessageImageButton.contentMode = UIViewContentModeScaleAspectFit;
    [commentsNewButton addSubview:newMessageImageButton];

    if (refreshHeaderView == nil) {
        refreshHeaderView = [[BRefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - self.table.bounds.size.height, 320.0f, self.table.bounds.size.height)];
        refreshHeaderView.backgroundColor = [UIColor colorWithRed:226.0/255.0 green:231.0/255.0 blue:237.0/255.0 alpha:1.0];
        refreshHeaderView.bottomBorderThickness = 1.0;
        [self.table addSubview:refreshHeaderView];
        self.table.showsVerticalScrollIndicator = YES;
        [refreshHeaderView release];
    }
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    if ([BeintooDevice isiPad]) {
        [self setContentSizeForViewInPopover:CGSizeMake(320, 415)];
    }
    
    _vgood.delegate     =   self;
    
    textView.text       = @"";
    
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [commentsSendButton setTextSize:[NSNumber numberWithInt:15]];
    [commentsSendButton setHighColor:[UIColor colorWithRed:156.0/255 green:168.0/255 blue:184.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(156, 2)/pow(255,2) green:pow(168, 2)/pow(255,2) blue:pow(184, 2)/pow(255,2) alpha:1]];
    [commentsSendButton setMediumHighColor:[UIColor colorWithRed:116.0/255 green:135.0/255 blue:159.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(116, 2)/pow(255,2) green:pow(135, 2)/pow(255,2) blue:pow(159, 2)/pow(255,2) alpha:1]];
    [commentsSendButton setMediumLowColor:[UIColor colorWithRed:108.0/255 green:128.0/255 blue:154.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(108, 2)/pow(255,2) green:pow(128, 2)/pow(255,2) blue:pow(154, 2)/pow(255,2) alpha:1]];
    [commentsSendButton setLowColor:[UIColor colorWithRed:89.0/255 green:112.0/255 blue:142.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(89, 2)/pow(255,2) green:pow(112, 2)/pow(255,2) blue:pow(142, 2)/pow(255,2) alpha:1]];
    
    [textView.layer setCornerRadius:0];
    [textView.layer setMasksToBounds:YES];
    [textView.layer setBorderWidth:1.0f];
    [textView.layer setBorderColor:[UIColor colorWithWhite:0 alpha:0.9].CGColor];
    
    if ([Beintoo appOrientation] == UIInterfaceOrientationLandscapeRight || 
        [Beintoo appOrientation] == UIInterfaceOrientationLandscapeLeft) {
        textView.frame = CGRectMake(textView.frame.origin.x, textView.frame.origin.y, textView.frame.size.width, 60);
        commentsSendButton.frame = CGRectMake(commentsSendButton.frame.origin.x, textView.frame.origin.y + textView.frame.size.height + 5, commentsSendButton.frame.size.width, commentsSendButton.frame.size.height);
    }
    else {
        textView.frame = CGRectMake(textView.frame.origin.x, textView.frame.origin.y, textView.frame.size.width, 120);    
        commentsSendButton.frame = CGRectMake(commentsSendButton.frame.origin.x, textView.frame.origin.y + textView.frame.size.height + 5, commentsSendButton.frame.size.width, commentsSendButton.frame.size.height);
    }

    [BLoadingView startFullScreenActivity:self.view];
    [_vgood getCommentListForVgoodId:[selectedVgood objectForKey:@"id"]];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    _vgood.delegate     =   nil;

}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    
    [self dismissKeyboard];
    [self hideTextView];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


#pragma mark - Private Methods

+ (UIButton *)closeButton{
	UIImage *closeImg   = [UIImage imageNamed:@"bar_close.png"];
	UIButton *closeBtn  = [UIButton buttonWithType:UIButtonTypeCustom];
	[closeBtn setImage:closeImg forState:UIControlStateNormal];
	closeBtn.frame      = CGRectMake(0,0, closeImg.size.width+7, closeImg.size.height);
	[closeBtn addTarget:self action:@selector(closeBeintoo) forControlEvents:UIControlEventTouchUpInside];
	return closeBtn;
}

+ (void)closeBeintoo{
	[Beintoo dismissBeintoo];
}

#pragma mark - IBOutlets

- (IBAction)createNewComment:(id)sender{
    if (isTextViewShown == NO){
        [self showTextView];
        
    }
    else {
        [self hideTextView];
        
    }
}

- (IBAction)sendCommentForVgood:(id)sender{
    
    NSString *text = [textView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if ([text length] > 0){
        [BLoadingView startFullScreenActivity:commentsView];
        [_vgood setCommentForVgoodId:[selectedVgood objectForKey:@"id"] andUser:[Beintoo getUserID] withComment:text];
    }
    else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedStringFromTable(@"error", @"BeintooLocalizable", nil) message:NSLocalizedStringFromTable(@"MPemptyCommentError", @"BeintooLocalizable", nil) delegate:self cancelButtonTitle:NSLocalizedStringFromTable(@"ok", @"BeintooLocalizable", nil) otherButtonTitles: nil];
        [alert show];
        [alert release];
    }
}

#pragma mark - Private Methods

- (void)showTextView{
    
    if (isTextViewShown == NO){
        isTextViewShown = YES;
        [UIView beginAnimations:@"showTextView" context:nil];
        [UIView setAnimationDuration:0.4];
        [UIView setAnimationDelegate:self];
        
        writeNewMessageLabel.textColor = [UIColor colorWithWhite:0.5 alpha:0.6];
        writeNewMessageLabel.frame      = CGRectMake(writeNewMessageLabel.frame.origin.x, writeNewMessageLabel.frame.origin.y + 1, writeNewMessageLabel.frame.size.width, writeNewMessageLabel.frame.size.height);
        newMessageImageButton.image = [UIImage imageNamed:@"new_message_button_off.png"];
        textView.alpha = 1.0f;
        commentsSendButton.alpha = 1.0f;
        table.frame = CGRectMake(table.frame.origin.x, table.frame.origin.y + textView.frame.size.height + commentsSendButton.frame.size.height + 15, table.frame.size.width, table.frame.size.height - textView.frame.size.height - commentsSendButton.frame.size.height - 15);
        
        [UIView commitAnimations];
    }
}

- (void)hideTextView{
    
    if (isTextViewShown == YES){
        [UIView beginAnimations:@"showTextView" context:nil];
        [UIView setAnimationDuration:0.4];
        [UIView setAnimationDelegate:self];
        
        writeNewMessageLabel.textColor = [UIColor colorWithWhite:0.2 alpha:1.0];
        writeNewMessageLabel.frame      = CGRectMake(writeNewMessageLabel.frame.origin.x, writeNewMessageLabel.frame.origin.y - 1, writeNewMessageLabel.frame.size.width, writeNewMessageLabel.frame.size.height);
        newMessageImageButton.image = [UIImage imageNamed:@"new_message_button_on.png"];
        textView.alpha = 0.0f;
        commentsSendButton.alpha = 0.0f;
        table.frame = CGRectMake(table.frame.origin.x, table.frame.origin.y - textView.frame.size.height - commentsSendButton.frame.size.height - 15, table.frame.size.width, table.frame.size.height + textView.frame.size.height + commentsSendButton.frame.size.height + 15);
        
        [self dismissKeyboard];
        
        [UIView commitAnimations];
        
        isTextViewShown = NO;
    }
}

#pragma mark -
#pragma mark BImageDownload Delegate Methods

- (void)bImageDownloadDidFinishDownloading:(BImageDownload *)download{
    if (download.tag != 1111){
         NSUInteger index       = [imagesArray indexOfObject:download]; 
         NSUInteger indices[]   = {0, index};
         NSIndexPath *path      = [[NSIndexPath alloc] initWithIndexes:indices length:2];
         [table reloadRowsAtIndexPaths:[NSArray arrayWithObject:path] withRowAnimation:UITableViewRowAnimationNone];
         [path release];
    }
}
- (void)bImageDownload:(BImageDownload *)download didFailWithError:(NSError *)error{
    NSLog(@"BeintooImageError: %@", [error localizedDescription]);
}

#pragma mark -
#pragma mark Animations For Keyboard

- (BOOL)textViewShouldBeginEditing:(UITextView *)aTextView {
    @try {
		if ([textView respondsToSelector:@selector(setInputAccessoryView:)])
			[textView setInputAccessoryView:keyboardToolbar];
		else
			isAccessoryInputViewNotSupported = YES;
	}
	@catch (NSException * e) {
		isAccessoryInputViewNotSupported = YES;
	}    return YES;
}

- (void)keyboardWillShow:(NSNotification *)aNotification {
	if ([textView isFirstResponder]){
		
		if (isAccessoryInputViewNotSupported) {
			UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedStringFromTable(@"done",@"BeintooLocalizable",@"")
																		   style:UIBarButtonItemStylePlain target:self action:@selector(dismissKeyboard)];
			self.navigationItem.rightBarButtonItem = doneButton;
			[doneButton release];
		}
        if (![BeintooDevice isiPad]) {
            [self moveTextViewForKeyboard:aNotification up:YES];
        }
	}
}

- (void)keyboardWillHide:(NSNotification *)aNotification {
	if ([textView isFirstResponder]) {
		self.navigationItem.rightBarButtonItem = nil;
        
        if (![BeintooDevice isiPad]) {
            [self moveTextViewForKeyboard:aNotification up:NO]; 
        }
	}
}

- (void)moveTextViewForKeyboard:(NSNotification*)aNotification up:(BOOL)up{
	NSDictionary* userInfo = [aNotification userInfo];
	
	NSTimeInterval animationDuration;
	UIViewAnimationCurve animationCurve;
	CGRect keyboardEndFrame;
	
	[[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] getValue:&animationCurve];
	[[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&animationDuration];
	[[userInfo objectForKey:UIKeyboardBoundsUserInfoKey] getValue:&keyboardEndFrame];
	
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:animationDuration];
	[UIView setAnimationCurve:animationCurve];
    
	CGPoint center          = self.view.center;
	CGRect keyboardFrame    = [self.view convertRect:keyboardEndFrame toView:nil];
	
	float shiftValue = 2.5;
	if (self.view.bounds.size.width > 330) {
		shiftValue = 16.8;
	}
	
	center.y			     -= (keyboardFrame.size.height/shiftValue) * (up? 1 : -1);	
	
    if ([Beintoo appOrientation] == UIInterfaceOrientationLandscapeRight || 
        [Beintoo appOrientation] == UIInterfaceOrientationLandscapeLeft) {
        self.view.center = center;
	}
	[UIView commitAnimations];
}

- (void)dismissKeyboard{
	if ([textView isFirstResponder])
		[textView resignFirstResponder];
}

#pragma mark - Beintoo callbacks

- (void)didGetCommentsList:(NSMutableArray *)result{
     @try {
         [commentsArray removeAllObjects];
         [imagesArray removeAllObjects];
         
         for (int i = 0; i < [result count]; i++){
             BImageDownload *download   = [[[BImageDownload alloc] init] autorelease];
             download.delegate          = self;
             download.urlString         = [[[result objectAtIndex:i] objectForKey:@"user"] objectForKey:@"usersmallimg"];
             [imagesArray addObject:download];
             [commentsArray addObject:[result objectAtIndex:i]];           
         }
         if ([commentsArray count] == 0){
             [self showTextView];
         }
     }
     @catch (NSException *exception) {
     
     }
     
     [BLoadingView stopActivity];
     [self performSelector:@selector(dataSourceDidFinishLoadingNewData) withObject:nil afterDelay:0.0];
}
     
- (void)didSetCommentForVgood:(NSDictionary *)result{
    [self hideTextView];
    textView.text = @"";
    [commentsArray removeAllObjects];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:NSLocalizedStringFromTable(@"MPsentComment", @"BeintooLocalizable", nil) delegate:self cancelButtonTitle:NSLocalizedStringFromTable(@"ok", @"BeintooLocalizable", nil) otherButtonTitles: nil];
    [alert show];
    [alert release];
    
    [_vgood getCommentListForVgoodId:[selectedVgood objectForKey:@"id"]];
}

#pragma mark -
#pragma mark Table view data source
 
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    if ([commentsArray count] == 0)
        return 1;
    else 
        return [commentsArray count];
}

- (float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([commentsArray count] == 0){
        return 45;
    }
    else {
        UILabel *textMessage         = [[UILabel alloc] initWithFrame:CGRectMake(75, 22, 240, 1000)];
        textMessage.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        CGSize size = CGSizeMake(textMessage.frame.size.width, textMessage.frame.size.height);
        CGSize expectedCommentDimensions = [[[commentsArray objectAtIndex:indexPath.row] objectForKey:@"comment"] sizeWithFont:[UIFont systemFontOfSize:11] constrainedToSize:size lineBreakMode:UILineBreakModeWordWrap];

        [textMessage release];
        
        return 22 + expectedCommentDimensions.height + 20 + 5;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    static NSString *CellIdentifier = @"Cell";
    int _gradientType = (indexPath.row % 2) ? GRADIENT_CELL_HEAD : GRADIENT_CELL_BODY;

    BTableViewCell *cell = (BTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil || YES) {
    cell = [[[BTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier andGradientType:_gradientType] autorelease];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }

    @try {
        if (indexPath.row == 0){
            UIView *vi = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 0.5)];
            vi.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.70f];
            vi.autoresizingMask = UIViewAutoresizingFlexibleWidth;
            [cell addSubview:vi];
            [vi release];

            vi = [[UIView alloc] initWithFrame:CGRectMake(0, 0.5, 320, 1)];
            vi.backgroundColor = [UIColor whiteColor];
            [cell addSubview:vi];
        }

        if ([commentsArray count] == 0){

            cell.textLabel.text        = NSLocalizedStringFromTable(@"MPnoAvailableComments", @"BeintooLocalizable", nil);
            cell.textLabel.font        = [UIFont systemFontOfSize:14];
        }
        else {

            UIImageView *imageViewItem = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 50, 50)];

            BImageDownload *download   = [imagesArray objectAtIndex:indexPath.row];
            imageViewItem.image        = download.image;
            imageViewItem.contentMode  = UIViewContentModeScaleAspectFit;
            imageViewItem.center       = CGPointMake(imageViewItem.center.x, imageViewItem.center.y);

            [cell addSubview:imageViewItem];
            [imageViewItem release];

            UILabel *nameLabel         = [[UILabel alloc] initWithFrame:CGRectMake(75, 2, 240, 20)];
            nameLabel.text             = [[[commentsArray objectAtIndex:indexPath.row] objectForKey:@"user"] objectForKey:@"nickname"];
            nameLabel.textAlignment    = UITextAlignmentLeft;
            nameLabel.font             = [UIFont systemFontOfSize:13];
            nameLabel.backgroundColor  = [UIColor clearColor];
            nameLabel.numberOfLines    = 1;
            nameLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;

            [cell addSubview:nameLabel];
            [nameLabel release];

            
            UILabel *textMessage         = [[UILabel alloc] initWithFrame:CGRectMake(75, 22, 240, 1000)];
            
            CGSize size = CGSizeMake(textMessage.frame.size.width, textMessage.frame.size.height);
            
            CGSize expectedCommentDimensions = [[[commentsArray objectAtIndex:indexPath.row] objectForKey:@"comment"] sizeWithFont:[UIFont systemFontOfSize:11] constrainedToSize:size lineBreakMode:UILineBreakModeWordWrap];
            
            textMessage.frame = CGRectMake(75, 22, 240, expectedCommentDimensions.height);
            textMessage.text             = [[commentsArray objectAtIndex:indexPath.row] objectForKey:@"comment"];
            textMessage.textAlignment    = UITextAlignmentLeft;
            textMessage.font             = [UIFont systemFontOfSize:11];
            textMessage.backgroundColor  = [UIColor clearColor];
            textMessage.numberOfLines    = 0;
            textMessage.autoresizingMask = UIViewAutoresizingFlexibleWidth;

            [cell addSubview:textMessage];
            [textMessage release];


            UILabel *descLabel = [[UILabel alloc] initWithFrame:CGRectMake(75, 23 + expectedCommentDimensions.height, 240, 20)];
            descLabel.text              = [[commentsArray objectAtIndex:indexPath.row] objectForKey:@"creationdate"];
            descLabel.textAlignment     = UITextAlignmentLeft;
            descLabel.font              = [UIFont systemFontOfSize:11];
            descLabel.backgroundColor   = [UIColor clearColor];
            descLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
            descLabel.textColor         = [UIColor colorWithWhite:0.30 alpha:1.00];

            [cell addSubview:descLabel];
            [descLabel release];

        }
    }
    @catch (NSException * e) {
        //[_player logException:[NSString stringWithFormat:@"STACK: %@\n\nException: %@",[NSThread callStackSymbols],e]];
    }

    return cell;
}

#pragma mark - Pull To Refresh TableView

- (void)reloadTableViewDataSource{
	//  qui possiamo richiamare metodi specifici per ricaricare i dati
    _reloading = NO;
	
    [_vgood getCommentListForVgoodId:[selectedVgood objectForKey:@"id"]];
    
}

- (void)dataSourceDidFinishLoadingNewData{
	// settiamo la data corrente come ultimo refresh
    
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:.3];
	[self.table setContentInset:UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f)];
	[UIView commitAnimations];
	
	[refreshHeaderView setState:EGOOPullRefreshNormal];

    [refreshHeaderView setCurrentDate];	
	//[super dataSourceDidFinishLoadingNewData];
    [self.table reloadData];
    if ([commentsArray count] == 0){
        [self showTextView];
    }
    else {
        [self hideTextView];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{	
	
	if (scrollView.isDragging) {
		if (refreshHeaderView.state == EGOOPullRefreshPulling && scrollView.contentOffset.y > -65.0f && scrollView.contentOffset.y < 0.0f && !_reloading) {
			[refreshHeaderView setState:EGOOPullRefreshNormal];
		} else if (refreshHeaderView.state == EGOOPullRefreshNormal && scrollView.contentOffset.y < -65.0f && !_reloading) {
			[refreshHeaderView setState:EGOOPullRefreshPulling];
		}
	}
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
	
	if (scrollView.contentOffset.y <= - 65.0f && !_reloading) {
		_reloading = YES;
		[self reloadTableViewDataSource];
		[refreshHeaderView setState:EGOOPullRefreshLoading];
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:0.2];
		self.table.contentInset = UIEdgeInsetsMake(60.0f, 0.0f, 0.0f, 0.0f);
		[UIView commitAnimations];
	}
}


@end
