//
// NSDate+Helper.h
//
// Created by Billy Gray on 2/26/09.
// Copyright (c) 2009, 2010, ZETETIC LLC
// All rights reserved.
//
// Redistribution and use in source and binary forms, with or without
// modification, are permitted provided that the following conditions are met:
//     * Redistributions of source code must retain the above copyright
//       notice, this list of conditions and the following disclaimer.
//     * Redistributions in binary form must reproduce the above copyright
//       notice, this list of conditions and the following disclaimer in the
//       documentation and/or other materials provided with the distribution.
//     * Neither the name of the ZETETIC LLC nor the
//       names of its contributors may be used to endorse or promote products
//       derived from this software without specific prior written permission.
//
// THIS SOFTWARE IS PROVIDED BY ZETETIC LLC ''AS IS'' AND ANY
// EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
// WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
// DISCLAIMED. IN NO EVENT SHALL ZETETIC LLC BE LIABLE FOR ANY
// DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
// (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
// LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
// ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
// (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
// SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//

#import "NSDate+Helper.h"

@implementation NSDate (Helper)

/*
 * This guy can be a little unreliable and produce unexpected results,
 * you're better off using daysAgoAgainstMidnight
 */
- (NSUInteger)daysAgo {
    NSDateComponents *components =
        [[NSCalendar currentCalendar] components:(NSDayCalendarUnit)fromDate:self toDate:[NSDate date] options:0];
    return [components day];
}

- (NSInteger)secondAgo {
    NSDateComponents *components =
        [[NSCalendar currentCalendar] components:(NSSecondCalendarUnit)fromDate:self toDate:[NSDate date] options:0];
    return [components second];
}

- (NSInteger)minuteCompare:(NSDate *)date {
    NSDateComponents *components =
        [[NSCalendar currentCalendar] components:(NSMinuteCalendarUnit)fromDate:self toDate:date options:0];
    return [components minute];
}

- (NSInteger)dayCompare:(NSDate *)date {
    if (date == nil) {
        return 0;
    }
    NSDateComponents *components =
        [[NSCalendar currentCalendar] components:(NSDayCalendarUnit)fromDate:self toDate:date options:0];
    return [components day];
}

- (NSInteger)dayFCompare:(NSDate *)date {
    NSInteger dayInterval = [self dayCompare:date];
    if (0 == dayInterval) {
        NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        NSInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit |
                              NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
        NSDateComponents *comps = [calendar components:unitFlags fromDate:date];
        NSInteger day = [comps day];
        NSDateComponents *components = [calendar components:unitFlags fromDate:self];
        NSInteger nowDay = [components day];
        dayInterval = nowDay - day;
    }

    return dayInterval;
}

- (NSInteger)hourCompare:(NSDate *)date {
    NSDateComponents *components =
        [[NSCalendar currentCalendar] components:(NSHourCalendarUnit)fromDate:self toDate:date options:0];
    return [components hour];
}

- (NSUInteger)daysAgoAgainstMidnight {
    // get a midnight version of ourself:
    NSDateFormatter *mdf = [[NSDateFormatter alloc] init];
    [mdf setDateFormat:@"yyyy-MM-dd"];
    NSDate *midnight = [mdf dateFromString:[mdf stringFromDate:self]];

    return (int)[midnight timeIntervalSinceNow] / (60 * 60 * 24) * -1;
}

- (NSString *)stringDaysAgo {
    return [self stringDaysAgoAgainstMidnight:YES];
}

- (NSString *)stringDaysAgoAgainstMidnight:(BOOL)flag {
    NSUInteger daysAgo = (flag) ? [self daysAgoAgainstMidnight] : [self daysAgo];
    NSString *text = nil;
    switch (daysAgo) {
        case 0:
            text = @"Today";
            break;
        case 1:
            text = @"Yesterday";
            break;
        default:
            text = [NSString stringWithFormat:@"%lu days ago", (unsigned long)daysAgo];
    }
    return text;
}

- (NSUInteger)weekday {
    NSDateComponents *weekdayComponents =
        [[NSCalendar currentCalendar] components:(NSWeekdayCalendarUnit)fromDate:self];
    return [weekdayComponents weekday];
}

+ (NSDate *)dateFromString:(NSString *)string {
    return [NSDate dateFromString:string withFormat:[NSDate dbFormatString]];
}

+ (NSDate *)dateFromString:(NSString *)string withFormat:(NSString *)format {
    NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
    [inputFormatter setDateFormat:format];

    NSDate *date = [inputFormatter dateFromString:string];
    NSTimeZone *fromzone = [NSTimeZone systemTimeZone];
    NSInteger frominterval = [fromzone secondsFromGMTForDate:date];
    date = [date dateByAddingTimeInterval:frominterval];
    return date;
}

+ (NSString *)stringFromDate:(NSDate *)date withFormat:(NSString *)format {
    return [date stringWithFormat:format];
}

+ (NSString *)stringFromDate:(NSDate *)date {
    return [date string];
}

+ (NSString *)stringForDisplayFromDate:(NSDate *)date prefixed:(BOOL)prefixed alwaysDisplayTime:(BOOL)displayTime {
    /*
         * if the date is in today, display 12-hour time with meridian,
         * if it is within the last 7 days, display weekday name (Friday)
         * if within the calendar year, display as Jan 23
         * else display as Nov 11, 2008
         */

    NSDate *today = [NSDate date];
    NSDateComponents *offsetComponents =
        [[NSCalendar currentCalendar] components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit)
                                        fromDate:today];

    NSDate *midnight = [[NSCalendar currentCalendar] dateFromComponents:offsetComponents];

    NSString *displayString = nil;
    NSDateFormatter *displayFormatter = [[NSDateFormatter alloc] init];
    // comparing against midnight
    if ([date compare:midnight] == NSOrderedDescending) {
        if (prefixed) {
            [displayFormatter setDateFormat:@"'at' h:mm a"]; // at 11:30 am
        } else {
            [displayFormatter setDateFormat:@"h:mm a"]; // 11:30 am
        }
    } else {
        // check if date is within last 7 days
        NSDateComponents *componentsToSubtract = [[NSDateComponents alloc] init];
        [componentsToSubtract setDay:-7];
        NSDate *lastweek =
            [[NSCalendar currentCalendar] dateByAddingComponents:componentsToSubtract toDate:today options:0];
        if ([date compare:lastweek] == NSOrderedDescending) {
            if (displayTime)
                [displayFormatter setDateFormat:@"EEEE h:mm a"]; // Tuesday
            else
                [displayFormatter setDateFormat:@"EEEE"]; // Tuesday
        } else {
            // check if same calendar year
            NSInteger thisYear = [offsetComponents year];

            NSDateComponents *dateComponents =
                [[NSCalendar currentCalendar] components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit)
                                                fromDate:date];
            NSInteger thatYear = [dateComponents year];
            if (thatYear >= thisYear) {
                if (displayTime)
                    [displayFormatter setDateFormat:@"MMM d h:mm a"];
                else
                    [displayFormatter setDateFormat:@"MMM d"];
            } else {
                if (displayTime)
                    [displayFormatter setDateFormat:@"MMM d, yyyy h:mm a"];
                else
                    [displayFormatter setDateFormat:@"MMM d, yyyy"];
            }
        }
        if (prefixed) {
            NSString *dateFormat = [displayFormatter dateFormat];
            NSString *prefix = @"'on' ";
            [displayFormatter setDateFormat:[prefix stringByAppendingString:dateFormat]];
        }
    }

    // use display formatter to return formatted date string
    displayString = [displayFormatter stringFromDate:date];
    return displayString;
}

+ (NSString *)stringForDisplayFromDate:(NSDate *)date prefixed:(BOOL)prefixed {
    // preserve prior behavior
    return [self stringForDisplayFromDate:date prefixed:prefixed alwaysDisplayTime:NO];
}

+ (NSString *)stringForDisplayFromDate:(NSDate *)date {
    return [self stringForDisplayFromDate:date prefixed:NO];
}

- (NSString *)stringWithFormat:(NSString *)format {
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    [outputFormatter setDateFormat:format];
    NSString *timestamp_str = [outputFormatter stringFromDate:self];
    return timestamp_str;
}

- (NSString *)string {
    return [self stringWithFormat:[NSDate dbFormatString]];
}

- (NSString *)stringWithDateStyle:(NSDateFormatterStyle)dateStyle timeStyle:(NSDateFormatterStyle)timeStyle {
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    [outputFormatter setDateStyle:dateStyle];
    [outputFormatter setTimeStyle:timeStyle];
    NSString *outputString = [outputFormatter stringFromDate:self];
    return outputString;
}

- (NSDate *)beginningOfWeek {
    // largely borrowed from "Date and Time Programming Guide for Cocoa"
    // we'll use the default calendar and hope for the best

    NSDate *beginningOfWeek = nil;
    BOOL ok = [[NSCalendar currentCalendar] rangeOfUnit:NSWeekCalendarUnit
                                              startDate:&beginningOfWeek
                                               interval:NULL
                                                forDate:self];
    if (ok) {
        return beginningOfWeek;
    }

    // couldn't calc via range, so try to grab Sunday, assuming gregorian style
    // Get the weekday component of the current date
    NSDateComponents *weekdayComponents = [[NSCalendar currentCalendar] components:NSWeekdayCalendarUnit fromDate:self];

    /*
     Create a date components to represent the number of days to subtract from the current date.
     The weekday value for Sunday in the Gregorian calendar is 1, so subtract 1 from the number of days to subtract from
     the date in question.  (If today's Sunday, subtract 0 days.)
     */
    NSDateComponents *componentsToSubtract = [[NSDateComponents alloc] init];
    [componentsToSubtract setDay:0 - ([weekdayComponents weekday] - 1)];
    beginningOfWeek = nil;
    beginningOfWeek = [[NSCalendar currentCalendar] dateByAddingComponents:componentsToSubtract toDate:self options:0];

    // normalize to midnight, extract the year, month, and day components and create a new date from those components.
    NSDateComponents *components =
        [[NSCalendar currentCalendar] components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit)
                                        fromDate:beginningOfWeek];
    return [[NSCalendar currentCalendar] dateFromComponents:components];
}

- (NSDate *)beginningOfDay {
    // Get the weekday component of the current date
    NSDateComponents *components =
        [[NSCalendar currentCalendar] components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit)
                                        fromDate:self];
    return [[NSCalendar currentCalendar] dateFromComponents:components];
}

- (NSDate *)endOfWeek {
    // Get the weekday component of the current date
    NSDateComponents *weekdayComponents = [[NSCalendar currentCalendar] components:NSWeekdayCalendarUnit fromDate:self];
    NSDateComponents *componentsToAdd = [[NSDateComponents alloc] init];
    // to get the end of week for a particular date, add (7 - weekday) days
    [componentsToAdd setDay:(7 - [weekdayComponents weekday])];
    NSDate *endOfWeek = [[NSCalendar currentCalendar] dateByAddingComponents:componentsToAdd toDate:self options:0];

    return endOfWeek;
}

+ (NSString *)dateFormatString {
    return @"yyyy-MM-dd";
}

+ (NSString *)timeFormatString {
    return @"HH:mm:ss";
}

+ (NSString *)timestampFormatString {
    return @"yyyy-MM-dd HH:mm:ss";
}

// preserving for compatibility
+ (NSString *)dbFormatString {
    return [NSDate timestampFormatString];
}

+ (NSString *)dateFormatString:(NSDate *)date {
    NSString *showDate = nil;
    NSDate *curendate = [NSDate date];
    NSInteger inter = [date dayCompare:curendate];

    if (ABS(inter) > 1) {
        showDate = [date stringWithFormat:@"yyyy-MM-dd HH:mm"];
    } else if (inter == 0) {
        {
            if ([date dayFCompare:date] == 0 || [date compare:date] == NSOrderedSame) {
                showDate = [NSString stringWithFormat:@"今天 %@", [date stringWithFormat:@"HH:mm"]];
            } else if (1 != labs([date dayFCompare:date]) || [date compare:date] == NSOrderedAscending) {
                showDate = [date stringWithFormat:@"yyyy-MM-dd HH:mm"];
            } else {
                showDate = [NSString stringWithFormat:@"昨天 %@", [date stringWithFormat:@"HH:mm"]];
            }
        }
    } else if (1 == inter) {
        long cuday = [date dayFCompare:date];
        if (labs(cuday) > 1) {
            showDate = [date stringWithFormat:@"yyyy-MM-dd HH:mm"];
        } else {
            showDate = [NSString stringWithFormat:@"昨天 %@", [date stringWithFormat:@"HH:mm"]];
        }
    } else {
        showDate = [date stringWithFormat:@"yyyy-MM-dd HH:mm"];
    }

    return showDate;
}

#pragma mark - Schedule

- (NSDate *)lastDayOfMonth {
    NSInteger dayCount = [self numberOfDaysInMonthCount];

    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];

    [calendar setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];

    NSDateComponents *comp =
        [calendar components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit fromDate:self];

    [comp setDay:dayCount];

    return [calendar dateFromComponents:comp];
}

- (NSInteger)numberOfDaysInMonthCount {
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];

    //    [calendar setTimeZone:[NSTimeZone timeZoneWithName:TIMEZONE]];

    NSRange dayRange = [calendar rangeOfUnit:NSDayCalendarUnit inUnit:NSMonthCalendarUnit forDate:self];

    return dayRange.length;
}

- (NSInteger)numberOfWeekInMonthCount {

    NSCalendar *calender = [NSCalendar currentCalendar];
    NSRange weekRange = [calender rangeOfUnit:NSWeekCalendarUnit inUnit:NSMonthCalendarUnit forDate:self];
    return weekRange.length;
}

- (NSDateComponents *)componentsOfDate {

    return [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear |
                                                    NSCalendarUnitWeekday | NSHourCalendarUnit | NSMinuteCalendarUnit
                                           fromDate:self];
}

#pragma mark - Methods Statics
+ (NSDateComponents *)componentsOfCurrentDate {

    return [NSDate componentsOfDate:[NSDate date]];
}

+ (NSDateComponents *)componentsOfDate:(NSDate *)date {

    return [[NSCalendar currentCalendar]
        components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear | NSCalendarUnitWeekday |
                   NSCalendarUnitWeekOfMonth | NSHourCalendarUnit | NSMinuteCalendarUnit
          fromDate:date];
}

+ (NSDate *)dateWithYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day {

    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [NSDate componentsWithYear:year month:month day:day];

    return [calendar dateFromComponents:components];
}


+ (NSDate *)dateWithHour:(NSInteger)hour min:(NSInteger)min {

    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [NSDate componentsWithHour:hour min:min];

    return [calendar dateFromComponents:components];
}

+ (NSString *)stringTimeOfDate:(NSDate *)date {

    NSDateFormatter *dateFormater = [NSDateFormatter new];
    [dateFormater setDateFormat:@"HH:mm"];

    return [dateFormater stringFromDate:date];
}

+ (NSDateComponents *)componentsWithYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day {

    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setYear:year];
    [components setMonth:month];
    [components setDay:day];

    return components;
}

+ (NSDateComponents *)componentsWithHour:(NSInteger)hour min:(NSInteger)min {

    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setHour:hour];
    [components setMinute:min];

    return components;
}

+ (BOOL)isTheSameDateTheCompA:(NSDateComponents *)compA compB:(NSDateComponents *)compB {

    return ([compA day] == [compB day] && [compA month] == [compB month] && [compA year] == [compB year]);
}

+ (BOOL)isTheSameTimeTheCompA:(NSDateComponents *)compA compB:(NSDateComponents *)compB {

    return ([compA hour] == [compB hour] && [compA minute] == [compB minute]);
}


@end
