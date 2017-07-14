//
//  TrackCollectionViewCell.m
//  CarControl
//
//  Created by Dan Attali on 1/14/14.
//  Copyright (c) 2014 Dan Attali. All rights reserved.
//

#import "TrackCollectionViewCell.h"

@implementation TrackCollectionViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //self.backgroundColor = [UIColor colorWithRed:221/255.0f green:221/255.0f blue:221/255.0f alpha:1.0f];
        self.backgroundColor = [UIColor whiteColor];
        self.imageView = [[UIImageView alloc] initWithFrame:self.bounds];
//        self.imageView.image = [UIImage imageNamed:@"spotify-logo.png"];
        
        [self.contentView addSubview:self.imageView];
    }
    return self;
}

-(void) setSpotifyImage:(SPImage *)spImage
{
    [self.imageView setSPImage:spImage placeholderImage:[UIImage imageNamed:@"spotify-logo.png"]];
}

-(void) displayNoTrackView
{
    self.imageView.image = [UIImage imageNamed:@"spotify-logo.png"];
}

@end
