//
//  UserManager.h
//  CarControl
//
//  Created by Dan Attali on 12/13/13.
//  Copyright (c) 2013 Dan Attali. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"

@interface UserManager : NSObject

@property(nonatomic, readwrite) NSManagedObjectContext *managedObjectContext;

-(id)initWithManagedObjectContext:(NSManagedObjectContext *)managedObjectContext;
-(User *)getUserInstance;
-(User *)save:(User *)user;

@end
