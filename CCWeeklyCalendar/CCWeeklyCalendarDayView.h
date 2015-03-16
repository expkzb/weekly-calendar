//
//  CCWeeklyCalendarDayView.h
//  CCWeeklyCalendar
//
//  Created by zhoubin on 15-3-5.
//  Copyright (c) 2015年 Withtrip. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CCWeeklyCalendarBusyBarView.h"

// “今天”，圆圈视图
@interface CCWeeklyCalendarTodayCircle : UIView

@end

@interface CCWeeklyCalendarDayView : UIView
@property (nonatomic, strong) UILabel *weekDayLabel;
@property (nonatomic, strong) UILabel *dayLabel;
@property (nonatomic, strong) UILabel *bottomLabel;
@property (nonatomic, strong) UILabel *rightLabel;
@property (nonatomic, strong) CCWeeklyCalendarBusyBarView *busyBarView;
@property (nonatomic, strong) CCWeeklyCalendarTodayCircle *todayCircle;

// 增加“今天”圈
- (void)addTodayCircle;

// 移除"今天“圈
- (void)removeTodayCircle;

@end
