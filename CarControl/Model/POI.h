//
//  POI.h
//  CarControl
//
//  Created by Dan Attali on 1/29/14.
//  Copyright (c) 2014 Dan Attali. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface POI : NSObject

@property (nonatomic, readwrite) NSString *title;
@property (nonatomic, readwrite) NSNumber *latitude;
@property (nonatomic, readwrite) NSNumber *longitude;
@property (nonatomic, readwrite) NSString *phoneNumber;
@property (nonatomic, readwrite) NSString *address;
@property (nonatomic, readwrite) NSString *pictureUrl;
@property (nonatomic, readwrite) NSInteger rating;
@property (nonatomic, readwrite) NSInteger reviewCount;

-(id) initWithYelpBusiness:(NSDictionary *)dictionnary;

@end
