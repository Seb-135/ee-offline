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

	public class LabelProperties extends PropertiesBackground
	{
		public function LabelProperties(){
			var textfld:Sprite = createTextField("Label text:")
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
				
			//// TEXT
			
			var inptf:TextField = new TextField();
			inptf.type = TextFieldType.INPUT;
			inptf.selectable = true;
			inptf.sharpness = 100;
			inptf.multiline = false
			inptf.borderColor = 0xffffff;
			inptf.backgroundColor = 0xAAAAAA;
			inptf.background = true;
			inptf.border = true;
			
			inptf.addEventListener(Event.CHANGE, function(e:Event):void{
				Global.default_label_text = inptf.text;
			});
			
			var inptff:TextFormat = new TextFormat("Tahoma", 12, 0x0, null, null, null, null, null, TextFormatAlign.LEFT);
			inptf.defaultTextFormat = inptff;
			inptf.text = Global.default_label_text;
			inptf.height = tf.height+3;
			inptf.width = 297-58;
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
			
			// COLOR
			
			var inptf2:TextField = new TextField();
			inptf2.type = TextFieldType.INPUT;
			inptf2.selectable = true;
			inptf2.sharpness = 100;
			inptf2.multiline = false
			inptf2.borderColor = 0xffffff;
			inptf2.backgroundColor = 0xAAAAAA;
			inptf2.background = true;
			inptf2.border = true;
			inptf2.maxChars = 7;
			inptf2.restrict = "0-9A-Fa-f";
			
			inptf2.addEventListener(Event.CHANGE, function(e:Event):void{
				inptf2.text = "#" + inptf2.text.substr(1,inptf2.text.length).replace("#","");
				inptf2.backgroundColor = uint("0x"+inptf2.text.substr(1,inptf2.text.length));
				inptf2.textColor = 16777215 - uint("0x"+inptf2.text.substr(1,inptf2.text.length));
				Global.default_label_hex = inptf2.text;
			});
			
			var inptff2:TextFormat = new TextFormat("Tahoma", 12, 0x0, null, null, null, null, null, TextFormatAlign.LEFT);
			inptf2.defaultTextFormat = inptff2;
			inptf2.text = Global.default_label_hex;
			inptf2.height = tf.height+3;
			inptf2.width = 58;
			inptf2.y = tf.y + tf.height + 5;
			inptf2.x = tf.x + 297-55;
			
			inptf2.backgroundColor = uint("0x"+inptf2.text.substr(1,inptf2.text.length));
			inptf2.textColor = 16777215 - uint("0x"+inptf2.text.substr(1,inptf2.text.length));
			
			inptf2.addEventListener(FocusEvent.FOCUS_IN, function(e:Event):void{
				e.preventDefault();
				e.stopImmediatePropagation();
				e.stopPropagation()
			});
			
			inptf2.addEventListener(KeyboardEvent.KEY_DOWN, function(e:KeyboardEvent):void{
				e.preventDefault();
				e.stopImmediatePropagation();
				e.stopPropagation();
			})
				
			container.addChild(inptf2);
			
			
			// WRAP
			var inptfWrap:TextField = new TextField();
			inptfWrap.type = TextFieldType.INPUT;
			inptfWrap.text = Bl.data.wrapLength;
			inptfWrap.restrict = "0-9";
			inptfWrap.maxChars = 5;
			inptfWrap.selectable = true;
			inptfWrap.sharpness = 100;
			inptfWrap.multiline = false
			inptfWrap.borderColor = 0xffffff;
			inptfWrap.backgroundColor = 0xAAAAAA;
			inptfWrap.background = true;
			inptfWrap.border = true;
			inptfWrap.x = inptf2.x;
			inptfWrap.y = 2.5;
			inptfWrap.height = tf.height+3;
			inptfWrap.width = 58;
			
			inptfWrap.addEventListener(Event.CHANGE, function(e:Event):void{
				var wrap:int = parseInt(inptfWrap.text);
				if (!isNaN(wrap)) {
					Bl.data.wrapLength = wrap;
				}
			});
			
			inptfWrap.addEventListener(FocusEvent.FOCUS_IN, function(e:Event):void{
				e.preventDefault();
				e.stopImmediatePropagation();
				e.stopPropagation()
			});
			
			inptfWrap.addEventListener(KeyboardEvent.KEY_DOWN, function(e:KeyboardEvent):void{
				e.preventDefault();
				e.stopImmediatePropagation();
				e.stopPropagation();
			});
			
			container.addChild(inptfWrap);
			
			return container
		}
	}
}