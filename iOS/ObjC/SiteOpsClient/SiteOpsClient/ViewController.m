//
//  ViewController.m
//  SiteOpsClient
//
//  Created by Radwar on 8/24/17.
//  Copyright © 2017 curbside. All rights reserved.
//

#import "ViewController.h"
#import "CustomerTableViewCell.h"
#import "ConfigureViewController.h"
#import "SiteOpsExtras.h"

@import Curbside;

@interface ViewController () <UITableViewDelegate, UITableViewDataSource, CSMonitoringSessionDelegate>

@property (strong, nonatomic) IBOutlet UITableView *customersTableView;
@property (strong, nonatomic) NSString *trackingIdentifier;
@property (strong, nonatomic) NSString *siteIdentifier;
@property (strong, nonatomic) NSArray<CSUserStatusUpdate *> *customerLocationUpdates;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _customersTableView.delegate = self;
    _customersTableView.dataSource = self;
    
    UINib *customerCellProtoNib = [UINib nibWithNibName:@"CustomerTableViewCell" bundle:[NSBundle mainBundle]];
    [_customersTableView registerNib:customerCellProtoNib forCellReuseIdentifier:kCustomerTableViewCellIdentifier];
    _customersTableView.tableFooterView = [UIView new];

}

- (void)_close:sender
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults removeObjectForKey:kTrackingIdentifierKey];
    [userDefaults removeObjectForKey:kSiteIdentifierKey];
    [userDefaults synchronize];
    
    [[CSMonitoringSession currentSession] stopMonitoringArrivals];
    [self _showSetupViewController];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)_readFromDefaults
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    _trackingIdentifier  = [userDefaults stringForKey:kTrackingIdentifierKey];
    _siteIdentifier = [userDefaults stringForKey:kSiteIdentifierKey];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [CSMonitoringSession currentSession].delegate = self;
    UIButton *closeButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 20 , 55, 25)];
    [closeButton setTitle:@"Close" forState:UIControlStateNormal];
    closeButton.layer.cornerRadius = 2.0f;
    [closeButton addTarget:self action:@selector(_close:) forControlEvents:UIControlEventTouchUpInside];
    [closeButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:[[UIBarButtonItem alloc] initWithCustomView:closeButton], nil];
    
    // Do we have a Site in preferences?
    [self _readFromDefaults];
    if (_trackingIdentifier) {
        [self _startUpdates];
        self.title = _siteIdentifier;
    } else {
        [self _showSetupViewController];
    }
}

- (void)_startUpdates
{
    CSMonitoringSession *currentSession = [CSMonitoringSession currentSession];
    currentSession.trackingIdentifier = _trackingIdentifier;
    currentSession.statusesUpdatedHandler = ^(NSArray<CSUserStatusUpdate *> * _Nonnull updates) {
        _customerLocationUpdates = updates;
        [_customersTableView reloadData];
        self.title = [NSString stringWithFormat:@"%@ @ %@",_siteIdentifier, FormatDate([NSDate date])];
    };
    [currentSession startMonitoringArrivalsToSiteWithIdentifier:_siteIdentifier];
}

- (void)_showSetupViewController
{
    ConfigureViewController *vc = [ConfigureViewController new];
    [self presentViewController:vc animated:YES completion:^{}];
}

#pragma UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return section == 0 ? _customerLocationUpdates.count : 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return indexPath.section == 0 ? 140 : 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;

    if (indexPath.section == 0) {
        cell = [_customersTableView dequeueReusableCellWithIdentifier:kCustomerTableViewCellIdentifier];
        if (cell == nil)
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCustomerTableViewCellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        ((CustomerTableViewCell *)cell).userStatusUpdate = [_customerLocationUpdates objectAtIndex:indexPath.row];
    }
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"selected cell %li",(long)indexPath.row);
}

#pragma mark CSMonitoringSessionDelegate

- (void)session:(CSSession *)session changedState:(CSSessionState)newState
{
    NSLog(@"Session changed state to %li",(long)newState);
}

- (void)session:(CSMonitoringSession *)session encounteredError:(NSError *)error
{
    NSLog(@"Encountered Error : %@",error);
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Error" message:error.description preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {}]];
    [self presentViewController:alertController animated:YES completion:nil];
}

@end
