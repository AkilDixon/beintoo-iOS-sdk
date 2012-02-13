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

#import "BeintooLoginVC.h"
#import "Beintoo.h"

@implementation BeintooLoginVC

@synthesize retrievedUsers, userImages, callerIstance, caller;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
		
    if (self) {
		registrationFBVC = [[BeintooSigninFacebookVC alloc] initWithNibName:@"BeintooSigninFacebookVC" bundle:[NSBundle mainBundle]];
		registrationVC	 = [[BeintooSigninVC alloc] initWithNibName:@"BeintooSigninVC" bundle:[NSBundle mainBundle]];
		self.userImages   = [[NSMutableArray alloc]init];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.title = @"Accounts";
	
	[loginView setTopHeight:53.0];
	[loginView setBodyHeight:375.0];
	
	_player = [[BeintooPlayer alloc] init];
	_player.delegate = self;
	
	self.retrievedUsers = [[NSArray alloc]init];

	useAnotherBtnLabel.text = NSLocalizedStringFromTable(@"useAnotherAccount",@"BeintooLocalizable",@"Use another account");
	titleLabel1.text = NSLocalizedStringFromTable(@"wehavefound",@"BeintooLocalizable",@"We have found multiple Beintoo players");
	titleLabel2.text = NSLocalizedStringFromTable(@"selectwhich",@"BeintooLocalizable",@"Select which one to use,");
	
	[anotherPlayerButton setHighColor:[UIColor colorWithRed:156.0/255 green:168.0/255 blue:184.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(156, 2)/pow(255,2) green:pow(168, 2)/pow(255,2) blue:pow(184, 2)/pow(255,2) alpha:1]];
	[anotherPlayerButton setMediumHighColor:[UIColor colorWithRed:116.0/255 green:135.0/255 blue:159.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(116, 2)/pow(255,2) green:pow(135, 2)/pow(255,2) blue:pow(159, 2)/pow(255,2) alpha:1]];
	[anotherPlayerButton setMediumLowColor:[UIColor colorWithRed:108.0/255 green:128.0/255 blue:154.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(108, 2)/pow(255,2) green:pow(128, 2)/pow(255,2) blue:pow(154, 2)/pow(255,2) alpha:1]];
    [anotherPlayerButton setLowColor:[UIColor colorWithRed:89.0/255 green:112.0/255 blue:142.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(89, 2)/pow(255,2) green:pow(112, 2)/pow(255,2) blue:pow(142, 2)/pow(255,2) alpha:1]];
	[anotherPlayerButton setTitle:NSLocalizedStringFromTable(@"useAnotherAccount",@"BeintooLocalizable",@"Use another account") forState:UIControlStateNormal];
	[anotherPlayerButton setButtonTextSize:20];
		
	self.navigationController.navigationBarHidden = NO;
		
	// Retrieved Players Initial Settings
	retrievedPlayersTable.delegate  = self;
	retrievedPlayersTable.rowHeight = 50.0f; 
	
	UIBarButtonItem *barCloseBtn = [[UIBarButtonItem alloc] initWithCustomView:[self closeButton]];
	[self.navigationItem setRightBarButtonItem:barCloseBtn animated:YES];
	[barCloseBtn release];
}

- (void)viewWillAppear:(BOOL)animated{
    
    if ([caller isEqualToString:@"MarketplaceList"]){
        callerIstance.needsToReloadData = NO;
    }
    
    if ([BeintooDevice isiPad]) {
        [self setContentSizeForViewInPopover:CGSizeMake(320, 415)];
    }
	self.retrievedUsers = [[Beintoo getLastLoggedPlayers] retain];	
	
	if ([self.retrievedUsers count]<1) { // -- no already logged users found. Proceeding to registration.
        [self.navigationController pushViewController:registrationVC animated:NO];
	}else{
		[self.userImages removeAllObjects];
		for (int i=0; i<[self.retrievedUsers count]; i++) {
			@try {
                if ([self.retrievedUsers isKindOfClass:[NSDictionary class]]) {
                    NSLog(@"Beintoo ERROR: %@",[(NSDictionary *)self.retrievedUsers objectForKey:@"message"]);
                    return;
                }
				NSDictionary *user = [self.retrievedUsers objectAtIndex:i];	
				BImageDownload *download = [[[BImageDownload alloc] init] autorelease];
				download.delegate = self;
				download.urlString = [user objectForKey:@"usersmallimg"];
				

				[self.userImages addObject:download];
			}
			@catch (NSException * e) {
				NSLog(@"BeintooException: %@ \n for object: %@",e,[self.retrievedUsers objectAtIndex:i]);
			}
		}
		[retrievedPlayersTable reloadData];		
	}
}

- (UIButton *)closeButton{
	UIImage *closeImg = [UIImage imageNamed:@"bar_close.png"];
	UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
	[closeBtn setImage:closeImg forState:UIControlStateNormal];
	closeBtn.frame = CGRectMake(0,0, closeImg.size.width+7, closeImg.size.height);
	[closeBtn addTarget:self action:@selector(closeBeintoo) forControlEvents:UIControlEventTouchUpInside];
	return closeBtn;
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //return [[[BeintooApp sharedInstance] getRetrievedPlayers] count];
	return [self.retrievedUsers count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *CellIdentifier = @"Cell";
   	int _gradientType = (indexPath.row % 2) ? GRADIENT_CELL_HEAD : GRADIENT_CELL_BODY;
	
	BTableViewCell *cell = (BTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil || TRUE) {
        cell = [[[BTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier andGradientType:_gradientType] autorelease];
    }
    if ([self.retrievedUsers isKindOfClass:[NSDictionary class]]) {
        return cell;
    }
	NSDictionary *user = [self.retrievedUsers objectAtIndex:indexPath.row];

	@try {
		BImageDownload *download = [self.userImages objectAtIndex:indexPath.row];
		UIImage *cellImage  = download.image;

		cell.textLabel.text				= [user objectForKey:@"nickname"];
		cell.textLabel.font				= [UIFont systemFontOfSize:16];
		cell.detailTextLabel.text		= [NSString stringWithFormat:@"%@ %@",NSLocalizedStringFromTable(@"level",@"BeintooLocalizable",@""),[self translateLevel:[user objectForKey:@"level"]]];
		cell.imageView.image			= cellImage;
	}
	@catch (NSException * e){
		//[_player logException:[NSString stringWithFormat:@"STACK: %@\n\nException: %@",[NSThread callStackSymbols],e]];
	}
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
		
	NSDictionary *user	= [self.retrievedUsers objectAtIndex:indexPath.row];	
	NSString *userID	= [user objectForKey:@"id"];
	
	[BLoadingView startActivity:self.view];
	[_player login:userID];
}

#pragma mark -
#pragma mark GeneratePlayer

- (void)generatePlayerIfNotExists{
	if ([Beintoo getPlayerID]==nil) {
		NSDictionary *anonymPlayer = [_player blockingLogin:@""];
		if ([anonymPlayer objectForKey:@"guid"]==nil) {			
			[BeintooNetwork showNoConnectionAlert];
			return;
		}
		else {
			[Beintoo setBeintooPlayer:anonymPlayer];
		}
	}
}

#pragma mark -
#pragma mark Delegates
- (void)playerDidLogin:(BeintooPlayer *)player{	
	[BLoadingView stopActivity];
	if ([player loginError]==LOGIN_NO_ERROR) {
		[retrievedPlayersTable deselectRowAtIndexPath:[retrievedPlayersTable indexPathForSelectedRow] animated:YES];
        
        if ([caller isEqualToString:@"MarketplaceList"] || [caller isEqualToString:@"MarketplaceSelectedCoupon"]){
            if([BeintooDevice isiPad]){
                [Beintoo dismissIpadLogin];
            }
            else {
                [self dismissModalViewControllerAnimated:YES];
            }
        }
        else if([BeintooDevice isiPad]){
            if ([Beintoo dismissBeintooOnRegistrationEnd]) {
                [Beintoo dismissBeintoo];
            }
            else{
                [Beintoo dismissIpadLogin];
            }
        }else {
            if ([Beintoo dismissBeintooOnRegistrationEnd]) {
                [Beintoo dismissBeintooNotAnimated];
                [self dismissModalViewControllerAnimated:YES];
            }
            else{
                [self dismissModalViewControllerAnimated:YES];
            }
        }
        
        // OLD DISMISS (does not care of dismissBeintooAfterRegistration parameter)
        /*	if([BeintooDevice isiPad]){
         [Beintoo dismissIpadLogin];
         }else {
         [self dismissModalViewControllerAnimated:YES];
         }*/
        
	}
}

#pragma mark -
#pragma mark BImageDownload Delegate Methods
- (void)bImageDownloadDidFinishDownloading:(BImageDownload *)download{
    NSUInteger index = [self.userImages indexOfObject:download]; 
    NSUInteger indices[] = {0, index};
    NSIndexPath *path = [[NSIndexPath alloc] initWithIndexes:indices length:2];
	[retrievedPlayersTable reloadRowsAtIndexPaths:[NSArray arrayWithObject:path] withRowAnimation:UITableViewRowAnimationNone];
    [path release];
    download.delegate = nil;
}
- (void)bImageDownload:(BImageDownload *)download didFailWithError:(NSError *)error{
    NSLog(@"imagedownloadingerror: %@", [error localizedDescription]);
}

#pragma mark -
#pragma mark CommonMethods

- (IBAction)otherPlayer{	
    [self.navigationController pushViewController:registrationVC animated:YES];
}

-(void)closeBeintoo{
    if ([caller isEqualToString:@"MarketplaceList"] || [caller isEqualToString:@"MarketplaceSelectedCoupon"]){
        if([BeintooDevice isiPad]){
            [Beintoo dismissIpadLogin];
        }
        else {
            [self dismissModalViewControllerAnimated:YES];
        }
    }
    else if([BeintooDevice isiPad]){
		[Beintoo dismissIpadLogin];
	}else {
		[self dismissModalViewControllerAnimated:YES];
	}
}

- (NSString *)translateLevel:(NSNumber *)levelNumber{	
	if (levelNumber.intValue==1) {return NSLocalizedStringFromTable(@"novice",@"BeintooLocalizable",@"Novice");}
	else if(levelNumber.intValue==2){return NSLocalizedStringFromTable(@"learner",@"BeintooLocalizable",@"Learner");}
	else if(levelNumber.intValue==3){return NSLocalizedStringFromTable(@"passionate",@"BeintooLocalizable",@"Passionate");}
	else if(levelNumber.intValue==4){return NSLocalizedStringFromTable(@"winner",@"BeintooLocalizable",@"Winner");}
	else if(levelNumber.intValue==5){return NSLocalizedStringFromTable(@"master",@"BeintooLocalizable",@"Master");}
	else
		return @"";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
    [super viewDidUnload];
}

- (void)viewWillDisappear:(BOOL)animated {
    @try {
		[BLoadingView stopActivity];
	}
	@catch (NSException * e) {
	}
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return (interfaceOrientation == [Beintoo appOrientation]);
}

- (void)dealloc {
	[registrationFBVC release];
	[registrationVC release];
	[self.userImages release];
	[_player release];
	[self.retrievedUsers release];
    [super dealloc];
}


@end
