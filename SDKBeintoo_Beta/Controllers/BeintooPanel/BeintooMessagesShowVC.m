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


#import "BeintooMessagesShowVC.h"
#import "Beintoo.h"

@implementation BeintooMessagesShowVC

@synthesize currentMessage;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil andOptions:(NSDictionary *)options{
	self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
		self.currentMessage	= options;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
		
	[showMessageView setTopHeight:118.0];
	[showMessageView setBodyHeight:309.0];
	
	_message		  = [[BeintooMessage alloc] init];
	_player			  =	[[BeintooPlayer alloc] init];
	newMessageVC	  = [BeintooNewMessageVC alloc];
	
	UIBarButtonItem *barCloseBtn = [[UIBarButtonItem alloc] initWithCustomView:[self closeButton]];
	[self.navigationItem setRightBarButtonItem:barCloseBtn animated:YES];
	[barCloseBtn release];			
	
	[replyButton setHighColor:[UIColor colorWithRed:156.0/255 green:168.0/255 blue:184.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(156, 2)/pow(255,2) green:pow(168, 2)/pow(255,2) blue:pow(184, 2)/pow(255,2) alpha:1]];
	[replyButton setMediumHighColor:[UIColor colorWithRed:116.0/255 green:135.0/255 blue:159.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(116, 2)/pow(255,2) green:pow(135, 2)/pow(255,2) blue:pow(159, 2)/pow(255,2) alpha:1]];
	[replyButton setMediumLowColor:[UIColor colorWithRed:108.0/255 green:128.0/255 blue:154.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(108, 2)/pow(255,2) green:pow(128, 2)/pow(255,2) blue:pow(154, 2)/pow(255,2) alpha:1]];
    [replyButton setLowColor:[UIColor colorWithRed:89.0/255 green:112.0/255 blue:142.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(89, 2)/pow(255,2) green:pow(112, 2)/pow(255,2) blue:pow(142, 2)/pow(255,2) alpha:1]];
	[replyButton setTitle:NSLocalizedStringFromTable(@"reply",@"BeintooLocalizable",@"") forState:UIControlStateNormal];
	[replyButton setButtonTextSize:16];
	
	[deleteButton setHighColor:[UIColor colorWithRed:156.0/255 green:168.0/255 blue:184.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(156, 2)/pow(255,2) green:pow(168, 2)/pow(255,2) blue:pow(184, 2)/pow(255,2) alpha:1]];
	[deleteButton setMediumHighColor:[UIColor colorWithRed:116.0/255 green:135.0/255 blue:159.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(116, 2)/pow(255,2) green:pow(135, 2)/pow(255,2) blue:pow(159, 2)/pow(255,2) alpha:1]];
	[deleteButton setMediumLowColor:[UIColor colorWithRed:108.0/255 green:128.0/255 blue:154.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(108, 2)/pow(255,2) green:pow(128, 2)/pow(255,2) blue:pow(154, 2)/pow(255,2) alpha:1]];
    [deleteButton setLowColor:[UIColor colorWithRed:89.0/255 green:112.0/255 blue:142.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(89, 2)/pow(255,2) green:pow(112, 2)/pow(255,2) blue:pow(142, 2)/pow(255,2) alpha:1]];
	[deleteButton setTitle:NSLocalizedStringFromTable(@"delete",@"BeintooLocalizable",@"") forState:UIControlStateNormal];
	[deleteButton setButtonTextSize:16];
	
	messageText.backgroundColor = [UIColor clearColor];
	[messageView setGradientType:GRADIENT_HEADER];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    if ([BeintooDevice isiPad]) {
        [self setContentSizeForViewInPopover:CGSizeMake(320, 436)];
    }
    _message.delegate = self;
	_player.delegate  = self;
    
    self.title = [self.currentMessage objectForKey:@"from"];
	
	if (![Beintoo isUserLogged])
		[self.navigationController popToRootViewControllerAnimated:NO];
	else {
		[BLoadingView startActivity:self.view];
		[NSThread detachNewThreadSelector:@selector(loadImage) toTarget:self withObject:nil];	
		
		fromLabel.text		= NSLocalizedStringFromTable(@"from:",@"BeintooLocalizable",@"");
		fromLabelText.text  = [self.currentMessage objectForKey:@"from"];
		dateLabel.text		= NSLocalizedStringFromTable(@"date",@"BeintooLocalizable",@"");
		NSString *currentCreationDate = [self.currentMessage objectForKey:@"creationdate"];
		dateLabelText.text  = [BeintooNetwork convertToCurrentDate:currentCreationDate];		
		messageText.text	= [self.currentMessage objectForKey:@"text"];
		
		@try {
			if ([[self.currentMessage objectForKey:@"status"]isEqualToString:@"UNREAD"]) 
				[_message setToReadMessageWithID:[self.currentMessage objectForKey:@"id"]];		
		}
		@catch (NSException * e) {
		}
	}
}

- (void)loadImage{
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	@try{
		NSURL *imageURL = [NSURL URLWithString:[self.currentMessage  objectForKey:@"fromImgURL"]];
		UIImage *userImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:imageURL]];
		[fromPicture setImage:userImage];
	}
	@catch (NSException * e) {
	}
	[BLoadingView stopActivity];	
	[pool release];
}

#pragma mark -
#pragma mark Message delegates

- (void)didDeleteMessageWithResult:(BOOL)messageDeleted{
	if (messageDeleted) {

		// * Update total message count */
		NSString *guid = [Beintoo getPlayerID];
		if (guid!=nil) {
			[_player getPlayerByGUID:guid];
		}
	}
	else {
		UIAlertView *av = [[UIAlertView alloc] initWithTitle:nil message:NSLocalizedStringFromTable(@"messageNotDeleted",@"BeintooLocalizable",@"") 
													delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
		[av show];
		[av release];		
	}
}

- (void)didUserReadAMessage:(BOOL)messareRead{
	int unreadMsg = [BeintooMessage unreadMessagesCount];
	[BeintooMessage setUnreadMessages:[NSString stringWithFormat:@"%d",(unreadMsg-1)]];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex{ 
	if (buttonIndex == 0 && alertView.tag == 123)
		[self.navigationController popViewControllerAnimated:YES];
}

- (void)player:(BeintooPlayer *)player getPlayerByGUID:(NSDictionary *)result{
	@try {
		if ([result objectForKey:@"user"]!=nil) {
			NSString *totalMessages  = [[result objectForKey:@"user"] objectForKey:@"messages"];
			NSString *unreadMessages = [[result objectForKey:@"user"] objectForKey:@"unreadMessages"];
			
			[BeintooMessage setTotalMessages:totalMessages];
			[BeintooMessage setUnreadMessages:unreadMessages];
			
			UIAlertView *av = [[UIAlertView alloc] initWithTitle:nil message:NSLocalizedStringFromTable(@"messageDeleted",@"BeintooLocalizable",@"") 
														delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
			av.tag = 123;
			[av show];
			[av release];
		}
	}
	@catch (NSException * e) {
	}
	
}

#pragma mark -
#pragma mark IBActions

- (IBAction)deleteMessage{
	[_message deleteMessageWithID:[self.currentMessage objectForKey:@"id"]];
}

- (IBAction)replyToMessage{
	NSDictionary *replyOptions = [NSDictionary dictionaryWithObjectsAndKeys:self.currentMessage,@"replyOptions",nil];
	[newMessageVC initWithNibName:@"BeintooNewMessageVC" bundle:[NSBundle mainBundle] andOptions:replyOptions];
	[self.navigationController pushViewController:newMessageVC animated:YES];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return NO;
}

- (UIView *)closeButton{
    UIView *_vi = [[UIView alloc] initWithFrame:CGRectMake(-25, 5, 35, 35)];
    
    UIImageView *_imageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 15, 15)];
    _imageView.image = [UIImage imageNamed:@"bar_close_button.png"];
    _imageView.contentMode = UIViewContentModeScaleAspectFit;
	
    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
	closeBtn.frame = CGRectMake(6, 6.5, 35, 35);
    [closeBtn addSubview:_imageView];
	[closeBtn addTarget:self action:@selector(closeBeintoo) forControlEvents:UIControlEventTouchUpInside];
    
    [_vi addSubview:closeBtn];
	
    return _vi;
}

- (void)closeBeintoo{
    BeintooNavigationController *navController = (BeintooNavigationController *)self.navigationController;
    [Beintoo dismissBeintoo:navController.type];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];

    _message.delegate = nil;
    _player.delegate  = nil;
    
    @try {
        [BLoadingView stopActivity];
    }	
    @catch (NSException * e) {
    }
}

- (void)dealloc {
	[newMessageVC release];
	[_player release];
	[_message release];
    [super dealloc];
}


@end
