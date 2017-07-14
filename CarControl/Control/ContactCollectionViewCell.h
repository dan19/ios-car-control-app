//
//  ContactCollectionViewCell.h
//  CarControl
//
//  Created by Dan Attali on 1/23/14.
//  Copyright (c) 2014 Dan Attali. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "Contact.h"
#import "POI.h"

@interface ContactCollectionViewCell : UICollectionViewCell

@property (nonatomic, readwrite) UIImageView *imageView;
@property (nonatomic, readwrite) UILabel *labelTitle;
@property (nonatomic, readwrite) UILabel *labelSubtitle;

@property AVSpeechSynthesizer *speechSynth;

@property (nonatomic, readwrite) POI *poi;
@property (nonatomic, readwrite) Contact *contact;
@property (nonatomic, readwrite) NSString *backgroundColor;

@property (nonatomic) CGFloat circleRadius;
@property (nonatomic) CGPoint circleCenter;

@property (nonatomic, weak) CAShapeLayer *maskLayer;
@property (nonatomic, weak) CAShapeLayer *circleLayer;

-(void) displayLoading;
-(void) displayContact:(Contact *)contact;
-(void) displayPOI:(POI *)poi imageName:(NSString *)imageName;
-(void) displayFirstViewWith:(NSString *)title :(NSString *)imageName;
-(void) doAction;

-(void) pronounceInformation;

@end
