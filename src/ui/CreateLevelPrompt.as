package ui {
	import com.greensock.*;
	import com.greensock.easing.*;
	import fl.managers.FocusManager;
	import flash.events.TextEvent;
	import flash.text.TextField;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	
	import flash.text.TextFieldType;
	
	public class CreateLevelPrompt extends CreateLevel{
		
		private var callbackRee:Function = null;
		
		public function CreateLevelPrompt(callback:Function = null) {
			x = (Config.width - 358) / 2;
			
			roomname.text = "Untitled World";
			roomname.type = TextFieldType.INPUT; 
			roomname.maxChars = 20; 
			
			worldWidth.text = "100";
			worldWidth.type = TextFieldType.INPUT; 
			worldWidth.maxChars = 3;
			worldWidth.restrict = "0-9"; 
			worldWidth.addEventListener(FocusEvent.FOCUS_OUT, restrictWidth); 
			
			worldHeight.text = "100";
			worldHeight.type = TextFieldType.INPUT; 
			worldHeight.maxChars = 3;
			worldHeight.restrict = "0-9"; 
			worldHeight.addEventListener(FocusEvent.FOCUS_OUT, restrictHeight); 
			
			gravity.text = "100";
			gravity.type = TextFieldType.INPUT; 
			gravity.maxChars = 3;
			gravity.restrict = "0-9";
			gravity.addEventListener(FocusEvent.FOCUS_OUT, restrictGravity); 
			gravity.visible = false;
			bgGravity.visible = false;
			titleGravity.visible = false;
			if (Global.cookie.data.easterEggs && Global.cookie.data.easterEggs.grav) {
				gravity.visible = true;
				bgGravity.visible = true;
				titleGravity.visible = true;
			}
			
			callbackRee = callback;
			
			closebtn.addEventListener(MouseEvent.CLICK, close);
			start.addEventListener(MouseEvent.CLICK, call);
		}
		
		public function close(e:Event=null):void
		{
			var pm:CreateLevelPrompt = this;
			TweenMax.to(pm, 0.4, {alpha:0, onComplete:function(pr:CreateLevelPrompt):void{
				//if(stage) stage.focus = Global.base
				if (pr.parent) pr.parent.removeChild(pr);
			}, onCompleteParams:[pm]});
			
			//if (call != null) call(textfield.text);
		}
		
		private function call(e:Event=null):void
		{
			if(parseInt(worldWidth.text) >= 3 && parseInt(worldHeight.text) >= 3 && parseInt(gravity.text) >= 10) {
				this.close();
				if (callbackRee != null) callbackRee(roomname.text, parseInt(worldWidth.text), parseInt(worldHeight.text), parseFloat(gravity.text)/100);
			}
		}
		
		private function restrictWidth(e:FocusEvent = null):void {
			var w:int = parseInt(worldWidth.text);
			if (w <= 3) worldWidth.text = "3";
			else if (w >= 636) worldWidth.text = "636";
		}
		
		private function restrictHeight(e:FocusEvent = null):void {
			var h:int = parseInt(worldHeight.text);
			if (h <= 3) worldHeight.text = "3";
			else if (h >= 460) worldHeight.text = "460";
		}
		
		private function restrictGravity(e:FocusEvent = null):void {
			var g:Number = parseInt(gravity.text);
			if (g < 10) gravity.text = "10";
			else if (g >= 300) gravity.text = "300";
		}
	}
	
}
