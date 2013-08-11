//
//  MGPhotoViewCell.m
//  MGLayout
//
//  Created by Michael Gray on 8/11/13.
//  Copyright (c) 2013 Michael Gray. All rights reserved.
//

#import "MGMomentViewCell.h"
#import "UIImageView+UIActivityIndicatorForSDWebImage.h"

@implementation MGMomentViewCell


+ (NSString*)cellIdentifier
{
    return @"MGMomentViewCellIdentifier";
}


- (void)prepareForReuse
{
    [super prepareForReuse];
    [self.momentView prepareForReuse];
}

@end
