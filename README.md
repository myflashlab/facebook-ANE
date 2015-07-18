# Facebook SDK ANE V1.0
###### ios version to be released soon :iphone:
This extension is the cleanest and the most easy to work with Facebook API you can find online. don’t take my word for it. download it for free from here and test it for yourself. this will be your best solution to integrate Facebook into your Adobe Air apps.

Main features:
* Login/logout
* ask users for permissions
* decide on your app logic based on granted permissions
* Share URL links directly from your app
* create Facebook like button and place it inside your Air app
* full access to Facebook Graph API… the sky is the limit!

checkout here for the commercial version: http://myappsnippet.com/facebook-sdk-air-native-extension/

![Facebook SDK ANE](http://myappsnippet.com/wp-content/uploads/2015/07/facebook-adobe-air-extension_preview.jpg)

**NOTICE: the demo ANE works only after you hit the "OK" button in the dialog which opens. in your tests make sure that you are NOT calling other ANE methods prior to hitting the "OK" button.**

# Requirements:
1. you will need to add [commonDependenciesV2.0.ane](https://github.com/myflashlab/common-dependencies-ANE) to your project.
2. Compile with Air SDK 18 or above.

# AS3 API:
###### Login sample. (find more samples in repository)
```actionscript
     FB.getInstance("000000000000000"); // facebook app ID you received from your Facebook API console
     trace("hash key = ", FB.hashKey);

     FB.logManager.addEventListener(FBEvent.LOGIN_DONE, onLoginSuccess);
     FB.logManager.addEventListener(FBEvent.LOGIN_CANCELED, onLoginCanceled);
     FB.logManager.addEventListener(FBEvent.LOGIN_ERROR, onLoginError);
     
     // an array of permissions. you can add or remove items from this array anytime you like
     FB.logManager.requestPermission(Permissions.public_profile, Permissions.user_friends, Permissions.email);
     
     function onLoginSuccess(event:FBEvent):void
     {
         FB.logManager.removeEventListener(FBEvent.LOGIN_DONE, onLoginSuccess);
         FB.logManager.removeEventListener(FBEvent.LOGIN_CANCELED, onLoginCanceled);
         FB.logManager.removeEventListener(FBEvent.LOGIN_ERROR, onLoginError);
         
         trace("onLoginSuccess");
         trace("token = " + FB.logManager.token);
         trace("permissions = " + FB.logManager.permissions);
         trace("declined Permissions = " + FB.logManager.declinedPermissions);
     }
     
     function onLoginCanceled(event:FBEvent):void
     {
         FB.logManager.removeEventListener(FBEvent.LOGIN_DONE, onLoginSuccess);
         FB.logManager.removeEventListener(FBEvent.LOGIN_CANCELED, onLoginCanceled);
         FB.logManager.removeEventListener(FBEvent.LOGIN_ERROR, onLoginError);
         
         trace("onLoginCanceled");
     }
     
     function onLoginError(event:FBEvent):void
     {
         FB.logManager.removeEventListener(FBEvent.LOGIN_DONE, onLoginSuccess);
         FB.logManager.removeEventListener(FBEvent.LOGIN_CANCELED, onLoginCanceled);
         FB.logManager.removeEventListener(FBEvent.LOGIN_ERROR, onLoginError);
         
         trace("onLoginError = " + event.param);
     }
     
```

# Manifest setup:
```xml
<!-- This is required for logging in -->
<activity android:name="com.facebook.FacebookActivity" android:theme="@style/Theme.Transparent" />
<activity android:name="com.doitflash.facebook.access.MyLogin" android:theme="@style/Theme.Transparent" />

<!-- This is required for sharing. you must enter your FB app ID at the end of com.facebook.app.FacebookContentProvider again -->
<provider android:authorities="com.facebook.app.FacebookContentProvider000000000000000" android:name="com.facebook.FacebookContentProvider" android:exported="true"/>
<activity android:name="com.doitflash.facebook.sharing.MyShare" android:theme="@style/Theme.Transparent" />
```

This extension works on Android SDK 11 or higher