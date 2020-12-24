package ui
{
	import flash.display.Sprite;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	
	import sample.ui.components.Label;
	
	import com.greensock.*;
	
	public class InfoDisplay extends Sprite
	{
		private var _timer:Timer;
		
		public function InfoDisplay(header:String, body:String)
		{
			var headerLabel:Label = new Label(header,14,"left",0xFFFFFF,false,"system");
			headerLabel.x = (400 - headerLabel.width) / 2;
			headerLabel.y = 10;
			addChild(headerLabel);
			
			var bodyLabel:Label = new Label(body,8,"center",0xFFFFFF,true,"system");
			bodyLabel.thickness = -200;
			bodyLabel.sharpness = -400;
			bodyLabel.width = 400 - 20;
			bodyLabel.x = (400 - bodyLabel.width) / 2;
			bodyLabel.y = headerLabel.y + headerLabel.height;
			addChild(bodyLabel);
			
			var h:int = bodyLabel.y + bodyLabel.height + 10;
			
			graphics.lineStyle(1,0x999999);
			graphics.beginFill(0x333333);
			graphics.drawRoundRect(0,0,400,h,5,5);
			graphics.endFill();
			
			_timer = new Timer(5 * 1000, 1);
			_timer.addEventListener(TimerEvent.TIMER_COMPLETE, onTimerComplete);
			_timer.start();
		}
		
		private function onTimerComplete(e:TimerEvent) : void
		{
			Global.base.hideInfoDisplay();
			_timer.stop();
		}
		
		public function get timer() : Timer{
			return _timer;
		}
	}
}