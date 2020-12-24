package ui.chat
{
	import animations.AnimationManager;
	import flash.display.Sprite;
	import flash.display3D.Context3DMipFilter;
	import flash.filters.ColorMatrixFilter;
	import flash.geom.ColorTransform;
	import flash.text.AntiAliasType;
	import flash.text.GridFitType;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import utilities.ColorUtil;
	
	import sample.ui.components.Box;
	
	public class ChatEntry extends Sprite
	{
		private var t:TextField;
		private var text:String;
		private var preTextLength:int;
		
		public function ChatEntry(from:String, text:String, backgroundcolor:Number, usernameColor:Number, old:Boolean)
		{
			this.text = text;
			preTextLength = from == ""?0:from.length + 2;
			
			t = new TextField();
			t.multiline = true;
			t.selectable = true;
			t.wordWrap = true;
			
			t.width = 190;
			t.height = 500;
			t.sharpness = 1;
			t.condenseWhite = true;
			
			if (backgroundcolor != 0) {
				t.background = true;
				t.backgroundColor = backgroundcolor;
			}
			
			var f:TextFormat = new TextFormat("Tahoma", 9, usernameColor, false, false, false); //set username color
			f.indent = from==""?0:-8;
			f.blockIndent = 8;
			f.align = TextFormatAlign.LEFT;
			t.defaultTextFormat = f;
			
			t.text = from.toUpperCase();
			ColorUtil.colorizeUsername(t); //set gradient color
			
			t.appendText((from == ""?"":": ") + text); //add ": " and text in the end
			t.setTextFormat(new TextFormat(null, null, 0x888888), from != "" ? from.length : 0, t.text.length); //set test of the text to default color
			
			t.x = 2;
			t.y = 1;
			t.height = t.textHeight+5;
			addChild(t);
			
			this.cacheAsBitmap = true;
			
			if (old) {
				var dim:Sprite = new Sprite();
				dim.mouseEnabled = false;
				dim.graphics.beginFill(0,.25);
				dim.graphics.drawRect(0,0,width + 20,height+1);
				addChild(dim);
			}
		}
		
		public function highlightWords(regex:RegExp, format:TextFormat):void
		{
			var exc:Object;
			while (exc = regex.exec(text)) {
				t.setTextFormat(format, preTextLength + exc.index, preTextLength + exc.index + exc[0].length);
				if (Global.base.settings.coloredNames) ColorUtil.colorizeUsername(t, preTextLength + exc.index, exc[0].length);
			}
		}
		
		public override function set width(s:Number):void
		{
			t.width = s;
			t.height = 200;
			t.height = t.textHeight+5;
		}
	}
}