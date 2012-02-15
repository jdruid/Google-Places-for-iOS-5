//
//  GooglePlacesConnection.m
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

#import "GooglePlacesConnection.h"
#import "../GTM/GTMNSString+URLArguments.h"

@implementation GooglePlacesConnection

@synthesize delegate;
@synthesize responseData;
@synthesize connection;
@synthesize connectionIsActive;
@synthesize minAccuracyValue;
//NEW
@synthesize userLocation;

- (id)initWithDelegate:(id <GooglePlacesConnectionDelegate>)del
{
	self = [super init];
	
	if (!self)
		return nil;
	[self setDelegate:del];	
	return self;
}

- (id) init
{
	NSLog(@"need a delegate!! use initWithDelegate!");
	return nil;
}


//Method is called to load initial search
-(void)getGoogleObjects:(CLLocationCoordinate2D)coords andTypes:(NSString *)types
{	
    //NEW setting userlocation to the coords passed in for later use
    userLocation = coords;
    
    double centerLat = coords.latitude;
	double centerLng = coords.longitude;
    
    types = [types gtm_stringByEscapingForURLArgument];
    
    NSString* gurl  = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/search/json?location=%f,%f&radius=500&types=%@&sensor=true&key=%@",
                                    centerLat, centerLng, types, kGOOGLE_API_KEY];
    
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:gurl] 
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy 
                                                       timeoutInterval:10];
    
	[self cancelGetGoogleObjects];
	
	connection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:YES];
    
	if (connection) 
    {
		responseData = [NSMutableData data];
		connectionIsActive = YES;
	}		
	else {
        NSLog(@"connection failed");
	}
    
}
//Method is called during UISearchBar search
-(void)getGoogleObjectsWithQuery:(NSString *)query 
                  andCoordinates:(CLLocationCoordinate2D)coords 
                        andTypes:(NSString *)types
{
    
    //NEW setting userlocation to the coords passed in for later use
    userLocation = coords;

	double centerLat = coords.latitude;
	double centerLng = coords.longitude;
    
    query = [query gtm_stringByEscapingForURLArgument];
    types = [types gtm_stringByEscapingForURLArgument];
    
    NSString* gurl               = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/search/json?location=%f,%f&radius=1000&types=%@&name=%@&sensor=true&key=%@",
                                    centerLat, centerLng, types, query, kGOOGLE_API_KEY];
    
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:gurl] 
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy 
                                                       timeoutInterval:10];
    
	[self cancelGetGoogleObjects];
	
	connection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:YES];
    
	if (connection) 
    {
		responseData = [NSMutableData data];
		connectionIsActive = YES;
	} else {
        NSLog(@"connection failed");
	}
}
//Method is called to get details of place
-(void)getGoogleObjectDetails:(NSString *)reference
{	
        
    NSString* gurl  = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/details/json?reference=%@&sensor=true&key=%@",
                       reference, kGOOGLE_API_KEY];
    
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:gurl] 
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy 
                                                       timeoutInterval:10];
    
	[self cancelGetGoogleObjects];
	
	connection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:YES];
    
	if (connection) 
    {
		responseData = [NSMutableData data];
		connectionIsActive = YES;
	}		
	else {
        NSLog(@"connection failed");
	}
    
}

- (void)connection:(NSURLConnection *)conn didReceiveResponse:(NSURLResponse *)response 
{
	[responseData setLength:0];
}

- (void)connection:(NSURLConnection *)conn didReceiveData:(NSData *)data 
{
	[responseData appendData:data];
}

- (void)connection:(NSURLConnection *)conn didFailWithError:(NSError *)error 
{
	connectionIsActive = NO;
	[delegate googlePlacesConnection:self didFailWithError:error];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)conn 
{
    connectionIsActive          = NO;

    SBJsonParser *json          = [[SBJsonParser alloc] init];
    
	NSString *responseString    = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];	
	NSError *jsonError          = nil;
	
	NSDictionary *parsedJSON    = [json objectWithString:responseString error:&jsonError];
    
	if ([jsonError code]==0) 
    {
        NSString *responseStatus = [NSString stringWithFormat:@"%@",[parsedJSON objectForKey:@"status"]];
    
        if ([responseStatus isEqualToString:@"OK"]) 
        {
            if ([parsedJSON objectForKey: @"results"] == nil) {
                //Perform Place Details results
                NSDictionary *gResponseDetailData = [parsedJSON objectForKey: @"result"];
                NSMutableArray *googlePlacesDetailObject = [NSMutableArray arrayWithCapacity:1];  //Hard code since ONLY 1 result will be coming back
                
                GooglePlacesObject *detailObject = [[GooglePlacesObject alloc] initWithJsonResultDict:gResponseDetailData andUserCoordinates:userLocation];
                [googlePlacesDetailObject addObject:detailObject];
                
                [delegate googlePlacesConnection:self didFinishLoadingWithGooglePlacesObjects:googlePlacesDetailObject];
                
            } else {
                //Perform Place Search results
                NSDictionary *gResponseData  = [parsedJSON objectForKey: @"results"];
                NSMutableArray *googlePlacesObjects = [NSMutableArray arrayWithCapacity:[[parsedJSON objectForKey:@"results"] count]]; 

                for (NSDictionary *result in gResponseData) 
                {
                    [googlePlacesObjects addObject:result];
                }
                
                for (int x=0; x<[googlePlacesObjects count]; x++) 
                {                
                    GooglePlacesObject *object = [[GooglePlacesObject alloc] initWithJsonResultDict:[googlePlacesObjects objectAtIndex:x] andUserCoordinates:userLocation];
                    [googlePlacesObjects replaceObjectAtIndex:x withObject:object];
                }
                
                [delegate googlePlacesConnection:self didFinishLoadingWithGooglePlacesObjects:googlePlacesObjects];
                
            }
                        
        }
        else if ([responseStatus isEqualToString:@"ZERO_RESULTS"]) 
        {
            NSString *description = nil;
            int errCode;
            
            description = NSLocalizedString(@"No locations were found.", @"");
            errCode = 404;
            
            // Make underlying error.
            NSError *underlyingError = [[NSError alloc] initWithDomain:NSPOSIXErrorDomain
                                                                   code:errno userInfo:nil];
            // Make and return custom domain error.
            NSArray *objArray = [NSArray arrayWithObjects:description, underlyingError, nil];
            NSArray *keyArray = [NSArray arrayWithObjects:NSLocalizedDescriptionKey,
                                 NSUnderlyingErrorKey, nil];
            NSDictionary *eDict = [NSDictionary dictionaryWithObjects:objArray
                                                              forKeys:keyArray];
            
            NSError *responseError = [NSError errorWithDomain:@"GoogleLocalObjectDomain" 
                                                         code:errCode 
                                                     userInfo:eDict];
            
            [delegate googlePlacesConnection:self didFailWithError:responseError];
        } else {
            // no results
            NSString *responseDetails = [NSString stringWithFormat:@"%@",[parsedJSON objectForKey:@"status"]];
            NSError *responseError = [NSError errorWithDomain:@"GoogleLocalObjectDomain" 
                                                         code:500 
                                                     userInfo:[NSDictionary dictionaryWithObjectsAndKeys:responseDetails,@"NSLocalizedDescriptionKey",nil]];
            
            [delegate googlePlacesConnection:self didFailWithError:responseError];
        }
	}
	else 
    {
		[delegate googlePlacesConnection:self didFailWithError:jsonError];
	}
	
}

- (void)cancelGetGoogleObjects 
{
	if (connectionIsActive == YES) {
		connectionIsActive = NO;
	}
}
@end
