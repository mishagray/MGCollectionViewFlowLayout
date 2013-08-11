//
//  MGLayoutView.h
//  MGLayout
//
//  Created by Michael Gray on 8/10/13.
//  Copyright (c) 2013 Michael Gray. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MGLayoutView : UIView


+ (CGSize)sizeForWidth:(CGFloat)width andNumberOfPics:(NSUInteger)pics;

// the picsArray should ALREADY be in priority Order!
- (id)initWithPicsArray:(NSArray*)picsArray andWidth:(CGFloat)width;

@end
