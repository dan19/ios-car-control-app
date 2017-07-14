//
//  TrackProgressView.m
//  CarControl
//
//  Created by Dan Attali on 12/18/13.
//  Copyright (c) 2013 Dan Attali. All rights reserved.
//

#import "TrackProgressView.h"

@implementation TrackProgressView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    rect.size.width = 320;
    rect.size.height = 320;
}

@end
