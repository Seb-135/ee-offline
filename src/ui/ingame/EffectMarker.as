package ui.ingame
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import items.ItemLayer;
	import items.ItemManager;
	
	import items.ItemBrick;
	import items.ItemId;

	public class EffectMarker extends Sprite
	{
		public static const HEIGHT:int = 24;
		public static const WIDTH_WITH_TIMER:int = 30;
		public static const WIDTH_WITHOUT_TIMER:int = 24;
		
		private static const TIMEBAR_MARGIN:int = 3;
		private static const TIMEBAR_WIDTH:int = 4;
		private static const TIMEBAR_HEIGHT:int = HEIGHT - (2 * TIMEBAR_MARGIN);
		
		private var WIDTH:int;
		
		private var _id:int;
		private var timer:Sprite;
		private var startDate:Date;
		private var duration:Number;
		
		public function EffectMarker(bmd:BitmapData, id:int, timeLeft:Number = 0, duration:Number = 0)
		{
			super();
			
			_id = id;
			this.duration = duration;
			startDate = new Date();
			startDate.time -= (duration - timeLeft) * 1000;
			
			var effectGraphics:Bitmap;
			
			// Should probably redo this at some point
			// for gravity effect
			if (id == ItemId.EFFECT_GRAVITY) {
				var gravityGraphics:BitmapData = new BitmapData(16, 16);
				ItemManager.sprGravityEffect.drawPoint(gravityGraphics, new Point(0, 0), timeLeft);
				
				effectGraphics = new Bitmap(gravityGraphics.clone());
			}
			// for jump effect
			else if (id == ItemId.EFFECT_JUMP) {
				var jumpGraphics:BitmapData = new BitmapData(16, 16);
				ItemManager.sprEffect.drawPoint(jumpGraphics, new Point(0, 0), [7, 0, 22][timeLeft]);
				
				effectGraphics = new Bitmap(jumpGraphics.clone());
			}
			else if (id == ItemId.EFFECT_RUN) {
				var speedGraphics:BitmapData = new BitmapData(16, 16);
				ItemManager.sprEffect.drawPoint(speedGraphics, new Point(0, 0), [9, 2, 25][timeLeft])
				
				effectGraphics = new Bitmap(speedGraphics.clone());
			}
			// otherwise
			else effectGraphics = new Bitmap(bmd.clone())
			
			effectGraphics.x = effectGraphics.y = ((HEIGHT - effectGraphics.width) / 2) >> 0;
			addChild(effectGraphics);
			
			WIDTH = duration == 0
				? WIDTH_WITHOUT_TIMER
				: WIDTH_WITH_TIMER;
			
			graphics.beginFill(0xCCCCCC, 0.75);
			graphics.drawRect(0, 0, WIDTH, HEIGHT);
			graphics.beginFill(0x0, 0.75);
			graphics.drawRect(1, 1, WIDTH - 2, HEIGHT - 2);
			
			if (duration > 0) {
				timer = new Sprite();
				addChild(timer);
			}
		}
		
		public function get id():int
		{
			return _id;
		}
		
		public function get timeLeft():Number
		{
			return new Date().time - (startDate.time + (duration * 1000));
		}
		
		public function get progress():Number
		{
			if (duration == 0) return 0;
			return Math.max(0, Math.min((new Date().time - startDate.time) / (duration * 1000), 1));
		}
		
		public function refresh():Boolean
		{
			if (duration == 0) return false;
			var prog:Number = progress;
			setProgress(prog);
			if (prog == 1 && (id == ItemId.EFFECT_CURSE || id == ItemId.EFFECT_ZOMBIE || 
			id == ItemId.LAVA || id == ItemId.EFFECT_POISON)) {
				Global.playState.player.killPlayer();
				return true;
			}
			return false;
		}
		
		private function setProgress(amount:Number):void
		{
			timer.x = WIDTH - TIMEBAR_WIDTH - TIMEBAR_MARGIN;
			timer.y = TIMEBAR_MARGIN;
			
			timer.graphics.clear();
			timer.graphics.beginFill(0xCCCCCC, 1);
			timer.graphics.drawRect(0, 0, TIMEBAR_WIDTH, TIMEBAR_HEIGHT);
			timer.graphics.beginFill(0x00FF00, 1);
			timer.graphics.drawRect(1, 1, TIMEBAR_WIDTH - 2, TIMEBAR_HEIGHT - 2);
			timer.graphics.beginFill(0x0, 1);
			timer.graphics.drawRect(1, 1, TIMEBAR_WIDTH - 2, TIMEBAR_HEIGHT - 2 - (TIMEBAR_HEIGHT - 2) * (1 - amount));
		}
	}
}