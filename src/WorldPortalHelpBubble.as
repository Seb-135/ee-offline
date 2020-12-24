package
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.GradientType;
	import flash.display.SpreadMethod;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.filters.GlowFilter;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.utils.Timer;
	/*
	The diologue displayed when a player stands on a world portal
	*/
	public class WorldPortalHelpBubble
	{
		[Embed(source="/../media/worldportal_help.png")] protected var helpimage:Class;
		private var BMDhelpimage:BitmapData = new helpimage().bitmapData;
		
		private var worldname_timer:Timer;
		
		private var bmd:BitmapData;
		private var cachedIDs:Object;
		
		private var id:String = "";
		private var text:String = "";
		private var target:int = 0;
		private var isGod:Boolean = false;
		
		public function WorldPortalHelpBubble()
		{
			
			//cachedIDs = new Object();
			//cachedIDs[""] = "No such world";
			
			updateGraphic();
		}
		
		public function updateGraphic():void {
			var s:Sprite = new Sprite();
			
			// Text
			var t:TextField = new TextField()
			
			t.y = BMDhelpimage.height + 10 + 4;
			t.multiline = true;
			t.selectable = false;
			t.wordWrap = false;
			t.width = 75;
			t.height = 50;
			t.antiAliasType = AntiAliasType.ADVANCED;
			t.autoSize = TextFieldAutoSize.CENTER;
			
			var f:TextFormat = new TextFormat("Tahoma", 9, 0xFFFFFF)
			f.align = TextFormatAlign.CENTER;
			t.defaultTextFormat = f;
			
			if (text != "") t.appendText(text + '\n');
			if (isGod) {
				if (target == 0) t.appendText("Default spawn\n");
				else t.appendText("Spawn " + target + '\n');
			}
			t.appendText("Press " + KeyBinding.risky.key.print() + " to Enter");
			
			var total_width:Number = Math.max(t.width + 6, 90);
			var total_height:Number = Math.max(t.y + t.height, 30);
			t.x = ((total_width - t.width) / 2) >> 0;
			
			s.addChild(t)
			
			// Background
			var bg:Sprite = new Sprite();
			
			var fillType:String = GradientType.LINEAR;
			var colors:Array = [0x0, 0x0];
			var alphas:Array = [.5, .3];
			var ratios:Array = [0x00, 0xFF];
			var matr:Matrix = new Matrix();
			matr.createGradientBox(20, total_height + 3, Math.PI / 2, 0, 0);
			var spreadMethod:String = SpreadMethod.PAD;
			bg.graphics.beginGradientFill(fillType, colors, alphas, ratios, matr, spreadMethod);  
			
			bg.graphics.lineStyle(0, 0xFFFFFF);
			bg.graphics.moveTo(0, 0);
			bg.graphics.lineTo(total_width, 0)
			bg.graphics.lineTo(total_width, total_height + 3)
			bg.graphics.lineTo(total_width / 2 + 3, total_height + 3)
			bg.graphics.lineTo(total_width / 2, total_height + 10)
			bg.graphics.lineTo(total_width / 2 - 3, total_height + 3)
			bg.graphics.lineTo(0, total_height+3)
			bg.graphics.lineTo(0, 0)
			bg.graphics.lineStyle(0, 0x0);
			
			s.addChildAt(bg, 0);
			
			// Shadow
			var shadow:Sprite = new Sprite();
			
			shadow.x = 1;
			
			var copybmd:BitmapData = new BitmapData(bg.width, bg.height, true, 0x0);
			copybmd.draw(bg);
			shadow.addChild(new Bitmap(copybmd));
			
			var gf:GlowFilter = new GlowFilter(0x0, 0.5, 4, 4, 3, 3, false, true);
			shadow.filters = [gf];
			
			s.addChildAt(shadow, 0);
			
			// Draw
			bmd = new BitmapData(s.width+4, s.height+4, true, 0x0);
			bmd.draw(s);
			var img_m:Matrix = new Matrix();
			img_m.translate((total_width - BMDhelpimage.width) / 2, 10);
			bmd.draw(BMDhelpimage, img_m);
		}
		
		public function update(wp:WorldPortal, isGod:Boolean):void {
			var requiresUpdate:Boolean = false;
			
			if (wp.id != id) {
				id = wp.id;
				var name:String = "";
				
				var index:int = parseInt(id);
				if (Global.isValidWorldIndex(index))
					name = Global.worldNames[index];
				else /*if (index == Global.worldIndex)*/ name = Global.currentLevelname;
				//else name = "No such world";
				
				if (name != null) {
					text = name;
					requiresUpdate = true;
				}
			}
			
			if ((!Global.isValidWorldIndex(parseInt(id)) || parseInt(id) == Global.worldIndex) && name != Global.currentLevelname) {
				if (Global.currentLevelname != null) {
					text = Global.currentLevelname;
					requiresUpdate = true;
				}
			}
			
			if (wp.target != target) {
				target = wp.target;
				if (isGod) requiresUpdate = true;
			}
			
			if (this.isGod != isGod) {
				this.isGod = isGod;
				requiresUpdate = true;
			}
			
			if (requiresUpdate) updateGraphic();
		}
		
		public function drawPoint(target:BitmapData, point:Point, frame:int = 0):void {
			var width:int = bmd.rect.width;
			var height:int = bmd.rect.height;
			
			var x:int = (width/2>>0) - 12;
			var y:int = height - 2;
			
			var pos:Point = point.subtract(new Point(x, y));
			
			target.copyPixels(bmd, bmd.rect, pos);
		}
	}
}