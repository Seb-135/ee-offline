package ui
{
	import com.greensock.*;
	import com.greensock.easing.*;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	
	public class ChangeDescription extends asset_changedescription
	{
		public function ChangeDescription(desc:String)
		{
			this.con = con;
			
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
			
			this.input.text = desc;
			char();
			
			savebtn.buttonMode = true;
			savebtn.gotoAndStop(1);
			
			this.input.addEventListener(Event.CHANGE, char);
			closebtn.addEventListener(MouseEvent.CLICK, close);
			savebtn.addEventListener(MouseEvent.CLICK, save);
			
		}
		
		public function char(ov:Event = null):void{
			var pm:ChangeDescription = this;
			pm.savebtn.gotoAndStop(1);
			pm.chars.text = pm.input.text.length + " of 100";
			
			if (pm.input.text.length >= 100) {
				pm.chars.textColor = 0xFF0000;
			} else if (pm.input.text.length >= 90) {
				pm.chars.textColor = 0xFF9900;
			} else if (pm.input.text.length >= 80) {
				pm.chars.textColor = 0xFFFF00;
			}  else {
				pm.chars.textColor = 0x00FF00;
			}
			
			if (pm.input.numLines > 3) {
				var lastChar:int = pm.input.getLineOffset(3) - 1;
				lastChar = pm.input.text.substring(0, lastChar + 1).search(/\S\s*$/);
				pm.input.text = pm.input.text.substring(0,  lastChar + 1);
			}
		}
		
		public function save(ov:MouseEvent):void {
			var pm:ChangeDescription = this;
			con.send("setRoomDescription", pm.input.text);
			close();
		}
		
		public function close(e:Event=null):void
		{
			var pm:ChangeDescription = this;
			TweenMax.to(pm, 0.4, {alpha:0, onComplete:function(pr:ChangeDescription):void{
				if(stage) stage.focus = Global.base
				pr.parent.removeChild(pr);
			}, onCompleteParams:[pm]});
		}
	}
}