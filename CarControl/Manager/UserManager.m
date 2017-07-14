//
//  UserManager.m
//  CarControl
//
//  Created by Dan Attali on 12/13/13.
//  Copyright (c) 2013 Dan Attali. All rights reserved.
//

#import "UserManager.h"

@implementation UserManager

-(id)initWithManagedObjectContext:(NSManagedObjectContext *)managedObjectContext {
    if ( self = [super init] ) {
        self.managedObjectContext = managedObjectContext;
        
        return self;
    }
    
    return nil;
}

-(User *)getUserInstance {
    User *user = [NSEntityDescription insertNewObjectForEntityForName:@"User"
                                                  inManagedObjectContext:self.managedObjectContext];
    
    return user;
}

-(User *)save:(User *)user{

    NSError *error;
    if (![self.managedObjectContext save:&error]) {
        NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
    }
    
    return user;
}

@end
