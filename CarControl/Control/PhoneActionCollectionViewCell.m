//
//  PhoneActionCollectionViewCell.m
//  CarControl
//
//  Created by Dan Attali on 1/23/14.
//  Copyright (c) 2014 Dan Attali. All rights reserved.
//

#import "PhoneActionCollectionViewCell.h"
#import "AppDelegate.h"
#import "ContactCollectionViewCell.h"
#import "POIQuery.h"

@implementation PhoneActionCollectionViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
//        self.backgroundColor = [UIColor whiteColor];
        self.collectionViewFlowLayout = [[UICollectionViewFlowLayout alloc] init];
        [self.collectionViewFlowLayout setItemSize:self.frame.size];
        self.collectionViewFlowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        [self.collectionViewFlowLayout setSectionInset:UIEdgeInsetsMake(0, 0, 0, 0)];
        
        self.collectionView = [[UICollectionView alloc]initWithFrame:self.bounds collectionViewLayout:self.collectionViewFlowLayout];
        //[self.collectionView setBackgroundColor:[UIColor colorWithRed:221/255.0f green:221/255.0f blue:221/255.0f alpha:1.0f]];
        [self.collectionView setBackgroundColor:[UIColor whiteColor]];
        [self.collectionView setDataSource:self];
        [self.collectionView setDelegate:self];
        [self.collectionView setShowsVerticalScrollIndicator:NO];
        [self.collectionView setBounces:YES];
        [self.collectionView setAlwaysBounceVertical:YES];
        [self.collectionView setScrollEnabled:YES];
        [self.collectionView setPagingEnabled:YES];
        self.collectionView.autoresizesSubviews = 0;
        [self.contentView addSubview:self.collectionView];
        
        self.firstViews = [NSArray arrayWithObjects:
                           [NSArray arrayWithObjects: @"Call", @"#F97D75", @"call_icon", @"", nil],
                           [NSArray arrayWithObjects: @"Gas station", @"#74AF96", @"gas_station_icon", @"servicestations", nil],
                           [NSArray arrayWithObjects: @"Parking", @"#AACBE7", @"map_icon", @"parking", nil]
                           ,nil];
        
        [self.collectionView registerClass:[ContactCollectionViewCell class] forCellWithReuseIdentifier:@"ContactCell"];
        
        UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doAction:)];
        doubleTap.numberOfTapsRequired = 2;
        [self.collectionView addGestureRecognizer:doubleTap];
        [self.collectionView setDelegate:self];
    }
    
    return self;
}

-(void) doAction:(UIGestureRecognizer *)recognizer
{
    for (NSIndexPath *indexPath in [self.collectionView indexPathsForVisibleItems]) {
        NSLog(@"indexPath %d/%d/%d", indexPath.row, indexPath.item, indexPath.section);
                
        ContactCollectionViewCell *cell = (ContactCollectionViewCell *)[self getCollectionViewCellWithCollectionView:self.collectionView cellForItemAtIndexPath:indexPath];
        [cell doAction];
        
        return;
    }
}

-(void) setCollectionViewCellClass:(Class)class andIdentifier:(NSString *)identifier
{
    self.cellIdentifier = identifier;
    [self.collectionView registerClass:class forCellWithReuseIdentifier:identifier];
}

-(void) initParentIndexPath:(NSIndexPath *)indexPath
{
    self.parentIndexPath = indexPath;
    [self.collectionView reloadData];
}

- (NSInteger)numberOfSectionsInCollectionView: (UICollectionView *)collectionView {
    int count = 0;
    if (self.parentIndexPath.item == 0) {
        AppDelegate *appDelegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
        count = [appDelegate.contactManager getContactsCount];
    } else {
        if (self.poiQuery != nil && self.poiQuery.results != nil) {
            count = [self.poiQuery.results count];
            NSLog(@"count %d", count);
        } else {
            NSArray *conf = [self.firstViews objectAtIndex:self.parentIndexPath.item];
            NSString *category = [conf objectAtIndex:3];
            [self loadPOIsForCategory:category];
            count = 1;
        }
    }
    
    return count+1;
}

- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ContactCollectionViewCell *cell = (ContactCollectionViewCell *)[self getCollectionViewCellWithCollectionView:cv cellForItemAtIndexPath:indexPath];
    
    [cell pronounceInformation];
    
    return cell;
}

- (UICollectionViewCell *)getCollectionViewCellWithCollectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ContactCollectionViewCell *cell = [cv dequeueReusableCellWithReuseIdentifier:@"ContactCell" forIndexPath:indexPath];
    
    NSArray *conf = [self.firstViews objectAtIndex:self.parentIndexPath.item];
    if (indexPath.section == 0) {
        [cell displayFirstViewWith:[conf objectAtIndex:0] :[conf objectAtIndex:2]];
    } else {
        
        if (self.parentIndexPath.item == 0) {
            AppDelegate *appDelegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
            Contact *contact = [appDelegate.contactManager getContactAtIndex:indexPath.section-1];
            [cell displayContact:contact];
        } else {
            if (self.poiQuery == nil || self.poiQuery.results == nil) {
                [cell displayLoading];
            } else {
                POI *poi = [self.poiQuery.results objectAtIndex:indexPath.section-1];
                [cell displayPOI:poi imageName:[conf objectAtIndex:2]];
            }
        }
    }
    [cell setBackgroundColor:[conf objectAtIndex:1]];
    
    return cell;
}

-(void) loadPOIsForCategory:(NSString *)category
{
    AppDelegate *appDelegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    NSURLRequest *request = [appDelegate.yelpManager getRequestForSearchInCategory:category location:@"Palo Alto"];
    self.poiQuery = [[POIQuery alloc] init];
    [self.poiQuery searchWithNSURLRequest:request];
    [self.poiQuery addObserver:self forKeyPath:@"results" options:NSKeyValueObservingOptionNew context:nil];
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"results"]) {
        NSLog(@" query status = [%d]", self.poiQuery.status);
        if (self.poiQuery.results != nil) {
            [self.collectionView reloadData];
        }
    }
}



@end
