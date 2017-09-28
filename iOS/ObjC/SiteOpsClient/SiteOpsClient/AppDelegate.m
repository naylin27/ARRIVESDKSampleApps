//
//  AppDelegate.m
//  SiteOpsClient
//
//  Created by Radwar on 8/24/17.
//  Copyright © 2017 curbside. All rights reserved.
//

#import "AppDelegate.h"
@import Curbside;

@interface AppDelegate () <CSMobileSessionDelegate>
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
#warning Replace with a valid API Key and Secret generated from your Curbside ARRIVE platform

    CSSiteOpsSession *sdksession = [CSSiteOpsSession createSessionWithAPIKey:@"API_KEY" secret:@"API_SECRET" delegate:self];
    
    // Call sessions method application:didFinishLaunchingWithOptions:
    [sdksession application:[UIApplication sharedApplication] didFinishLaunchingWithOptions:nil];
    return YES;
}

- (void)session:(CSSession *)session changedState:(CSSessionState)newState
{
    NSLog(@"Session changed state to %li",(long)newState);
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


@end
