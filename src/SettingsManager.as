package {
	import flash.utils.ByteArray;
	/**
	 * 
	 * @author Remmoze
	 */
	public class SettingsManager {
		
		public var smileys:Array = new Array();
		private function setSmileys(ba:ByteArray):void {
			smileys = new Array();
			for (var i:int = 0; i < ba.length; i++) 
				smileys.push(ba[i]);
		}
		
		public var keybinds:Array = new Array();
		private function setKeybinds(ba:ByteArray):void {
			keybinds = new Array();
			for (var i:int = 0; i < ba.length; i++) 
				keybinds.push(ba[i]);
		}
		
		public var particles:Boolean = false;
		public var greenOnMinimap:Boolean = true;
		public var minimapAlpha:Number = 1;
		public var wordFilter:Boolean = true;
		public var coloredNames:Boolean = false;
		public var hideUsernames:Boolean = false;
		public var hideBubbles:Boolean = false;
		public var showPackageNames:Boolean = true;
		public var visibleRows:int = 3;
		public var collapsed:Boolean = false;
		public var blockPicker:Boolean = false;
		public var historyLimit:int = 25;
		public var volume:int = 100;
		public var azerty:Boolean = false;
		public var savedBlocks:Array = [9,10,11,16,17,18,29,32,2,100];
		
		public function save(extra:Boolean = false):void {
			//var msg:Message = new Message("settings");
			if (!Global.cookie.data.settings) Global.cookie.data.settings = new Object();
			var settings:Object = Global.cookie.data.settings;
			settings.particles = particles;
			settings.greenOnMinimap = greenOnMinimap;
			settings.minimapAlpha = minimapAlpha;
			settings.hideBubbles = hideBubbles;
			settings.showPackageNames = showPackageNames;
			settings.visibleRows = visibleRows;
			settings.collapsed = collapsed;
			settings.blockPicker = blockPicker;
			settings.volume = volume;
			settings.azerty = azerty;
			//msg.add(particles);
			//msg.add(greenOnMinimap);
			//msg.add(minimapAlpha);
			//msg.add(wordFilter);
			//msg.add(coloredNames);
			//msg.add(hideUsernames);
			//msg.add(hideBubbles);
			//msg.add(showPackageNames);
			//msg.add(visibleRows);
			//msg.add(collapsed);
			//msg.add(blockPicker);
			//msg.add(historyLimit);
			//msg.add(volume);
			//msg.add(azerty);
			//Global.base.connection.sendMessage(msg);
			//trace("sent", msg);
		}
		
		public function SettingsManager():void {
		}
	}
}