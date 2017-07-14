//
//  User.h
//  CarControl
//
//  Created by Dan Attali on 12/13/13.
//  Copyright (c) 2013 Dan Attali. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface User : NSManagedObject

@property (nonatomic, retain) NSString * spotifyUserName;
@property (nonatomic, retain) NSString * spotifyCredential;

@end
