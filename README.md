# Facebook SDK ANE V4.11.0 (Android + iOS)
This extension is the cleanest and the most easy to work with Facebook API you can find online. don't take my word for it. download it for free and test it for yourself. this will be your best solution to integrate Facebook into your Adobe Air apps.

Main features:
* Login/logout
* ask users for permissions
* decide on your app logic based on granted permissions
* Share URL links directly from your app
* create Facebook like button and place it inside your Air app
* send App Invite to friends
* Support App Events for use in Facebook analytics
* full access to Facebook Graph API... the sky is the limit!
* works on Android and iOS with an identical AS3 library

# Demo .apk
you may like to see the ANE in action? [Download demo .apk](https://github.com/myflashlab/facebook-ANE/tree/master/FD/dist)

**NOTICE**: the demo ANE works only after you hit the "OK" button in the dialog which opens. in your tests make sure that you are NOT calling other ANE methods prior to hitting the "OK" button.
[Download the ANE](https://github.com/myflashlab/facebook-ANE/tree/master/FD/lib)

# Air Usage
###### Login sample. [find more samples in repository](https://github.com/myflashlab/facebook-ANE/tree/master/FD/src)
```actionscript
FB.getInstance("000000000000000"); // facebook app ID you received from your Facebook API console
trace("hash key = ", FB.hashKey); // required once for Android only

FB.auth.addEventListener(FBEvent.LOGIN_DONE, onLoginSuccess);
FB.auth.addEventListener(FBEvent.LOGIN_CANCELED, onLoginCanceled);
FB.auth.addEventListener(FBEvent.LOGIN_ERROR, onLoginError);

// an array of permissions. you can add or remove items from this array anytime you like
FB.auth.requestPermission(Auth.WITH_READ_PERMISSIONS, Permissions.public_profile, Permissions.user_friends, Permissions.email);

function onLoginSuccess(event:FBEvent):void
{
	FB.auth.removeEventListener(FBEvent.LOGIN_DONE, onLoginSuccess);
	FB.auth.removeEventListener(FBEvent.LOGIN_CANCELED, onLoginCanceled);
	FB.auth.removeEventListener(FBEvent.LOGIN_ERROR, onLoginError);
	
	trace("onLoginSuccess");
	trace("token = " + FB.auth.token);
	trace("permissions = " + FB.auth.permissions);
	trace("declined Permissions = " + FB.auth.declinedPermissions);
}

function onLoginCanceled(event:FBEvent):void
{
	FB.auth.removeEventListener(FBEvent.LOGIN_DONE, onLoginSuccess);
	FB.auth.removeEventListener(FBEvent.LOGIN_CANCELED, onLoginCanceled);
	FB.auth.removeEventListener(FBEvent.LOGIN_ERROR, onLoginError);
	
	trace("onLoginCanceled");
}

function onLoginError(event:FBEvent):void
{
	FB.auth.removeEventListener(FBEvent.LOGIN_DONE, onLoginSuccess);
	FB.auth.removeEventListener(FBEvent.LOGIN_CANCELED, onLoginCanceled);
	FB.auth.removeEventListener(FBEvent.LOGIN_ERROR, onLoginError);

	trace("onLoginError = " + event.param);
}
```

# Air .xml manifest
```xml
  <android>
    <manifestAdditions>
		<![CDATA[<manifest android:installLocation="auto">
		<uses-permission android:name="android.permission.WAKE_LOCK" />
		<uses-permission android:name="android.permission.INTERNET" />
		
		<application android:hardwareAccelerated="true" android:allowBackup="true">
			<activity android:hardwareAccelerated="false">
				<intent-filter>
					<action android:name="android.intent.action.MAIN" />
					<category android:name="android.intent.category.LAUNCHER" />
				</intent-filter>
				<intent-filter>
					<action android:name="android.intent.action.VIEW" />
					<category android:name="android.intent.category.BROWSABLE" />
					<category android:name="android.intent.category.DEFAULT" />
					
					<!-- Your application scheme. read here for more information: http://www.myflashlabs.com/open-adobe-air-app-browser-pass-parameters/ -->
					<data android:scheme="air.com.doitflash.exfacebook2" />
				</intent-filter>
			</activity>
			
			
			
			<!-- This is required for logging in -->
			<activity android:name="com.facebook.FacebookActivity" 			android:configChanges="fontScale|keyboard|keyboardHidden|locale|mnc|mcc|navigation|orientation|screenLayout|screenSize|smallestScreenSize|uiMode|touchscreen" 	android:theme="@style/Theme.Transparent" />
			<activity android:name="com.doitflash.facebook.access.MyLogin" 	android:configChanges="fontScale|keyboard|keyboardHidden|locale|mnc|mcc|navigation|orientation|screenLayout|screenSize|smallestScreenSize|uiMode|touchscreen"	android:theme="@style/Theme.Transparent" />
			
			<!-- This is required for sharing https://developers.facebook.com/docs/sharing/android -->
			<provider android:authorities="com.facebook.app.FacebookContentProvider000000000000000" android:name="com.facebook.FacebookContentProvider" android:exported="true"/>
			<activity android:name="com.doitflash.facebook.sharing.MyShare" android:theme="@style/Theme.Transparent" />
			
			<!-- This is required for app invite feature -->
			<activity android:name="com.doitflash.facebook.invite.MyInvite" android:theme="@style/Theme.Transparent" />
			
		</application>
		
</manifest>]]></manifestAdditions>
  </android>
  <iPhone>
    <!-- A list of plist key/value pairs to be added to the application Info.plist -->
    <InfoAdditions>
		<![CDATA[<key>MinimumOSVersion</key>
		<string>7.1</string>
		
		<key>UIStatusBarStyle</key>
		<string>UIStatusBarStyleBlackOpaque</string>
		
		<key>UIRequiresPersistentWiFi</key>
		<string>NO</string>
		
		<key>FacebookAppID</key>
		<string>000000000000000</string>
		
		<key>FacebookDisplayName</key>
		<string>Air Native Extension</string>
		
		<key>CFBundleURLTypes</key>
		<array> 
			<dict>
				<key>CFBundleURLSchemes</key>
				<array>
					<string>fb000000000000000</string>
					<string>air.com.doitflash.exfacebook2</string>
				</array>
			</dict>
		</array>
		
		<!-- To whitelist Facebook Apps and domains 
		https://developers.facebook.com/docs/ios/getting-started/  -->
		
		<key>NSAppTransportSecurity</key>
		<dict>
		  <key>NSExceptionDomains</key>
		  <dict>
			<key>facebook.com</key>
			<dict>
			  <key>NSIncludesSubdomains</key>
			  <true/>
			  <key>NSExceptionRequiresForwardSecrecy</key>
			  <false/>
			</dict>
			<key>fbcdn.net</key>
			<dict>
			  <key>NSIncludesSubdomains</key>
			  <true/>
			  <key>NSExceptionRequiresForwardSecrecy</key>
			  <false/>
			</dict>
			<key>akamaihd.net</key>
			<dict>
			  <key>NSIncludesSubdomains</key>
			  <true/>
			  <key>NSExceptionRequiresForwardSecrecy</key>
			  <false/>
			</dict>
		  </dict>
		</dict>

		<key>LSApplicationQueriesSchemes</key>
		<array>
			<string>fbapi</string>
			<string>fb-messenger-api</string>
			<string>fbauth2</string>
			<string>fbshareextension</string>
		</array>
		
		<key>UIDeviceFamily</key>
		<array>
			<!-- iPhone support -->
			<string>1</string>
			<!-- iPad support -->
			<string>2</string>
		</array>]]></InfoAdditions>
		
    <requestedDisplayResolution>high</requestedDisplayResolution>
  </iPhone>
  
  
  
  <extensions>
    <extensionID>com.myflashlab.air.extensions.dependency.overrideAir</extensionID>
    <extensionID>com.myflashlab.air.extensions.dependency.androidSupport</extensionID>
    <extensionID>com.myflashlab.air.extensions.facebook</extensionID>
  </extensions>
```

# Requirements:
1. This ANE is dependent on **androidSupport.ane** and **overrideAir.ane** You need to add these ANEs to your project too. [Download them from here:](https://github.com/myflashlab/common-dependencies-ANE)
2. Compile with Air SDK 22 or above.
3. To compile on iOS, you will need to add the Facebook frameworks to your Air SDK.
  - download FB_SDK_FRAMEWORKS.zip package from our github and extract them on your computer.
  - you will see some xxxxxx.framework files. just copy them as they are and go to your AdobeAir SDK.
  - when in your Air SDK, go to "\lib\aot\stub". here you will find all the iOS frameworks provided by Air SDK by default.
  - paste the facebook frameworks you had downloaded into this folder and you are ready to build your project.
4. Android SDK 15 or higher 
5. iOS 7.1 or higher
6. When compiling on Android, make sure you are always compiling in debug or captive mode. shared mode won't work because in the extension we have overwritten some Adobe classes for the extension to work properly.

# Commercial Version
http://www.myflashlabs.com/product/facebook-ane-adobe-air-native-extension/

![Facebook SDK ANE](http://www.myflashlabs.com/wp-content/uploads/2015/11/product_adobe-air-ane-extension-facebook-595x738.jpg)

# Tech Details
* When compiling on Android, rarely, randomly you may see a compilation error! Just try again and it will be fine. It's a bug on Adobe's side as [explained here](https://forums.adobe.com/thread/1948895)
* From V4.11.0 of this ANE, Facebook is forcing Safari View Controller (SVC) instead of fast-app-switching (FAS) for the iOS side. [Read the official blog about this](https://developers.facebook.com/blog/post/2015/10/29/Facebook-Login-iOS9/)

# Tutorials
[How to embed ANEs into **FlashBuilder**, **FlashCC** and **FlashDevelop**](https://www.youtube.com/watch?v=Oubsb_3F3ec&list=PL_mmSjScdnxnSDTMYb1iDX4LemhIJrt1O)  
[Understanding how Facebook SDK works in general](http://myappsnippet.com/adobe-air-facebook-sdk-integration-part-1)  
[Creating a Facebook application. A place for your app to connect to](http://myappsnippet.com/adobe-air-facebook-sdk-integration-part-2)  
[Connecting your FB app to your mobile app with a hash key](http://myappsnippet.com/adobe-air-facebook-sdk-integration-part-3)  
[Managing login/out and asking permissions from users](http://myappsnippet.com/adobe-air-facebook-sdk-integration-part-4)  
[Generating real Facebook Like buttons in your apps](http://myappsnippet.com/adobe-air-facebook-sdk-integration-part-5)  
[Knowing how to share content from your app](http://myappsnippet.com/adobe-air-facebook-sdk-integration-part-6)  
[Understanding Facebook Graph API. how to request for information](http://myappsnippet.com/adobe-air-facebook-sdk-integration-part-7)  
[Setting up the Air manifest .xml file for Android and iOS](http://myappsnippet.com/adobe-air-facebook-sdk-integration-part-8)  
[Compiling requirements on Android and iOS](http://myappsnippet.com/adobe-air-facebook-sdk-integration-part-9)  

# Changelog
*May 16, 2016 - V4.11.0*
* updated the core facebook SDK to [V4.11.0](https://developers.facebook.com/docs/android/change-log-4.x)
* Support Android API 15 or higher
* your app must be compiled with Air SDK 22 or higher
* Added App Events support ```FB.logEvent(eventName, sum, params)```
* Using Graph API v2.6
* ```FB.logManager``` is now deprecated. you should use ```FB.auth``` instead
* Updated the whitelist for facebook on iOS side of the manifest
* From FB SDK 4.6 and higher, FB is forcing Safari View Controller (SVC) instead of fast-app-switching (FAS). It seems like a pain not to have the fast-app-switching anymore but Facebook says, this is actually a good thing! [Read here for more details](https://developers.facebook.com/blog/post/2015/10/29/Facebook-Login-iOS9/)
* The iOS frameworks are updated to V4.11.0 **FB_SDK_FRAMEWORKS.zip**
* Added ```event.graphRequest``` to ```FBEvent.GRAPH_RESPONSE``` and ```FBEvent.GRAPH_RESPONSE_ERROR``` so you will know what request to the graph you had sent previously
* Some minor bug fixes


*Jan 20, 2016 - V3.9.2*
* bypassing xCode 7.2 bug causing iOS conflict when compiling with AirSDK 20 without waiting on Adobe or Apple to fix the problem. This is a must have upgrade for your app to make sure you can compile multiple ANEs in your project with AirSDK 20 or greater. https://forums.adobe.com/thread/2055508 https://forums.adobe.com/message/8294948


*Dec 20, 2015 - V3.9.1*
* minor bug fixes


*Nov 02, 2015 - V3.9*
* doitflash devs merged into MyFLashLab Team


*Sep 08, 2015 - V3.0*
* Added support for App invites https://developers.facebook.com/docs/app-invites
* Fixed Like button bug in Android where the button interface was not being updated after coming back to the flash app
* Requires commonDependenciesV4.0.ane or higher https://github.com/myflashlab/common-dependencies-ANE


*Jul 31, 2015 - V2.0*
* Added iOS support
* Minor bug fixes on Android side


*Jul 17, 2015 - V1.0*
* beginning of the journey!