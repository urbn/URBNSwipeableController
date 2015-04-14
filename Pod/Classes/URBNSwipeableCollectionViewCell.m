//
//  URBNSwipeableCollectionViewCell.m
//  Pods
//
//  Created by Joseph Ridenour on 4/14/15.
//
//

#import "URBNSwipeableCollectionViewCell.h"
#import "UIView+SwiperController.h"
#import "URBNSwipeableController.h"

@implementation URBNSwipeableCollectionViewCell

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

#pragma mark - Layout
- (void)layoutSubviews {
    [super layoutSubviews];
    [self.contentView.urbn_swiperController updateLayout];
}

@end
