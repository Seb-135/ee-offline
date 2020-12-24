package blitter
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	public class BlSprite extends BlObject
	{
		public var rect:Rectangle;
		public var bmd:BitmapData;
		private var shadowRect:Rectangle;
		private var shadowBmd:BitmapData;
		protected var frames:int;
		protected var offset:int;
		protected var bmdAlpha:BitmapData // Used as alpha channel source when drawing transparent
		protected var shadow:Boolean;
		private var sprImage:BitmapData;
		private var sprImageShadow:BitmapData;
		
		public function BlSprite( srcBmd:BitmapData, indexx:int , indexy:int, width:int, height:int, frames:int, shadow:Boolean = false)
		{
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
		
		public function updateFrame():void {
			if (shadow) {
				this.sprImageShadow = this.getImage(true);
			}
			this.sprImage = this.getImage(false);
		}
		
		public static function createFromBitmapData( bmd:BitmapData ):BlSprite
		{
			return new BlSprite( bmd , 0 , 0, bmd.width, bmd.height, 1 );
		}
		
		public function set frame(f:int):void{
			if (f != frame) {
				rect.x = (f+offset)*width;
				shadowRect.x = f * (width + 2);
				updateFrame();
			}
		}
		
		public function get frame():int{
			return (rect.x/width)-offset;
		}
		
		public function get totalFrames():int {
			return this.frames;
		}
		
		public function hitTest(ox:int, oy:int):Boolean{
			
			return ox >= x && oy >= y && ox <= x + width && oy <= y + height;  
			
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
			var w:int = width;
			var h:int = height;
			
			if (shadow) {
				w += 2;
				h += 2;
			}
			
			var bm:BitmapData = new BitmapData(w, h, true, 0x0);
			bm.copyPixels(shadow ? shadowBmd : bmd, shadow ? shadowRect : rect, new Point(0, 0));
			return bm;
		}
		
		private static var dp:Point = new Point();
		private var currentImage:BitmapData;
		
		public var RotateDeg:int = 0;		
		public override function draw(target:BitmapData, ox:int, oy:int):void{
			dp.x = ox + x
			dp.y = oy + y;
			currentImage = shadow ? sprImageShadow : sprImage;
			
			var rotatedImage:BitmapData = Player.rotateBitmapData(currentImage, RotateDeg);
			target.copyPixels(rotatedImage, rotatedImage.rect, dp);
		}
		
		public function drawPoint(target:BitmapData, point:Point, frame:int = 0):void{
			currentImage = shadow ? sprImageShadow : sprImage;
			
			var rotatedImage:BitmapData = Player.rotateBitmapData(currentImage, RotateDeg);
			target.copyPixels(rotatedImage, rotatedImage.rect, point);
		}
	}
}