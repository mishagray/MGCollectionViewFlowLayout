#import "NSSet+Combinatorics.h"

@implementation NSSet (Combinatorics)


- (NSSet*) combinationsWithRepetitionsOfSize:(NSUInteger)size {
	if (size == 0) return [NSSet setWithObject:[NSCountedSet set]];
	if ([self count] == 0) return self;
	
    NSNumber * head = nil;
    for (NSNumber * val in self) {
        if (head == nil) {
            head = val;
        }
        else if ([val compare:head] == NSOrderedDescending) {
            head = val;
        }
    }
    
	NSMutableSet* tail = [[NSMutableSet alloc] initWithSet:self];
	[tail removeObject:head];
	
	NSMutableSet* subSet = [[NSMutableSet alloc] initWithSet:[self combinationsWithRepetitionsOfSize:(size - 1)]];
	
	for (NSCountedSet* i in subSet) {
		[i addObject:head];
	}
	
	[subSet unionSet:[tail combinationsWithRepetitionsOfSize:size]];
    
    NSSet * retVal = [[NSSet alloc] initWithSet:subSet];
	
	return retVal;
}

@end
