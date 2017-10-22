# User Session Sample App

The ARRIVE SDK delivers reliable arrival prediction. Battle-tested by millions of customer arrivals in real world commerce, ARRIVE sends an accurate alert before arrival and gives you true visibility into customer ETA and dwell time. ARRIVE hooks easily into a mobile commerce infrastructure and on-site apps or POS for notifications.

This sample app integrates with the ARRIVE SDK. It is an example of a User Session app that is used to send accurate user location events to the ARRIVE server.


## Prerequisite
Register for an account at [Curbside Platform](https://dashboard.curbside.com). Sign in and do the following:
* Generate a [usage token](https://dashboard.curbside.com/account?accessTab=tokens&accountTab=access)
* Create a [site](https://dashboard.curbside.com/account?accountTab=sites)

## Installing
* The recommended way to install the SDK is using [CocoaPods](https://cocoapods.org)
  * Run `pod install` from the command line for the initial install.
  * Open `UserSessionApp.xcworkspace`.
* Add [usage token](https://dashboard.curbside.com/account?accessTab=tokens&accountTab=access) in place of `YOUR_USAGE_TOKEN` in the `AppDelegate` file. 

## Running
* Grant permission to use location services
* Add a tracking identifier
* Add a track token
* Add a [site identifier](https://dashboard.curbside.com/account?accountTab=sites) that was created on the Curbside Platform.
* Tap “Start Tracking Site”
* Go on a test drive

## View User Trip
* Check [ARRIVE dashboard](https://dashboard.curbside.com) to see your current location and to note that your status changed from In-Transit to Arrived.
* Use the monitor app to view detailed information about your arrival.

Visit the [ARRIVE dashboard](https://dashboard.curbside.com) to get aggregate data and statistics about your sites and trips or to download the  [Monitoring Session Sample App](https://github.com/Curbside/ARRIVESDKSampleApps/tree/master/iOS/MonitorApp) to view trips from one of your sites.


## Quick Start Guide
See the [iOS App Quick Start](https://developer.curbside.com/docs/getting-started/quickstart-ios-app/) to integrate ARRIVE with an existing project.

## iOS SDK Reference Docs
https://developer.curbside.com/docs/reference/ios/index.html

## License
See the repo root directory for licensing information.

