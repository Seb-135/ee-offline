package ui.brickoverlays
{
	import ui2.ui2properties;
	
	public class PropertiesBackground extends ui2properties
	{
		public function PropertiesBackground()
		{
			super();
		}
		
		public function setSize(w:Number,h:Number):void
		{
			bg.width = w;
			bg.height= h-10;
			bg.x = -w/2;
			bg.y = -h;
			
			arrow.x = -arrow.width/2;
			arrow.y = -10; 
		}
		
		public function incrementValue(amount:int = 1):void {
			// Must be overridden
		}
		
		public function decrementValue(amount:int = 1):void {
			// Must be overridden
		}
	}
}