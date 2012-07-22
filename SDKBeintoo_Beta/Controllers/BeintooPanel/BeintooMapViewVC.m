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

#import "BeintooMapViewVC.h"
#import "BPinAnnotation.h"

@implementation BeintooMapViewVC

@synthesize selectedVgood, mapImage;

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
    [latitudeArray release];
    [longitudeArray release];
    [distancesArray release];
    [detailsView release];
    [nameLabel release];
    [addressLabel release];
    
    [super dealloc];
}


#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title   = @"Marketplace";
    
    if ([BeintooDevice isiPad]) {
        [self setContentSizeForViewInPopover:CGSizeMake(320, 415)];
    }
    
    latitudeArray               =   [[NSMutableArray alloc] init];
    longitudeArray              =   [[NSMutableArray alloc] init];
    distancesArray              =   [[NSMutableArray alloc] init];
    
    [mapView setTopHeight:10.0f];
    [mapView setBodyHeight:self.view.frame.size.height - 20];
    
    //------> Detail View and subLabels
    detailsView                 = [[BView alloc] initWithFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.size.height, self.view.frame.size.width, 80)];
    
    if ([Beintoo appOrientation] == UIInterfaceOrientationLandscapeRight || [Beintoo appOrientation] == UIInterfaceOrientationLandscapeLeft)
        detailsView.frame      = CGRectMake(detailsView.frame.origin.x, detailsView.frame.origin.y, 480, detailsView.frame.size.height);
    else 
        detailsView.frame      = CGRectMake(detailsView.frame.origin.x, detailsView.frame.origin.y, 320, detailsView.frame.size.height);
    
    [detailsView setTopHeight:20.0f];
    [detailsView setBodyHeight:55.0f];
    detailsView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleRightMargin;
    
    nameLabel                   = [[UILabel alloc] initWithFrame:CGRectMake(10, 25, self.view.frame.size.width, 20)];
    nameLabel.backgroundColor   = [UIColor clearColor];
    nameLabel.textAlignment     = UITextAlignmentLeft;
    nameLabel.font              = [UIFont systemFontOfSize:14];
    nameLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth  | UIViewAutoresizingFlexibleRightMargin; 
    
    [detailsView addSubview:nameLabel];
    
    addressLabel                = [[UILabel alloc] initWithFrame:CGRectMake(10, 45, self.view.frame.size.width, 18)];
    addressLabel.backgroundColor = [UIColor clearColor];
    addressLabel.textAlignment  = UITextAlignmentLeft;
    addressLabel.font           = [UIFont systemFontOfSize:12];
    addressLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth  | UIViewAutoresizingFlexibleRightMargin;
    [detailsView addSubview:addressLabel];

    //------> Nav Controller Close Button
    UIBarButtonItem *barCloseBtn = [[UIBarButtonItem alloc] initWithCustomView:[BeintooMarketplaceVC closeButton]];
	[self.navigationItem setRightBarButtonItem:barCloseBtn animated:YES];
	[barCloseBtn release];
    [self.view addSubview:detailsView];
    
    BButton *closeButton = [[BButton alloc] initWithFrame:CGRectMake(detailsView.frame.size.width - 30, 0, 25, 25)];
    closeButton.autoresizingMask = UIViewAutoresizingFlexibleRightMargin; 
    [closeButton addTarget:self action:@selector(closeDetails) forControlEvents:UIControlStateNormal];
    [closeButton addTarget:self action:@selector(closeDetails) forControlEvents:UIControlStateHighlighted];
    [closeButton addTarget:self action:@selector(closeDetails) forControlEvents:UIControlStateSelected];
    
    UIImageView *rateImgViews           = [[UIImageView alloc] initWithFrame:CGRectMake(2.5, 2.5, 15, 15)];
    rateImgViews.backgroundColor        = [UIColor clearColor];
    rateImgViews.image                  = [UIImage imageNamed:@"exit.png"];
    rateImgViews.contentMode            = UIViewContentModeScaleAspectFit;
    [closeButton addSubview:rateImgViews];
    [rateImgViews release];
    
    [detailsView addSubview:closeButton];    
    
    [self loadMapView];

}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


#pragma mark - Private Methods

- (void)loadMapView{
    
    mappaView.delegate          = self;
    mappaView.showsUserLocation = YES;
    
    for (int i = 0; i < [[selectedVgood objectForKey:@"vgoodPOIs"] count]; i++){
        
        float latitude          = [[[[[selectedVgood objectForKey:@"vgoodPOIs"] objectAtIndex:i] objectForKey:@"place"] objectForKey:@"latitude"] floatValue];
        
        float longitude         = [[[[[selectedVgood objectForKey:@"vgoodPOIs"] objectAtIndex:i] objectForKey:@"place"] objectForKey:@"longitude"] floatValue];
        
        CLLocationCoordinate2D loc;
        loc.latitude            = latitude;
        loc.longitude           = longitude;
        
        CLLocation *pinLocation = [[CLLocation alloc] initWithLatitude:latitude longitude:longitude];

        float userLatitude      = mappaView.userLocation.coordinate.latitude;
        
        float userLongitude     = mappaView.userLocation.coordinate.longitude;
        
        CLLocationCoordinate2D userLoc;
        userLoc.latitude        = userLatitude;
        userLoc.longitude       = userLongitude;

        CLLocation *userLocation = [[CLLocation alloc] initWithLatitude:[Beintoo getUserLocation].coordinate.latitude longitude:[Beintoo getUserLocation].coordinate.longitude];
        
        float distance = [userLocation distanceFromLocation:pinLocation];
        float miglia = 0.621371192 * (distance/1000);
        
        [distancesArray addObject:[NSString stringWithFormat:@"%f", distance/1000]];
        [latitudeArray addObject:[NSString stringWithFormat:@"%f", latitude]];
        [longitudeArray addObject:[NSString stringWithFormat:@"%f", longitude]];
        
        BPinAnnotation *pin = [[BPinAnnotation alloc] initWithCoordinate:loc];
        [pin setTag:i];
        [pin setMTitle:[selectedVgood objectForKey:@"name"]];
        [pin setMSubTitle:[NSString stringWithFormat:@"%@: %.02f Km / %.02f M", NSLocalizedStringFromTable(@"MPdistance", @"BeintooLocalizable", nil), distance/1000, miglia]];
        
        [mappaView addAnnotation:pin];
        
        [pinLocation release];
        [userLocation release];
    }
    
}

#pragma mark - MapView Delegates

- (MKAnnotationView *)mapView:(MKMapView *)_mapView viewForAnnotation:(id )annotation {
    
    if (annotation == _mapView.userLocation) {
        return nil;
    }
    MKAnnotationView *pinView = [[[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"Pin"] autorelease];
    pinView.canShowCallout  = YES;
    
    UIButton *button        = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    button.tag              = [annotation tag];
    button.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleRightMargin;      
    [button addTarget:self action:@selector(openDetails:) forControlEvents:UIControlStateNormal];
    [button addTarget:self action:@selector(openDetails:) forControlEvents:UIControlStateHighlighted];
    [button addTarget:self action:@selector(openDetails:) forControlEvents:UIControlStateSelected];
    
    pinView.rightCalloutAccessoryView = button;
    
    UIImageView *imageView  = [[UIImageView alloc] initWithFrame:CGRectMake(-17.5, -17.5, 35, 35)];
    imageView.image         = [UIImage imageNamed:@"marker.png"];
    imageView.backgroundColor = [UIColor clearColor];
    imageView.contentMode   = UIViewContentModeScaleAspectFit;
    [pinView addSubview:imageView];
    [imageView release];
    
    return pinView;
}

- (void)mapView:(MKMapView *)_mapView didAddAnnotationViews:(NSArray *)views {
    @try{
        if ([latitudeArray count] > 0 && [longitudeArray count] > 0){
            float maxDistance;
            int positionOfMaxDistanceAnnotation;
            for (MKAnnotationView *annotationView in views) {
                if ([[distancesArray objectAtIndex:[annotationView tag]] floatValue] > maxDistance){
                    maxDistance = [[distancesArray objectAtIndex:[annotationView tag]] floatValue];
                    positionOfMaxDistanceAnnotation = [annotationView tag];
                }
                float latitudeDistance = [Beintoo getUserLocation].coordinate.latitude - [[latitudeArray objectAtIndex:positionOfMaxDistanceAnnotation] floatValue];
                
                float longitudeDistance = [Beintoo getUserLocation].coordinate.longitude - [[longitudeArray objectAtIndex:positionOfMaxDistanceAnnotation] floatValue];
                if( latitudeDistance < 0){
                    latitudeDistance *= -1;
                }
                if( longitudeDistance < 0){
                    longitudeDistance *= -1;
                }
                if (annotationView.annotation == _mapView.userLocation){
                    MKCoordinateSpan span = MKCoordinateSpanMake(latitudeDistance*2.0, longitudeDistance*2.0);
                    MKCoordinateRegion region = MKCoordinateRegionMake(_mapView.userLocation.coordinate, span);
                    [_mapView setRegion:region animated:YES];
                }
            }
        }
     }
     @catch (NSException *e){
         NSLog(@"Exception on map view: %@", e);
     }
}

#pragma mark - IBOutlets

- (IBAction)openDetails:(id)sender{
    
    nameLabel.text = [[[[selectedVgood objectForKey:@"vgoodPOIs"] objectAtIndex:[sender tag]] objectForKey:@"place"] objectForKey:@"name"];
        
    NSString *address = [[NSString alloc] init];
    address = [NSString stringWithFormat:@"%@: ", NSLocalizedStringFromTable(@"MPaddress", @"BeintooLocalizable", nil)];
    if ([[[[selectedVgood objectForKey:@"vgoodPOIs"] objectAtIndex:[sender tag]] objectForKey:@"place"] objectForKey:@"address"]){
        address = [address stringByAppendingFormat:@"%@, ", [[[[selectedVgood objectForKey:@"vgoodPOIs"] objectAtIndex:[sender tag]] objectForKey:@"place"] objectForKey:@"address"]];
    }
    if ([[[[selectedVgood objectForKey:@"vgoodPOIs"] objectAtIndex:[sender tag]] objectForKey:@"place"] objectForKey:@"zip"]){
        address = [address stringByAppendingFormat:@"%@ ", [[[[selectedVgood objectForKey:@"vgoodPOIs"] objectAtIndex:[sender tag]] objectForKey:@"place"] objectForKey:@"zip"]];
    }
    if ([[[[selectedVgood objectForKey:@"vgoodPOIs"] objectAtIndex:[sender tag]] objectForKey:@"place"] objectForKey:@"city"]){
        address = [address stringByAppendingFormat:@"%@ ", [[[[selectedVgood objectForKey:@"vgoodPOIs"] objectAtIndex:[sender tag]] objectForKey:@"place"] objectForKey:@"city"]];
    }
    if ([[[[selectedVgood objectForKey:@"vgoodPOIs"] objectAtIndex:[sender tag]] objectForKey:@"place"] objectForKey:@"country"]){
        address = [address stringByAppendingFormat:@"(%@)", [[[[selectedVgood objectForKey:@"vgoodPOIs"] objectAtIndex:[sender tag]] objectForKey:@"place"] objectForKey:@"country"]];
    }
    
    addressLabel.text = address;
    
    int tag;
    if (sender){
        tag = [sender tag];    
    }
    else {
        tag = currentTag;
    }
    
    
    
    if (isDetailsViewOpen == NO){
        [UIView beginAnimations:@"openDetails" context:nil];
        [UIView setAnimationDuration:0.4];
        [UIView setAnimationDelegate:self];
        
        detailsView.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.size.height - detailsView.frame.size.height, detailsView.frame.size.width, detailsView.frame.size.height);
        isDetailsViewOpen = YES;
        
        [UIView commitAnimations];
    }
    
}

- (void)closeDetails{
    
    if (isDetailsViewOpen == YES){
        [UIView beginAnimations:@"closeDetails" context:nil];
        [UIView setAnimationDuration:0.4];
        [UIView setAnimationDelegate:self];
        
        detailsView.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.size.height + detailsView.frame.size.height, detailsView.frame.size.width, detailsView.frame.size.height);
        isDetailsViewOpen = NO;
        
        [UIView commitAnimations];
    }
}


@end
