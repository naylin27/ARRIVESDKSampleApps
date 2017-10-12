# Monitor App

The ARRIVE SDK delivers reliable arrival prediction. Battle-tested by millions of customer arrivals in real world commerce, ARRIVE sends an accurate alert before arrival and gives you true visibility into customer ETA and dwell time. ARRIVE hooks easily into mobile commerce infrastructure and on-site apps or POS for notifications.

This sample app integrates ARRIVE SDK. It is an example of a monitor app that is used to demonstrate the ability of ARRIVE to accurately detect not only where a user is, but when the user is about to arrive.

## Prerequisite
Register for an account at [ARRIVE dashboard](https://dashboard.curbside.com). Login and do the following:
* Setup and run the Transmit App. [Objective-C](https://github.com/Curbside/ARRIVESDKSampleApps/tree/master/iOS/ObjC/TransmitApp) or [Swift](https://github.com/Curbside/ARRIVESDKSampleApps/tree/master/iOS/Swift/TransmitApp).
* Generate an [API Key and Secret](https://dashboard.curbside.com/account?accessTab=keys&accountTab=access)
* Register an [App ID](https://dashboard.curbside.com/account?accessTab=ids&accountTab=access) for Monitor app
 
## Installing
* Download and open the Xcode project
* Change the Bundle Identifier to the Monitor [App ID](https://dashboard.curbside.com/account?accessTab=ids&accountTab=access) registered in the portal
* Add [API Key and Secret](https://dashboard.curbside.com/account?accessTab=keys&accountTab=access) in place of `YOUR_API_KEY` and `YOUR_SECRET_KEY` in the `AppDelegate` file. 

## Running
* Add tracking identifier
* Add [site identifier](https://dashboard.curbside.com/account?accountTab=sites) that was created on [ARRIVE dashboard](https://dashboard.curbside.com)
* Tap “Start Updates”

Visit [ARRIVE dashboard](https://dashboard.curbside.com) to get an overview of all your sites and trips.

## Quickstart
Refer to [Quickstart](https://developer.curbside.com/docs/getting-started/quickstart-ios-monitor-app/) to integrate ARRIVE into an existing project.

## iOS SDK Reference Docs
https://developer.curbside.com/docs/reference/ios/index.html

## License
Please refer to the repos root diretory for licensing information.
