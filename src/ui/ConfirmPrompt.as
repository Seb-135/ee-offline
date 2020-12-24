package ui {
	import com.greensock.*;
	import com.greensock.easing.*;
	import flash.display.SimpleButton;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	
	public class ConfirmPrompt extends asset_confirmprompt {
		
		private var focusBase:Boolean;
		
		public var btn_yes:SimpleButton;
		public var btn_no:SimpleButton;
		
		public var onAnyClose:Function;
		
		public function ConfirmPrompt(text:String, danger:Boolean, dangerName:String = null, focusBase:Boolean = true, closeButton:Boolean = true) {
			x = -157 + (Config.width - 491) / 2;
			
			btn_yes1.visible = btn_no1.visible = !danger;
			btn_yes2.visible = btn_no2.visible = danger;
			
			btn_yes2.field.mouseEnabled = false;
			if (danger && dangerName) btn_yes2.field.text = dangerName;
			
			btn_yes = danger ? btn_yes2.btn : btn_yes1;
			btn_no = danger ? btn_no2 : btn_no1;
			
			closebtn.visible = closeButton;
			
			this.focusBase = focusBase;
			
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
			
			textbox.text = text;	
			
			btn_no.addEventListener(MouseEvent.CLICK, close);
			closebtn.addEventListener(MouseEvent.CLICK, close);
		}
		
		public function close(e:Event=null):void
		{
			var pm:ConfirmPrompt = this;
			TweenMax.to(pm, 0.4, {alpha:0, onComplete:function(pr:ConfirmPrompt):void{
				if (pr != null && pr.parent != null) {
					if (stage && focusBase) stage.focus = stage; //Global.base;
					pr.parent.removeChild(pr);
					if (onAnyClose != null) onAnyClose();
				}
			}, onCompleteParams:[pm]});
		}
	}
	
}
