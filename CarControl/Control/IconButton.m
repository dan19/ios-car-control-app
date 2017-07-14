//
//  IconButton.m
//  CarControl
//
//  Created by Dan Attali on 1/2/14.
//  Copyright (c) 2014 Dan Attali. All rights reserved.
//

#import "IconButton.h"

@interface IconButton()

@property (nonatomic, readwrite) UILabel *subtitleLabel;

@end

@implementation IconButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

-(void) setSubtitle:(NSString *)title
{
    if (self.subtitleLabel == nil) {
        NSLog(@"button height [%f]", self.bounds.size.height);
        self.subtitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.bounds.size.width, 20)];
        [self.subtitleLabel setFont:[UIFont fontWithName:@"Helvetica" size:11]];
        [self.subtitleLabel setTextColor:[UIColor grayColor]];
        [self.subtitleLabel setTextAlignment:NSTextAlignmentCenter];
        [self addSubview:self.subtitleLabel];
        [self.subtitleLabel setCenter:CGPointMake(self.bounds.size.width/2, self.bounds.size.height-20)];
    }
    self.subtitleLabel.text = title;
}

@end
