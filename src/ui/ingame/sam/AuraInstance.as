package ui.ingame.sam
{
	import blitter.BlText;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	
	import items.ItemAuraShape;

	public class AuraInstance extends Sprite
	{
		private var _item:ItemAuraShape
		private var ss:UI2;
		private var bm:Bitmap;
		
		public function AuraInstance(item:ItemAuraShape, ss:UI2)
		{
			_item = item;
			this.ss = ss;
			
			bm = new Bitmap(item.auras[0].bmd);
			var sprite:Sprite = new Sprite();
			sprite.addChild(bm);
			addChild(sprite);
		}
		
		public function changeColor(color:int):void
		{
			bm.bitmapData = item.auras[item.generated ? color : 0].bmd;
		}
		
		public function get item():ItemAuraShape {
			return _item;
		}
	}
}