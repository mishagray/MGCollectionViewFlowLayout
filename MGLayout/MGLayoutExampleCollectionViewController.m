//
//  MGLayoutExampleCollectionViewController.m
//  MGLayout
//
//  Created by Michael Gray on 8/11/13.
//  Copyright (c) 2013 Michael Gray. All rights reserved.
//

#import "MGLayoutExampleCollectionViewController.h"

#import "MGLayoutFactory.h"
#import "MGMomentViewCell.h"


@interface MGLayoutExampleCollectionViewController () <UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) NSArray * flowOrderedSectionData;
@property (nonatomic, strong) NSArray * sectionLayouts;


@end


@implementation MGLayoutExampleCollectionViewController


- (NSArray*)generateSomeInitialDataForSectionCount:(NSUInteger)sections andPhotoCount:(NSUInteger)photos;
{

    
    NSSortDescriptor * sortByPriority = [NSSortDescriptor sortDescriptorWithKey:@"priority" ascending:NO];
    
    NSMutableArray * sectionArray = [NSMutableArray arrayWithCapacity:sections];
    
    for (NSUInteger i=0;i<sections;i++) {

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

- (void)setupLayoutData
{
    NSMutableArray * sectionLayouts = [NSMutableArray arrayWithCapacity:self.arrayOfSectionDataArrays.count];
    NSMutableArray * flowOrderedSectionData = [NSMutableArray arrayWithCapacity:self.arrayOfSectionDataArrays.count];
    
    for (NSArray * photoArray in self.arrayOfSectionDataArrays) {
        
        MGLayout * layout = [MGLayoutFactory findARandomLayoutThatFitWithNumberOfPics:photoArray.count];
        
        NSAssert(layout != nil, @"Oh no!  ");
        
        [sectionLayouts addObject:layout];
        
        NSMutableArray * flowOrderedPhotos = [NSMutableArray arrayWithCapacity:photoArray.count];
        
        for (NSUInteger i=0;i<layout.count;i++) {
            NSUInteger flowIndex = [layout flowIndexForPriority:i];
            
            NSDictionary * pictureInfo = photoArray[flowIndex];
            [flowOrderedPhotos addObject:pictureInfo];
        }
        
        [flowOrderedSectionData addObject:flowOrderedPhotos];
    }
    
    self.sectionLayouts = sectionLayouts;
    self.flowOrderedSectionData = flowOrderedSectionData;
    
}

- (void)viewWillAppear:(BOOL)animated
{
    if (self.arrayOfSectionDataArrays == nil) {
        self.arrayOfSectionDataArrays = [self generateSomeInitialDataForSectionCount:2 andPhotoCount:12];
    }
    [self setupLayoutData];

}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MGLayout * layout = self.sectionLayouts[indexPath.section];
    
    CGSize gridSize = [layout rectByFlowOrder:indexPath.row].size;
   
    CGFloat gridScale = self.collectionView.bounds.size.width / layout.totalRect.size.width;
    
    CGSize cellSize = CGSizeApplyAffineTransform(gridSize, CGAffineTransformMakeScale(gridScale, gridScale));
    
    return cellSize;
    
}

- (UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    MGMomentViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:[MGMomentViewCell cellIdentifier]forIndexPath:indexPath];
    
    NSArray * flowOrderedPictures = self.flowOrderedSectionData[indexPath.section];
    
    cell.momentView.pictureInfo = flowOrderedPictures[indexPath.row];
    
    return cell;
}


@end
