//
//  MGRandomGeneratorController.h
//  MGLayout
//
//  Created by Michael Gray on 8/11/13.
//  Copyright (c) 2013 Michael Gray. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MGRandomGeneratorController : UITableViewController
@property (weak, nonatomic) IBOutlet UISegmentedControl *pictureTypeControl;

@property (weak, nonatomic) IBOutlet UILabel *detailLabel;
@property (weak, nonatomic) IBOutlet UIButton *button;


@end
