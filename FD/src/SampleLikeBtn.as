package 
{
	import com.myflashlab.air.extensions.dependency.OverrideAir;
	import com.myflashlab.air.extensions.facebook.FB;
	import com.myflashlab.air.extensions.facebook.FBEvent;
	import com.myflashlab.air.extensions.facebook.LikeBtn;
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
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.ui.Keyboard;
	import flash.ui.Multitouch;
	import flash.ui.MultitouchInputMode;
	import flash.utils.setTimeout;
	
	/**
	 * 
	 * @author Hadi Tavakoli - 5/3/2015 1:57 PM
	 */
	public class SampleLikeBtn extends Sprite 
	{
		private const BTN_WIDTH:Number = 150;
		private const BTN_HEIGHT:Number = 60;
		private const BTN_SPACE:Number = 2;
		private var _txt:TextField;
		private var _body:Sprite;
		private var _list:List;
		private var _numRows:int = 1;
		
		public function SampleLikeBtn():void 
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
			_txt.htmlText = "<font face='Arimo' color='#333333' size='20'><b>Facebook extension V" + FB.VERSION + " for adobe air</b></font>";
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
			NativeApplication.nativeApplication.removeEventListener(InvokeEvent.INVOKE, onInvoke);
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
				C.y = _txt.y + _txt.height + 0;
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
			trace($ane+"("+$class+") "+$msg);
		}
		
		private function init():void
		{
			// remove this line in production build or pass null as the delegate
			OverrideAir.enableDebugger(myDebuggerDelegate);
			
			FB.getInstance("00000000000");
			trace("hash key = ", FB.hashKey);
			
			var btn1:MySprite = createBtn("create LIKE btn");
			btn1.addEventListener(MouseEvent.CLICK, likeBtn);
			_list.add(btn1);
			
			function likeBtn(e:MouseEvent):void
			{
				var like1:LikeBtn = FB.createLikeBtn("https://www.facebook.com/myflashlab", LikeBtn.STYLE_STANDARD, LikeBtn.LINK_TYPE_PAGE, stage);
				like1.name = "like" + Math.random();
				like1.addEventListener(FBEvent.LIKE_BTN_CREATED, onBtnCreated);
				like1.addEventListener(FBEvent.LIKE_BTN_ERROR, onBtnError);
				like1.addEventListener(FBEvent.LIKE_BTN_UPDATED, onBtnUpdated);
				like1.addEventListener(FBEvent.LIKE_BTN_CLICKED, onBtnClicked);
			}
			
			// ----------------------------
			
			var btn2:MySprite = createBtn("remove all btn");
			btn2.addEventListener(MouseEvent.CLICK, removeLikeBtns);
			_list.add(btn2);
			
			function removeLikeBtns(e:MouseEvent):void
			{
				FB.removeLikeBtns();
			}
			
			// ----------------------------
			
			var btn3:MySprite = createBtn("toggle visibility (first btn)");
			btn3.addEventListener(MouseEvent.CLICK, toggleVisibilityLikeBtns);
			_list.add(btn3);
			
			function toggleVisibilityLikeBtns(e:MouseEvent):void
			{
				_btn.setVisibility(!_btn.isVisible);
			}
		}
		
		private var _btn:LikeBtn;
		private function onBtnCreated(e:FBEvent):void
		{
			var btn:LikeBtn = e.target as LikeBtn;
			_btn = btn;
			
			btn.x = Math.random() * 600;
			btn.y = Math.random() * 600;
			
			C.log("onBtnCreated, btn.name = " + btn.name);
			C.log("width = " + btn.width);
			C.log("height = " + btn.height);
			
			setTimeout(btn.update, 5000, "http://www.myflashlabs.com", LikeBtn.STYLE_STANDARD, LikeBtn.LINK_TYPE_OPEN_GRAPH);
			//btn.update("http://www.myflashlabs.com", LikeBtn.STYLE_STANDARD, LikeBtn.LINK_TYPE_OPEN_GRAPH);
		}
		
		private function onBtnError(e:FBEvent):void
		{
			var btn:LikeBtn = e.target as LikeBtn;
			C.log("e.param = " + e.param);
		}
		
		private function onBtnUpdated(e:FBEvent):void
		{
			var btn:LikeBtn = e.target as LikeBtn;
			C.log("onBtnUpdated");
			C.log("width = " + btn.width);
			C.log("height = " + btn.height);
			
			/*btn.removeEventListener(FBEvent.LIKE_BTN_CREATED, onBtnCreated);
			btn.removeEventListener(FBEvent.LIKE_BTN_ERROR, onBtnError);
			btn.removeEventListener(FBEvent.LIKE_BTN_UPDATED, onBtnUpdated);
			btn.dispose();
			btn = null;
			C.log("btn.dispose();");*/
		}
		
		private function onBtnClicked(e:FBEvent):void
		{
			var btn:LikeBtn = e.target as LikeBtn;
			C.log(" clicked: " + btn.name);
			trace(" clicked: " + btn.name);
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