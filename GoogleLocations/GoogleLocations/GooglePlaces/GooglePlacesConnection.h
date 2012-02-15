//
//  GooglePlacesConnection.h
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

#import <Foundation/Foundation.h>
#import "../SBJSON/SBJson.h"
#import "GooglePlacesObject.h"

@protocol GooglePlacesConnectionDelegate;

@interface GooglePlacesConnection : NSObject
{
    NSMutableData       *responseData;
    NSURLConnection     *connection;
    BOOL                connectionIsActive;
    int                 minAccuracyValue;
    //NEW
    CLLocationCoordinate2D userLocation;
}

@property (nonatomic, weak) id <GooglePlacesConnectionDelegate> delegate;
@property (nonatomic, retain) NSMutableData     *responseData;
@property (nonatomic, retain) NSURLConnection   *connection;
@property (nonatomic, assign) BOOL              connectionIsActive;
@property (nonatomic, assign) int               minAccuracyValue;
//NEW
@property (nonatomic, assign) CLLocationCoordinate2D userLocation;

// useful functions
-(id)initWithDelegate:(id)del;

-(void)getGoogleObjectsWithQuery:(NSString *)query 
                  andCoordinates:(CLLocationCoordinate2D)coords 
                        andTypes:(NSString *)types;

-(void)getGoogleObjects:(CLLocationCoordinate2D)coords 
               andTypes:(NSString *)types;

-(void)getGoogleObjectDetails:(NSString*)reference;

-(void)cancelGetGoogleObjects;

@end

@protocol GooglePlacesConnectionDelegate

- (void) googlePlacesConnection:(GooglePlacesConnection *)conn didFinishLoadingWithGooglePlacesObjects:(NSMutableArray *)objects;
- (void) googlePlacesConnection:(GooglePlacesConnection *)conn didFailWithError:(NSError *)error;

@end
