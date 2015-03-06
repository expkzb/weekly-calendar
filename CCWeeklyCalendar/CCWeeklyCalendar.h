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
static CGFloat   const kHeightForDayView = 80.0f;           //`日`视图的高度

@interface CCWeeklyCalendar : NSObject

@property (nonatomic, strong) CCWeeklyCalendarView *calendarView; //日历视图

// 滑动到某一天
- (void)scrollToDate:(NSDate *)date animate:(BOOL)animate;

@end
