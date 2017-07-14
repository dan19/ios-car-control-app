//
//  Share.m
//  CarControl
//
//  Created by Dan Attali on 12/25/13.
//  Copyright (c) 2013 Dan Attali. All rights reserved.
//

#import "Share.h"

@implementation Share

-(id) initWith:(SPTrack *)track
{
    self = [super self];
    self.trackUrl = track.spotifyURL.absoluteString;
    self.userUuid = [[UIDevice currentDevice] identifierForVendor];
    self.deviceName = [[UIDevice currentDevice] name];
    
    return self;
}

- (NSMutableDictionary *)toNSDictionary
{
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];

    [dictionary setValue:self.trackUrl forKey:@"trackUrl"];
    [dictionary setValue:self.userUuid.UUIDString forKey:@"userUuid"];
    [dictionary setValue:self.deviceName forKey:@"deviceName"];
    [dictionary setValue:self.displayName forKey:@"displayName"];
    
    return dictionary;
}

@end
