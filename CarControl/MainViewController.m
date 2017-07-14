//
//  MainViewController.m
//  CarControl
//
//  Created by Dan Attali on 12/8/13.
//  Copyright (c) 2013 Dan Attali. All rights reserved.
//

#import "MainViewController.h"
#import "AppDelegate.h"

@implementation MainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    
    return self;
}

-(void) prononceCurrentPlaylist
{
    if (self.speechSynth.isSpeaking) {
        [self.speechSynth stopSpeakingAtBoundary:AVSpeechBoundaryImmediate];
    }
    AppDelegate *appDelegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    SpotifyPlaylist *playlist = [appDelegate.spotifyManager getCurrentPlaylist];
    if (playlist != nil) {
        AVSpeechUtterance *utterance = [AVSpeechUtterance speechUtteranceWithString:playlist.playlist.name];
        [utterance setRate:0.2f];
        //@TODO: set language of the voice
//        AVSpeechSynthesisVoice *voice = [AVSpeechSynthesisVoice voiceWithLanguage:@"fr-FR"];
//        utterance.voice = voice;
        [self.speechSynth speakUtterance:utterance];
    }
}

-(void) loadSharedTrack
{
    AppDelegate *appDelegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    NSString *jsonShare = appDelegate.bluetoothReceiverManager.dataReceived;
    NSError *error = nil;
    NSData *JSONData = [jsonShare dataUsingEncoding:NSUTF8StringEncoding];
    NSObject *share = [NSJSONSerialization JSONObjectWithData:JSONData options:NSJSONReadingAllowFragments error:&error];
    NSLog(@"share received [%@] [%@] [%@]", [share valueForKey:@"trackUrl"], [share valueForKey:@"deviceName"], [share valueForKey:@"displayName"]);
    
    NSURL *url = [[NSURL alloc] initWithString:[share valueForKey:@"trackUrl"]];
    [SPTrack trackForTrackURL:url inSession:[SPSession sharedSession] callback:^(SPTrack *track) {
        NSString *message = [[NSString alloc] initWithFormat:@"%@ wants to share %@", [share valueForKey:@"displayName"], [track name]];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Incomming share" message:message delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Add to queue", nil];
        [alertView show];
        [appDelegate.spotifyManager addToQueue:track];
    }];
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqual:@"bluetoothReceiverManager.dataReceived"]) {
        [self loadSharedTrack];
    }
    if ([keyPath isEqual:@"spotifyManager.logged"] || [keyPath isEqual:@"spotifyManager.currentPlaylistIndex"]) {
        [self prononceCurrentPlaylist];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.speechSynth = [[AVSpeechSynthesizer alloc] init];
    
    AppDelegate *appDelegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    [appDelegate addObserver:self forKeyPath:@"bluetoothReceiverManager.dataReceived" options:NSKeyValueObservingOptionNew context:nil];
    [appDelegate addObserver:self forKeyPath:@"spotifyManager.currentPlaylistIndex" options:NSKeyValueObservingOptionNew context:nil];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
