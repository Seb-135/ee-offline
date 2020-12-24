package ui.ingame
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import utilities.MathUtil;
	
	public class DeathStar extends Sprite
	{
		public var max_dist:Number = 32;
		public var brake:Number = .7;
		public var speed:Number;
		public var speed_x:Number;
		public var speed_y:Number;
		
		public function DeathStar(bmd:BitmapData)
		{
			super();
			var star:Bitmap = new Bitmap(bmd);
			star.x -= (star.width/2)>>0;
			star.y -= (star.height/2)>>0;
			addChild(star);
		}
		
		public function tick(num:int = 1):void
		{
			for (var i:int = 0; i < num; i++) 
			{
				x += speed_x*speed;
				y += speed_y * speed;
				var dist:Number = Math.sqrt(Math.pow(x,2) + Math.pow(y,2));
				speed *= brake;
				if (!parent) continue;
				
				if(!MathUtil.inRange(0, 0, x, y, max_dist) || alpha <= 0 || speed <=.05){
					parent.removeChild(this);
				}							
			}
			
		}
	}
}