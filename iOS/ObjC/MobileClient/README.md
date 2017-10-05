# Mobile Sample App

The ARRIVE SDK delivers reliable arrival prediction. Battle-tested by millions of customer arrivals in real world commerce, ARRIVE sends an accurate alert before arrival and gives you true visibility into customer ETA and dwell time. ARRIVE hooks easily into mobile commerce infrastructure and on-site apps or POS for notifications.

This sample app integrates ARRIVE SDK. It is an example of a transmit app that is used to transmit accurate user location events to ARRIVE server. Run the sample app on a device before doing a drive test or try the SDK’s mock trip simulator to test ARRIVE without leaving the office.

## Prerequisite
Register for an account at [ARRIVE dashboard](https://control.curbside.com). Login and do the following:
* Generate a [usage token](https://control.curbside.com/account?accessTab=tokens&accountTab=access)
* Create a [site](https://control.curbside.com/account?accountTab=sites)
* Register an [App ID](https://control.curbside.com/account?accessTab=ids&accountTab=access) for Mobile app
 
## Installing
* Download and open the Xcode project
* Change the Bundle Identifier to the Mobile [App ID](https://control.curbside.com/account?accessTab=ids&accountTab=access) registered in the portal
* Add [usage token](https://control.curbside.com/account?accessTab=tokens&accountTab=access) in place of `YOUR_USAGE_TOKEN` in the `AppDelegate.m` file. 

## Running
* Grant permission to use location services
* Add tracking identifier
* Add track token
* Add [site identifier](https://control.curbside.com/account?accountTab=sites) that was created on [ARRIVE dashboard](https://control.curbside.com)
* Tap “Start Tracking Site”
* Go on a test drive

## View user trip
* Check [ARRIVE dashboard](https://control.curbside.com) to see your current location and your status change from in-transit to arrived.
* You can also use the SiteOps app to view detailed information of your arrival.

Visit [ARRIVE dashboard](https://control.curbside.com) to get an overview of all your sites and trips or download the SiteOps app to view trips from one of your sites.

## Quickstart
Refer to [Quickstart](https://developer.curbside.com/docs/getting-started/quickstart-ios-transmit-app/) to integrate ARRIVE into an existing project.

## iOS SDK Reference Docs
https://developer.curbside.com/docs/reference/ios/index.html

## License
Please refer to the repos root diretory for licensing information.
