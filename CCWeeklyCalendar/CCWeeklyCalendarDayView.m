//
//  CCWeeklyCalendarDayView.m
//  CCWeeklyCalendar
//
//  Created by zhoubin on 15-3-5.
//  Copyright (c) 2015年 Withtrip. All rights reserved.
//

#import "CCWeeklyCalendarDayView.h"

static CGFloat const kBusyBarHeight = 2.0f; //忙碌程度`bar`的高度
static CGFloat const kBorderWidth  = 1.0f; //边框宽度
static CGFloat const kDayLabelHeight = 12.0f; //日期label高度
static CGFloat const kWeekDayLabelHeight = 10.0f; //星期几label高度
static CGFloat const kTopBottomPadding = 6.0f; //上下留白
static CGFloat const kBottomLabelHeight = 10.0f; //底部label高度

@implementation CCWeeklyCalendarDayView


- (void)setupDayLabel {
    
    self.dayLabel = [[UILabel alloc] initWithFrame:CGRectMake(kBorderWidth/2.0f,
                                                              self.bounds.size.height/2.0f - kDayLabelHeight/2.0f,
                                                              self.bounds.size.width - kBorderWidth,
                                                              kDayLabelHeight)];
    //self.dayLabel.backgroundColor = [UIColor greenColor];
    
    [self.dayLabel setFont:[UIFont fontWithName:@"Arial" size:15]];
    [self.dayLabel setTextColor:[UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:1]];
    [self.dayLabel setTextAlignment:NSTextAlignmentCenter];
    
    self.dayLabel.numberOfLines = 2;
    
    [self addSubview:_dayLabel];
}

// ’周一‘
- (void)setupWeekDayLabel {
    
    self.weekDayLabel = [[UILabel alloc] initWithFrame:CGRectMake(kBorderWidth/2.0f,
                                                                  kTopBottomPadding + kBorderWidth,
                                                                  self.bounds.size.width - kBorderWidth,
                                                                  kWeekDayLabelHeight)];
    //self.weekDayLabel.backgroundColor = [UIColor grayColor];
    
    [self.weekDayLabel setFont:[UIFont fontWithName:@"Arial" size:11.0f]];
    [self.weekDayLabel setTextColor:[UIColor colorWithRed:0.6 green:0.6 blue:0.6 alpha:1]];
    [self.weekDayLabel setTextAlignment:NSTextAlignmentCenter];
    
    [self addSubview:_weekDayLabel];
}

// 底部label，用于显示农历及节日
- (void)setupBottomLabel {
    
    self.bottomLabel = [[UILabel alloc] initWithFrame:CGRectMake(kBorderWidth/2.0f,
                                                                 self.bounds.size.height - kBorderWidth - kBusyBarHeight - kTopBottomPadding - kBottomLabelHeight,
                                                                 self.bounds.size.width - kBorderWidth,
                                                                 kBottomLabelHeight)];
    
    [self.bottomLabel setFont:[UIFont fontWithName:@"Arial" size:11.0f]];
    [self.bottomLabel setTextColor:[UIColor colorWithRed:0.73 green:0.73 blue:0.73 alpha:1]];
    [self.bottomLabel setTextAlignment:NSTextAlignmentCenter];
    
    [self addSubview:_bottomLabel];
}


- (void)setupBusyBarView {
    
    CGRect rect = CGRectMake(kBorderWidth / 2.0f,
                             self.bounds.size.height - kBusyBarHeight - kBorderWidth,
                             self.bounds.size.width - kBorderWidth ,
                             kBusyBarHeight);
    
    self.busyBarView = [[CCWeeklyCalendarBusyBarView alloc] initWithFrame:rect];
    
    [self addSubview:_busyBarView];
}


- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    
    if (self) {
        [self setupDayLabel];
        [self setupBusyBarView];
        [self setupWeekDayLabel];
        [self setupBottomLabel];
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
    CGContextSetStrokeColorWithColor(context, [UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1].CGColor);
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
