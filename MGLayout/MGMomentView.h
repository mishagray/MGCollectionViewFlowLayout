//
//  MGLayoutSubView.h
//  MGLayout
//
//  Created by Michael Gray on 8/10/13.
//  Copyright (c) 2013 Michael Gray. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MGMomentView : UIView

@property (nonatomic, assign) UIEdgeInsets contentInsets UI_APPEARANCE_SELECTOR;
@property (nonatomic, strong) UIColor * photoShadowColor UI_APPEARANCE_SELECTOR;
@property (nonatomic, assign) CGFloat photoShadowWidth UI_APPEARANCE_SELECTOR;
@property (nonatomic, assign) CGSize photoShadowOffset UI_APPEARANCE_SELECTOR;
@property (nonatomic, assign) CGFloat photoShadowOpacity UI_APPEARANCE_SELECTOR;


@property (nonatomic, strong) NSDictionary * pictureInfo;

// @property (nonatomic, strong) NSURL * urlOfImage;

- (void)prepareForReuse;

@end
