package
{
	import flash.display.BitmapData;
	import flash.display.GradientType;
	import flash.display.SpreadMethod;
	import flash.display.Sprite;
	import flash.filters.ColorMatrixFilter;
	import flash.filters.GlowFilter;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.text.AntiAliasType;
	import flash.text.GridFitType;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import blitter.BlSprite;
	
	public class ChatBubble extends BlSprite
	{
		
		public var time:Date = new Date()
		public var text:String = "";
		public function ChatBubble(name:String, text:String)
		{
			this.text = text;
			var t:TextField = new TextField()
			
			t.x = 2
			t.y = 2
			t.multiline = true
			t.selectable = false
			t.wordWrap = true
			t.width = 110
			t.height = 500
			t.antiAliasType = AntiAliasType.ADVANCED
			t.gridFitType = GridFitType.SUBPIXEL
			t.condenseWhite = true
			
			//t.border = true
			//t.borderColor = 0xffffff
			
			var f:TextFormat = new TextFormat("Tahoma", 11, 0x0, false, false, false)
			f.align = TextFormatAlign.CENTER
			t.defaultTextFormat = f;
			t.text = text
			
			
			if(t.numLines == 1){
				t.width = t.textWidth + 5;
			}
			
			t.height = t.textHeight + 5
			var oh:Number = t.textHeight
				
			if(t.numLines != 1){
				while(oh == t.textHeight){
					t.width--
				}
				t.width++
			}

			var s:Sprite = new Sprite;
			s.addChild(t);
			
			var fillType:String = GradientType.LINEAR;
			var colors:Array = [0xD2D2D2, 0xffffff];
			var alphas:Array = [.9, .9];
			var ratios:Array = [0x00, 0xFF];
			var matr:Matrix = new Matrix();
			matr.createGradientBox(20, t.height+3, Math.PI/2, 0, 0);
			
			var spreadMethod:String = SpreadMethod.PAD;
			s.graphics.beginGradientFill(fillType, colors, alphas, ratios, matr, spreadMethod);  
			s.graphics.drawRoundRect(0,0, t.width+4, t.height+3, 4,4)
			
			s.graphics.moveTo(t.width/2, t.height+3)
			s.graphics.lineTo(t.width/2, t.height+10)
			s.graphics.lineTo(t.width/2+7, t.height+3)
			
			var gf:GlowFilter = new GlowFilter(0x0, 1, 2,2,2,3,false)
			
			s.filters = [gf]
			
			var bmd:BitmapData  = new BitmapData(s.width+4, s.height+4, true, 0x0);
			var mm:Matrix = new Matrix()
			mm.translate(2,2)
			bmd.draw(s,mm)
			
			super(bmd,0,0,bmd.width,bmd.height,1);
			
			rect = bmd.rect
			frames = 1
			
			width = rect.width;
			height = rect.height;
			
			x = -(width/2>>0) + 19
			y = -height + 7
			
		}
		
		public function age(time:Number):void{
			if(time > 14000){
				
				bmd.applyFilter(bmd, bmd.rect, new Point(0,0), new ColorMatrixFilter([
					1, 0, 0, 0, 0,
					0, 1, 0, 0, 0,
					0, 0, 1, 0, 0,
					0, 0, 0,.9, 0
				
				]));
			}
		}
		
		public override function draw(target:BitmapData, ox:int, oy:int):void{
			target.copyPixels(bmd, rect, new Point(
				(ox+x),
				(oy+y)
			));
		}
		
	}
}