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
// 中国日历
@property (nonatomic, strong) NSCalendar *chineseCalendar;
@property (nonatomic, strong) NSArray *chineseDays;

// 是否需要响应手指离开scrollview的动作
@property (nonatomic) BOOL shouldResponseToEndDraggingEvent;

@property (nonatomic, strong) NSArray *weekDaySymbols;

// 根据数据源数量返回`contentSize`
- (CGSize)contentSizeForNumberOfDays:(NSUInteger)days;

@end

@implementation CCWeeklyCalendar

#pragma mark - Getter

- (CGFloat)dayViewWidth {
    
    if (_dayViewWidth > 0) return _dayViewWidth;
    
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    _dayViewWidth = screenWidth / (CGFloat)kDaysPerPage;
    
    return _dayViewWidth;
}


- (CGSize)contentSizeForNumberOfDays:(NSUInteger)days {
    return CGSizeMake(days * self.dayViewWidth, kHeightForDayView);
}


- (NSArray *)weekDaySymbols {
    
    if (!_weekDaySymbols) {
        _weekDaySymbols = [self.calendar veryShortWeekdaySymbols];
    }
    
    return _weekDaySymbols;
}

- (NSArray *)chineseDays {
    if (!_chineseDays) {
        _chineseDays = [NSArray arrayWithObjects:@"初一", @"初二", @"初三", @"初四", @"初五", @"初六", @"初七", @"初八", @"初九", @"初十",@"十一", @"十二", @"十三", @"十四", @"十五", @"十六", @"十七", @"十八", @"十九", @"二十",@"廿一", @"廿二", @"廿三", @"廿四", @"廿五", @"廿六", @"廿七", @"廿八", @"廿九", @"三十",  nil];
    }
    return _chineseDays;
}

- (NSString *)chineseCalendarDayWithDate:(NSDate *)date {
    
    unsigned unitFlags = NSCalendarUnitDay;
    
    NSDateComponents *localeComp = [self.chineseCalendar components:unitFlags fromDate:date];
    NSString *d_str = [self.chineseDays objectAtIndex:localeComp.day-1];
    
    return d_str;
}

- (NSDate *)today {
    return [NSDate date].dateAtStartOfDay;
}

#pragma mark

// 最左侧日期
- (NSDate *)leftDateOnScreen {
    
    // 若最左侧日期从右向左，滑出屏幕超过一半宽度，则返回紧邻其右侧的日期
    // 同理，若从左向右滑出超过一半宽度，则返回该日期
    
    CGFloat offset = self.calendarView.contentOffset.x + self.dayViewWidth / 2.0f;
    
    NSInteger index = offset / self.dayViewWidth;
    NSDate *date = self.dates[index];
    return date;
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
        
        NSDate *date = self.dates[i];
        
        dayCellView.dayLabel.text = [NSString stringWithFormat:@"%ld", (long)date.day];
        dayCellView.weekDayLabel.text = [NSString stringWithFormat:@"%@", self.weekDaySymbols[date.weekday - 1]];
        
        
        // 繁忙程度
        NSInteger eventsTotal = [self .dataSource weeklyCalendar:self numberOfEventsOnDate:date];
        
        if (eventsTotal > 4) {
            dayCellView.busyBarView.percent = 1;
            dayCellView.busyBarView.barColor = [UIColor colorWithRed:0.99 green:0.44 blue:0.45 alpha:1];
        }else if (eventsTotal > 2) {
            dayCellView.busyBarView.percent = 0.5;
            dayCellView.busyBarView.barColor = [UIColor colorWithRed:0.99 green:0.71 blue:0.44 alpha:1];
        }else if (eventsTotal > 0) {
            dayCellView.busyBarView.percent = 0.2;
            dayCellView.busyBarView.barColor = [UIColor colorWithRed:0.53 green:0.8 blue:0.99 alpha:1];
        }
        
        // 调休状态
        BOOL shouldShowRightLabel = [self.dataSource weeklyCalendar:self shouldShowRightLabelForDate:date];
        dayCellView.rightLabel.hidden = !shouldShowRightLabel;
        
        CCWeeklyCalendarPaidLeaveType type = [self.dataSource weeklyCalendar:self paidLeaveTypeForDate:date];
        
        switch (type) {
            case CCWeeklyCalendarPaidLeaveTypeRest:
            {
                dayCellView.rightLabel.text = @"休";
                [dayCellView.rightLabel setTextColor:[UIColor colorWithRed:0.99 green:0.17 blue:0.2 alpha:1]];
            }
                break;
            case CCWeeklyCalendarPaidLeaveTypeWork:
            {
                dayCellView.rightLabel.text = @"班";
                [dayCellView.rightLabel setTextColor:[UIColor colorWithRed:0.06 green:0.38 blue:0.64 alpha:1]];
            }
                break;
            default:
                dayCellView.rightLabel.text = @"";
                break;
        }
        
        
        // 节假日
        NSString *holidayString = [self.dataSource weeklyCalendar:self holidayStringForDate:date];
        
        if (nil == holidayString) {
            dayCellView.bottomLabel.text = [self chineseCalendarDayWithDate:date];
            [dayCellView.bottomLabel setTextColor:[UIColor colorWithRed:0.73 green:0.73 blue:0.73 alpha:1]];
        }else {
            dayCellView.bottomLabel.text = holidayString;
            [dayCellView.bottomLabel setTextColor:[UIColor colorWithRed:0.11 green:0.59 blue:0.99 alpha:1]];
        }
        
        // “今天”圈
        if ([self.today isEqualToDate:date]) {
            [dayCellView addTodayCircle];
        }else {
            [dayCellView removeTodayCircle];
        }
        
    }
}


- (instancetype)init {
    
    self = [super init];
    
    if (self) {
        
        self.dayViewWidth = 0;
        self.dates = [[NSMutableArray alloc] initWithCapacity:kNumberOfDaysInScrollView];
        self.dayCellViews = [[NSMutableArray alloc] initWithCapacity:kNumberOfDaysInScrollView];
        self.shouldResponseToEndDraggingEvent = YES;

        self.calendar = [NSCalendar currentCalendar];
        self.chineseCalendar = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierChinese];
        
        self.calendarView = [[CCWeeklyCalendarView alloc] initWithFrame:CGRectZero];
        self.calendarView.delegate = self;
        self.calendarView.contentSize = [self contentSizeForNumberOfDays:kNumberOfDaysInScrollView];
        self.calendarView.showsHorizontalScrollIndicator = NO;
        
        [self addDayCellViews];
        
        [self scrollToDate:self.today animate:NO];
    }
    
    return self;
}


- (void)scrollToDate:(NSDate *)date animate:(BOOL)animate {
    
    NSDate *dateAtStartOfDay = [date dateAtStartOfDay];
    
    if ( NO == animate ) {
        
        [self resetDaysWithDate:date];
        [self resetDayCellViews];

        NSInteger index = [self.dates indexOfObject:dateAtStartOfDay];
        self.calendarView.contentOffset = CGPointMake(index * self.dayViewWidth, 0);
        
    } else {
        
        //获取当前屏幕区域的日期区间
        NSInteger leftDateIndex = self.calendarView.contentOffset.x / self.dayViewWidth;
        NSInteger rightDateIndex = leftDateIndex + kDaysPerPage - 1;
        
        NSDate *leftDateOnScreen = self.dates[leftDateIndex];
        NSDate *rightDateOnScreen = self.dates[rightDateIndex];
        
        BOOL needFadeOut = NO;
        
        if ([dateAtStartOfDay isEarlierThanDate:leftDateOnScreen]) {
            
            // 在左侧屏幕外
            NSInteger daysBefore = [date daysBeforeDate:leftDateOnScreen];
            if (daysBefore > 1) {
                needFadeOut = YES;
            }
            
            [self resetDaysWithDate:dateAtStartOfDay];
            [self resetDayCellViews];
            
            NSInteger index = [self.dates indexOfObject:dateAtStartOfDay];
            CGPoint newOffset  = CGPointMake(index * self.dayViewWidth + self.dayViewWidth, 0);
            self.calendarView.contentOffset = newOffset;
            
        }else if ([dateAtStartOfDay isLaterThanDate:rightDateOnScreen]) {
            
            // 在右侧屏幕外
            [self resetDaysWithDate:dateAtStartOfDay];
            [self resetDayCellViews];
            
            NSInteger index = [self.dates indexOfObject:dateAtStartOfDay];
            CGPoint newOffset  = CGPointMake(index * self.dayViewWidth - self.calendarView.bounds.size.width, 0);
            self.calendarView.contentOffset = newOffset;
            
            needFadeOut = YES;
            
        } else {

            // 在屏幕内
            NSInteger index = [self.dates indexOfObject:dateAtStartOfDay];
            NSInteger indexOnScreen = (index * self.dayViewWidth - self.calendarView.contentOffset.x) / self.dayViewWidth;
            
            [self resetDaysWithDate:dateAtStartOfDay];
            [self resetDayCellViews];
            
            NSInteger newIndex = [self.dates indexOfObject:dateAtStartOfDay];
            CGPoint newOffset  = CGPointMake(newIndex * self.dayViewWidth - indexOnScreen * self.dayViewWidth, 0);
            
            self.calendarView.contentOffset = newOffset;
        }
        
        NSInteger index = [self.dates indexOfObject:dateAtStartOfDay];
        
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
    
    if ([self.delegate respondsToSelector:@selector(weeklyCalendar:didSelectDate:)]) {
        [self.delegate weeklyCalendar:self didSelectDate:dateTapped];
    }
    
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
    
    [scrollView setContentOffset:offset animated:YES];
}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self snapScrollView:scrollView];
    self.shouldResponseToEndDraggingEvent = YES;
}


- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (self.shouldResponseToEndDraggingEvent) {
        [self snapScrollView:scrollView];
    }
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView {
    self.shouldResponseToEndDraggingEvent = NO;
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    // 到达边界时，重载数据
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
    
    NSDate *leftDateOnScreen = [self leftDateOnScreen];
    
    if (![leftDateOnScreen isEqualToDate:self.currentDate]) {
        self.currentDate = leftDateOnScreen;
        [self.delegate weeklyCalendar:self didScrollToDate:leftDateOnScreen];
    }
}


#pragma mark - Setter

- (void)setDataSource:(id<CCWeeklyCalendarDataSource>)dataSource {
    _dataSource = dataSource;
    [self resetDayCellViews];
}

@end
