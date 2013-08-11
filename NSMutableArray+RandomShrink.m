//
//  NSMutableArray+RandomShrink.m
//  MGLayout
//
//  Created by Michael Gray on 8/10/13.
//  Copyright (c) 2013 Michael Gray. All rights reserved.
//

#import "NSMutableArray+RandomShrink.h"

@implementation NSMutableArray (RandomShrink)


- (id)randomPopFromArray
{
    if (self.count == 0) return nil;
    NSUInteger randomIndex = arc4random() % self.count;
    id value = [self objectAtIndex:randomIndex];
    [self removeObjectAtIndex:randomIndex];
    return value;
}


- (void)randomlyRemoveItemsUntilSize:(NSUInteger)newSize
{
    while (self.count > newSize) {
        [self randomPopFromArray];
    }
}


@end
