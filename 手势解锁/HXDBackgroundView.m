//
//  HXDBackgroundView.m
//  手势解锁
//
//  Created by huxuedong on 15/10/11.
//  Copyright © 2015年 huxuedong. All rights reserved.
//

#import "HXDBackgroundView.h"

@implementation HXDBackgroundView

- (void)drawRect:(CGRect)rect {
    UIImage *image = [UIImage imageNamed:@"Home_refresh_bg"];
    [image drawInRect:self.bounds];
}

@end
