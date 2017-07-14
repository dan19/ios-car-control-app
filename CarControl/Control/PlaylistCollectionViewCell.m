//
//  PlaylistCollectionView.m
//  CarControl
//
//  Created by Dan Attali on 1/8/14.
//  Copyright (c) 2014 Dan Attali. All rights reserved.
//

#import "PlaylistCollectionViewCell.h"

@implementation PlaylistCollectionViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.collectionViewFlowLayout = [[UICollectionViewFlowLayout alloc] init];
        [self.collectionViewFlowLayout setItemSize:self.frame.size];
        self.collectionViewFlowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        [self.collectionViewFlowLayout setSectionInset:UIEdgeInsetsMake(0, 0, 0, 0)];
        
        self.collectionView = [[UICollectionView alloc]initWithFrame:self.bounds collectionViewLayout:self.collectionViewFlowLayout];
        //[self.collectionView setBackgroundColor:[UIColor colorWithRed:221/255.0f green:221/255.0f blue:221/255.0f alpha:1.0f]];
        [self.collectionView setBackgroundColor:[UIColor whiteColor]];
        [self.collectionView setDataSource:self];
        [self.collectionView setDelegate:self];
        [self.collectionView registerClass:[TrackCollectionViewCell class] forCellWithReuseIdentifier:@"TrackCell"];
        [self.collectionView setShowsHorizontalScrollIndicator:NO];
        [self.collectionView setBounces:YES];
        [self.collectionView setAlwaysBounceHorizontal:YES];
        [self.collectionView setScrollEnabled:YES];
        [self.collectionView setPagingEnabled:YES];
        self.collectionView.autoresizesSubviews = 0;
        [self.contentView addSubview:self.collectionView];
        AppDelegate *appDelegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
        [appDelegate addObserver:self forKeyPath:@"spotifyManager.shuffle" options:NSKeyValueObservingOptionNew context:nil];
        [appDelegate addObserver:self forKeyPath:@"spotifyManager.currentTrackIndex" options:NSKeyValueObservingOptionNew context:nil];        
    }
    
    return self;
}

-(void) setPlaylistCovers:(NSMutableArray *)covers
{
    self.covers = covers;
    [self.collectionView reloadData];
}

-(void) loadPlaylistAt:(NSInteger)index
{
    self.playlistIndex = index;
    [self.collectionView reloadData];
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    AppDelegate *appDelegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    if ([keyPath isEqual:@"spotifyManager.shuffle"]) {
        if (appDelegate.spotifyManager.shuffle){
            [self.collectionView setContentOffset:CGPointZero animated:NO];
        }
    } else if ([keyPath isEqual:@"spotifyManager.currentTrackIndex"]) {
//        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:appDelegate.spotifyManager.currentTrackIndex];
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:appDelegate.spotifyManager.currentTrackIndex inSection:0];
        [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredVertically animated:YES];
    }
}

- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    AppDelegate *appDelegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    SpotifyPlaylist *playlist = [appDelegate.spotifyManager getPlaylistAt:self.playlistIndex];
    if (playlist.tracks != nil && [playlist.tracks count] > 0) {
        return [playlist.tracks count];
    }
    
    return 1;
}

- (NSInteger)numberOfSectionsInCollectionView: (UICollectionView *)collectionView {    
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    TrackCollectionViewCell *cell = [cv dequeueReusableCellWithReuseIdentifier:@"TrackCell" forIndexPath:indexPath];
    AppDelegate *appDelegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    SpotifyPlaylist *playlist = [appDelegate.spotifyManager getPlaylistAt:self.playlistIndex];
    if (playlist.queue != nil && [playlist.queue count] > 0 && indexPath.item < [playlist.queue count]) {
        SPTrack *track = [playlist.queue objectAtIndex:indexPath.item];
        SPImage *image = track.album.cover;
        [cell setSpotifyImage:image];
    } else {
        [cell displayNoTrackView];
    }

    return cell;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!decelerate) {
        [self playVisibleTrack];
    }
}

-(void)playVisibleTrack
{
    AppDelegate *appDelegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    if(appDelegate.spotifyManager.playlistReady) {
        for (NSIndexPath *indexPath in [self.collectionView indexPathsForVisibleItems]) {
            NSLog(@"indexPath %d/%d/%d", indexPath.row, indexPath.item, indexPath.section);
            [appDelegate.spotifyManager playTrackAtIndex:indexPath.item];
            return;
        }
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self playVisibleTrack];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(320, 320);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0,0,0,0);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

@end
