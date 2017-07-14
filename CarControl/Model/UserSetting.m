//
//  UserSetting.m
//  CarControl
//
//  Created by Dan Attali on 12/15/13.
//  Copyright (c) 2013 Dan Attali. All rights reserved.
//

#import "UserSetting.h"

@implementation UserSetting

-(id)init {
    self = [super init];
    
    self.spotifyUserName = [[NSUserDefaults standardUserDefaults] objectForKey:@"spotifyUserName"];
    self.spotifyCredential = [[NSUserDefaults standardUserDefaults] objectForKey:@"spotifyCredential"];
    
    return self;
}

-(void)save {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:self.spotifyUserName forKey:@"spotifyUserName"];
    [defaults setObject:self.spotifyCredential forKey:@"spotifyCredential"];
    [defaults synchronize];
}

@end
