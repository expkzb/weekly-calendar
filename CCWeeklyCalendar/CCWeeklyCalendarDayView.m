//
//  CCWeeklyCalendarDayView.m
//  CCWeeklyCalendar
//
//  Created by zhoubin on 15-3-5.
//  Copyright (c) 2015年 Withtrip. All rights reserved.
//

#import "CCWeeklyCalendarDayView.h"

@implementation CCWeeklyCalendarDayView

- (void)setupDayLabel {
    
    self.dayLabel = [[UILabel alloc] initWithFrame:self.bounds];
    
    [self.dayLabel setFont:[UIFont fontWithName:@"Arial" size:15]];
    [self.dayLabel setTextColor:[UIColor blackColor]];
    [self.dayLabel setTextAlignment:NSTextAlignmentCenter];
    self.dayLabel.numberOfLines = 2;
    [self addSubview:_dayLabel];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        [self setupDayLabel];
    }
    
    return self;
}

@end
