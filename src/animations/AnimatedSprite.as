package animations
{
	import blitter.BlContainer;
	
	import flash.display.BitmapData;
	import flash.geom.Point;
	
	import states.PlayState;
	
	public class AnimatedSprite extends SynchronizedSprite
	{
		public var angle:int = 0;
		public var speedx:Number = 0;
		public var speedy:Number = 0;
		public var radius:Number = 0;
		public var lifetime:Number = 0;
		public var life:Number = 0;
		public var cont:BlContainer;
		public var d:int = 0;
		
		public function AnimatedSprite(bmd:BitmapData, w:int)
		{
			super(bmd,w);
		}
		
		public function set scale(s:Number):void
		{
			frame = Math.round(frames*(1-s));
		}

		public function get scale():Number
		{
			return 1-(frame/frames);
		}
		
		public override function draw(target:BitmapData, ox:int, oy:int):void{
			
			target.copyPixels(bmd, rect, new Point(
				(x+ox),
				(y+oy)
			));
			if (lifetime>0){upd();}
		}
		
		public function upd():void{
			if (life>lifetime){
				cont.remove(this);
			}

			this.x += speedx* Math.cos(angle);
			this.y += speedy* Math.sin(angle);
			life++;
		}
	}
}