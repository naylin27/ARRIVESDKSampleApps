//
//  ViewController.m
//  MobileClient
//
//  Created by Radwar on 9/3/17.
//  Copyright © 2017 curbside. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"
@import Curbside;

@interface ViewController () <CSUserSessionDelegate>
{
    BOOL _isStartTrack;
    BOOL _hasTrackingID;
}

@property (strong, nonatomic) IBOutlet UITextField *tidTextField;
@property (strong, nonatomic) IBOutlet UITextField *trackTokenField;
@property (strong, nonatomic) IBOutlet UITextField *siteIdentierField;
@property (strong, nonatomic) IBOutlet UILabel *errorTitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *errorDescriptionLabel;
@property (strong, nonatomic) IBOutlet UILabel *errorSolutionLabel;
@property (strong, nonatomic) IBOutlet UILabel *statusLabel;
@property (strong, nonatomic) IBOutlet UIButton *trackingIdentifierButton;
@property (strong, nonatomic) IBOutlet UIButton *trackingButton;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _statusLabel.text = @"";
    _isStartTrack = YES;
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_sessionValidated:) name:kSessionValidatedNotificationName object:nil];
    [self _resetError];
    [CSUserSession currentSession].delegate = self;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)_sessionValidated:sender
{
    NSString *trackingIdentifier =  [CSUserSession currentSession].trackingIdentifier;
    if (trackingIdentifier.length > 0) {
        _tidTextField.text = trackingIdentifier;
        _hasTrackingID = YES;
    } else {
        _hasTrackingID = NO;
    }
    [self _updateButtons];
}

- (void)_resetError
{
    _errorTitleLabel.text = @"";
    _errorDescriptionLabel.text = @"";
    _errorSolutionLabel.text = @"";
}

- (IBAction)updateTrackingIdentifier:(id)sender {
    NSString *newTrackingIdentifier = _tidTextField.text;
    if (_hasTrackingID) {
        [CSUserSession currentSession].trackingIdentifier = nil;
        _tidTextField.text = @"";
        _hasTrackingID = NO;
    } else {
        [CSUserSession currentSession].trackingIdentifier = newTrackingIdentifier;
        _hasTrackingID = YES;
    }
    [self _updateButtons];
}

- (void)_updateButtons
{
    [_trackingIdentifierButton setTitle:_hasTrackingID ? @"Unregister Tracking Identfier" : @"Set Tracking Identifier" forState:UIControlStateNormal];
    [_trackingButton setTitle:_isStartTrack ? @"Start Tracking Site" : @"Stop Tracking Site" forState:UIControlStateNormal];
}

- (IBAction)startTracking:(id)sender {
    [self _resetError];
    NSString *trackingIdentifier = _tidTextField.text;
    NSString *trackToken = _trackTokenField.text;
    NSString *siteIdentifier = _siteIdentierField.text;

    if (_isStartTrack) {
        if (trackingIdentifier.length == 0) {
            _errorTitleLabel.text = @"Empty Tracking Identifier.";
            return;
        }
        
        if (trackToken.length == 0) {
            _errorTitleLabel.text = @"Empty track token.";
            return;
        }
        
        if (siteIdentifier.length == 0) {
            _errorTitleLabel.text = @"Empty site Identifier.";
            return;
        }
        
        [[CSUserSession currentSession] startTripToSiteWithIdentifier:siteIdentifier trackToken:trackToken];
        _isStartTrack = NO;
    } else {
        NSString *trackToken = _trackTokenField.text;
        [[CSUserSession currentSession] cancelTripToSiteWithIdentifier:siteIdentifier trackToken:trackToken];
        _siteIdentierField.text = nil;
        _trackTokenField.text = nil;
        _isStartTrack = YES;
    }
    [self _updateButtons];
}

#pragma mark CSUserSessionDelegate

- (void)session:(CSSession *)session changedState:(CSSessionState)newState
{
    if (newState == CSSessionStateValid)
        [[NSNotificationCenter defaultCenter] postNotificationName:kSessionValidatedNotificationName object:nil];
    
    NSLog(@"Session changed state to %li",(long)newState);
}

- (void)session:(CSUserSession *)session userArrivedAtSite:(CSSite *)site
{
    NSString *trackingIdentifier = [CSUserSession currentSession].trackingIdentifier;
    _statusLabel.text = [NSString stringWithFormat:@"%@ arrived at site %@",trackingIdentifier, site.siteIdentifier];
}

- (void)session:(CSUserSession *)session userApproachingSite:(CSSite *)site
{
    NSString *trackingIdentifier = [CSUserSession currentSession].trackingIdentifier;
    _statusLabel.text = [NSString stringWithFormat:@"%@ approaching site %@",trackingIdentifier, site.siteIdentifier];
}

- (void)session:(CSUserSession *)session encounteredError:(NSError *)error forOperation:(CSUserSessionAction)customerSessionAction
{
    NSDictionary *userInfo = error.userInfo;
    _errorTitleLabel.text = [userInfo objectForKey:NSLocalizedDescriptionKey];
    _errorDescriptionLabel.text = [userInfo objectForKey:NSLocalizedFailureReasonErrorKey];
    _errorSolutionLabel.text = [userInfo objectForKey:NSLocalizedRecoverySuggestionErrorKey];
}

- (void)session:(CSUserSession *)session updatedTrackedSites:(NSSet<CSSite *> *)trackedSites
{
    // We will just show the first one for now. It is in dispatch_async because we are making changes in the UI
    dispatch_async(dispatch_get_main_queue(), ^{
        NSArray *sites = [trackedSites allObjects];
        if (sites.count > 0) {
            CSSite *site = (CSSite *)sites.firstObject;
            _siteIdentierField.text = site.siteIdentifier;
            NSString *firstTrackToken = site.tripInfos.firstObject.trackToken;
            _trackTokenField.text = firstTrackToken ? firstTrackToken : @"";
            _isStartTrack = NO;
        } else {
            _isStartTrack = YES;
        }
        [self _updateButtons];
    });
}
@end
