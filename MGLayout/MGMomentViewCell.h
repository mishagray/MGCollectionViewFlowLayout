//
//  MGPhotoViewCell.h
//  MGLayout
//
//  Created by Michael Gray on 8/11/13.
//  Copyright (c) 2013 Michael Gray. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MGMomentView.h"

@interface MGMomentViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet MGMomentView *momentView;

+ (NSString*)cellIdentifier;

@end
