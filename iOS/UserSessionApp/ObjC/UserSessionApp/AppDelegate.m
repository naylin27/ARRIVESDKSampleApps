//
//  AppDelegate.m
//  UserSessionApp
//
//  Created by Radwar on 9/3/17.
//  Copyright © 2017 curbside. All rights reserved.
//

#import "AppDelegate.h"
@import Curbside;
@import UserNotifications;

@interface AppDelegate () <UNUserNotificationCenterDelegate>

@property (nonatomic, strong) CLLocationManager *locationManager;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    _locationManager = [[CLLocationManager alloc] init];
    if ([_locationManager respondsToSelector:@selector(requestAlwaysAuthorization)])
        [_locationManager requestAlwaysAuthorization];
    
    CSUserSession *sdksession = [CSUserSession createSessionWithUsageToken:@"YOUR_USAGE_TOKEN" delegate:nil];
    
    // Call sessions method application:didFinishLaunchingWithOptions:
    [sdksession application:[UIApplication sharedApplication] didFinishLaunchingWithOptions:launchOptions];
    
    // Request authorization to show notifications
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    center.delegate = self;
    UNAuthorizationOptions options = UNAuthorizationOptionAlert + UNAuthorizationOptionSound;
    [center requestAuthorizationWithOptions:options
                          completionHandler:^(BOOL granted, NSError * _Nullable error) {
                              if (!granted) {
                                  NSLog(@"Something went wrong");
                              }
                          }];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - UNUserNotificationCenterDelegate

- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler
{
    completionHandler(UNNotificationPresentationOptionBadge + UNNotificationPresentationOptionSound + UNNotificationPresentationOptionAlert);
}

@end
