//
//  MGLayoutView.m
//  MGLayout
//
//  Created by Michael Gray on 8/10/13.
//  Copyright (c) 2013 Michael Gray. All rights reserved.
//

#import "MGLayoutView.h"
#import "MGLayoutFactory.h"
#import "MGLayoutImageView.h"

@interface MGLayoutView ()

@property (nonatomic, strong) MGLayout * layout;


@end

@implementation MGLayoutView


+ (CGSize)sizeForWidth:(CGFloat)width andNumberOfPics:(NSUInteger)pics;
{
    CGFloat gridHeight = [MGLayoutFactory preferredGridHeightThatFitsWithNumberOfPics:pics];
    
    return CGSizeMake(width,width*gridHeight);
}

// the picsArray should ALREADY be in priority Order!
- (id)initWithPicsArray:(NSArray*)picsArray andWidth:(CGFloat)width
{
    NSUInteger numberOfPics = picsArray.count;
    CGSize size = [MGLayoutView sizeForWidth:width andNumberOfPics:numberOfPics];
    
    self = [super initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    if (self)
    {
        self.layout = [MGLayoutFactory findARandomLayoutThatFitWithNumberOfPics:numberOfPics];
        
        [self.layout.rects enumerateObjectsUsingBlock:^(NSValue * rectValue, NSUInteger idx, BOOL *stop) {
            MGLayoutImageView * mg_imageView = [[MGLayoutImageView alloc] initWithFrame:[rectValue CGRectValue]];
            [self addSubview:mg_imageView];
            mg_imageView.pictureInfo = picsArray[idx];
        }];
    }
    return self;
}


@end
