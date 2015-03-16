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
static CGFloat const kRightLabelWidth = 10.0f; //右侧label宽度
static CGFloat const kTodayCircleWidth = 20.0f; //“今天”蓝色圈的宽度
static CGFloat const kTodayCircleTextHeight = 10.0f; // “今”文字高度
static NSInteger const kTodayCircleTag = 1998; // “今天”蓝色圈视图tag


@implementation CCWeeklyCalendarTodayCircle

- (void)drawRect:(CGRect)rect {
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    // setup the size
    CGRect circleRect = CGRectMake( 0, 0, rect.size.width, rect.size.height);
    
    CGContextSetFillColorWithColor(ctx, [UIColor whiteColor].CGColor);
    CGContextFillRect(ctx, rect);
    
    // Fill
    CGContextSetFillColorWithColor(ctx, [UIColor colorWithRed:0.11 green:0.59 blue:0.99 alpha:1].CGColor);
    CGContextFillEllipseInRect(ctx, circleRect);
    
    UIFont* font = [UIFont fontWithName:@"Arial" size:kTodayCircleTextHeight];
    UIColor* textColor = [UIColor whiteColor];
    
    NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    [style setAlignment:NSTextAlignmentCenter];
    
    NSDictionary* stringAttrs = @{ NSFontAttributeName : font, NSForegroundColorAttributeName : textColor, NSParagraphStyleAttributeName: style};
    NSAttributedString* attrStr = [[NSAttributedString alloc] initWithString:@"今" attributes:stringAttrs];
    
    [attrStr drawInRect:CGRectMake(0.0f, rect.size.height/2.0f - kTodayCircleTextHeight/2.0f, rect.size.width, kTodayCircleWidth)];
}

@end


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
    self.bottomLabel.adjustsFontSizeToFitWidth = YES;
    
    [self addSubview:_bottomLabel];
}


// 右侧label，用于显示节假日调休安排，“上班/休息”
- (void)setupRightLabel {
    
    self.rightLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.bounds.size.width - kRightLabelWidth - kTopBottomPadding, self.bounds.size.height/2.0 - kRightLabelWidth/2.0, kRightLabelWidth, kRightLabelWidth)];
    
    [self.rightLabel setFont:[UIFont fontWithName:@"Arial" size:10.0f]];
    [self.rightLabel setTextAlignment:NSTextAlignmentCenter];
    [self.rightLabel setTextColor:[UIColor redColor]];
    
    [self addSubview:_rightLabel];
}


- (void)setupBusyBarView {
    
    CGRect rect = CGRectMake(kBorderWidth / 2.0f,
                             self.bounds.size.height - kBusyBarHeight - kBorderWidth,
                             self.bounds.size.width - kBorderWidth ,
                             kBusyBarHeight);
    
    self.busyBarView = [[CCWeeklyCalendarBusyBarView alloc] initWithFrame:rect];
    
    [self addSubview:_busyBarView];
}

- (void)addTodayCircle {
    
    if ([self viewWithTag:kTodayCircleTag]) return;
    
    CGRect rect = CGRectMake(0, 0, kTodayCircleWidth, kTodayCircleWidth);
    self.todayCircle = [[CCWeeklyCalendarTodayCircle alloc] initWithFrame:rect];
    self.todayCircle.center = self.dayLabel.center;
    self.todayCircle.tag = kTodayCircleTag;
    [self addSubview:_todayCircle];
}

- (void)removeTodayCircle {
    if ([self viewWithTag:kTodayCircleTag]) {
        [self.todayCircle removeFromSuperview];
    }
}

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    
    if (self) {
        [self setupDayLabel];
        [self setupBusyBarView];
        [self setupWeekDayLabel];
        [self setupBottomLabel];
        [self setupRightLabel];
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
