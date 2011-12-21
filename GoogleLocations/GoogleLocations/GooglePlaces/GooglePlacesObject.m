//
//  GooglePlacesObject.m
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

#import "GooglePlacesObject.h"

@implementation GooglePlacesObject

@synthesize placesId;
@synthesize reference;
@synthesize name;
@synthesize icon;
@synthesize rating;
@synthesize vicinity;
@synthesize type;
@synthesize url;
@synthesize addressComponents;
@synthesize formattedAddress;
@synthesize formattedPhoneNumber;
@synthesize website;
@synthesize internationalPhoneNumber;
@synthesize coordinate;
@synthesize searchTerms;

-(id)initWithName:(NSString *)theName 
         latitude:(double)lt 
        longitude:(double)lg 
        placeIcon:(NSString *)icn 
           rating:(NSString *)rate 
         vicinity:(NSString *)vic 
             type:(NSArray *)typ 
        reference:(NSString *)ref 
              url:(NSString *)www 
addressComponents:(NSArray *)addComp 
 formattedAddress:(NSString *)fAddrss 
formattedPhoneNumber:(NSString *)fPhone
website:(NSString *)web 
internationalPhone:(NSString *)intPhone
      searchTerms:(NSString *)search
{
    
    if (self = [super init])
    {
        [self setName:theName];
        [self setIcon:icn];
        [self setRating:rate];
        [self setVicinity:vic];
        [self setType:typ];
        [self setReference:ref];
        [self setUrl:www];
        [self setAddressComponents:addComp];
        [self setFormattedAddress:fAddrss];
        [self setFormattedPhoneNumber:fPhone];
        [self setWebsite:web];
        [self setInternationalPhoneNumber:intPhone];
        [self setSearchTerms:search];
        
        [self setCoordinate:CLLocationCoordinate2DMake(lt, lg)];
    }
    return self;
    
}

-(id)initWithJsonResultDict:(NSDictionary *)jsonResultDict searchTerms:(NSString *)terms
{
    
    NSDictionary *geo = [jsonResultDict objectForKey:@"geometry"];
    NSDictionary *loc = [geo objectForKey:@"location"];
    
	return [self initWithName:[jsonResultDict objectForKey:@"name"] 
              latitude:[[loc objectForKey:@"lat"] doubleValue] 
             longitude:[[loc objectForKey:@"lng"] doubleValue]
             placeIcon:[jsonResultDict objectForKey:@"icon"] 
                rating:[jsonResultDict objectForKey:@"rating"]
              vicinity:[jsonResultDict objectForKey:@"vicinity"]
                  type:[jsonResultDict objectForKey:@"types"]
             reference:[jsonResultDict objectForKey:@"reference"]
                   url:[jsonResultDict objectForKey:@"url"]
     addressComponents:[jsonResultDict objectForKey:@"address_components"]
      formattedAddress:[jsonResultDict objectForKey:@"formatted_address"]
  formattedPhoneNumber:[jsonResultDict objectForKey:@"formatted_phone_number"]
            website:[jsonResultDict objectForKey:@"website"]
           internationalPhone:[jsonResultDict objectForKey:@"international_phone_number"] 
     searchTerms:[jsonResultDict objectForKey:terms]];

}

-(id) initWithJsonResultDict:(NSDictionary *)jsonResultDict
{
    return [self initWithJsonResultDict:jsonResultDict searchTerms:@""];

}
@end
