//
//  MGRandomGeneratorController.m
//  MGLayout
//
//  Created by Michael Gray on 8/11/13.
//  Copyright (c) 2013 Michael Gray. All rights reserved.
//

#import "MGRandomGeneratorController.h"
#import "MGCatGenerator.h"
#import "MGMomentsViewController.h"
#import "NSMutableArray+RandomShrink.h"


@implementation MGRandomGeneratorController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupDetailText];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"Moments"]) {
        MGMomentsViewController * dest = segue.destinationViewController;
        
        dest.arrayOfSectionDataArrays = [self generateSomeInitialDataForSectionCount:7];
        
    }
}


- (NSArray*)generateSomeInitialDataForSectionCount:(NSUInteger)sections
{
    
    NSArray * loremTypes = @[@"abstract",@"animals",@"business",@"cats",@"city",@"food",@"nightlife",@"fashion",@"people",@"nature",@"sports",@"technics",@"transport"];
    
    NSUInteger typeOfPhotos = self.pictureTypeControl.selectedSegmentIndex;
        
    NSMutableArray * sectionArray = [NSMutableArray arrayWithCapacity:sections];
    
    NSUInteger bigPickWidth = (self.view.frame.size.width / 5) * 6.0; // assume retina
    
    for (NSUInteger i=0;i<sections;i++) {
        
        NSUInteger photos = 4 + (arc4random() % 28);
        NSMutableArray * photoArray = [NSMutableArray arrayWithCapacity:photos];
        
 http://lorempixel.com/192/192/cats/p99/
        for (NSUInteger p=0;p<photos;p++) {
            
            NSURL * url = nil;
            
            NSUInteger priority = photos-p;
            switch (typeOfPhotos)
            {
                case 0:
                {
                    NSString * image = [NSString stringWithFormat:@"http://dummyimage.com/%d.png&text=%d",bigPickWidth,priority];
                    url = [NSURL URLWithString:image];
                    break;
                }
                case 1:
                {
                    url = [MGCatGenerator randomAnimatedCatUrl];
                    break;
                }
                case 2:
                    
                {
                    NSString * searchTerm = [loremTypes randomItemFromArray];
//                   NSString * image = [NSString stringWithFormat:@"http://lorempixel.com/%d/%d/%@/priority%d/",bigPickWidth,bigPickWidth,searchTerm,priority];
                    NSString * image = [NSString stringWithFormat:@"http://lorempixel.com/%d/%d/%@/%d",bigPickWidth,bigPickWidth,searchTerm,(arc4random() % 10) + 1];
                    url = [NSURL URLWithString:image];
                    break;
                }
            }
            
            [photoArray addObject:@{@"priority" : @(priority),
                                    @"URL" : url }];
        }
        
        [sectionArray addObject:photoArray];
    }
    
    return sectionArray;
}
- (IBAction)momentTypeSelected:(UISegmentedControl *)sender {
    
    [self setupDetailText];
}

- (void)setupDetailText
{
    NSUInteger typeOfPhotos = self.pictureTypeControl.selectedSegmentIndex;
    switch (typeOfPhotos) {
        case 0: {
            self.detailLabel.text = @"Show the priority number as the photo.";
            [self.button setTitle:@"Show Numbers" forState:UIControlStateNormal];
            break;
        }
        case 1: {
            self.detailLabel.text = @"Who doesn't like cats?";
            [self.button setTitle:@"Show Cats!" forState:UIControlStateNormal];
            break;
        }
        case 2: {
            self.detailLabel.text = @"Lots of boring but good looking moments";
            [self.button setTitle:@"Show Pics!" forState:UIControlStateNormal];
break;
        }
    }

}




@end
