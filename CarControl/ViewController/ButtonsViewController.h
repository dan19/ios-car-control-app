//
//  ButtonsViewController.h
//  CarControl
//
//  Created by Dan Attali on 1/2/14.
//  Copyright (c) 2014 Dan Attali. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CocoaLibSpotify.h"
#import "BluetoothSenderManager.h"
#import "IconButton.h"
#import "Contact.h"
#import "ButtonCollectionViewCell.h"

@interface ButtonsViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet IconButton *buttonShare;
@property (weak, nonatomic) IBOutlet IconButton *buttonShuffle;
@property (weak, nonatomic) IBOutlet IconButton *buttonVoice;
@property (weak, nonatomic) IBOutlet IconButton *buttonLocation;
@property (weak, nonatomic) IBOutlet IconButton *buttonCall;
@property (weak, nonatomic) IBOutlet IconButton *buttonGPS;

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;

@property (nonatomic, readwrite) BluetoothSenderManager *bluetoothSenderManager;

@property NSDictionary *buttons;

@end
