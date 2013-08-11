//
//  UIMomentHeader.h
//  MGLayout
//
//  Created by Michael Gray on 8/11/13.
//  Copyright (c) 2013 Michael Gray. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MGMomentHeader : UICollectionReusableView

+ (NSString*)reuseIdentifier;

@property (weak, nonatomic) IBOutlet UILabel *headerLabel;

@end
