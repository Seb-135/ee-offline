package items 
{
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	public class ItemNpc 
	{
		public var id:int;
		public var payvaultid:String;
		public var bmd:BitmapData;
		public var frames:int;
		public var rate:Number;
		public var bubbleOffset:Number;
		
		public function ItemNpc(id:int, payvault:String, bmd:BitmapData, frames:int, rate:Number, bubbleOffset:Number) 
		{
			this.id = id;
			this.payvaultid = payvault;
			this.bmd = bmd;
			this.frames = frames;
			this.rate = rate;
			this.bubbleOffset = bubbleOffset;
		}
		
		public function drawTo(target:BitmapData, point:Point, animationOffset:int = 0, inWorld:Boolean = false):void {
			//target.copyPixels(bmd, new Rectangle(animationOffset*16, 0, 16, 16), point);
			target.copyPixels(bmd, new Rectangle(animationOffset*16, 0, 16, 32), new Point(point.x, point.y - 16));
		}
	}
}