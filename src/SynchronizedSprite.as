package 
{
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	public class SynchronizedSprite extends SynchronizedObject
	{
		protected var rect:Rectangle
		protected var bmd:BitmapData
		protected var size:int;
		protected var frames:int
		
		public function SynchronizedSprite(bmd:BitmapData,w:int = 0,x:int = 0)	{
			this.bmd = bmd;
			if(w==0)w=bmd.height;
			
			rect = new Rectangle(0,0, w,bmd.height);
			size = w;
			
			width = w;
			height = size;

			frames = bmd.width / size;
		}
		
		public function set frame(f:int):void{
			rect.x = f*size;
		}
		
		public function get frame():int{
			return rect.x/size;
		}
		
		public function setRectY(oy:int) : void{
			rect.y = oy;
		}
		
		public function hitTest(ox:int, oy:int):Boolean{
			return ox >= x && oy >= y && ox <= x + size && oy <= y + size;  
		}
		
		public override function draw(target:BitmapData, ox:int, oy:int):void{
			target.copyPixels(bmd, rect, new Point(
				(x+ox),
				(y+oy)
			));
		}
	}
}