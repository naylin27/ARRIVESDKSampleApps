//
//  ConfigureViewController.m
//  SiteOpsClient
//
//  Created by Radwar on 8/24/17.
//  Copyright © 2017 curbside. All rights reserved.
//

#import "ConfigureViewController.h"
#import "SiteOpsExtras.h"


@interface ConfigureViewController ()

@property (strong, nonatomic) IBOutlet UITextField *siteIdentifierTextField;
@property (strong, nonatomic) IBOutlet UITextField *trackingIdentifierTextField;
@property (strong, nonatomic) IBOutlet UILabel *errorLabel;
@property (strong, nonatomic) IBOutlet UIButton *startUpdatesButton;

@end

@implementation ConfigureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _startUpdatesButton.layer.cornerRadius = 4.0;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)startUpdates:(id)sender {
    NSString *trackingIdentifier = _trackingIdentifierTextField.text;
    NSString *siteIdentifier = _siteIdentifierTextField.text;
    
    if (trackingIdentifier.length == 0) {
        _errorLabel.text = @"Please enter a valid tracking identifier.";
        return;
    }
    
    if (siteIdentifier.length == 0) {
        _errorLabel.text = @"Please enter a valid site identifier.";
        return;
    }
    
    // We are good. Set defaults and exit.
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:trackingIdentifier forKey:kTrackingIdentifierKey];
    [userDefaults setObject:siteIdentifier forKey:kSiteIdentifierKey];
    [userDefaults synchronize];
    
    [self dismissViewControllerAnimated:YES completion:^{}];
}

@end
