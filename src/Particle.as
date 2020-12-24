package
{
	import blitter.BlSprite;
	
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import items.ItemId;
	import items.ItemManager;
	
	import states.PlayState;
	
	public class Particle extends SynchronizedSprite
	{
		public var life:int = 0;
		public var maxlife:int = 0;
		public var dir:Number;
		public var cx:Number;
		public var cy:Number;
		public var rd:Boolean;
		public var world:World;
		private var bm:BitmapData = new BitmapData(5, 5);
		
		public function Particle(w:World, frame:int, x:int, y:int, speedX:Number, speedY:Number, modX:Number, modY:Number, dir:int, lifespan:int, dored:Boolean = false)
		{
			this.world = w;
			
			ItemManager.sprParticles.frame = frame;
			ItemManager.sprParticles.drawPoint(bm, new Point(0, 0));
			
			super(bm, 5, 5);
			
			this.maxlife = lifespan;
			
			this.x = x;
			this.y = y;
			this.cx = x;
			this.cy = y;
			this.modifierX = modX;
			this.modifierY = modY;
			this.rd = dored;
			
			this.speedX = speedX;
			this.speedY = speedY;
			this.mox = 0.5;
			this.moy = 0.5;
			this.dir = dir;
		}
		
		public override function tick():void {
			super.tick();
			life++;
			
			var Angle:Number = dir * Math.PI / 180;
			cx =cx + speedX * Math.cos(Angle);
			cy =cy + speedY * Math.sin(Angle);
			this.x = cx; 
			this.y = cy;
			
			speedX-=modifierX;
			speedY-=modifierY;
			
			if ((speedX < 0 && !rd))
				speedX = 0;
			
			if ((speedY < 0 && !rd))
				speedY = 0;
			
			if (life >= maxlife) {
				var sta:PlayState = Global.base.state as PlayState;
				sta.world.particlecontainer.remove(this);
			}
		}
	}
}