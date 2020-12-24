package blitter
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	public class BlockSprite extends BlSprite
	{
		private var shadowRect:Rectangle;
		private var shadowBmd:BitmapData;
		private var sprImage:BitmapData;
		private var sprImageShadow:BitmapData;
		
		public function BlockSprite( srcBmd:BitmapData, indexx:int , indexy:int, width:int, height:int, frames:int, shadow:Boolean = false)
		{
			super(srcBmd, indexx, indexy, width, height, frames, shadow)
			//this.bmd = new BitmapData(width*frames,height);
			this.bmd = srcBmd;
			rect = new Rectangle(0,0,width,height);
			shadowRect = new Rectangle(0, 0, width + 2, height + 2);
			this.frames = frames;
			this.offset = indexx;
			this.shadow = shadow;
			
			this.width = width;
			this.height = height;
			
			if (shadow) {
				shadowBmd = drawWithShadow(bmd);
			}
			
			updateFrame();
			this.frame=0;
		}
		
		
		
		
		private function drawWithShadow(bmd:BitmapData):BitmapData {
			var newBmd:BitmapData = new BitmapData(frames * (width + 2), (height + 2), true, 0x0);
			for (var i:int = 0; i < frames; i++) {
				var blockBmd:BitmapData = drawWithShadowSingle(bmd, i);
				newBmd.copyPixels(blockBmd, blockBmd.rect, new Point(i * (width + 2), 0));
			}
			return newBmd;
		}
		
		private function drawWithShadowSingle(bmd:BitmapData, blockOffset:int):BitmapData {
			// Get single block from source
			var copyBmd:BitmapData = new BitmapData(width, height, true, 0x0);
			copyBmd.copyPixels(bmd, new Rectangle((offset + blockOffset) * width, 0, width, height), new Point(0, 0));
			
			// Matrix that moves the shadow 2 pixels to the right and down
			var m:Matrix = new Matrix();
			m.translate(2,2);
			
			var newBmd:BitmapData = new BitmapData(width + 2, height + 2, true, 0x0);
			
			// Draw shadow
			newBmd.draw(copyBmd, m, new ColorTransform(0,0,0,.30,0,0,0,0));
			// Draw original bitmap
			newBmd.draw(copyBmd);
			
			return newBmd;
		}
		
		private function getImage(shadow:Boolean):BitmapData {
			return shadow?shadowBmd:bmd;
		}
		
		private static var dp:Point = new Point();
		private var currentImage:BitmapData;
		private var currentRect:Rectangle;
		public override function draw(target:BitmapData, ox:int, oy:int):void{
			dp.x = ox + x
			dp.y = oy + y;
			currentImage = shadow ? sprImageShadow : sprImage;
			target.copyPixels(currentImage, currentImage.rect, dp);
		}
		
		public override function drawPoint(target:BitmapData, point:Point, frame:int = 0):void{
			currentImage = getImage(shadow);
			currentRect = shadow ? new Rectangle(frame * 18, 0, 18, 18) : new Rectangle((offset + frame) * 16, 0, 16, 16);
			target.copyPixels(currentImage, currentRect, point);
		}
	}
}