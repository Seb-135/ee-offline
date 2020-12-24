package
{
	import blitter.Bl;
	
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.filters.GlowFilter;
	import flash.geom.Point;
	import flash.text.AntiAliasType;
	import flash.text.GridFitType;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import io.player.tools.Badwords;
	
	import states.PlayState;
	
	/*
	Used by the sign block to display user defined text when a player is on a sign block
	*/
	public class TextBubble
	{
		private var colors:Array = [0xFFFFFF, 0x6699FF, 0xFF5050, 0xFFD11A];
		
		private var bmd:BitmapData;
		private var s:Sprite;
		private var latest:String = "";
		private var latest2:int = -1;
		
		private static var credits:Array = [
			"Everybody Edits Offline was created by LuciferX and Seb135 over the span of 3 months, from\n2020-09-20 to 2020-12-20\n\nLukeM created the .eelvl format.",
			"Everybody Edits was originally created as Flixel Walker, by Chris Benjaminsen, the creator of PlayerIO.\nHe later went on to work for Yahoo, before becoming a freelance game developer.",
			"The game had its ownership transferred serveral times over its 10 year lifespan. The owners, in order, were:\nBenjaminsen, Nou, NVD, and finally, Xenonetix.",
			"The staff team was even more of a merry-go-round, with many different programmers and moderators. All of their usernames are preserved as yellow and purple NPC names.",
			"When it became clear that Flash was not a sustainable platform for Everybody Edits, there was a rush to attempt to keep the game alive. The first of these was an empty promise of \"Everybody Edits Unity\".",
			"Xenonetix and his team decided to instead create a sort of 'sequel', a spiritual successor: Everybody Edits Universe.\nIn order to keep the original game, it was decided that there should be an offline copy."
		];
		
		public function TextBubble()
		{
			
		}
		
		// Note this is called on every tick which seems a bit extensive
		private function updateGraphics(text:String, type:int, bg:uint):void {
			
			var t:TextField = new TextField();
			
			t.x = 3;
			t.y = 3;
			t.multiline = true;
			t.selectable = false;
			t.wordWrap = true;
			t.width = 150;
			t.height = 500;
			t.antiAliasType = AntiAliasType.ADVANCED;
			t.gridFitType = GridFitType.SUBPIXEL;
			t.condenseWhite = true;
			
			var f:TextFormat = new TextFormat("Tahoma", 11, colors[type], false, false, false);
			f.align = TextFormatAlign.CENTER;
			t.defaultTextFormat = f;
			t.text = text;
			
			if(t.numLines == 1){
				t.width = t.textWidth + 5;
			}
			
			t.height = t.textHeight + 5
			var oh:Number = t.textHeight
			
			if(t.numLines != 1){
				while(oh == t.textHeight && t.width > 11){
					t.width--;
				}
				t.width++;
			}
			
			if (t.height > 135) t.height = 135;
			
			s = new Sprite();
			s.addChild(t);
			
			s.graphics.beginFill(bg, 1);
			s.graphics.drawRoundRect(2,2, t.width+1, t.height+1, 4, 4);
			
			// draw arrow
			s.graphics.moveTo(t.width/2+7, t.height+3);
			s.graphics.lineTo(t.width/2-1, t.height+10);
			s.graphics.lineTo(t.width/2-1, t.height+3);
			
			var gf:GlowFilter = new GlowFilter(0x0, 1, 2,2,2,3,false);
			
			s.filters = [gf];
			
			bmd = new BitmapData(s.width+4, s.height+4, true, 0x0);
			bmd.draw(s);
		}
		
		
		// Note this is called on every tick which seems a bit extensive
		public function update(text:String, type:int = 0, filterBadWords:Boolean = true, bgColor:uint = 0x000000):void {
			// for smaller time-based messages, you can just put
			// text = text.replace(/%command%/g, ["array","of","messages"]);
			// into richMessage()
			
			// a singular %credits% takes up nearly the entire sign though,
			// so it isn't repeatable
			if (text == "%credits%") {
				text = timeMessage(credits);
			}
			
			text = richMessage(text);
			
			// remove bad words
			if (latest != text || latest2 != type) {
				updateGraphics(text, type, bgColor);
			}
			
			latest=text;
			latest2 = type;
		}
		
		public static function richMessage(text:String, newline:Boolean = true):String {
			var pl:Player = (Global.base.state as PlayState).player;
			
			text = text.replace(/%coins%/g, pl.coins);
			text = text.replace(/%bcoins%/g, pl.bcoins);
			text = text.replace(/%deaths%/g, pl.deaths);
			text = text.replace(/%levelname%/g, Global.currentLevelname);
			
			text = text.replace(/%username%/g, pl.name);
			text = text.replace(/%Username%/g, pl.name.substring(0, 1).toUpperCase() + pl.name.substr(1));
			text = text.replace(/%USERNAME%/g, pl.name.toUpperCase());
			if (newline) text = text.replace(/\\n/g, "\n");
			
			text = Badwords.Filter(text);
			
			return text;
		}
		
		private function timeMessage(texts:Array):String {
			var time:Number = new Date().seconds;
			var period:Number = 60 / credits.length;
			return texts[Math.floor(time / period)];
		}
		
		public function drawPoint(target:BitmapData, point:Point):void {
			
			var width:int = bmd.rect.width;
			var height:int = bmd.rect.height;
			
			var x:int = (width/2>>0) - 12;
			var y:int = height - 2;
			
			var pos:Point = point.subtract(new Point(x, y));
			
			target.copyPixels(bmd, bmd.rect, pos);
		}
	}
}