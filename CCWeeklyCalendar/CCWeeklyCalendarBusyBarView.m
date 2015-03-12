//
//  CCWeeklyCalendarBusyBarView.m
//  CCWeeklyCalendar
//
//  Created by zhoubin on 15-3-10.
//  Copyright (c) 2015年 Withtrip. All rights reserved.
//

#import "CCWeeklyCalendarBusyBarView.h"

@implementation CCWeeklyCalendarBusyBarView

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    
    if (self) {
        self.percent = 0;
        self.barColor = [UIColor redColor];
        self.backgroundColor = [UIColor whiteColor];
    }
    
    return self;
}

- (void)drawRect:(CGRect)rect {
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGFloat barPadding = rect.size.width / 2.0f * (1 - self.percent);
    CGFloat barLength = rect.size.width * self.percent;
    
    // 绘制背景色
    CGContextSetFillColorWithColor(context, self.backgroundColor.CGColor);
    CGContextFillRect(context, rect);
    CGContextStrokePath(context);
    
    // 绘制繁忙程度bar
    CGContextSetFillColorWithColor(context, self.barColor.CGColor);
    CGContextFillRect(context, CGRectMake(barPadding, 0, barLength, rect.size.height));
    CGContextStrokePath(context);
}

#pragma mark - Set

- (void)setPercent:(CGFloat)percent {
    _percent = percent;
    [self setNeedsDisplay];
}

- (void)setBackgroundColor:(UIColor *)backgroundColor {
    _backgroundColor = backgroundColor;
    [self setNeedsDisplay];
}

- (void)setBarColor:(UIColor *)barColor {
    _barColor = barColor;
    [self setNeedsDisplay];
}

@end
