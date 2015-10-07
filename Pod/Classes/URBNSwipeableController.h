//
//  URBNSwipeableController.h
//  Pods
//
//  Created by Joseph Ridenour on 4/14/15.
//
//

@import Foundation;
@import UIKit;

#import "UIView+SwiperController.h"
#import "URBNSwipeableCollectionViewCell.h"
#import "URBNSwipeableTableViewCell.h"


@class URBNSwipeableAction;

@interface URBNSwipeableController : NSObject

@property (nonatomic, strong, readonly) UIScrollView *scrollView;
@property (nonatomic, strong, readonly) UIView *scrollContentView;
@property (nonatomic, strong, readonly) UIView *basementView;
@property (nonatomic, assign, readwrite) BOOL allowsUserInteractionInScrollView;

/**
 *  Used by swipeable controller when opening the drawer
 */
@property (nonatomic, strong) UIPanGestureRecognizer *panGesture;

/**
 *  If set to `YES`, swiping will not be allowed.
 *  Defaults: NO
 */
@property (nonatomic, assign) BOOL swiperNoSwiping;

/**
 *  This is just a storage component to help with performance.   Use it to determine if you
 *  need to setup your basement or not.
 */
@property (nonatomic, assign, getter = isBasementConfigured) BOOL basementConfigured;

@property (nonatomic, assign, readonly, getter = isShowingBasement) BOOL showingBasement;

/**
 *  Create a new swiper controller using the given view.
 */
+ (instancetype)swiperCellWithContainer:(UIView *)container;
+ (void)closeBasements;
- (void)openBasementAnimated:(BOOL)animated;
- (void)closeBasementAnimated:(BOOL)animated;
- (void)updateLayout;

@end


typedef void(^URBNSwipeableActionStyleHandler)(UIButton *handler);
@interface URBNSwipeableController (Convenience)

- (void)addAction:(URBNSwipeableAction *)action;
- (void)addAction:(URBNSwipeableAction *)action withStyleHandler:(URBNSwipeableActionStyleHandler)handler;

@end



/**
 *  This can be used for easy setup of the basementView.   Using
 *  these actions will give an effect similar to UITableViewRowAction's
 */
typedef void(^URBNSwipeableActionHandler)(URBNSwipeableAction *action);
@interface URBNSwipeableAction : NSObject

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) URBNSwipeableActionHandler handler;
- (void)setHandler:(URBNSwipeableActionHandler)handler;

+ (instancetype)actionWithTitle:(NSString *)title withHandler:(URBNSwipeableActionHandler)handler;

@end