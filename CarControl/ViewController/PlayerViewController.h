//
//  PlayerViewController.h
//  CarControl
//
//  Created by Dan Attali on 12/26/13.
//  Copyright (c) 2013 Dan Attali. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CocoaLibSpotify.h"
#import "UIImageView+Cover.h"
#import "PlaylistCollectionViewCell.h"
#import "PlaylistCollectionViewFlowLayout.h"

@interface PlayerViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet PlaylistCollectionViewFlowLayout *collectionViewFlowLayout;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIView *progressView;
@property (weak, nonatomic) IBOutlet UILabel *labelTrackTitle;
@property (weak, nonatomic) IBOutlet UILabel *labelArtistName;
@property (weak, nonatomic) IBOutlet UILabel *labelPlaylistName;
@property (weak, nonatomic) IBOutlet UILabel *labelTrackPosition;

@property (nonatomic, strong) NSMutableArray *spotifyCovers;

@end
