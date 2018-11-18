# Facebook SDK ANE V4.35.1 (Android + iOS)
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

# asdoc
[find the latest asdoc for this ANE here.](http://myflashlab.github.io/asdoc/com/myflashlab/air/extensions/fb/package-detail.html)

[Download demo ANE](https://github.com/myflashlab/facebook-ANE/tree/master/AIR/lib)

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

![Facebook SDK ANE](https://www.myflashlabs.com/wp-content/uploads/2015/11/product_adobe-air-ane-extension-facebook-595x738.jpg)

# Tutorials
[How to embed ANEs into **FlashBuilder**, **FlashCC** and **FlashDevelop**](https://www.youtube.com/watch?v=Oubsb_3F3ec&list=PL_mmSjScdnxnSDTMYb1iDX4LemhIJrt1O)  
[Usage WIKI](https://github.com/myflashlab/facebook-ANE/wiki)

# Changelog
*Nov 17, 2018 - V4.35.1*
* Works with OverrideAir ANE V5.6.1 or higher
* Works with ANELAB V1.1.26 or higher

*Sep 10, 2018 - V4.35.0*
* Updated to the official Facebook SDK V4.35.0.
  * If you see an error like ```Undefined symbols ___isOSVersionAtLeast``` when compiling the iOS side, please watch this video: https://www.youtube.com/watch?v=m4bwZRCvs2c  
* Remove the androidSupport ANE from your project and from your manifest. *com.myflashlab.air.extensions.dependency.androidSupport*
* We have split the androidSupport dependency into smaller ANEs for better performance. You need to include the following ANEs to your project instead of one androidSupport ANE:
  * ```<extensionID>com.myflashlab.air.extensions.dependency.bolts</extensionID>```
  * ```<extensionID>com.myflashlab.air.extensions.dependency.androidSupport.appcompatV7</extensionID>```
  * ```<extensionID>com.myflashlab.air.extensions.dependency.androidSupport.arch</extensionID>```
  * ```<extensionID>com.myflashlab.air.extensions.dependency.androidSupport.cardviewV7</extensionID>```
  * ```<extensionID>com.myflashlab.air.extensions.dependency.androidSupport.core</extensionID>```
  * ```<extensionID>com.myflashlab.air.extensions.dependency.androidSupport.customtabs</extensionID>```
  * ```<extensionID>com.myflashlab.air.extensions.dependency.androidSupport.v4</extensionID>```
* Added property ```appId``` to AccessToken instances
* For expert users, now the ANE supports manual generation of AccessToken instance using the newly introduced method ```Facebook.auth.manualInit```. If you don't know what this method is, do not use it at all. Eventually, to use the generated AccessToken, we have made the ```Facebook.auth.currentAccessToken``` property writeable also so you can pass the AccessToken instance to it.
* New method ```Facebook.auth.isCurrentAccessTokenActive``` introduced. This will tell you if the current AccessToken is active or not.
* Upgrade to Facebook Graph API Version 3.1
* Add the following receiver tag to your manifest:
```xml
<receiver
    android:name="com.facebook.CurrentAccessTokenExpirationBroadcastReceiver" android:exported="false">
    <intent-filter>
        <action android:name="com.facebook.sdk.ACTION_CURRENT_ACCESS_TOKEN_CHANGED" />
    </intent-filter>
</receiver>
```
* Add the following provider tag to your manifest but make sure you are replacing [PACKAGE_NAME] with your own app package name. Don't forget that Android AIR apps adds *air.* to the beginning of your package name.
```xml
<provider
    android:name="com.facebook.marketing.internal.MarketingInitProvider"
    android:authorities="[PACKAGE_NAME].MarketingInitProvider"
    android:exported="false" />
```

*Apr 28, 2018 - V4.30.1*
* Fixed issue [#129](https://github.com/myflashlab/facebook-ANE/issues/129)
* Fixed issue [#128](https://github.com/myflashlab/facebook-ANE/issues/128)

*Apr 4, 2018 - V4.30.0*
* Updated to Facebook SDK V4.30.0 on both Android and iOS.
* You need to update the iOS frameworks from [this package](https://origincache.facebook.com/developers/resources/?id=FacebookSDKs-iOS-4.30.0.zip)
  * FBSDKCoreKit.framework
  * FBSDKLoginKit.framework
  * FBSDKShareKit.framework
  * Bolts.framework
* Facebook Invites and Native Like buttons have been deprecated and are removed from the ANE.
* AS3 API re-write from scratch to be able to work with Facebook SDK easier. In your AIR project, simply import ```import com.myflashlab.air.extensions.fb.*```.
* asdoc location changed to **http://myflashlab.github.io/asdoc/com/myflashlab/air/extensions/fb/package-detail.html**
* Read wiki pages to learn how to initialize and access different Facebook APIs: https://github.com/myflashlab/facebook-ANE/wiki
* You will need at least AIR SDK 28 to run this ANE.
* Android API 19 is the oldest Android API version to be supported.
* AIR Manifest changes:
  * removed the tag ```<activity android:name="com.doitflash.facebook.access.MyLogin" ....```
  * removed the tag ```<activity android:name="com.doitflash.facebook.sharing.MyShare" ...```
  * removed the tag ```<activity android:name="com.doitflash.facebook.invite.MyInvite" ...```
  * Added ```<string>fb-messenger-share-api</string>``` and ```<string>fb-messenger</string>``` to ```LSApplicationQueriesSchemes```.
* A lot of new features are added like ```Facebook.games.requestDialog```, ```Facebook.isFacebookMessengerAppInstalled``` or ```Facebook.appEvents.logPurchase``` and many more. to learn about them, please read the wiki docs.

*Dec 15, 2017 - V4.22.5*
* Optimized for [ANE-LAB software](https://github.com/myflashlab/ANE-LAB/).

*Sep 03, 2017 - V4.22.3*
* Added callbacks to know when the like button is clicked, [requested here](https://github.com/myflashlab/facebook-ANE/issues/92). You need to listen to this event: ```FBEvent.LIKE_BTN_CLICKED```.

*Aug 19, 2017 - V4.22.2*
* Fixed bug #90
* Added IntelliJ demo

*May 16, 2017 - V4.22.1*
* updated the core facebook SDK to V4.22.1
* The ```FB.graph.request``` method along with the ```FB.graph.version``` property is removed. these were deprecated in the last release and are now removed. instead you have to use the [FB.graph.call](http://myflashlab.github.io/asdoc/com/myflashlab/air/extensions/facebook/access/Graph.html#call()) method to access the graph.
* new methods introduced: [FB.setUserId](http://myflashlab.github.io/asdoc/com/myflashlab/air/extensions/facebook/FB.html#setUserId()), [FB.clearUserId](http://myflashlab.github.io/asdoc/com/myflashlab/air/extensions/facebook/FB.html#clearUserId()) and  [FB.updateUserProperties](http://myflashlab.github.io/asdoc/com/myflashlab/air/extensions/facebook/FB.html#updateUserProperties())
* When using sharing a URL with ```FB.share(shareModel, onSharingResult);```, the shareModel object can only have the [contentURL](http://myflashlab.github.io/asdoc/com/myflashlab/air/extensions/facebook/sharing/ShareLink.html#contentURL) property. Other properties are deprecated: (```contentDescription```, ```contentTitle``` and ```imageURL```)
* You need to update your dependency files ```androidSupport.ane``` (required on Android ONLY) and ```overrideAir.ane``` (required on iOS+Android).
* Min Air SDK is 25+
* Min Android SDK is 15+
* Min iOS SDK is 8+
* You need to add the following changes to your manifest .xml file:
  * Add ```<meta-data android:name="com.facebook.sdk.ApplicationId" android:value="\ {FB_APP_ID}"/>```. **Notice the space after the ```\```**
  * change two activities to following while replacing ```My App Name``` with your own app name. 
  ```xml
  <activity android:name="com.facebook.FacebookActivity" android:configChanges="keyboard|keyboardHidden|screenLayout|screenSize|orientation" android:theme="@android:style/Theme.Translucent.NoTitleBar" android:label="My App Name" />
  <activity android:name="com.doitflash.facebook.access.MyLogin" android:configChanges="keyboard|keyboardHidden|screenLayout|screenSize|orientation" android:theme="@style/Theme.Transparent" />
  ``` 
  * Add these activities while changing {FB_APP_ID} to your own Facebook App ID.
  ```xml
  <activity android:name="com.facebook.CustomTabMainActivity" />
  <activity
	  android:name="com.facebook.CustomTabActivity"
	  android:exported="true">
	  <intent-filter>
		  <action android:name="android.intent.action.VIEW" />
		  <category android:name="android.intent.category.DEFAULT" />
		  <category android:name="android.intent.category.BROWSABLE" />
		  <data android:scheme="fb{FB_APP_ID}" />
	  </intent-filter>
  </activity>
  ```
  * Don't forget to include other manifest settings. Above, we only mentioned what is changed.

*Mar 17, 2017 - V4.17.1*
* Updated the ANE with OverrideAIR V4.0.0 From now on, this ANE will also be needed for the iOS side too.

*Nov 10, 2016 - V4.17.0*
* Optimized for manual permissions required by AIR SDK 24+
* Min AIR SDK 24 to compile this ANE with swf-version set to 35
* updated the core facebook SDK to V4.17.0 - Make sure to update your current [Facebook frameworks for iOS](https://github.com/myflashlab/facebook-ANE/blob/master/FB_SDK_FRAMEWORKS.zip)
* Min iOS to support this version is 8.0
* Login activity has changed to:
```xml
<activity android:name="com.facebook.FacebookActivity" android:configChanges="fontScale|keyboard|keyboardHidden|locale|mnc|mcc|navigation|orientation|screenLayout|screenSize|smallestScreenSize|uiMode|touchscreen" android:theme="@android:style/Theme.Translucent.NoTitleBar" />
```
* You no longer need to whitelist Facebook domains.
* Add Usage Description for PhotoLibrary by the Facebook SDK
```xml
<key>NSPhotoLibraryUsageDescription</key>
<string>My description about why I need this feature in my app</string>
```
* Make sure to [update the common dependencies](https://github.com/myflashlab/common-dependencies-ANE): **overrideAir** and **androidSupport** to the latest version
* The ```FB.graph.request()``` method and the ```FB.graph.version``` property is now depricated. Instead use the ```FB.graph.call()``` method and pass in the graph version directly:
```actionscript
FB.graph.addEventListener(FBEvent.GRAPH_RESPONSE, onGraphResponse);
FB.graph.addEventListener(FBEvent.GRAPH_RESPONSE_ERROR, onGraphError);
FB.graph.call("https://graph.facebook.com/v2.8/me", URLRequestMethod.GET, new URLVariables("fields=name,email,picture&metadata=0"));
```

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