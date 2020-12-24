package ui {
	import com.greensock.*;
	import com.greensock.easing.*;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	
	public class Prompt extends asset_prompt{
		private var focusBase:Boolean;
		
		public function Prompt(title:String, dtext:String = "", callback:Function = null, max:int = 140, overrideSave:Boolean = false, focusBase:Boolean = true) {
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

			tf_error.visible = false;
			
			savebtn.buttonMode = true;
			savebtn.gotoAndStop(1);
				
			headline.text = title;
			inputvar.text = dtext
			inputvar.restrict = "^,"
			inputvar.maxChars = max;
				
			if (!overrideSave){
				savebtn.addEventListener(MouseEvent.CLICK, function():void{
					callback(inputvar.text);
					close();
				});
			}
			
			closebtn.addEventListener(MouseEvent.CLICK, close);
		}
		
		public function setError(error:String) : void{
			tf_error.visible = true;
			tf_error.text = error;
		}
		
		public function close(e:Event=null):void
		{
			var pm:Prompt = this;
			TweenMax.to(pm, 0.4, {alpha:0, onComplete:function(pr:Prompt):void{
				if(stage && focusBase) stage.focus = Global.base
				pr.parent.removeChild(pr);
			}, onCompleteParams:[pm]});
			
		}
	}
	
}
