//
//  ViewController.h
// 
// Copyright 2011 Joshua Drew
// 
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
// 
// http://www.apache.org/licenses/LICENSE-2.0
// 
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "GooglePlacesConnection.h"
#import "PullToRefreshTableViewController.h"

@class GooglePlacesObject;

@interface ViewController : PullToRefreshTableViewController <UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, GooglePlacesConnectionDelegate, CLLocationManagerDelegate>
{   
    CLLocationManager       *locationManager;
    CLLocation              *currentLocation;
    
    NSMutableData           *responseData;
    NSMutableArray          *locations;
    NSString                *searchString;
    
    GooglePlacesConnection  *googlePlacesConnection;
}


@property (nonatomic, getter = isResultsLoaded) BOOL resultsLoaded;

@property (nonatomic, retain) CLLocationManager *locationManager;
@property (nonatomic, retain) CLLocation        *currentLocation;

@property (nonatomic, retain) NSURLConnection   *urlConnection;
@property (nonatomic, retain) NSMutableData     *responseData;
@property (nonatomic, retain) NSMutableArray    *locations;

@end
