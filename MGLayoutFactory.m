//
//  Combinator.m
//  MGLayout
//
//  Created by Michael Gray on 8/9/13.
//  Copyright (c) 2013 Michael Gray. All rights reserved.
//

#import "MGLayoutFactory.h"
#import "NSSet+Combinatorics.h"
#import "MGLayout.h"
#import "NSMutableArray+RandomShrink.h"

@implementation MGLayoutFactory


/////  MG Layout Factory!

// So we are going to take a list of pictures of size (pic)
// the list will be broken up into 3 potential "grid" sizes of 3x3, 2x2, and 1x1
// then we will try and squeeze all of these photos into a rectangle of grid size 5xn ,
//       where n is the height of the rectangle.

// So for any given is of pics X, there is only gonna be so many potential sizes.
// NOTE this is a potentially ombinatorial explosive algorithm!  Computing the potential combinations can be expensive.
// Don't try this for lists greater pics than MAX_COMPUTABLE_LAYOUT_SIZE or so.
// If you have a bigger list than MAX_COMPUTABLE_LAYOUT_SIZE, then it will be broken into smaller layouts and those layouts will be appended together.


// So first we are going to generate potential set of Rects.
// They must fit in a grid-width of 5.
// we are next going to look at the set of sizes we see and see if we can get a good balance of 3x3 vs 2x2
// then we will try and compute the layouts for those sets of sizes.

static const NSUInteger MAX_COMPUTABLE_LAYOUT_SIZE = 18;
static const NSUInteger GOOD_COMPUTABLE_SIZE_LAYOUT = 8;
static NSMutableDictionary * s_scoredCombinationsCache = nil;

+ (void) initialize
{
    s_scoredCombinationsCache = [NSMutableDictionary dictionary];
}

+ (MGLayout*)searchForLayoutInCombination:(NSCountedSet*)combination tries:(NSUInteger)tries
{
    NSUInteger countForThreeByThree = [combination countForObject:@(3)];
    NSUInteger countForTwoByTwo = [combination countForObject:@(2)];
    NSUInteger countForOneByOne = [combination countForObject:@(1)];
    
    NSUInteger areaOfRectangle = (countForThreeByThree * 9) + (countForTwoByTwo * 4) + countForOneByOne;
    CGFloat heightOfRectangle = areaOfRectangle / 5.0;
    MGLayout * layout = [self randomLayoutForCombination:combination inRect:CGRectMake(0,0,5.0,heightOfRectangle) tries:tries];
    
   switch (arc4random() % 4) {
        case 0:
            [layout sortRectsBySizeAndLayout];
            break;
        case 1:
            layout = [layout flippedHorizontally];
            break;
        case 2:
            [layout = layout flippedVertically];
            break;
        case 3:
            layout = [layout flippedHorizontallyAndVertically];
            break;
    }
    return layout;
}

+ (MGLayout*)findARandomLayoutThatFitWithNumberOfPics:(NSUInteger)pics
{
    NSAssert(pics >= 4, @"Small layouts don't exist yet!");
    if (pics > MAX_COMPUTABLE_LAYOUT_SIZE) {
        
        NSUInteger bottomSize = pics-MAX_COMPUTABLE_LAYOUT_SIZE;
        if (bottomSize < 4) {
            bottomSize = GOOD_COMPUTABLE_SIZE_LAYOUT;
        }
        NSUInteger topSize = pics-bottomSize;
        MGLayout * top = [self findARandomLayoutThatFitWithNumberOfPics:topSize];
        MGLayout * bottom = [self findARandomLayoutThatFitWithNumberOfPics:bottomSize];
        
        [top appendLayout:bottom];
        
        // we need to set the combination in the cache so we can pre-compute the sizes of Cells without generating the layouts again.;
        NSCountedSet * highestScoringCachedCombination = s_scoredCombinationsCache[@(pics)];
        if (highestScoringCachedCombination != nil) {
            NSCountedSet * topCombination = s_scoredCombinationsCache[@(topSize)];
            NSCountedSet * bottomCombination = s_scoredCombinationsCache[@(topSize)];
            [topCombination unionSet:bottomCombination];
            s_scoredCombinationsCache[@(pics)] = topCombination;
        }

        return top;
    }
    else {

        NSCountedSet * highestScoringCachedCombination = s_scoredCombinationsCache[@(pics)];
        if (highestScoringCachedCombination != nil) {
            return [self searchForLayoutInCombination:highestScoringCachedCombination tries:4];
        }
        NSDictionary * scoredCombinations = [self computeScoredCombinationsThatMayFitWithNumberOfPics:pics];
            
        NSArray * keys = [[scoredCombinations allKeys] sortedArrayUsingSelector:@selector(compare:)];

        for (NSNumber * score in keys) {
            NSCountedSet * combination = scoredCombinations[score];
            MGLayout * layout = [self searchForLayoutInCombination:combination tries:1];
            if (layout != nil) {
                s_scoredCombinationsCache[@(pics)] = combination;
                return layout;
            }
        }
        MGLayout * layout = [self findARandomLayoutThatFitWithNumberOfPics:pics-1];
        s_scoredCombinationsCache[@(pics)] = s_scoredCombinationsCache[@(pics-1)];
        return layout;
    }
}

+ (NSUInteger)preferredGridHeightThatFitsWithNumberOfPics:(NSUInteger)pics
{
    NSCountedSet * highestScoringCachedCombination = s_scoredCombinationsCache[@(pics)];
    if (highestScoringCachedCombination != nil) {
        CGRect rectForCombination = [self rectForCombination:highestScoringCachedCombination];
        return rectForCombination.size.height;
    }
    MGLayout * layout = [self findARandomLayoutThatFitWithNumberOfPics:pics];
    return layout.totalRect.size.height;
}


+ (CGRect)rectForCombination:(NSCountedSet*)combination
{
    NSUInteger countForThreeByThree = [combination countForObject:@(3)];
    NSUInteger countForTwoByTwo = [combination countForObject:@(2)];
    NSUInteger countForOneByOne = [combination countForObject:@(1)];

    NSUInteger areaOfRectangle = (countForThreeByThree * 9) + (countForTwoByTwo * 4) + countForOneByOne;
    
    NSUInteger heightOfRectangle = areaOfRectangle / 5;

    return CGRectMake(0, 0, 5.0, heightOfRectangle);
}

// Now we will compute a set of combinations for a given set of picture Sizes.
// We can't use ALL Combinations.  Just those that MIGHT fit in a 5xN rectangle.
// Some combinations will still fail to fit.

+ (NSDictionary*)computeScoredCombinationsThatMayFitWithNumberOfPics:(NSUInteger)pics
{
    if (pics < 4) return nil;  // This logic only works for numbers of pics greater than 3
    
    NSLog(@"combinations building for size %d", pics);
    NSSet * combinations = [[NSCountedSet setWithArray:@[@3,@2,@1]] combinationsWithRepetitionsOfSize:pics];
    
    NSMutableDictionary * scored_combinations = [NSMutableDictionary dictionaryWithCapacity:combinations.count];
    
    NSLog(@"raw combinations = %d", combinations.count);
	for (NSCountedSet* i in combinations) {
        
        NSUInteger countForThreeByThree = [i countForObject:@(3)];
        NSUInteger countForTwoByTwo = [i countForObject:@(2)];
        NSUInteger countForOneByOne = [i countForObject:@(1)];
        
        NSAssert((countForThreeByThree+countForTwoByTwo+countForOneByOne) == pics, @"this is a bad combination!");
        
        NSUInteger areaOfRectangle = (countForThreeByThree * 9) + (countForTwoByTwo * 4) + countForOneByOne;
        
        NSUInteger areaModFive = areaOfRectangle % 5;
        
        // always try and use at least one nice big photo (3x3).
        // also always try and use a 2x2.   These layouts will look nicer.
        
        // These two conditions are going to lead to MORE unsolveable lists of pics but that's ok.
        //  We will start throwing away photos if that's the case.
        
        // And fit us into a 5xN rectangle, so the area better be a muliple of 5. (Not a guarantee of success)
        
        if ((countForThreeByThree > 0) && (countForTwoByTwo > 0) && (areaModFive == 0))
                // this COULD be a set that could be assembled in a 5 x N rectangle.
        {
            NSUInteger heightOfRectangle = areaOfRectangle / 5;
            NSUInteger heightOfStackOfThreeByThrees = countForThreeByThree * 3;
            
            // first see if a stack of 3x3 will fit in this rectangle.
            if (heightOfStackOfThreeByThrees <= heightOfRectangle) {
                
                // If the 3x3 fits, than see if we can fit the 2x2 also.
                NSUInteger numberOfTwoByTwosThatWillStillFit = (heightOfRectangle / 2) + ((heightOfRectangle - heightOfStackOfThreeByThrees) / 2);
                
                if (countForTwoByTwo <= numberOfTwoByTwosThatWillStillFit) {
                    
                    // Now let's "score" the combination.  Some combos will look better than others
                    // We don't want too many 1x1s etc.
                    
                    CGFloat minBig = MIN(countForThreeByThree,countForTwoByTwo);
                    CGFloat maxBig = MAX(countForThreeByThree,countForTwoByTwo);

                    // about we want a good ratio of 2x2 to 3x3.  With as few OneByOnes
                    CGFloat scoreRatio = minBig / maxBig;
                    CGFloat score = (minBig * scoreRatio);
                    
                    scored_combinations[@(score)] = i;
                }
            }
        }
	}
    NSLog(@"combinations %d found for size %d", scored_combinations.count,pics);
    // so SOME numbers (like 7?) don't give us any layouts.  So drop lets find a layout with one less pic (we will end up throwing away the worst priority photo.
    if (scored_combinations.count == 0) {
        return [self computeScoredCombinationsThatMayFitWithNumberOfPics:pics-1];
    }
    return scored_combinations;
}


// Let's take a combination and try to randomly draw inside it.
//

+ (MGLayout*)randomLayoutForCombination:(NSCountedSet*)combination inRect:(CGRect)rect tries:(NSUInteger)tries
{
    NSUInteger countForThreeByThree = [combination countForObject:@(3)];
    NSUInteger countForTwoByTwo = [combination countForObject:@(2)];
    NSUInteger countForOneByOne = [combination countForObject:@(1)];
    
    
    NSLog(@"{3x3:%d,2x2:%d,1x1:%d} heigoweht %f", countForThreeByThree, countForTwoByTwo, countForOneByOne, rect.size.height);
    
    //  I suppose we don't have to compute ALL the 3x3s, but if we start using different 3x3 layouts we may need to be flexible about some that cause the 2x2s to not fit).  So try a few layouts.  (They are cheap to make).
    
    NSMutableArray * initialLayouts = [self layoutsWithJustTheThreeByThrees:countForThreeByThree forFiveByNRect:rect];
    
    while ((tries > 0) && initialLayouts.count > 0) {

        MGLayout * randomLayout = [initialLayouts randomPopFromArray];
        MGLayout * foundLayout = [self randomized_DFS_ForlayoutsByAddingRestOfCombination:combination toLayout:randomLayout];
        if (foundLayout != nil) {
            [foundLayout sortRectsBySizeAndLayout];
            return foundLayout;
        }
    }
    return nil;
    
}


// now take a take N number of threeByThrees and a 5xN CGRect and generate all the layouts for just the 3x3s.
// but we want to ALTERNATE the X origin for 3x3 to either 0 or 2.
// it also will help reduce chance of hitting a dead end (It avoids some layout issues where 2x2 can't fit).

// TODO: Should we try flowing the 3x3s from right, to middle, to left, to middle to right????  That might look ok too, but increases the chance of failing to find a layout.

// we will layout from the bottom up.  (This lets us do recursive stuff without changing origin values around).

+ (NSMutableArray*)layoutsWithJustTheThreeByThrees:(NSUInteger)numberOfThreeByThrees forFiveByNRect:(CGRect)fiveByNRect {
    if (numberOfThreeByThrees == 0) {
        return nil;
    }
    
    NSAssert(fiveByNRect.size.height >= 3.0, @"can't fit in this rectangle!");
    
    CGRect layoutArea = fiveByNRect;
    if (numberOfThreeByThrees > 1) // let's chop off the top of the rect. and compute all the potential positions of the bottom 3x3 rect.
    {
        NSUInteger threeByThreesAboveBottomRect = numberOfThreeByThrees-1;
        CGFloat minHeightAboveBottomRect = threeByThreesAboveBottomRect * 3.0;
        layoutArea.origin.y += minHeightAboveBottomRect;
        layoutArea.size.height -= minHeightAboveBottomRect;
    }
    
    NSUInteger numberOfLayouts = layoutArea.size.height - 2.0;
    NSMutableArray * arrayOfLayouts = [NSMutableArray arrayWithCapacity:numberOfLayouts];
    
    // let's just try either the right and left sides.
    // later we will randomly flip these computed layouts around for variety.
    CGFloat xValue = (numberOfThreeByThrees % 2) ? 0.0 : 2.0;
    for (NSInteger i=0;i<numberOfLayouts;i++) {
        CGRect positionOfRect = CGRectMake(xValue, layoutArea.origin.y + i, 3.0, 3.0);
        
        if (numberOfThreeByThrees == 1) {
            MGLayout * mgLayout = [MGLayout layoutWithCGRect:fiveByNRect];
            [mgLayout addRectToLayout:positionOfRect];
            [arrayOfLayouts addObject:mgLayout];
        }
        else if (numberOfThreeByThrees > 1) {
            CGRect rectAboveThisRect = fiveByNRect;
            rectAboveThisRect.size.height = positionOfRect.origin.y;
            NSArray * layoutsAboveThisRect = [self layoutsWithJustTheThreeByThrees:numberOfThreeByThrees-1 forFiveByNRect:rectAboveThisRect];
            
            for (MGLayout * layout in layoutsAboveThisRect) {
                MGLayout * newLayout = layout.mutableCopy;
                newLayout.totalRect = fiveByNRect;
                [newLayout addRectToLayout:positionOfRect];
                [arrayOfLayouts addObject:newLayout];
            }
        }
        
    }
    return arrayOfLayouts;
}



// so now we have an MGLayout with some rects on it, and we need to add TwoByTwos and OneByOnes.
// each uncovered spot can be covered by either a OneByOne OR a twoByTwo;
// so let's just try and add one or the other type of rect as we go.

+ (MGLayout*)randomized_DFS_ForlayoutsByAddingRestOfCombination:(NSCountedSet*)combination toLayout:(MGLayout*)layout
{
    NSUInteger countForOneByOne = [combination countForObject:@(1)];
    NSUInteger countForTwoByTwo = [combination countForObject:@(2)];
    
    if ((countForOneByOne + countForTwoByTwo) == 0) {
        NSAssert(layout.isTotallyCovered, @"The rect should be covered");
        return layout;
    }
    MGLayout * result = nil;
    
    // So if we still have two small pic types,
    // find the next available unconvered spot and randonly attempt to put a 1x1 or 2x2.
    // if one fails try the other.
    // this is basically a "randomized" DFS algoritithm.
    if ((countForOneByOne > 0) && (countForTwoByTwo > 0)) {
        
        CGPoint firstEmptyBlock = [layout firstUnconveredPoint];

        NSUInteger size = ((arc4random() % 2) == 0) ? 1 : 2;
        CGRect rectToAdd = CGRectMake(firstEmptyBlock.x, firstEmptyBlock.y, size, size);
        result = [self DFS_forLayoutByTryingToAddingCGRect:rectToAdd toLayout:layout withCombination:combination];
        
        if (result == nil) {
            NSUInteger newSize = (size == 1) ? 2 : 1;
            rectToAdd.size.width = rectToAdd.size.height = newSize;
            return [self DFS_forLayoutByTryingToAddingCGRect:rectToAdd toLayout:layout withCombination:combination];
        }
    }
    else if (countForTwoByTwo > 0) {
        // TODO : This could probably done without going recursive.  It's Sunday night so I'm not gonna fix it.
        
        result = [self DFS_forLayoutByAddingNextUncoveredRectWithSide:2 toLayout:layout withCombination:combination];
    }
    else if (countForOneByOne > 0) {
        // TODO : This could probably done without going recursive.  It's Sunday night so I'm not gonna fix it.
        result = [self DFS_forLayoutByAddingNextUncoveredRectWithSide:1 toLayout:layout withCombination:combination];
    }
    
    return result;
}

+ (MGLayout*)DFS_forLayoutByAddingNextUncoveredRectWithSide:(NSUInteger)size toLayout:(MGLayout*)layout withCombination:(NSCountedSet*)combination
{
    CGRect rectToAdd = [layout firstUnconveredRectOfSize:CGSizeMake(size, size)];
    if (CGRectIsNull(rectToAdd)) {
        return nil;
    }
    MGLayout * newLayout = layout.mutableCopy;
    [newLayout addRectToLayout:rectToAdd];
    
    NSCountedSet * newCombination = combination.mutableCopy;
    [newCombination removeObject:@(size)];
    
    return [self randomized_DFS_ForlayoutsByAddingRestOfCombination:newCombination toLayout:newLayout];
}

+ (MGLayout*)DFS_forLayoutByTryingToAddingCGRect:(CGRect)rectToAdd toLayout:(MGLayout*)layout withCombination:(NSCountedSet*)combination
{
    BOOL canFit = [layout canRectFitInLayout:rectToAdd];
    if (!canFit) {
        return nil;
    }
    MGLayout * newLayout = layout.mutableCopy;
    [newLayout addRectToLayout:rectToAdd];
    
    NSCountedSet * newCombination = combination.mutableCopy;
    NSUInteger size = rectToAdd.size.width;
    [newCombination removeObject:@(size)];
    
    return [self randomized_DFS_ForlayoutsByAddingRestOfCombination:newCombination toLayout:newLayout];
}


@end
