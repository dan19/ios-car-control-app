//
//  BluetoothTransferManager.m
//  CarControl
//
//  Created by Dan Attali on 12/24/13.
//  Copyright (c) 2013 Dan Attali. All rights reserved.
//

#import "BluetoothSenderManager.h"

@implementation BluetoothSenderManager

-(id) init
{
    self = [super init];
    [self startAdvertising];
    
    return self;
}

//-(void) initIbeacon
//{
//    NSUUID *uuid = [[NSUUID alloc] initWithUUIDString:TRANSFER_SERVICE_UUID];
//    self.beaconRegion = [[CLBeaconRegion alloc] initWithProximityUUID:uuid major:1 minor:1 identifier:@"com.danattali.CarControl"];
//    self.beaconPeripheralData = [self.beaconRegion peripheralDataWithMeasuredPower:nil];
//    self.peripheralManager = [[CBPeripheralManager alloc] initWithDelegate:self queue:nil options:nil];
//}

- (void)startAdvertising {
    self.peripheralManager = [[CBPeripheralManager alloc] initWithDelegate:self queue:nil];
    [self.peripheralManager startAdvertising:@{
        CBAdvertisementDataServiceUUIDsKey : @[[CBUUID UUIDWithString:TRANSFER_SERVICE_UUID]] }];
}

- (void)stop {
    self.peripheralManager = [[CBPeripheralManager alloc] initWithDelegate:self queue:nil];
    [self.peripheralManager stopAdvertising];
}

- (void)peripheralManagerDidUpdateState:(CBPeripheralManager *)peripheral {
    NSLog(@"peripheralManagerDidUpdateState");
    if (peripheral.state != CBPeripheralManagerStatePoweredOn) {
        return;
    }
    self.transferCharacteristic = [[CBMutableCharacteristic alloc] initWithType:[CBUUID UUIDWithString:TRANSFER_CHARACTERISTIC_UUID] properties:CBCharacteristicPropertyNotify value:nil permissions:CBAttributePermissionsReadable];
    CBMutableService *transferService = [[CBMutableService alloc] initWithType:[CBUUID UUIDWithString:TRANSFER_SERVICE_UUID] primary:YES];
    transferService.characteristics = @[self.transferCharacteristic];
    [self.peripheralManager addService:transferService];
}

- (void)peripheralManager:(CBPeripheralManager *)peripheral central:(CBCentral *)central didSubscribeToCharacteristic:(CBCharacteristic *)characteristic {
    NSLog(@"didSubscribeToCharacteristic");
    self.ready = true;
    self.sendDataIndex = 0;
//    [self sendData];
}

- (void)send:(SPTrack *)track
{
    Share *share = [[Share alloc] initWith:track];
    SPUser *user = [[SPSession sharedSession] user];
    share.displayName = user.displayName;
    
    NSError *error = [[NSError alloc] init];
    NSDictionary *shareDictionnary = [share toNSDictionary];
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:shareDictionnary options:NSJSONWritingPrettyPrinted error:&error];    
    
    NSLog(@"Successfully serialized the dictionary into data = %@", jsonData);
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSLog(@"Json : [%@]", jsonString);
    NSLog(@"send track [%@]", track.name);
    if (self.ready) {
        self.dataToSend = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
        self.sendDataIndex = 0;
        [self sendData];
    }
}

- (void)sendData {
    static BOOL sendingEOM = NO;
    // end of message?
    if (sendingEOM) {
        BOOL didSend = [self.peripheralManager updateValue:[@"EOM" dataUsingEncoding:NSUTF8StringEncoding] forCharacteristic:self.transferCharacteristic onSubscribedCentrals:nil];
        if (didSend) {
            // It did, so mark it as sent
            sendingEOM = NO;
        }
        // didn't send, so we'll exit and wait for peripheralManagerIsReadyToUpdateSubscribers to call sendData again
        return;
    }
    // We're sending data
    // Is there any left to send?
    if (self.sendDataIndex >= self.dataToSend.length) {
        // No data left.  Do nothing
        return;
    }
    // There's data left, so send until the callback fails, or we're done.
    BOOL didSend = YES;
    while (didSend) {
        // Work out how big it should be
        NSInteger amountToSend = self.dataToSend.length - self.sendDataIndex;
        // Can't be longer than 20 bytes
        if (amountToSend > NOTIFY_MTU) amountToSend = NOTIFY_MTU;
        // Copy out the data we want
        NSData *chunk = [NSData dataWithBytes:self.dataToSend.bytes+self.sendDataIndex length:amountToSend];
        didSend = [self.peripheralManager updateValue:chunk forCharacteristic:self.transferCharacteristic onSubscribedCentrals:nil];
        // If it didn't work, drop out and wait for the callback
        if (!didSend) {
            return;
        }
        NSString *stringFromData = [[NSString alloc] initWithData:chunk encoding:NSUTF8StringEncoding];
        NSLog(@"Sent: %@", stringFromData);
        // It did send, so update our index
        self.sendDataIndex += amountToSend;
        NSLog(@"Data index [%d], [%d]", self.sendDataIndex, self.dataToSend.length);
        // Was it the last one?
        if (self.sendDataIndex >= self.dataToSend.length) {
            // Set this so if the send fails, we'll send it next time
            sendingEOM = YES;
            BOOL eomSent = [self.peripheralManager updateValue:[@"EOM" dataUsingEncoding:NSUTF8StringEncoding] forCharacteristic:self.transferCharacteristic onSubscribedCentrals:nil];
            if (eomSent) {
                // It sent, we're all done
                sendingEOM = NO;
                NSLog(@"Sent: EOM");
            }
            return;
        }
    }
}

- (void)peripheralManagerIsReadyToUpdateSubscribers:(CBPeripheralManager *)peripheral {
    NSLog(@"peripheralManagerIsReadyToUpdateSubscribers");
    [self sendData];
}

@end
