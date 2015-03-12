//
//  ViewController.h
//  CCWeeklyCalendar
//
//  Created by zhoubin on 15-3-4.
//  Copyright (c) 2015年 Withtrip. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CCWeeklyCalendarBusyBarView.h"

@interface ViewController : UIViewController

@property (nonatomic, strong) IBOutlet UIDatePicker *datePicker;
@property (nonatomic, strong) IBOutlet CCWeeklyCalendarBusyBarView *busyView;

@end

