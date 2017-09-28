//
//  CustomerTableViewCell.m
//  SiteOpsClient
//
//  Created by Radwar on 8/24/17.
//  Copyright © 2017 curbside. All rights reserved.
//

#import "CustomerTableViewCell.h"
#import "SiteOpsExtras.h"
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

- (void)setUserLocationUpdate:(CSUserLocationUpdate *)userLocationUpdate
{
    _userLocationUpdate = userLocationUpdate;
    NSString *customerName = userLocationUpdate.customerInfo.fullName;
    if (customerName.length == 0)
        customerName = userLocationUpdate.trackingIdentifier;
    _customerNameTIDLabel.text = customerName;
    int distanceFromSite = userLocationUpdate.distanceFromSite;
    _distanceValueLabel.text = FormatDistance(userLocationUpdate.distanceFromSite);
    int eta = userLocationUpdate.estimatedTimeOfArrival;
    _etaValueLabel.text = eta > 0 ?  FormatSeconds(eta) : @"-";
    _dateValueLabel.text = FormatDate(userLocationUpdate.lastUpdateTimestamp);
    switch (_userLocationUpdate.userStatus) {
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
    CSTripInfo *firstTripInfo = [_userLocationUpdate.tripInfos firstObject];
    _trackToken = firstTripInfo.trackToken;
    _trackTokenLabel.text = _trackToken;
}

- (IBAction)cancelTrip:(id)sender {
    [[CSSiteArrivalTracker sharedArrivalTracker] cancelTrackingArrivalForTrackingIdentifier:_userLocationUpdate.trackingIdentifier trackTokens:@[_trackToken]];
}

- (IBAction)endTrip:(id)sender {
    [[CSSiteArrivalTracker sharedArrivalTracker] stopTrackingArrivalForTrackingIdentifier:_userLocationUpdate.trackingIdentifier trackTokens:@[_trackToken]];
}
@end
