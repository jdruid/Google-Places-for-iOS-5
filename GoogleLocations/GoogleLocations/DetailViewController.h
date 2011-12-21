//
//  DetailViewController.h
//  GoogleLocations
//
//  Created by Joshua Drew on 12/21/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "GooglePlacesConnection.h"

@class GooglePlacesObject;

@interface DetailViewController : UIViewController <GooglePlacesConnectionDelegate, MKMapViewDelegate>
{
    IBOutlet UILabel    *placeName;
    IBOutlet UILabel    *placeFormattedAddress;
    IBOutlet UILabel    *placeWebsite;
    
    IBOutlet MKMapView  *mapView;
    
    GooglePlacesConnection  *googlePlacesConnection;
}

@property (nonatomic, strong) NSString *reference;
@property (nonatomic, retain) IBOutlet MKMapView *mapView;

-(void)loadViewWithGooglePlaces:(NSMutableArray *)objects;

@end
