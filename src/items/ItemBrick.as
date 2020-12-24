package items
{
	import flash.display.BitmapData;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	public class ItemBrick
	{
		public var id:int
		public var payvaultid:String = null;
		public var layer:int;
		public var bmd:BitmapData
		public var tab:int
		public var requiresOwnership:Boolean
		public var requiresAdmin:Boolean
		// Requires that the item is bought. Not useable by Gold Members.
		public var requiresPurchase:Boolean = false;
		public var hasShadow:Boolean = false;
		public var description:String = "";
		public var tags:Array;
		public var selectorBG:int;
		
		public var minimapColor:Number
		public function ItemBrick(id:int, layer:int, bmd:BitmapData, payvaultid:String, description:String, tab:int, requiresOwnership:Boolean, requiresAdmin:Boolean, requiresPurchase:Boolean, shadow:Boolean, minimapColor:Number, tags:Array, selectorBG:int = 0){
			this.id = id;
			this.layer = layer;
			
			this.minimapColor = minimapColor == -1 ? generateThumbColor(bmd) : minimapColor
				
			this.bmd = shadow ? drawWithShadow(bmd) : bmd;
			this.payvaultid = payvaultid;
			this.description = description;
			this.tab = tab;
			this.requiresOwnership = requiresOwnership;
			this.requiresAdmin = requiresAdmin;
			this.requiresPurchase = requiresPurchase;
			this.hasShadow = shadow;
			this.tags = tags || [];
			
			this.selectorBG = selectorBG;
		}
		
		public static function drawWithShadow(bmd:BitmapData):BitmapData{
			
			var rect:Rectangle = new Rectangle(0,0,18,18);
			var newBmd:BitmapData = new BitmapData( 18,18, true,0x0);
			//Draw bg
			var m:Matrix = new Matrix();
			m.translate(2,2);
			newBmd.draw(bmd,m,new ColorTransform(0,0,0,.30,0,0,0,0));
			
			newBmd.draw(bmd); // Draw original bitmap
			return  newBmd;
		}
		
		public function drawTo(target:BitmapData, x:int, y:int):void{
			target.copyPixels(bmd, bmd.rect, new Point(x,y));
		}
		
		public static function generateThumbColor( bmd:BitmapData ):uint{
			
			
			var r:Number = 0;
			var g:Number = 0;
			var b:Number = 0;
			for( var y:int=y;y<bmd.height;y++){
				for( var x:int=0;x<bmd.width;x++){
					var c:uint = bmd.getPixel(x,y);
					
					r += (c & 0xff0000) >> 16
					g += (c & 0x00ff00) >> 8
					b += (c & 0x0000ff )
					
				}
			}
			
			
			r /= (bmd.width * bmd.height);
			g /= (bmd.width * bmd.height);
			b /= (bmd.width * bmd.height);
			
			
			return 0xff000000 | (r<<16) | (g<<8) | (b<<0)
			
			
			//smallBMD.draw(smallBMD, matrix, null, null, null,true);
			
			
			return 0
			
			//return 0xff000000 | smallBMD.getPixel(0,0);
		}
	}
}