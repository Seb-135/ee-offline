package blitter
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;

	public class Bl	{
		private static var last:Number = 0;
		//private static var offset:Number = 0;
		private static var keys:Object = {};
		public static var justPressedKeys:Object = {};
		public static var justReleasedKeys:Object = {};
		private static var mouseDown:Boolean = false;
		private static var mouseJustPressed:Boolean = false;
		private static var middleMouseJustPressed:Boolean = false;
		private static var middleMouseDown:Boolean = false;
		public static var stage:Stage;
		// overlayContainer should be used instead of adding anything directly to the stage. 
		public static var overlayContainer:Sprite;
		public static var screenContainer:Bitmap;
		
		public static var data:Object = {};
		public static var width:Number;
		public static var height:Number;
		
		public static function init(s:Stage,w:Number, h:Number):void{
			width = w;
			height = h;
			
			stage = s;
			stage.addEventListener(KeyboardEvent.KEY_DOWN, handleKeyDown);
			stage.addEventListener(KeyboardEvent.KEY_UP, handleKeyUp);
			stage.addEventListener(MouseEvent.MOUSE_DOWN, handleMouseDown);
			stage.addEventListener(MouseEvent.MOUSE_UP, handleMouseUp);
			stage.addEventListener(MouseEvent.MIDDLE_MOUSE_DOWN, handleMiddleMouseDown);
			stage.addEventListener(MouseEvent.MIDDLE_MOUSE_UP, handleMiddleMouseUp);
			
			last = new Date().time;
		}
		
		public static function get time():Number{
			//Meh, limited persision to prevent the dreaded 100% cpu
			return last;
		}
		
		public static function set time(t:Number):void{
			//Meh, limited persision to prevent the dreaded 100% cpu
			last = t;
		}
		
		public static function get mouseX():Number{
			return (screenContainer||stage).mouseX;
		}
		
		public static function get mouseY():Number{
			return (screenContainer||stage).mouseY;
		}
		
		public static function get isMouseDown():Boolean{
			return mouseDown;
		}
		
		public static function get isMouseJustPressed():Boolean{
			return mouseJustPressed;
		}
		
		public static function get isMiddleMouseDown():Boolean{
			return middleMouseDown;
		}
		
		public static function get isMiddleMouseJustPressed():Boolean{
			return middleMouseJustPressed;
		}
		
		public static function isKeyDown(k:int):Boolean{
			return keys[k] ? true : false;
		}
		
		public static function isKeyJustPressed(k:int):Boolean{
			return justPressedKeys[k] ? true : false;
		}
		
		public static function isKeyJustReleased(k:int):Boolean{
			return justReleasedKeys[k] ? true : false;
		}
		
		public static function exitFrame():void{
			resetJustPressed();
		}
		
		public static function resetJustPressed():void{
			justPressedKeys = {};
			justReleasedKeys = {};
			mouseJustPressed = false;
			middleMouseJustPressed = false;
		}

		private static var shiftState:Boolean = false;
		public static function get shiftKey():Boolean{
			return shiftState;	
		}

		protected static function handleMouseDown(e:MouseEvent):void{
			shiftState = e.shiftKey;
			
			mouseDown = true;
			mouseJustPressed = true;
		}
		
		protected static function handleMouseUp(e:MouseEvent):void{
			shiftState = e.shiftKey;
			mouseDown = false;
		}
		
		protected static function handleMiddleMouseDown(e:MouseEvent):void{
			middleMouseJustPressed = true;
			middleMouseDown = true;
		}
		
		protected static function handleMiddleMouseUp(e:MouseEvent):void{
			middleMouseDown = false;
		}
		
		protected static function handleKeyDown(e:KeyboardEvent):void{
			shiftState = e.shiftKey;
			if (!keys[e.keyCode] && !Global.inGameSettings) {
				justPressedKeys[e.keyCode] = true;
				keys[e.keyCode] = true;
			}
		}

		protected static function handleKeyUp(e:KeyboardEvent):void{
			shiftState = e.shiftKey;
			if (keys[e.keyCode] && !Global.inGameSettings) {
				justReleasedKeys[e.keyCode] = true;
			}
			delete keys[e.keyCode];
		}
		
		public static function forceKeyUp(keyCode:int):void 
		{
			if (keys[keyCode]) {
				justReleasedKeys[keyCode] = true;
			}
			delete keys[keyCode];
		}
	}
}