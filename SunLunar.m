//
//  SunLunar.m
//  NotePro
//
//  Created by Nguyen Van Toan on 28/06/2013.
//  Copyright (c) 2013 Horical. All rights reserved.
//

#import "SunLunar.h"

@implementation SunLunar

- (id) init
{
    self = [super init];
    
    //[self test];
    return self;
}

- (void) test
{
    TimeSL t = [self convertSunToLunar:29 month:6 year:2013 timeZone:[self getLocalTimeZoneNumber]];
    NSLog(@"Lunar day : %d %d %d", t.day, t.month, t.year);
    
    t = [self convertLunarToSun:5 month:5 year:t.year timeZone:[self getLocalTimeZoneNumber]];
    NSLog(@"Sun day : %d %d %d", t.day, t.month, t.year);
}

- (int) getLocalTimeZoneNumber
{
    NSDate *d = [NSDate date];

    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setTimeZone:[NSTimeZone systemTimeZone]];
    [df setDateFormat:@"Z"];
    int tz = [[[df stringFromDate:d] stringByReplacingOccurrencesOfString:@"0" withString:@""] intValue];
    [df release];
    
    return tz;
}

- (int) jdFromDate:(int)day month:(int)month year:(int)year
{
    int a, y, m, jd;
    
    a = ((14 - month) / 12);
    y = year + 4800 - a;
    m = month+12*a - 3;
    jd = day + (153*m+2)/5 + 365*y + y/4 - y/100 + y/400 - 32045;
    if (jd < 2299161)
    {
        jd = day + (153*m+2)/5 + 365*y + y/4 - 32083;
    }
    
    return jd;
}

- (TimeSL)jdToDate:(long long)jd
{
    long long a, b, c, d, e, m, day, month, year;
    
    if (jd > 2299160)
    { // After 5/10/1582, Gregorian calendar
        a = jd + 32044;
        b = (int)((4*a+3)/146097);
        c = a - (int)((b*146097)/4);
    }
    else
    {
        b = 0;
        c = jd + 32082;
    }
    
    d = (int)((4*c+3)/1461);
    e = c - (int)((1461*d)/4);
    m = (int)((5*e+2)/153);
    day = e - (int)((153*m+2)/5) + 1;
    month = m + 3 - 12*(int)(m/10);
    year = b*100 + d - 4800 + (int)(m/10);
    
    TimeSL t = {day=(int)day, month=(int)month, year=(int)year};
    return t;
}

- (int) getNewMoonDay:(CGFloat)k timeZone:(int)timeZone
{
    CGFloat T, T2, T3, dr, Jd1, M, Mpr, F, C1, deltat, JdNew;
    
    T = k/1236.85; // Time in Julian centuries from 1900 January 0.5
    T2 = T * T;
    T3 = T2 * T;
    dr = M_PI/180;
    Jd1 = 2415020.75933 + 29.53058868*k + 0.0001178*T2 - 0.000000155*T3;
    Jd1 = Jd1 + 0.00033*sin((166.56 + 132.87*T - 0.009173*T2)*dr); // Mean new moon
    M = 359.2242 + 29.10535608*k - 0.0000333*T2 - 0.00000347*T3; // Sun's mean anomaly
    Mpr = 306.0253 + 385.81691806*k + 0.0107306*T2 + 0.00001236*T3; // Moon's mean anomaly
    F = 21.2964 + 390.67050646*k - 0.0016528*T2 - 0.00000239*T3; // Moon's argument of latitude
    C1=(0.1734 - 0.000393*T)*sin(M*dr) + 0.0021*sin(2*dr*M);
    C1 = C1 - 0.4068*sin(Mpr*dr) + 0.0161*sin(dr*2*Mpr);
    C1 = C1 - 0.0004*sin(dr*3*Mpr);
    C1 = C1 + 0.0104*sin(dr*2*F) - 0.0051*sin(dr*(M+Mpr));
    C1 = C1 - 0.0074*sin(dr*(M-Mpr)) + 0.0004*sin(dr*(2*F+M));
    C1 = C1 - 0.0004*sin(dr*(2*F-M)) - 0.0006*sin(dr*(2*F+Mpr));
    C1 = C1 + 0.0010*sin(dr*(2*F-Mpr)) + 0.0005*sin(dr*(2*Mpr+M));
    
    if (T < -11)
    {
        deltat = 0.001 + 0.000839*T + 0.0002261*T2 - 0.00000845*T3 - 0.000000081*T*T3;
    }
    else
    {
        deltat= -0.000278 + 0.000265*T + 0.000262*T2;
    };
    
    JdNew = Jd1 + C1 - deltat;
    
    return (int)(JdNew + 0.5 + timeZone/24);
}

- (int) getSunLongitude:(CGFloat)jdn timeZone:(int)timeZone
{
    CGFloat T, T2, dr, M, L0, DL, L;
    
    T = (jdn - 2451545.5 - timeZone/24) / 36525; // Time in Julian centuries from 2000-01-01 12:00:00 GMT
    T2 = T*T;
    dr = M_PI/180; // degree to radian
    M = 357.52910 + 35999.05030*T - 0.0001559*T2 - 0.00000048*T*T2; // mean anomaly, degree
    L0 = 280.46645 + 36000.76983*T + 0.0003032*T2; // mean longitude, degree
    DL = (1.914600 - 0.004817*T - 0.000014*T2)*sin(dr*M);
    DL = DL + (0.019993 - 0.000101*T)*sin(dr*2*M) + 0.000290*sin(dr*3*M);
    L = L0 + DL; // true longitude, degree
    L = L*dr;
    L = L - M_PI*2*((int)(L/(M_PI*2))); // Normalize to (0, 2*PI)
    
    return (int)(L / M_PI * 6);
}

- (int) getLunarMonth11:(int)year timeZone:(int)timeZone
{
    long k, off, nm, sunLong;
    
    off = [self jdFromDate:31 month:12 year:year] - 2415021;
    k = (int)(off / 29.530588853);
    nm = [self getNewMoonDay:k timeZone:timeZone];
    sunLong = [self getSunLongitude:nm timeZone:timeZone]; // sun longitude at local midnight
    
    if (sunLong >= 9)
    {
        nm = [self getNewMoonDay:k-1 timeZone:timeZone];
    }
    
    return (int)(nm);
}

- (int) getLeapMonthOffset:(CGFloat)a11 timeZone:(int)timeZone
{
    int k, last, arc, i;
    
    k = (int)((a11 - 2415021.076998695) / 29.530588853 + 0.5);
    last = 0;
    i = 1; // We start with the month following lunar month 11
    arc = [self getSunLongitude:[self getNewMoonDay:k+i timeZone:timeZone] timeZone:timeZone];
    
    do {
        last = arc;
        i++;
        arc = [self getSunLongitude:[self getNewMoonDay:k+i timeZone:timeZone] timeZone:timeZone];
    } while (arc != last && i < 14);
    
    return i-1;
}

- (TimeSL) convertSunToLunar:(int)day month:(int)month year:(int)year timeZone:(int)timeZone
{
    CGFloat k, dayNumber, monthStart, a11, b11, lunarDay, lunarMonth, lunarYear, lunarLeap;
    
    dayNumber = [self jdFromDate:day month:month year:year];
    
    k = (int)((dayNumber - 2415021.076998695) / 29.530588853);
    monthStart = [self getNewMoonDay:k+1 timeZone:timeZone];
    if (monthStart > dayNumber)
    {
        monthStart = [self getNewMoonDay:k timeZone:timeZone];
    }
    
    a11 = [self getLunarMonth11:year timeZone:timeZone];
    b11 = a11;
    if (a11 >= monthStart)
    {
        lunarYear = year;
        a11 = [self getLunarMonth11:year-1 timeZone:timeZone];
    }
    else
    {
        lunarYear = year+1;
        b11 = [self getLunarMonth11:year+1 timeZone:timeZone];
    }
    
    lunarDay = dayNumber-monthStart+1;
    int diff = (int)((monthStart - a11)/29);
    lunarLeap = 0;
    lunarMonth = diff+11;
    if (b11 - a11 > 365)
    {
        CGFloat leapMonthDiff = [self getLeapMonthOffset:a11 timeZone:timeZone];
        if (diff >= leapMonthDiff)
        {
            lunarMonth = diff + 10;
            if (diff == leapMonthDiff)
            {
                lunarLeap = 1;
            }
        }
    }
    
    if (lunarMonth > 12)
    {
        lunarMonth = lunarMonth - 12;
    }
    
    if (lunarMonth >= 11 && diff < 4)
    {
        lunarYear -= 1;
    }
    
    TimeSL t = {day=(int)lunarDay, month=(int)lunarMonth, year=(int)lunarYear};
    return t;
}

- (TimeSL) convertLunarToSun:(int)day month:(int)month year:(int)year timeZone:(int)timeZone
{
    
    CGFloat k, a11, b11, off, leapOff, leapMonth, monthStart;
	if (month < 11)
    {
		a11 = [self getLunarMonth11:year-1 timeZone:timeZone];
        b11 = [self getLunarMonth11:year timeZone:timeZone];
	}
    else
    {
		a11 = [self getLunarMonth11:year timeZone:timeZone];
		b11 = [self getLunarMonth11:year+1 timeZone:timeZone];
	}
    
	k = (int)(0.5 + (a11 - 2415021.076998695) / 29.530588853);
	off = month - 11;
	if (off < 0)
    {
		off += 12;
	}
    
	if (b11 - a11 > 365)
    {
		leapOff = [self getLeapMonthOffset:a11 timeZone:timeZone];
		leapMonth = leapOff - 2;
		if (leapMonth < 0)
        {
			leapMonth += 12;
		}
        
		if (month != leapMonth)
        {
            TimeSL t = {0,0,0};
			return t;
		}
        else if (off >= leapOff)
        {
			off += 1;
		}
	}
    
	monthStart = [self getNewMoonDay:k+off timeZone:timeZone];
    return [self jdToDate:monthStart+day-1];
}

@end
