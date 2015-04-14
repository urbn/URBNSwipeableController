//
//  URBNSwipeableCollectionExampleVC.m
//  URBNSwipeableController
//
//  Created by Joseph Ridenour on 4/14/15.
//  Copyright (c) 2015 Joe Ridenour. All rights reserved.
//

#import "URBNSwipeableCollectionExampleVC.h"
#import <URBNSwipeableController/URBNSwipeableController.h>
#import <URBNSwipeableController/UIView+SwiperController.h>



@implementation URBNSwipeableCollectionExampleVC

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    CGFloat delay = 0.f;
    for (UITableViewCell *cell in [self.collectionView visibleCells]) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [cell.contentView.swiperController openBasementAnimated:YES];
        });
        delay += 0.25f;
    }
}

#pragma mark - DataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 10;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"swipeCell" forIndexPath:indexPath];
    
    typeof(self) __weak __self = self;
    [cell.contentView.swiperController addAction:[URBNSwipeableAction actionWithTitle:@"EDIT" withHandler:^(URBNSwipeableAction *action) {
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

@end
