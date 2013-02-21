//
//  RFSemiChaoticLayout.m
//  SemiChaotic
//
//  Created by Bryce Redd on 2/19/13.
//  Copyright (c) 2013 Bryce Redd. All rights reserved.
//

#import "RFSemiChaoticLayout.h"

@interface RFSemiChaoticLayout()
@property(nonatomic) NSMutableDictionary* rects;
@end

@implementation RFSemiChaoticLayout


#pragma mark uicollectionviewlayout methods

- (void) prepareLayout {
    [super prepareLayout];
    if(!self.rects) self.rects = [@{} mutableCopy];
    
    [self findAHomeForAll];
}

- (void) invalidateLayout {
    [super invalidateLayout];
    //self.rects = [@[] mutableCopy];
}

- (CGSize)collectionViewContentSize {
    [self findAHomeForAll];
    
    float maxHeight = 0;
    for(NSNumber* index in self.rects) {
        NSValue* rectValue = self.rects[index];
        maxHeight = MAX(maxHeight, CGRectGetMaxY([rectValue CGRectValue]));
    }
    return CGSizeMake(self.collectionView.frame.size.width, maxHeight);
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSMutableArray* array = [@[] mutableCopy];
    
    [self findAHomeForAll];
    
    for(NSNumber* index in [self.rects copy]) {
        NSValue* rectValue = self.rects[index];
        
        if(CGRectIntersectsRect([rectValue CGRectValue], rect)) {
            [array addObject:[self layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForRow:index.intValue inSection:0]]];
        }
    }
    return array;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    [self findAHomeForIndexPath:indexPath];
    
    UICollectionViewLayoutAttributes* attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    attributes.frame = [self.rects[@(indexPath.row)] CGRectValue];
    return attributes;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    BOOL res = !(CGSizeEqualToSize(newBounds.size, self.collectionView.frame.size));
    
    // new bounds = new randomness
    if(res) self.rects = [@{} mutableCopy];
    
    return res;
}


#pragma mark private methods

- (void) findAHomeForAll {
    for(int i=0; i<[self.collectionView numberOfItemsInSection:0]; i++) {
        [self findAHomeForIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
    }
}

- (void) findAHomeForIndexPath:(NSIndexPath*)path {
    CGRect frame = [self.delegate chaoticLayout:self roughFrameForIndexPath:path];
    CGRect rect = [self.rects[@(path.row)] CGRectValue];
    
    if(CGSizeEqualToSize(frame.size, rect.size) || self.rects[@(path.row)]) return;
    
    self.rects[@(path.row)] = [NSValue valueWithCGRect:[self placeOriginOfRect:frame]];
}

- (CGRect) placeOriginOfRect:(CGRect)rect {
    // we're going to do a three tiers of randomness
    // 1. within 100px
    // 2. within 300px
    // 3. within 500px
    //
    // 4 tries each
    
    for(NSNumber* range in @[@(.2), @(.5), @(1)]) {
        for(int i=0; i<5; i++) {
            float y = (float)arc4random()/UINT_MAX;
            float x = (float)arc4random()/UINT_MAX;
            
            CGRect attempt = CGRectMake(floorf(x * (self.collectionView.frame.size.width - rect.size.width)),
                                        floorf(rect.origin.y + (y * range.floatValue * self.collectionView.frame.size.width)),
                                        rect.size.width, rect.size.height);
            
            if([self rectIsOk:attempt])
                return attempt;
        }
    }
    
    NSLog(@"COULD NOT FIND ANY DECENT PLACE FOR CELL!");
    
    return CGRectZero;
}

- (BOOL) rectIsOk:(CGRect)rect {
    for(NSNumber* index in self.rects) {
        NSValue* rectValue = self.rects[index];
        if(CGRectIntersectsRect(rect, [rectValue CGRectValue]))
            return NO;
    }
    return YES;
}


@end
