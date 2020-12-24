package items
{
	import animations.AnimationManager;
	
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	public class ItemAura
	{
		public var shapeId:int;
		public var colorId:int;
		public var bmd:BitmapData;
		public var fullbmd:BitmapData;
		public var frames:int = 1;
		public var speed:Number = 0.2;

		private var isAnimated:Boolean = false;
		private var animationBMD:BitmapData;
		private var drawRect:Rectangle = new Rectangle();
		
		public function ItemAura(shapeId:int, colorId:int, fullbmd:BitmapData)
		{
			this.shapeId = shapeId;
			this.colorId = colorId;
			this.fullbmd = fullbmd;
			this.bmd = new BitmapData(64, 64, true, 0x0);
			this.bmd.copyPixels(fullbmd, new Rectangle(0, 0, 64, 64), new Point(0, 0));
			
			this.drawRect = this.bmd.rect;
		}
		
		public function drawTo(target:BitmapData, x:int, y:int, animationOffset:int = 0):void {
			if (isAnimated) {
				drawRect.x = animationOffset * 64;
				target.copyPixels(animationBMD, drawRect, new Point(x, y));
			} else {
				target.copyPixels(bmd, drawRect, new Point(x, y));
			}
		}
		
		public function setFramedAnimation(animBmd:BitmapData, frames:int, speed:Number):void {
			animationBMD = animBmd;
			this.frames = frames;
			this.speed = speed;
			isAnimated = true;
		}
		
		public function setRotationAnimation(frames:int, rotation:int):void {
			this.animationBMD = AnimationManager.createRotationAnimation(this.bmd, frames, rotation);
			this.frames = frames;
			isAnimated = true;
		}
	}
}
