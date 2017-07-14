//
//  BluetoothTransferManager.h
//  CarControl
//
//  Created by Dan Attali on 12/24/13.
//  Copyright (c) 2013 Dan Attali. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "CocoaLibSpotify.h"
#import "Share.h"

#define TRANSFER_SERVICE_UUID           @"94041516-64AB-44B8-B8A0-FC03683E9BC3"
#define TRANSFER_CHARACTERISTIC_UUID    @"45FF64AC-44CA-4302-8F91-EE1E6EFD27F6"
#define NOTIFY_MTU 20

@interface BluetoothSenderManager : NSObject <CBPeripheralDelegate, CBPeripheralManagerDelegate>

@property (strong, nonatomic) CBPeripheralManager *peripheralManager;
@property (strong, nonatomic) CBMutableCharacteristic *transferCharacteristic;
@property (strong, nonatomic) NSData *dataToSend;
@property (nonatomic, readwrite) NSInteger sendDataIndex;

@property(nonatomic, readwrite) BOOL ready;

@property (strong, nonatomic) CLBeaconRegion *beaconRegion;
@property (strong, nonatomic) NSDictionary *beaconPeripheralData;

- (void)send:(SPTrack *)track;
- (void)startAdvertising;

@end
