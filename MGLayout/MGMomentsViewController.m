//
//  MGLayoutExampleCollectionViewController.m
//  MGLayout
//
//  Created by Michael Gray on 8/11/13.
//  Copyright (c) 2013 Michael Gray. All rights reserved.
//

#import "MGMomentsViewController.h"

#import "MGMomentViewCell.h"
#import "MGMomentHeader.h"
#import "MGCollectionViewFlowLayout.h"
#import "MGCatGenerator.h"


@interface MGMomentsViewController () <UICollectionViewDelegateFlowLayout>


@property (weak, nonatomic) IBOutlet UILabel *navigationBarLabel;
@property (nonatomic, assign) BOOL shouldShake;
@property (nonatomic, assign) BOOL hasShaken;

@end


@implementation MGMomentsViewController

#pragma mark -- shake detection things


-(BOOL)canBecomeFirstResponder {
    return YES;
}


- (void)shakeDetect
{
    NSLog(@"Shake shake shake");
    self.hasShaken = YES;
    self.navigationBarLabel.alpha = 1.0;
    self.navigationBarLabel.text = @"Thanks For Shaking";
    self.navigationBarLabel.textColor = [UIColor blackColor];
    
    MGCollectionViewFlowLayout * newLayout = [[MGCollectionViewFlowLayout alloc] init];
    
    newLayout.headerReferenceSize = [(MGCollectionViewFlowLayout*)self.collectionView.collectionViewLayout headerReferenceSize];
    newLayout.footerReferenceSize = [(MGCollectionViewFlowLayout*)self.collectionView.collectionViewLayout footerReferenceSize];
    [self.collectionView setCollectionViewLayout:newLayout animated:YES completion:^(BOOL finished) {
    }];
    
    
}

- (void)checkForShake
{
    if (!self.hasShaken) {
        self.navigationBarLabel.text = @"SHAKE ME!!!";
        
        self.shouldShake = YES;
        
        self.navigationBarLabel.hidden = NO;
        [UIView animateWithDuration:1.0 animations:^{
            self.navigationBarLabel.alpha = 0.0;
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:1.0 animations:^{
                self.navigationBarLabel.alpha = 1.0;
            } completion:^(BOOL finished) {
                [self performSelectorOnMainThread:@selector(checkForShake) withObject:nil waitUntilDone:NO];
            }];
        }];
    }
}


- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(    NSTimeInterval)duration {
    [super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
    [self.collectionView reloadData];
}


-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self becomeFirstResponder];
    
    
    [NSTimer scheduledTimerWithTimeInterval:10.0 target:self selector:@selector(checkForShake) userInfo:nil repeats:NO];
}

- (void)viewWillDisappear:(BOOL)animated {
    [self resignFirstResponder];
    [super viewWillDisappear:animated];
}

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    if (motion == UIEventSubtypeMotionShake)
    {
        [self shakeDetect];
    }
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSArray * photoDicts = self.arrayOfSectionDataArrays[section];
    return photoDicts.count;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return self.arrayOfSectionDataArrays.count;
}

- (UICollectionReusableView*)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    MGMomentHeader * header = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:[MGMomentHeader reuseIdentifier] forIndexPath:indexPath];
    
    NSArray * photoDicts = self.arrayOfSectionDataArrays[indexPath.section];
    header.headerLabel.text = [NSString stringWithFormat:@"%d moments",photoDicts.count];


    return header;
}

- (UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    MGMomentViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:[MGMomentViewCell cellIdentifier]forIndexPath:indexPath];
    
    NSArray * pictureDicts = self.arrayOfSectionDataArrays[indexPath.section];
    
    cell.momentView.pictureInfo = pictureDicts[indexPath.row];
    
    return cell;
}


@end
