//
//  URBNSwipeableController.m
//  Pods
//
//  Created by Joseph Ridenour on 4/14/15.
//
//

#import "URBNSwipeableController.h"

@import UIKit;

/// Notification Keys
static NSString * const kSwiperControllerCloseAllKey = @"kSwiperControllerCloseAllKey";

@interface URBNSwipeableController() <UIScrollViewDelegate, UIGestureRecognizerDelegate>
@property (nonatomic, weak) UIView *container;

@property (nonatomic, strong, readwrite) UIScrollView *scrollView;
@property (nonatomic, strong, readwrite) UIView *scrollContentView;
@property (nonatomic, strong, readwrite) UIView *basementView;

@property (nonatomic, assign) CGPoint startPoint;

@property (nonatomic, assign, readwrite, getter = isShowingBasement) BOOL showingBasement;
@end

@implementation URBNSwipeableController

#pragma mark - Public Methods
+ (instancetype)swiperCellWithContainer:(UIView *)container {
    URBNSwipeableController *cell = [[[self class] alloc] init];
    cell.container = container;
    [cell sharedInit];
    return cell;
}

+ (void)closeBasements {
    [[NSNotificationCenter defaultCenter] postNotificationName:kSwiperControllerCloseAllKey object:self];
}

- (void)openBasementAnimated:(BOOL)animated {
    [self.scrollView setContentOffset:CGPointMake([self basementWidth], 0) animated:animated];
    [self basementDidAppear];
}

- (void)closeBasementAnimated:(BOOL)animated {
    [self.scrollView setContentOffset:CGPointMake(0, 0) animated:animated];
    [self basementDidDisappear];
}

#pragma mark - Init
- (void)sharedInit {
    UIScrollView *sv = [[UIScrollView alloc] initWithFrame:self.container.bounds];
    sv.showsHorizontalScrollIndicator =
    sv.showsVerticalScrollIndicator = NO;
    sv.directionalLockEnabled = YES;
    sv.scrollEnabled = YES;
    sv.delegate = self;
    sv.userInteractionEnabled = self.allowsUserInteractionInScrollView;
    sv.translatesAutoresizingMaskIntoConstraints = NO;
    sv.autoresizesSubviews = YES;
    
    UIView *cv = [[UIView alloc] initWithFrame:sv.bounds];
    cv.autoresizesSubviews = NO;
    cv.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [sv addSubview:cv];
    
    UIView *bv = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100.f, self.container.bounds.size.height)];
    [sv addSubview:bv];
    
    self.basementView = bv;
    self.scrollView = sv;
    self.scrollContentView = cv;
    
    sv.layoutMargins = self.container.layoutMargins;
    self.container.layoutMargins = UIEdgeInsetsZero;
    
    [self moveViewsWithConstraints:self.container toView:cv];
    
    [self.container addSubview:sv];
    NSDictionary *views = NSDictionaryOfVariableBindings(sv, cv, bv);
    [self.container addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[sv]|" options:0 metrics:nil views:views]];
    [self.container addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[sv]|" options:0 metrics:nil views:views]];
    
    [self updateLayout];
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    pan.minimumNumberOfTouches =
    pan.maximumNumberOfTouches = 1;
    pan.delegate = self;
    [self.container addGestureRecognizer:pan];
    self.panGesture = pan;
    
    [self setupNotifications];
}

- (void)setupNotifications {
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateLayout) name:UIDeviceOrientationDidChangeNotification object:[UIDevice currentDevice]];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(closeBasementNotification:) name:kSwiperControllerCloseAllKey object:nil];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Gestures
- (BOOL)gestureRecognizerShouldBegin:(UIPanGestureRecognizer *)gesture {
    CGPoint translation = [gesture translationInView:self.container.superview.superview];
    return (fabs(translation.x) > fabs(translation.y));
}

- (void)handlePan:(UIPanGestureRecognizer *)pan {
    if (self.swiperNoSwiping) {
        return;
    }
    
    CGPoint position = [pan locationInView:self.container];
    switch (pan.state) {
        case UIGestureRecognizerStateBegan: {
            self.startPoint = position;
            [self notifyAllBasementsToClose];
        } break;
            
        case UIGestureRecognizerStateChanged: {
            CGPoint offset = CGPointZero;
            offset.x = MAX((self.startPoint.x - position.x), 0.0f);
            [_scrollView setContentOffset: offset];
        } break;
            
        case UIGestureRecognizerStateEnded: {
            if ( _scrollView.contentOffset.x >= ceilf(self.basementView.frame.size.width / 2.0f) ) {
                [_scrollView setContentOffset: CGPointMake(self.basementView.frame.size.width, 0.0f) animated: YES];
                
            } else {
                [_scrollView setContentOffset: CGPointZero animated:YES];
            }
        } break;
            
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateFailed: {
            [_scrollView setContentOffset: CGPointZero animated: YES];
            _scrollView.userInteractionEnabled = self.allowsUserInteractionInScrollView;
        } break;
            
        default:
            break;
    }
}

#pragma mark - Layout
- (void)updateLayout {
    CGFloat w = CGRectGetWidth(self.container.bounds);
    CGFloat h = CGRectGetHeight(self.container.bounds);
    
    /// Need to reset the insets here incase uiviewController has attempted to
    /// `automaticallyAdjust`
    self.scrollView.contentInset = UIEdgeInsetsZero;
    self.scrollView.frame = CGRectMake(0, 0, w, h);
    self.scrollView.contentSize = CGSizeMake(w + [self basementWidth], h);
    self.basementView.frame = CGRectMake(w, 0, [self basementWidth], h);
    self.scrollContentView.frame = CGRectMake(0, 0, w, h);
}

#pragma mark - Getters / Setters
- (CGFloat)basementWidth {
    // TOOD:  Decide if we ever want to show more/less than the size of our basmentView;
    return self.basementView.frame.size.width;
}

- (void)setSwiperNoSwiping:(BOOL)swiperNoSwiping {
    _swiperNoSwiping = swiperNoSwiping;
    self.scrollView.scrollEnabled = !swiperNoSwiping;
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    
    /// If our contentOffset.x
    if ((*targetContentOffset).x <= [self basementWidth]/2.f) {
        [self closeBasementAnimated:YES];
    } else {
        [self openBasementAnimated:YES];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView.contentOffset.x < 0) {
        // prevent scrolling to the right
        scrollView.contentOffset = CGPointZero;
    }
    else if (scrollView.contentOffset.x == 0) {
        [self closeBasementAnimated:NO];
    }
    else {
        // slide view
        self.basementView.hidden = NO;
        self.basementView.frame = CGRectMake(CGRectGetMaxX(self.scrollContentView.frame),
                                             0.0f,
                                             [self basementWidth],
                                             CGRectGetHeight(self.container.bounds));
    }
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    if (self.scrollView.contentOffset.x == [self basementWidth]) {
        [self basementDidAppear];
    }
    else if (_scrollView.contentOffset.x == 0.f) {
        _basementView.hidden = YES;
        [self basementDidDisappear];
    }
}

#pragma mark - Private Helpers
- (void)notifyAllBasementsToClose {
    [[NSNotificationCenter defaultCenter] postNotificationName:kSwiperControllerCloseAllKey object:self];
}

- (void)closeBasementNotification:(NSNotification *)note {
    if ([note object] == self) {
        return;
    }
    [self closeBasementAnimated:YES];
}

- (void)basementDidDisappear {
    if ([self isShowingBasement]) {
        // From this point the scrollView should take over interactions
        self.showingBasement =
        self.scrollView.userInteractionEnabled = self.allowsUserInteractionInScrollView;
        self.panGesture.enabled = YES;
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kSwiperControllerBasementDidDisappear object:self];
    }
}

- (void)basementDidAppear {
    if (![self isShowingBasement]) {
        [self notifyAllBasementsToClose];
        // From this point the scrollView should take over interactions
        self.showingBasement =
        self.scrollView.userInteractionEnabled = YES;
        self.panGesture.enabled = NO;
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kSwiperControllerBasementDidAppear object:self];
    }
}

- (void)setAllowsUserInteractionInScrollView:(BOOL)allowsUserInteractionInScrollView {
    _allowsUserInteractionInScrollView = allowsUserInteractionInScrollView;
    self.scrollView.userInteractionEnabled = allowsUserInteractionInScrollView;
}

/**
 *  Here we're moving all subviews of @contentView to our @newView, and copying the constraints
 *  for each.
 *
 *  @param contentView The contentView that we want to move the subviews off
 *  @param newView  The new view that all the subviews should be added to
 */
- (void)moveViewsWithConstraints:(UIView *)contentView toView:(UIView *)newView {
    
    NSArray *constraints = [contentView constraints];
    NSMutableArray *newConstraints = [@[] mutableCopy];
    
    for (UIView *view in contentView.subviews) {
        if (view != self.scrollView) {
            for (NSLayoutConstraint *constraint in constraints) {
                
                UIView *firstItem = (UIView *)constraint.firstItem;
                UIView *secondItem = (UIView *)constraint.secondItem;
                
                if (!firstItem || !secondItem) {
                    continue;
                }
                
                if (firstItem == contentView) {
                    firstItem = newView;
                }
                
                if (secondItem == contentView) {
                    secondItem = newView;
                }
                
                // create new constraint
                NSLayoutConstraint *newConstraint = [NSLayoutConstraint constraintWithItem: firstItem
                                                                                 attribute: constraint.firstAttribute
                                                                                 relatedBy: constraint.relation
                                                                                    toItem: secondItem
                                                                                 attribute: constraint.secondAttribute
                                                                                multiplier: constraint.multiplier
                                                                                  constant: constraint.constant];
                newConstraint.priority = constraint.priority;
                [newConstraints addObject: newConstraint];
            }
            
            [view removeFromSuperview];
            [newView addSubview: view];
        }
    }
    
    if (newConstraints.count > 0) {
        [newView addConstraints:newConstraints];
    }
}

@end


@implementation URBNSwipeableController (Convenience)
static NSString * kURBNSwipeableActionKey = @"kURBNSwipeableActionKey";

- (void)addAction:(URBNSwipeableAction *)action {
    [self addAction:action withStyleHandler:nil];
}

- (void)addAction:(URBNSwipeableAction *)action withStyleHandler:(URBNSwipeableActionStyleHandler)handler {
    UIButton *actionButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [actionButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    actionButton.titleLabel.font = [UIFont boldSystemFontOfSize:16.f];
    actionButton.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    [actionButton setTitle:action.title forState:UIControlStateNormal];
    [actionButton.layer setValue:action forKey:kURBNSwipeableActionKey];
    [actionButton addTarget:self action:@selector(urbn_swipeActionHandleEvent:) forControlEvents:UIControlEventTouchUpInside];
    if (handler) {
        handler(actionButton);
    }
    CGRect frame = CGRectMake(0, 0, 200.f, self.basementView.frame.size.height);
    frame.size.width = [actionButton sizeThatFits:CGSizeMake(MAXFLOAT, self.basementView.frame.size.height)].width + actionButton.titleEdgeInsets.left + actionButton.titleEdgeInsets.right;
    actionButton.frame = frame;
    [self.basementView addSubview:actionButton];
    
    CGFloat xOff = 0.f;
    for (UIButton *b in self.basementView.subviews) {
        b.frame = CGRectMake(xOff, 0, b.frame.size.width, self.basementView.frame.size.height);
        xOff = CGRectGetMaxX(b.frame);
    }
    CGRect rect = self.basementView.frame;
    rect.size.width = xOff;
    self.basementView.frame = rect;
    [self updateLayout];
}

#pragma mark - Hanlder
- (void)urbn_swipeActionHandleEvent:(UIButton *)button {
    URBNSwipeableAction *action = [button.layer valueForKey:kURBNSwipeableActionKey];
    if (action.handler) {
        action.handler(action);
    }
}

@end







@implementation URBNSwipeableAction

+ (instancetype)actionWithTitle:(NSString *)title withHandler:(URBNSwipeableActionHandler)handler {
    URBNSwipeableAction *action = [[[self class] alloc] init];
    action.title = title;
    action.handler = handler;
    return action;
}

@end


