package blitter
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import items.ItemBrick;
	import items.ItemLayer;
	import items.ItemManager;

	public class BlTilemap extends BlObject
	{
		protected var rect:Rectangle
		public var size:int;
	//	protected var map:Array = [ [[]] ]; // layer/row/col
		
		protected var hitOffset:int
		protected var hitEnd:int
		
		public var depth:int = 0;
		
		protected var bmd:BitmapData
		public var realmap:Vector.<Vector.<Vector.<int>>> // layer/row/col
		protected var background:Vector.<Vector.<int>>
		protected var decoration:Vector.<Vector.<int>>
		protected var forground:Vector.<Vector.<int>>
		protected var above:Vector.<Vector.<int>>
		
		public var lastframe:BitmapData;
		
		
		public function BlTilemap(bitmap:Bitmap, hitOffset:int=1, hitEnd:int = 99, hitOffset2:int = 121){
			bmd = bitmap.bitmapData
			rect = new Rectangle(0,0, bmd.height,bmd.height);
			size = bmd.height;
			
			this.hitOffset = hitOffset 
			this.hitEnd = hitEnd 
		}
		
		public function setMapArray(map:Array):void{
			//this.map = map;
			
			
			depth = map.length;
			height = map[0].length;
			width = map[0][0].length;
				
			//Reset render maps
			background = new Vector.<Vector.<int>>(height)
			decoration = new Vector.<Vector.<int>>(height)
			forground = new Vector.<Vector.<int>>(height)
			above = new Vector.<Vector.<int>>(height)
				
			for( var r:int=0;r<height;r++){
				background[r] = new Vector.<int>(width);
				decoration[r] = new Vector.<int>(width);
				forground[r] = new Vector.<int>(width);
				above[r] = new Vector.<int>(width);
			}
			
			//Reset realmap
			realmap = new Vector.<Vector.<Vector.<int>>>(depth)
			
			//Populate maps
			for( var a:int=0;a<depth;a++){
				realmap[a] = new Vector.<Vector.<int>>(height);
				for( var b:int=0;b<height;b++){
					realmap[a][b] = new Vector.<int>(width);
					for( var c:int=0;c<width;c++){
						realmap[a][b][c] = map[a][b][c];
						setMagicTile(a,c,b,map[a][b][c]);
					}
				}
			}
		}
		
		
		public function overlaps(o:BlObject):int{
			////////// THIS CODE IS OVERLOADED IN WORLD!!
			/*var ox:Number = o.x/size;
			/* overridden in World anyway, and is not updated for layer support here..
			var ox:Number = o.x/size;
			var oy:Number = o.y/size;
			
			var endy:Number = oy+(o.width-1)/size
			var endx:Number = ox+(o.height-1)/size
			for( var a:int=oy;a<endy;a++){
				if(map[a] != null){
					for( var b:int=ox;b<endy;b++){
						var val:int = map[a][b]
						if( val >= hitOffset && val <= hitEnd){
							return true;
						}
					}
				}
			}*/
			return 0
		}
		
		protected function setMagicTile(layer:int, x:int,y:int,type:int):void{					
			if(layer == ItemLayer.BACKGROUND){
				background[y][x] = type;
			}else{
				
				decoration[y][x] = 0;
				forground[y][x] = 0;
				above[y][x] = 0;

				var i:ItemBrick = ItemManager.bricks[type];
				
				if(i != null){
					switch(i.layer){
						case ItemLayer.BACKGROUND:{ 
							break;
						}
							
						case ItemLayer.DECORATION:{
							decoration[y][x] = type;
							break;
						}
						case ItemLayer.FORGROUND:{
							forground[y][x] = type;
							break;
						}
						case ItemLayer.ABOVE:{
							above[y][x] = type;
							break;
						}
							
					}
				}

			}
			
		}
		
		protected function setTile(layer:int,x:int,y:int,type:int):void{
			setMagicTile(layer,x,y,type)

			if(realmap[layer] != null){
				if(realmap[layer][y] != null){
					realmap[layer][y][x] = type;
				}
			}
			
			
		}
		
		public function getTile(layer:int,x:int,y:int):int{
			if(
				layer < 0 || layer >= depth ||
				x < 0 || x >= width ||
				y < 0 || y >= height
			) return 0;
			return realmap[layer][y][x]
		}
		
		/**
		 * Counts all the occurences of a given type in the entire tilemap 
		 * @param type the type being counted
		 * @return number of occurences
		 * 
		 */
		public function getTypeCount( type:int ):int
		{
			var c:int = 0;
			
			for( var l:int=0 ; l<realmap.length ; l++)
				for( var y:int=0 ; y<realmap[l].length ; y++ ){
					var row:Vector.<int> = realmap[l][y];
					for( var x:int=0;x<row.length;x++){
						if( row[x] == type ) c++;		
					}
				}
			return c;
		}
		
		public function get image():Bitmap {
			return new Bitmap(lastframe);
		}
		
		
		/*public override function draw(target:BitmapData, ox:Number, oy:Number):void{
			//This is overloaded by world .draw
			/* overridden in World, and is not prepared for layer support here...
			var starty:int = -oy/size;
			var startx:int = -ox/size;

			var endy:int = starty + Bl.height/size + 1;
			var endx:int = startx + Bl.width/size + 1;
			
			if(starty<0)starty = 0;
			if(startx<0)startx = 0;
			if(endy > height) endy = height; 
			if(endx > width) endx = width; 
				
			
			for( var a:int=starty;a<endy;a++){
				var row:Array = map[a] as Array;
				
				for( var b:int=startx;b<endx;b++){
					var type:int = row[b];
					
					rect.x = type*size;
					target.copyPixels(bmd, rect, new Point(
						b*size+ox,
						a*size+oy
					));
				
				}
			}
			
		}*/
	}
}