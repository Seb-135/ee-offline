package ui
{
	import ui2.ui2youbtn;
	import flash.display.MovieClip;
	import flash.display.BitmapData;
	import flash.display.Bitmap;
	import flash.geom.Rectangle;
	import flash.geom.Point;
	
	public class YouButton extends ui2youbtn
	{
		private	var bmd:BitmapData = new BitmapData(26,26,true,0x0)
		private var smileybmd:BitmapData
		public function YouButton(smileybmd:BitmapData) {
			this.smileybmd = smileybmd;
			var bm:Bitmap = new Bitmap(bmd);
			addChild(bm);
			bm.x = 2;
			bm.y = 1;
			setSelectedSmiley(0)
		}
		public function setSelectedSmiley(selected:int):void{
			bmd.copyPixels(smileybmd, new Rectangle(selected*26,0,26,24), new Point(0,0));
		}
	}
}