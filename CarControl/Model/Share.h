//
//  Share.h
//  CarControl
//
//  Created by Dan Attali on 12/25/13.
//  Copyright (c) 2013 Dan Attali. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CocoaLibSpotify.h"

@interface Share : NSObject

@property (nonatomic, readwrite) NSUUID *userUuid;
@property (nonatomic, readwrite) NSString *deviceName;
@property (nonatomic, readwrite) NSString *trackUrl;
@property (nonatomic, readwrite) NSString *displayName;

-(id) initWith:(SPTrack *)track;
-(NSMutableDictionary *)toNSDictionary;

@end
