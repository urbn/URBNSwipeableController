//
//  URBNSwipeableTableViewCell.m
//  Pods
//
//  Created by Joseph Ridenour on 4/14/15.
//
//

#import "URBNSwipeableTableViewCell.h"
#import "UIView+SwiperController.h"

@implementation URBNSwipeableTableViewCell

#pragma mark - Init
- (void)sharedInit {
    [self.contentView urbn_swiperize];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
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
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    if (![[self swipeController] isShowingBasement]) {
        [super setSelected:selected animated:animated];
    }
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    if (![[self swipeController] isShowingBasement]) {
        [super setHighlighted:highlighted animated:animated];
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
