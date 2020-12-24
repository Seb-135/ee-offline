package ui.brickoverlays
{
	import blitter.Bl;
	
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.text.TextFieldType;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.TextEvent;
	
	import items.ItemId;
	
	import ui2.ui2minusbtn;
	import ui2.ui2plusbtn;
	import ui2.ui2properties;
	
	public class DeathProperties extends PropertiesBackground
	{
		private var inptf:TextField;
		
		public function DeathProperties(bricktype:int){
			
			var tf:TextField = new TextField();
			tf.embedFonts = true;
			tf.selectable = false;
			tf.sharpness = 100;
			tf.multiline = false;
			tf.wordWrap = false;				
			
			var tff:TextFormat = new TextFormat("system",12,0xffffff);
			tf.defaultTextFormat = tff;
			tf.width = 280;
			tf.x = -150;
			tf.y = -38;
			if(bricktype == ItemId.DEATH_DOOR){
				tf.text = "Deaths to open this door";				
			}else{
				tf.text = "Deaths to close this gate";								
			}
			tf.height = tf.textHeight
			addChild(tf)	
			
			inptf = new TextField();
			inptf.selectable = true;
			inptf.sharpness = 100;
			inptf.multiline = false
			inptf.borderColor = 0xffffff;
			inptf.backgroundColor = 0xAAAAAA;
			inptf.background = true;
			inptf.border = true;
			inptf.restrict = "0-9";
			inptf.maxChars = 3;
			inptf.type = TextFieldType.INPUT;
			
			inptf.addEventListener(Event.CHANGE, function(e:Event):void{
				var pid:int = parseInt(inptf.text);
				trace("Input: " + pid + " - " + inptf.text);
				if(!isNaN(pid) && pid >= 0 && pid <= 999){
					if (pid == 0) pid++;
					Bl.data.deathcount = pid;
				}
			});
			
			var inptff:TextFormat = new TextFormat("Arial", 12, 0x0, null, null, null, null, null, TextFormatAlign.CENTER);
			inptf.defaultTextFormat = inptff;
			inptf.text = Bl.data.deathcount;
			inptf.height = tf.height+3;
			inptf.width = 30;
			inptf.y = -38
			inptf.x = 130-35;
			
			inptf.addEventListener(FocusEvent.FOCUS_IN, function(e:Event):void{
				e.preventDefault();
				e.stopImmediatePropagation();
				e.stopPropagation()
			});
			
			inptf.addEventListener(KeyboardEvent.KEY_DOWN, function(e:KeyboardEvent):void{
				e.preventDefault();
				e.stopImmediatePropagation();
				e.stopPropagation();
			})
			
			
			var add:ui2plusbtn = new ui2plusbtn();
			add.y = -29
			add.x = 130+10;
			addChild(add);
			
			
			add.addEventListener(MouseEvent.MOUSE_DOWN, incrementValue)
			
			var sub:ui2minusbtn = new ui2minusbtn();
			sub.y = -29
			sub.x = 130-34-16;
			addChild(sub);
			
			sub.addEventListener(MouseEvent.MOUSE_DOWN, decrementValue)
			
			
			addChild(inptf);
			
			//			this.bg.height = 50;
			setSize(325,50);
		}
		
		public override function incrementValue(amount:int = 1):void {
			if(Bl.data.deathcount<999) Bl.data.deathcount ++
					inptf.text = Bl.data.deathcount;
		}
			
		public override function decrementValue(amount:int = 1):void {
			if(Bl.data.deathcount>1) Bl.data.deathcount --
					inptf.text = Bl.data.deathcount;
		}
	}
}