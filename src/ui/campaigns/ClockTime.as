package ui.campaigns {
	import flash.display.Sprite;
	import sample.ui.components.Label;
	
	public class ClockTime extends Sprite {
		
		public var clock:Clock;
		public var label:Label;
		private var _time:int;
		
		public function ClockTime(data:Object) {
			clock = new Clock(data.rank);
			addChild(clock);
			label = new Label("", 8, "left", 0xffffff, false, "system");
			label.x = clock.width + 2;
			label.y = 1;
			addChild(label);
			time = data.time;
			rank = data.rank; // update color and size
		}
		
		public function get rank():int { return clock.rank; }
		public function set rank(n:int):void {
			clock.rank = n;
			label.textColor = rankColor(clock.rank);
			label.width = label.textWidth + 4;
		}
		
		public function get time():int { return _time; }
		public function set time(totalCent:int):void {
			_time = totalCent;
			label.text = format(totalCent);
		}
		
		public static function format(totalCent:int):String {
			if (totalCent < 0) return "(not set)";
			
			var totalSec:Number = Math.floor(totalCent / 100);
			var totalMin:Number = Math.floor(totalSec / 60);
			
			var s:String = "";
			
			var hour:Number = Math.floor(totalMin / 60);
			if (hour > 0) {
				s += hour + ":";
			}
			
			var min:Number = totalMin % 60;
			if (min < 10) s += "0";
			s += min + ":";
			
			var sec:Number = totalSec % 60;
			if (sec < 10) s += "0";
			s += sec;
			
			var cent:Number = totalCent % 100;
			if (cent > 0 || hour == 0) {
				s += ".";
				if (cent < 10) s += "0";
				s += cent;
			}
			
			return s;
		}
		
		public static function rankColor(rank:int):uint {
			return rank == 5 ? 0xffadf6 :
			       rank == 4 ? 0xc1fcff :
			       rank == 3 ? 0xffce6d :
			       rank == 2 ? 0xfff4ef :
			       rank == 1 ? 0xff9189 :
			       0x40ff40;
		}
		
		public static function pickFour(targetTimes:Array, time:int = -1, rank:int = 0):Vector.<ClockTime> {
			var times:Array = targetTimes.map(function(t:int, i:int, a:Array):Object { return { rank: i + 1, time: t }; }); // Get tiers
			times.insertAt(rank, { rank: 0, time: time }); // Insert player time
			
			var clocks:Vector.<ClockTime> = new Vector.<ClockTime>();
			clocks.push(new ClockTime(times[times.length - 4]));
			clocks.push(new ClockTime(times[times.length - 3]));
			clocks.push(new ClockTime(times[times.length - 2]));
			clocks.push(new ClockTime(times[times.length - 1]));
			return clocks;
		}
		
	}
}