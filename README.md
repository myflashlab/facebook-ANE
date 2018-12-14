# Facebook SDK ANE (Android + iOS)
Use this AIR Native Extension to implement the latest official Facebook SDK into your AIR applications.

Main features:
* Login/logout
* ask users for permissions
* decide on your app logic based on granted permissions
* Share URL links directly from your app
* send Game Requests to friends
* Support App Events for use in Facebook analytics
* full access to Facebook Graph API... the sky is the limit!
* works on Android and iOS with an identical AS3 library

[find the latest **asdoc** for this ANE here.](http://myflashlab.github.io/asdoc/com/myflashlab/air/extensions/fb/package-detail.html)

# AIR Usage
###### Login sample. [find more samples in repository](https://github.com/myflashlab/facebook-ANE/tree/master/AIR/src)
```actionscript
import com.myflashlab.air.extensions.fb.*;

Facebook.init("000000000000000");

// Add these listeners right after initializing the ANE but don't call any other method before FacebookEvents.INIT happens
Facebook.listener.addEventListener(FacebookEvents.INIT, onAneInit);
Facebook.listener.addEventListener(FacebookEvents.INVOKE, onAneInvoke);

// You can receive the hashKey for your Android certificate like below.
if (Facebook.os == Facebook.ANDROID) trace("hash key = ", Facebook.hashKey);

function onAneInvoke(e:FacebookEvents):void
{
	trace("onAneInvoke: " + decodeURIComponent(e.deeplink));
}

function onAneInit(e:FacebookEvents):void
{
	trace("onAneInit");
	
	// check if user is already logged in or not
	_accessToken = Facebook.auth.currentAccessToken;
	
	/*
		IMPORTANT: in practice you should let users click on a login button 
		not logging them automatically.
	*/
	if(!_accessToken) toLogin();
}

function toLogin():void
{
	/*
		It is recommended to login users with minimal permissions. Later, whe your app 
		needs more permissions, you can call "Facebook.auth.login" again with more permissions.
		
		To ask for publish permissions, set the first parameter to "true".
	*/

	var permissions:Array = [Permissions.public_profile, Permissions.user_friends, Permissions.email];
	Facebook.auth.login(false, permissions, loginCallback);
	
	function loginCallback($isCanceled:Boolean, $error:Error, $accessToken:AccessToken, $recentlyDeclined:Array, $recentlyGranted:Array):void
	{
		if($error)
		{
			trace("login error: " + $error.message);
		}
		else
		{
			if($isCanceled)
			{
				trace("login canceled by user");
			}
			else
			{
				trace("$recentlyDeclined: " + $recentlyDeclined);
				trace("$recentlyGranted: " + $recentlyGranted);
				
				_accessToken = $accessToken;
				
				trace("token: " + _accessToken.token);
				trace("userId: " + _accessToken.userId);
				trace("declinedPermissions: " + _accessToken.declinedPermissions);
				trace("grantedPermissions: " + _accessToken.grantedPermissions);
				trace("expiration: " + new Date(_accessToken.expiration).toLocaleDateString());
				trace("lastRefresh: " + new Date(_accessToken.lastRefresh).toLocaleDateString());
			}
		}
	}
}
```

# AIR .xml manifest
```xml
  <android>
    <manifestAdditions>
		<![CDATA[<manifest android:installLocation="auto">
		<uses-permission android:name="android.permission.WAKE_LOCK" />
		<uses-permission android:name="android.permission.INTERNET" />
		
		<uses-sdk android:minSdkVersion="15" android:targetSdkVersion="26"/>
		
		<application 
			android:hardwareAccelerated="true" 
			android:allowBackup="true"
			android:name="android.support.multidex.MultiDexApplication">

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
					<data android:scheme="[PACKAGE_NAME]" />
				</intent-filter>
			</activity>
			
			
			
			<!-- 
				This is required by the Facebook ANE. replace the zeros with your actual Facebook App ID
				While doing that, notice the empty space after the "\ ". This is required because the ANE 
				must see the value as an String.
			-->
			<meta-data android:name="com.facebook.sdk.ApplicationId" android:value="\ 000000000000000"/>
			
			<!-- This is required by the Facebook ANE for logging in -->
			<activity 
				android:name="com.facebook.FacebookActivity" 
				android:configChanges="keyboard|keyboardHidden|screenLayout|screenSize|orientation"
				android:theme="@android:style/Theme.Translucent.NoTitleBar" 
				android:label="My App Name" />
			
			<activity android:name="com.facebook.CustomTabMainActivity" />
			<activity android:name="com.facebook.CustomTabActivity" android:exported="true">
				<intent-filter>
					<action android:name="android.intent.action.VIEW" />
					<category android:name="android.intent.category.DEFAULT" />
					<category android:name="android.intent.category.BROWSABLE" />
					<data android:scheme="fb000000000000000" />
				</intent-filter>
			</activity>
			
			<provider android:authorities="com.facebook.app.FacebookContentProvider000000000000000" android:name="com.facebook.FacebookContentProvider" android:exported="true"/>

			<receiver
				android:name="com.facebook.CurrentAccessTokenExpirationBroadcastReceiver" android:exported="false">
				<intent-filter>
					<action android:name="com.facebook.sdk.ACTION_CURRENT_ACCESS_TOKEN_CHANGED" />
				</intent-filter>
			</receiver>

			<!--
				change "[PACKAGE_NAME]" to your own package name
			-->
			<provider
				android:name="com.facebook.marketing.internal.MarketingInitProvider"
				android:authorities="[PACKAGE_NAME].MarketingInitProvider"
				android:exported="false" />

		</application>
		
</manifest>]]></manifestAdditions>
  </android>
  <iPhone>
    <!-- A list of plist key/value pairs to be added to the application Info.plist -->
    <InfoAdditions>
		<![CDATA[<key>MinimumOSVersion</key>
		<string>8.0</string>
		
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
					
					<!-- Your application scheme. read here for more information: http://www.myflashlabs.com/open-adobe-air-app-browser-pass-parameters/ -->
					<string>[PACKAGE_NAME]</string>
				</array>
			</dict>
		</array>

		<key>LSApplicationQueriesSchemes</key>
		<array>
			<string>fbapi</string>
			<string>fb-messenger-api</string>
			<string>fb-messenger-share-api</string>
			<string>fb-messenger</string>
			<string>fbauth2</string>
			<string>fbshareextension</string>
		</array>
			
		<key>NSPhotoLibraryUsageDescription</key>
		<string>My description about why I need this feature in my app</string>
		
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
  
	<extensionID>com.myflashlab.air.extensions.facebook</extensionID>

	<!-- Needed on Android/iOS -->
	<extensionID>com.myflashlab.air.extensions.dependency.overrideAir</extensionID>

	<!-- Needed on Android ONLY -->
	<extensionID>com.myflashlab.air.extensions.dependency.bolts</extensionID>
	<extensionID>com.myflashlab.air.extensions.dependency.androidSupport.appcompatV7</extensionID>
	<extensionID>com.myflashlab.air.extensions.dependency.androidSupport.arch</extensionID>
	<extensionID>com.myflashlab.air.extensions.dependency.androidSupport.cardviewV7</extensionID>
	<extensionID>com.myflashlab.air.extensions.dependency.androidSupport.core</extensionID>
	<extensionID>com.myflashlab.air.extensions.dependency.androidSupport.customtabs</extensionID>
	<extensionID>com.myflashlab.air.extensions.dependency.androidSupport.v4</extensionID>

  </extensions>
```

# Requirements:
1. This ANE is dependent on the following ANEs. [Download them from here:](https://github.com/myflashlab/common-dependencies-ANE)
	* overrideAir.ane
	* bolts.ane
	* androidSupport-appcompatV7.ane
	* androidSupport-arch.ane
	* androidSupport-cardviewV7.ane
	* androidSupport-core.ane
	* androidSupport-customtabs.ane
	* androidSupport-v4.ane
2. AIR SDK V30+
3. To compile on iOS, you will need to add following Facebook frameworks to your Air SDK.
  - download [FacebookSDKs-iOS-4.35.0.zip](https://origincache.facebook.com/developers/resources/?id=FacebookSDKs-iOS-4.35.0.zip) package and extract them on your computer.
    * FBSDKCoreKit.framework
    * FBSDKLoginKit.framework
    * FBSDKShareKit.framework
    * Bolts.framework
    * FBSDKMarketingKit.framework
    * FBSDKMessengerShareKit.framework
    * FBSDKPlacesKit.framework
  - you will see some xxxxxx.framework files. just copy them as they are and go to your AdobeAir SDK.
  - when in your Air SDK, go to "\lib\aot\stub". here you will find all the iOS frameworks provided by Air SDK by default.
  - paste the facebook frameworks you had downloaded into this folder and you are ready to build your project.
4. Android SDK 19 or higher 
5. iOS 9.0 or higher
6. In case you see the following error messages when compiling for iOS, check out [this video clip](https://www.youtube.com/watch?v=m4bwZRCvs2c) to know how to resolve it.
```
ld: library not found for -lclang_rt.ios
``` 
or 
```
Undefined symbols ___isOSVersionAtLeast
``` 
7. There's aknown bug as follow on windows machines when compiling for iOS. To avoid that, you will need a Mac to compile your project for iOS. We are hoping that Adobe would fix this problem soon so the app can be correctly packaged on Windows machines also. vote up here https://tracker.adobe.com/#/view/AIR-4198557
```
ld: in C:\AIR_SDK\lib\aot/stub/FBSDKCoreKit.framework/FBSDKCoreKit(FBSDKApplicationDelegate.o), unsupported address encoding (A5) of personality function in CIE for architecture arm64
Compilation failed while executing : ld64
```

# Commercial Version
https://www.myflashlabs.com/product/facebook-ane-adobe-air-native-extension/

[![Facebook SDK ANE](https://www.myflashlabs.com/wp-content/uploads/2015/11/product_adobe-air-ane-extension-facebook-2018-595x738.jpg)](https://www.myflashlabs.com/product/facebook-ane-adobe-air-native-extension/)

# Tutorials
* [How to embed ANEs into **FlashBuilder**, **FlashCC** and **FlashDevelop**](https://www.youtube.com/watch?v=Oubsb_3F3ec&list=PL_mmSjScdnxnSDTMYb1iDX4LemhIJrt1O)  
* [Usage WIKI](https://github.com/myflashlab/facebook-ANE/wiki)

# Premium Support #
[![Premium Support package](https://www.myflashlabs.com/wp-content/uploads/2016/06/professional-support.jpg)](https://www.myflashlabs.com/product/myflashlabs-support/)
If you are an [active MyFlashLabs club member](https://www.myflashlabs.com/product/myflashlabs-club-membership/), you will have access to our private and secure support ticket system for all our ANEs. Even if you are not a member, you can still receive premium help if you purchase the [premium support package](https://www.myflashlabs.com/product/myflashlabs-support/).