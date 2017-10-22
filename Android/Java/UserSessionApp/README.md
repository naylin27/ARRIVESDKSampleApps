# User Session Sample App

The ARRIVE SDK delivers reliable arrival prediction. Battle-tested by millions of customer arrivals in real world commerce, ARRIVE sends an accurate alert before arrival and gives you true visibility into customer ETA and dwell time. ARRIVE hooks easily into mobile commerce infrastructure and on-site apps or POS for notifications.

This sample app demonstrates how to integrate the ARRIVE SDK with an Android app using the Java Programming Language. Run the sample app on a device before doing a drive test.


### Prerequisites

Register for an account at [ARRIVE dashboard](https://dashboard.curbside.com/) and sign in to the platform. Do the following:

* Generate a [usage token](https://dashboard.curbside.com/account?accessTab=tokens&accountTab=access)
* Create a [site](https://dashboard.curbside.com/account?accountTab=sites)

### Installing

* Please download [Android Studio](https://developer.android.com/studio/index.html) and install it on your machine.
* Open the project in the Android Studio. 
* [Download](https://developer.curbside.com/downloads/) the ARRIVE Android SDK.
* Add the dowloaded aar file in your libs folder.
* Add the dependencies in the gradle file. See [Android App Quick Start](https://developer.curbside.com/docs/getting-started/quickstart-android-app/) for detailed information on how to integrate sdk with your app.

## Running
* Add the generated usage token in place of the USAGE_TOKEN defined in the MainActivity of the project
* Run the app
* Grant permission to use location services
* Enter a tracking identifier
* Enter a track token
* Enter a [site identifier](https://dashboard.curbside.com/account?accountTab=sites) that was created on the Curbside Platform
* Tap "Register Tracking Id".
* Once "Register Tracking Id" is successful, tap “Start Trip”.
* Go on a test drive.
* You can cancel the trip by tapping "Cancel Trip". Note: To start a new trip, enter a new track token. Once a complete trip is called on a track token, it cannot be reused.
* You can also unregister you tracking ID by tapping "Unregister Tracking Id".
* When you are near the site, you can also notify the user of the monitor app by tapping "Notify Monitoring Session User".


## View User trip
* Check the [ARRIVE dashboard](https://dashboard.curbside.com/) to see your current location and your trip status change from In-Transit to Arrived.
* Visit the [ARRIVE dashboard](https://dashboard.curbside.com/)  to get aggregate data and statistics about your sites and trips.

## Quick Start Guide
See [Android App Quick Start](https://developer.curbside.com/docs/getting-started/quickstart-android-app/) to integrate ARRIVE with an existing project.

## Android SDK Reference Docs
https://developer.curbside.com/docs/reference/android/index.html

## License
Please refer to the repos root diretory for licensing information.
