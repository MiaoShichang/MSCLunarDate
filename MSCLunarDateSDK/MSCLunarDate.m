//
//  MSCLunarDate.m
//  MSCLunarDateDemo
//
//  Created by MiaoShichang on 2020/4/18.
//  Copyright © 2020 MiaoShichang. All rights reserved.
//

#import "MSCLunarDate.h"
//#import "RMDateManager.h"


#define MSCLunarDate_MIN_YEAR 1901
#define MSCLunarDate_MAX_YEAR 2099

// Lunar 农历

/*
  bit23 bit22 bit21 bit20: 表示当年闰月月份，值为0 为则表示当年无闰月
  bit19 bit18 bit17 bit16 bit15 bit14 bit13 bit12 bit11 bit10 bit9 bit8 bit7
    1     2     3     4     5     6     7     8     9     10    11   12   13
  农历1-13 月大小 。月份对应位为1，农历月大(30 天),为0 表示小(29 天)
  bit6 bit5 春节的阳历月份
  bit4 bit3 bit2 bit1 bit0 春节的阳历日期
*/
unsigned int lunar_info[199] = {
    0x04AE53,0x0A5748,0x5526BD,0x0D2650,0x0D9544,0x46AAB9,0x056A4D,0x09AD42,0x24AEB6,0x04AE4A,/*1901-1910*/
    0x6A4DBE,0x0A4D52,0x0D2546,0x5D54BA,0x0B554E,0x056A44,0x296D37,0x095B4B,0x749BC1,0x049B54,/*1911-1920*/
    0x0A4B48,0x5B25BC,0x06A550,0x06D445,0x4ADAB8,0x02B64D,0x095742,0x2497B7,0x04974A,0x664B3E,/*1921-1930*/
    0x0D4A51,0x0EA546,0x56D4BA,0x05AD4E,0x02B644,0x393738,0x092E4B,0x7C96BF,0x0C9553,0x0D4A48,/*1931-1940*/
    0x6DA53B,0x0B554F,0x056A45,0x4AADB9,0x025D4D,0x092D42,0x2C95B6,0x0A954A,0x7B4ABD,0x06CA51,/*1941-1950*/
    0x0B5546,0x555ABB,0x04DA4E,0x0A5B43,0x352BB8,0x052B4C,0x8A953F,0x0E9552,0x06AA48,0x6AD53C,/*1951-1960*/
    0x0AB54F,0x04B645,0x4A5739,0x0A574D,0x052642,0x3E9335,0x0D9549,0x75AABE,0x056A51,0x096D46,/*1961-1970*/
    0x54AEBB,0x04AD4F,0x0A4D43,0x4D26B7,0x0D254B,0x8D52BF,0x0B5452,0x0B6A47,0x696D3C,0x095B50,/*1971-1980*/
    0x049B45,0x4A4BB9,0x0A4B4D,0xAB25C2,0x06A554,0x06D449,0x6ADA3D,0x0AB651,0x095746,0x5497BB,/*1981-1990*/
    0x04974F,0x064B44,0x36A537,0x0EA54A,0x86B2BF,0x05AC53,0x0AB647,0x5936BC,0x092E50,0x0C9645,/*1991-2000*/
    0x4D4AB8,0x0D4A4C,0x0DA541,0x25AAB6,0x056A49,0x7AADBD,0x025D52,0x092D47,0x5C95BA,0x0A954E,/*2001-2010*/
    0x0B4A43,0x4B5537,0x0AD54A,0x955ABF,0x04BA53,0x0A5B48,0x652BBC,0x052B50,0x0A9345,0x474AB9,/*2011-2020*/
    0x06AA4C,0x0AD541,0x24DAB6,0x04B64A,0x6A573D,0x0A4E51,0x0D2646,0x5E933A,0x0D534D,0x05AA43,/*2021-2030*/
    0x36B537,0x096D4B,0xB4AEBF,0x04AD53,0x0A4D48,0x6D25BC,0x0D254F,0x0D5244,0x5DAA38,0x0B5A4C,/*2031-2040*/
    0x056D41,0x24ADB6,0x049B4A,0x7A4BBE,0x0A4B51,0x0AA546,0x5B52BA,0x06D24E,0x0ADA42,0x355B37,/*2041-2050*/
    0x09374B,0x8497C1,0x049753,0x064B48,0x66A53C,0x0EA54F,0x06B244,0x4AB638,0x0AAE4C,0x092E42,/*2051-2060*/
    0x3C9735,0x0C9649,0x7D4ABD,0x0D4A51,0x0DA545,0x55AABA,0x056A4E,0x0A6D43,0x452EB7,0x052D4B,/*2061-2070*/
    0x8A95BF,0x0A9553,0x0B4A47,0x6B553B,0x0AD54F,0x055A45,0x4A5D38,0x0A5B4C,0x052B42,0x3A93B6,/*2071-2080*/
    0x069349,0x7729BD,0x06AA51,0x0AD546,0x54DABA,0x04B64E,0x0A5743,0x452738,0x0D164A,0x8E933E,/*2081-2090*/
    0x0D5252,0x0DAA47,0x66B53B,0x056D4F,0x04AE45,0x4A4EB9,0x0A4D4C,0x0D1541,0x2D92B5          /*2091-2099*/
};

@implementation MSCLunarDate
 
+ (instancetype)lunarDate {
    return [[MSCLunarDate alloc] init];
}

+ (instancetype)lunarDateWithDate:(NSDate *)date {
    return [MSCLunarDate fromDate:date];
}

+ (NSDate *)minSolarDate {
    return [self dateWithSolarYear:1901 month:2 day:19];
}

+ (NSDate *)maxSolarDate {
    return [self dateWithSolarYear:2100 month:2 day:8];
}

+ (MSCLunarDate *)minLunarDate {
    MSCLunarDate *lunarDate = [MSCLunarDate lunarDate];
    lunarDate.year = 1901;
    lunarDate.month = 1;
    lunarDate.day = 1;
    return lunarDate;
}

+ (MSCLunarDate *)maxLunarDate {
    MSCLunarDate *lunarDate = [MSCLunarDate lunarDate];
    lunarDate.year = 2099;
    lunarDate.month = 12;
    lunarDate.day = 30;
    return lunarDate;
}

// 是否是闰年
- (BOOL)isLeapYearForSolar:(NSInteger)year {
    return  ( (((year % 4) == 0)&&((year % 100) !=0)) || ((year % 400) ==0) );
}

//0x04AE53 == 0000 0100 1010 1110 0  101 0011
// 返回year那年中闰几月，0 表示不闰月
+ (NSInteger)leapMonthForLunarYear:(NSInteger)year {
    if (year < MSCLunarDate_MIN_YEAR || year > MSCLunarDate_MAX_YEAR ) {
        return 0;
    }
    return((lunar_info[year-MSCLunarDate_MIN_YEAR] & 0xf00000) >>20);
}

- (NSInteger)leapMonthForLunarYear:(NSInteger)year {
    return [self.class leapMonthForLunarYear:year];
}

// 在year那年每月month中包含多少天
- (NSInteger)daysForLunarYear:(NSInteger)year month:(NSInteger)month {
    if (year < MSCLunarDate_MIN_YEAR || year > MSCLunarDate_MAX_YEAR ) {
        return 0;
    }
    if (month < 0 || month >13) {
        return 0;
    }
    return( (lunar_info[year-MSCLunarDate_MIN_YEAR] & (0x80000>>(month-1)))? 30: 29 );
}

// 返回春节在阳历的哪个月
- (NSInteger)monthOfSpringDateForLunarYear:(NSInteger)year {
    return (lunar_info[year-MSCLunarDate_MIN_YEAR] & 0x0060) >> 5;
}

// 返回春节在阳历的那个月中哪一天
- (NSInteger)dayOfSpringDateForLunarYear:(NSInteger)year {
    return lunar_info[year-MSCLunarDate_MIN_YEAR]&0x1f;
}

// 检查农历是否正确
- (BOOL)checkLunarDate {
    if ((self.year < MSCLunarDate_MIN_YEAR) || (self.year > MSCLunarDate_MAX_YEAR)){
       return NO;
    }
    if ((self.month < 1) || (self.month > 12)){
       return NO;
    }
    if ((self.day < 1) || (self.day > 30)){ //农历每月最多30天
      return NO;
    }
    
    NSInteger leapMonth = [self leapMonthForLunarYear:self.year];
    if (self.isLeap) {
        if(self.month != leapMonth) {
            return NO;
        }
        else if([self daysForLunarYear:self.year month:self.month+1] < self.day) {
            return NO;
        }
    }
    else {
        // 考虑闰月的情况 要对月份进行处理
        NSInteger leapMonth = [self leapMonthForLunarYear:self.year];
        NSInteger month = self.month;
        if (leapMonth > 0 && leapMonth < self.month) {
                month += 1;
        }
        if ([self daysForLunarYear:self.year month:month] < self.day) {
            return NO;
        }
    }
    return YES;
}

- (NSArray *)monthsOfSolarYear:(NSInteger)solorYear {
    NSArray *monthDays = nil;
    BOOL bLeapYearOfSolar = [self isLeapYearForSolar:solorYear];
    if (bLeapYearOfSolar) {
        monthDays = @[@31, @29, @31, @30, @31, @30, @31, @31, @30, @31, @30, @31];
    }
    else {
        monthDays = @[@31, @28, @31, @30, @31, @30, @31, @31, @30, @31, @30, @31];
    }
    return monthDays;
}

- (NSInteger)daysOfMonthForSolarYear:(NSInteger)year month:(NSInteger)month {
    if (month < 0 || month > 12) {
        return 0;
    }
    NSArray *months = [self monthsOfSolarYear:year];
    return [months[month-1] integerValue];
}

- (NSInteger)daysOfSolarYear:(NSInteger)year {
    NSInteger days = 0;
    NSArray *monthDays = [self monthsOfSolarYear:year];
    for (int i = 0; i < monthDays.count; i++) {
        days += [monthDays[i] integerValue];
    }
    return days;
}

- (NSInteger)passedDaysForSolarYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day {
    NSInteger daysOfPassedForSolar = 0;
    NSArray *monthDays = [self monthsOfSolarYear:year];
    for (NSUInteger i = 0; i < month-1 ; i++) {
        NSInteger days = [monthDays[i] integerValue];
        daysOfPassedForSolar += days;
    }
    daysOfPassedForSolar += day;
    return daysOfPassedForSolar;
}

- (NSInteger)daysOfFromNewYearToSpringForLunarYear:(NSInteger)year {
    // 正月初一是阳历的那一月那一天
    NSInteger solarMonthOfSpring = [self monthOfSpringDateForLunarYear:year];
    NSInteger solarDayOfSpring = [self dayOfSpringDateForLunarYear:year];
    // 元旦离春节的天数
    NSInteger daysOfFromNewYearToSpring = solarDayOfSpring - 1;
    if(solarMonthOfSpring == 2) {
        daysOfFromNewYearToSpring += 31;
    }
    return daysOfFromNewYearToSpring;
}

+ (NSDate *)dateWithSolarYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day {
    if (month < 1 || month > 12) {
        return nil;
    }
    if (day < 1 || day > 31) {
        return nil;
    }
    //设置转换格式
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
    [formatter setDateFormat:@"yyyy/M/d"];
    NSString *str = [NSString stringWithFormat:@"%ld/%ld/%ld", (long)year, (long)month, (long)day];
    NSDate *toDate=[formatter dateFromString:str];
    return toDate;
}

- (NSDate *)dateWithSolarYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day {
    return [self.class dateWithSolarYear:year month:month day:day];
}

- (NSDate *)toSolarDate{
    if (![self checkLunarDate]) {
        return nil;
    }
    NSInteger yearForSolar = self.year;
    NSInteger monthForSolar = 0;
    NSInteger dayForSolar = 0;
    
    // 元旦离春节的天数
    NSInteger daysOfFromNewYearToSpring = [self daysOfFromNewYearToSpringForLunarYear:self.year];
    // 农历已经过了多少天   注意添加闰月的天数
    NSInteger daysOfPassedForLunar = 0;
    NSInteger leapMonth = [self leapMonthForLunarYear:self.year];
    NSInteger indexOfMonthForLunar = self.month;
    if(self.isLeap || (leapMonth > 0 && leapMonth < self.month)) {
        indexOfMonthForLunar += 1;
    }
    for(NSInteger i = 1; i < indexOfMonthForLunar; i++){
        daysOfPassedForLunar += [self daysForLunarYear:self.year month:i];
    }
    daysOfPassedForLunar += self.day;
    
    // 阳历过了多少天
    NSInteger daysOfPassedForSolar = daysOfPassedForLunar + daysOfFromNewYearToSpring;
    // 一年有多少天
    NSInteger daysOfYearForSolar = [self daysOfSolarYear:self.year];
    if (daysOfPassedForSolar > daysOfYearForSolar) { // 阳历新的一年过了多少天
        yearForSolar++;
        daysOfPassedForSolar -= daysOfYearForSolar;
    }
    // 计算月份和日子
    for (NSUInteger i = 1; i <= 12; i++) {
        NSInteger daysOfMonthForSolar = [self daysOfMonthForSolarYear:yearForSolar month:i];
        if (daysOfPassedForSolar <= daysOfMonthForSolar) {
            monthForSolar = i;
            dayForSolar = daysOfPassedForSolar;
            break;
        }
        daysOfPassedForSolar -= daysOfMonthForSolar;
    }
    NSDate *date = [self dateWithSolarYear:yearForSolar month:monthForSolar day:dayForSolar];
    return date;
}

+ (MSCLunarDate *)fromDate:(NSDate *)date {
    return [[MSCLunarDate lunarDate] fromDate:date];
}

- (MSCLunarDate *)fromDate:(NSDate *)date {
    NSCalendar* calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:date];
    NSInteger yearForSolar = components.year;
    NSInteger monthForSolar = components.month;
    NSInteger dayForSolar = components.day;
    
    MSCLunarDate *lunarDate = [MSCLunarDate lunarDate];
    lunarDate.year = yearForSolar;
    
    // 已经过了多少天
    NSInteger daysOfPassedForSolar = [self passedDaysForSolarYear:yearForSolar month:monthForSolar day:dayForSolar];
    // 元旦离春节的天数
    NSInteger daysOfFromNewYearToSpring = [self daysOfFromNewYearToSpringForLunarYear:lunarDate.year];
    // 当前date日期 在农历春节前（不包含春节）
    if (daysOfPassedForSolar <= daysOfFromNewYearToSpring) {
        lunarDate.year -= 1;
        daysOfFromNewYearToSpring = [self daysOfFromNewYearToSpringForLunarYear:lunarDate.year];
        daysOfPassedForSolar += [self daysOfSolarYear:lunarDate.year];
    }
    else { // 当前date日期在农历春节后（包含春节）

    }
    
    NSInteger daysOfPassedForLunar = daysOfPassedForSolar-daysOfFromNewYearToSpring;
    NSInteger monthCountOfYearForLunar = 12;
    NSInteger leapMonth = [self leapMonthForLunarYear:lunarDate.year];
    if (leapMonth > 0) {
        monthCountOfYearForLunar = 13;
    }
    for (NSInteger i = 1; i <= monthCountOfYearForLunar; i++) {
        NSInteger daysOfMonthForLunar = [self daysForLunarYear:lunarDate.year month:i];
        if(daysOfPassedForLunar-daysOfMonthForLunar <= 0){
            if (leapMonth > 0) { // 当前农历年有闰月
                if (leapMonth < i) {
                    lunarDate.month = i-1;
                    if (leapMonth == i-1) {
                        lunarDate.bLeap = YES;
                    }
                }
                else{
                    lunarDate.month = i;
                }
            }
            else {
                lunarDate.month = i;
            }
            lunarDate.day = daysOfPassedForLunar;
            break;
        }
        daysOfPassedForLunar -=daysOfMonthForLunar;
    }
    return lunarDate;
}

- (NSString *)yearName {
    NSArray *chineseYears = @[
        @"甲子",   @"乙丑",  @"丙寅",  @"丁卯",  @"戊辰",  @"己巳",  @"庚午",  @"辛未",  @"壬申",  @"癸酉",
        @"甲戌",   @"乙亥",  @"丙子",  @"丁丑",  @"戊寅",  @"己卯",  @"庚辰",  @"辛己",  @"壬午",  @"癸未",
        @"甲申",   @"乙酉",  @"丙戌",  @"丁亥",  @"戊子",  @"己丑",  @"庚寅",  @"辛卯",  @"壬辰",  @"癸巳",
        @"甲午",   @"乙未",  @"丙申",  @"丁酉",  @"戊戌",  @"己亥",  @"庚子",  @"辛丑",  @"壬寅",  @"癸丑",
        @"甲辰",   @"乙巳",  @"丙午",  @"丁未",  @"戊申",  @"己酉",  @"庚戌",  @"辛亥",  @"壬子",  @"癸丑",
        @"甲寅",   @"乙卯",  @"丙辰",  @"丁巳",  @"戊午",  @"己未",  @"庚申",  @"辛酉",  @"壬戌",  @"癸亥"];

    NSInteger indexOfYear = (self.year-(1901-37))%60;
    if (indexOfYear < 0) {
        return @"";
    }
    return chineseYears[indexOfYear];
}

- (NSString *)monthName {
    NSArray *chineseMonths = @[@"正月", @"二月", @"三月", @"四月", @"五月", @"六月", @"七月", @"八月", @"九月", @"十月", @"冬月", @"腊月"];
    if (self.month < 1 || self.month > 12) {
        return @"";
    }
    if(self.isLeap) {
        return [NSString stringWithFormat:@"闰%@", chineseMonths[self.month-1]];
    }
    return chineseMonths[self.month-1];
}

- (NSString *)dayName {
    NSArray *chineseDays = @[ @"初一", @"初二", @"初三", @"初四", @"初五", @"初六", @"初七", @"初八", @"初九", @"初十", @"十一", @"十二", @"十三", @"十四", @"十五", @"十六", @"十七", @"十八", @"十九", @"二十", @"廿一", @"廿二", @"廿三", @"廿四", @"廿五", @"廿六", @"廿七", @"廿八", @"廿九", @"三十"];
    if (self.day < 1 || self.day > 30) {
        return @"";
    }
    return chineseDays[self.day-1];
}

- (NSString *)zodiacName {
    NSArray *zodiacs = @[@"鼠", @"牛", @"虎", @"兔", @"龙", @"蛇", @"马", @"羊", @"猴", @"鸡", @"狗", @"猪"];
    NSInteger index = (self.year -(1901-1))%12;
    if (index < 0) {
        return @"";
    }
    return zodiacs[index];
}

- (NSString *)description {
    if ([self checkLunarDate]) {
        return [NSString stringWithFormat:@"农历 %@ %@年 %@%@", [self yearName], [self zodiacName], [self monthName], [self dayName]];
    }
    return [NSString stringWithFormat:@"该农历日期错误【year=%ld, month=%ld, day=%ld, bLaap=%ld】", (long)self.year, (long)self.month, (long)self.day, (long)self.bLeap];
}


@end
