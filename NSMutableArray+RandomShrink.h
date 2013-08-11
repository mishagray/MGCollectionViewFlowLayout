//
//  NSMutableArray+RandomShrink.h
//  MGLayout
//
//  Created by Michael Gray on 8/10/13.
//  Copyright (c) 2013 Michael Gray. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableArray (RandomShrink)

- (void)randomlyRemoveItemsUntilSize:(NSUInteger)newSize;

- (id)randomPopFromArray;

@end
