# Mobile Sample App

This sample app integrates ARRIVE SDK. It is an example of a transmit app that is used to transmit accurate user location events to ARRIVE server. Run the sample app on a device before doing a drive test or try the SDK’s mock trip simulator to test ARRIVE without leaving the office.

## Prerequisite
Register for an account at https://control.curbside.com and log into ARRIVE dashboard. Do the following:
* Generate usage token
* Create a site
* Register an App ID for Mobile app

## Installing
* Download and open the Xcode project
* Change the Bundle Identifier to the Mobile App ID registered in the portal
* Add usage token to `CSMobileSession`

## Running
* Grant permission to use location services
* Add tracking identifier
* Add track token
* Add site identifier that was created on ARRIVE dashboard
* Tap “Start Tracking Site”
* Go on a test drive

## View user trip
* Check ARRIVE dashboard to see your current location and your status change from in-transit to arrived.
* You can also use the SiteOps app to view detailed information of your arrival.

Visit https://control.curbside.com to get an overview of all your sites and trips or download the SiteOps app to view trips from one of your sites.


## Quickstart
Refer to Quickstart at https://developer.curbside.com/docs/getting-started/quickstart-ios/ to integrate ARRIVE into an existing.

## iOS SDK Reference Docs
https://developer.curbside.com/docs/reference/ios/index.html

## License
Please refer to the repos root diretory for licensing information.
