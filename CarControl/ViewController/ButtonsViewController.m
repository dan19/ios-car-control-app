//
//  ButtonsViewController.m
//  CarControl
//
//  Created by Dan Attali on 1/2/14.
//  Copyright (c) 2014 Dan Attali. All rights reserved.
//

#import "ButtonsViewController.h"
#import "AppDelegate.h"
#import "PhoneActionCollectionViewCell.h"

@interface ButtonsViewController ()

@end

@implementation ButtonsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    return 3;
}

- (NSInteger)numberOfSectionsInCollectionView: (UICollectionView *)collectionView {
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    PhoneActionCollectionViewCell *cell = [cv dequeueReusableCellWithReuseIdentifier:@"PhoneActionCell" forIndexPath:indexPath];
    [cell initParentIndexPath:indexPath];
    
    return cell;
}

- (IBAction)shareTrack:(id)sender {
    AppDelegate *appDelegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    if (appDelegate.spotifyManager.isLogged) {
        SPTrack *track = [appDelegate.spotifyManager currentTrack];
        if (track != nil) {
            if (self.bluetoothSenderManager == nil) {
                self.bluetoothSenderManager = [[BluetoothSenderManager alloc] init];
            }
            [self.bluetoothSenderManager send:track];
        }
    }
}

- (IBAction)toggleShuffle:(id)sender {
    AppDelegate *appDelegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    [appDelegate.spotifyManager toggleShuffle];
    
    UIColor *color;
    if (appDelegate.spotifyManager.shuffle) {
        color = [UIColor colorWithRed:0/255.0f green:122/255.0f blue:5/255.0f alpha:1.0f];
    } else {
        color = [UIColor blackColor];
    }
    [self.buttonShuffle setTitleColor:color forState:UIControlStateNormal];
}

- (void) viewWillAppear:(BOOL)animated
{
    UIColor *lightGrayColor = [UIColor colorWithRed:238/255.0f green:238/255.0f blue:238/255.0f alpha:1.0f];
    UIFont *customFont = [UIFont fontWithName:@"FontAwesome" size:34.0f];
    
//    self.view.layer.masksToBounds = NO;
//    self.view.layer.shadowColor = [UIColor grayColor].CGColor;
//    self.view.layer.shadowOffset = CGSizeMake(1, 1);
//    self.view.layer.shadowOpacity = 0.4f;
//    self.view.layer.shadowRadius = 6.0f;
    
    float w = self.view.frame.size.width/3;
    float h = self.view.frame.size.height/2;
    
    self.buttonShare.frame = CGRectMake(-1, -1, w+1, h);
    [self.buttonShare.titleLabel setFont:customFont];
    [self.buttonShare.titleLabel setCenter:CGPointMake(self.buttonShare.titleLabel.center.x, self.buttonShare.titleLabel.center.y-5)];
    [self.buttonShare setTitle:@"\uF064" forState:UIControlStateNormal];
    [self.buttonShare setSubtitle:@"SHARE"];    
    
    self.buttonShuffle.frame = CGRectMake(w-2, -1, w+1, h);
    [self.buttonShuffle.titleLabel setFont:customFont];
    [self.buttonShuffle.titleLabel setCenter:CGPointMake(self.buttonShuffle.titleLabel.center.x, self.buttonShuffle.titleLabel.center.y-5)];
    [self.buttonShuffle setTitle:@"\uF074" forState:UIControlStateNormal];
    [self.buttonShuffle setSubtitle:@"SHUFFLE"];
    
    self.buttonVoice.frame = CGRectMake((w*2)-2, -1, w+2, h);
    [self.buttonVoice.titleLabel setFont:customFont];
    [self.buttonVoice.titleLabel setCenter:CGPointMake(self.buttonVoice.titleLabel.center.x, self.buttonVoice.titleLabel.center.y-5)];
    [self.buttonVoice setTitle:@"\uF0A1" forState:UIControlStateNormal];
    [self.buttonVoice setSubtitle:@"VOICE"];
    
    self.buttonLocation.frame = CGRectMake(-1, h-2, w+1, h+3);
    [self.buttonLocation.titleLabel setFont:customFont];
    [self.buttonLocation.titleLabel setCenter:CGPointMake(self.buttonLocation.titleLabel.center.x, self.buttonLocation.titleLabel.center.y-5)];
    [self.buttonLocation setTitle:@"\uF041" forState:UIControlStateNormal];
    [self.buttonLocation setSubtitle:@"LOCATION"];
    
    self.buttonCall.frame = CGRectMake(w-2, h-2, w+1, h+3);
    [self.buttonCall.titleLabel setFont:customFont];
    [self.buttonCall.titleLabel setCenter:CGPointMake(self.buttonCall.titleLabel.center.x, self.buttonCall.titleLabel.center.y-5)];
    [self.buttonCall setTitle:@"\uF095" forState:UIControlStateNormal];
    [self.buttonCall setSubtitle:@"CALL"];
    
    self.buttonGPS.frame = CGRectMake((w*2)-2, h-2, w+2, h+3);
    [self.buttonGPS.titleLabel setFont:customFont];
    [self.buttonGPS.titleLabel setCenter:CGPointMake(self.buttonGPS.titleLabel.center.x, self.buttonGPS.titleLabel.center.y-5)];
    [self.buttonGPS setTitle:@"\uF124" forState:UIControlStateNormal];
    [self.buttonGPS setSubtitle:@"GPS"];
    
    self.buttonShare.layer.borderWidth = 1.0f;
    self.buttonShare.layer.borderColor = lightGrayColor.CGColor;
    self.buttonShuffle.layer.borderWidth = 1.0f;
    self.buttonShuffle.layer.borderColor = lightGrayColor.CGColor;
    self.buttonVoice.layer.borderWidth = 1.0f;
    self.buttonVoice.layer.borderColor = lightGrayColor.CGColor;
    self.buttonLocation.layer.borderWidth = 1.0f;
    self.buttonLocation.layer.borderColor = lightGrayColor.CGColor;
    self.buttonCall.layer.borderWidth = 1.0f;
    self.buttonCall.layer.borderColor = lightGrayColor.CGColor;
    self.buttonGPS.layer.borderWidth = 1.0f;
    self.buttonGPS.layer.borderColor = lightGrayColor.CGColor;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.buttons = @{@"Gas station" : [NSArray arrayWithObjects: @"#74AF96", @"gas_station_icon", nil], //79CB8C
                     @"Navigation" : [NSArray arrayWithObjects: @"#AACBE7", @"map_icon", nil], //#7fd2eb
                     @"Call" : [NSArray arrayWithObjects: @"#F97D75", @"call_icon", nil] //EC4574
                     };
    
    [self.collectionView registerClass:[PhoneActionCollectionViewCell class] forCellWithReuseIdentifier:@"PhoneActionCell"];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
