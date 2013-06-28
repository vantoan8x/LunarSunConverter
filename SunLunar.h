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

// Convert Sun Calenda to Lunar
- (TimeSL) convertSunToLunar:(int)day month:(int)month year:(int)year timeZone:(int)timeZone;

// Convert Lunar to Sun Calenda
- (TimeSL) convertLunarToSun:(int)day month:(int)month year:(int)year timeZone:(int)timeZone;

// Get Current Local TimeZone
- (int) getLocalTimeZoneNumber;

@end
