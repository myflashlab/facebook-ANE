To be able to compile this extension, you need to add the following ANEs to your project. https://github.com/myflashlab/common-dependencies-ANE

required on Android ONLY
  androidSupport.ane

required on Android + iOS
  overrideAir.ane

To compile on iOS, you will need to add the Facebook frameworks to your Air SDK. to do that, do the folloiwng:
1) download https://origincache.facebook.com/developers/resources/?id=FacebookSDKs-iOS-4.30.0.zip and extract them on your computer.
2) you will see some xxxxxx.framework files. just copy them as they are and go to your AdobeAir SDK.
  *. FBSDKCoreKit.framework
  *. FBSDKLoginKit.framework
  *. FBSDKShareKit.framework
  *. Bolts.framework

3) when in your Air SDK, go to "\lib\aot\stub". here you will find all the iOS frameworks provided by Air SDK by default.
4) paste the facebook frameworks you had downloaded into this folder and you are ready to build your project.

please check out our Github page for sample codes and also read the wikis for more tutorials.
https://github.com/myflashlab/facebook-ANE

if you have any question about how the extension works, please contact us through the 'issues' page on github.

Best Regards,
MyFlashLab Team