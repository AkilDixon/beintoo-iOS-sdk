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
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@interface BeintooMapViewVC : UIViewController <MKMapViewDelegate, CLLocationManagerDelegate> {

    // -------> map view <-------
    IBOutlet BView          *mapView;
    IBOutlet MKMapView      *mappaView;
    BView                   *detailsView;
    UILabel                 *labelName;
    UILabel                 *labelAddress;
    UILabel                 *nameLabel;
    UILabel                 *addressLabel;
    
    NSMutableArray          *latitudeArray;
    NSMutableArray          *longitudeArray;
    NSMutableArray          *distancesArray;
    
    BOOL                    isDetailsViewOpen;
    int                     currentTag;

}

@property (nonatomic, retain) NSMutableDictionary       *selectedVgood;
@property (nonatomic, retain) UIImage                   *mapImage;

- (IBAction)openDetails:(id)sender;
- (void)closeDetails;
- (void)loadMapView;

@end
