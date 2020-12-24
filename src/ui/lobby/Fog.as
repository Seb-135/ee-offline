package ui.lobby
{
	import com.greensock.*;
	import com.greensock.easing.Linear;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import items.ItemId;
	import items.ItemManager;
	
	import states.PlayState;
	
	public class Fog extends Sprite
	{
		[Embed(source="/../media/halloween_lobby_fog.png")] protected var fogBM:Class;
		public var fog:BitmapData = new fogBM().bitmapData;
		
		private var dir:int = 0;
		private var added:Number = .1;
		
		private var blitMask:BlitMask;
		
		public function Fog()
		{
			var bm:Bitmap = new Bitmap(fog);
			
			blitMask = new BlitMask(bm, bm.x, bm.y, bm.width, bm.height, true, true, 0, false);
			addChild(blitMask);
			
			TweenMax.to(this, 60, {x:-(bm.width - 850), yoyo:true, ease:Linear.easeInOut, repeat:-1});
		}
	}
}