//
//  RFSemiChaoticLayout.h
//  SemiChaotic
//
//  Created by Bryce Redd on 2/19/13.
//  Copyright (c) 2013 Bryce Redd. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RFSemiChaoticLayout;

// at the moment only 1 direction (vertical) is supported
// only the first section of elements will be drawn

@protocol RFSemiChaoticLayoutDelegate <UICollectionViewDelegate>
- (CGRect) chaoticLayout:(RFSemiChaoticLayout*)layout roughFrameForIndexPath:(NSIndexPath*)indexPath;
@end


@interface RFSemiChaoticLayout : UICollectionViewLayout
@property (nonatomic, weak) IBOutlet NSObject<RFSemiChaoticLayoutDelegate>* delegate;
@end

