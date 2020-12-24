package sample.ui.components.scroll
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	
	public class ScrollContainer extends Sprite
	{
		protected var componentWidth:Number = 0;
		
		public override function set width(value:Number):void{
			mouseEnabled = true;
			
			if(componentWidth != value)
			{
				
				for(var a:int=0;a<numChildren;a++){
					var content:DisplayObject = getChildAt(a);
					content.width = value-1
					
				}
				componentWidth = value;
			}
		}
		
		public override function set height(value:Number):void{
			//DO nothing
		}

	}
}