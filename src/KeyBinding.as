package {
	import blitter.Bl;
	public class KeyBinding	{
		
		public static var _all:Vector.<KeyBinding> = new Vector.<KeyBinding>();
		private static var _ref:Array = [];
		
		public static var jump:KeyBinding =              _add(25, "Jump", new Key(32));                              // Space
		public static var up:KeyBinding =                _add(0, "Move Up (alt)", new Key(87), new Key(90));         // W / Z
		public static var left:KeyBinding =              _add(1, "Move Left (alt)", new Key(65), new Key(81));       // A / Q
		public static var down:KeyBinding =              _add(2, "Move Down (alt)", new Key(83));                    // S
		public static var right:KeyBinding =             _add(3, "Move Right (alt)", new Key(68));                   // D
		public static var godmode:KeyBinding =           _add(4, "Toggle God Mode", new Key(71));                    // G
		public static var modmode:KeyBinding =           _add(5, "Toggle Mod Mode", new Key(80), null, true);        // P
		public static var modmodeRow:KeyBinding =        _add(27, "Change Mod Mode Colour", new Key(80, true), null, true); // Shift + P
		public static var minimap:KeyBinding =           _add(6, "Toggle Minimap", new Key(77));                     // M
		public static var inspect:KeyBinding =           _add(7, "Toggle Inspect Tool", new Key(73));                // I
		public static var chat:KeyBinding =              _add(8, "Chat (alt)", new Key(84));                         // T
		public static var blockbar:KeyBinding =          _add(9, "Show Blocks (held)", new Key(66));                 // B
		public static var interact:KeyBinding =          _add(10, "NPC Interaction", new Key(67));                   // C (communication with npcs)
		public static var risky:KeyBinding =             _add(11, "World Interaction", new Key(89));                 // Y (reset block, world portal)
		public static var decrement:KeyBinding =         _add(12, "Decrement Value", new Key(81), new Key(65));      // Q / A (switches, doors, etc.)
		public static var increment:KeyBinding =         _add(13, "Increment Value", new Key(69));                   // E (switches, doors, etc.)
		public static var retryRun:KeyBinding =          _add(26, "Retry Time Trial", new Key(82, true));            // Shift + R
		public static var hideUsernames:KeyBinding =     _add(14, "Hide Usernames", new Key(85, true));              // Shift + U
		public static var hideChatBubbles:KeyBinding =   _add(15, "Hide Chat Bubbles", new Key(73, true));           // Shift + I
		public static var screenshot:KeyBinding =        _add(16, "Screenshot", new Key(66, true));                  // Shift + B
		public static var screenshotFull:KeyBinding =    _add(17, "Full Screenshot", new Key(78, true), null, true); // Shift + N
		public static var screenshotMinimap:KeyBinding = _add(18, "Minimap Screenshot", new Key(86, true));          // Shift + V
		public static var lockCamera:KeyBinding =        _add(19, "Lock Camera", new Key(76, true), null, true);     // Shift + L
		public static var lookUp:KeyBinding =            _add(20, "Look Up", new Key(72, true), null, true);         // Shift + Y
		public static var lookLeft:KeyBinding =          _add(21, "Look Left", new Key(74, true), null, true);       // Shift + G
		public static var lookDown:KeyBinding =          _add(22, "Look Down", new Key(89, true), null, true);       // Shift + H
		public static var lookRight:KeyBinding =         _add(23, "Look Right", new Key(71, true), null, true);      // Shift + J
		public static var hideUI:KeyBinding =            _add(24, "Hide UI", new Key(79, true), null, true);         // Shift + O
		//public static var download:KeyBinding =          _add(27, "Download Level", new Key(67, true), null);        // Shift + C
		// NEXT: 28
		
		private static function _add(id:int, name:String, keyDefault:Key, keyAzerty:Key = null, staffOnly:Boolean = false):KeyBinding {
			var k:KeyBinding = new KeyBinding(id, name, keyDefault, keyAzerty, staffOnly);
			_all.push(k);
			_ref[id] = k;
			return k;
		}
		
		public static function load():void {
			for each (var b:KeyBinding in _all) b.keyCustom = null;
			var kb:Array = Global.base.settings.keybinds;
			for (var i:int = 0; i < kb.length; i += 3) {
				if (kb[i] == undefined)	continue;
				var id:int = kb[i];
				var key:int = kb[i + 1];
				var shift:Boolean = kb[i + 2];
				
				_ref[id].keyCustom = new Key(key, shift);
			}
		}
		
		public static function save():void {
			var list:Array = new Array();
			for (var i:int = 0; i < _all.length; i++) {
				var item:KeyBinding = _all[i];
				if (!item.keyCustom) continue;
				
				list[i*3] = item.id;
				
				list[i*3 + 1] = item.keyCustom.keyCode;
				
				list[i*3 + 2] = item.keyCustom.needsShift?1:0;
			}
			Global.base.settings.keybinds = list;
			if (!Global.cookie.data.settings) Global.cookie.data.settings = new Object();
			Global.cookie.data.settings.keybinds = list;
			World.updateRiskyPopups();
		}
		
		// = = = = = = = = = = = =
		
		public var id:int;
		public var name:String;
		
		public var keyDefault:Key;
		public var keyAzerty:Key;
		public var keyCustom:Key = null;
		
		public var staffOnly:Boolean;
		
		public function KeyBinding(id:int, name:String, keyDefault:Key, keyAzerty:Key = null, staffOnly:Boolean = false) {
			this.id = id;
			this.name = name;
			this.keyDefault = keyDefault;
			this.keyAzerty = keyAzerty;
			this.staffOnly = staffOnly;
		}
		
		public function get key():Key {
			return keyCustom ? keyCustom : Global.base.settings.azerty && keyAzerty ? keyAzerty : keyDefault;
		}
		
		public function isDown(ignoreShift:Boolean = false):Boolean {
			var key:Key = this.key;
			if (!ignoreShift && Bl.isKeyDown(16) != key.needsShift) return false;
			return Bl.isKeyDown(key.keyCode as int);
		}
		
		public function isJustPressed(ignoreShift:Boolean = false):Boolean {
			var key:Key = this.key;
			if (!ignoreShift && Bl.isKeyDown(16) != key.needsShift) return false;
			return Bl.isKeyJustPressed(key.keyCode as int);
		}
		
		public function isJustReleased(ignoreShift:Boolean = false):Boolean {
			var key:Key = this.key;
			if (!ignoreShift && Bl.isKeyDown(16) != key.needsShift) return false;
			return Bl.isKeyJustReleased(key.keyCode as int);
		}
		
	}
}