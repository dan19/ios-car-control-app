//
//  SpotifyTracksViewController.h
//  CarControl
//
//  Created by Dan Attali on 12/12/13.
//  Copyright (c) 2013 Dan Attali. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SpotifyPlaylist.h"

@interface SpotifyTracksViewController : UITableViewController

@property(nonatomic, readwrite) SpotifyPlaylist *spotifyPlaylist;

@end
