//
//  SpotifyPlaylistViewController.m
//  CarControl
//
//  Created by Dan Attali on 12/11/13.
//  Copyright (c) 2013 Dan Attali. All rights reserved.
//

#import "SpotifyPlaylistViewController.h"
#import "AppDelegate.h"

@interface SpotifyPlaylistViewController ()

@property NSIndexPath *selectedIndexPath;

@end

@implementation SpotifyPlaylistViewController


- (id)init
{
    self = [super init];
    if (self) {

    }
    return self;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

-(NSArray *)getPlaylists {
    AppDelegate *appDelegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    
    return appDelegate.spotifyManager.playlists;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [[self getPlaylists] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"playlistCell" forIndexPath:indexPath];
    NSInteger index = [indexPath row];
    SpotifyPlaylist *playlist = [[self getPlaylists] objectAtIndex:index];
    cell.textLabel.text = [playlist getName];
    NSInteger count = [playlist.tracks count];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%d songs", count];
    if (count == 0) {
        cell.userInteractionEnabled = false;
    }
    
    
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSLog(@"prepare for segue in playlist [%@]", [segue identifier]);
    AppDelegate *appDelegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    if (indexPath != self.selectedIndexPath) {
        NSInteger index = [indexPath row];
        appDelegate.spotifyManager.currentPlaylistIndex = index;
    }
    self.selectedIndexPath = indexPath;    
    SpotifyTracksViewController *destinationViewController = [segue destinationViewController];
    destinationViewController.spotifyPlaylist = [appDelegate.spotifyManager getCurrentPlaylist];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
