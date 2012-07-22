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

#import "BeintooAllianceActionsVC.h"
#import "Beintoo.h"

@implementation BeintooAllianceActionsVC

@synthesize elementsTable, elementsArrayList, selectedElement, startingOptions;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil andOptions:(NSDictionary *)options{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
		self.startingOptions	= options;
	}
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.title		= NSLocalizedStringFromTable(@"alliances",@"BeintooLocalizable",@"");
	
	[alliancesActionView setTopHeight:20];
	[alliancesActionView setBodyHeight:457];
	
	elementsArrayList   = [[NSMutableArray alloc] init];
	_player				= [[BeintooPlayer alloc] init];
		
	UIBarButtonItem *barCloseBtn = [[UIBarButtonItem alloc] initWithCustomView:[BeintooVC closeButton]];
	[self.navigationItem setRightBarButtonItem:barCloseBtn animated:YES];
	[barCloseBtn release];
		
	self.elementsTable.delegate		= self;
	self.elementsTable.rowHeight	= 85.0;	
    
    UILabel *allianceTipsLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 200, 300, 70)];
    allianceTipsLabel.text              = NSLocalizedStringFromTable(@"alliancemaintextfooter",@"BeintooLocalizable",@"");
    allianceTipsLabel.autoresizingMask  = UIViewAutoresizingFlexibleWidth;
    allianceTipsLabel.textAlignment     = UITextAlignmentCenter;
    allianceTipsLabel.textColor         = [UIColor colorWithWhite:0 alpha:0.7]; 
    allianceTipsLabel.font              = [UIFont systemFontOfSize:13];
    allianceTipsLabel.backgroundColor   = [UIColor clearColor];
    allianceTipsLabel.numberOfLines     = 3;
    
    [self.view addSubview:allianceTipsLabel];
    [self.view sendSubviewToBack:allianceTipsLabel];
    [allianceTipsLabel release];
    
    viewAllianceVC = [[BeintooViewAllianceVC alloc] initWithNibName:@"BeintooViewAllianceVC" bundle:[NSBundle mainBundle] andOptions:nil];
    allianceListVC = [[BeintooAlliancesListVC alloc] initWithNibName:@"BeintooAlliancesListVC" bundle:[NSBundle mainBundle] andOptions:nil];
    
    allianceCreateVC = [[BeintooCreateAllianceVC alloc] initWithNibName:@"BeintooCreateAllianceVC" bundle:[NSBundle mainBundle] andOptions:nil];
}

- (void)viewWillAppear:(BOOL)animated{
    if ([BeintooDevice isiPad]) {
        [self setContentSizeForViewInPopover:CGSizeMake(320, 415)];
    }

    _player.delegate    = self;

	if (![Beintoo isUserLogged]){
		[self.navigationController popToRootViewControllerAnimated:NO];
    }
    else{
        [BLoadingView startActivity:self.view];
        [_player getPlayerByGUID:[Beintoo getPlayerID]];
    }
    
    self.elementsArrayList = [NSArray arrayWithObjects:@"alliance_create",@"alliance_list",nil];	
    if([BeintooAlliance userHasAlliance]){	
        self.elementsArrayList = [NSArray arrayWithObjects:@"alliance_your",@"alliance_list", nil];	
    }
}

- (void)player:(BeintooPlayer *)player getPlayerByGUID:(NSDictionary *)result{
    
    if ([result objectForKey:@"user"]!=nil){
        [Beintoo setBeintooPlayer:result];
    }
    
    // Alliance check
    if ([result objectForKey:@"alliance"] != nil) {
        [BeintooAlliance setUserWithAlliance:YES];
    }else{
        [BeintooAlliance setUserWithAlliance:NO];
    }
    
    self.elementsArrayList = [NSArray arrayWithObjects:@"alliance_create",@"alliance_list",nil];
    
    if([BeintooAlliance userHasAlliance]){
        self.elementsArrayList = [NSArray arrayWithObjects:@"alliance_your",@"alliance_list", nil];
    }
    
    [BLoadingView stopActivity];
    [self.elementsTable reloadData];

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
   	int _gradientType = (indexPath.row % 2) ? GRADIENT_CELL_HEAD : GRADIENT_CELL_BODY;
	
	BTableViewCell *cell = (BTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil || TRUE) {
        cell = [[[BTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier andGradientType:_gradientType] autorelease];
    }
	
	NSString *choicheCode			= [self.elementsArrayList objectAtIndex:indexPath.row];
	NSString *choicheDesc			= [NSString stringWithFormat:@"%@Desc",choicheCode];
	cell.textLabel.text				= NSLocalizedStringFromTable(choicheCode,@"BeintooLocalizable",@"Select A Friend");
	cell.textLabel.font				= [UIFont systemFontOfSize:16];
	cell.detailTextLabel.text		= NSLocalizedStringFromTable(choicheDesc,@"BeintooLocalizable",@"");;
	cell.detailTextLabel.font		= [UIFont systemFontOfSize:14];

	cell.imageView.image	= [UIImage imageNamed:[NSString stringWithFormat:@"beintoo_%@.png",choicheCode]];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	NSString *selectedElem = [self.elementsArrayList objectAtIndex:indexPath.row];
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	
	if (indexPath.row == 0) {
        if ([selectedElem isEqualToString:@"alliance_your"]) {
            [self.navigationController pushViewController:viewAllianceVC animated:YES];
        }
        if ([selectedElem isEqualToString:@"alliance_create"]) {
            [self.navigationController pushViewController:allianceCreateVC animated:YES];
        }
	}
	else if (indexPath.row == 1) {
        [self.navigationController pushViewController:allianceListVC animated:YES];

    }
	else if	(indexPath.row == 2){
	
    }
	else if (indexPath.row == 3){
	
    }
}

#pragma mark -
#pragma mark BImageDownload Delegate Methods

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewWillDisappear:(BOOL)animated {
    _player.delegate    = nil;
    
    @try {
        [BLoadingView stopActivity];
    }
    @catch (NSException * e) {
    }  
}

- (void)viewDidUnload {
    [super viewDidUnload];
}

- (void)dealloc {
	[_player release];
	[elementsArrayList release];
    [viewAllianceVC release];
    [super dealloc];
}


@end
