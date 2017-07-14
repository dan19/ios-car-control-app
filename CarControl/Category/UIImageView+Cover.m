//
//  UIImageView+Cover.m
//  CarControl
//
//  Created by Dan Attali on 1/6/14.
//  Copyright (c) 2014 Dan Attali. All rights reserved.
//

#import "UIImageView+Cover.h"
#import "UIImageView+LBBlurredImage.h"

@implementation UIImageView (Cover)


- (void)setSPImage:(SPImage *)spImage placeholderImage:(UIImage *)placeholder
{
    if (spImage.isLoaded) {
        self.image = spImage.image;
        [self blurImage];
    } else {
        self.image = placeholder;
        [spImage startLoading];
        [spImage addObserver:self forKeyPath:@"loaded" options:NSKeyValueObservingOptionNew context:nil];
    }
}

- (void)setSPImage:(SPImage *)spImage
{
    if (spImage.isLoaded) {
        self.image = spImage.image;
        [self blurImage];
    } else {
        [spImage addObserver:self forKeyPath:@"loaded" options:NSKeyValueObservingOptionNew context:nil];
    }
}

-(void) blurImage {
    [self setImageToBlur:self.image blurRadius:1.0 completionBlock:^(NSError *error){
        NSLog(@"The blurred image has been setted");
    }];
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqual:@"loaded"]) {
        SPImage *spImage = object;
        self.image = spImage.image;
        [self blurImage];
    }
}

- (UIColor *)averageColor {
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    unsigned char rgba[4];
    CGContextRef context = CGBitmapContextCreate(rgba, 1, 1, 8, 4, colorSpace, kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    
    CGContextDrawImage(context, CGRectMake(0, 0, 1, 1), self.image.CGImage);
    CGColorSpaceRelease(colorSpace);
    CGContextRelease(context);
    
    if(rgba[3] > 0) {
        CGFloat alpha = ((CGFloat)rgba[3])/255.0;
        CGFloat multiplier = alpha/255.0;
        return [UIColor colorWithRed:((CGFloat)rgba[0])*multiplier
                               green:((CGFloat)rgba[1])*multiplier
                                blue:((CGFloat)rgba[2])*multiplier
                               alpha:alpha];
    }
    else {
        return [UIColor colorWithRed:((CGFloat)rgba[0])/255.0
                               green:((CGFloat)rgba[1])/255.0
                                blue:((CGFloat)rgba[2])/255.0
                               alpha:((CGFloat)rgba[3])/255.0];
    }
}

@end
