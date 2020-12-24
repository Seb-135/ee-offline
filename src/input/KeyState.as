package input
{
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.KeyboardEvent;

	public class KeyState
	{
		
		private static var stage:Stage;
		private static var key:Object;
		
		public static function activate(s:Stage):void
		{
			stage = s;
			key = {};
			stage.addEventListener(KeyboardEvent.KEY_DOWN,handleKey,false,0,true);	
			stage.addEventListener(KeyboardEvent.KEY_UP,handleKey,false,0,true);	
			stage.addEventListener(Event.DEACTIVATE, handleDeactivate,false,0,true);
		}
		
		protected static function handleDeactivate(event:Event):void
		{
			key = {};	
		}
		
		public static function deactivate():void
		{
			try{
				stage.removeEventListener(KeyboardEvent.KEY_DOWN,handleKey);	
				stage.removeEventListener(KeyboardEvent.KEY_UP,handleKey);
			}catch(e:Error){};
		}
		
		private static function handleKey(event:KeyboardEvent):void
		{
			key[event.keyCode] = event.type == KeyboardEvent.KEY_DOWN; 	
		}
		
		public static function isKeyDown(keyCode:uint):Boolean
		{
			return (key[keyCode] != null && key[keyCode]);
		}
	
		
	}
}