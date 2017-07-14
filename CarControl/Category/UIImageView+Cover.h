//
//  UIImageView+Cover.h
//  CarControl
//
//  Created by Dan Attali on 1/6/14.
//  Copyright (c) 2014 Dan Attali. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CocoaLibSpotify.h"

@interface UIImageView (Cover)

- (void)setSPImage:(SPImage *)spImage placeholderImage:(UIImage *)placeholder;
- (UIColor *)averageColor;

@end
