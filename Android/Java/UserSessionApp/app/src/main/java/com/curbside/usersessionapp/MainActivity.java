package com.curbside.usersessionapp;

import android.Manifest;
import android.app.AlertDialog;
import android.app.Notification;
import android.app.NotificationChannel;
import android.app.NotificationManager;
import android.content.Context;
import android.content.DialogInterface;
import android.content.pm.PackageManager;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.os.Build;
import android.os.Bundle;
import androidx.core.app.ActivityCompat;
import androidx.core.app.NotificationCompat;
import androidx.appcompat.app.AppCompatActivity;
import androidx.appcompat.widget.Toolbar;
import android.util.Log;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;
import android.widget.TextView;

import com.curbside.sdk.CSErrorCode;
import com.curbside.sdk.CSSite;
import com.curbside.sdk.CSUserSession;
import com.curbside.sdk.credentialprovider.TokenCurbsideCredentialProvider;
import com.curbside.sdk.event.Event;
import com.curbside.sdk.event.Path;
import com.curbside.sdk.event.Status;
import com.curbside.sdk.event.Type;
import com.curbside.sdk.model.CSUserInfo;

import java.util.Arrays;

import rx.Subscription;
import rx.functions.Action1;

public class MainActivity extends AppCompatActivity implements View.OnClickListener {
    private static final String TAG = "MainActivity";
    private static String USAGE_TOKEN = "YOUR-USAGE-TOKEN";

    private static final int PERMISSION_REQUEST_CODE = 1;

    private static final float ALPHA = (float)0.5;
    private static final float NO_ALPHA = 1;

    private EditText etTrackingIdentifier = null;
    private EditText etTrackToken = null;
    private EditText etSiteIdentifier = null;
    private EditText etName = null;
    private EditText etEmail= null;
    private EditText etPhoneNumber = null;
    private EditText etCarMake = null;
    private EditText etCarModel = null;
    private EditText etLicensePlate = null;

    private Button bRegisterTrackingId = null;
    private Button bStartTrip = null;
    private Button bCancelTrip = null;
    private Button bNotifyMonitoringSessionUser = null;
    private Button bUnregisterTrackingId = null;

    private TextView tvLabel = null;

    private String trackingIdentifier = null;
    private String trackToken = null;
    private String siteIdentifier = null;
    private String siteIdentifierToNotifyMonitoringUser = null;

    private CSUserInfo userInfo = null;
    private String name = null;
    private String email = null;
    private String phoneNumber = null;
    private String licensePlate = null;
    private String carMake = null;
    private String carModel = null;

    private Subscription completeTripSubscription = null;
    private Subscription userArrivedAtSiteSubscription = null;

    public Notification notification = null;

    @Override
    protected void onCreate(final Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
        final Toolbar toolbar = (Toolbar) findViewById(R.id.toolbar);
        setSupportActionBar(toolbar);

        etTrackingIdentifier = (EditText) findViewById(R.id.etTrackingIdentifier);
        etTrackToken = (EditText) findViewById(R.id.etTrackToken);
        etSiteIdentifier = (EditText) findViewById(R.id.etSiteIdentifier);
        etName = (EditText) findViewById(R.id.etName);
        etEmail = (EditText) findViewById(R.id.etEmail);
        etPhoneNumber = (EditText) findViewById(R.id.etPhoneNumber);
        etCarMake = (EditText) findViewById(R.id.etCarMake);
        etCarModel = (EditText) findViewById(R.id.etCarModel);
        etLicensePlate = (EditText) findViewById(R.id.etLicensePlate);

        bRegisterTrackingId = (Button) findViewById(R.id.bRegisterTrackingId);
        bRegisterTrackingId.setOnClickListener(this);

        bStartTrip = (Button) findViewById(R.id.bStartTrip);
        bStartTrip.setAlpha(ALPHA);
        bStartTrip.setOnClickListener(this);

        bCancelTrip = (Button) findViewById(R.id.bCancelTrip);
        bCancelTrip.setAlpha(ALPHA);
        bCancelTrip.setOnClickListener(this);

        bNotifyMonitoringSessionUser = (Button) findViewById(R.id.bNotifyMonitoringSessionUser);
        bNotifyMonitoringSessionUser.setAlpha(ALPHA);
        bNotifyMonitoringSessionUser.setOnClickListener(this);

        bUnregisterTrackingId = (Button) findViewById(R.id.bUnregisterTrackingId);
        bUnregisterTrackingId.setAlpha(ALPHA);
        bUnregisterTrackingId.setOnClickListener(this);

        tvLabel = (TextView) findViewById(R.id.tvLabel);

        checkLocationPermissions();

        //Initialize CSUserSession
        CSUserSession.init(this /*context*/, new TokenCurbsideCredentialProvider(USAGE_TOKEN));

        notification = createNotification();
        if(notification != null)
            CSUserSession.getInstance().setNotificationForForegroundService(notification);
    }

    private void checkLocationPermissions() {
        if (ActivityCompat.checkSelfPermission(this /*context*/, Manifest.permission.ACCESS_FINE_LOCATION) != PackageManager.PERMISSION_GRANTED &&
                ActivityCompat.checkSelfPermission(this /*context*/, Manifest.permission.ACCESS_COARSE_LOCATION) != PackageManager.PERMISSION_GRANTED) {

            final String[] permissions = new String[]{Manifest.permission.ACCESS_COARSE_LOCATION, Manifest.permission.ACCESS_FINE_LOCATION};
            ActivityCompat.requestPermissions(this, permissions, PERMISSION_REQUEST_CODE /*int requestCode*/);
        }
    }

    @Override
    public void onRequestPermissionsResult(final int requestCode, final String permissions[], final int[] grantResults) {
        switch (requestCode) {
            case PERMISSION_REQUEST_CODE:
                Arrays.sort(grantResults);
                if (Arrays.binarySearch(grantResults, PackageManager.PERMISSION_DENIED) >= 0) {
                    tvLabel.setText("Location Permission Denied");
                    tvLabel.setTextColor(getResources().getColor(R.color.colorRed));
                    //Location permission not given by the user. Can try showing rationale to the user.
                } else {
                    //Location permissions given by the user.
                }
                break;
        }
    }

    @Override
    public void onClick(final View view) {
        switch (view.getId()) {
            case R.id.bRegisterTrackingId:
                trackingIdentifier = etTrackingIdentifier.getText().toString();

                //set CSUserInfo
                name = etName.getText().toString();
                email = etEmail.getText().toString();
                phoneNumber = etPhoneNumber.getText().toString();
                licensePlate = etLicensePlate.getText().toString();
                carMake = etCarMake.getText().toString();
                carModel = etCarModel.getText().toString();

                if(!carModel.isEmpty() || !carModel.isEmpty() || !licensePlate.isEmpty()){
                    userInfo = new CSUserInfo(name, email, phoneNumber, licensePlate, carMake, carModel);
                } else{
                    userInfo = new CSUserInfo(name, email, phoneNumber);
                }

                if(trackingIdentifier == null || trackingIdentifier.isEmpty()) {
                    tvLabel.setText("Please enter tracking Id");
                    tvLabel.setTextColor(getResources().getColor(R.color.colorRed));
                    return;
                }

                //create an observer for listening register tracking id events
                final Action1<Event> registerTrackingIdEventObserver = new Action1<com.curbside.sdk.event.Event>() {
                    @Override
                    public void call(final Event event) {
                        if (event.status == Status.SUCCESS) {
                            CSUserSession.getInstance().setUserInfo(userInfo);

                            tvLabel.setText(String.format("Successfully registered tracking id"));
                            tvLabel.setTextColor(getResources().getColor(R.color.colorPrimaryDark));

                            bStartTrip.setEnabled(true);
                            bStartTrip.setAlpha(NO_ALPHA);

                            bUnregisterTrackingId.setEnabled(true);
                            bUnregisterTrackingId.setAlpha(NO_ALPHA);

                            bRegisterTrackingId.setEnabled(false);
                            bRegisterTrackingId.setAlpha(ALPHA);

                        }  else if (event.status == Status.FAILURE) {
                            tvLabel.setText(String.format("Failure in register tracking Id due to: %s", (CSErrorCode) event.object));
                            tvLabel.setTextColor(getResources().getColor(R.color.colorRed));
                        }
                        return;
                    }
                };

                //subscribe to the event on the eventBus
                CSUserSession
                        .getInstance()
                        .getEventBus()
                        .getObservable(Path.USER, Type.REGISTER_TRACKING_ID)
                        .subscribe(registerTrackingIdEventObserver);

                //register tracking id
                CSUserSession.getInstance().registerTrackingIdentifier(trackingIdentifier);

                break;

            case R.id.bStartTrip:
                trackToken = etTrackToken.getText().toString();
                if(trackToken == null || trackToken.isEmpty()) {
                    tvLabel.setText("Please enter track token");
                    tvLabel.setTextColor(getResources().getColor(R.color.colorRed));
                    return;
                }

                siteIdentifier = etSiteIdentifier.getText().toString();
                if(siteIdentifier == null || siteIdentifier.isEmpty()) {
                    tvLabel.setText("Please enter site identifier");
                    tvLabel.setTextColor(getResources().getColor(R.color.colorRed));
                    return;
                }

                //create the observer for listening start trip event
                final Action1<Event> startTripEventObserver = new Action1<Event>() {
                    @Override
                    public void call(Event event) {
                        if(event.status == Status.SUCCESS) {
                            tvLabel.setText(String.format("Successfully started trip"));
                            tvLabel.setTextColor(getResources().getColor(R.color.colorPrimaryDark));
                            bCancelTrip.setEnabled(true);
                            bCancelTrip.setAlpha(NO_ALPHA);

                            bStartTrip.setEnabled(false);
                            bStartTrip.setAlpha(ALPHA);

                            createObserverToCheckIfCanNotifyMonitoringSessionUser();
                            createObserverToCheckIfUserArrived();
                        }
                        else if (event.status == Status.FAILURE) {
                            tvLabel.setText(String.format("Failure in start trip due to: %s", (CSErrorCode)event.object));
                            tvLabel.setTextColor(getResources().getColor(R.color.colorRed));
                        }

                        return;
                    }
                };

                //subscribe to the event on the eventBus
                CSUserSession.getInstance().getEventBus().getObservable(Path.USER, Type.START_TRIP).subscribe(startTripEventObserver);

                //start trip
                CSUserSession.getInstance().startTripToSiteWithIdentifier(siteIdentifier, trackToken);

                break;

            case R.id.bCancelTrip:

                //create an observer for listening cancel trip event
                final Action1<Event> cancelTripSiteEventObserver = new Action1<Event>() {
                    @Override
                    public void call(Event event) {
                        if(event.status == Status.SUCCESS) {
                            //Cannot start trip on track token on which complete/cancel track was called
                            tvLabel.setText(String.format("Successfully cancelled trip"));
                            tvLabel.setTextColor(getResources().getColor(R.color.colorPrimaryDark));

                            bNotifyMonitoringSessionUser.setEnabled(false);
                            bNotifyMonitoringSessionUser.setAlpha(ALPHA);

                            bCancelTrip.setEnabled(false);
                            bCancelTrip.setAlpha(ALPHA);

                            bStartTrip.setEnabled(true);
                            bStartTrip.setAlpha(NO_ALPHA);

                            showAlertDialogBox();
                        }
                        else if (event.status == Status.FAILURE) {
                            tvLabel.setText(String.format("Failure in cancelling trip due to: %s", (CSErrorCode)event.object));
                            tvLabel.setTextColor(getResources().getColor(R.color.colorRed));
                        }

                        return;
                    }
                };

                //subscribe to the event on the eventBus
                CSUserSession.getInstance().getEventBus().getObservable(Path.USER, Type.CANCEL_TRIP).subscribe(cancelTripSiteEventObserver);

                //cancel trip
                CSUserSession.getInstance().cancelTripToSiteWithIdentifier(siteIdentifier, null /*track token*/);

                break;

            case R.id.bNotifyMonitoringSessionUser:

                //create an observer for listening monitoring user event
                final Action1<Event> notifyMonitoringSessionUserEventObserver = new Action1<Event>() {
                    @Override
                    public void call(Event event) {
                        if(event.status == Status.SUCCESS) {
                            tvLabel.setText(String.format("Successfully notified monitoring user"));
                            tvLabel.setTextColor(getResources().getColor(R.color.colorPrimaryDark));
                        }
                        else if (event.status == Status.FAILURE) {
                            tvLabel.setText(String.format("Failure in notifying monitoring session user due to: %s", (CSErrorCode)event.object));
                            tvLabel.setTextColor(getResources().getColor(R.color.colorRed));
                        }

                        return;
                    }
                };

                //subscribe to the event on the eventBus
                CSUserSession.getInstance().getEventBus().getObservable(Path.USER, Type.NOTIFY_MONITORING_SESSION_USER).subscribe(notifyMonitoringSessionUserEventObserver);

                //notify monitoring session user
                CSUserSession.getInstance().notifyMonitoringSessionUserOfArrivalAtSite(new CSSite(siteIdentifierToNotifyMonitoringUser));
                break;

            case R.id.bUnregisterTrackingId:

                //create an observer for listening unregister tracking id event
                final Action1<Event> unregisterTrackingIdEventObserver = new Action1<Event>() {
                    @Override
                    public void call(Event event) {
                        if(event.status == Status.SUCCESS) {
                            tvLabel.setText(String.format("Successfully unregistered tracking id"));
                            tvLabel.setTextColor(getResources().getColor(R.color.colorPrimaryDark));
                            disableAllExceptRegisterTrackingId();
                        }
                        else if (event.status == Status.FAILURE) {
                            tvLabel.setText(String.format("Failure in unregistering tracking id due to: %s", (CSErrorCode)event.object));
                            tvLabel.setTextColor(getResources().getColor(R.color.colorRed));
                        }

                        return;
                    }
                };

                //subscribe to the event on the eventBus
                CSUserSession.getInstance().getEventBus().getObservable(Path.USER, Type.UNREGISTER_TRACKING_ID).subscribe(unregisterTrackingIdEventObserver);

                //unregister tracking identifier
                CSUserSession.getInstance().unregisterTrackingIdentifier();

                break;
        }
    }

    private void createObserverToCheckIfUserArrived() {
        final Action1<Event> userArrivedAtSiteEvent = new Action1<Event>() {
            @Override
            public void call(com.curbside.sdk.event.Event event) {
                if(event.status == Status.TRUE) {
                    Log.d(TAG, "User has arrived at site");

                    final CSSite site = (CSSite) event.object;
                    if(site != null) {
                        showNotification(site);
                        //create an observer for listening complete trip event
                        final Action1<Event> completeTripSiteEventObserver = new Action1<Event>() {
                            @Override
                            public void call(final Event event) {
                                if (event.status == Status.SUCCESS) {
                                    //Cannot start trip on track token on which complete track was called
                                    tvLabel.setText(String.format("Successfully completed trip"));
                                    tvLabel.setTextColor(getResources().getColor(R.color.colorPrimaryDark));
                                    bStartTrip.setEnabled(true);
                                    bStartTrip.setAlpha(NO_ALPHA);

                                    showAlertDialogBox();
                                } else if (event.status == Status.FAILURE) {
                                    tvLabel.setText(String.format("Failure in completing trip due to: %s", (CSErrorCode) event.object));
                                    tvLabel.setTextColor(getResources().getColor(R.color.colorRed));
                                }

                                if (completeTripSubscription != null)
                                    completeTripSubscription.unsubscribe();
                            }
                        };

                        //subscribe to the event on the eventBus
                        completeTripSubscription =
                                CSUserSession.getInstance().getEventBus().getObservable(Path.USER, Type.COMPLETE_TRIP).subscribe(completeTripSiteEventObserver);

                        CSUserSession.getInstance().completeTripToSiteWithIdentifier(site.getSiteIdentifier(), null);
                    }
                }
            }
        };

        //subscribe to the event
        if(userArrivedAtSiteSubscription == null || userArrivedAtSiteSubscription.isUnsubscribed()) {
            userArrivedAtSiteSubscription =
                    CSUserSession.getInstance().getEventBus().getObservable(Path.USER, Type.ARRIVED_AT_SITE).subscribe(userArrivedAtSiteEvent);
        }
    }

    private void showAlertDialogBox() {
        AlertDialog.Builder alertDialogBuilder = new AlertDialog.Builder(this);
        alertDialogBuilder
                .setTitle("Trip Cancelled Sucessfully")
                .setMessage("Do Not forget to change value of track token before calling start trip again. Cannot start trip on track token on which complete/cancel track was called")
                .setPositiveButton("OK", new DialogInterface.OnClickListener() {
                    @Override
                    public void onClick(final DialogInterface dialogInterface, final int id) {
                        dialogInterface.dismiss();
                    }
        });

        final AlertDialog alertDialog = alertDialogBuilder.create();
        alertDialog.show();
    }

    private void disableAllExceptRegisterTrackingId() {
        bRegisterTrackingId.setEnabled(true);
        bRegisterTrackingId.setAlpha(NO_ALPHA);

        bUnregisterTrackingId.setEnabled(false);
        bUnregisterTrackingId.setAlpha(ALPHA);

        bStartTrip.setEnabled(false);
        bStartTrip.setAlpha(ALPHA);

        bCancelTrip.setEnabled(false);
        bCancelTrip.setAlpha(ALPHA);

        bNotifyMonitoringSessionUser.setEnabled(false);
        bCancelTrip.setAlpha(ALPHA);
    }

    private void createObserverToCheckIfCanNotifyMonitoringSessionUser() {
        //create an observer to observe if you are near to any site and can notify monitoring session user there
        final Action1<Event> canNotifyMonitoringUserAtSiteEventObserver = new Action1<Event>() {
            @Override
            public void call(com.curbside.sdk.event.Event event) {
                if(event.status == Status.TRUE) {
                    final CSSite site = (CSSite) event.object;
                    if (site != null) {
                        tvLabel.setText(String.format("Can Notify Monitoring Session User Now!"));
                        tvLabel.setTextColor(getResources().getColor(R.color.colorPrimaryDark));
                        bNotifyMonitoringSessionUser.setEnabled(true);
                        bNotifyMonitoringSessionUser.setAlpha(NO_ALPHA);
                        siteIdentifierToNotifyMonitoringUser = site.getSiteIdentifier();
                    } else {
                         tvLabel.setText("User still in transit to the site");
                    }
                }

                return;
            }
        };

        //subscribe to the event
        CSUserSession.getInstance().getEventBus().getObservable(Path.USER, Type.CAN_NOTIFY_MONITORING_USER_AT_SITE).subscribe(canNotifyMonitoringUserAtSiteEventObserver);
    }

    private void showNotification(final CSSite site) {
        final String message = String.format("You have arrived at %s", site.getSiteIdentifier());

        if(Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            final String CHANNEL_ID = "USER_SESSION_APP_123";
            final String CHANNEL_NAME = "USER_SESSION_APP_CHANNEL";

            final NotificationChannel notificationChannel =
                    new NotificationChannel(CHANNEL_ID, CHANNEL_NAME, NotificationManager.IMPORTANCE_HIGH);

            final NotificationManager notificationManager =
                    (NotificationManager) getApplicationContext().getSystemService(Context.NOTIFICATION_SERVICE);
            notificationManager.createNotificationChannel(notificationChannel);

            final Notification notification =
                    new Notification.Builder(this, CHANNEL_ID)
                            .setContentTitle("User Session Notification")
                            .setSmallIcon(R.drawable.app_notification_icon)
                            .setContentText(message)
                            .build();

            notificationManager.notify(1 /*notifyID*/, notification);

        } else {
            final NotificationCompat.Builder builder =
                    new NotificationCompat.Builder(this)
                            .setContentTitle("User Session Notification")
                            .setSmallIcon(R.drawable.app_notification_icon)
                            .setContentText(message)
                            .setDefaults(Notification.DEFAULT_ALL)
                            .setPriority(Notification.PRIORITY_HIGH);

            final NotificationManager notificationManager =
                    (NotificationManager) getSystemService(Context.NOTIFICATION_SERVICE);

            notificationManager.notify(1 /*notifyID*/, builder.build());
        }
    }

    private Notification createNotification() {
        final Bitmap appIcon =
                BitmapFactory.decodeResource(getResources(), R.mipmap.app_product_icon_square);

        if(Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            final String CHANNEL_ID = "USER_SESSION_APP_123";
            final String CHANNEL_NAME = "USER_SESSION_APP_CHANNEL";

            final NotificationChannel notificationChannel =
                    new NotificationChannel(CHANNEL_ID, CHANNEL_NAME, NotificationManager.IMPORTANCE_LOW);

            final NotificationManager notificationManager =
                    (NotificationManager) getApplicationContext().getSystemService(Context.NOTIFICATION_SERVICE);
            notificationManager.createNotificationChannel(notificationChannel);

            return new Notification.Builder(this, CHANNEL_ID)
                    .setContentTitle("User Session App Foreground Service")
                    .setContentText("Sending locations to server")
                    .setSmallIcon(R.drawable.app_notification_icon)
                    .setLargeIcon(Bitmap.createScaledBitmap(appIcon, 128 /*width*/, 128 /*height*/, false /*filter*/))
                    .setOngoing(true)
                    .build();
        }

        return null;
    }
}
