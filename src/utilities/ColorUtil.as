package utilities
{
	import flash.text.TextField;
	import flash.text.TextFormat;
	public class ColorUtil
	{
		private static var hexArray:Array = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "A", "B", "C", "D", "E", "F"];
		
		public static function DecimalToHex(dec:Number, removeAlpha:Boolean = true) : String{
			var decimal:Number = dec;
			
			var output:String = "";
			
			//Continue to divide the value by 16 until it reaches 0
			while(Math.floor(decimal) != 0){
				decimal /= 16;
				
				//The index to be used for getting the hex value from hexArray
				var hexIndex:int = (decimal - Math.floor(decimal)) * 16;
				
				//Add the value to the output string
				output += hexArray[hexIndex];
			}
			
			//Create a temporary array to reverse the output string
			var tempArray:Array = output.split("");
			tempArray.reverse();
			output = tempArray.join("");
			
			//To remove the first two ALPHA characters from the string (ee does not allow for alpha in the hex code)
			if (removeAlpha) {
				//If the output is equal to 8, remove the alpha characters
				if (output.length == 8) output = output.slice(2, 8);
				
				//If the output is less than 6 we need to add 0's to the front of the string to create a 6 character hex code
				if (output.length < 6){
					for (var i:int = output.length; i < 6; i++){
						output = "0" + output;
					}
				}
			}
			
			trace("DecimalToHex:", dec, output);
			
			return output;
		}
		
		public static var gradientNames:Object = {
			brandon: [0xFF9D00, 0xFF9301, 0xFF8504, 0xFF7706, 0xFF5C0B, 0xFF4F0E, 0xFF4110],
			oxidizer: [0x0BF24C, 0x22D964, 0x3DCC82, 0x5BBFA8, 0x7CAACC, 0x8E84D8, 0x9D62E5, 0xAD44F3],
			emily: [0xff0000, 0xff9100, 0xffff00, 0x00ff00, 0x0091ff],
			bud: [0xFF9090, 0xFFFF60, 0xADFF60],
			pipec: [0xE32105, 0xFF442F, 0xFF7468, 0xF28574, 0xFEB3FF],
			kaleb: [0xB600FF, 0xE14766, 0xFF7700, 0xE14766, 0xB600FF],
			acetari: [0x20A5EE, 0x4EB6EE, 0x60B9EA, 0xFF0000, 0xFB2323, 0xFB3333, 0xF93F3F],
			lunarys: [0xCA1689, 0xD32996, 0xDC3DA1, 0xE550AD, 0xF36DBF, 0xF573C3, 0xFF87D0],
			dynamite: [0xFF00AA, 0xFF32CC, 0xFF66E5, 0xFF99F6, 0xFF7FFF, 0xFF4CFF, 0xFF26EC, 0xFF00D4],
			loot: [0xFFFFFF, 0xFFFFFF, 0xFFFFFF, 0xFFFFFF],
			satanya: [0xCA1689, 0xD32996, 0xDC3DA1, 0xE550AD, 0xF36DBF, 0xF573C3, 0xFF87D0],
			//gosha: [0xFFB400, 0xFFB400, 0xFFB400, 0xFFB400, 0x004BFF],
			luciferx: [0xFF7600, 0xFF6800, 0xFF5800, 0xFF4C00, 0xFF3D00, 0xFF2B00, 0xFF0900, 0xFFFFFF],
			seb135: [0x5DFF00, 0x5DFF00, 0x5DFF00, 0x289C00, 0x289C00, 0x289C00],
			xenonetix: [0xB0FFA3, 0xBFFCD7, 0xADFFDF, 0xA3FFEB, 0xA5FFE7, 0x96FFE3, 0x83DAE1, 0x70C6E0, 0x66B0FF]
			// Keep Xeno at the end so we don't have to change commas when adding / removing names
		};
		
		public static var colouredNames:Object = {
			admin:	["benjaminsen", "rpgmaster2000", "sbeam", "kerff", "mrshoe", "mrvoid", "toby", "cyclone", "processor",
					 "thanel", "nou", "toop", "eejesse", "jesse", "nvd", "priddle", "showpath", "bytearray", "lukem", "john", "gosha",
					 "cercul1"],
			mod:	["ultrabass", "thesource85", "kingoftheozone", "jawapa", "zioxei", "dream", "benje00", "phinarose",
					 "lrussell", "zoey2070", "grandswordsman26", "capasha", "minimania", "luridmetal35", "megalamb", "kiraninja",
					 "mutantdevle", "darksaplep"],
			dev:	["cjmaeder", "kaslai", "xjeex"],
			design:	["cola1", "minisaurus", "kentiya", "koya", "securitydrone", "security-drone"],
			camp:	["kirby", "master1", "ravatroll", "tiralmo"],
			music:	["satanya", "neonsynth"],
			forum:	["different55", "tomahawk", "buzzerbee"],
			patron:	["matt", "silvermoonlight", "kank", "emily", "dynamite", "teds", "grensnez", "loot", "dev",
					 "wallymitko", "k3nny5", "killerofgoku", "sidneyy", "metamo", "kosta89", "joeyc", "dtop", "och",
					 "skyler", "oxed", "craftspider", "exstyle", "drewcakes", "enano2001", "supermouk", "ultramouk",
					 "zaruzet", "stratios", "pipec", "dylans", "carbombs", "funce", "macandcheese", "aquafresh",
					 "misterstupid", "xenaksis", "swarth100", "xdragao11", "alexthealien", "akimbo", "who", "boba",
					 "dogdavid", "doh", "ninjasupeatsninja", "sirjosh3917", "awesomedeath", "heavynubeslayer", "taras10",
					 "jr20star", "addexgg", "xfrogman43", "bierne", "untunedmc", "aymorr", "ziggurat", "sirsoul", "souk",
					 "soulrunner", "08jack", "awesomenessgood", "boatman", "cascabs", "user1212121234", "beby",
					 "tigergirl2007", "me5", "sapphirefoxxo", "myth", "lsplash", "cobatine", "popedits1234", "karimpie",
					 "immolation", "explozion", "degree", "jazper", "rpglover4life", "littlephilip", "finbae", "phooey",
					 "nightmore", "baxdartheinfamous", "doomester", "snowester", "growler", "doom", "keztek", "starblinky",
					 "wow", "tripledyou", "erick", "afy", "xxhackzxx", "degnut", "aia", "luna", "world111", "semxypenguin"]
		}
		
		public static function colorizeUsername(t:TextField, start:int = 0, len:int = -1):void {
			var text:String = t.text.toLowerCase();
			
			if (len < 0) len = text.length - start;
			if (len != text.length) text = text.substring(start, start + len);
			
			if (gradientNames[text]) {
				for (var i:int = 0; i < len; i++) {
					t.setTextFormat(new TextFormat(null, null, gradientNames[text][i]), start + i, start + i + 1);
				}
				return;
			}
			if (format(t, Config.admin_color, colouredNames.admin)) return;
			if (format(t, Config.moderator_color, colouredNames.mod)) return;
			if (format(t, Config.developer_color, colouredNames.dev)) return;
			if (format(t, Config.designer_color, colouredNames.design)) return;
			if (format(t, Config.campaign_curator_color, colouredNames.camp)) return;
			if (format(t, Config.composer_color, colouredNames.music)) return;
			if (format(t, Config.friend_color_dark, colouredNames.forum)) return;
			if (format(t, Config.patron_color_1, colouredNames.patron)) return;
		}
		
		private static function format(t:TextField, colour:uint, group:Array):Boolean {
			var text:String = t.text.toLowerCase();
			if (group.indexOf(text) != -1) {
				t.setTextFormat(new TextFormat(null, null, colour));
				return true;
			}
			return false;
		}
		
	}
}