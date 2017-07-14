//
//  PlayerViewController.m
//  CarControl
//
//  Created by Dan Attali on 12/26/13.
//  Copyright (c) 2013 Dan Attali. All rights reserved.
//

#import "PlayerViewController.h"
#import "AppDelegate.h"
#import "MBProgressHUD.h"
#import <ColorUtils/ColorUtils.h>

@interface PlayerViewController ()

@property NSString *swipeDirection;
@property BOOL coversLoaded;

@end

@implementation PlayerViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.automaticallyAdjustsScrollViewInsets = NO;
        // Custom initialization
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.automaticallyAdjustsScrollViewInsets = NO;
        self.spotifyCovers = [[NSMutableArray alloc] initWithCapacity:1];
        self.coversLoaded = false;
        [self.collectionView setDelegate:self];
        // Custom initialization
    }
    return self;
}

-(void) playPreviousPlaylist {
    AppDelegate *appDelegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    SpotifyPlaylist *playlist = [appDelegate.spotifyManager getPreviousPlaylist];
    if (playlist != nil) {
        [self playOrPauseTrack];
    }
}

-(void) playNextPlaylist {
    AppDelegate *appDelegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    SpotifyPlaylist *playlist = [appDelegate.spotifyManager getNextPlaylist];
    if (playlist != nil) {
        [self playOrPauseTrack];
    }
}

-(void)playOrPauseTrack
{
    AppDelegate *appDelegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    if (appDelegate.spotifyManager.isLogged) {
        [appDelegate.spotifyManager playOrPause];
    } else {
        [self showLogin];
    }
}

-(void)showLogin
{
    UIViewController *spotifyController = [SPLoginViewController loginControllerForSession:[SPSession sharedSession]];
    [self presentViewController:spotifyController animated:false completion:false];
}

-(void) playPause:(UIGestureRecognizer *)recognizer {
    [self playOrPauseTrack];
}

- (void) loadSpotifyCoversForPlaylistAtIndex:(NSInteger)index {
    AppDelegate *appDelegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    SpotifyPlaylist *playlist = [appDelegate.spotifyManager.playlists objectAtIndex:index];
    if (playlist != nil) {
        for (SPTrack *track in playlist.tracks) {
            [track.album.cover startLoading];
        }
    }
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    AppDelegate *appDelegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    if ([keyPath isEqual:@"spotifyManager.playlistReady"]) {
        if(appDelegate.spotifyManager.playlistReady) {
            [self loadSpotifyCoversForPlaylistAtIndex:0];
            [self loadSpotifyCoversForPlaylistAtIndex:1];
            [self.collectionView reloadData];
            [self hideLoadingIndicator];
        }
    }
    
    if ([keyPath isEqual:@"spotifyManager.shuffle"]) {
        [appDelegate.spotifyManager reloadPlaylist];
    }

    if ([keyPath isEqual:@"spotifyManager.playbackManager.trackPosition"]) {
        NSTimeInterval position = appDelegate.spotifyManager.playbackManager.trackPosition;
        SPTrack *track = [appDelegate.spotifyManager currentTrack];
        NSTimeInterval duration = track.duration;
        CGRect bounds = self.view.bounds;
        NSTimeInterval progress = ((position / duration) * bounds.size.width) * 2;
        if (!isnan(progress)) {
            self.progressView.bounds = CGRectMake(bounds.origin.x, 0, progress, self.progressView.bounds.size.height);
        }
        int minutes = floor(position/60);
        int seconds = round(position - minutes * 60);
        self.labelTrackPosition.text = [NSString stringWithFormat:@"%d:%s%d", minutes, (seconds < 10 ? "0" : ""), seconds];
    }
    
    if ([keyPath isEqual:@"spotifyManager.logged"] ||
        [keyPath isEqual:@"spotifyManager.currentPlaylistIndex"] ||
        [keyPath isEqualToString:@"spotifyManager.playlistReady"]) {
        SpotifyPlaylist *playlist = [appDelegate.spotifyManager getCurrentPlaylist];
        if (playlist != nil) {
            self.labelPlaylistName.text = [[playlist getName] uppercaseString];
        }
    }
    if ([keyPath isEqual:@"spotifyManager.logged"] || [keyPath isEqual:@"spotifyManager.currentTrackIndex"]
        || [keyPath isEqual:@"spotifyManager.playlistReady"] || [keyPath isEqual:@"spotifyManager.currentPlaylistIndex"]) {
        SPTrack *track = [appDelegate.spotifyManager currentTrack];
        if (track != nil) {
            self.labelArtistName.text = [track.consolidatedArtists uppercaseString];
            self.labelTrackTitle.text = [track.name uppercaseString];
        }
    }
    
}

- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    return 1;
}

- (NSInteger)numberOfSectionsInCollectionView: (UICollectionView *)collectionView {
    AppDelegate *appDelegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    if(appDelegate.spotifyManager.playlistReady) {
        return [appDelegate.spotifyManager.playlists count];
    }
    
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PlaylistCollectionViewCell *cell = [cv dequeueReusableCellWithReuseIdentifier:@"PlaylistCell" forIndexPath:indexPath];
    AppDelegate *appDelegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    if ([appDelegate.spotifyManager.playlists count] > indexPath.section) {
        [self loadSpotifyCoversForPlaylistAtIndex:indexPath.section];
        [cell loadPlaylistAt:indexPath.section];
    }
    [cell.collectionView setContentOffset:CGPointZero animated:NO];
    
    return cell;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    [self playVisiblePlaylist];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!decelerate) {
        [self playVisiblePlaylist];
    }
}

-(void)playVisiblePlaylist
{
    AppDelegate *appDelegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    if(appDelegate.spotifyManager.playlistReady) {
        for (NSIndexPath *indexPath in [self.collectionView indexPathsForVisibleItems]) {
            if (appDelegate.spotifyManager.currentPlaylistIndex != indexPath.section) {
                [appDelegate.spotifyManager loadPlaylistAt:indexPath.section];
                [appDelegate.spotifyManager playTrackAtIndex:0];
            }
            return;
        }
    }
}

-(void) displayLoadingIndicator
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"Loading playlist";
    hud.labelFont = [UIFont fontWithName:@"HelveticaNeue-CondensedBold" size:16.f];
}

-(void) hideLoadingIndicator
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self displayLoadingIndicator];
    
    [self.collectionView registerClass:[PlaylistCollectionViewCell class] forCellWithReuseIdentifier:@"PlaylistCell"];
    
    AppDelegate *appDelegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];

    [appDelegate addObserver:self forKeyPath:@"spotifyManager.playlistReady" options:NSKeyValueObservingOptionNew context:nil];
    [appDelegate addObserver:self forKeyPath:@"spotifyManager.playbackManager.trackPosition" options:NSKeyValueObservingOptionNew context:nil];
    [appDelegate addObserver:self forKeyPath:@"spotifyManager.shuffle" options:NSKeyValueObservingOptionNew context:nil];
    
    [appDelegate addObserver:self forKeyPath:@"spotifyManager.currentPlaylistIndex" options:NSKeyValueObservingOptionNew context:nil];
    [appDelegate addObserver:self forKeyPath:@"spotifyManager.currentTrackIndex" options:NSKeyValueObservingOptionNew context:nil];
    
    
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(playPause:)];
    doubleTap.numberOfTapsRequired = 2;
    [self.collectionView addGestureRecognizer:doubleTap];
    [self.collectionView setDelegate:self];
    
    
    self.labelArtistName.text = @"";
    self.labelPlaylistName.text = @"";
    self.labelTrackTitle.text = @"";
    self.labelTrackPosition.text = @"";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
