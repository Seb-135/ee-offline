package  {
	public class Key {
		
		public var needsShift:Boolean;
		public var keyCode:int;
		
		public function Key(keyCode:int, shift:Boolean = false) {
			this.keyCode = keyCode;
			this.needsShift = shift;
		}
		
		public function print():String {
			var s:String = printKey(keyCode);
			return s ? (needsShift ? "Shift + " : "") + s : "???";
		}
		
		public static function isValidKey(code:int):Boolean {
			return (code >= 65 && code <= 90) || // A to Z
			       (code >= 96 && code <= 111) || // numpad
			       (code >= 186 && code <= 192 && code != 191) || (code >= 219 && code <= 222) || // symbols
				   code == 32; // space
		}
		
		public static function printKey(code:int):String {
			if (code >= 65 && code <= 90)
				return String.fromCharCode(code);
			else if (code >= 96 && code <= 111)
				return "Numpad " + String.fromCharCode(code - (code <= 105 ? 48 : 64));
				
			switch (code) {
				case 186: return ";:";
				case 187: return "=+";
				case 188: return ",<";
				case 189: return "-_";
				case 190: return ".>";
				//case 191: return "/?";
				case 192: return "`~";
				case 219: return "[{";
				case 220: return "\\|";
				case 221: return "]}";
				case 222: return "'\"";
				case 32: return "Space";
				default: return null;
			}
		}
	}
}