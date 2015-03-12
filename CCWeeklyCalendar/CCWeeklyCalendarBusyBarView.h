//
//  CCWeeklyCalendarBusyBarView.h
//  CCWeeklyCalendar
//
//  Created by zhoubin on 15-3-10.
//  Copyright (c) 2015年 Withtrip. All rights reserved.
//
//  用于体现繁忙程度的`条`

#import <UIKit/UIKit.h>

@interface CCWeeklyCalendarBusyBarView : UIView

@property (nonatomic) CGFloat percent;
@property (nonatomic, strong) UIColor *barColor;
@property (nonatomic, strong) UIColor *backgroundColor;

@end
