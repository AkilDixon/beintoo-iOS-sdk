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

#import "BeintooViewAllianceVC.h"
#import "Beintoo.h"

@implementation BeintooViewAllianceVC

@synthesize elementsTable, elementsArrayList, selectedElement, startingOptions, globalResult;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil andOptions:(NSDictionary *)options{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
		self.startingOptions	= options;
	}
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.title		= NSLocalizedStringFromTable(@"alliance_your",@"BeintooLocalizable",@"");
	
	[alliancesActionView setTopHeight:82];
	[alliancesActionView setBodyHeight:440];
	
	elementsArrayList   = [[NSMutableArray alloc] init];
     globalResult        = [[NSDictionary alloc] init];
	_player				= [[BeintooPlayer alloc] init];
    _alliance           = [[BeintooAlliance alloc] init];
    allianceAdminUserID = [[NSString alloc] init];    
    allianceId = [[NSString alloc] init];    

	UIBarButtonItem *barCloseBtn = [[UIBarButtonItem alloc] initWithCustomView:[BeintooVC closeButton]];
	[self.navigationItem setRightBarButtonItem:barCloseBtn animated:YES];
	[barCloseBtn release];
		
	self.elementsTable.delegate		= self;
	self.elementsTable.rowHeight	= 30.0;	
    
    [alliancesActionView setIsScrollView:YES];
    scrollView.contentSize = CGSizeMake(self.view.bounds.size.width, 320);
	scrollView.backgroundColor = [UIColor colorWithRed:108.0/255 green:128.0/255 blue:154.0/255 alpha:1];
    scrollView.scrollEnabled = NO;

    
    [leaveAllianceButton setHighColor:[UIColor colorWithRed:156.0/255 green:168.0/255 blue:184.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(156, 2)/pow(255,2) green:pow(168, 2)/pow(255,2) blue:pow(184, 2)/pow(255,2) alpha:1]];
	[leaveAllianceButton setMediumHighColor:[UIColor colorWithRed:116.0/255 green:135.0/255 blue:159.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(116, 2)/pow(255,2) green:pow(135, 2)/pow(255,2) blue:pow(159, 2)/pow(255,2) alpha:1]];
	[leaveAllianceButton setMediumLowColor:[UIColor colorWithRed:108.0/255 green:128.0/255 blue:154.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(108, 2)/pow(255,2) green:pow(128, 2)/pow(255,2) blue:pow(154, 2)/pow(255,2) alpha:1]];
    [leaveAllianceButton setLowColor:[UIColor colorWithRed:89.0/255 green:112.0/255 blue:142.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(89, 2)/pow(255,2) green:pow(112, 2)/pow(255,2) blue:pow(142, 2)/pow(255,2) alpha:1]];
	[leaveAllianceButton setTitle:NSLocalizedStringFromTable(@"allianceleave",@"BeintooLocalizable",@"") forState:UIControlStateNormal];
	[leaveAllianceButton setButtonTextSize:15];
    
	[pendingRequestsButton setHighColor:[UIColor colorWithRed:156.0/255 green:168.0/255 blue:184.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(156, 2)/pow(255,2) green:pow(168, 2)/pow(255,2) blue:pow(184, 2)/pow(255,2) alpha:1]];
	[pendingRequestsButton setMediumHighColor:[UIColor colorWithRed:116.0/255 green:135.0/255 blue:159.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(116, 2)/pow(255,2) green:pow(135, 2)/pow(255,2) blue:pow(159, 2)/pow(255,2) alpha:1]];
	[pendingRequestsButton setMediumLowColor:[UIColor colorWithRed:108.0/255 green:128.0/255 blue:154.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(108, 2)/pow(255,2) green:pow(128, 2)/pow(255,2) blue:pow(154, 2)/pow(255,2) alpha:1]];
    [pendingRequestsButton setLowColor:[UIColor colorWithRed:89.0/255 green:112.0/255 blue:142.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(89, 2)/pow(255,2) green:pow(112, 2)/pow(255,2) blue:pow(142, 2)/pow(255,2) alpha:1]];
	[pendingRequestsButton setTitle:NSLocalizedStringFromTable(@"allianceviewpending",@"BeintooLocalizable",@"") forState:UIControlStateNormal];
	[pendingRequestsButton setButtonTextSize:15];
    
    [askToJoinAllianceButton setHighColor:[UIColor colorWithRed:156.0/255 green:168.0/255 blue:184.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(156, 2)/pow(255,2) green:pow(168, 2)/pow(255,2) blue:pow(184, 2)/pow(255,2) alpha:1]];
	[askToJoinAllianceButton setMediumHighColor:[UIColor colorWithRed:116.0/255 green:135.0/255 blue:159.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(116, 2)/pow(255,2) green:pow(135, 2)/pow(255,2) blue:pow(159, 2)/pow(255,2) alpha:1]];
	[askToJoinAllianceButton setMediumLowColor:[UIColor colorWithRed:108.0/255 green:128.0/255 blue:154.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(108, 2)/pow(255,2) green:pow(128, 2)/pow(255,2) blue:pow(154, 2)/pow(255,2) alpha:1]];
    [askToJoinAllianceButton setLowColor:[UIColor colorWithRed:89.0/255 green:112.0/255 blue:142.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(89, 2)/pow(255,2) green:pow(112, 2)/pow(255,2) blue:pow(142, 2)/pow(255,2) alpha:1]];
	[askToJoinAllianceButton setTitle:NSLocalizedStringFromTable(@"alliancesendreq",@"BeintooLocalizable",@"") forState:UIControlStateNormal];
	[askToJoinAllianceButton setButtonTextSize:15];


    allianceNameLabel.font          = [UIFont systemFontOfSize:14];
    allianceMembersLabel.font       = [UIFont systemFontOfSize:14];
    allianceMembersLabel.textColor  = [UIColor colorWithWhite:0 alpha:0.7];
    allianceAdminLabel.font         = [UIFont systemFontOfSize:14];
    allianceAdminLabel.textColor    = [UIColor colorWithWhite:0 alpha:0.7];
    
    allianceImageView.image         = [UIImage imageNamed:@"beintoo_alliance_your.png"];
    allianceImageView.contentMode   = UIViewContentModeCenter;
    
    pendingRequestsVC = [BeintooAlliancePendingVC alloc];
    
}

- (void)viewWillAppear:(BOOL)animated{
    if ([BeintooDevice isiPad]) {
        [self setContentSizeForViewInPopover:CGSizeMake(320, 415)];
    }
    
    _alliance.delegate  = self;
    
    elementsTable.hidden            = NO;
    pendingRequestsButton.hidden    = NO;
    leaveAllianceButton.hidden      = NO;
    askToJoinAllianceButton.hidden  = NO;
    
    if (![Beintoo isUserLogged]){
		[self.navigationController popToRootViewControllerAnimated:NO];
    }
    else{
        if (!self.startingOptions) { // No initial options, this is the case when the user wants to see his current alliance (and of course he has one)
            NSString *userAllianceID = [BeintooAlliance userAllianceID];
            if (userAllianceID) {
                [BLoadingView startActivity:self.view];
                [_alliance getAllianceWithID:userAllianceID];
                askToJoinAllianceButton.hidden  = YES;
                pendingRequestsButton.hidden    = YES;
            }
        }
        else{                       // With options, it means that an user wants to see an alliance from the global list...
            NSString *userAllianceID = [self.startingOptions objectForKey:@"allianceID"];
            if (userAllianceID) {
                [BLoadingView startActivity:self.view];
                [_alliance getAllianceWithID:userAllianceID];
                pendingRequestsButton.hidden    = YES;
                leaveAllianceButton.hidden      = YES;
                
                if ([BeintooAlliance userAllianceID] != nil) {
                    askToJoinAllianceButton.hidden  = YES;
                }
            }
        }
    }
}

#pragma mark -
#pragma mark Alliance Delegates

- (void)didGetAlliance:(NSDictionary *)result{
    [BLoadingView stopActivity];
    
    allianceAdminUserID          = [[[result objectForKey:@"admin"]objectForKey:@"id"] retain];
    allianceId                   = [[result objectForKey:@"id"] retain];
    
    if ([[Beintoo getUserID] isEqualToString:allianceAdminUserID]) {
        pendingRequestsButton.hidden = NO;
    }
    
    allianceNameLabel.text       = [result objectForKey:@"name"];
    allianceMembersLabel.text    = [NSString stringWithFormat:@"%@: %@",NSLocalizedStringFromTable(@"allianceMembers",@"BeintooLocalizable",@""),[result objectForKey:@"members"]];
    allianceAdminLabel.text      = [NSString stringWithFormat:@"%@: %@",NSLocalizedStringFromTable(@"allianceAdmin",@"BeintooLocalizable",@""),[[result objectForKey:@"admin"]objectForKey:@"nickname"]];
    
    [self.elementsArrayList removeAllObjects];    
    if ([[result objectForKey:@"users"] isKindOfClass:[NSArray class]]) {
        self.elementsArrayList = [result objectForKey:@"users"];
    }
    
    [self.elementsTable reloadData];
}

- (void)didAllianceAdminPerformedRequest:(NSDictionary *)result{
    
    [BLoadingView stopActivity];
    
    self.globalResult = result;
    
	NSString *successAlertMessage = NSLocalizedStringFromTable(@"requestSent",@"BeintooLocalizable",@"");

	/*if (requestType == ALLIANCE_REQUEST_JOIN) 
		successAlertMessage = NSLocalizedStringFromTable(@"requestSent",@"BeintooLocalizable",@"");
	else 
		successAlertMessage = NSLocalizedStringFromTable(@"requestSent",@"BeintooLocalizable",@"");*/
	
	NSString *alertMessage;
	if ([[result objectForKey:@"message"] isEqualToString:@"OK"]) 
		alertMessage = successAlertMessage;
	else
		alertMessage = NSLocalizedStringFromTable(@"requestNotSent",@"BeintooLocalizable",@"");
	UIAlertView *av = [[UIAlertView alloc] initWithTitle:nil message:alertMessage delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
	[av show];
	[av release];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex { 
    if (requestType == ALLIANCE_REQUEST_LEAVE && [[self.globalResult objectForKey:@"message"] isEqualToString:@"OK"]) {
        [BeintooAlliance setUserWithAlliance:NO];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - 
#pragma mark IBActions

- (IBAction)leaveAlliance{
    
    UIActionSheet *as = [[UIActionSheet alloc] initWithTitle:NSLocalizedStringFromTable(@"allianceleaveareyousure",@"BeintooLocalizable",@"") delegate:self cancelButtonTitle:@"No" destructiveButtonTitle:@"Yes" otherButtonTitles:nil];
    as.actionSheetStyle = UIActionSheetStyleDefault;
    as.tag = 1;
    [as showInView:[self.view superview]];
    [as release];
}

- (IBAction)joinAlliance{
    UIActionSheet *as = [[UIActionSheet alloc] initWithTitle:NSLocalizedStringFromTable(@"alliancerequestdialog",@"BeintooLocalizable",@"") delegate:self cancelButtonTitle:@"No" destructiveButtonTitle:nil otherButtonTitles:NSLocalizedStringFromTable(@"yes",@"BeintooLocalizable",@""),nil];
    as.actionSheetStyle = UIActionSheetStyleDefault;
    as.tag = 2;
    [as showInView:[self.view superview]];
    [as release];
}

- (IBAction)getPendingRequests{
    
    NSDictionary *pendingOptions = [NSDictionary dictionaryWithObjectsAndKeys:allianceId,@"allianceID",allianceAdminUserID,@"allianceAdminID", nil];
    
    [pendingRequestsVC initWithNibName:@"BeintooAlliancePendingVC" bundle:[NSBundle mainBundle] andOptions:pendingOptions];
    [self.navigationController pushViewController:pendingRequestsVC animated:YES];
}

#pragma mark -
#pragma mark ActionSheet

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (actionSheet.tag == 1) {  // LEAVE
        if (buttonIndex == 0) { 
            requestType = ALLIANCE_REQUEST_LEAVE;
            [BLoadingView startActivity:self.view];
            [_alliance performActionOnAlliance:allianceId withAction:ALLIANCE_ACTION_REMOVE forUser:[Beintoo getUserID]];
        }
        if (buttonIndex == 1) {
            // do nothing, the user picked no -> not leaving alliance
        }
    }
    
    if (actionSheet.tag == 2) {  // ASK TO JOIN
        if (buttonIndex == 0) { 
            requestType = ALLIANCE_REQUEST_JOIN;
            [BLoadingView startActivity:self.view];
            [_alliance sendJoinRequestForUser:[Beintoo getUserID] toAlliance:allianceId];
        }
        if (buttonIndex == 1) {
            // do nothing, the user picked no
        }
    }
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [self.elementsArrayList count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
   	int _gradientType = GRADIENT_CELL_BODY;
	
	BTableViewCell *cell = (BTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil || TRUE) {
        cell = [[[BTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier andGradientType:_gradientType] autorelease];
    }
	
    cell.textLabel.text         = [[self.elementsArrayList objectAtIndex:indexPath.row] objectForKey:@"nickname"];
    cell.textLabel.font         = [UIFont systemFontOfSize:13];
    cell.textLabel.textColor    = [UIColor colorWithWhite:0 alpha:0.7];
    cell.imageView.image        = [UIImage imageNamed:@"beintoo_user_icon.png"];
    cell.imageView.alpha        = 0.4;
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.elementsTable deselectRowAtIndexPath:indexPath animated:YES];
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
	BGradientView *gradientView = [[[BGradientView alloc] initWithGradientType:GRADIENT_HEADER]autorelease];
	gradientView.frame = CGRectMake(0, 0, tableView.bounds.size.width, 35);
    
	UILabel *allianceMembers        = [[UILabel alloc]initWithFrame:CGRectMake(45,7,300,20)];
	allianceMembers.backgroundColor	= [UIColor clearColor];
	allianceMembers.textColor		= [UIColor blackColor];
	allianceMembers.font			= [UIFont boldSystemFontOfSize:13];
	
	allianceMembers.text = NSLocalizedStringFromTable(@"allianceviewmembers",@"BeintooLocalizable",@"");
    
    UIImageView *userImage = [[UIImageView alloc] initWithFrame:CGRectMake(2, 4, 34, 27)];
    userImage.image = [UIImage imageNamed:@"beintoo_user_icon.png"];
    
    [gradientView addSubview:userImage];
    [userImage release];

	[gradientView addSubview:allianceMembers];
	[allianceMembers release];
	
    return gradientView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
	return 35.0;
}


#pragma mark -
#pragma mark BImageDownload Delegate Methods

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return NO;
}

- (void)viewWillDisappear:(BOOL)animated {
    _alliance.delegate  = nil;
    @try {
		[BLoadingView stopActivity];
	}
	@catch (NSException * e) {
	}
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
    [super viewDidUnload];
}

- (void)dealloc {
	[_player release];
    [_alliance release];
    [globalResult release];
	[elementsArrayList release];
    [allianceAdminUserID release];
    [allianceId release];
    [pendingRequestsVC release];
    [super dealloc];
}


@end
