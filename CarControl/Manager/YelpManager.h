//
//  YelpManager.h
//  CarControl
//
//  Created by Dan Attali on 1/28/14.
//  Copyright (c) 2014 Dan Attali. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GCOAuth.h"

@interface YelpManager : NSObject

@property (readwrite, nonatomic) NSString *responseData;

@property (nonatomic, readwrite) NSNumber *lastSearchLatitude;
@property (nonatomic, readwrite) NSNumber *lastSearchLongitude;

-(NSURLRequest *) getRequestForSearchInCategory:(NSString *)category location:(NSString *)location;

@end
