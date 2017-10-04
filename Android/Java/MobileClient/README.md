# Android Sample App

This sample app demonstrates how to integrate Curbside SDK with an android app using the Java Programming Language. Run the sample app on a device before
doing a drive test or try the SDK’s mock trip simulator to test ARRIVE without leaving the office.

### Prerequisites

* Register for an account at https://control.curbside.com and log into ARRIVE dashboard. Do the following:
* Generate usage token
* Create a site
* Register an App ID for Mobile app

### Installing

* Please download [Android Studio](https://developer.android.com/studio/index.html) and install it on your machine
* Open the project in the Android Studio 
* [Download](https://developer.curbside.com/downloads/) the ARRIVE Android SDK.
* Add the dowloaded aar file in your libs folder.
* Add the dependencies in the gradle file. Please refer to [QuickStart Documentation](https://developer.curbside.com/docs/getting-started/quickstart-android/) for detailed information on how to integrate sdk with your app.
* Compile the app. It should compile successfully.

## Running
* Add the generated usage token in place of `USAGE_TOKEN` defined in the MainActivity of the project. 
* Change the application Id to the Mobile App ID registered in the portal.
* Run the app 
* Grant permission to use location services.
* Enter tracking identifier
* Enter track token
* Enter site identifier that was created on ARRIVE dashboard
* Tap "Register Tracking Id".
* Once "Register Tracking Id" is successful, tap “Start Tracking Site”.
* Go on a test drive.
* You can stop the trip by tapping "Stop Tracking". Note: For starting new trip, enter new track token, as once stop track is called on a track token, it cannnot be reused.
* You can also unregister you tracking Id by tapping "Unregister Tracking Id".
* Once you are near the site, you can also notify associate by tapping "Notify Associate".

## View user trip
* Check ARRIVE dashboard to see your current location and your status change from in-transit to arrived.
* Visit https://control.curbside.com to get an overview of all your sites and trips.
## Quickstart
Refer to [Quickstart](https://developer.curbside.com/docs/getting-started/quickstart-android/) to integrate ARRIVE into an existing.

## Android SDK Reference Docs
https://developer.curbside.com/docs/reference/android/index.html

## License
Please refer to the repos root diretory for licensing information.
