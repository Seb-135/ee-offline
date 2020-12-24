package ui.ingame.sam 
{
	import blitter.BlText;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.GradientType;
	import flash.display.SpreadMethod;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import flash.text.AntiAliasType;
	import flash.text.GridFitType;
	import flash.text.TextFormat;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	public class SoundSlider extends Sprite
	{
		[Embed(source="/../media/soundSlider/states.png")] private static var SoundState:Class;
		private static var soundStateBMD:BitmapData = new SoundState().bitmapData;
		
		[Embed(source="/../media/soundSlider/bar.png")] private static var SoundBar:Class;
		private static var soundBarBMD:BitmapData = new SoundBar().bitmapData;
		
		[Embed(source="/../media/soundSlider/grip.png")] private static var SoundGrip:Class;
		private static var soundGripBMD:BitmapData = new SoundGrip().bitmapData;
		
		public var WIDTH:int = 153;
		public var HEIGHT:int = 29;
		
		private var matrix:Matrix;
		
		private var stateImage:Bitmap;
		private var gripImage:Bitmap;
		private var barImage:Bitmap;
		
		private var imageBMD:BitmapData;
		
		public function SoundSlider()
		{
			gripImage = new Bitmap(soundGripBMD);
			gripImage.y = Math.round((HEIGHT - gripImage.height) / 2) -1;
			gripImage.x = 137;			
			
			barImage = new Bitmap(soundBarBMD);
			barImage.y = Math.round((HEIGHT - barImage.height) / 2) -1;
			barImage.x = 38;
			
			addChild(barImage);
			addChild(gripImage);
			
			addEventListener(MouseEvent.MOUSE_MOVE, function (e:MouseEvent):void {
				var x:int = e.localX;
				if (x > 137) x = 137;
				else if (x < 37) x = 37;
				
				if (e.buttonDown) {
					redraw(x);
				}
			});
			
			addEventListener(MouseEvent.MOUSE_UP, function (e:MouseEvent):void {
				var x:int = e.localX;
				if (x > 137) x = 137;
				else if (x < 37) x = 37;
				
				redraw(x, true);
			});
			
			this.buttonMode = true;
			this.useHandCursor = true;
			this.mouseEnabled = true;
			
			matrix = new Matrix();
			matrix.createGradientBox(WIDTH, HEIGHT, (Math.PI / 2));
			
			graphics.clear();
			graphics.lineStyle(1, 0x7B7B7B);
			graphics.beginGradientFill(GradientType.LINEAR, [0x313131, 0x202020], [1, 1], [0, 255], matrix, SpreadMethod.PAD);
			graphics.drawRect(0, -1, WIDTH, HEIGHT);
			graphics.endFill();
			
			redraw(Global.base.settings.volume + 37);
		}
		
		private function getStateFromVolume(save:Boolean):Bitmap {
			var v:int = gripImage.x - 37;
			if (v > 100) v = 100;
			else if (v < 0) v = 0;			
			var state:int = v == 0 ? 0 : v > 0 && v < 50 ? 1 : 2;
			Global.base.settings.volume = v;
			if (save) Global.base.settings.save();
			
			var newImage:BitmapData = new BitmapData(soundStateBMD.width / 3, soundStateBMD.height, true, 0x0);
			newImage.copyPixels(soundStateBMD, new Rectangle((soundStateBMD.width / 3) * state, 0, newImage.width, newImage.height), new Point());
			
			return new Bitmap(newImage);
		}
		
		private function redraw(x:int, save:Boolean = false) : void{
			gripImage.x = x;
			
			if (stateImage != null)
				removeChild(stateImage);
			
			stateImage = getStateFromVolume(save);
			stateImage.y = Math.round((HEIGHT - stateImage.height) / 2) -1;
			stateImage.x = 11;
			
			addChild(stateImage);
		}
	}
}