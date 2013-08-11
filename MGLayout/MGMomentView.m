//
//  MGLayoutSubView.m
//  MGLayout
//
//  Created by Michael Gray on 8/10/13.
//  Copyright (c) 2013 Michael Gray. All rights reserved.
//

#import "MGMomentView.h"
#import <QuartzCore/QuartzCore.h>

#import "UIImageView+UIActivityIndicatorForSDWebImage.h"

@interface MGMomentView ()

@property (nonatomic, weak) UIImageView * imageSubView;


@end

@implementation MGMomentView


- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        UIImageView * subImageView = [[UIImageView alloc] initWithFrame:self.bounds];
        subImageView.contentMode = UIViewContentModeScaleAspectFill;
        [self addSubview:subImageView];
        self.imageSubView = subImageView;
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        UIImageView * subImageView = [[UIImageView alloc] initWithFrame:self.bounds];
        [self addSubview:subImageView];
        self.imageSubView = subImageView;
    }
    return self;
}

- (void)setPictureInfo:(NSDictionary *)pictureInfo
{
    _pictureInfo = pictureInfo;
    
    NSURL * url = _pictureInfo[@"URL"];
    NSAssert(url != nil, @"No URL FOUND!");
    
    [self.imageSubView setImageWithURL:url usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    
    // TODO - load picture from URL now!
}

- (void)prepareForReuse
{
    [self.imageSubView cancelCurrentImageLoad];
}

#pragma mark -- UI Appearance Proxy Properties

- (void)setPhotoShadowColor:(UIColor *)photoShadowColor
{
    self.imageSubView.layer.shadowColor = [photoShadowColor CGColor];
}
- (UIColor*)photoShadowColor
{
    return [UIColor colorWithCGColor:self.imageSubView.layer.shadowColor];
}
- (void)setPhotoShadowOffset:(CGSize)photoShadowOffset
{
    self.imageSubView.layer.shadowOffset = photoShadowOffset;
}
- (CGSize)photoShadowOffset
{
    return self.imageSubView.layer.shadowOffset;
}
- (void)setPhotoShadowOpacity:(CGFloat)photoShadowOpacity
{
    self.imageSubView.layer.shadowOpacity = photoShadowOpacity;
}
-(CGFloat)photoShadowOpacity
{
    return self.imageSubView.layer.shadowOpacity;
}


#pragma mark -- Layout

- (void)setContentInsets:(UIEdgeInsets)contentInsets
{
    if (!UIEdgeInsetsEqualToEdgeInsets(_contentInsets, contentInsets)) {
        _contentInsets = contentInsets;
        [self setNeedsLayout];
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGRect frame = self.bounds;
    
    self.imageSubView.frame = UIEdgeInsetsInsetRect(frame, self.contentInsets);;
    
}

@end
