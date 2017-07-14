//
//  BluetoothReceiverManager.h
//  CarControl
//
//  Created by Dan Attali on 12/24/13.
//  Copyright (c) 2013 Dan Attali. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "BluetoothSenderManager.h"

@interface BluetoothReceiverManager : NSObject <CBCentralManagerDelegate, CBPeripheralDelegate>

@property (strong, nonatomic) CBCentralManager *centralManager;
@property (strong, nonatomic) CBPeripheral *discoveredPeripheral;
@property (strong, nonatomic) NSMutableData *data;
@property (nonatomic, readwrite) NSString *dataReceived;

@end
