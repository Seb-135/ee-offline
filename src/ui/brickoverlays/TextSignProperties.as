package ui.brickoverlays
{
	import blitter.Bl;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TextEvent;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.KeyboardEvent;
	import items.ItemId;
	
	import ui2.ui2minusbtn;
	import ui2.ui2plusbtn;
	import ui2.ui2properties;
	/*
	The UI element for entering text for the text sign block
	*/
	public class TextSignProperties extends PropertiesBackground
	{
		public function TextSignProperties()
		{
			var textfld:Sprite = createTextField("Sign text:")
			textfld.y = -39-25
			addChild(textfld);
			setSize(325,70);
		}
		
		private function createTextField(name:String):Sprite{
			
			var container:Sprite = new Sprite();
			
			var tf:TextField = new TextField();
			tf.embedFonts = true;
			tf.selectable = false;
			tf.sharpness = 100;
			tf.multiline = false;
			tf.wordWrap = false;
			
			
			var tff:TextFormat = new TextFormat("system", 12, 0xffffff);
			tf.defaultTextFormat = tff;
			tf.width = 280;
			tf.x = -150;
			tf.y = 2.5;
			tf.text = name;
			tf.height = tf.textHeight;
			container.addChild(tf);
			
			var inptf:TextField = new TextField();
			inptf.type = TextFieldType.INPUT;
			inptf.selectable = true;
			inptf.sharpness = 100;
			inptf.multiline = false
			inptf.borderColor = 0xffffff;
			inptf.backgroundColor = 0xAAAAAA;
			inptf.background = true;
			inptf.border = true;
			inptf.maxChars = 140;
			
			inptf.addEventListener(Event.CHANGE, function(e:Event):void{
				Global.text_sign_text = inptf.text;
			});
			
			var inptff:TextFormat = new TextFormat("Tahoma", 12, 0x0, null, null, null, null, null, TextFormatAlign.LEFT);
			inptf.defaultTextFormat = inptff;
			inptf.text = Global.text_sign_text;
			inptf.height = tf.height+3;
			inptf.width = 297;
			inptf.y = tf.y + tf.height + 5;
			inptf.x = tf.x;
			
			inptf.addEventListener(FocusEvent.FOCUS_IN, function(e:Event):void{
				e.preventDefault();
				e.stopImmediatePropagation();
				e.stopPropagation()
			});
			
			inptf.addEventListener(KeyboardEvent.KEY_DOWN, function(e:KeyboardEvent):void{
				e.preventDefault();
				e.stopImmediatePropagation();
				e.stopPropagation();
			});
			
			inptf.addEventListener(KeyboardEvent.KEY_UP, function(e:KeyboardEvent):void {
				e.preventDefault();
				e.stopImmediatePropagation();
				e.stopPropagation();
			});
			
			container.addChild(inptf);
			
			return container
		}
	}
}