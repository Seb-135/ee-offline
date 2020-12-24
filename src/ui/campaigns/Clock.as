package ui.campaigns {
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	public class Clock extends Bitmap {
		
		[Embed(source = "/../media/campaigns/clocks.png")] private static var Clocks:Class;
		public static var clocksBMD:BitmapData = new Clocks().bitmapData;
		
		public static const size:int = 15;
		protected static const maxTier:int = (clocksBMD.width / size) - 1;
		protected static const tempRect:Rectangle = new Rectangle(0, 0, size, size);
		protected static const tempPoint:Point = new Point();
		
		protected var bmd:BitmapData = new BitmapData(size, size, true, 0);
		protected var _rank:int = -1;
		
		public function Clock(rank:int) {
			super(bmd);
			this.rank = rank;
		}
		
		public function get rank():int { return _rank; }
		public function set rank(n:int):void {
			n = n < 0 ? 0 : n > maxTier ? maxTier : n;
			if (n != _rank) {
				tempRect.x = n * size;
				bmd.copyPixels(clocksBMD, tempRect, tempPoint);
				_rank = n;
			}
		}
		
	}
}