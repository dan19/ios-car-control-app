//
//  SpotifyManager.h
//  CarControl
//
//  Created by Dan Attali on 12/9/13.
//  Copyright (c) 2013 Dan Attali. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CocoaLibSpotify.h"
#import "SpotifyPlaylist.h"
#import "NSMutableArray+Helpers.h"

@interface SpotifyManager : NSObject <UIApplicationDelegate, SPSessionDelegate, SPSessionPlaybackDelegate> {
    SPPlaybackManager *_playbackManager;
    SPTrack *_currentTrack;
    NSMutableArray *_trackPool;
    NSMutableArray *_playlists;
}

@property (nonatomic, strong, readwrite) SPPlaybackManager *playbackManager;
@property (nonatomic, readwrite) NSInteger currentPlaylistIndex;
@property (nonatomic, readwrite, strong) NSMutableArray *playlists;
@property (nonatomic, readwrite, getter = isLogged) BOOL logged;
@property (nonatomic, readwrite) NSInteger currentTrackIndex;
@property (nonatomic, readwrite, strong) NSMutableArray *queue;
@property (nonatomic, readwrite) BOOL shuffle;
@property (nonatomic, readwrite) BOOL playlistReady;

//Player
-(void)loadAndPlay:(SPTrack *) track;
-(void) playOrPause;
-(SPTrack *) currentTrack;
-(void) playTrackAtIndex:(NSInteger)index;
-(SpotifyPlaylist *) getCurrentPlaylist;
-(SpotifyPlaylist *) getNextPlaylist;
-(SpotifyPlaylist *) getPreviousPlaylist;
-(void) addToQueue:(SPTrack *)track;

//Connection
-(SPLoginViewController *) createLoginView;
-(void) authenticate;
-(void) logout;

//Playlists
-(void) toggleShuffle;
-(void) loadPlaylistAt:(NSInteger)index;
-(void) reloadPlaylist;
-(SpotifyPlaylist *) getPlaylistAt:(NSInteger)index;

@end
