//
//  SettingsViewController.m
//  CarControl
//
//  Created by Dan Attali on 12/12/13.
//  Copyright (c) 2013 Dan Attali. All rights reserved.
//

#import "SettingsViewController.h"
#import "AppDelegate.h"

@interface SettingsViewController ()

@end

@implementation SettingsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];

    return self;
}

- (IBAction)connectWithSpotify:(id)sender {
    AppDelegate *appDelegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    if (appDelegate.spotifyManager.isLogged) {
        [appDelegate.spotifyManager logout];
    } else {
        UIViewController *loginViewController = [appDelegate.spotifyManager createLoginView];
        [self presentViewController:loginViewController animated:NO completion:nil];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    AppDelegate *appDelegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    if (appDelegate.spotifyManager.isLogged) {
        self.spotifyConnectButton.titleLabel.text = @"Disconnect Spotify";
    } else {
        self.spotifyConnectButton.titleLabel.text = @"Connect Spotify";
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
