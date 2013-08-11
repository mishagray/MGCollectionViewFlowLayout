//
//  MGLayout.m
//  MGLayout
//
//  Created by Michael Gray on 8/10/13.
//  Copyright (c) 2013 Michael Gray. All rights reserved.
//

#import "MGLayout.h"

const BOOL DO_LOGIC_ASSERTIONS = false;

@interface MGLayoutRect : NSObject

@property (nonatomic, assign) CGRect rect;


- (id)initWithCGRect:(CGRect)rect;

@end


@implementation MGLayoutRect

-(id)initWithCGRect:(CGRect)rect
{
    self = [super init];
    if (self) {
        self.rect = rect;
    }
    return self;
}

- (NSString*)description
{
    return [NSString stringWithFormat:@"MGLayoutRect:{%@}", NSStringFromCGRect(self.rect)];
}

@end


@interface MGLayout ()

// this is the current rects that have been applied to the layout so far.
@property (nonatomic, strong) NSMutableArray * layoutRects;
// a 2D array of BOOLS.
// will flip as we layout Rects.
@property (nonatomic, strong) NSMutableArray * rows;

@end

@implementation MGLayout


+ (MGLayout*)layoutWithCGRect:(CGRect)rect
{
    return [[MGLayout alloc] initWithCGRect:rect];
}
- (id)init
{
    self = [super init];
    if (self) {
        _totalRect = CGRectZero;
    }
    return self;
    
}


- (id)initWithCGRect:(CGRect)rect
{
    
    self = [super init];
    if (self) {
        self.totalRect = rect;
    }
    return self;
}

- (NSArray*)layoutRects
{
    if (_layoutRects == nil) {
        _layoutRects = [NSMutableArray array];
    }
    return _layoutRects;
}

- (void)resizeRowsIfNeededForRect:(CGRect)rect
{
    for (NSUInteger i = 0; i < rect.size.height;i++)
    {
        NSMutableArray * pointsInRow;
        if (i >= _rows.count) {

            pointsInRow = [NSMutableArray arrayWithCapacity:rect.size.width];
            [_rows addObject:pointsInRow];
        }
        else {
            pointsInRow = _rows[i];
        }
        while (pointsInRow.count < rect.size.width) {
            [pointsInRow addObject:@(NO)];
        }
    }
    
}

- (NSArray*)rows
{
    if (_rows == nil) {
        NSUInteger height = self.totalRect.size.height;
        _rows = [NSMutableArray arrayWithCapacity:height];
        [self resizeRowsIfNeededForRect:self.totalRect];
    }
    return _rows;
}

- (void)_copyValuesFrom:(MGLayout*)mgLayout
{
    self.layoutRects = mgLayout.layoutRects.mutableCopy;
    self.rows = [NSMutableArray arrayWithCapacity:mgLayout.rows.count];
    for (NSUInteger i = 0; i < mgLayout.rows.count;i++) {
        NSMutableArray * column = mgLayout.rows[i];
        [_rows addObject:column.mutableCopy];
    }
    self.areaCovered = mgLayout.areaCovered;
    
}
- (MGLayout*)mutableCopy
{
    MGLayout * copy = [[MGLayout alloc] initWithCGRect:self.totalRect];
    [copy _copyValuesFrom:self];
    return copy;
}

- (void)appendLayout:(MGLayout *)layout
{
    CGFloat currentHeight = self.totalRect.size.height;
    
    CGRect totalRectToAppend = layout.totalRect;
    totalRectToAppend.origin.y += currentHeight;
    
    self.totalRect = CGRectUnion(self.totalRect, totalRectToAppend);
    
    for (MGLayoutRect * layoutRect in layout.layoutRects) {
        
        CGRect rectToAppend = layoutRect.rect;
        rectToAppend.origin.y += currentHeight;
        
        [self addRectToLayout:rectToAppend];
    };
    
    [self sortRectsBySizeAndLayout];
}


- (BOOL)isPointCoveredInGrid:(CGPoint)point
{
    NSUInteger row = point.y;
    NSUInteger column = point.x;
    NSArray * columnRow = self.rows[row];
    return [columnRow[column] boolValue];
}

- (void)coverPointInGrid:(CGPoint)point
{
//    NSLog(@"covering %@", NSStringFromCGPoint(point));
    NSUInteger row = point.y;
    NSUInteger column = point.x;
    if (row >= self.rows.count) {
        [self resizeRowsIfNeededForRect:self.totalRect];
    }
    NSMutableArray * columnRow = self.rows[row];
    if (column < columnRow.count) {
        [self resizeRowsIfNeededForRect:self.totalRect];
    }
    if (DO_LOGIC_ASSERTIONS) {
        BOOL currentValue = [columnRow[column] boolValue];
        NSAssert(currentValue == false, @"TRYING TO COVER TWICE!");
    }
    columnRow[column] = @(YES);
}

- (BOOL)canRectFitInLayout:(CGRect)rectToCheck
{
    NSAssert(!CGRectIsEmpty(rectToCheck), @"rect can't be zero sized");
    
    NSUInteger width = rectToCheck.size.width;
    NSUInteger height = rectToCheck.size.height;
    
    CGRect rectThatFits = CGRectIntersection(rectToCheck, self.totalRect);
    if (!CGRectEqualToRect(rectThatFits, rectToCheck))
        return FALSE;
    
    for (NSUInteger i=0;i<width;i++) {
        for (NSUInteger j=0;j<height;j++) {
            CGPoint pointToCheck = rectToCheck.origin;
            pointToCheck.x += i;
            pointToCheck.y += j;
            BOOL covered = [self isPointCoveredInGrid:pointToCheck];
            if (covered)
                return FALSE;
        }
    }
    return TRUE;
}

- (void)coverRectInGrid:(CGRect)rectToCover
{
    NSAssert(!CGRectIsEmpty(rectToCover), @"rect can't be zero sized");
    
    NSUInteger width = rectToCover.size.width;
    NSUInteger height = rectToCover.size.height;
    
    for (NSUInteger i=0;i<width;i++) {
        for (NSUInteger j=0;j<height;j++) {
            CGPoint pointToCover = rectToCover.origin;
            pointToCover.x += i;
            pointToCover.y += j;
            [self coverPointInGrid:pointToCover];
        }
    }
}

- (void)addRectToLayout:(CGRect)rect
{
//    NSLog(@"addRectToLayout %@", NSStringFromCGRect(rect));
    
    CGRect newRect = CGRectUnion(_totalRect, rect);
    if (!CGRectEqualToRect(newRect, _totalRect)) {
        self.totalRect = newRect;
        [self resizeRowsIfNeededForRect:newRect];
    }
    
    [self coverRectInGrid:rect];
    MGLayoutRect * layoutRect = [[MGLayoutRect alloc] initWithCGRect:rect];
    [self.layoutRects addObject:layoutRect];
    self.areaCovered += (rect.size.width * rect.size.height);
    
}

- (CGFloat)areaUncovered
{
    return (self.totalRect.size.width*self.totalRect.size.height) - self.areaCovered;
}

- (BOOL)isTotallyCovered
{
    return (self.areaUncovered == 0.0);
}

- (CGPoint)firstUnconveredPoint
{
    CGPoint currentPoint;
    for (NSUInteger x=0; x<self.totalRect.size.width; x++) {
        for (NSUInteger y=0;y<self.totalRect.size.height;y++) {
            currentPoint = CGPointMake(x, y);
            if (![self isPointCoveredInGrid:currentPoint]) {
                return currentPoint;
            }
        }
    }
    return currentPoint;
}

- (CGRect)firstUnconveredRectOfSize:(CGSize)size
{
    CGRect currentRect;
    for (NSUInteger x=0; x<self.totalRect.size.width; x++) {
        for (NSUInteger y=0;y<self.totalRect.size.height;y++) {
            currentRect = CGRectMake(x, y, size.width, size.height);
            BOOL canFit = [self canRectFitInLayout:currentRect];
            if (canFit) {
                return currentRect;
            }
        }
    }
    return CGRectNull;
}


- (NSArray*)sortLayoutRectsBySize
{
    NSArray * sortedBySizeLayoutRects = [self.layoutRects sortedArrayUsingComparator:^NSComparisonResult(MGLayoutRect * layoutRect1, MGLayoutRect * layoutRect2) {
        
        CGRect rect1 = CGRectStandardize(layoutRect1.rect);
        CGRect rect2 = CGRectStandardize(layoutRect2.rect);
        
        // we want the largest size rects to go first, so we invert rect1 and rect2 to compare
        NSComparisonResult comparison = [@(rect2.size.width) compare: @(rect1.size.width)];
        
        if (comparison == NSOrderedSame) {
            comparison = [@(rect1.origin.y) compare: @(rect2.origin.y)];
        }
        if (comparison == NSOrderedSame) {
            comparison = [@(rect1.origin.x) compare: @(rect2.origin.x)];
            
        }
        return comparison;
        
    }];
    
    return sortedBySizeLayoutRects;
}

- (NSArray*)sortLayoutRectsByFlowOrder
{
    NSArray * sortedBySizeLayoutRects = [self.layoutRects sortedArrayUsingComparator:^NSComparisonResult(MGLayoutRect * layoutRect1, MGLayoutRect * layoutRect2) {
        
        CGRect rect1 = CGRectStandardize(layoutRect1.rect);
        CGRect rect2 = CGRectStandardize(layoutRect2.rect);
        
        // we want the largest size rects to go first, so we invert rect1 and rect2 to compare
        NSComparisonResult comparison = [@(rect1.origin.y) compare: @(rect2.origin.y)];
        if (comparison == NSOrderedSame) {
            comparison = [@(rect1.origin.x) compare: @(rect2.origin.x)];
            
        }
        return comparison;
        
    }];
    
    return sortedBySizeLayoutRects;
}



- (void)sortRectsBySizeAndLayout
{
    self.layoutRects = [self sortLayoutRectsBySize].mutableCopy;
}

- (CGRect)rectForIndex:(NSUInteger)n
{
    MGLayoutRect * layout = self.layoutRects[n];
    return layout.rect;
}


- (NSUInteger)count
{
    return self.layoutRects.count;
}

- (MGLayout*)flippedHorizontally
{
    MGLayout * newLayout = [MGLayout layoutWithCGRect:self.totalRect];
    
    CGFloat height = self.totalRect.size.height;
    
    for (MGLayoutRect * layoutRect in self.layoutRects) {
        CGRect oldRect = layoutRect.rect;
        CGRect newRect = oldRect;
        newRect.origin.y = height - oldRect.origin.y;
        newRect.size.height = -oldRect.size.height;
        [newLayout addRectToLayout:CGRectStandardize(newRect)];
    };
    
    [newLayout sortRectsBySizeAndLayout];
    return newLayout;
}

- (MGLayout*)flippedVertically
{
    MGLayout * newLayout = [MGLayout layoutWithCGRect:self.totalRect];
    
    CGFloat width = self.totalRect.size.width;
    
    for (MGLayoutRect * layoutRect in self.layoutRects) {
        CGRect oldRect = layoutRect.rect;
        CGRect newRect = oldRect;
        newRect.origin.x = width - oldRect.origin.x;
        newRect.size.width = -oldRect.size.width;
        [newLayout addRectToLayout:CGRectStandardize(newRect)];
    };
    
    [newLayout sortRectsBySizeAndLayout];
    return newLayout;
}

- (MGLayout*)flippedHorizontallyAndVertically
{
    MGLayout * newLayout = [MGLayout layoutWithCGRect:self.totalRect];
    
    CGFloat width = self.totalRect.size.width;
    CGFloat height = self.totalRect.size.height;
    
    for (MGLayoutRect * layoutRect in self.layoutRects) {
        CGRect oldRect = layoutRect.rect;
        CGRect newRect = oldRect;
        newRect.origin.x = width - oldRect.origin.x;
        newRect.size.width = -oldRect.size.width;
        newRect.origin.y = height - oldRect.origin.y;
        newRect.size.height = -oldRect.size.height;
        [newLayout addRectToLayout:CGRectStandardize(newRect)];
    };
    
    [newLayout sortRectsBySizeAndLayout];
    return newLayout;
}


@end
