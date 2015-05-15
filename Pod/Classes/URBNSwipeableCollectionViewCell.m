//
//  URBNSwipeableCollectionViewCell.m
//  Pods
//
//  Created by Joseph Ridenour on 4/14/15.
//
//

#import "URBNSwipeableCollectionViewCell.h"
#import "UIView+SwiperController.h"

@implementation URBNSwipeableCollectionViewCell

#pragma mark - Init
- (void)sharedInit {
    [self.contentView urbn_swiperize];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self sharedInit];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self sharedInit];
}

#pragma mark - Selection Override
- (void)setHighlighted:(BOOL)highlighted {
    if (![[self swipeController] isShowingBasement]) {
        [super setHighlighted:highlighted];
    }
}

- (void)setSelected:(BOOL)selected {
    if (![[self swipeController] isShowingBasement]) {
        [super setSelected:selected];
    }
}

#pragma mark - Getters
- (URBNSwipeableController *)swipeController{
    return self.contentView.urbn_swiperController;
}

#pragma mark - Layout
- (void)layoutSubviews {
    [super layoutSubviews];
    [[self swipeController] updateLayout];
}

- (void)prepareForReuse {
    [super prepareForReuse];
    [[self swipeController] closeBasementAnimated:NO];
}

@end
