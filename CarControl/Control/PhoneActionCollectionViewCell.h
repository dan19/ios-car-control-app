//
//  PhoneActionCollectionViewCell.h
//  CarControl
//
//  Created by Dan Attali on 1/23/14.
//  Copyright (c) 2014 Dan Attali. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "POIQuery.h"

@interface PhoneActionCollectionViewCell : UICollectionViewCell <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (readwrite, nonatomic) UICollectionView *collectionView;
@property (readwrite, nonatomic) UICollectionViewFlowLayout *collectionViewFlowLayout;

@property (readwrite, nonatomic) NSString *cellIdentifier;
@property (readwrite, nonatomic) NSArray *firstViews;
@property (readwrite, nonatomic) NSInteger currentCellIndex;
@property (readwrite, nonatomic) NSIndexPath *parentIndexPath;

@property (readwrite, nonatomic) POIQuery *poiQuery;

-(void) initParentIndexPath:(NSIndexPath *)indexPath;
-(void) setCollectionViewCellClass:(Class)class andIdentifier:(NSString *)identifier;



@end
