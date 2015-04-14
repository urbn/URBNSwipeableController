//
//  UIView+SwiperController.m
//  Pods
//
//  Created by Joseph Ridenour on 4/14/15.
//
//

#import "UIView+SwiperController.h"
#import "URBNSwipeableController.h"
@import QuartzCore.CALayer;

@implementation UIView (SwiperController)

static NSString * kUIViewSwiperControllerKey = @"kUIViewSwiperControllerKey";

- (URBNSwipeableController *)swiperize {
    [self setSwiperController:[URBNSwipeableController swiperCellWithContainer:self]];
    [self.swiperController updateLayout];
    return [self swiperController];
}

- (void)didMoveToSuperview {
    [self.swiperController updateLayout];
}

#pragma mark - Getters 
- (URBNSwipeableController *)swiperController {
    return [self.layer valueForKey:kUIViewSwiperControllerKey];
}

#pragma mark - Setters
- (void)setSwiperController:(URBNSwipeableController *)swiperController {
    [self.layer setValue:swiperController forKey:kUIViewSwiperControllerKey];
}

@end
