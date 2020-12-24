package ui
{
	import blitter.BlText;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	import flash.text.TextFieldAutoSize;
	
	public class HoverLabel extends Sprite
	{
		public var w:int = 0;
		
		public var textCount:BlText;
		
		public function HoverLabel(size:int = 120)
		{
			super();
			mouseEnabled = false;
			mouseChildren = false;
			
			textCount = new BlText(14,size, 0xFFFFFF, "left", "visitor");
		}
		
		public function draw(text:String):void
		{
			while(numChildren > 0){
				removeChildAt(0);
			}
			
			textCount.textfield.autoSize = TextFieldAutoSize.LEFT;
			textCount.text = text;	
			
			var bm:Bitmap = new Bitmap(textCount.clone());
			bm.x = 4;
			bm.y = 3;
			addChild(bm);
			
			graphics.clear();
			graphics.lineStyle(1,0x7B7B7B,1);
			graphics.beginFill(0x323231, 0.85);
			graphics.drawRect(0,0,(textCount.textfield.textWidth) + 10, textCount.textfield.height + 8);
			w = textCount.textfield.textWidth + 10;
		}
	}
}