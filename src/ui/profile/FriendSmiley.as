package ui.profile
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.PixelSnapping;
	import flash.geom.Matrix;
	
	public class FriendSmiley extends SynchronizedSprite
	{
		public function FriendSmiley(bmd:BitmapData)
		{
			super(bmd);
			
			size = 26;
			width = 26;
			height = 26;			
			frames = bmd.width / size;
		}
		
		public function getAsBitmap(scale:uint = 1):Bitmap
		{
			var bitmapData:BitmapData = new BitmapData(width, height);
			draw(bitmapData, 0, 0);	
			
			var scaled:BitmapData = new BitmapData(bitmapData.width * scale, bitmapData.height * scale, true, 0x00000000);
			var mtx:Matrix = new Matrix();
			mtx.scale(scale, scale);
			scaled.draw(bitmapData, mtx);
			
			var bitmap:Bitmap = new Bitmap(scaled);
			bitmap.smoothing = false;
			bitmap.pixelSnapping = PixelSnapping.NEVER;
			
			return bitmap;
		}
	}
}