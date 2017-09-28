//
//  SiteOpsExtras.m
//  SiteOpsClient
//
//  Created by Radwar on 8/24/17.
//  Copyright © 2017 curbside. All rights reserved.
//

#import "SiteOpsExtras.h"

@import MapKit;

NSString *FormatDistance(float distance)
{
    static MKDistanceFormatter *_distanceFormatter = nil;
    static dispatch_once_t once = 0;
    dispatch_once(&once, ^{
        _distanceFormatter = [[MKDistanceFormatter alloc] init];
        _distanceFormatter.unitStyle = MKDistanceFormatterUnitStyleAbbreviated;
    });
    
    return [_distanceFormatter stringFromDistance:distance];
}

NSString *FormatSeconds(int totalSeconds)
{
    totalSeconds = abs(totalSeconds);
    float hours = floor(totalSeconds / 3600);
    int minutes = floor((totalSeconds - (hours * 3600)) / 60);
    int seconds = floor(totalSeconds % 60);
    if (seconds > 0 && minutes > 0) {
        seconds = 0;
        minutes++;
    }
    
    if (seconds < 0)
        NSLog(@"seconds");
    
    NSString *timeString;
    if ((hours > 0 && minutes > 0) || hours > 0) {
        BOOL needDecimalHours = (int)hours != hours;
        NSString *hoursString = hours == 1 ? @"hr" : @"hrs";
        if (minutes > 0) {
            if (needDecimalHours)
                timeString = [NSString stringWithFormat:@"%1.1f %@ %i min", hours, hoursString, minutes];
            else
                timeString = [NSString stringWithFormat:@"%1.0f %@ %i min", hours, hoursString, minutes];
        } else {
            if (needDecimalHours)
                timeString = [NSString stringWithFormat:@"%1.1f %@",hours, hoursString];
            else
                timeString = [NSString stringWithFormat:@"%1.0f %@",hours, hoursString];
        }
    } else if (minutes > 0) {
        timeString = [NSString stringWithFormat:@"%i min",minutes];
    } else {
        timeString = [NSString stringWithFormat:@"%i sec",seconds];
    }
    
    return  timeString;
}

NSString *FormatDate(NSDate *date)
{
    static NSDateFormatter *__dateFormatter = nil;
    static dispatch_once_t once = 0;
    dispatch_once(&once, ^{
        __dateFormatter = [[NSDateFormatter alloc] init];
        [__dateFormatter setDateFormat:@"h:mm:ss a"];
    });
    
    return [__dateFormatter stringFromDate:date];
}
