# Monitoring Session Sample App

The ARRIVE SDK delivers reliable arrival prediction. Battle-tested by millions of customer arrivals in real world commerce, ARRIVE sends an accurate alert before arrival and gives you true visibility into customer ETA and dwell time. ARRIVE hooks easily into mobile commerce infrastructure and on-site apps or POS for notifications.
This sample app integrates with the ARRIVE SDK. It is an example of a monitor app that demonstrates the ability of ARRIVE to accurately detect not only where a user is, but when the user is about to arrive.


## Prerequisite
Register for an account at [Curbside Platform](https://dashboard.curbside.com). Sign in and do the following:
* Set up and run the [User Session Sample App](https://github.com/Curbside/ARRIVESDKSampleApps/tree/master/iOS/UserSessionApp).
* Generate an [API Key and Secret](https://dashboard.curbside.com/account?accessTab=keys&accountTab=access)

## Installing
* The recommended way to install the SDK is using [CocoaPods](https://cocoapods.org/
  * Run pod install from the command line for the initial install.
  * Open MonitorApp.xcworkspace.
* Add [API Key and Secret](https://dashboard.curbside.com/account?accessTab=keys&accountTab=access) in place of YOUR_API_KEY and YOUR_SECRET_KEY in the AppDelegate file.

## Running
* Add tracking identifier
* Add [site identifier](https://dashboard.curbside.com/account?accountTab=sites) that was created on the Curbside Platform.
* Tap “Start Updates”

Visit the [ARRIVE dashboard](https://dashboard.curbside.com) to get aggregate data and statistics about your sites and trips.

## Quick Start Guide
See the  iOS Monitor App Quick Start to integrate ARRIVE with an existing project.

## iOS SDK Reference Docs
https://developer.curbside.com/docs/reference/ios/index.html

## License
See the repo root directory for licensing information.

