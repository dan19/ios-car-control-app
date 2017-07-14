//
//  ButtonCollectionViewCell.h
//  CarControl
//
//  Created by Dan Attali on 1/20/14.
//  Copyright (c) 2014 Dan Attali. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ColorUtils/ColorUtils.h>

@interface ButtonCollectionViewCell : UICollectionViewCell

@property (nonatomic) UILabel *label;
@property (nonatomic) UIImageView *imageView;
@property (nonatomic) UIView *colorLayerView;

-(void) setText:(NSString *)text andBackgroundColor:(NSString *)hexColor andImagePath:(NSString *)imagePath;

@end
