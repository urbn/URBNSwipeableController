//
//  URBNSwipeTableExampleVC.m
//  URBNSwipeableController
//
//  Created by Joseph Ridenour on 4/14/15.
//  Copyright (c) 2015 Joe Ridenour. All rights reserved.
//

#import "URBNSwipeTableExampleVC.h"
#import <URBNSwipeableController/URBNSwipeableController.h>
#import <URBNSwipeableController/UIView+SwiperController.h>

@implementation URBNSwipeTableExampleVC

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    //// Showing off a little magic.
    CGFloat delay = 0.f;
    for (UITableViewCell *cell in [self.tableView visibleCells]) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [cell.contentView.urbn_swiperController openBasementAnimated:YES];
        });
        delay += 0.25f;
    }
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"swipeCell" forIndexPath:indexPath];
    
    cell.textLabel.text = [NSString stringWithFormat:@"Cell %@", indexPath];
    cell.accessoryType = indexPath.row % UITableViewCellAccessoryDetailButton;
    
    
    //// We've built in some action handling to swiperView directly.
    typeof(self) __weak __self = self;
    [cell.contentView.urbn_swiperController addAction:[URBNSwipeableAction actionWithTitle:@"EDIT" withHandler:^(URBNSwipeableAction *action) {
        [__self alertWithAction:action withIndexPath:indexPath];
    }] withStyleHandler:^(UIButton *handler) {
        [handler setBackgroundColor:[UIColor orangeColor]];
    }];
    
    return cell;
}

- (void)alertWithAction:(URBNSwipeableAction *)action withIndexPath:(NSIndexPath *)indexPath {
    UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"Sup" message:[NSString stringWithFormat:@"%@ Clicked for %@", action.title, indexPath] preferredStyle:UIAlertControllerStyleAlert];
    [ac addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:ac animated:YES completion:nil];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [URBNSwipeableController closeBasements];
}

@end
