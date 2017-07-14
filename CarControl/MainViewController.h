//
//  MainViewController.h
//  CarControl
//
//  Created by Dan Attali on 12/8/13.
//  Copyright (c) 2013 Dan Attali. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>
#import "CocoaLibSpotify.h"
#import "BluetoothSenderManager.h"

@interface MainViewController : UIViewController

@property MPMusicPlayerController *mainPlayer;
@property AVSpeechSynthesizer *speechSynth;
@property (weak, nonatomic) IBOutlet UIView *viewTopBar;

@end
