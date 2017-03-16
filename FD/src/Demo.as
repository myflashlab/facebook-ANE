package 
{
	import com.myflashlab.air.extensions.facebook.access.Permissions;
	import com.myflashlab.air.extensions.facebook.access.Auth;
	import com.myflashlab.air.extensions.facebook.FB;
	import com.myflashlab.air.extensions.facebook.FBEvent;
	import com.myflashlab.air.extensions.facebook.LikeBtn;
	import com.myflashlab.air.extensions.facebook.AppEventsConstants;
	import com.myflashlab.air.extensions.facebook.sharing.ShareLink;
	import com.myflashlab.air.extensions.dependency.OverrideAir;
	
	import com.doitflash.consts.Direction;
	import com.doitflash.consts.Orientation;
	import com.doitflash.mobileProject.commonCpuSrc.DeviceInfo;
	import com.doitflash.starling.utils.list.List;
	import com.doitflash.text.modules.MySprite;
	import com.luaye.console.C;
	import flash.desktop.NativeApplication;
	import flash.desktop.SystemIdleMode;
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.InvokeEvent;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.ui.Keyboard;
	import flash.ui.Multitouch;
	import flash.ui.MultitouchInputMode;
	import com.greensock.TweenMax;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	
	/**
	 * 
	 * @author Hadi Tavakoli - 7/31/2015 3:33 PM
	 * 							10/31/2016 3:40 PM
	 */
	public class Demo extends Sprite 
	{
		private const BTN_WIDTH:Number = 150;
		private const BTN_HEIGHT:Number = 60;
		private const BTN_SPACE:Number = 2;
		private var _txt:TextField;
		private var _body:Sprite;
		private var _list:List;
		private var _numRows:int = 1;
		
		private var _user:Object;
		private var txt:TextField;
		private var bm:Bitmap;
		private var like:LikeBtn;
		
		public function Demo():void 
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
			_txt.htmlText = "<font face='Arimo' color='#333333' size='20'>Facebook extension V" + FB.VERSION + "</font>";
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
			
			// refresh the like button. updating a like button will not use much resources, feel free to use it to refresh the button anytime you wish to make sure its size fits correctly
			if(like) like.update("https://www.facebook.com/myflashlab", LikeBtn.STYLE_STANDARD, LikeBtn.LINK_TYPE_PAGE);
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
		
		private function myDebuggerDelegate($ane:String, $class:String, $msg:String):void
		{
			trace("------------------");
			trace("$ane = " + $ane);
			trace("$class = " + $class);
			trace("$msg = " + $msg);
			trace("------------------");
		}
		
		private function init():void
		{
			// remove this line in production build or pass null as the delegate
			OverrideAir.enableDebugger(myDebuggerDelegate);
			
			// App link: https://fb.me/477806509057618
			FB.getInstance("00000000000");
			if(FB.os == FB.ANDROID) trace("hash key = ", FB.hashKey);
			
			var btn1:MySprite = createBtn("Test Login and Graph");
			btn1.addEventListener(MouseEvent.CLICK, toLogin);
			_list.add(btn1);
			
			function toLogin(e:MouseEvent):void
			{
				if (FB.auth.isLogin)
				{
					C.log("You are now logged out... Please hit the button again to login back!");
					//toGraph();
					FB.auth.logout();
				}
				else
				{
					FB.auth.addEventListener(FBEvent.LOGIN_DONE, onLoginSuccess);
					FB.auth.addEventListener(FBEvent.LOGIN_CANCELED, onLoginCanceled);
					FB.auth.addEventListener(FBEvent.LOGIN_ERROR, onLoginError);
					FB.auth.requestPermission(Auth.WITH_READ_PERMISSIONS, Permissions.public_profile, Permissions.user_friends, Permissions.email);
					C.log("Please wait...");
				}
			}
			
			function onLoginSuccess(event:FBEvent):void
			{
				FB.auth.removeEventListener(FBEvent.LOGIN_DONE, onLoginSuccess);
				FB.auth.removeEventListener(FBEvent.LOGIN_CANCELED, onLoginCanceled);
				FB.auth.removeEventListener(FBEvent.LOGIN_ERROR, onLoginError);
				
				C.log("on Login Success... Now connecting to graph to download your profile picture!");
				toGraph();
			}
			
			function onLoginCanceled(event:FBEvent):void
			{
				FB.auth.removeEventListener(FBEvent.LOGIN_DONE, onLoginSuccess);
				FB.auth.removeEventListener(FBEvent.LOGIN_CANCELED, onLoginCanceled);
				FB.auth.removeEventListener(FBEvent.LOGIN_ERROR, onLoginError);
				
				C.log("on Login Canceled");
			}
			
			function onLoginError(event:FBEvent):void
			{
				FB.auth.removeEventListener(FBEvent.LOGIN_DONE, onLoginSuccess);
				FB.auth.removeEventListener(FBEvent.LOGIN_CANCELED, onLoginCanceled);
				FB.auth.removeEventListener(FBEvent.LOGIN_ERROR, onLoginError);
				
				C.log("on Login Error = " + event.param);
			}
			
			function toGraph():void
			{
				if (txt)
				{
					removeChild(txt);
					txt = null;
				}
				
				if (bm)
				{
					removeChild(bm);
					bm = null;
				}
				
				FB.graph.addEventListener(FBEvent.GRAPH_RESPONSE, onGraphResponse);
				FB.graph.addEventListener(FBEvent.GRAPH_RESPONSE_ERROR, onGraphError);
				FB.graph.call("https://graph.facebook.com/v2.8/me", URLRequestMethod.GET, new URLVariables("fields=name,email,picture&metadata=0"));
			}
			
			function onGraphResponse(event:FBEvent):void
			{
				FB.graph.removeEventListener(FBEvent.GRAPH_RESPONSE, onGraphResponse);
				FB.graph.removeEventListener(FBEvent.GRAPH_RESPONSE_ERROR, onGraphError);
				
				//C.log(event.graphRequest);
				//C.log(event.param);
				//C.log("----------------");
				
				_user = JSON.parse(event.param);
				
				
				
				// save some event logs for analytics reasons
				// 
				// NOTICE: If you really need to generate logs in your app, we stringly 
				// recommend you to have a look at the Firebase Analytics ANE:
				// http://www.myflashlabs.com/product/analytics-firebase-air-native-extension/
				if (_user.email) 
				{
					// The following two APIs are still in experimental and will work on the iOS side only at the moment
					FB.setUserId(_user.email);
					FB.updateUserProperties({name:_user.name}, onUpdateUserPropertiesResult);
				}
				
				
				
				
				toLoadProfilePic();
			}
			
			function onUpdateUserPropertiesResult($status:String, $msg:String):void
			{
				/*
				
				$status will be one of the following:
					FBEvent.UPDATE_USER_PROPERTIES_SUCCESS
					FBEvent.UPDATE_USER_PROPERTIES_ERROR
					
				if it is "FBEvent.UPDATE_USER_PROPERTIES_ERROR", then $msg will explain the error reason
				
				*/
				
				C.log("onUpdateUserPropertiesResult = " + $status);
			}
			
			function onGraphError(event:FBEvent):void
			{
				FB.graph.removeEventListener(FBEvent.GRAPH_RESPONSE, onGraphResponse);
				FB.graph.removeEventListener(FBEvent.GRAPH_RESPONSE_ERROR, onGraphError);
				
				C.log("ERROR!");
				C.log(event.graphRequest);
				C.log(event.param);
				C.log("----------------");
				
				var obj:Object;
				
				try
				{
					obj = JSON.parse(event.param);
					if (obj.error.type == "OAuthException")
					{
						FB.auth.logout();
						FB.auth.addEventListener(FBEvent.LOGIN_DONE, onLoginSuccess);
						FB.auth.addEventListener(FBEvent.LOGIN_CANCELED, onLoginCanceled);
						FB.auth.addEventListener(FBEvent.LOGIN_ERROR, onLoginError);
						FB.auth.requestPermission(Auth.WITH_READ_PERMISSIONS, Permissions.public_profile, Permissions.user_friends, Permissions.email);
					}
				}
				catch (err:Error)
				{
					
				}
			}
			
			function toLoadProfilePic():void
			{
				if (!_user.email) _user.email = "your FB email is not set!";
				
				txt = new TextField()
				txt.autoSize = TextFieldAutoSize.LEFT;
				txt.multiline = true;
				txt.border = false;
				txt.selectable = false;
				txt.defaultTextFormat = new TextFormat("Tahoma", 25, 0x9900);
				txt.htmlText = "Hello " + _user.name + ",<br>Your email address is:<br>" + _user.email;
				txt.x = 10;
				txt.y = (C.y + C.height + 5) * DeviceInfo.dpiScaleMultiplier;
				addChild(txt);
				
				var loader:Loader = new Loader();
				loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onPicLoaded);
				loader.load(new URLRequest(_user.picture.data.url));
			}
			
			function onPicLoaded(event:Event):void
			{
				var loaderInfo:LoaderInfo = event.target as LoaderInfo;
				
				loaderInfo.addEventListener(Event.COMPLETE, onPicLoaded);
				
				bm = loaderInfo.content as Bitmap;
				bm.width = 150;
				bm.height = 150;
				bm.y = (C.y + C.height + 5) * DeviceInfo.dpiScaleMultiplier;
				bm.x = stage.stageWidth - bm.width - 10;
				addChild(bm);
			}
			
			// -------------------------
			
			var btn2:MySprite = createBtn("Test Sharing");
			btn2.addEventListener(MouseEvent.CLICK, toShare);
			_list.add(btn2);
			
			function toShare(e:MouseEvent):void
			{
				var shareModel:ShareLink = new ShareLink();
				shareModel.contentTitle = "Cool ANEs in one basket!";
				shareModel.contentURL = "http://myflashlabs.com";
				shareModel.imageURL = "http://myflashlabs.com/myflashlab2.png";
				shareModel.contentDescription = "This is a test description message to see how sharing works!";
				FB.share(shareModel, onSharingResult);
				
				var logEventParams:Object = { };
				logEventParams[AppEventsConstants.EVENT_PARAM_DESCRIPTION] = "sharing something!"; 
				logEventParams[AppEventsConstants.EVENT_PARAM_CONTENT_TYPE] = "ShareLink"; 
				//logEventParams[ CHOOSE ANY OTHER EVENT_PARAM_* ] = "value must be a string"; 
				
				FB.logEvent(AppEventsConstants.EVENT_NAME_VIEWED_CONTENT, 1, logEventParams);
				//FB.logEvent( CHOOSE ANY OTHER EVENT_NAME_* , 1, logEventParams);
			}
			
			function onSharingResult($status:String, $msg:String):void
			{
				/*
				
				$status will be one of the following:
					FBEvent.SHARING_DONE
					FBEvent.SHARING_CANCELED
					FBEvent.SHARING_ERROR
					
				if it is "FBEvent.SHARING_ERROR", then $msg will explain the error reason
				
				*/
				
				C.log("onSharingResult = " + $status);
			}
			
			// -------------------------
			
			var btn3:MySprite = createBtn("Create a Like Btn");
			btn3.addEventListener(MouseEvent.CLICK, toLike);
			_list.add(btn3);
			
			function toLike(e:MouseEvent):void
			{
				if (like) 
				{
					like.dispose();
					like.removeEventListener(FBEvent.LIKE_BTN_CREATED, onBtnCreated);
					like.removeEventListener(FBEvent.LIKE_BTN_ERROR, onBtnError);
				}
				
				like = FB.createLikeBtn("https://www.facebook.com/myflashlab", LikeBtn.STYLE_STANDARD, LikeBtn.LINK_TYPE_PAGE, stage);
				like.name = "myLikeBtn"
				like.addEventListener(FBEvent.LIKE_BTN_CREATED, onBtnCreated);
				like.addEventListener(FBEvent.LIKE_BTN_ERROR, onBtnError);
			}
			
			function onBtnError(e:FBEvent):void
			{
				C.log("e.param = " + e.param);
			}
			
			function onBtnCreated(e:FBEvent):void
			{
				TweenMax.to(like, 0.5, {x:stage.stageWidth / 2 - like.width / 2, y:stage.stageHeight / 2 - like.height / 2});
			}
			
			// -------------------------
			
			var btn4:MySprite = createBtn("Test App Invite");
			btn4.addEventListener(MouseEvent.CLICK, toAppInvite);
			_list.add(btn4);
			
			function toAppInvite(e:MouseEvent):void
			{
				// how to generate a unique app invite link: https://developers.facebook.com/quickstarts/?platform=app-links-host
				// The suggested image size is 1,200 x 628 pixels with an image ratio 1.9:1.
				C.log("app invite can show? " + FB.appInvite("https://fb.me/477806509057618", "http://www.myflashlabs.com/wp-content/uploads/2015/11/product_adobe-air-ane-extension-facebook-595x738.jpg", onInviteResult));
			}
			
			function onInviteResult($status:String, $msg:String):void
			{
				/*
				
				$status will be one of the following:
					FBEvent.INVITE_DONE
					FBEvent.INVITE_CANCELED
					FBEvent.INVITE_ERROR
					
				if it is "FBEvent.INVITE_ERROR", then $msg will explain the error reason
				
				*/
				
				C.log("onInviteResult = " + $status);
			}
			
			// -------------------------
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
	}
	
}