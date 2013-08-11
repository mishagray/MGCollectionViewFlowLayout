//
//  MGFlowLayout.m
//  MGLayout
//
//  Created by Michael Gray on 8/11/13.
//  Copyright (c) 2013 Michael Gray. All rights reserved.
//

#import "MGFlowLayout.h"
#import "MGLayoutFactory.h"

@interface MGFlowLayout ()

@property (nonatomic,strong) NSMutableArray * layouts;

@property (nonatomic,strong) NSMutableDictionary * headerAttributesByIndexPath;
@property (nonatomic,strong) NSMutableDictionary * footerAttributesByIndexPath;
@property (nonatomic,strong) NSMutableDictionary * itemAttributesByIndexPath;

@property (nonatomic,assign) CGRect contentRect;

@end


@implementation MGFlowLayout



- (void)prepareLayout
{
    [super prepareLayout];
    
    CGRect bounds = self.collectionView.bounds;
    UIEdgeInsets collectionInsets = self.collectionView.contentInset;
    
    CGFloat contentWidth = bounds.size.width - collectionInsets.left - collectionInsets.right;
    CGFloat currentY = 0.0;
    
    NSInteger sections = [self.collectionView.dataSource numberOfSectionsInCollectionView:self.collectionView];
    
    self.itemAttributesByIndexPath = [NSMutableDictionary dictionary];
    self.headerAttributesByIndexPath = [NSMutableDictionary dictionary];
    self.footerAttributesByIndexPath = [NSMutableDictionary dictionary];
    self.layouts = [NSMutableArray arrayWithCapacity:sections];
    
    self.contentRect = CGRectZero;
    for (NSUInteger section=0;section<sections;section++) {
        
        NSUInteger pics = [self.collectionView.dataSource collectionView:self.collectionView numberOfItemsInSection:section];
        
        MGLayout * layout = nil;
        if (self.layouts.count > section) {
            layout = self.layouts[section];
            if (abs(layout.count-pics) > 1) {
                layout = nil;
            }
        }
        if (layout == nil) {
            layout = [MGLayoutFactory findARandomLayoutThatFitWithNumberOfPics:pics];
            self.layouts[section] = layout;
        }
        
        
        id<UICollectionViewDelegateFlowLayout> delegate = (id<UICollectionViewDelegateFlowLayout>) self.collectionView.delegate;
        
        CGSize headerSize = self.headerReferenceSize;
        if ([delegate respondsToSelector:@selector(collectionView:layout:referenceSizeForHeaderInSection:)]) {
            headerSize = [delegate collectionView:self.collectionView layout:self referenceSizeForHeaderInSection:section];
        }
        if (!CGSizeEqualToSize(headerSize, CGSizeZero)) {
            headerSize.width = contentWidth;
            NSIndexPath * sectionPath = [NSIndexPath indexPathForItem:0 inSection:section];
            UICollectionViewLayoutAttributes * headerAttribute = [UICollectionViewLayoutAttributes
                                                                layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader withIndexPath:sectionPath];
            
            CGRect headerRect;
            headerRect.size = headerSize;
            
            CGFloat x = (contentWidth - headerSize.width)/ 2;
            headerRect.origin = CGPointMake(x, currentY);
            headerAttribute.frame = headerRect;
            
            self.headerAttributesByIndexPath[sectionPath] = headerAttribute;
            currentY += headerSize.height;
        }
        
        
        CGFloat gridScale = contentWidth / layout.totalRect.size.width;
        
        for (NSUInteger p=0;p<layout.count;p++) {
            CGRect layoutRect = [layout rectForIndex:p];
            
            CGRect itemFrame = CGRectApplyAffineTransform(layoutRect, CGAffineTransformMakeScale(gridScale, gridScale));
            
            itemFrame.origin.y += currentY;

            
            NSIndexPath * itemIndexPath = [NSIndexPath indexPathForRow:p inSection:section];
            UICollectionViewLayoutAttributes * itemAttribute = [UICollectionViewLayoutAttributes
                                                                layoutAttributesForCellWithIndexPath:itemIndexPath];
            
            itemAttribute.frame = itemFrame;
            
            self.contentRect = CGRectUnion(self.contentRect, itemFrame);
            
            NSLog(@"adding frame %@", NSStringFromCGRect(itemFrame));
            
            self.itemAttributesByIndexPath[itemIndexPath] = itemAttribute;
        }
       
        currentY += (layout.totalRect.size.height * gridScale);
        
        
        CGSize footerSize = self.footerReferenceSize;
        if ([delegate respondsToSelector:@selector(collectionView:layout:referenceSizeForFooterInSection:)]) {
            footerSize = [delegate collectionView:self.collectionView layout:self referenceSizeForFooterInSection:section];
        }
        if (!CGSizeEqualToSize(footerSize, CGSizeZero)) {
            footerSize.width = contentWidth;
            NSIndexPath * sectionPath = [NSIndexPath indexPathForItem:0 inSection:section];
            UICollectionViewLayoutAttributes * footerAttribute = [UICollectionViewLayoutAttributes
                                                                  layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionFooter withIndexPath:sectionPath];
            
            CGRect footerRect;
            footerRect.size = footerSize;
            
            CGFloat x = (contentWidth - footerSize.width)/ 2;
            footerRect.origin = CGPointMake(x, currentY);
            footerAttribute.frame = footerRect;
            
            self.footerAttributesByIndexPath[sectionPath] = footerAttribute;
            currentY += footerSize.height;
        }

    }
}



- (void)finalizeCollectionViewUpdates
{
    [self prepareLayout];
}


- (CGSize)collectionViewContentSize
{
    return self.contentRect.size;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return self.itemAttributesByIndexPath[indexPath];
  
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        return self.headerAttributesByIndexPath[indexPath];
    }
    else {
        return self.footerAttributesByIndexPath[indexPath];
    }
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    return NO;
}

- (NSArray*)layoutAttributesForElementsInRect:(CGRect)rect
{
    
    NSMutableArray * layoutAttributes = [NSMutableArray array];
    
    [self.itemAttributesByIndexPath
            enumerateKeysAndObjectsUsingBlock:^(id key, UICollectionViewLayoutAttributes * itemAttribute, BOOL *stop) {
            if (CGRectIntersectsRect(rect, itemAttribute.frame)) {
                
                [layoutAttributes addObject:itemAttribute];
            }
            }];
    [self.headerAttributesByIndexPath
     enumerateKeysAndObjectsUsingBlock:^(id key, UICollectionViewLayoutAttributes * itemAttribute, BOOL *stop) {
         if (CGRectIntersectsRect(rect, itemAttribute.frame)) {
             
             [layoutAttributes addObject:itemAttribute];
         }
     }];
    [self.footerAttributesByIndexPath
     enumerateKeysAndObjectsUsingBlock:^(id key, UICollectionViewLayoutAttributes * itemAttribute, BOOL *stop) {
         if (CGRectIntersectsRect(rect, itemAttribute.frame)) {
             
             [layoutAttributes addObject:itemAttribute];
         }
     }];
    
    
    return layoutAttributes;
    
}


@end
