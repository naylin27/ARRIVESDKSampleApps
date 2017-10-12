//
//  MonitorExtras.h
//  MonitorApp
//
//  Created by Radwar on 8/24/17.
//  Copyright © 2017 curbside. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSString *kTrackingIdentifierKey = @"TrackingIdentifier";
static NSString *kSiteIdentifierKey = @"SiteIdentifier";

extern NSString *FormatDistance(float distance);
extern NSString *FormatSeconds(int totalSeconds);
extern NSString *FormatDate(NSDate *date);
