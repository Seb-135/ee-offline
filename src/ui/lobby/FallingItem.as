package ui.lobby
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import items.ItemId;
	import items.ItemManager;
	
	import states.PlayState;

	public class FallingItem extends Sprite
	{
		private var rotSpeed:Number = (Math.random() * .45) + .1;
		private var fallSpeed:Number = (Math.random() * .80) + .2;
		
		private var particleMode:String = FallingItemMode.NONE;
		
		public function FallingItem(i:int, x:int, y:int, mode:String)
		{
			this.addEventListener(Event.ENTER_FRAME, onEnterFrame);
			
			this.particleMode = mode;
			
			this.x = x;
			this.y = y;
			
			this.scaleX = this.scaleY = (Math.random() * 2) + .5;
			var bmd:BitmapData
			if (mode == FallingItemMode.LEAVES)
			{
				
				bmd = new BitmapData(10, 6);
				if (i == 14)
					bmd.copyPixels(ItemManager.sprParticles.bmd, new Rectangle(70, 0, 10, 6), new Point(0, 0));
				if (i == 15)
					bmd.copyPixels(ItemManager.sprParticles.bmd, new Rectangle(80, 0, 10, 6), new Point(0, 0));
			}
			else
			{
				bmd = new BitmapData(5,5);
				ItemManager.sprParticles.frame = i;
				ItemManager.sprParticles.drawPoint(bmd, new Point(0,0));
			}
			var bm:Bitmap = new Bitmap(bmd);
			addChild(bm);
		}
		
		public function onEnterFrame(e:Event):void {
			var add:Number = 0;
			
			if (particleMode == FallingItemMode.SNOW) {
				add = 0;
				this.rotation += rotSpeed;
				this.scaleX = this.scaleY -= .0005; 
				if (this.scaleX < .5 || this.scaleY < .5)
					this.scaleX = this.scaleY = .5;
			} else if (particleMode == FallingItemMode.RAIN) {
				add = 2.9;
				this.rotation = 10;
				this.x -= .5;
			} else if (particleMode == FallingItemMode.CONFETTI) {
				add = 1.3;
				this.rotation += rotSpeed + 3;
			} else if (particleMode == FallingItemMode.LEAVES) {
				add = 1.3;
				this.rotation += rotSpeed + 3;
			}
			
			this.y += fallSpeed + add;
			
			if (this.y > Global.height + 20) {
				die();
			}
		}
		
		public function die():void {
			this.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
			this.parent.removeChild(this);
		}
	}
}