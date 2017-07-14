//
//  SpotifyManager.m
//  CarControl
//
//  Created by Dan Attali on 12/9/13.
//  Copyright (c) 2013 Dan Attali. All rights reserved.
//

#import "SpotifyManager.h"
#import "appkey.c"
#import "AppDelegate.h"

@implementation SpotifyManager

-(id)init {

    NSError *error = nil;
    self.currentPlaylistIndex = 0;
    [SPSession initializeSharedSessionWithApplicationKey:[NSData dataWithBytes:&g_appkey length:g_appkey_size]
                                               userAgent:@"com.DanAttali.CarControl"
                                               loadingPolicy:SPAsyncLoadingManual
                                               error: &error];
    
    self.playbackManager = [[SPPlaybackManager alloc] initWithPlaybackSession:[SPSession sharedSession]];
    [[SPSession sharedSession] setDelegate:self];
    self.logged = false;
    self.playlistReady = false;
    self.shuffle = false;
    [self addObserver:self forKeyPath:@"playlistReady" options:NSKeyValueObservingOptionNew context:nil];
    [self addObserver:self forKeyPath:@"playbackManager.trackPosition" options:NSKeyValueObservingOptionNew context:nil];
    
    return self;
}

-(void) authenticate {
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if (appDelegate.userSetting.spotifyUserName && appDelegate.userSetting.spotifyCredential) {
        [[SPSession sharedSession] attemptLoginWithUserName:appDelegate.userSetting.spotifyUserName existingCredential:appDelegate.userSetting.spotifyCredential];
    } else {
        NSLog(@"No spotify credential available");
    }
}

-(void) logout {
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate.userSetting.spotifyUserName = nil;
    appDelegate.userSetting.spotifyCredential = nil;
    [appDelegate.userSetting save];
    self.logged = false;
}

-(SPLoginViewController *) createLoginView {
    
    SPLoginViewController *spotifyController = [SPLoginViewController loginControllerForSession:[SPSession sharedSession]];
    
    return spotifyController;
}

-(SpotifyPlaylist *) getCurrentPlaylist {
    return [self.playlists objectAtIndex:self.currentPlaylistIndex];
}

-(SpotifyPlaylist *) getNextPlaylist {
    [self loadPlaylistAt:self.currentPlaylistIndex+1];
    
    return [self.playlists objectAtIndex:self.currentPlaylistIndex];
}

-(SpotifyPlaylist *) getPreviousPlaylist {
    [self loadPlaylistAt:self.currentPlaylistIndex-1];
    
    return [self.playlists objectAtIndex:self.currentPlaylistIndex];
}

-(void) loadPlaylistAt:(NSInteger)index
{
    if (self.playlistReady) {
        if (index != self.currentPlaylistIndex || ([self getCurrentPlaylist].queue == nil && self.currentPlaylistIndex == 0)) {
            self.currentTrackIndex = 0;
            int end = [self.playlists count]-1;
            if (index < 0) {
                self.currentPlaylistIndex = end;
            } else if (index > end) {
                self.currentPlaylistIndex = 0;
            } else {
                self.currentPlaylistIndex = index;
            }
            SpotifyPlaylist *playlist = [self.playlists objectAtIndex:self.currentPlaylistIndex];
            [playlist prepareQueue:self.shuffle];
        }
    }
}

-(void) reloadPlaylist
{
    if (self.playlistReady) {
        SpotifyPlaylist *playlist = [self.playlists objectAtIndex:self.currentPlaylistIndex];
        if ([self.playbackManager isPlaying]) {
            [playlist prepareQueue:self.shuffle withTrackAtIndexFirst:self.currentTrackIndex];
            if (self.shuffle) {
                self.currentTrackIndex = 0;
            }
        } else {
            [playlist prepareQueue:self.shuffle];
            self.currentTrackIndex = 0;
        }
    }
}


-(SpotifyPlaylist *) getPlaylistAt:(NSInteger)index
{
    if (self.playlistReady) {
        int end = [self.playlists count]-1;
        if (index >= 0 && index <= end) {
            SpotifyPlaylist *playlist = [self.playlists objectAtIndex:index];
            
            return playlist;
        }
    }
    
    return nil;
}

-(void) playOrPause{
    SPTrack *track = [self currentTrack];
    if (track != nil) {
        if (track.isLoaded && self.playbackManager.currentTrack == track) {
            self.playbackManager.isPlaying = (!self.playbackManager.isPlaying);
        } else {
            [self loadAndPlay:track];
        }
    }
}

-(SPTrack *) currentTrack{
    SpotifyPlaylist *playlist = [self getCurrentPlaylist];
    
    return [playlist getCurrentTrack];
}

-(void) playNextTrack{
    [self playTrackAtIndex:self.currentTrackIndex+1];
}

-(void) playTrackAtIndex:(NSInteger)index {
    SpotifyPlaylist *playlist = [self.playlists objectAtIndex:self.currentPlaylistIndex];
    if (playlist != nil && [playlist.queue count] > index) {
        [playlist setTrackIndex:index];
        self.currentTrackIndex = index;
        [self playOrPause];
    }
}

- (void)loadAndPlay:(SPTrack *) track {
    
    if (track != nil) {
        [SPAsyncLoading waitUntilLoaded:track timeout:kSPAsyncLoadingDefaultTimeout then:^(NSArray *tracks, NSArray *notLoadedTracks) {
            [self.playbackManager playTrack:track callback:^(NSError *error) {
                if (error) {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Cannot Play Track"
                                                                    message:[error localizedDescription]
                                                                   delegate:nil
                                                          cancelButtonTitle:@"OK"
                                                          otherButtonTitles:nil];
                    [alert show];
                }
            }];
        }];
    }
}

-(void) addToQueue:(SPTrack *)track {
    if (self.queue != nil || [self.queue count] == 0) {
        self.queue = [[NSMutableArray alloc] init];
        [self.queue addObject:track];
    } else {
        [self.queue insertObject:track atIndex:self.currentTrackIndex+1];
    }
}

-(void) toggleShuffle {
    self.shuffle = !self.shuffle;
    
    if (self.playlistReady) {
        SpotifyPlaylist *playlist = [self.playlists objectAtIndex:self.currentPlaylistIndex];
        if (playlist != nil) {
            self.queue = playlist.tracks;
            if (self.shuffle) {
                self.queue = [self.queue shuffled];
            }
            if (self.playbackManager.isPlaying) {
                NSInteger trackIndex = [self.queue indexOfObject:self.playbackManager.currentTrack];
                if(NSNotFound == trackIndex) {
                    self.currentTrackIndex = 0;
                } else {
                    self.currentTrackIndex = trackIndex;
                }
            } else {
                self.currentTrackIndex = 0;
            }
        }
    }
    
}

-(void)waitAndFillPlaylists {
    
    [SPAsyncLoading waitUntilLoaded:[SPSession sharedSession] timeout:kSPAsyncLoadingDefaultTimeout then:^(NSArray *loadedession, NSArray *notLoadedSession) {
        
        // The session is logged in and loaded — now wait for the userPlaylists to load.
        NSLog(@"[%@ %@]: %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd), @"Session loaded.");
        
        [SPAsyncLoading waitUntilLoaded:[SPSession sharedSession].userPlaylists timeout:kSPAsyncLoadingDefaultTimeout then:^(NSArray *loadedContainers, NSArray *notLoadedContainers) {
            
            // User playlists are loaded — wait for playlists to load their metadata.
            NSLog(@"[%@ %@]: %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd), @"Container loaded.");
            
            NSMutableArray *playlists = [NSMutableArray array];
            //            [playlists addObject:[SPSession sharedSession].starredPlaylist];
            //            [playlists addObject:[SPSession sharedSession].inboxPlaylist];
            [playlists addObjectsFromArray:[SPSession sharedSession].userPlaylists.flattenedPlaylists];
            
            [SPAsyncLoading waitUntilLoaded:playlists timeout:kSPAsyncLoadingDefaultTimeout then:^(NSArray *loadedPlaylists, NSArray *notLoadedPlaylists) {
                
                self.playlists = [NSMutableArray arrayWithCapacity:loadedPlaylists.count];
                int i = 0;
                for(SPPlaylist *playlist in loadedPlaylists) {
                    SpotifyPlaylist *spotifyPlaylist = [[SpotifyPlaylist alloc] initWithSPPlaylist:playlist];
//                        [playlist setMarkedForOfflinePlayback:true];
                    
                    NSArray *tracks = [self tracksFromPlaylistItems:playlist.items];
                    spotifyPlaylist.tracks = [NSMutableArray arrayWithCapacity:loadedPlaylists.count];
                    
                    [SPAsyncLoading waitUntilLoaded:tracks timeout:kSPAsyncLoadingDefaultTimeout then:^(NSArray *loadedTracks, NSArray *notLoadedTracks) {
                        
                        for (SPTrack *aTrack in loadedTracks) {
                            if (aTrack.availability == SP_TRACK_AVAILABILITY_AVAILABLE && [aTrack.name length] > 0) {
                                [spotifyPlaylist.tracks addObject:aTrack];
                            }
                        }
                        if ([spotifyPlaylist.tracks count] > 0) {
                            [spotifyPlaylist prepareQueue:self.shuffle];
                            [self.playlists addObject:spotifyPlaylist];
                        }
                    }];
                    i++;
                }
                self.playlistReady = true;
                self.logged = true;
            }];
        }];
    }];
}

-(NSArray *)tracksFromPlaylistItems:(NSArray *)items {
    
    NSMutableArray *tracks = [NSMutableArray arrayWithCapacity:items.count];
    
    for (SPPlaylistItem *anItem in items) {
        if (anItem.itemClass == [SPTrack class]) {
            [tracks addObject:anItem.item];
        }
    }
    
    return [NSArray arrayWithArray:tracks];
}

-(void)sessionDidLoginSuccessfully:(SPSession *)aSession; {
    NSLog(@"Login successfull %@", aSession.user.displayName);
    self.logged = true;
    [self waitAndFillPlaylists];
}

- (void)session:(SPSession *)aSession didGenerateLoginCredentials:(NSString *)credential forUserName:(NSString *)userName {
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate.userSetting.spotifyUserName = userName;
    appDelegate.userSetting.spotifyCredential = credential;
    [appDelegate.userSetting save];
}

-(void)session:(SPSession *)aSession didFailToLoginWithError:(NSError *)error; {
    NSLog(@"Error while login %@", error);
}

-(void)session:(SPSession *)aSession recievedMessageForUser:(NSString *)aMessage; {
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Message from Spotify"
                                                    message:aMessage
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"playlistReady"]) {
        [self loadPlaylistAt:self.currentPlaylistIndex];
    } else if ([keyPath isEqual:@"playbackManager.trackPosition"]) {
        NSTimeInterval position = self.playbackManager.trackPosition;
        SPTrack *track = [self currentTrack];
        if (position+0.5f >= track.duration) {
            [self playNextTrack];
        }
    
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

@end
