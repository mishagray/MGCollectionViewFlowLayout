//
//  MGInitialViewController.m
//  MGLayout
//
//  Created by Michael Gray on 8/11/13.
//  Copyright (c) 2013 Michael Gray. All rights reserved.
//

#import "MGInitialViewController.h"
#import "MGLayoutFactory.h"

@interface MGInitialViewController ()

@property (weak, nonatomic) IBOutlet UIProgressView *progressBar;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;


@end

@implementation MGInitialViewController


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.progressBar setProgress:0.0];
    
    [self performSelectorInBackground:@selector(doLayoutInitialization) withObject:nil];

}


- (void)doLayoutInitialization
{
    for (NSUInteger i=4; i<=100; i++) {
        
        MGLayout * layout = [MGLayoutFactory findARandomLayoutThatFitWithNumberOfPics:i];
        
        NSLog(@"%d layouts for a list of size %d",layout.count, i);
        [self.progressBar setProgress:i/46 animated:YES];
    }
    self.nextButton.hidden = NO;
}

@end
