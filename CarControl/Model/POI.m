//
//  POI.m
//  CarControl
//
//  Created by Dan Attali on 1/29/14.
//  Copyright (c) 2014 Dan Attali. All rights reserved.
//

#import "POI.h"

@implementation POI

-(id) initWithYelpBusiness:(NSDictionary *)dictionnary
{
    self.title = [dictionnary objectForKey:@"name"];
    self.phoneNumber = [dictionnary objectForKey:@"display_phone"];
    self.pictureUrl = [dictionnary objectForKey:@"image_url"];
    self.reviewCount = [[dictionnary objectForKey:@"review_count"] integerValue];
    self.rating = [[dictionnary objectForKey:@"rating"] integerValue];
    
    NSDictionary *location = [dictionnary objectForKey:@"location"];
    NSArray *address = [location objectForKey:@"display_address"];
    self.address = [address componentsJoinedByString:@" "];;
    
    return self;
}

@end
