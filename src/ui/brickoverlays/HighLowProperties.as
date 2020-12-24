package ui.brickoverlays
{
	import blitter.Bl;
	
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import ui2.ui2minusbtn;
	import ui2.ui2plusbtn;

	public class HighLowProperties extends PropertiesBackground
	{
		private var inptf:TextField;
		
		public function HighLowProperties()
		{
			var tf:TextField = new TextField();
			tf.embedFonts = true;
			tf.selectable = false;
			tf.sharpness = 100;
			tf.multiline = false;
			tf.wordWrap = false;
			
			var tff:TextFormat = new TextFormat("system", 12, 0xFFFFFF);
			tf.defaultTextFormat = tff;
			tf.width = 280;
			tf.x = -150;
			tf.y = -38;
			tf.text = "Effect:";
			tf.height = tf.textHeight;
			addChild(tf);
			
			inptf = new TextField();
			inptf.selectable = true;
			inptf.sharpness = 100;
			inptf.multiline = true;
			inptf.borderColor = 0xFFFFFF;
			inptf.backgroundColor = 0xAAAAAA;
			inptf.background = true;
			inptf.border = true;
			inptf.restrict "0-9";
			inptf.maxChars = 2;
			inptf.type = TextFieldType.INPUT;
			
			var inptff:TextFormat = new TextFormat("Arial", 12, 0x0, null, null, null, null, null, TextFormatAlign.CENTER);
			inptf.defaultTextFormat = inptff;
			updateText();
			inptf.height = tf.height + 3;
			inptf.width = 75;
			inptf.y = -38;
			inptf.x = 50;
			
			inptf.addEventListener(FocusEvent.FOCUS_IN, function(e:Event):void {
				e.preventDefault();
				e.stopImmediatePropagation();
				e.stopPropagation();
			});
			
			inptf.addEventListener(KeyboardEvent.KEY_DOWN, function(e:KeyboardEvent):void {
				e.preventDefault();
				e.stopImmediatePropagation();
				e.stopPropagation();
			});
			
			var add:ui2plusbtn = new ui2plusbtn();
			add.x = 140;
			add.y = -29;
			addChild(add);
			
			add.addEventListener(MouseEvent.MOUSE_DOWN, incrementValue);
			
			var sub:ui2minusbtn = new ui2minusbtn();
			sub.y = -29
			sub.x = inptf.x - sub.width - 3;
			addChild(sub);
			
			sub.addEventListener(MouseEvent.MOUSE_DOWN, decrementValue);
			
			addChild(inptf);
			
			setSize(325,50);
		}
		
		private function updateText():void {
			inptf.text = ["Normal", "High", "Low"][Bl.data.mode];
		}
		
		public override function incrementValue(amount:int = 1):void {
			if (Bl.data.mode == 2) {
				Bl.data.mode = 0;
				updateText();
			} else if (Bl.data.mode == 0) {
				Bl.data.mode = 1;
				updateText();
			}
		}
			
		public override function decrementValue(amount:int = 1):void {
			if (Bl.data.mode == 1) {
				Bl.data.mode = 0;
				updateText();
			} else if (Bl.data.mode == 0) {
				Bl.data.mode = 2;
				updateText();
			}
		}
	}
}