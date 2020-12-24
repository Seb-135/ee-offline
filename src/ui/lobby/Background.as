package ui.lobby
{
	import com.greensock.TweenMax;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.ColorTransform;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import ui.lobby.FallingItemMode;

	public class Background extends Sprite
	{
		[Embed(source="/../media/lobby/bg_new.png")] protected static var image:Class;
		protected static var img:BitmapData = new image().bitmapData;
		private var currentImage:int = 0;
		private var maxFrames:int = 0;
		
		private var particles:Array = [];
		private var mode:String = FallingItemMode.NONE;
		
		private var bm:Bitmap = new Bitmap(new BitmapData(1,1));
		
		public function Background()
		{
			this.addEventListener(Event.ENTER_FRAME, onEnterFrame);
			
			addChild(bm);
			
			maxFrames = (img.width / Config.width) - 1;
			showImage(Math.round(Math.random() * maxFrames));
			
			if (Config.lobbyEffect == FallingItemMode.SNOW) {
				particles.push(4);
				mode = FallingItemMode.SNOW;
			} else if (Config.lobbyEffect == FallingItemMode.RAIN) {
				particles.push(10);
				mode = FallingItemMode.RAIN;
			} else if (Config.lobbyEffect == FallingItemMode.CONFETTI) {
				particles.push(11,12,13);
				mode = FallingItemMode.CONFETTI;
			} else if (Config.lobbyEffect == FallingItemMode.LEAVES) {
				particles.push(14, 15);
				mode = FallingItemMode.LEAVES;
			}
		}
		
		public function showImage(index:int):void {
			var g:Graphics = this.graphics;
			var bmd:BitmapData = new BitmapData(Config.width, 500, true, 0x000000);
			bmd.copyPixels(img, new Rectangle(Config.width * index, 0, Config.width, 500), new Point(0,0));
			bmd.colorTransform(new Rectangle(0, 0, bmd.width, bmd.height), new ColorTransform(.4,.4,.4,1) );
			
			bm.bitmapData = bmd;
			bm.alpha = 0;
			
			TweenMax.to(bm, 2, {alpha:1});
			
			if (maxFrames > 0) {
				TweenMax.delayedCall(10, function():void {
					TweenMax.to(bm, .6, {alpha:0,onComplete:function():void{
						currentImage++;
						if (currentImage > maxFrames)
							currentImage = 0;
						showImage(currentImage);
					}});
				});
			}
		}
		
		public function onEnterFrame(e:Event):void {
			if (particles.length > 0) {
				var ch:int = 0;
				
				var divider:int = (Global.base.settings.particles ? 1 : 4);
				
				if(mode == FallingItemMode.SNOW)
					ch = 25;
				if(mode == FallingItemMode.RAIN)
					ch = 75;
				if(mode == FallingItemMode.CONFETTI)
					ch = 75;
				if(mode == FallingItemMode.LEAVES)
					ch = 75;
				
				if ((Math.random() * 100) < (ch / divider)) {
					addChild(new FallingItem(particles[Math.floor(Math.random() * particles.length)], Math.random()*Global.width,-10,mode));
				}
			}
		}
	}
}