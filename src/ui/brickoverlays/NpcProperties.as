package ui.brickoverlays 
{
	import blitter.Bl;
	import flash.display.Bitmap;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import items.ItemId;
	
	import flash.display.Sprite;
	import flash.display.PixelSnapping;
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
	
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import items.ItemManager;
	public class NpcProperties extends PropertiesBackground 
	{
		[Embed(source="/../media/arrows.png")] private static var Arrows:Class;
		private static var arrowsBMD:BitmapData = new Arrows().bitmapData;
		
		private var smiley:Bitmap;
		private var ui:UI2;
		private var hotbar:Boolean;
		
		public function NpcProperties(blockId:int, ui:UI2, hotbar:Boolean) 
		{
			if (!ItemId.isNPC(blockId)) throw new Error("Tried creating properties for non-NPC block");
			
			Bl.data.brick = blockId;
			this.ui = ui;
			this.hotbar = hotbar;
			
			createChatField("Message 1:", "npc_mes1", -256, -142, 0); //-142 - upper left corner
			createChatField("Message 2:", "npc_mes2", -256, -100, 1); //-142 + 42(height + offset)
			createChatField("Message 3:", "npc_mes3", -256, -57, 2);  //-100 + 42(height + offset) + 1 just for sake of it.
			createNameText("Name your NPC!", 69, -140);
			createArrow(false);
			createArrow(true);
			switchSmiley();
			createNameField(Bl.data.npc_name, 69, -43, 3);
			
			setSize(525,145);
		}
		
		public override function incrementValue(amount:int = 1):void {
			updateSelection(Npc.getNextNpcID(Bl.data.brick, true));
			switchSmiley();
		}
		
		public override function decrementValue(amount:int = 1):void {
			updateSelection(Npc.getNextNpcID(Bl.data.brick, false));
			switchSmiley();
		}
		
		private function switchSmiley():void {
			if (!ItemId.isNPC(Bl.data.brick)) return;
			if (smiley && smiley.parent == this) this.removeChild(smiley);
			
			var smileyBMD:BitmapData = ItemManager.getBrickById(Bl.data.brick).bmd;
			
			var matrix:Matrix = new Matrix();
			matrix.scale(64 / smileyBMD.width, 64 / smileyBMD.height);
			
			var newSmiley:BitmapData = new BitmapData(64, 64, true, 0x0);
			newSmiley.draw(smileyBMD, matrix);
			
			smiley = new Bitmap(newSmiley);
			smiley.pixelSnapping = PixelSnapping.NEVER;
			smiley.smoothing = false;
			smiley.y = -113;
			smiley.x = 122;
			
			this.addChild(smiley);
		}
		
		private function updateSelection(brick:int):void {
			if (hotbar) {
				Bl.data.brick = brick;
				ui.favoriteBricks.setDefault(ui.favoriteBricks.selectedBlock, ItemManager.getBrickById(brick));
			}
			ui.hideAllProperties();
			ui.setSelected(brick);
		}
		
		private function createArrow(increase:Boolean):void {
			var arrowBMD:BitmapData = new BitmapData(20, 64, true, 0x0);
			arrowBMD.copyPixels(arrowsBMD, new Rectangle(increase ? 20 : 0, 0, 20, 64), new Point());
			
			var arrow:Sprite = new Sprite();
			arrow.addChild(new Bitmap(arrowBMD));
			arrow.y = -109;
			arrow.x = increase ? 186 : 102;
			arrow.addEventListener(MouseEvent.CLICK, function():void {
				increase ? incrementValue() : decrementValue();
			});
			addChild(arrow);
		}
		
		private function createNameField(name:String, x:Number = -150, y:Number = 2.5, tabIndex:int = -1):void {
			var inptff:TextFormat = new TextFormat("Tahoma", 12, 0x0);
			inptff.align = TextFormatAlign.CENTER;
			var inptf:TextField = new TextField();
			inptf.type = TextFieldType.INPUT;
			inptf.selectable = true;
			inptf.sharpness = 100;
			inptf.multiline = false
			inptf.borderColor = 0xffffff;
			inptf.backgroundColor = 0xAAAAAA;
			inptf.background = true;
			inptf.border = true;
			inptf.maxChars = 20;
			inptf.defaultTextFormat = inptff;
			inptf.text = name;
			inptf.height = 23;
			inptf.width = 175;
			inptf.x = x;
			inptf.y = y;
			
			inptf.tabIndex = tabIndex;
			
			inptf.addEventListener(Event.CHANGE, function(e:Event):void{
				//couldn't make RegExp /^[0-9a-z.-]*$/ work here. 
				var allowedChars:String = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789.-'~%";
				var newName:String = "";
				for (var i:int = 0; i < inptf.text.length; i++) {
					if (allowedChars.indexOf(inptf.text.charAt(i)) != -1) newName+= inptf.text.charAt(i);
				}
				Bl.data.npc_name = inptf.text = newName;
			});
			
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
			
			addChild(inptf);
		}
		
		private function createNameText(text:String, x:Number, y:Number):void {
			var tf:TextField = new TextField();
			tf.embedFonts = true;
			tf.selectable = false;
			tf.sharpness = 100;
			tf.multiline = false;
			tf.wordWrap = false;
			
			var tff:TextFormat = new TextFormat("system", 16, 0xffffff);
			tff.align = TextFormatAlign.CENTER;
			tf.defaultTextFormat = tff;
			tf.width = 174;
			tf.x = x;
			tf.y = y;
			tf.text = text;
			tf.height = tf.textHeight;
			addChild(tf);
		}
		
		private function createNpcSmiley(blockId:int):Bitmap {
			var smileyBMD:BitmapData = ItemManager.getBrickById(blockId).bmd;
			
			var matrix:Matrix = new Matrix();
			matrix.scale(64 / smileyBMD.width, 64 / smileyBMD.height);
			
			var newSmiley:BitmapData = new BitmapData(64, 64, true, 0x0);
			newSmiley.draw(smileyBMD, matrix);
			
			var smiley:Bitmap = new Bitmap(newSmiley);
			smiley.pixelSnapping = PixelSnapping.NEVER;
			smiley.smoothing = false;
			smiley.y = -113;
			smiley.x = 122;
			return smiley;
		}
		
		private function createChatField(name:String, id:String, x:Number = -150, y:Number = 2.5, tabIndex:int = 0):void {
			
			var tff:TextFormat = new TextFormat("system",12,0xffffff);
			var tf:TextField = new TextField(); //title
			tf.embedFonts = true;
			tf.selectable = false;
			tf.sharpness = 100;
			tf.multiline = false;
			tf.wordWrap = false;
			tf.defaultTextFormat = tff;
			tf.width = 280;
			tf.x = x;
			tf.y = y;
			tf.text = name;
			tf.height = tf.textHeight;
			addChild(tf);
			
			var inptff:TextFormat = new TextFormat("Tahoma", 12, 0x0, null, null, null, null, null, TextFormatAlign.LEFT);
			var inptf:TextField = new TextField(); //box
			inptf.type = TextFieldType.INPUT;
			inptf.selectable = true;
			inptf.sharpness = 100;
			inptf.multiline = false
			inptf.borderColor = 0xffffff;
			inptf.backgroundColor = 0xAAAAAA;
			inptf.background = true;
			inptf.border = true;
			inptf.maxChars = 80;
			inptf.defaultTextFormat = inptff;
			inptf.text = Bl.data[id];
			inptf.height = tf.height+3;
			inptf.width = 297;
			inptf.y = tf.y + tf.height + 5;
			inptf.x = tf.x;
			
			inptf.tabIndex = tabIndex;
			
			inptf.addEventListener(Event.CHANGE, function(e:Event):void{
				Bl.data[id] = inptf.text;
			});
			
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
			
			addChild(inptf);
		}
	}

}