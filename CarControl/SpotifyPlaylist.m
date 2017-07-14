//
//  SpotifyPlaylist.m
//  CarControl
//
//  Created by Dan Attali on 12/11/13.
//  Copyright (c) 2013 Dan Attali. All rights reserved.
//

#import "SpotifyPlaylist.h"

@implementation SpotifyPlaylist

- (id)initWithSPPlaylist:(SPPlaylist *)playlist {
    if ( self = [super init] ) {
        self.playlist = playlist;
        self.currentTrackIndex = 0;
        self.tracks = [NSMutableArray arrayWithCapacity:playlist.items.count];
        
        return self;
    }
    
    return nil;
}

-(NSString *) getName {
    return self.playlist.name;
}

-(void) prepareQueue:(bool)shuffle
{
    self.currentTrackIndex = 0;
    if (shuffle) {
        self.queue = [self.tracks shuffled];
    } else {
        self.queue = self.tracks;
    }
}

-(void) prepareQueue:(bool)shuffle withTrackAtIndexFirst:(NSInteger)index
{
    self.currentTrackIndex = 0;
    self.queue = [NSMutableArray arrayWithArray:self.tracks];
    [self.queue removeObjectAtIndex:index];
    if (shuffle) {
        self.queue = [self.queue shuffled];
    }
    [self.queue insertObject:[self.tracks objectAtIndex:index] atIndex:0];
}

-(SPTrack *) getCurrentTrack {
    if (self.queue != nil && self.queue.count > 0) {
        SPTrack *track = (SPTrack *) [self.queue objectAtIndex:(self.currentTrackIndex)];
        
        return track;
    }
    
    return nil;
}

-(void) setTrackIndex:(NSInteger)index {
    if (self.queue != nil && [self.queue count] >= index) {
        self.currentTrackIndex = index;
    }
}

-(SPTrack *) getNextTrack {
    if (self.tracks != nil && self.tracks.count > 0) {
        if (self.currentTrackIndex < self.tracks.count-2) {
            self.currentTrackIndex++;
        } else {
            self.currentTrackIndex = 0;
        }
    
        return [self getCurrentTrack];
    }
    
    return nil;
}

-(SPTrack *) getPreviousTrack {
    if (self.tracks != nil && self.tracks.count > 0) {
        if (self.currentTrackIndex > 0) {
            self.currentTrackIndex--;
        } else {
            self.currentTrackIndex = self.tracks.count-1;
        }
    
        return [self getCurrentTrack];
    }
    
    return nil;
}

@end
