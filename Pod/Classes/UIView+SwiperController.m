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

NSString * const kSwiperControllerBasementDidAppear = @"kSwiperControllerBasementDidAppear";
NSString * const kSwiperControllerBasementDidDisappear = @"kSwiperControllerBasementDidDisappear";

@implementation UIView (SwiperController)

static NSString * kUIViewSwiperControllerKey = @"kUIViewSwiperControllerKey";

- (URBNSwipeableController *)urbn_swiperize {
    
    // Do not swiperize if we're alredy swiperized.
    if (self.urbn_swiperController) {
        return self.urbn_swiperController;
    }
    
    /**
     *  Create our swiperController and assign it to our property.
     */
    URBNSwipeableController *c = [URBNSwipeableController swiperCellWithContainer:self];
    [self setUrbn_swiperController:c];
    return c;
}

// Make sure we relayout when we move to superView.
- (void)didMoveToSuperview {
    [self.urbn_swiperController updateLayout];
}

#pragma mark - Getters 
- (URBNSwipeableController *)urbn_swiperController {
    return [self.layer valueForKey:kUIViewSwiperControllerKey];
}

#pragma mark - Setters
- (void)setUrbn_swiperController:(URBNSwipeableController *)swiperController {
    [self.layer setValue:swiperController forKey:kUIViewSwiperControllerKey];
}

@end
