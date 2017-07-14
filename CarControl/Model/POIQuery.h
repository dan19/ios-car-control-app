//
//  POIQuery.h
//  CarControl
//
//  Created by Dan Attali on 1/29/14.
//  Copyright (c) 2014 Dan Attali. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface POIQuery : NSObject<NSURLConnectionDelegate>

@property (nonatomic,readwrite) NSArray *results;
@property (nonatomic,readwrite) NSURLConnection *connection;

@property (nonatomic,readwrite) int status;

@property (nonatomic,readwrite) NSMutableData *data;

-(void) searchWithNSURLRequest:(NSURLRequest *)request;

@end
