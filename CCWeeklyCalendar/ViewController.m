//
//  ViewController.m
//  CCWeeklyCalendar
//
//  Created by zhoubin on 15-3-4.
//  Copyright (c) 2015年 Withtrip. All rights reserved.
//

#import "ViewController.h"
#import "CCWeeklyCalendar.h"

@interface ViewController ()
@property (nonatomic, strong) CCWeeklyCalendar *weeklyCalendar;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.weeklyCalendar = [[CCWeeklyCalendar alloc] init];
    self.weeklyCalendar.calendarView.frame = CGRectMake(0, 20, [UIScreen mainScreen].bounds.size.width, kHeightForDayView);
    
    [self.view addSubview:self.weeklyCalendar.calendarView];
    
    
    [self.datePicker addTarget:self action:@selector(datePickerValueChanged:) forControlEvents:UIControlEventValueChanged];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)datePickerValueChanged:(UIDatePicker *)picker {
    
    NSLog(@"%@", picker.date);
    
    [self.weeklyCalendar scrollToDate:picker.date animate:YES];
}

@end
