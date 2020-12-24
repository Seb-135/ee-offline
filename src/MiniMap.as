package
{
	import blitter.Bl;
	import blitter.BlObject;
	import items.ItemBrick;
	
	//import fl.motion.Color;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.geom.ColorTransform;
	import flash.geom.Point;
	import flash.utils.ByteArray;
	
	import items.ItemLayer;
	import items.ItemManager;
	
	public class MiniMap extends BlObject
	{
		private var bmd:BitmapData
		private var playermap:BitmapData
		private var alphaData:BitmapData;
		private var alphaBox:Sprite;
		
		private var ct:ColorTransform;
		
		public function MiniMap(world:World, width:int, height:int)
		{
			bmd = new BitmapData(width,height,true, 0x00000000);
			playermap = new BitmapData(width,height,true,0x00000000);
			
			this.x = 640-width-2;
			this.y = 470-height-2;
			
			ct = new ColorTransform();
			
			alphaBox = new Sprite();
			alphaData = new BitmapData(width, height, true, 0x00000000);
			setAlpha(Global.base.settings.minimapAlpha);
			
			reset(world);
		}
		
		public function updatePixel(xo:int,yo:int,color:Number):void{
			bmd.setPixel32(xo,yo,color)
		}
		
		public function showPlayer(p:Player, color:uint):void{
			playermap.setPixel32(p.x >> 4, p.y >> 4, color);
		}
		
		public function clear():void{
			playermap.colorTransform(playermap.rect, new ColorTransform(1,1,1,1-1/64));
		}
		
		public function reset(world:World):void{
			for( var a:int=0;a<world.width;a++){
				for( var b:int=0;b<world.height;b++){
					bmd.setPixel32(a,b,world.getMinimapColor(a,b))
				}
			}
		}
		
		public function drawDirect(target:BitmapData):void{
			target.copyPixels(bmd,bmd.rect,new Point(0,0));
		}
		
		public function setAlpha(value:Number) : void{
			ct.alphaMultiplier = value;
			
			alphaBox.graphics.clear();
			alphaBox.graphics.beginFill(0x000000, 1);
			alphaBox.graphics.drawRect(0, 0, bmd.width, bmd.height);
			alphaBox.graphics.endFill();
			
			alphaData = new BitmapData(bmd.width, bmd.height, true, 0x00000000);
			alphaData.draw(alphaBox, null, ct);
		}
		
		public override function draw(target:BitmapData, ox:int, oy:int):void{
			var point:Point = new Point(x, y - 3);
			if (Bl.data.moreisvisible) {
				point.y = y + Bl.data.bselector.y;
				if (bmd.width > 150) {
					point.y -= 15;
				}
			}
			target.copyPixels(bmd, bmd.rect, point, alphaData, new Point(), true);
			target.copyPixels(playermap, playermap.rect, point, alphaData, new Point(), true);
			
			clear();
		}	
		
		public function getBitmapData():BitmapData {
			return bmd;
		}
	}
}