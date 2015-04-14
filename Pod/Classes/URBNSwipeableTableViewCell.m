//
//  URBNSwipeableTableViewCell.m
//  Pods
//
//  Created by Joseph Ridenour on 4/14/15.
//
//

#import "URBNSwipeableTableViewCell.h"
#import "UIView+SwiperController.h"
#import "URBNSwipeableController.h"


@implementation URBNSwipeableTableViewCell

- (void)sharedInit {
    [self.contentView swiperize];
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
    if (![self.contentView.swiperController isShowingBasement]) {
        [super setSelected:selected animated:animated];
    }
}

#pragma mark - Layout
- (void)layoutSubviews {
    [super layoutSubviews];
    [self.contentView.swiperController updateLayout];
}

@end
