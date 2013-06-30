//
//  SunLunar.h
//  NotePro
//
//  Created by Nguyen Van Toan on 28/06/2013.
//  Copyright (c) 2013 Horical. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef struct
{
    int day;
    int month;
    int year;
} TimeSL;

@interface SunLunar : NSObject

// Convert Sun calendar to Lunar
- (TimeSL) convertSunToLunar:(TimeSL)date timeZone:(int)timeZone;

// Convert Sun calendar to Lunar
- (TimeSL) convertSunToLunar:(int)day month:(int)month year:(int)year timeZone:(int)timeZone;

// Convert Lunar to Sun calendar
- (TimeSL) convertLunarToSun:(TimeSL)date timeZone:(int)timeZone;

// Convert Lunar to Sun calendar
- (TimeSL) convertLunarToSun:(int)day month:(int)month year:(int)year lunarLeap:(int)lunarLeap timeZone:(int)timeZone;

// Get Date Components
- (TimeSL) getDateComponentsBy:(NSDate*)date;

// Get Today
- (TimeSL) getToday;

// Get Next Day
- (TimeSL) getPreviousDayBy:(NSDate*)date;

// Get Next Day
- (TimeSL) getPreviousDayBy:(int)day month:(int)month year:(int)year;

// Get Next Day
- (TimeSL) getNextDayBy:(NSDate*)date;

// Get Next Day
- (TimeSL) getNextDayBy:(int)day month:(int)month year:(int)year;

// Get count day of a Month
- (int) getNumberDayOfMonth:(int)month year:(int)year;

// get NSDate by Time separated numbers
- (NSDate*) getDateTimeBy:(int)day month:(int)month year:(int)year hour:(int)hour minute:(int)minute second:(int)second;

// Get Day of Week, Sunday = 1
- (int) getWeekDayBy:(int)day month:(int)month year:(int)year;

// Get Day of Week, Sunday = 1
- (int) getWeekDayBy:(NSDate*)date;

// Get Week of Year,
- (int) getYearWeekBy:(int)day month:(int)month year:(int)year;

// get Week of Year,
- (int) getYearWeekBy:(NSDate*)date;

// Get Day of Year,
- (int) getYearDayBy:(int)day month:(int)month year:(int)year;

// get Day of Year
- (int) getYearDayBy:(NSDate*)date;

// Get Week of Month,
- (int) getMonthWeekBy:(int)day month:(int)month year:(int)year;

// get Week of Month,
- (int) getMonthWeekBy:(NSDate*)date;

// Add some days to a day
- (TimeSL) addSomeDaysTo:(int)day month:(int)month year:(int)year addDays:(int)addDays;

// Add some days to a day
- (TimeSL) addSomeDaysTo:(TimeSL)day addDays:(int)addDays;

// Add some Months to a Date
- (TimeSL) addSomeMonthsTo:(TimeSL)day addMonths:(int)addMonths;

// Add some Months to a Date
- (TimeSL) addSomeMonthsTo:(int)month year:(int)year addMonths:(int)addMonths;

// Get Current Local TimeZone
- (int) getLocalTimeZoneNumber;

// Get Lunar Next Day from Lunar day
- (TimeSL) getLunarNextDay:(int)day month:(int)month year:(int)year;

// Get Lunar Previous Day from Lunar day
- (TimeSL) getLunarPreviousDay:(int)day month:(int)month year:(int)year;

// Get Leap From Sun Date
- (int) getLunarLeapFromSunDate:(int)day month:(int)month year:(int)year timeZone:(int)timeZone;

@end
