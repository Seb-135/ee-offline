package utilities 
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Shape;
	
	public class DebugTools {
		
		//usage: in the end of the DisplayObjectContainer redraw function add this:
		//DebugTools.outlineChildren(this);
		public static function outlineChildren(parent:DisplayObjectContainer, thickness:int = 2, color:int = 0xFF0000):void {
			removeOutlines(parent);
			
			var outlines:Shape = new Shape();
			outlines.name = "outlinesDebug";
			outlines.graphics.lineStyle(thickness, color);
			for (var i:int = 0; i < parent.numChildren; i++) {
				var child:DisplayObject = parent.getChildAt(i);
				outlines.graphics.drawRect(child.x, child.y, child.width, child.height);
			}
			parent.addChild(outlines);
		}
		
		public static function removeOutlines(parent:DisplayObjectContainer):void {
			var child:DisplayObject = parent.getChildByName("outlinesDebug");
			if (!child) return;
			parent.removeChildAt(parent.getChildIndex(child));
		}
	}
}