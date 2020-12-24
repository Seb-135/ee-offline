package blitter
{
	import animations.AnimationManager;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.display.StageQuality;
	import flash.geom.Point;
	import flash.text.AntiAliasType;
	import flash.text.Font;
	import flash.text.GridFitType;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import utilities.ColorUtil;

	public class BlText extends BlObject
	{		
		[Embed(source="/../media/nokiafc22.ttf", fontFamily="system", embedAsCFF="false", mimeType="application/x-font-truetype")]  
		private var systemFont:Class;
			
		[Embed(source="/../media/visitor.ttf", fontFamily="visitor", embedAsCFF="false", mimeType="application/x-font-truetype")]  
		private var visitorFont:Class;
		
		protected var _text:String = "";
		public var bmd:BitmapData;
		protected var tf:TextField
		protected var tff:TextFormat
		
		public function BlText(size:int, width:Number, color:Number = 0xffffff, align:String = "left", font:String = "system", smoothing:Boolean = false)
		{
			tf = new TextField();
		    tf.embedFonts = true;
			tf.selectable = false;
			tf.sharpness = 100;
			if(smoothing)tf.antiAliasType = AntiAliasType.ADVANCED
			tf.multiline = true;
			tf.wordWrap = true;
			tf.width = width; 
			
			tff = new TextFormat(font,size,color,null,null,null,null,null,align);
			
			tf.defaultTextFormat = tff;
			tf.text = "qi´"
			bmd = new BitmapData(width,tf.textHeight+5, true, 0x0);
			tf.text = "";
			
			super();
		}
	
		public function set text(s:String):void{
			if (_text == s) return;
			this._text = s;
			if (s) tf.text = s;
			tf.setTextFormat(tff);
			ColorUtil.colorizeUsername(tf);
			redraw();
		}
		
		private function redraw():void {
			Bl.stage.quality = StageQuality.LOW;
			bmd = new BitmapData(tf.width, tf.textHeight + 2, true, 0x0);
			bmd.draw(tf);
			Bl.stage.quality = StageQuality.BEST;
		}
		
		public function set filters(f:Array):void{
			tf.filters = f
			text = this._text
		}
		
		public function get text():String{
			return this._text
		}
		
		public function get textfield():TextField{
			return this.tf;
		}
		
		public override function draw(target:BitmapData, ox:int, oy:int) : void{
			target.copyPixels(bmd, bmd.rect, new Point(ox+x, oy+y));
		}
		public function clone():BitmapData{
			return bmd.clone()
		}
	}
}