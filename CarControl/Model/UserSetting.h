//
//  UserSetting.h
//  CarControl
//
//  Created by Dan Attali on 12/15/13.
//  Copyright (c) 2013 Dan Attali. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserSetting : NSObject

-(void)save;

@property (nonatomic, retain) NSString * spotifyUserName;
@property (nonatomic, retain) NSString * spotifyCredential;

@end
