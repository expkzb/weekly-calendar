//
//  CCWeeklyCalendar.h
//  CCWeeklyCalendar
//
//  Created by zhoubin on 15-3-5.
//  Copyright (c) 2015年 Withtrip. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CCWeeklyCalendarView.h"

static NSInteger const kDaysPerPage = 5;                    //每页所显示的`日`视图个数
static NSInteger const kNumberOfDaysInScrollView = 15;      //scrollView上存在的`日`视图总数
static CGFloat   const kHeightForDayView = 65.0f;           //`日`视图的高度

@class CCWeeklyCalendar;

#pragma mark - Protocol
@protocol CCWeeklyCalendarDelegate <NSObject>

@optional
// 日期被选中
- (void)weeklyCalendar:(CCWeeklyCalendar *)calendar didSelectDate:(NSDate *)date;
// 当前在最左端的日期发生变化
- (void)weeklyCalendar:(CCWeeklyCalendar *)calendar didScrollToDate:(NSDate *)date;

@end


#pragma mark - Datasource
@protocol CCWeeklyCalendarDataSource <NSObject>
// 特定日期有多少事件
- (NSInteger)weeklyCalendar:(CCWeeklyCalendar *)calendar numberOfEventsOnDate:(NSDate *)date;
@end


#pragma mark - Interface

@interface CCWeeklyCalendar : NSObject

@property (nonatomic, strong) CCWeeklyCalendarView *calendarView; //日历视图
@property (nonatomic, strong) NSDate *currentDate; //位于最左侧的日期
@property (nonatomic, weak) id<CCWeeklyCalendarDelegate> delegate;
@property (nonatomic, weak) id<CCWeeklyCalendarDataSource> dataSource;

// 滑动到某一天
- (void)scrollToDate:(NSDate *)date animate:(BOOL)animate;

@end
