//
//  TrackCollectionViewCell.h
//  CarControl
//
//  Created by Dan Attali on 1/14/14.
//  Copyright (c) 2014 Dan Attali. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImageView+Cover.h"

@interface TrackCollectionViewCell : UICollectionViewCell

@property (nonatomic) UIImageView *imageView;
@property (nonatomic) UILabel *label;
@property (nonatomic) UIView *noTrackView;

-(void) setSpotifyImage:(SPImage *)spImage;
-(void) displayNoTrackView;

@end
