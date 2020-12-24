package ui {
	import com.greensock.*;
	import com.greensock.easing.*;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	
	import flash.text.TextFieldType;
	
	public class CopyPrompt extends assets_copyprompt{
		
		private var call:Function = null;
		
		public function CopyPrompt(title:String, dtext:String, extraText:String, callback:Function = null, maxChars:int = 0, restrict:String = null) {
			
			//this.addEventListener(MouseEvent.MOUSE_DOWN, function(e:MouseEvent):void{
				//e.preventDefault();
				//e.stopImmediatePropagation()
				//e.stopPropagation();
			//})
			
			//this.addEventListener(KeyboardEvent.KEY_DOWN, function(e:KeyboardEvent):void{
				//e.preventDefault();
				//e.stopImmediatePropagation()
				//e.stopPropagation();
			//})
			
			headline.text = title;
			textfield.text = dtext;
			textfield.type = TextFieldType.INPUT; 
			textfield.maxChars = maxChars; 
			textfield.restrict = restrict; 
			this.extraText.text = extraText;
			
			call = callback;
			
			closebtn.addEventListener(MouseEvent.CLICK, close);
		}
		
		public function close(e:Event=null):void
		{
			var pm:CopyPrompt = this;
			TweenMax.to(pm, 0.4, {alpha:0, onComplete:function(pr:CopyPrompt):void{
				//if(stage) stage.focus = Global.base
				if (pr.parent) pr.parent.removeChild(pr);
			}, onCompleteParams:[pm]});
			
			if (call != null) call(textfield.text);
		}
	}
	
}
