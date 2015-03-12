//
//  CCWeeklyCalendarDayView.m
//  CCWeeklyCalendar
//
//  Created by zhoubin on 15-3-5.
//  Copyright (c) 2015年 Withtrip. All rights reserved.
//

#import "CCWeeklyCalendarDayView.h"

static CGFloat const kBusyBarHeight = 5.0f; //忙碌程度`bar`的高度
static CGFloat const kBorderWidth  = 2.0f; //边框宽度

@implementation CCWeeklyCalendarDayView


- (void)setupDayLabel {
    
    self.dayLabel = [[UILabel alloc] initWithFrame:self.bounds];
    
    [self.dayLabel setFont:[UIFont fontWithName:@"Arial" size:15]];
    [self.dayLabel setTextColor:[UIColor blackColor]];
    [self.dayLabel setTextAlignment:NSTextAlignmentCenter];
    
    self.dayLabel.numberOfLines = 2;
    
    [self addSubview:_dayLabel];
}


- (void)setupBusyBarView {
    
    CGRect rect = CGRectMake(kBorderWidth / 2.0f, self.bounds.size.height - kBusyBarHeight - kBorderWidth, self.bounds.size.width - kBorderWidth , kBusyBarHeight);
    self.busyBarView = [[CCWeeklyCalendarBusyBarView alloc] initWithFrame:rect];
    [self addSubview:_busyBarView];
}


- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    
    if (self) {
        [self setupDayLabel];
        [self setupBusyBarView];
    }
    
    return self;
}


- (void)drawRect:(CGRect)rect {
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // 填充背景色
    CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
    CGContextFillRect(context, rect);
    CGContextStrokePath(context);
    
    // 边框 - 上下
    CGContextSetStrokeColorWithColor(context, [UIColor blackColor].CGColor);
    CGContextSetLineWidth(context, kBorderWidth);
    
    CGContextMoveToPoint(context, 0, kBorderWidth / 2.0f);
    CGContextAddLineToPoint(context, rect.size.width, kBorderWidth / 2.0f);
    
    CGContextMoveToPoint(context, 0, rect.size.height - kBorderWidth / 2.0f);
    CGContextAddLineToPoint(context, rect.size.width, rect.size.height - kBorderWidth / 2.0f);
    
    CGContextStrokePath(context);
    
    // 边框 - 左右
    CGContextSetLineWidth(context, kBorderWidth / 2.0f);
    
    CGContextMoveToPoint(context, kBorderWidth / 4.0f, 0);
    CGContextAddLineToPoint(context, kBorderWidth / 4.0f, rect.size.height);
    
    CGContextMoveToPoint(context, rect.size.width - kBorderWidth / 4.0f, 0);
    CGContextAddLineToPoint(context, rect.size.width - kBorderWidth / 4.0f, rect.size.height);
    
    CGContextStrokePath(context);

}


@end
