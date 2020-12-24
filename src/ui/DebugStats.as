package ui {
	import flash.events.*;
	import flash.text.AntiAliasType;
	import flash.text.GridFitType;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.utils.getTimer;
	import states.PlayState;

	public class DebugStats extends TextField {
		
		private static const UPDATE_INTERVAL:Number = 1000;
		
		private var state:PlayState;
		
		private var lastUpdate:Number;
		private var frameCount:Number;
		private var lastFps:Number = 0;
		
		public function DebugStats(state:PlayState, textColor:Number = 0xffffff, fontSize:Number = 11):void {
			this.state = state;
			
			x = 4;
			y = 2;
			
			var format:TextFormat = new TextFormat("Tahoma", fontSize, textColor);
			defaultTextFormat = format;
			antiAliasType = AntiAliasType.ADVANCED;
			gridFitType = GridFitType.SUBPIXEL;
			multiline = true;
			autoSize = TextFieldAutoSize.LEFT;
			selectable = false;
			mouseEnabled = false;
			
			addEventListener(Event.ADDED_TO_STAGE, onShow);
			addEventListener(Event.REMOVED_FROM_STAGE, onHide);
		}
		
		private function onShow(e:Event):void {
			addEventListener(Event.ENTER_FRAME, update);
			frameCount = 0;
			lastUpdate = getTimer();
		}
		
		private function onHide(e:Event):void {
			removeEventListener(Event.ENTER_FRAME, update);
		}
		
		private function update(e:Event):void {
			
			if (!visible) return;
			
			var currentTime:Number = getTimer();
			frameCount++;
			
			if (currentTime >= lastUpdate + UPDATE_INTERVAL) {
				lastUpdate = currentTime;
				lastFps = frameCount;
				frameCount = 0;
			}
			
			updateText();
		}
		
		private function updateText():void {
			text = "";
			
			add("Everybody Edits Offline");
			add("FPS", lastFps.toString());
			add("Position", "(" + (state.player.x / 16).toFixed(3) + ", " + (state.player.y / 16).toFixed(3) + ")");
			add("Time", (state.player.ticks / 100).toFixed(2) + "s");
			
			if (Global.reportTextTest != "") 
				add("Report", Global.reportTextTest);
			
			/*
			add("Cam", (state.x >> 4) + "x" + (state.y >> 4));
			add("isFlying", state.player.isFlying);
			add("JumpCount", state.player.jumpCount);
			add("grounded", state.player.grounded);
			add("speedX", state.player.speedX);
			add("speedY", state.player.speedY);
			add("moX", state.player.moy);
			add("moY", state.player.moy);
			add("morX", state.player.morx);
			add("morY", state.player.mory);
			add("flipGravity", state.player.flipGravity);
			add("current_below", state.player.current_below);
			*/
		}
		
		private function add(name:String, value:String=""):void {
			text += name + (value==""?"":": " + value) + "\n";
		}
		
	}
}