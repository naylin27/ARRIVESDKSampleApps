# Site Ops App

The ARRIVE SDK delivers reliable arrival prediction. Battle-tested by millions of customer arrivals in real world commerce, ARRIVE sends an accurate alert before arrival and gives you true visibility into customer ETA and dwell time. ARRIVE hooks easily into mobile commerce infrastructure and on-site apps or POS for notifications.

This sample app integrates ARRIVE SDK. It is an example of a monitor app that is used to demonstrate the ability of ARRIVE to accurately detect not only where a user is, but when the user is about to arrive.

## Prerequisite
Register for an account at [ARRIVE dashboard](https://control.curbside.com). Login and do the following:
* Setup and run the [Mobile app](https://github.com/Curbside/ARRIVESDKSampleApps/tree/master/iOS/Swift/MobileClient).
* Generate an [API Key and Secret](https://control.curbside.com/account?accessTab=keys&accountTab=access)
* Register an [App ID](https://control.curbside.com/account?accessTab=ids&accountTab=access) for SiteOps app
 
## Installing
* Download and open the Xcode project
* Change the Bundle Identifier to the SiteOps [App ID](https://control.curbside.com/account?accessTab=ids&accountTab=access) registered in the portal
* Add [API Key and Secret](https://control.curbside.com/account?accessTab=keys&accountTab=access) in place of `YOUR_API_KEY` and `YOUR_SECRET_KEY` in the `AppDelegate.m` file. 

## Running
* Add tracking identifier
* Add [site identifier](https://control.curbside.com/account?accountTab=sites) that was created on [ARRIVE dashboard](https://control.curbside.com)
* Tap “Start Updates”

Visit [ARRIVE dashboard](https://control.curbside.com) to get an overview of all your sites and trips.

## Quickstart
Refer to [Quickstart](https://developer.curbside.com/docs/getting-started/quickstart-ios-monitor-app/) to integrate ARRIVE into an existing project.

## iOS SDK Reference Docs
https://developer.curbside.com/docs/reference/ios/index.html

## License
Please refer to the repos root diretory for licensing information.
