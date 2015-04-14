//
//  URBNViewController.m
//  URBNSwipeableController
//
//  Created by Joe Ridenour on 04/14/2015.
//  Copyright (c) 2014 Joe Ridenour. All rights reserved.
//

#import "URBNViewController.h"
#import <URBNSwipeableController/UIView+SwiperController.h>

@implementation URBNViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.swiperView1 swiperize];
    [self.swiperView2 swiperize];
}

@end
