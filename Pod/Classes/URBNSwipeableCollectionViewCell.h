//
//  URBNSwipeableCollectionViewCell.h
//  Pods
//
//  Created by Joseph Ridenour on 4/14/15.
//
//

#import <UIKit/UIKit.h>
#import "URBNSwipeableController.h"

@interface URBNSwipeableCollectionViewCell : UICollectionViewCell

- (void)sharedInit;

- (URBNSwipeableController *)swipeController;

@end
