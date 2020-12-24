package ui.campaigns {
	import flash.display.Sprite;
	
	public class TimesInfo extends Sprite {
		
		private static const SIDES:Number = 8;
		private static const SPACE:Number = 8;
		private static const ABOVE:Number = 7;
		
		public function TimesInfo() {}
		
		public function displayTimes(targetTimes:Array, time:int = -1, rank:int = 0):void {
			removeChildren();
			graphics.clear();
			
			var clocks:Vector.<ClockTime> = ClockTime.pickFour(targetTimes, time, rank);
			
			clocks[0].x = SIDES;
			clocks[0].y = ABOVE;
			addChild(clocks[0]);
			
			clocks[1].x = Math.round(clocks[0].x + clocks[0].width) + SPACE;
			clocks[1].y = ABOVE;
			addChild(clocks[1]);
			
			clocks[2].x = Math.round(clocks[1].x + clocks[1].width) + SPACE;
			clocks[2].y = ABOVE;
			addChild(clocks[2]);
			
			clocks[3].x = Math.round(clocks[2].x + clocks[2].width) + SPACE;
			clocks[3].y = ABOVE;
			addChild(clocks[3]);
			
			graphics.beginFill(0x7b7b7b);
			graphics.drawRect(Math.round(clocks[3].x + clocks[3].width) + SIDES, 0, 1, 28);
		}
		
	}
}