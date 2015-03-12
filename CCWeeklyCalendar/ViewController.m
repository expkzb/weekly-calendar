//
//  ViewController.m
//  CCWeeklyCalendar
//
//  Created by zhoubin on 15-3-4.
//  Copyright (c) 2015年 Withtrip. All rights reserved.
//

#import "ViewController.h"
#import "CCWeeklyCalendar.h"

@interface ViewController () <CCWeeklyCalendarDelegate, CCWeeklyCalendarDataSource>
@property (nonatomic, strong) CCWeeklyCalendar *weeklyCalendar;
@end

@implementation ViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.weeklyCalendar = [[CCWeeklyCalendar alloc] init];
    self.weeklyCalendar.calendarView.frame = CGRectMake(0, 20, [UIScreen mainScreen].bounds.size.width, kHeightForDayView);
    self.weeklyCalendar.delegate = self;
    self.weeklyCalendar.dataSource = self;
    
    [self.view addSubview:self.weeklyCalendar.calendarView];
    
    [self.datePicker addTarget:self action:@selector(datePickerValueChanged:) forControlEvents:UIControlEventValueChanged];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)datePickerValueChanged:(UIDatePicker *)picker {
    [self.weeklyCalendar scrollToDate:picker.date animate:YES];
}


#pragma mark - weekly calendar delegate

- (void)weeklyCalendar:(CCWeeklyCalendar *)calendar didSelectDate:(NSDate *)date {
    NSLog(@"%@", date);
}


- (void)weeklyCalendar:(CCWeeklyCalendar *)calendar didScrollToDate:(NSDate *)date {
    //[self.datePicker setDate:date animated:YES];
}

#pragma mark - weekly calendar datasource

- (NSInteger)weeklyCalendar:(CCWeeklyCalendar *)calendar numberOfEventsOnDate:(NSDate *)date {
    NSInteger fakeEventsTotal = rand() % 10;
    return fakeEventsTotal;
}

@end
