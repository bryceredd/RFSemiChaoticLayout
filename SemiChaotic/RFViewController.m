//
//  RFViewController.m
//  SemiChaotic
//
//  Created by Bryce Redd on 2/19/13.
//  Copyright (c) 2013 Bryce Redd. All rights reserved.
//

#import "RFViewController.h"

@interface RFViewController ()
@property (nonatomic) NSMutableArray* numbers;
@end

@implementation RFViewController

int num = 0;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.numbers = [@[] mutableCopy];
    
    for (; num<50; num++) {
        [self.numbers addObject:@(num)];
    }
    
    [self.collectionView reloadData];
}

- (IBAction)remove:(id)sender {
    if(!self.numbers.count) return;
    
    [self.collectionView performBatchUpdates:^{
        int index = arc4random() % self.numbers.count;
        [self.numbers removeObjectAtIndex:index];
        [self.collectionView deleteItemsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]]];
    } completion:nil];
}

- (IBAction)add:(id)sender {
    [self.collectionView performBatchUpdates:^{
        int index = arc4random() % self.numbers.count;
        [self.numbers insertObject:@(++num) atIndex:index];
        [self.collectionView insertItemsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]]];
    } completion:nil];
}

- (UIColor*) colorForNumber:(NSNumber*)num {
    return [UIColor colorWithHue:((19 * num.intValue) % 255)/255.f saturation:1.f brightness:1.f alpha:1.f];
}


#pragma mark - UICollectionView Datasource

- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    return [self.numbers count];
}

- (NSInteger)numberOfSectionsInCollectionView: (UICollectionView *)collectionView {
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [cv dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.backgroundColor = [self colorForNumber:self.numbers[indexPath.row]];
    
    UILabel* label = (id)[cell viewWithTag:5];
    label.text = [NSString stringWithFormat:@"%@", self.numbers[indexPath.row]];
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self remove:nil];
    //[self add:nil];
    /*if(indexPath.row % 2) {
        [self add:nil];
    } else {
        [self remove:nil];
    }*/
}
- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    // TODO: Deselect Item
}


#pragma mark – RFSemiChaoticLayout

- (CGRect)chaoticLayout:(RFSemiChaoticLayout *)layout roughFrameForIndexPath:(NSIndexPath *)indexPath {
    // we're going to make three boxes every 100 px
    return CGRectMake((indexPath.row % 3) * 100, (int)(indexPath.row / 3) * 100, 100, 100);
}

@end
