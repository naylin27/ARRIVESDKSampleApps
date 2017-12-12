//
//  MockTripViewController.m
//  UserSessionApp
//
//  Created by Hon Chen on 12/12/17.
//  Copyright © 2017 curbside. All rights reserved.
//

#import "MockTripViewController.h"

@import CoreLocation;
@import Curbside;

@interface MockTripViewController () <CLLocationManagerDelegate, CSUserSessionDelegate>
@property (strong, nonatomic) IBOutlet UITextField *siteIdentierField;
@property (strong, nonatomic) IBOutlet UITextField *latitudeField;
@property (strong, nonatomic) IBOutlet UITextField *longitudeField;

@property (strong, nonatomic) IBOutlet UILabel *statusLabel;
@property (strong, nonatomic) IBOutlet UILabel *errorTitleLabel;

@property (strong, nonatomic) CLLocationManager *locationManager;

@end

@implementation MockTripViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [CSUserSession currentSession].delegate = self;
}

- (IBAction)getCurrentLocation:(UIButton *)sender {
    if (!_locationManager) {
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.delegate = self;
    }
    [_locationManager requestLocation];
}

- (IBAction)startMockTrip:(UIButton *)sender {
    NSString *siteid = [_siteIdentierField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (siteid.length == 0) {
        _errorTitleLabel.text = @"Empty site Identifier.";
        return;
    }
    
    double lat = _latitudeField.text.doubleValue;
    double lng = _longitudeField.text.doubleValue;
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(lat, lng);
    if (!CLLocationCoordinate2DIsValid(coordinate)) {
        _errorTitleLabel.text = @"Invalid coordinates";
        return;
    }
    _errorTitleLabel.text = nil;
    
    [[CSUserSession currentSession] startMockTripToSiteWithIdentifier:siteid fromLocation:[[CLLocation alloc] initWithLatitude:lat longitude:lng]];
}

- (IBAction)StopMockTrip:(UIButton *)sender {
    [[CSUserSession currentSession] cancelMockTrip];
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations
{
    CLLocation *location = locations.lastObject;
    if (!location) {
        NSLog(@"%s, no location", __PRETTY_FUNCTION__);
        return;
    }
    CLLocationDegrees lat = location.coordinate.latitude;
    CLLocationDegrees lng = location.coordinate.longitude;
    _latitudeField.text = [NSString stringWithFormat:@"%f", lat];
    _longitudeField.text = [NSString stringWithFormat:@"%f", lng];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Fetch Location Error!"
                                                                   message:error.localizedDescription
                                                            preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - CSUserSessionDelegate

- (void)session:(CSUserSession *)session mockTripStartedForSite:(CSSite *)site
{
    _statusLabel.text = [NSString stringWithFormat:@"mock trip started for %@", site.siteIdentifier];
    NSLog(@"%s", __PRETTY_FUNCTION__);
}

- (void)session:(CSUserSession *)session mockTripFailedForSite:(CSSite *)site error:(NSError *)error
{
    _statusLabel.text = [NSString stringWithFormat:@"mock trip failed for %@ with error: %@", site.siteIdentifier, error.localizedDescription];
    NSLog(@"%s", __PRETTY_FUNCTION__);
}

- (void)session:(CSUserSession *)session mockTripSentLocationForSite:(CSSite *)site
{
    CATransition *animation = [CATransition animation];
    animation.type = kCATransitionPush;
    animation.subtype = kCATransitionFromTop;
    animation.duration = 0.5;
    [_statusLabel.layer addAnimation:animation forKey:nil];
    
    _statusLabel.text = [NSString stringWithFormat:@"mock trip sent location for %@", site.siteIdentifier];
    NSLog(@"%s", __PRETTY_FUNCTION__);
}

- (void)session:(CSUserSession *)session mockTripCancelledForSite:(CSSite *)site
{
    _statusLabel.text = [NSString stringWithFormat:@"mock trip cancelled for %@", site.siteIdentifier];
    NSLog(@"%s", __PRETTY_FUNCTION__);
}

@end
