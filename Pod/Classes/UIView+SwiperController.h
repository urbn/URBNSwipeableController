//
//  UIView+SwiperController.h
//  Pods
//
//  Created by Joseph Ridenour on 4/14/15.
//
//

#import <UIKit/UIKit.h>

@class URBNSwipeableController;

extern NSString * const kSwiperControllerBasementDidAppear;
extern NSString * const kSwiperControllerBasementDidDisappear;

@interface UIView (SwiperController)

/**
 *  A reference to the swiperController if view is swiperized
 */
@property (nonatomic, strong, readonly) URBNSwipeableController *urbn_swiperController;

/**
 *  Call this on any view to swiperize it
 */
- (URBNSwipeableController *)urbn_swiperize;

@end
