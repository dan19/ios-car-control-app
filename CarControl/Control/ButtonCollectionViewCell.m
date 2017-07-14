//
//  ButtonCollectionViewCell.m
//  CarControl
//
//  Created by Dan Attali on 1/20/14.
//  Copyright (c) 2014 Dan Attali. All rights reserved.
//

#import "ButtonCollectionViewCell.h"

@implementation ButtonCollectionViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        float y = self.bounds.size.height - 80;
        float width = self.bounds.size.width;
        self.label = [[UILabel alloc] initWithFrame:CGRectMake(0, y, width, 60)];
        self.label.textAlignment = NSTextAlignmentCenter;
        self.label.textColor = [UIColor whiteColor];
        self.label.shadowColor = [UIColor darkGrayColor];
        self.label.shadowOffset = CGSizeMake(0, 1);
        self.label.font = [UIFont fontWithName:@"HelveticaNeue-CondensedBold" size:22.f];
        
        self.imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        self.imageView.contentMode = UIViewContentModeScaleAspectFit;
        
        self.colorLayerView = [[UIView alloc] initWithFrame:self.bounds];
        self.colorLayerView.alpha = 0.9f;
        
        [self.contentView addSubview:self.colorLayerView];
        [self.contentView addSubview:self.imageView];
        [self.contentView addSubview:self.label];

    }
    
    return self;
}

-(void) setText:(NSString *)text andBackgroundColor:(NSString *)hexColor andImagePath:(NSString *)imagePath
{
    UIColor *backgroundColor = [UIColor colorWithString:hexColor];
    self.colorLayerView.backgroundColor = backgroundColor;
    self.label.text = [text uppercaseString];
    self.imageView.image = [UIImage imageNamed:imagePath];
}


@end
