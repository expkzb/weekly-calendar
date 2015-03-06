//
//  CCWeeklyCalendar.m
//  CCWeeklyCalendar
//
//  Created by zhoubin on 15-3-5.
//  Copyright (c) 2015年 Withtrip. All rights reserved.
//

#import "CCWeeklyCalendar.h"
#import "NSDate+Utilities.h"
#import "CCWeeklyCalendarDayView.h"


@interface CCWeeklyCalendar () <UIScrollViewDelegate>

// 每个`日`视图的宽度
@property (nonatomic) CGFloat dayViewWidth;
// 今天
@property (nonatomic ,strong) NSDate *today;
// 日期数据数组
@property (nonatomic, strong) NSMutableArray *dates;
// `日`视图数组
@property (nonatomic, strong) NSMutableArray *dayCellViews;
// 系统日历对象
@property (nonatomic, strong) NSCalendar *calendar;

// 根据数据源数量返回`contentSize`
- (CGSize)contentSizeForNumberOfDays:(NSUInteger)days;

@end

@implementation CCWeeklyCalendar


- (CGFloat)dayViewWidth {
    
    if (_dayViewWidth > 0) return _dayViewWidth;
    
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    _dayViewWidth = screenWidth / (CGFloat)kDaysPerPage;
    
    return _dayViewWidth;
}


- (CGSize)contentSizeForNumberOfDays:(NSUInteger)days {
    return CGSizeMake(days * self.dayViewWidth, kHeightForDayView);
}


// 以参数 date 为中心，载入 kNumberOfDaysInScrollView 天
- (void)resetDaysWithDate:(NSDate *)date {
    
    if ([self.dates count] > 0) {
        [self.dates removeAllObjects];
    }
    
    // `今天`之前的天数
    // 如：一共有30天，`今天`是第15天，则之前有14天
    NSInteger numberOfDaysBeforeToday = (kNumberOfDaysInScrollView / 2) + (kNumberOfDaysInScrollView % 2) - 1;
    
    // 将 kNumberOfDaysInScrollView 个日期放入数组
    NSDate *start = [date dateByAddingDays: - numberOfDaysBeforeToday];
    
    for (NSInteger i = 0; i < kNumberOfDaysInScrollView; i ++ ) {
        [self.dates addObject:[start dateByAddingDays:i]];
    }
}


- (UIColor *)randomColor {
    CGFloat hue = ( arc4random() % 256 / 256.0 );  //  0.0 to 1.0
    CGFloat saturation = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from white
    CGFloat brightness = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from black
    UIColor *color = [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
    return color;
}


// 将`日`视图贴到 scrollView 上
- (void)addDayCellViews {
    
    for (NSInteger i = 0; i < kNumberOfDaysInScrollView; i ++) {
        
        CCWeeklyCalendarDayView *dayCellView = [[CCWeeklyCalendarDayView alloc] initWithFrame:CGRectMake( i * self.dayViewWidth, 0, self.dayViewWidth , kHeightForDayView)];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dayViewTapped:)];
        [dayCellView addGestureRecognizer:tap];
        
        [self.calendarView addSubview:dayCellView];
        [self.dayCellViews addObject:dayCellView];
    }
}


// 重新设置`日`视图的数据
- (void)resetDayCellViews {
    
    for (NSInteger i = 0; i < kNumberOfDaysInScrollView; i ++) {
        
        CCWeeklyCalendarDayView *dayCellView = self.dayCellViews[i];
        
        dayCellView.backgroundColor = [self randomColor];
        
        NSDate *date = self.dates[i];
        
        dayCellView.dayLabel.text = [NSString stringWithFormat:@"%ld月%ld日",(long)date.month, (long)date.day];
    }
}


- (instancetype)init {
    
    self = [super init];
    
    if (self) {
        
        self.dayViewWidth = 0;
        self.dates = [[NSMutableArray alloc] initWithCapacity:kNumberOfDaysInScrollView];
        self.dayCellViews = [[NSMutableArray alloc] initWithCapacity:kNumberOfDaysInScrollView];

        self.today = [[NSDate date] dateAtStartOfDay];
        self.calendar = [NSCalendar currentCalendar];
        
        self.calendarView = [[CCWeeklyCalendarView alloc] initWithFrame:CGRectZero];
        self.calendarView.delegate = self;
        self.calendarView.contentSize = [self contentSizeForNumberOfDays:kNumberOfDaysInScrollView];
        self.calendarView.showsHorizontalScrollIndicator = NO;
        
        [self addDayCellViews];
        
        [self scrollToDate:_today animate:NO];
    }
    
    return self;
}


- (void)scrollToDate:(NSDate *)date animate:(BOOL)animate {
    
    
    if ( NO == animate ) {
        
        [self resetDaysWithDate:date];
        [self resetDayCellViews];

        NSInteger index = [self.dates indexOfObject:date];
        self.calendarView.contentOffset = CGPointMake(index * self.dayViewWidth, 0);
        
    } else {
        
        //获取当前屏幕区域的日期区间
        NSInteger leftDateIndex = self.calendarView.contentOffset.x / self.dayViewWidth;
        NSInteger rightDateIndex = leftDateIndex + kDaysPerPage - 1;
        
        NSDate *leftDateOnScreen = self.dates[leftDateIndex];
        NSDate *rightDateOnScreen = self.dates[rightDateIndex];
        
        BOOL needFadeOut = NO;
        
        if ([date isEarlierThanDate:leftDateOnScreen]) {
            
            // 在左侧屏幕外
            NSInteger daysBefore = [date daysBeforeDate:leftDateOnScreen];
            if (daysBefore > 1) {
                needFadeOut = YES;
            }
            
            [self resetDaysWithDate:date];
            [self resetDayCellViews];
            
            NSInteger index = [self.dates indexOfObject:date];
            CGPoint newOffset  = CGPointMake(index * self.dayViewWidth + self.dayViewWidth, 0);
            self.calendarView.contentOffset = newOffset;
            
        }else if ([date isLaterThanDate:rightDateOnScreen]) {
            
            // 在右侧屏幕外
            [self resetDaysWithDate:date];
            [self resetDayCellViews];
            
            NSInteger index = [self.dates indexOfObject:date];
            CGPoint newOffset  = CGPointMake(index * self.dayViewWidth - self.calendarView.bounds.size.width, 0);
            self.calendarView.contentOffset = newOffset;
            
            needFadeOut = YES;
            
        } else {

            // 在屏幕内
            NSInteger index = [self.dates indexOfObject:date];
            NSInteger indexOnScreen = (index * self.dayViewWidth - self.calendarView.contentOffset.x) / self.dayViewWidth;
            
            [self resetDaysWithDate:date];
            [self resetDayCellViews];
            
            NSInteger newIndex = [self.dates indexOfObject:date];
            CGPoint newOffset  = CGPointMake(newIndex * self.dayViewWidth - indexOnScreen * self.dayViewWidth, 0);
            
            self.calendarView.contentOffset = newOffset;
        }
        
        NSInteger index = [self.dates indexOfObject:date];
        
        CGPoint newOffset  = CGPointMake(index * self.dayViewWidth, 0);
        
        if (needFadeOut) {
            
            [UIView animateWithDuration:0.3 animations:^{
                
                self.calendarView.alpha = 0.4;
                
            } completion:^(BOOL finished) {
                
                [UIView animateWithDuration:0.3 animations:^{
                    self.calendarView.alpha = 1;
                }];
                
            }];

        }
        
        [self.calendarView setContentOffset:newOffset animated:YES];
    }
    
}


#pragma mark - Gesture

- (void)dayViewTapped:(UITapGestureRecognizer *)gesture {
    
    CCWeeklyCalendarDayView *dayView = (CCWeeklyCalendarDayView *)gesture.view;
    NSInteger index = [self.dayCellViews indexOfObject:dayView];
    NSDate *dateTapped = self.dates[index];
    
    [self scrollToDate:dateTapped animate:YES];
    
    NSLog(@"%@", [dateTapped stringWithDateStyle:NSDateFormatterMediumStyle timeStyle:NSDateFormatterShortStyle]);
}


#pragma mark - UIScroll view delegate 

- (void)snapScrollView:(UIScrollView *)scrollView
{
    // 为完整呈现`日`视图，做吸附操作
    CGPoint offset = scrollView.contentOffset;
    
    if ((offset.x + scrollView.frame.size.width) >= scrollView.contentSize.width)
    {
        return;
    }
    
    offset.x = floorf(offset.x / self.dayViewWidth + 0.5) * self.dayViewWidth;
    
    //FIXME:执行动画时，scrollview会不响应手势
    [scrollView setContentOffset:offset animated:YES];
}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self snapScrollView:scrollView];
}


- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [self snapScrollView:scrollView];
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if (scrollView.contentOffset.x > [self contentSizeForNumberOfDays:kNumberOfDaysInScrollView].width - [UIScreen mainScreen].bounds.size.width) {
        
        NSDate *lastDate = self.dates.lastObject;
        
        [self resetDaysWithDate:lastDate];
        [self resetDayCellViews];
        
        NSInteger index = [self.dates indexOfObject:lastDate];
        
        //将原先最后一个`日`视图， 移动到当前屏幕上的最右侧
        scrollView.contentOffset = CGPointMake(index * self.dayViewWidth - (kDaysPerPage - 1) * self.dayViewWidth, 0);
    }
    
    if (scrollView.contentOffset.x < 0) {
        
        NSDate *firstDate = self.dates.firstObject;
        
        [self resetDaysWithDate:firstDate];
        [self resetDayCellViews];
        
        NSInteger index = [self.dates indexOfObject:firstDate];
        scrollView.contentOffset = CGPointMake(index * self.dayViewWidth, 0);
        
    }
}

@end
