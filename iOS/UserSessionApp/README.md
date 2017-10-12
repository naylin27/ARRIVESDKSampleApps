# UserSession App

The ARRIVE SDK delivers reliable arrival prediction. Battle-tested by millions of customer arrivals in real world commerce, ARRIVE sends an accurate alert before arrival and gives you true visibility into customer ETA and dwell time. ARRIVE hooks easily into mobile commerce infrastructure and on-site apps or POS for notifications.

This sample app integrates ARRIVE SDK. It is an example of a UserSession app that is used to send accurate user location events to ARRIVE server.

## Prerequisite
Register for an account at [ARRIVE dashboard](https://dashboard.curbside.com). Login and do the following:
* Generate a [usage token](https://dashboard.curbside.com/account?accessTab=tokens&accountTab=access)
* Create a [site](https://dashboard.curbside.com/account?accountTab=sites)

## Installing
* The recommended way to install the SDK is via [CocoaPods](https://cocoapods.org)
  * Run `pod install` from the command line for the initial install.
  * Open `UserSessionApp.xcworkspace`.
* Add [usage token](https://dashboard.curbside.com/account?accessTab=tokens&accountTab=access) in place of `YOUR_USAGE_TOKEN` in the `AppDelegate` file. 

## Running
* Grant permission to use location services
* Add tracking identifier
* Add track token
* Add [site identifier](https://dashboard.curbside.com/account?accountTab=sites) that was created on [ARRIVE dashboard](https://dashboard.curbside.com)
* Tap “Start Tracking Site”
* Go on a test drive

## View user trip
* Check [ARRIVE dashboard](https://dashboard.curbside.com) to see your current location and your status change from in-transit to arrived.
* You can also use the Monitor app to view detailed information of your arrival.

Visit [ARRIVE dashboard](https://dashboard.curbside.com) to get an overview of all your sites and trips or download the [Monitor app](https://github.com/Curbside/ARRIVESDKSampleApps/tree/master/iOS/MonitorApp) to view trips from one of your sites.

## Quickstart
Refer to [Quickstart](https://developer.curbside.com/docs/getting-started/quickstart-ios-transmit-app/) to integrate ARRIVE into an existing project.

## iOS SDK Reference Docs
https://developer.curbside.com/docs/reference/ios/index.html

## License
Please refer to the repos root diretory for licensing information.
