//
//  Combinator.h
//  MGLayout
//
//  Created by Michael Gray on 8/9/13.
//  Copyright (c) 2013 Michael Gray. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "MGLayout.h"

@interface MGLayoutFactory : NSObject

+ (MGLayout*)findARandomLayoutThatFitWithNumberOfPics:(NSUInteger)pics;

+ (NSUInteger)preferredGridHeightThatFitsWithNumberOfPics:(NSUInteger)pics;


@end
