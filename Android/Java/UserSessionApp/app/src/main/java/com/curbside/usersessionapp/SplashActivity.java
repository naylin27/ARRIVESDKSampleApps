package com.curbside.usersessionapp;

import android.content.Intent;
import android.os.Bundle;
import android.os.Handler;
import android.support.v7.app.AppCompatActivity;

import com.curbside.usersessionapp.R;

public class SplashActivity extends AppCompatActivity {

    // Splash screen timer
    private static int SPLASH_TIME_OUT = 2000;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_splash);

        new Handler().postDelayed(new Runnable() {
            @Override
            public void run() {
                // This method will be executed once the timer is over
                // Start your app main activity
                final Intent mainActivityIntent = new Intent(SplashActivity.this, MainActivity.class);
                startActivity(mainActivityIntent);

                // close this activity
                finish();
            }
        }, SPLASH_TIME_OUT);
    }
}
