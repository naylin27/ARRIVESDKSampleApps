//
//  CustomerTableViewCell.m
//  MonitorApp
//
//  Created by Radwar on 8/24/17.
//  Copyright © 2017 curbside. All rights reserved.
//

#import "CustomerTableViewCell.h"
#import "MonitorExtras.h"
@import Curbside;

@interface CustomerTableViewCell ()

@property (strong, nonatomic) IBOutlet UILabel *customerNameTIDLabel;
@property (strong, nonatomic) IBOutlet UILabel *etaValueLabel;
@property (strong, nonatomic) IBOutlet UILabel *distanceValueLabel;
@property (strong, nonatomic) IBOutlet UILabel *dateValueLabel;
@property (strong, nonatomic) IBOutlet UILabel *statusLabel;
@property (strong, nonatomic) IBOutlet UILabel *trackTokenLabel;

@property (strong, nonatomic) IBOutlet UIButton *endTripButton;
@property (strong, nonatomic) IBOutlet UIButton *cancelTripButton;

@property (strong, nonatomic) NSString *trackToken;
@end

@implementation CustomerTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _endTripButton.layer.cornerRadius = 4.0;
    _cancelTripButton.layer.cornerRadius = 4.0;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)setUserStatusUpdate:(CSUserStatusUpdate *)userStatusUpdate
{
    _userStatusUpdate = userStatusUpdate;
    NSString *customerName = userStatusUpdate.userInfo.fullName;
    if (customerName.length == 0)
        customerName = userStatusUpdate.trackingIdentifier;
    _customerNameTIDLabel.text = customerName;
    int distanceFromSite = userStatusUpdate.distanceFromSite;
    _distanceValueLabel.text = monitor_FormatDistance(userStatusUpdate.distanceFromSite);
    int eta = userStatusUpdate.estimatedTimeOfArrival;
    _etaValueLabel.text = eta > 0 ?  monitor_FormatSeconds(eta) : @"-";
    _dateValueLabel.text = FormatDate(userStatusUpdate.lastUpdateTimestamp);
    switch (_userStatusUpdate.userStatus) {
        case CSUserStatusArrived:
            _statusLabel.text = @"Arrived";
            break;
        case CSUserStatusInTransit:
            _statusLabel.text = @"In Transit";
            break;
        case CSUserStatusApproaching:
            _statusLabel.text = @"Approaching Site";
            break;
        case CSUserStatusUserInitiatedArrived:
            _statusLabel.text = @"Customer Initiated Arrived";
            break;
        case CSUserStatusUnknown:
            _statusLabel.text = @"Unknown";
            if (distanceFromSite == 0)
                _distanceValueLabel.text = @"-";
            break;
    }
    
#warning Note this is taking the first trackToken and using that trackToken for dispaly and cancel/Stop.
    CSTripInfo *firstTripInfo = [_userStatusUpdate.tripInfos firstObject];
    _trackToken = firstTripInfo.trackToken;
    _trackTokenLabel.text = _trackToken;
}

- (IBAction)cancelTrip:(id)sender {
    [[CSMonitoringSession currentSession] cancelTripForTrackingIdentifier:_userStatusUpdate.trackingIdentifier trackTokens:@[_trackToken]];
}

- (IBAction)endTrip:(id)sender {
    [[CSMonitoringSession currentSession] completeTripForTrackingIdentifier:_userStatusUpdate.trackingIdentifier trackTokens:@[_trackToken]];
}
@end
