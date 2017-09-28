package com.curbside.mobileclient;

import android.Manifest;
import android.app.AlertDialog;
import android.content.DialogInterface;
import android.content.pm.PackageManager;
import android.os.Bundle;
import android.support.v4.app.ActivityCompat;
import android.support.v7.app.AppCompatActivity;
import android.support.v7.widget.Toolbar;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;
import android.widget.TextView;

import com.shopcurbside.curbsidesdk.CSErrorCode;
import com.shopcurbside.curbsidesdk.CSMobileSession;
import com.shopcurbside.curbsidesdk.CSSite;
import com.shopcurbside.curbsidesdk.credentialprovider.TokenCurbsideCredentialProvider;
import com.shopcurbside.curbsidesdk.event.Event;
import com.shopcurbside.curbsidesdk.event.Path;
import com.shopcurbside.curbsidesdk.event.Status;
import com.shopcurbside.curbsidesdk.event.Type;

import java.util.Arrays;
import java.util.List;
import java.util.Set;

import rx.functions.Action1;


public class MainActivity extends AppCompatActivity implements View.OnClickListener {
    private static final String TAG = "MainActivity";
    private static String USAGE_TOKEN = "YOUR_USAGE_TOKEN";

    private static final int PERMISSION_REQUEST_CODE = 1;

    private static final float ALPHA = (float)0.5;
    private static final float NO_ALPHA = 1;

    private EditText etTrackingIdentifier = null;
    private EditText etTrackToken = null;
    private EditText etSiteIdentifier = null;

    private Button bRegisterTrackingId = null;
    private Button bStartTrackingSite = null;
    private Button bStopTrackingSite = null;
    private Button bNotifyAssociate = null;
    private Button bUnregisterTrackingId = null;

    private TextView tvLabel = null;

    private String trackingIdentifier = null;
    private String trackToken = null;
    private String siteIdentifier = null;
    private String siteIdentifierToNotifyAssociate = null;

    @Override
    protected void onCreate(final Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
        final Toolbar toolbar = (Toolbar) findViewById(R.id.toolbar);
        setSupportActionBar(toolbar);

        etTrackingIdentifier = (EditText) findViewById(R.id.etTrackingIdentifier);
        etTrackToken = (EditText) findViewById(R.id.etTrackToken);
        etSiteIdentifier = (EditText) findViewById(R.id.etSiteIdentifier);

        bRegisterTrackingId = (Button) findViewById(R.id.bRegisterTrackingId);
        bRegisterTrackingId.setOnClickListener(this);

        bStartTrackingSite = (Button) findViewById(R.id.bStartTrackingSite);
        bStartTrackingSite.setAlpha(ALPHA);
        bStartTrackingSite.setOnClickListener(this);

        bStopTrackingSite = (Button) findViewById(R.id.bStopTrackingSite);
        bStopTrackingSite.setAlpha(ALPHA);
        bStopTrackingSite.setOnClickListener(this);

        bNotifyAssociate = (Button) findViewById(R.id.bNotifyAssociate);
        bNotifyAssociate.setAlpha(ALPHA);
        bNotifyAssociate.setOnClickListener(this);

        bUnregisterTrackingId = (Button) findViewById(R.id.bUnregisterTrackingId);
        bUnregisterTrackingId.setAlpha(ALPHA);
        bUnregisterTrackingId.setOnClickListener(this);

        tvLabel = (TextView) findViewById(R.id.tvLabel);

        checkLocationPermissions();

        //Initialize CSMobileSession
        CSMobileSession.init(this /*context*/, new TokenCurbsideCredentialProvider(USAGE_TOKEN));
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
                if(trackingIdentifier == null || trackingIdentifier.isEmpty()) {
                    tvLabel.setText("Please enter tracking Id");
                    tvLabel.setTextColor(getResources().getColor(R.color.colorRed));
                    return;
                }

                //create an observer for listening register tracking id events
                final Action1<Event> registerTrackingIdEventObserver = new Action1<com.shopcurbside.curbsidesdk.event.Event>() {
                    @Override
                    public void call(final Event event) {
                        if (event.status == Status.SUCCESS) {
                            tvLabel.setText(String.format("Successfully registered tracking id"));
                            tvLabel.setTextColor(getResources().getColor(R.color.colorPrimaryDark));

                            bStartTrackingSite.setEnabled(true);
                            bStartTrackingSite.setAlpha(NO_ALPHA);

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
                CSMobileSession
                        .getInstance()
                        .getEventBus()
                        .getObservable(Path.USER, Type.REGISTER_TRACKING_ID)
                        .subscribe(registerTrackingIdEventObserver);

                //register tracking id
                CSMobileSession.getInstance().registerTrackingIdentifier(trackingIdentifier);

                break;

            case R.id.bStartTrackingSite:
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

                //create the observer for listening start tracking site event
                final Action1<Event> startTrackingSiteEventObserver = new Action1<com.shopcurbside.curbsidesdk.event.Event>() {
                    @Override
                    public void call(com.shopcurbside.curbsidesdk.event.Event event) {
                        if(event.status == Status.SUCCESS) {
                            tvLabel.setText(String.format("Successfully started tracking site"));
                            tvLabel.setTextColor(getResources().getColor(R.color.colorPrimaryDark));
                            bStopTrackingSite.setEnabled(true);
                            bStopTrackingSite.setAlpha(NO_ALPHA);

                            bStartTrackingSite.setEnabled(false);
                            bStartTrackingSite.setAlpha(ALPHA);

                            createObserverToCheckIfCanNotifyAssociate();
                        }
                        else if (event.status == Status.FAILURE) {
                            tvLabel.setText(String.format("Failure in start track due to: %s", (CSErrorCode)event.object));
                            tvLabel.setTextColor(getResources().getColor(R.color.colorRed));
                        }

                        return;
                    }
                };

                //subscribe to the event on the eventBus
                CSMobileSession.getInstance().getEventBus().getObservable(Path.USER, Type.START_TRACKING).subscribe(startTrackingSiteEventObserver);

                //start tracking the site
                final List<String> tokens = Arrays.asList(trackToken);
                final CSSite site = new CSSite(siteIdentifier, tokens);
                CSMobileSession.getInstance().startTrackingSite(site);

                break;

            case R.id.bStopTrackingSite:

                //create an observer for listening stop tracking site event
                final Action1<Event> stopTrackingSiteEventObserver = new Action1<com.shopcurbside.curbsidesdk.event.Event>() {
                    @Override
                    public void call(com.shopcurbside.curbsidesdk.event.Event event) {
                        if(event.status == Status.SUCCESS) {
                            //Cannot start tracking on track token on which stop/cancel track was called
                            tvLabel.setText(String.format("Successfully stopped tracking site."));
                            tvLabel.setTextColor(getResources().getColor(R.color.colorPrimaryDark));

                            bNotifyAssociate.setEnabled(false);
                            bNotifyAssociate.setAlpha(ALPHA);

                            bStopTrackingSite.setEnabled(false);
                            bStopTrackingSite.setAlpha(ALPHA);

                            bStartTrackingSite.setEnabled(true);
                            bStartTrackingSite.setAlpha(NO_ALPHA);

                            showAlertDialogBox();
                        }
                        else if (event.status == Status.FAILURE) {
                            tvLabel.setText(String.format("Failure in stop tracking site due to: %s", (CSErrorCode)event.object));
                            tvLabel.setTextColor(getResources().getColor(R.color.colorRed));
                        }

                        return;
                    }
                };

                //subscribe to the event on the eventBus
                CSMobileSession.getInstance().getEventBus().getObservable(Path.USER, Type.STOP_TRACKING).subscribe(stopTrackingSiteEventObserver);

                //stop tracking site
                CSMobileSession.getInstance().stopTrackingSite(new CSSite(siteIdentifier));

                break;

            case R.id.bNotifyAssociate:

                //create an observer for listening notify associate event
                final Action1<Event> notifyAssociateEventObserver = new Action1<com.shopcurbside.curbsidesdk.event.Event>() {
                    @Override
                    public void call(com.shopcurbside.curbsidesdk.event.Event event) {
                        if(event.status == Status.SUCCESS) {
                            tvLabel.setText(String.format("Successfully notified associate"));
                            tvLabel.setTextColor(getResources().getColor(R.color.colorPrimaryDark));
                        }
                        else if (event.status == Status.FAILURE) {
                            tvLabel.setText(String.format("Failure in notifying associate due to: %s", (CSErrorCode)event.object));
                            tvLabel.setTextColor(getResources().getColor(R.color.colorRed));
                        }

                        return;
                    }
                };

                //subscribe to the event on the eventBus
                CSMobileSession.getInstance().getEventBus().getObservable(Path.USER, Type.NOTIFY_ASSOCIATE).subscribe(notifyAssociateEventObserver);

                //notifyAssociate
                CSMobileSession.getInstance().getNotifyAssociateManager().notifyAssociate(trackingIdentifier, siteIdentifierToNotifyAssociate);
                break;

            case R.id.bUnregisterTrackingId:

                //create an observer for listening unregister tracking id event
                final Action1<Event> unregisterTrackingIdEventObserver = new Action1<com.shopcurbside.curbsidesdk.event.Event>() {
                    @Override
                    public void call(com.shopcurbside.curbsidesdk.event.Event event) {
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
                CSMobileSession.getInstance().getEventBus().getObservable(Path.USER, Type.UNREGISTER_TRACKING_ID).subscribe(unregisterTrackingIdEventObserver);

                //notifyAssociate
                CSMobileSession.getInstance().unregisterTrackingIdentifier();
                break;
        }
    }

    private void showAlertDialogBox() {
        AlertDialog.Builder alertDialogBuilder = new AlertDialog.Builder(this);
        alertDialogBuilder
                .setTitle("Stop Tracking Successful")
                .setMessage("Do Not forget to change value of track token before calling start track again. Cannot start tracking on track token on which stop/cancel track was called")
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

        bStartTrackingSite.setEnabled(false);
        bStartTrackingSite.setAlpha(ALPHA);

        bStopTrackingSite.setEnabled(false);
        bStopTrackingSite.setAlpha(ALPHA);

        bNotifyAssociate.setEnabled(false);
        bStopTrackingSite.setAlpha(ALPHA);
    }

    private void createObserverToCheckIfCanNotifyAssociate() {
        //create an observer to observe if you are near to any site and can notify associate there
        final Action1<com.shopcurbside.curbsidesdk.event.Event> canNotifyAssociateEventObserver = new Action1<com.shopcurbside.curbsidesdk.event.Event>() {
            @Override
            public void call(com.shopcurbside.curbsidesdk.event.Event event) {
                if(event.status == Status.COMPLETED) {
                    final Set<String> siteIds = CSMobileSession.getInstance().getSitesToNotifyOpsOfArrival();
                    if (siteIds.size() > 0) {
                        tvLabel.setText(String.format("Can Notify Associate Now!"));
                        tvLabel.setTextColor(getResources().getColor(R.color.colorPrimaryDark));
                        bNotifyAssociate.setEnabled(true);
                        bNotifyAssociate.setAlpha(NO_ALPHA);
                        siteIdentifierToNotifyAssociate = siteIds.iterator().next();
                    } else {
                         tvLabel.setText("User still in transit to the site");
                    }
                }

                return;
            }
        };

        //subscribe to the event
        CSMobileSession.getInstance().getEventBus().getObservable(Path.USER, Type.FETCH_TRACKING_INFO).subscribe(canNotifyAssociateEventObserver);
    }
}
