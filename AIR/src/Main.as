package
{
import com.myflashlab.air.extensions.fb.*;
import com.myflashlab.air.extensions.dependency.*;

import com.doitflash.consts.Direction;
import com.doitflash.consts.Orientation;
import com.doitflash.mobileProject.commonCpuSrc.DeviceInfo;
import com.doitflash.starling.utils.list.List;
import com.doitflash.text.modules.MySprite;
import com.luaye.console.C;

import flash.desktop.NativeApplication;
import flash.desktop.SystemIdleMode;

import flash.display.Sprite;
import flash.display.StageAlign;
import flash.display.StageScaleMode;
import flash.events.Event;
import flash.events.InvokeEvent;
import flash.events.KeyboardEvent;
import flash.events.MouseEvent;
import flash.net.URLRequestMethod;
import flash.net.URLVariables;
import flash.text.AntiAliasType;
import flash.text.TextField;
import flash.text.TextFieldAutoSize;
import flash.text.TextFormat;
import flash.text.TextFormatAlign;
import flash.ui.Keyboard;
import flash.ui.Multitouch;
import flash.ui.MultitouchInputMode;

/**
 * ...
 * @author Hadi Tavakoli - 3/31/18 3:21 PM
 */
public class Main extends Sprite
{
	private const BTN_WIDTH:Number = 150;
	private const BTN_HEIGHT:Number = 60;
	private const BTN_SPACE:Number = 2;
	private var _txt:TextField;
	private var _body:Sprite;
	private var _list:List;
	private var _numRows:int = 1;
	
	private var _accessToken:AccessToken;
	
	public function Main()
	{
		Multitouch.inputMode = MultitouchInputMode.GESTURE;
		NativeApplication.nativeApplication.addEventListener(Event.ACTIVATE, handleActivate);
		NativeApplication.nativeApplication.addEventListener(Event.DEACTIVATE, handleDeactivate);
		NativeApplication.nativeApplication.addEventListener(InvokeEvent.INVOKE, onInvoke);
		NativeApplication.nativeApplication.addEventListener(KeyboardEvent.KEY_DOWN, handleKeys);
		
		stage.addEventListener(Event.RESIZE, onResize);
		stage.scaleMode = StageScaleMode.NO_SCALE;
		stage.align = StageAlign.TOP_LEFT;
		
		C.startOnStage(this, "`");
		C.commandLine = false;
		C.commandLineAllowed = false;
		C.x = 100;
		C.width = 500;
		C.height = 250;
		C.strongRef = true;
		C.visible = true;
		C.scaleX = C.scaleY = DeviceInfo.dpiScaleMultiplier;
		
		_txt = new TextField();
		_txt.autoSize = TextFieldAutoSize.LEFT;
		_txt.antiAliasType = AntiAliasType.ADVANCED;
		_txt.multiline = true;
		_txt.wordWrap = true;
		_txt.embedFonts = false;
		_txt.htmlText = "<font face='Arimo' color='#333333' size='20'>Facebook ANE V" + Facebook.VERSION + "</font>";
		_txt.scaleX = _txt.scaleY = DeviceInfo.dpiScaleMultiplier;
		this.addChild(_txt);
		
		_body = new Sprite();
		this.addChild(_body);
		
		_list = new List();
		_list.holder = _body;
		_list.itemsHolder = new Sprite();
		_list.orientation = Orientation.VERTICAL;
		_list.hDirection = Direction.LEFT_TO_RIGHT;
		_list.vDirection = Direction.TOP_TO_BOTTOM;
		_list.space = BTN_SPACE;
		
		init();
		onResize();
	}
	
	private function onInvoke(e:InvokeEvent):void
	{
		//C.log("onInvoke = " + e.arguments);
		//NativeApplication.nativeApplication.removeEventListener(InvokeEvent.INVOKE, onInvoke);
	}
	
	private function handleActivate(e:Event):void
	{
		NativeApplication.nativeApplication.systemIdleMode = SystemIdleMode.KEEP_AWAKE;
	}
	
	private function handleDeactivate(e:Event):void
	{
		NativeApplication.nativeApplication.systemIdleMode = SystemIdleMode.NORMAL;
	}
	
	private function handleKeys(e:KeyboardEvent):void
	{
		if(e.keyCode == Keyboard.BACK)
		{
			e.preventDefault();
			
			NativeApplication.nativeApplication.exit();
		}
	}
	
	private function onResize(e:*=null):void
	{
		if (_txt)
		{
			_txt.width = stage.stageWidth * (1 / DeviceInfo.dpiScaleMultiplier);
			
			C.x = 0;
			C.y = (_txt.y + _txt.height) * (1 / DeviceInfo.dpiScaleMultiplier);
			C.width = stage.stageWidth * (1 / DeviceInfo.dpiScaleMultiplier);
			C.height = 300 * (1 / DeviceInfo.dpiScaleMultiplier);
		}
		
		if (_list)
		{
			_numRows = Math.floor(stage.stageWidth / (BTN_WIDTH * DeviceInfo.dpiScaleMultiplier + BTN_SPACE));
			_list.row = _numRows;
			_list.itemArrange();
		}
		
		if (_body)
		{
			_body.y = stage.stageHeight - _body.height;
		}
	}
	
	private function init():void
	{
		// Remove OverrideAir debugger in production builds
		OverrideAir.enableDebugger(function ($ane:String, $class:String, $msg:String):void
		{
			trace($ane+" ("+$class+") "+$msg);
		});
		
		Facebook.init("000000000000000");
		
		// Add these listeners right after initializing the ANE but don't call any other method before FacebookEvents.INIT happens
		Facebook.listener.addEventListener(FacebookEvents.INIT, onAneInit);
		Facebook.listener.addEventListener(FacebookEvents.INVOKE, onAneInvoke);
		
		// You can receive the hashKey for your Android certificate like below.
		if (OverrideAir.os == OverrideAir.ANDROID) trace("hash key = ", Facebook.hashKey);
	}
	
	private function onAneInvoke(e:FacebookEvents):void
	{
		trace("onAneInvoke: " + decodeURIComponent(e.deeplink));
	}
	
	private function onAneInit(e:FacebookEvents):void
	{
		trace("onAneInit");
		
		// check if user is already logged in or not
		_accessToken = Facebook.auth.currentAccessToken;
		
		if(_accessToken) showButtons();
		else showLoginButton();
	}
	
	private function showLoginButton():void
	{
		_list.removeAll();
		
		var btn1:MySprite = createBtn("Login");
		btn1.addEventListener(MouseEvent.CLICK, toLogin);
		_list.add(btn1);
		
		onResize();
	}
	
	private function toLogin(e:MouseEvent):void
	{
		/*
			It is recommended to login users with minimal permissions. Later, whe your app needs more permissions,
			you can call "Facebook.auth.login" again with more permissions.
			
			To ask for publish permissions, set the first parameter to "true".
		*/
		
		var permissions:Array = [Permissions.public_profile, Permissions.user_friends, Permissions.email];
		Facebook.auth.login(false, permissions, loginCallback);
		
		function loginCallback($isCanceled:Boolean, $error:Error, $accessToken:AccessToken, $recentlyDeclined:Array, $recentlyGranted:Array):void
		{
			if($error)
			{
				C.log("login error: " + $error.message);
			}
			else
			{
				if($isCanceled)
				{
					C.log("login canceled by user");
				}
				else
				{
					trace("$recentlyDeclined: " + $recentlyDeclined);
					trace("$recentlyGranted: " + $recentlyGranted);
					
					_accessToken = $accessToken;
					showButtons();
				}
			}
		}
	}
	
	private function showButtons():void
	{
		C.log("user is login");
		
		trace("-");
		trace("token: " + _accessToken.token);
		trace("userId: " + _accessToken.userId);
		trace("appId: " + _accessToken.appId);
		trace("declinedPermissions: " + _accessToken.declinedPermissions);
		trace("grantedPermissions: " + _accessToken.grantedPermissions);
		trace("expiration: " + new Date(_accessToken.expiration).toLocaleDateString());
		trace("lastRefresh: " + new Date(_accessToken.lastRefresh).toLocaleDateString());
		trace("-");
		
		_list.removeAll();
		
		var btn0:MySprite = createBtn("isTokenActive?");
		btn0.addEventListener(MouseEvent.CLICK, isTokenActive);
		_list.add(btn0);
		
		function isTokenActive(e:MouseEvent):void
		{
			trace("isTokenActive: " + Facebook.auth.isCurrentAccessTokenActive());
		}
		
		var btn1:MySprite = createBtn("logout");
		btn1.addEventListener(MouseEvent.CLICK, toLogout);
		_list.add(btn1);
		
		function toLogout(e:MouseEvent):void
		{
			C.log("logout and disconnect from facebook...");
			
			Facebook.graph.call(
					"https://graph.facebook.com/v3.1/me/permissions",
					URLRequestMethod.POST,
					new URLVariables("method=delete"),
					function ($dataStr:String, $graphRequest:String):void
					{
						trace($graphRequest);
						trace($dataStr);
						
						Facebook.auth.logout();
						_accessToken = null;
						
						C.log("user is logout");
						
						showLoginButton();
					}
			);
		}
		
		var btn3:MySprite = createBtn("is Messenger Installed?");
		btn3.addEventListener(MouseEvent.CLICK, isFacebookMessengerAppInstalled);
		_list.add(btn3);
		
		function isFacebookMessengerAppInstalled(e:MouseEvent):void
		{
			C.log("isFacebookMessengerAppInstalled: " + Facebook.isFacebookMessengerAppInstalled);
		}
		
		var btn4:MySprite = createBtn("log event");
		btn4.addEventListener(MouseEvent.CLICK, logEvent);
		_list.add(btn4);
		
		function logEvent(e:MouseEvent):void
		{
			C.log("logEvent. check your facebook analytics page to see the logs. it may take some time for the logs to be seen there.");
			Facebook.appEvents.logEvent("myEvent", randomRange(50, 100), {var1:"value1", var2:"value2"});
		}
		
		var btn5:MySprite = createBtn("share via dialog");
		btn5.addEventListener(MouseEvent.CLICK, shareDialog);
		_list.add(btn5);
		
		function shareDialog(e:MouseEvent):void
		{
			C.log("sharing via dialog, please wait...");
			
			var content:ShareLinkContent = new ShareLinkContent();
			content.quote = "This is a test quote message...";
			content.contentUrl = "https://myflashlabs.com/";
			content.hashtag = "#myflashlabs";
			
			Facebook.share.shareDialog(content, function ($isCanceled:Boolean, $error:Error):void
			{
				if($error)
				{
					C.log("Facebook.share.shareDialog $error: " + $error.message);
				}
				else
				{
					if($isCanceled)
					{
						C.log("Facebook.share.shareDialog canceled");
					}
					else
					{
						C.log("share completed.");
					}
				}
			});
		}
		
		var btn6:MySprite = createBtn("share via messenger");
		btn6.addEventListener(MouseEvent.CLICK, shareMessenger);
		_list.add(btn6);
		
		function shareMessenger(e:MouseEvent):void
		{
			if(!Facebook.isFacebookMessengerAppInstalled)
			{
				C.log("The messenger app is not installed on your device.");
				return;
			}
			
			C.log("sharing via messenger app, please wait...");
			
			var content:ShareLinkContent = new ShareLinkContent();
			content.contentUrl = "https://myflashlabs.com/";
			
			Facebook.share.shareMessenger(content, function ($error:Error):void
			{
				/*
					Content sharing with the messenger app can't be traced! The best you can have is to
					check if an error occurs before ANE tries to open the messenger app.
				 */
				
				if($error)
				{
					trace($error.message);
				}
			});
		}
		
		var btn7:MySprite = createBtn("send game request");
		btn7.addEventListener(MouseEvent.CLICK, sendGameRequest);
		_list.add(btn7);
		
		function sendGameRequest(e:MouseEvent):void
		{
			C.log("sendGameRequest");
			
			var requestContent:GameRequestContent = new GameRequestContent();
			requestContent.message = "This is a message :)";
			
			Facebook.games.requestDialog(requestContent, function ($isCanceled:Boolean, $error:Error, $result:Object):void
			{
				if($error)
				{
					trace("Facebook.games.requestDialog $error: " + $error.message);
				}
				else
				{
					if($isCanceled)
					{
						trace("Facebook.games.requestDialog canceled");
					}
					else
					{
						trace("Facebook.games.requestDialog sent");
						if($result)
						{
							trace(JSON.stringify($result));
						}
					}
				}
			});
		}
		
		var btn8:MySprite = createBtn("Call Graph");
		btn8.addEventListener(MouseEvent.CLICK, callGraph);
		_list.add(btn8);
		
		function callGraph(e:MouseEvent):void
		{
			C.log("callGraph");
			
			Facebook.graph.call(
					"https://graph.facebook.com/v3.1/me",
					URLRequestMethod.GET,
					new URLVariables("fields=name,email,picture&metadata=0"),
					function ($dataStr:String, $graphRequest:String):void
					{
						trace($graphRequest);
						trace($dataStr)
					}
			)
		}
		
		onResize();
	}
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	private function createBtn($str:String):MySprite
	{
		var sp:MySprite = new MySprite();
		sp.addEventListener(MouseEvent.MOUSE_OVER,  onOver);
		sp.addEventListener(MouseEvent.MOUSE_OUT,  onOut);
		sp.addEventListener(MouseEvent.CLICK,  onOut);
		sp.bgAlpha = 1;
		sp.bgColor = 0xDFE4FF;
		sp.drawBg();
		sp.width = BTN_WIDTH * DeviceInfo.dpiScaleMultiplier;
		sp.height = BTN_HEIGHT * DeviceInfo.dpiScaleMultiplier;
		
		function onOver(e:MouseEvent):void
		{
			sp.bgAlpha = 1;
			sp.bgColor = 0xFFDB48;
			sp.drawBg();
		}
		
		function onOut(e:MouseEvent):void
		{
			sp.bgAlpha = 1;
			sp.bgColor = 0xDFE4FF;
			sp.drawBg();
		}
		
		var format:TextFormat = new TextFormat("Arimo", 16, 0x666666, null, null, null, null, null, TextFormatAlign.CENTER);
		
		var txt:TextField = new TextField();
		txt.autoSize = TextFieldAutoSize.LEFT;
		txt.antiAliasType = AntiAliasType.ADVANCED;
		txt.mouseEnabled = false;
		txt.multiline = true;
		txt.wordWrap = true;
		txt.scaleX = txt.scaleY = DeviceInfo.dpiScaleMultiplier;
		txt.width = sp.width * (1 / DeviceInfo.dpiScaleMultiplier);
		txt.defaultTextFormat = format;
		txt.text = $str;
		
		txt.y = sp.height - txt.height >> 1;
		sp.addChild(txt);
		
		return sp;
	}
	
	private function randomRange(minNum:Number, maxNum:Number):Number
	{
		return (Math.floor(Math.random() * (maxNum - minNum + 1)) + minNum);
	}
}
}
