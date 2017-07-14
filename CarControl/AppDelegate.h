//
//  AppDelegate.h
//  CarControl
//
//  Created by Dan Attali on 12/8/13.
//  Copyright (c) 2013 Dan Attali. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "UserManager.h"
#import "ContactManager.h"
#import "SpotifyManager.h"
#import "UserSetting.h"
#import "BluetoothReceiverManager.h"
#import "YelpManager.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (nonatomic, retain, readwrite) UserManager *userManager;
@property (strong, nonatomic, readwrite) SpotifyManager *spotifyManager;
@property (strong, nonatomic, readwrite) ContactManager *contactManager;
@property (strong, nonatomic, readwrite) UserSetting *userSetting;
@property (strong, nonatomic, readwrite) BluetoothReceiverManager *bluetoothReceiverManager;
@property (strong, nonatomic, readwrite) YelpManager *yelpManager;

@end
