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

#import "BeintooShowChallengeVC.h"
#import "Beintoo.h"

@implementation BeintooShowChallengeVC

@synthesize challengeStatus,myUserExt,toUserExt,userImages;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil andChallengeStatus:(NSDictionary *)status {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
		self.challengeStatus = status;
		
		self.myUserExt = [Beintoo getUserID];
		self.toUserExt = [self.challengeStatus objectForKey:@"userExtFrom"];
		if ([[self.challengeStatus objectForKey:@"userExtFrom"] isEqualToString:self.myUserExt]) {
			self.toUserExt = [self.challengeStatus objectForKey:@"userExtTo"];
		}
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.title = NSLocalizedStringFromTable(@"challenge",@"BeintooLocalizable",@"Challenge");
    table.separatorColor                    = [UIColor clearColor];
    table.backgroundColor                   = [UIColor clearColor];
    table.separatorStyle                    = UITableViewCellSeparatorStyleNone;
    
    //statusLabel.text = NSLocalizedStringFromTable(@"status",@"BeintooLocalizable",@"Status");
	
	// Localized
	//startDateTitle.text = NSLocalizedStringFromTable(@"startDate",@"BeintooLocalizable",@"");
	//endDateTitle.text = NSLocalizedStringFromTable(@"endChallengeDate",@"BeintooLocalizable",@"");
	//priceTitle.text = NSLocalizedStringFromTable(@"costToAccept",@"BeintooLocalizable",@"");
	//prizeTitle.text = NSLocalizedStringFromTable(@"prize",@"BeintooLocalizable",@"");
	//winnerTitle.text = NSLocalizedStringFromTable(@"challengeWinner",@"BeintooLocalizable",@"");
	//prize2Title.text = NSLocalizedStringFromTable(@"prize",@"BeintooLocalizable",@"");
	//prize3Title.text = NSLocalizedStringFromTable(@"prize",@"BeintooLocalizable",@"");
				
	UIBarButtonItem *barCloseBtn = [[UIBarButtonItem alloc] initWithCustomView:[self closeButton]];
	[self.navigationItem setRightBarButtonItem:barCloseBtn animated:YES];
	[barCloseBtn release];		
    
    self.userImages = [[NSMutableArray alloc] init];
	
	user = [[BeintooUser alloc] init];
}

- (void)viewWillAppear:(BOOL)animated{
    [self setContentSizeForViewInPopover:CGSizeMake(320, 415)];
    
    user.delegate = self;
    
    downloadImage1                          = [[[BImageDownload alloc] init] autorelease];
    downloadImage1.delegate                 = self;
    downloadImage1.urlString                = [self.challengeStatus objectForKey:@"imgUrlFrom"];
    
    downloadImage2                          = [[[BImageDownload alloc] init] autorelease];
    downloadImage2.delegate                 = self;
    downloadImage2.urlString                = [self.challengeStatus objectForKey:@"imgUrlTo"];
    
    [self.userImages removeAllObjects];    
    [self.userImages addObject:downloadImage1];
    [self.userImages addObject:downloadImage2];
    
    table.frame = self.view.frame;
    if ( [Beintoo appOrientation] == UIInterfaceOrientationPortrait || [Beintoo appOrientation] == UIInterfaceOrientationPortraitUpsideDown ) {
        table.scrollEnabled = NO;
        table.showsVerticalScrollIndicator = NO;
    }
    else {
        table.scrollEnabled = YES;
        table.showsVerticalScrollIndicator = YES;
    }
    
    [viewBack setTopHeight:0];
	[viewBack setBodyHeight:viewBack.frame.size.height];

    [table reloadData];
}

- (IBAction)acceptChallenge{
    [BLoadingView startActivity:self.view];
	[user challengeRequestfrom:self.myUserExt to:self.toUserExt withAction:@"ACCEPT" forContest:[self.challengeStatus objectForKey:@"contestCodeID"] withBedollarsToBet:nil andScoreToReach:nil forKindOfChallenge:nil andActor:nil];
}
- (IBAction)refuseChallenge{
    [BLoadingView startActivity:self.view];
	[user challengeRequestfrom:self.myUserExt to:self.toUserExt withAction:@"REFUSE" forContest:[self.challengeStatus objectForKey:@"contestCodeID"] withBedollarsToBet:nil andScoreToReach:nil forKindOfChallenge:nil andActor:nil];
}

// Delegate response
- (void)challengeRequestFinishedWithResult:(NSDictionary *)result{
    [BLoadingView stopActivity];
	if ([result objectForKey:@"messageID"]!=nil) {
        
		if ([[result objectForKey:@"messageID"] intValue] == -15) {
			UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Beintoo" message:NSLocalizedStringFromTable(@"challengeOngoing",@"BeintooLocalizable",@"")
														delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
			[av show];
			[av release];
			return;
		}
		UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Beintoo" message:NSLocalizedStringFromTable(@"errorMessage",@"BeintooLocalizable",@"")
													delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
		[av show];
		[av release];
		return;
		
	}
	if ([[result objectForKey:@"status"] isEqualToString:@"STARTED"]) {
		UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Beintoo" message:NSLocalizedStringFromTable(@"challengeAccepted",@"BeintooLocalizable",@"")
													delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
		[av show];
		[av release];
		[self.navigationController popViewControllerAnimated:YES];
	} else{
		UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Beintoo" message:NSLocalizedStringFromTable(@"challengeRefused",@"BeintooLocalizable",@"")
													delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
		[av show];
		[av release];
		[self.navigationController popViewControllerAnimated:YES];
	}
}

- (NSString *)translateStatusCode:(NSString *)code{
	if ([code isEqualToString:@"TO_BE_ACCEPTED"]) {
		return NSLocalizedStringFromTable(@"pending",@"BeintooLocalizable",@"Pending");
	}else if ([code isEqualToString:@"STARTED"]) {
		return NSLocalizedStringFromTable(@"ongoing",@"BeintooLocalizable",@"Ongoing");
	}else if ([code isEqualToString:@"ENDED"]) {
		return NSLocalizedStringFromTable(@"end",@"BeintooLocalizable",@"End");
	}else {
		return @"";
	}	
}

#pragma mark - UITableview methods

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 0){
        return 95;
    } 
    else if (indexPath.row == 1 || indexPath.row == 3 || indexPath.row == 4){
        return 65;
    }
    else {
        return 130;
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if ([[challengeStatus objectForKey:@"status"] isEqualToString:@"TO_BE_ACCEPTED"] == NO){
        return 4;
    }
    else {
        return 5;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *CellIdentifier = @"Cell";
    int _gradientType = GRADIENT_CELL_GRAY;
    if (indexPath.row == 0 || indexPath.row == 2 || indexPath.row == 4){
        _gradientType = GRADIENT_CELL_HEAD;
	}
    
	BTableViewCell *cell = (BTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil || TRUE) {
        cell = [[[BTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier andGradientType:_gradientType] autorelease];
    }   
    
    if (indexPath.row == 0){
                
        UILabel *challengeTitle         = [[UILabel alloc] initWithFrame:CGRectMake(20, 9, table.frame.size.width-40, 25)];
        challengeTitle.backgroundColor  = [UIColor clearColor];
        challengeTitle.textColor        = [UIColor blackColor];
        challengeTitle.font             = [UIFont systemFontOfSize:18];
        
        
        UILabel *challengeDescription        = [[UILabel alloc] initWithFrame:CGRectMake(20, 26, table.frame.size.width-40, 60)];
        challengeDescription.backgroundColor = [UIColor clearColor];
        challengeDescription.textColor       = [UIColor colorWithWhite:0 alpha:0.7];
        challengeDescription.font            = [UIFont systemFontOfSize:13];
        
        challengeDescription.numberOfLines   = 0;
        
        if ([[challengeStatus objectForKey:@"type"] isEqualToString:@"CHALLENGE"] == YES) {
            challengeTitle.text = NSLocalizedStringFromTable(@"chall48title", @"BeintooLocalizable", nil);
            challengeDescription.text            = NSLocalizedStringFromTable(@"chall48", @"BeintooLocalizable", nil);
        }
        else {
            if ([[challengeStatus objectForKey:@"actorId"] isEqualToString:[challengeStatus objectForKey:@"userExtFrom"]] == YES) {
                challengeTitle.text = NSLocalizedStringFromTable(@"challmevsyoutitle", @"BeintooLocalizable", nil);
                challengeDescription.text            = NSLocalizedStringFromTable(@"challmevsyou", @"BeintooLocalizable", nil);
            }
            else {
                challengeTitle.text = NSLocalizedStringFromTable(@"challFriendstitle", @"BeintooLocalizable", nil);
                challengeDescription.text            = NSLocalizedStringFromTable(@"challFriends", @"BeintooLocalizable", nil);
            }
        }
        
        [cell addSubview:challengeTitle];
        [cell addSubview:challengeDescription];
        
        [challengeTitle release];
        [challengeDescription release];
    }
    
    else if (indexPath.row == 1 || indexPath.row == 3){
        
        UIImageView *userImage      = [[UIImageView alloc] initWithFrame:CGRectMake(20, 8, 50, 50)];
        userImage.contentMode       = UIViewContentModeScaleAspectFit;
        
        UILabel *nomeUtente         = [[UILabel alloc] initWithFrame:CGRectMake(95, 15, 200, 20)];
        nomeUtente.font             = [UIFont systemFontOfSize:15];
        nomeUtente.backgroundColor  = [UIColor clearColor];
        
        if ([[challengeStatus objectForKey:@"status"] isEqualToString:@"TO_BE_ACCEPTED"] == NO) {
            
            UILabel *descrizioneUtente          = [[UILabel alloc] initWithFrame:CGRectMake(100, 20, 200, 40)];
            descrizioneUtente.font              = [UIFont systemFontOfSize:11];
            descrizioneUtente.textColor         = [UIColor colorWithWhite:0 alpha:0.8];
            descrizioneUtente.backgroundColor   = [UIColor clearColor];
            
            if (indexPath.row == 1){
                descrizioneUtente.text = [NSString stringWithFormat:@"%@: %@",NSLocalizedStringFromTable(@"points",@"BeintooLocalizable",@""), [self.challengeStatus objectForKey:@"playerFromScore"]];
            }
            else if (indexPath.row == 3){
                descrizioneUtente.text = [NSString stringWithFormat:@"%@: %@",NSLocalizedStringFromTable(@"points",@"BeintooLocalizable",@""), [self.challengeStatus objectForKey:@"playerToScore"]];
            }
            
            [cell addSubview:descrizioneUtente];
            [descrizioneUtente release];
        }
        
        if (indexPath.row == 1){
            nomeUtente.text             = [self.challengeStatus objectForKey:@"playerFrom"];
            BImageDownload *download    = [self.userImages objectAtIndex:0];
            userImage.image             = download.image;
        }
        else if (indexPath.row == 3){
            nomeUtente.text = [self.challengeStatus objectForKey:@"playerTo"];
            BImageDownload *download    = [self.userImages objectAtIndex:1];
            userImage.image             = download.image;
        }
        
        [cell addSubview:userImage];
        [cell addSubview:nomeUtente];
        
        [userImage release];
        [nomeUtente release];        
    }
    else if (indexPath.row == 2) {  
        
        //Challenge image drawing
        UIImage *imageVert              = [UIImage imageNamed:@"beintoo_challenges_vert.png"];
        UIImageView *challengesImg      = [[UIImageView alloc] initWithFrame:CGRectMake(22, 15, imageVert.size.width, imageVert.size.height)];
        challengesImg.image             = imageVert;
        UILabel *imageTypeLabel         = [[UILabel alloc] initWithFrame:CGRectMake(challengesImg.frame.origin.x + 1, 47, imageVert.size.width, 30)];
        imageTypeLabel.textColor        = [UIColor whiteColor];
        imageTypeLabel.backgroundColor  = [UIColor clearColor];
        imageTypeLabel.font             = [UIFont systemFontOfSize:15]; 
        imageTypeLabel.textAlignment    = UITextAlignmentCenter;
        
        if ([[challengeStatus objectForKey:@"type"] isEqualToString:@"CHALLENGE"] == YES) {
            imageTypeLabel.text = @"48h";
        }
        else {
            if ([[challengeStatus objectForKey:@"actorId"] isEqualToString:[challengeStatus objectForKey:@"userExtFrom"]] == YES) {
                imageTypeLabel.text = @"VS";
            }
            else {
                imageTypeLabel.text = @"ON";
            }
        }
        
        int h = 7;
        
        if ([[challengeStatus objectForKey:@"type"] isEqualToString:@"CHALLENGE"] == NO){
            showTargetScore = YES;
        }
        else {
            showTargetScore = NO;
            h = h + 10;
        }
        
        if ([[challengeStatus objectForKey:@"status"] isEqualToString:@"TO_BE_ACCEPTED"] == NO){
            showStartEndDate = YES;
            
        }
        else {
            showStartEndDate = NO;
            h = h + 20;
        }
        
        
        //Challenge labels drawing
        UILabel *contestNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(90, h, 200, 20)];
        contestNameLabel.text = [NSString stringWithFormat:@"App: %@", [challengeStatus objectForKey:@"contestName"]];
        contestNameLabel.backgroundColor = [UIColor clearColor];
        contestNameLabel.font = [UIFont systemFontOfSize:13];
        
        UILabel *contestStatusLabel = [[UILabel alloc] initWithFrame:CGRectMake(90, h+18, 200, 20)];
        contestStatusLabel.text = [NSString stringWithFormat:@"%@ %@", NSLocalizedStringFromTable(@"status", @"BeintooLocalizable", nil), [NSString stringWithFormat: NSLocalizedStringFromTable([[[challengeStatus objectForKey:@"status"] stringByReplacingOccurrencesOfString:@"_" withString:@" "] lowercaseString], @"BeintooLocalizable", nil)]];
        contestStatusLabel.backgroundColor = [UIColor clearColor];
        contestStatusLabel.font = [UIFont systemFontOfSize:13];
        
        UILabel *prizeLabel = [[UILabel alloc] initWithFrame:CGRectMake(90, h+36, 200, 20)];
        prizeLabel.text = [NSString stringWithFormat:@"%@ %@ %@", NSLocalizedStringFromTable(@"prize", @"BeintooLocalizable", nil), [challengeStatus objectForKey:@"prize"], NSLocalizedStringFromTable(@"bedollars", @"BeintooLocalizable", nil)];
        prizeLabel.font = [UIFont systemFontOfSize:13];
        prizeLabel.backgroundColor = [UIColor clearColor];
        
        h = h + 54;
        if (showTargetScore == YES){
            UILabel *targetScoreLabel           = [[UILabel alloc] initWithFrame:CGRectMake(90, h, 200, 20)];
            targetScoreLabel.text               = [NSString stringWithFormat:@"%@: %@", NSLocalizedStringFromTable(@"challPointsTarget", @"BeintooLocalizable", nil),  [challengeStatus objectForKey:@"targetScore"]];
            targetScoreLabel.backgroundColor    = [UIColor clearColor];
            targetScoreLabel.font = [UIFont systemFontOfSize:13];
            targetScoreLabel.backgroundColor    = [UIColor clearColor];
            
            [cell addSubview:targetScoreLabel];
            [targetScoreLabel release];
            h = h + 18;
        }
        
        if (showStartEndDate == YES){
            UILabel *startDateLabel = [[UILabel alloc] initWithFrame:CGRectMake(90, h, 200, 18)];
            startDateLabel.text = [NSString stringWithFormat:@"%@ %@", NSLocalizedStringFromTable(@"startDate",@"BeintooLocalizable",@""),[BeintooNetwork convertToCurrentDate:[challengeStatus objectForKey:@"startDate"]]];
            startDateLabel.backgroundColor = [UIColor clearColor];
            startDateLabel.font = [UIFont systemFontOfSize:13];
            startDateLabel.textColor = [UIColor colorWithWhite:0 alpha:1];
            
            
            UILabel *endDateLabel = [[UILabel alloc] initWithFrame:CGRectMake(90    , h+18, 200, 18)];
            endDateLabel.text = [NSString stringWithFormat:@"%@ %@",NSLocalizedStringFromTable(@"endDate",@"BeintooLocalizable",@""), [BeintooNetwork convertToCurrentDate:[challengeStatus objectForKey:@"endDate"]]];
            endDateLabel.backgroundColor = [UIColor clearColor];
            endDateLabel.font = [UIFont systemFontOfSize:13];
            endDateLabel.textColor = [UIColor colorWithWhite:0 alpha:1];
            
            [cell addSubview:startDateLabel];
            [cell addSubview:endDateLabel];
            
            [startDateLabel release];
            [endDateLabel release];
        }
        
        
        [cell addSubview:challengesImg];
        [cell addSubview:contestNameLabel];
        [cell addSubview:contestStatusLabel];
        [cell addSubview:prizeLabel];
        [cell addSubview:imageTypeLabel];
                
        [challengesImg release];
        [contestNameLabel release];
        [contestStatusLabel release];
        [prizeLabel release];
        [imageTypeLabel release];
        
    }
    
    else if (indexPath.row == 4) {
        
        BButton *refuseBtn = [[BButton alloc] initWithFrame:CGRectMake(20, 12.5, 130, 35)];
        [refuseBtn setHighColor:[UIColor colorWithRed:156.0/255 green:168.0/255 blue:184.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(156, 2)/pow(255,2) green:pow(168, 2)/pow(255,2) blue:pow(184, 2)/pow(255,2) alpha:1]];
        [refuseBtn setMediumHighColor:[UIColor colorWithRed:116.0/255 green:135.0/255 blue:159.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(116, 2)/pow(255,2) green:pow(135, 2)/pow(255,2) blue:pow(159, 2)/pow(255,2) alpha:1]];
        [refuseBtn setMediumLowColor:[UIColor colorWithRed:108.0/255 green:128.0/255 blue:154.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(108, 2)/pow(255,2) green:pow(128, 2)/pow(255,2) blue:pow(154, 2)/pow(255,2) alpha:1]];
        [refuseBtn setLowColor:[UIColor colorWithRed:89.0/255 green:112.0/255 blue:142.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(89, 2)/pow(255,2) green:pow(112, 2)/pow(255,2) blue:pow(142, 2)/pow(255,2) alpha:1]];
        [refuseBtn setTitle:NSLocalizedStringFromTable(@"refuseBtn",@"BeintooLocalizable",@"Refuse") forState:UIControlStateNormal];
        [refuseBtn addTarget:self action:@selector(refuseChallenge) forControlEvents:UIControlEventTouchUpInside];
        [refuseBtn setButtonTextSize:15];
        
        
        BButton *acceptBtn = [[BButton alloc] initWithFrame:CGRectMake(170, 12.5, 130, 35)];
        [acceptBtn setHighColor:[UIColor colorWithRed:156.0/255 green:168.0/255 blue:184.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(156, 2)/pow(255,2) green:pow(168, 2)/pow(255,2) blue:pow(184, 2)/pow(255,2) alpha:1]];
        [acceptBtn setMediumHighColor:[UIColor colorWithRed:116.0/255 green:135.0/255 blue:159.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(116, 2)/pow(255,2) green:pow(135, 2)/pow(255,2) blue:pow(159, 2)/pow(255,2) alpha:1]];
        [acceptBtn setMediumLowColor:[UIColor colorWithRed:108.0/255 green:128.0/255 blue:154.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(108, 2)/pow(255,2) green:pow(128, 2)/pow(255,2) blue:pow(154, 2)/pow(255,2) alpha:1]];
        [acceptBtn setLowColor:[UIColor colorWithRed:89.0/255 green:112.0/255 blue:142.0/255 alpha:1.0] andRollover:[UIColor colorWithRed:pow(89, 2)/pow(255,2) green:pow(112, 2)/pow(255,2) blue:pow(142, 2)/pow(255,2) alpha:1]];
        [acceptBtn setTitle:NSLocalizedStringFromTable(@"acceptBtn",@"BeintooLocalizable",@"Refuse") forState:UIControlStateNormal];
        [acceptBtn addTarget:self action:@selector(acceptChallenge) forControlEvents:UIControlEventTouchUpInside];
        [acceptBtn setButtonTextSize:15];
        
        [cell addSubview:acceptBtn];
        [cell addSubview:refuseBtn];
        
        [acceptBtn release];
        [refuseBtn release];
        
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;    
}

#pragma mark - ImageDownload Delegate
- (void)bImageDownloadDidFinishDownloading:(BImageDownload *)download{
    NSUInteger index = [self.userImages indexOfObject:download]; 
    int rowToReload = (index == 0) ? 1 : 3;
    
    NSUInteger indices[] = {0, rowToReload};
    NSIndexPath *path = [[NSIndexPath alloc] initWithIndexes:indices length:2];
    [table reloadRowsAtIndexPaths:[NSArray arrayWithObject:path] withRowAnimation:UITableViewRowAnimationNone];
    [path release];
    download.delegate = nil;
}
- (void)bImageDownload:(BImageDownload *)download didFailWithError:(NSError *)error{
    BeintooLOG(@"Beintoo - Image Loading Error: %@", [error localizedDescription]);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return NO;
}


- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    user.delegate = nil;
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

- (void)dealloc {
    [self.userImages release];
	[user release];
    [super dealloc];
}

@end
