package states {
	import blitter.BlState;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Point;
	
	public class JoinState extends BlState {
		
		[Embed(source="/../media/loading.png")] protected static var bg:Class;
		protected var background:Bitmap = new bg();
		
		protected var p:Point = new Point();
		
		public function JoinState() {
			Global.stage.addChildAt(background, 1);
		}
		
		override public function enterFrame():void {
			background.x = (Global.stage.stageWidth - background.width) / 2 >> 0;
		}
		
		override public function draw(target:BitmapData, ox:int, oy:int):void {
			target.fillRect(target.rect, 0);
			target.copyPixels(background.bitmapData, background.bitmapData.rect, p);
		}
		
		override public function killed():void {
			if (background.parent) Global.stage.removeChild(background);
		}
		
	}
}