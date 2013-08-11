//
//  MGLayoutExampleCollectionViewController.h
//  MGLayout
//
//  Created by Michael Gray on 8/11/13.
//  Copyright (c) 2013 Michael Gray. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MGLayoutExampleCollectionViewController : UICollectionViewController



// looking for an Array for each Section
// Each section is an array of picture dictionaries.
// Each array of picture dictionaries should BE in priority Order already.

@property (nonatomic, strong) NSArray * arrayOfSectionDataArrays;

@end
