//
//  MGLayout.h
//  MGLayout
//
//  Created by Michael Gray on 8/10/13.
//  Copyright (c) 2013 Michael Gray. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface MGLayout : NSObject

// this is the total CGRect we are trying to cover;
@property (nonatomic, assign) CGRect totalRect;
// this is the current total area currently covered by rects.
@property (nonatomic, assign) CGFloat areaCovered;
@property (nonatomic, readonly) CGFloat areaUncovered;


@property (nonatomic, readonly) NSUInteger count;


+ (MGLayout*)layoutWithCGRect:(CGRect)rect;

- (id)initWithCGRect:(CGRect)rect;

- (BOOL)isPointCoveredInGrid:(CGPoint)point;
- (BOOL)canRectFitInLayout:(CGRect)rectToCheck;
- (BOOL)isTotallyCovered;

- (void)addRectToLayout:(CGRect)rect;

- (CGPoint)firstUnconveredPoint;
- (CGRect)firstUnconveredRectOfSize:(CGSize)size;

- (MGLayout*)mutableCopy;

- (void)appendLayout:(MGLayout*)layout;

- (void)sortRectsBySizeAndLayout;

- (MGLayout*)flippedHorizontally;
- (MGLayout*)flippedVertically;
- (MGLayout*)flippedHorizontallyAndVertically;

- (CGRect)rectForIndex:(NSUInteger)n;


@end
