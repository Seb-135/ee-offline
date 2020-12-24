package 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	/**
	 * ...
	 * @author Remmoze
	 */
	public class ImageBlock 
	{
		private var bmd:BitmapData;
		public var name:String;
		
		public var x:int;
		public var y:int;
		private var _width:Number;
		private var _height:Number;
		private var area:Rectangle;
		
		public function ImageBlock(name:String, x:int, y:int, load:Boolean = true) {
			this.name = name;
			this.x = x;
			this.y = y;
			
			if(load) requestImage(this);
		}
		
		public function get width():Number {
			return _width;
		}
		
		public function get height():Number {
			return _width;
		}
		
		public function get rect():Rectangle {
			return area;
		}
		
		public function get bitmapData():BitmapData {
			return bmd;
		}
		
		public function get bitmap():Bitmap {
			return new Bitmap(bmd);
		}
		
		public function get loaded():Boolean {
			return bmd != null;
		}
		
		private function handleLoaded(bmd:BitmapData):void {
			
			trace("cached image loaded:", name);
			
			this.bmd = bmd;
			_width = bmd.width;
			_height = bmd.height;
			
			area = new Rectangle(0, 0, _width, _height);
		}
		
		public function isInbounds(startX:int, startY:int, endX:int, endY:int):Boolean {
			var imageRect:Rectangle = new Rectangle(x * 16, y * 16, width, height);
			var visibleArea:Rectangle = new Rectangle(startX * 16, startY * 16, endX * 16, endY * 16);
			return imageRect.intersects(visibleArea);
		}
		
		private static var query:Vector.<String> = new Vector.<String>();
		private static var queryBlocks:Vector.<ImageBlock> = new Vector.<ImageBlock>();
		private static function requestImage(block:ImageBlock):void {
			for each(var item:ImageBlock in Global.cachedImages) {
				if (item.name == block.name) {
					block.handleLoaded(item.bmd);
					return;
				}
			}
			queryBlocks.push(block);
			if (query.indexOf(block.name) != -1) return;
			query.push(block.name);
			
			var imageLink:String = "https://r.playerio.com/r/everybody-edits-su9rn58o40itdbnw69plyw/Images/"+block.name+".png";
			var load:Loader = new Loader();
			load.load(new URLRequest(imageLink));
			load.contentLoaderInfo.addEventListener("complete", function(e:Event):void {
				var bmd:BitmapData = new BitmapData(load.width, load.height, true, 0x0);
				bmd.draw(Bitmap(load.content));
				
				var storage:ImageBlock = new ImageBlock(block.name, 0, 0, false);
				storage.bmd = bmd;
				Global.cachedImages.push(storage);
				
				query.removeAt(query.indexOf(block.name));
				
				trace("image loaded:", block.name);
				for (var i:int = queryBlocks.length-1; i >= 0; i--) {
					var item:ImageBlock = queryBlocks[i];
					if (item.name != block.name) continue;
					item.handleLoaded(bmd);
					queryBlocks.removeAt(queryBlocks.indexOf(item));
				}
			});
		}
	}
}