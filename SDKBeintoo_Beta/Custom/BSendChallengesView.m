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

#import "BSendChallengesView.h"
#import <QuartzCore/QuartzCore.h>
#import "Beintoo.h"
#import "BSendChallengeDetailsView.h"


@implementation BSendChallengesView

@synthesize challengeSender, challengeReceiver;

-(id)init {
	if (self = [super init]){        
		
	}
    return self;
}

- (void)drawSendChallengeView{
    
    elementsArrayList = [[NSMutableArray alloc] init];
    
    [self initTableArrayElements];
    
    UIView  *shadowView                 = [[UIView alloc] initWithFrame:self.bounds];
    shadowView.backgroundColor          = [UIColor colorWithWhite:0 alpha:0.6];
        
    UITableView *elementsTable          = [[BTableView alloc] initWithFrame:CGRectMake(5, 5, self.frame.size.width - 10, self.frame.size.height - 15) style:UITableViewStylePlain];
    
    if ([BeintooDevice isiPad])
         elementsTable.frame          = CGRectMake(5, 5, self.frame.size.width - 10, self.frame.size.height - 15);
    else 
        elementsTable.frame          = CGRectMake(5, 5, self.frame.size.width - 10, self.frame.size.height - 35);
            
    elementsTable.separatorColor        = [UIColor clearColor];
    elementsTable.backgroundColor       = [UIColor clearColor];
    elementsTable.separatorStyle        = UITableViewCellSeparatorStyleNone;
	elementsTable.delegate              = self;
	elementsTable.dataSource            = self;
	elementsTable.rowHeight             = 122.0;
    elementsTable.bounces               = NO;
    
    elementsTable.layer.borderColor     = [UIColor lightGrayColor].CGColor;
    elementsTable.layer.cornerRadius    = 3.0;
    elementsTable.layer.borderWidth     = 1.0;
    
    
    [shadowView addSubview:elementsTable];
    [elementsTable release];

    [self addSubview:shadowView];
    [shadowView release];
    
}

#pragma mark - TableView Data Source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [elementsArrayList count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
   	int _gradientType = GRADIENT_CELL_GRAY;
	
	BTableViewCell *cell = (BTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil || TRUE) {
        cell = [[[BTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier andGradientType:_gradientType] autorelease];
    }
	
    
    UILabel *titleLabel         = [[UILabel alloc] initWithFrame:CGRectMake(12, 30, 190, 20)];
    titleLabel.backgroundColor  = [UIColor clearColor];
    titleLabel.font             = [UIFont boldSystemFontOfSize:15];
    titleLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    titleLabel.textColor        = [UIColor colorWithWhite:0 alpha:1];
    titleLabel.text             = [[elementsArrayList objectAtIndex:indexPath.row] objectForKey:@"title"];
    titleLabel.adjustsFontSizeToFitWidth = YES;
    
    [cell addSubview:titleLabel];
    [titleLabel release];
    
    UILabel *descr1Label         = [[UILabel alloc] initWithFrame:CGRectMake(12, 50, 190, 50)];
    descr1Label.backgroundColor  = [UIColor clearColor];
    descr1Label.font             = [UIFont systemFontOfSize:13];
    descr1Label.numberOfLines    = 3;
    descr1Label.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    descr1Label.textColor        = [UIColor colorWithWhite:0 alpha:1];
    descr1Label.text             = [[elementsArrayList objectAtIndex:indexPath.row] objectForKey:@"desc1"];
    descr1Label.adjustsFontSizeToFitWidth = YES;
    
    [cell addSubview:descr1Label];
    [descr1Label release];
    
    UIImageView *cellImage       = [[UIImageView alloc] initWithFrame:CGRectMake(self.frame.size.width-130, 15, 110, 93)];
    cellImage.autoresizingMask   = UIViewAutoresizingFlexibleRightMargin;
    cellImage.image              = [UIImage imageNamed:[[elementsArrayList objectAtIndex:indexPath.row] objectForKey:@"cellImage"]];
    cellImage.contentMode           = UIViewContentModeScaleAspectFit;
    
    [cell addSubview:cellImage];
    [cellImage release];
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    switch (indexPath.row) {
        case 0:{ // BET -> actor = utente selezionato dalla leaderboard

            BSendChallengeDetailsView       *sendChallengeDetailsView = [[BSendChallengeDetailsView alloc] initWithFrame:self.frame];
            sendChallengeDetailsView.challengeReceiver     = challengeReceiver;
            sendChallengeDetailsView.challengeSender       = challengeSender;
            sendChallengeDetailsView.challengeType         = SENDCHALLENGE_TYPE_BET_OTHER;
            
            [sendChallengeDetailsView drawSendChallengeView];
            sendChallengeDetailsView.tag = BSENDCHALLENGEDETAILS_VIEW_TAG;
            sendChallengeDetailsView.alpha = 0;
            [self addSubview:sendChallengeDetailsView];
            [sendChallengeDetailsView release];
            
            [UIView beginAnimations:@"sendChallengeDetailsOpen" context:nil];
            [UIView setAnimationDelay:0];
            [UIView setAnimationDuration:0.3];
            sendChallengeDetailsView.alpha = 1;
            [UIView commitAnimations];
            
            

        }
            break;

        case 1:{ // BET -> actor = utente corrente
            BSendChallengeDetailsView       *sendChallengeDetailsView = [[BSendChallengeDetailsView alloc] initWithFrame:self.frame];
            sendChallengeDetailsView.challengeReceiver     = self.challengeReceiver;
            sendChallengeDetailsView.challengeSender       = self.challengeSender;
            sendChallengeDetailsView.challengeType         = SENDCHALLENGE_TYPE_BET_ME;
            
            [sendChallengeDetailsView drawSendChallengeView];
            sendChallengeDetailsView.tag = BSENDCHALLENGEDETAILS_VIEW_TAG;
            sendChallengeDetailsView.alpha = 0;
            [self addSubview:sendChallengeDetailsView];
            [sendChallengeDetailsView release];
            
            [UIView beginAnimations:@"sendChallengeDetailsOpen" context:nil];
            [UIView setAnimationDelay:0];
            [UIView setAnimationDuration:0.3];
            sendChallengeDetailsView.alpha = 1;
            [UIView commitAnimations];
            
            
            break;
        }
        case 2:{ // CHALLENGE -> actor = nil
            BSendChallengeDetailsView       *sendChallengeDetailsView = [[BSendChallengeDetailsView alloc] initWithFrame:self.frame];
            
            sendChallengeDetailsView.challengeReceiver     = self.challengeReceiver;
            sendChallengeDetailsView.challengeSender       = self.challengeSender;
            sendChallengeDetailsView.challengeType         = SENDCHALLENGE_TYPE_TIME;
            
            [sendChallengeDetailsView drawSendChallengeView];
            sendChallengeDetailsView.tag = BSENDCHALLENGEDETAILS_VIEW_TAG;
            sendChallengeDetailsView.alpha = 0;
            [self addSubview:sendChallengeDetailsView];
            [sendChallengeDetailsView release];
            
            [UIView beginAnimations:@"sendChallengeDetailsOpen" context:nil];
            [UIView setAnimationDelay:0];
            [UIView setAnimationDuration:0.3];
            sendChallengeDetailsView.alpha = 1;
            [UIView commitAnimations];

            
            break;
        }
        default:
            break;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
	return 35.0;
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
	BGradientView *gradientView = [[[BGradientView alloc] initWithGradientType:GRADIENT_HEADER]autorelease];
	gradientView.frame = CGRectMake(0, 0, tableView.bounds.size.width, 30);
    
    UILabel *contestNameLbl			= [[UILabel alloc]initWithFrame:CGRectMake(10,7,300,20)];
	contestNameLbl.backgroundColor	= [UIColor clearColor];
	contestNameLbl.textColor		= [UIColor blackColor];
	contestNameLbl.font				= [UIFont boldSystemFontOfSize:15];
    contestNameLbl.text             = NSLocalizedStringFromTable(@"leadSendChall", @"BeintooLocalizable", @"");
	
    [gradientView addSubview:contestNameLbl];
	
    [contestNameLbl release];
    
    /* ----------- CLOSE BUTTON OVER HEADER SECTION ------------- */
    
    int closeBtnOffset      = 33;
    UIImage* closeBtnImg    = [UIImage imageNamed:@"popupCloseBtn.png"];
    UIButton* closeBtn      = [UIButton buttonWithType:UIButtonTypeCustom];
    closeBtn.alpha          = 0.8;
    [closeBtn setImage:closeBtnImg forState:UIControlStateNormal];
    [closeBtn setFrame:CGRectMake(gradientView.frame.size.width - closeBtnOffset, 3, 30, 30)];
	
    [closeBtn addTarget:self action:@selector(closeMainView) forControlEvents:UIControlEventTouchUpInside];
    [gradientView addSubview: closeBtn];
    [gradientView bringSubviewToFront:closeBtn];
    /* ----------------------------------------------------------- */
	return gradientView;
}

- (void)initTableArrayElements{
    [elementsArrayList removeAllObjects];
    
    NSDictionary *meVsYouDict       = [NSDictionary dictionaryWithObjectsAndKeys:
                                       NSLocalizedStringFromTable(@"challmevsyoutitle",@"BeintooLocalizable",@""),@"title",
                                       NSLocalizedStringFromTable(@"challmevsyou",@"BeintooLocalizable",@""), @"desc1",
                                       @"0",@"cellTag",
                                       @"beintoo_challenges_vs.png",@"cellImage",nil];
    
    NSDictionary *friendsChallDict  = [NSDictionary dictionaryWithObjectsAndKeys:
                                       NSLocalizedStringFromTable(@"challFriendstitle",@"BeintooLocalizable",@""),@"title",
                                       NSLocalizedStringFromTable(@"challFriends",@"BeintooLocalizable",@""), @"desc1",
                                       @"1",@"cellTag",
                                       @"beintoo_challenges_on.png",@"cellImage",nil];
    
    NSDictionary *challenge24Dict   = [NSDictionary dictionaryWithObjectsAndKeys:
                                       NSLocalizedStringFromTable(@"chall48title",@"BeintooLocalizable",@""),@"title",
                                       NSLocalizedStringFromTable(@"chall48",@"BeintooLocalizable",@""), @"desc1",
                                       @"2",@"cellTag",
                                       @"beintoo_challenges_24.png",@"cellImage",nil];
    
	
    [elementsArrayList addObject:meVsYouDict];
    [elementsArrayList addObject:friendsChallDict];
    [elementsArrayList addObject:challenge24Dict];
    
    
}

#pragma mark - ViewActions
- (void)closeMainView{
    self.alpha = 0;
	//[self removeViews];
    [[self viewWithTag:BSENDCHALLENGEDETAILS_VIEW_TAG] removeFromSuperview];
	[self removeFromSuperview];
}

- (void)removeViews {
	for (UIView *subview in [self subviews]) {
		[subview removeFromSuperview];
	}
}

- (void)dealloc {
    [elementsArrayList release];
    [super dealloc];
}


@end

