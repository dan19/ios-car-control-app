//
//  SpotifyPlaylist.h
//  CarControl
//
//  Created by Dan Attali on 12/11/13.
//  Copyright (c) 2013 Dan Attali. All rights reserved.
//

#import "CocoaLibSpotify.h"
#import "NSMutableArray+Helpers.h"

@interface SpotifyPlaylist : NSObject

-(SPTrack *) getCurrentTrack;
-(SPTrack *) getPreviousTrack;
-(SPTrack *) getNextTrack;
-(NSString *) getName;

-(id)initWithSPPlaylist:(SPPlaylist *)playlist;
-(void) prepareQueue:(bool)shuffle;
-(void) prepareQueue:(bool)shuffle withTrackAtIndexFirst:(NSInteger)index;
-(void) setTrackIndex:(NSInteger)index;

@property (nonatomic, readwrite, strong) SPPlaylist *playlist;
@property (nonatomic, readwrite, strong) NSMutableArray *tracks;
@property (nonatomic, readwrite) NSInteger currentTrackIndex;
@property (nonatomic, readwrite, strong) NSMutableArray *queue;

@end
