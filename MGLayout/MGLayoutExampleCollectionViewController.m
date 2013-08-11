//
//  MGLayoutExampleCollectionViewController.m
//  MGLayout
//
//  Created by Michael Gray on 8/11/13.
//  Copyright (c) 2013 Michael Gray. All rights reserved.
//

#import "MGLayoutExampleCollectionViewController.h"

#import "MGMomentViewCell.h"
#import "MGMomentHeader.h"
#import "MGFlowLayout.h"


@interface MGLayoutExampleCollectionViewController () <UICollectionViewDelegateFlowLayout>

@end


@implementation MGLayoutExampleCollectionViewController

#pragma mark -- shake detection things


-(BOOL)canBecomeFirstResponder {
    return YES;
}


- (void)shakeDetect
{
    NSLog(@"Shake shake shake");
    
    MGFlowLayout * newLayout = [[MGFlowLayout alloc] init];
    
    newLayout.headerReferenceSize = [(MGFlowLayout*)self.collectionView.collectionViewLayout headerReferenceSize];
    newLayout.footerReferenceSize = [(MGFlowLayout*)self.collectionView.collectionViewLayout footerReferenceSize];
    [self.collectionView setCollectionViewLayout:newLayout animated:YES];
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated {
    [self resignFirstResponder];
    [super viewWillDisappear:animated];
}

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    if (motion == UIEventSubtypeMotionShake)
    {
        [self shakeDetect];
    }
}

- (NSArray*)generateSomeInitialDataForSectionCount:(NSUInteger)sections;{

    
    NSSortDescriptor * sortByPriority = [NSSortDescriptor sortDescriptorWithKey:@"priority" ascending:NO];
    
    NSMutableArray * sectionArray = [NSMutableArray arrayWithCapacity:sections];
    
    for (NSUInteger i=0;i<sections;i++) {

        NSUInteger photos = 4 + (arc4random() % 20);
        NSMutableArray * photoArray = [NSMutableArray arrayWithCapacity:photos];
        
        
        for (NSUInteger p=0;p<photos;p++) {
            
            NSUInteger priority = (arc4random() % 100);
            
            NSString * URL = [NSString stringWithFormat:@"http://dummyimage.com/200.png&text=%d",priority];
        
            [photoArray addObject:@{@"priority" : @(priority),
                                    @"URL" : [NSURL URLWithString:URL] }];
        }
        
       [photoArray sortUsingDescriptors:@[sortByPriority]];
        [sectionArray addObject:photoArray];
    }
    
    return sectionArray;
}


- (NSArray*)arrayOfSectionDataArrays
{
    if (_arrayOfSectionDataArrays == nil) {
        _arrayOfSectionDataArrays = [self generateSomeInitialDataForSectionCount:3];
    }
    
    return _arrayOfSectionDataArrays;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSArray * photoDicts = self.arrayOfSectionDataArrays[section];
    return photoDicts.count;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return self.arrayOfSectionDataArrays.count;
}

- (UICollectionReusableView*)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    MGMomentHeader * header = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:[MGMomentHeader reuseIdentifier] forIndexPath:indexPath];
    
    NSArray * photoDicts = self.arrayOfSectionDataArrays[indexPath.section];
    header.headerLabel.text = [NSString stringWithFormat:@"%d moments",photoDicts.count];
    
    return header;
}

- (UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    MGMomentViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:[MGMomentViewCell cellIdentifier]forIndexPath:indexPath];
    
    NSArray * pictureDicts = self.arrayOfSectionDataArrays[indexPath.section];
    
    cell.momentView.pictureInfo = pictureDicts[indexPath.row];
    
    return cell;
}


@end
