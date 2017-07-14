//
//  PlaylistCollectionView.h
//  CarControl
//
//  Created by Dan Attali on 1/8/14.
//  Copyright (c) 2014 Dan Attali. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "TrackCollectionViewCell.h"
#import "UIImageView+Cover.h"

@interface PlaylistCollectionViewCell : UICollectionViewCell <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (readwrite, nonatomic) UICollectionView *collectionView;
@property (readwrite, nonatomic) UICollectionViewFlowLayout *collectionViewFlowLayout;
@property (nonatomic) NSMutableArray *covers;

@property (readwrite, nonatomic) NSInteger playlistIndex;

-(void) setPlaylistCovers:(NSMutableArray *)covers;
-(void) loadPlaylistAt:(NSInteger)index;

@end
