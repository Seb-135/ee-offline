package ui.ingame
{
	import blitter.BlSprite;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.GradientType;
	import flash.display.SpreadMethod;
	import flash.display.Sprite;
	import flash.filters.GlowFilter;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	public class ResetPopup/* extends BlSprite*/
	{
		[Embed(source="/../media/reset_popup.png")] private var ResetPopupImage:Class;
		private var resetPopupBMD:BitmapData = new ResetPopupImage().bitmapData;
		
		private var bmd:BitmapData;
		
		public function ResetPopup() {
			updateGraphic();
		}
		
		public function updateGraphic():void
		{
			var t:TextField = new TextField();
			t.y = resetPopupBMD.height + 14;
			t.multiline = true;
			t.selectable = false;
			t.wordWrap = false;
			t.width = 75;
			t.height = 50;
			t.antiAliasType = AntiAliasType.ADVANCED;
			t.autoSize = TextFieldAutoSize.CENTER;
			
			var tf:TextFormat = new TextFormat("Tahoma", 9, 0xFFFFFF);
			tf.align = TextFormatAlign.CENTER;
			t.defaultTextFormat = tf;
			
			t.text = ("Press " + KeyBinding.risky.key.print() + " to restart world.");
			
			var s:Sprite = new Sprite();
			
			var bg:Sprite = new Sprite();
			
			var total_width:Number = Math.max(t.width+6,90);
			var total_height:Number = Math.max(t.y + t.height,30);
			
			var fillType:String = GradientType.LINEAR;
			var colors:Array = [0x0, 0x0];
			var alphas:Array = [.5, .3];
			var ratios:Array = [0x00, 0xFF];
			var matr:Matrix = new Matrix();
			matr.createGradientBox(20, total_height+3, Math.PI/2, 0, 0);
			
			var spreadMethod:String = SpreadMethod.PAD;
			bg.graphics.beginGradientFill(fillType, colors, alphas, ratios, matr, spreadMethod);  
			
			bg.graphics.lineStyle(0,0xFFFFFF);
			bg.graphics.moveTo(0, 0);
			bg.graphics.lineTo(total_width, 0)
			bg.graphics.lineTo(total_width, total_height+3)
			bg.graphics.lineTo(total_width/2+3, total_height+3)
			bg.graphics.lineTo(total_width/2, total_height+10)
			bg.graphics.lineTo(total_width/2-3, total_height+3)
			bg.graphics.lineTo(0, total_height+3)
			bg.graphics.lineTo(0, 0)
			bg.graphics.lineStyle(0,0x0);
			
			var shadow:Sprite = new Sprite();
			var copybmd:BitmapData = new BitmapData(bg.width,bg.height,true,0x0);
			copybmd.draw(bg);
			shadow.x = 1;
			shadow.addChild(new Bitmap(copybmd));
			var gf:GlowFilter = new GlowFilter(0x0, .5,4,4,3,3,false,true);
			shadow.filters = [gf];
			
			t.x = ((total_width-t.width)/2)>>0;
			s.addChild(t)
			s.addChildAt(bg,0);
			s.addChildAt(shadow,0);
			
			
			/*var*/ bmd/*:BitmapData*/  = new BitmapData(s.width+4, s.height+4, true, 0x0);
			bmd.draw(s);
			
			var img_m:Matrix = new Matrix();
			img_m.translate((total_width-resetPopupBMD.width)/2,10);
			bmd.draw(resetPopupBMD,img_m);
			
			//super(bmd,0,0,bmd.width,bmd.height,1);
			
			//rect = bmd.rect
			//frames = 1
			//
			//width = rect.width;
			//height = rect.height;
			//
			//x = -(width/2>>0)+8;
			//y = -height + 3;
		}
		
		//public override function drawPoint(target:BitmapData, point:Point, frame:int = 0):void
		//{
			//draw(target, point.x, point.y);
		//}
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