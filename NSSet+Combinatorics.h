//originally impementation from https://github.com/tcard/NSSet-Combinatorics
// removed stuff and ported to ARC (mgray)


#import <Foundation/Foundation.h>

@interface NSSet (Combinatorics)

- (NSSet*) combinationsWithRepetitionsOfSize:(NSUInteger)size;

@end
