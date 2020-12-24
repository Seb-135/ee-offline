package ui.profile
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;

	public class FillBox extends Sprite
	{
		private var _width:Number = 100;
		private var _height:Number = 100;
		private var ss:int = 0;
		private var hs:int = 2;
		private var forcescale:Boolean = false;
		private var isHorizontal:Boolean = false;
		
		public function FillBox(spacing:int, hspacing:int = 0){
			this.ss = spacing;
			this.hs = hspacing;
		}
		
		public function set horizontal(value:Boolean):void{
			isHorizontal = value;
		}
		
		public function removeAllChildren() : void
		{
			while (numChildren){
				super.removeChild(getChildAt(0));
			}
			redraw();
		}
		
		public function set forceScale(value:Boolean):void
		{
			forcescale = value;
		}
		
		public override function set width(value:Number):void{
			_width = value;
			redraw();
		}
		
		public function refresh() : void{
			redraw();
		}
		
		public override function set height(value:Number):void{
			//Do nothing
		}
		
		public override function addChild(child:DisplayObject):DisplayObject{
			super.addChild(child);
			redraw();
			return child;
		}
		
		public function clear() : void{
			while(numChildren > 0){
				super.removeChildAt(0);
			}
			redraw();
		}
		
		private function redraw():void{
			var ox:Number = 0;
			var oy:Number = 0;
			var nj:Number = 0;
			for( var a:int=0;a<numChildren;a++){
				var c:DisplayObject = getChildAt(a);
				
				if (!isHorizontal)
				{
					if(ox + c.width + 2 > _width){
						ox = 0;
						oy += nj + ss;
						nj = 0;
					}
				}
				
				//Scale if it is still larger
				if(forcescale && ox + c.width + 2 > _width){
					c.width = _width-2;
				}
				
				c.x = Math.round(ox);
				c.y = Math.round(oy);
				
				if(c.height > nj){
					nj = c.height;
				}
				
				ox += c.width + hs;
			}
		}
		
	}
}