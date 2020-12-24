package ui
{
	import flash.display.Sprite;
	import flash.display.BitmapData;
	import flash.display.Bitmap;
	
	public class OverlayContainer extends Sprite
	{
		public function OverlayContainer()
		{
			super();
		}
		
		override public function get width():Number
		{
			var max:Number = 0;
			var num:int = numChildren;
			for (var i:int = 0; i < num; i++) 
			{
				max = Math.max(max, getChildAt(i).width);
			}
			return max;	
		}
	}
}