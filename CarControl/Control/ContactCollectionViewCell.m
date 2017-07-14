//
//  ContactCollectionViewCell.m
//  CarControl
//
//  Created by Dan Attali on 1/23/14.
//  Copyright (c) 2014 Dan Attali. All rights reserved.
//

#import "ContactCollectionViewCell.h"
#import <ColorUtils/ColorUtils.h>

@implementation ContactCollectionViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        float bH = self.bounds.size.height*0.7;
        float bY = (self.bounds.size.height - bH) / 2.2;
        CGRect bounds = CGRectMake(self.bounds.origin.x, bY, self.bounds.size.width, bH);
        self.imageView = [[UIImageView alloc] initWithFrame:bounds];
        self.imageView.contentMode = UIViewContentModeScaleAspectFit;
        
        //labelTitle
        float y = self.bounds.size.height - 65;
        float width = self.bounds.size.width * 0.8;
        float x = (self.bounds.size.width - width)/2;
        self.labelTitle = [[UILabel alloc] initWithFrame:CGRectMake(x, y, width, 30)];
        self.labelTitle.textAlignment = NSTextAlignmentCenter;
        self.labelTitle.textColor = [UIColor whiteColor];
        self.labelTitle.shadowColor = [UIColor darkGrayColor];
        self.labelTitle.shadowOffset = CGSizeMake(0, 1);
        self.labelTitle.font = [UIFont fontWithName:@"HelveticaNeue-CondensedBold" size:22.f];
        
        //labelSubtitle
        y = y + 30;
        self.labelSubtitle = [[UILabel alloc] initWithFrame:CGRectMake(x, y, width, 20)];
        self.labelSubtitle.textAlignment = NSTextAlignmentCenter;
        self.labelSubtitle.textColor = [UIColor whiteColor];
        self.labelSubtitle.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:18.f];
        
        [self.contentView addSubview:self.imageView];
        [self.contentView addSubview:self.labelTitle];
        [self.contentView addSubview:self.labelSubtitle];
        
        CAShapeLayer *maskLayer = [CAShapeLayer layer];
        self.imageView.layer.mask = maskLayer;
        self.maskLayer = maskLayer;
        
        CAShapeLayer *circleLayer = [CAShapeLayer layer];
        circleLayer.lineWidth = 8.0;
        circleLayer.fillColor = [[UIColor clearColor] CGColor];
        circleLayer.strokeColor = [[UIColor whiteColor] CGColor];
        [self.imageView.layer addSublayer:circleLayer];
         self.circleLayer = circleLayer;
        
        [self updateCirclePathAtLocation:CGPointMake(self.bounds.size.width / 2.0, self.bounds.size.height / 3.3) radius:self.bounds.size.width * 0.20];
        self.speechSynth = [[AVSpeechSynthesizer alloc] init];
    }
    
    return self;
}

- (void)updateCirclePathAtLocation:(CGPoint)location radius:(CGFloat)radius
{
    self.circleCenter = location;
    self.circleRadius = radius;
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path addArcWithCenter:self.circleCenter
                    radius:self.circleRadius
                startAngle:0.0
                  endAngle:M_PI * 2.0
                 clockwise:YES];
    
    self.maskLayer.path = [path CGPath];
    self.circleLayer.path = [path CGPath];
}

-(void) displayContact:(Contact *)contact
{
    self.contact = contact;
    
    NSString *firstname = contact.firstname != nil ? [contact.firstname uppercaseString] : @"";
    NSString *lastname = contact.lastname != nil ? [contact.lastname uppercaseString] : @"";
    self.labelTitle.text = [NSString stringWithFormat:@"%@ %@", firstname, lastname];
    self.labelSubtitle.text = [NSString stringWithFormat:@"%@: %@", [self.contact.phoneNumberDescription uppercaseString], self.contact.phoneNumber];
    if (contact.avatar != nil) {
        self.imageView.image = contact.avatar;
        self.imageView.center = self.contentView.center;
    } else {
        self.imageView.image = [UIImage imageNamed:@"contact_icon.png"];
    }
}

-(void) displayLoading
{
    self.labelTitle.text = @"LOADING...";
    self.labelSubtitle.text = @"Waiting for Yelp";
    self.imageView.image = nil;
}

-(void) displayPOI:(POI *)poi imageName:(NSString *)imageName
{
    self.poi = poi;    
    self.labelTitle.text = [poi.title uppercaseString];
    self.labelSubtitle.text = poi.address;
    self.imageView.image = [UIImage imageNamed:imageName];
}

-(void) pronounceInformation
{
    if (self.speechSynth.isSpeaking) {
        [self.speechSynth stopSpeakingAtBoundary:AVSpeechBoundaryImmediate];
    }
    NSString *text = self.labelTitle.text;
    AVSpeechUtterance *utterance = [AVSpeechUtterance speechUtteranceWithString:text];
    [utterance setRate:0.1f];
    [self.speechSynth speakUtterance:utterance];
}

-(void) pronounceAction
{
    if (self.speechSynth.isSpeaking) {
        [self.speechSynth stopSpeakingAtBoundary:AVSpeechBoundaryImmediate];
    }
    NSString *text = [NSString stringWithFormat:@"Calling %@", self.labelTitle.text];
    AVSpeechUtterance *utterance = [AVSpeechUtterance speechUtteranceWithString:text];
    [utterance setRate:0.1f];
    [self.speechSynth speakUtterance:utterance];
}

-(void) resizeAvatar
{
    float widthRatio = self.imageView.bounds.size.width / self.imageView.image.size.width;
    float heightRatio = self.imageView.bounds.size.height / self.imageView.image.size.height;
    float scale = MIN(widthRatio, heightRatio);
    NSLog(@"Scale %f", scale);
    float imageWidth = scale * self.imageView.image.size.width;
    float imageHeight = scale * self.imageView.image.size.height;
    self.imageView.frame = CGRectMake(0, 0, imageWidth, imageHeight);
}

-(void) displayFirstViewWith:(NSString *)title :(NSString *)imageName
{
    self.contact = nil;
    self.labelSubtitle.text = @"";
    self.labelTitle.text = [title uppercaseString];
    self.imageView.image = [UIImage imageNamed:imageName];
}

-(void) doAction
{
    if (self.contact != nil) {
        NSString *phoneURLString = [NSString stringWithFormat:@"telprompt://%@", self.contact.phoneNumber];
        phoneURLString = [phoneURLString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        phoneURLString = [phoneURLString stringByReplacingOccurrencesOfString:@" " withString:@""];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneURLString]];
        [self pronounceAction];
    }
}

-(void) setBackgroundColor:(NSString *)backgroundColor
{
    self.contentView.backgroundColor = [UIColor colorWithString:backgroundColor];
}

@end
