//
//  DetailViewController.m
//  GoogleLocations
//
//  Created by Joshua Drew on 12/21/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "DetailViewController.h"
#import "GooglePlacesObject.h"

@implementation DetailViewController

@synthesize reference;
@synthesize mapView;

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

#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    googlePlacesConnection = [[GooglePlacesConnection alloc] initWithDelegate:self];
    [googlePlacesConnection getGoogleObjectDetails:reference];
  
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)loadViewWithGooglePlaces:(NSMutableArray *)objects 
{
    GooglePlacesObject *place = [objects objectAtIndex:0];
    
    [placeName setText:place.name];
    [placeFormattedAddress setText:place.formattedAddress];
    [placeWebsite setText:place.website];
    
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(place.coordinate, 500, 500);
    [mapView setRegion:region animated:NO];
    
    MKPointAnnotation *annotationPoint = [[MKPointAnnotation alloc] init];
    annotationPoint.coordinate = place.coordinate;
    annotationPoint.title = place.name;
    [mapView addAnnotation:annotationPoint]; 
    
}

#pragma mark -
#pragma mark NSURLConnections

- (void)googlePlacesConnection:(GooglePlacesConnection *)conn didFinishLoadingWithGooglePlacesObjects:(NSMutableArray *)objects 
{
    
    if ([objects count] == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No matches found near this location" 
                                                        message:@"Try another place name or address" 
                                                       delegate:nil 
                                              cancelButtonTitle:@"OK" 
                                              otherButtonTitles: nil];
        [alert show];
    } else {
        [self   loadViewWithGooglePlaces:objects];
    }
}

- (void) googlePlacesConnection:(GooglePlacesConnection *)conn didFailWithError:(NSError *)error
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error finding place - Try again" 
                                                    message:[error localizedDescription] 
                                                   delegate:nil 
                                          cancelButtonTitle:@"OK" 
                                          otherButtonTitles: nil];
    [alert show];
}


@end
