//
//  MSCLunarDate.h
//  MSCLunarDateDemo
//
//  Created by MiaoShichang on 2020/4/18.
//  Copyright © 2020 MiaoShichang. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MSCLunarDate : NSObject

// 支持的最小阳历和最大阳历日期
@property (class, nonatomic, strong, readonly) NSDate *minSolarDate;
@property (class, nonatomic, strong, readonly) NSDate *maxSolarDate;
// 支持的最小农历和最大农历日期
@property (class, nonatomic, strong, readonly) MSCLunarDate *minLunarDate;
@property (class, nonatomic, strong, readonly) MSCLunarDate *maxLunarDate;

@property (nonatomic, assign) NSInteger year;
@property (nonatomic, assign) NSInteger month;
@property (nonatomic, assign) NSInteger day;
@property (nonatomic, assign, getter=isLeap) BOOL bLeap; // 是否闰月

+ (instancetype)lunarDate;
+ (instancetype)lunarDateWithDate:(NSDate *)date;

// 转换成阳历
- (NSDate *)toSolarDate;
// 阳历转换成农历
+ (MSCLunarDate *)fromDate:(NSDate *)date;

// 检测农历是否存在
- (BOOL)checkLunarDate;

// 当年闰几月，0表示不闰月
+ (NSInteger)leapMonthForLunarYear:(NSInteger)year;
- (NSInteger)leapMonthForLunarYear:(NSInteger)year;

// 中国年名称 例如 "甲子"、"乙丑"等
- (NSString *)yearName;
// 中国月名称 例如 一月、二月等
- (NSString *)monthName;
// 中国日名称 例如 初一、初二等
- (NSString *)dayName;
// 属相 例如 鼠、牛等
- (NSString *)zodiacName;

@end

NS_ASSUME_NONNULL_END
