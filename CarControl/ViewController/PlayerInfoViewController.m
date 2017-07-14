//
//  PlayerInfoViewController.m
//  CarControl
//
//  Created by Dan Attali on 1/1/14.
//  Copyright (c) 2014 Dan Attali. All rights reserved.
//

#import "PlayerInfoViewController.h"
#import "AppDelegate.h"
#import "SKInnerShadowLayer.h"

@interface PlayerInfoViewController ()

@end

@implementation PlayerInfoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

    }
    return self;
}

-(void) displayPlaylistName
{
    AppDelegate *appDelegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    SpotifyPlaylist *playlist = [appDelegate.spotifyManager getCurrentPlaylist];
    if (playlist != nil) {
        self.labelPlaylistName.text = [playlist getName];
    }
}

-(void) displayTrackInfo
{
    AppDelegate *appDelegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    SPTrack *track = [appDelegate.spotifyManager currentTrack];
    if (track != nil) {
        self.labelArtist.text = track.consolidatedArtists;
        self.labelTrackTitle.text = track.name;
    }
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqual:@"spotifyManager.playbackManager.trackPosition"]) {
        AppDelegate *appDelegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
        NSTimeInterval position = appDelegate.spotifyManager.playbackManager.trackPosition;
        int minutes = floor(position/60);
        int seconds = round(position - minutes * 60);
        self.labelProgressTime.text = [NSString stringWithFormat:@"%d:%s%d", minutes, (seconds < 10 ? "0" : ""), seconds];
    }
    if ([keyPath isEqual:@"spotifyManager.logged"] || [keyPath isEqual:@"spotifyManager.currentPlaylistIndex"]) {
        [self displayPlaylistName];
    }
    if ([keyPath isEqual:@"spotifyManager.logged"] || [keyPath isEqual:@"spotifyManager.currentTrackIndex"]
        || [keyPath isEqual:@"spotifyManager.playlistReady"] || [keyPath isEqual:@"spotifyManager.currentPlaylistIndex"]) {
        [self displayTrackInfo];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor colorWithWhite:1 alpha:1];
    self.view.layer.borderColor = [UIColor colorWithWhite:0.9 alpha:1.0f].CGColor;
    self.view.layer.borderWidth = 1;
    
    AppDelegate *appDelegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    [appDelegate addObserver:self forKeyPath:@"spotifyManager.playbackManager.trackPosition" options:NSKeyValueObservingOptionNew context:nil];
    [appDelegate addObserver:self forKeyPath:@"spotifyManager.playlistReady" options:NSKeyValueObservingOptionNew context:nil];
    [appDelegate addObserver:self forKeyPath:@"spotifyManager.currentPlaylistIndex" options:NSKeyValueObservingOptionNew context:nil];
    [appDelegate addObserver:self forKeyPath:@"spotifyManager.currentTrackIndex" options:NSKeyValueObservingOptionNew context:nil];
    [appDelegate addObserver:self forKeyPath:@"bluetoothReceiverManager.dataReceived" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
