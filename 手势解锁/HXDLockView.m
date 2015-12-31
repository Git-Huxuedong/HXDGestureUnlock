//
//  HXDLockView.m
//  手势解锁
//
//  Created by huxuedong on 15/10/11.
//  Copyright © 2015年 huxuedong. All rights reserved.
//

#import "HXDLockView.h"

@interface HXDLockView ()

@property (strong, nonatomic) NSMutableArray *seletedButton;
@property (assign, nonatomic) CGPoint currentPoint;

@end

@implementation HXDLockView

- (NSMutableArray *)seletedButton {
    if (_seletedButton == nil) {
        _seletedButton = [NSMutableArray array];
    }
    return _seletedButton;
}

- (void)awakeFromNib {
    CGFloat buttonW = 74;
    CGFloat buttonH = 74;
    int columns = 3;
    CGFloat margin = (self.bounds.size.width - columns * buttonW) / (columns + 1);
    int rowIndex = 0;
    int columnIndex = 0;
    for (int i = 0; i < 9; i++) {
        rowIndex = i / columns;
        columnIndex = i % columns;
        CGFloat buttonX = margin + (margin + buttonW) * columnIndex;
        CGFloat buttonY = (margin + buttonH) * rowIndex;
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(buttonX, buttonY, buttonW, buttonH)];
        //设置按钮的tag标识
        button.tag = (i + 1) * 100;
        [button setBackgroundImage:[UIImage imageNamed:@"gesture_node_normal"] forState:UIControlStateNormal];
        //设置选中状态下按钮的背景图
        [button setBackgroundImage:[UIImage imageNamed:@"gesture_node_highlighted"] forState:UIControlStateSelected];
        button.userInteractionEnabled = NO;
        [self addSubview:button];
    }
}

//自定义方法，获取当前触点的坐标
- (CGPoint)pointWithTouches:(NSSet *)touches {
    //获取触点对象
    UITouch *touch = [touches anyObject];
    //返回触点的坐标
    return [touch locationInView:self];
}

//自定义方法，根据触点的坐标处理按钮
- (void)dealPoint:(CGPoint)point {
    for (UIButton *button in self.subviews) {
        //判断触点的坐标是否在按钮的frame上
        if (CGRectContainsPoint(button.frame, point)) {
            //如果按钮已经被选中了，则跳出该方法
            if (button.selected) return;
            //如果按钮没别选中，则可以选中该按钮
            button.selected = YES;
            //将该按钮添加到数组中
            [self.seletedButton addObject:button];
        }
    }
}

//当点击时执行的方法
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    //获取当前点击的点的坐标
    CGPoint currentPoint = [self pointWithTouches:touches];
    //处理按钮
    [self dealPoint:currentPoint];
}

//当移动时执行的方法
- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    //获取当前触点的坐标
    CGPoint currentPoint = [self pointWithTouches:touches];
    //属性赋值
    self.currentPoint = currentPoint;
    //处理按钮
    [self dealPoint:currentPoint];
    //重绘
    [self setNeedsDisplay];
}

//当结束点击是执行的方法
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    NSMutableString *str = [NSMutableString string];
    for (UIButton *button in self.seletedButton) {
        //根据按钮的标识拼接密码
        [str appendFormat:@"%ld",button.tag];
    }
    //从文件中读取密码
    NSString *password = [[NSUserDefaults standardUserDefaults] objectForKey:@"pwd"];
    if ([password isEqualToString:str])
        NSLog(@"输入正确");
    else
        NSLog(@"输入错误");
    //保存密码
    [[NSUserDefaults standardUserDefaults] setObject:str forKey:@"pwd"];
    //让按钮都设置成没选中状态
    [self.seletedButton makeObjectsPerformSelector:@selector(setSelected:) withObject:0];
    //清空数组
    [self.seletedButton removeAllObjects];
    //重绘
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    //如果没有选中的按钮则结束该方法
    if (!self.seletedButton.count) return;
    UIBezierPath *path = [UIBezierPath bezierPath];
    for (int i = 0; i < self.seletedButton.count; i++) {
        UIButton *button = self.seletedButton[i];
        if (i == 0)
            [path moveToPoint:button.center];
        else
            [path addLineToPoint:button.center];
    }
    //添加一条线到当前触点
    [path addLineToPoint:self.currentPoint];
    //设置线宽
    path.lineWidth = 10;
    //设置线的样式为圆角
    path.lineJoinStyle = kCGLineJoinRound;
    [[UIColor greenColor] set];
    [path stroke];
}

@end
