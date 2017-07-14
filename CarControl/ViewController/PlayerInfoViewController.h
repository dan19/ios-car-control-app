//
//  PlayerInfoViewController.h
//  CarControl
//
//  Created by Dan Attali on 1/1/14.
//  Copyright (c) 2014 Dan Attali. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlayerInfoViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *labelTrackTitle;
@property (weak, nonatomic) IBOutlet UILabel *labelArtist;
@property (weak, nonatomic) IBOutlet UILabel *labelPlaylistName;
@property (weak, nonatomic) IBOutlet UILabel *labelProgressTime;

@end
