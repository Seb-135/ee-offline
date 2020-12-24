package ui.ingame
{	
	import com.greensock.*;
	import com.greensock.easing.*;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	
	import states.PlayState;
	
	public class NotificationHUD extends assets_notification
	{
		public var ticks = 0;
		private var arrListeners:Array = [];
		
		public function NotificationHUD(head:String, body:String)
		{
			tf_head.text = head;
			tf_body.text = body;
			
			this.addEventListener(MouseEvent.MOUSE_DOWN, function(e:MouseEvent):void{
				e.preventDefault();
				e.stopImmediatePropagation()
				e.stopPropagation();
			})
			
			this.addEventListener(KeyboardEvent.KEY_DOWN, function(e:KeyboardEvent):void{
				e.preventDefault();
				e.stopImmediatePropagation()
				e.stopPropagation();
			})
				
			

		}
		
	}
	
	
}