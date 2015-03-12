//
//  CCWeeklyCalendarDayView.h
//  CCWeeklyCalendar
//
//  Created by zhoubin on 15-3-5.
//  Copyright (c) 2015年 Withtrip. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CCWeeklyCalendarBusyBarView.h"

@interface CCWeeklyCalendarDayView : UIView
@property (nonatomic, strong) UILabel *weekDayLabel;
@property (nonatomic, strong) UILabel *dayLabel;
@property (nonatomic, strong) UILabel *bottomLabel;
@property (nonatomic, strong) UILabel *rightLabel;
@property (nonatomic, strong) CCWeeklyCalendarBusyBarView *busyBarView;
@end
