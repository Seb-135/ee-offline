package ui.ingame.sam
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import items.ItemAuraColor;
	
	public class AuraColorButton extends MovieClip
	{
		[Embed(source="/../media/aura_buttons.png")] private static var Aura:Class;
		private static var aura:BitmapData = new Aura().bitmapData;
		
		private	var bmd:BitmapData = new BitmapData(10, 10, true, 0x0);
		
		public var color:ItemAuraColor;
		
		public function AuraColorButton(color:ItemAuraColor, callback:Function) {
			this.color = color;
			
			bmd.copyPixels(aura, new Rectangle(color.id * 10, 0, 10, 10), new Point(0, 0));
			var bm:Bitmap = new Bitmap(bmd);
			addChild(bm);
			
			if (callback == null) return;
			addEventListener(MouseEvent.MOUSE_DOWN, function(e:MouseEvent):void {
				callback(color.id);
			});			
		}
	}
}