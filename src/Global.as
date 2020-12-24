package
{
	import blitter.BlContainer;
	import flash.display.Sprite;
	import flash.utils.ByteArray;
	import states.PlayState;
	import ui.DebugStats;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Stage;
	import flash.display.StageDisplayState;
	import flash.external.ExternalInterface;
	import flash.net.SharedObject;

	public class Global
	{
		public static var playerInstance:Player;
		
		public static var default_label_size:int = 12;
		public static var default_label_text:String = ":)";
		public static var default_label_hex:String = "#FFFFFF";
		public static var text_sign_text:String = "Enter text here.";
		
		public static var fullWidth:int = 640;
		public static var fullHeight:int = 500;
		public static var stage:Stage;
		
		public static var cookie:SharedObject;
		public static var sharedCookie:SharedObject;
		public static var noSave:Boolean = false;
		public static var noSaveShown:Boolean = false;
		
		public static var normalStart:Boolean = true;
		
		public static var chatIsVisible:Boolean = false;
		
		public static var affiliate:String = "";
		public static var base:EverybodyEdits;
		
		public static var pianoOffset:int = 0;
		public static var drumOffset:int = 0;
		public static var guitarOffset:int = 0;
		public static var hasOwner:Boolean = false;
		public static var currentLevelname:String = "";
		public static var worldOwner:String = "";
		public static var ownerID:String = "";
		public static var newData:ByteArray;
		public static var dataPos:int;
		public static var worldInfo:Object = {};
		public static var currentBgColor:uint;
		
		public static var playState:PlayState;
		public static var ui2:UI2;
		
		public static var showUI:Boolean = true;
		public static var showChatAndNames:Boolean = true;
		public static var getPlacer:Boolean = false;
		
		public static var roomid:String = "";
		public static var is_fullscreen_allowed:Boolean = true;
		
		public static var EMBED_WIDTH:int = 0;
		
		public static var brickoverlayactive:Boolean = false;
		
		public static var loadingscreen_image:BitmapData;
		
		public static var bgColor:uint;
		public static var backgroundEnabled:Boolean;
		
		public static var cachedImages:Vector.<ImageBlock> = new Vector.<ImageBlock>();
		
		public static var drawableContentTest:Sprite = new Sprite();
		public static var reportTextTest:String = "";
		
		public static var inGameSettings:Boolean = false;
		
		public static var debug_stats:DebugStats;
		
		public static var currentCampId:int;
		public static var currentTierId:int;
		public static var currentTierInfo:Object = new Object();
		public static var campTiersCompleted:Array = new Array();
		
		//array of .eelvl files
		public static var worlds:Array = new Array();
		public static var worldNames:Array = new Array();
		public static var worldIndex:int = 0;
		public static var unsavedWorlds:Boolean = false;
		
		public static var isWorldManagerOpen:Boolean = false;
		
		public static function isValidWorldIndex(id:int):Boolean 
		{
			return !isNaN(id)
			&& id >= 0 && id < worlds.length
			&& id != worldIndex
			&& worldNames[id] != null;
		}

		public static function get width():int {
			//trace("Global fullWidth is: " + fullWidth);
			if(!stage) {
				return EMBED_WIDTH;//fullWidth;
			}
			if(stage.displayState == StageDisplayState.NORMAL){
				// just some debugging
				/*
				trace("return Math.min(Math.max(640,850),850);");
				trace("return Math.min(Math.max("+Config.minwidth+","+stage.stageWidth+"),"+Config.maxwidth+");");
				*/
				// if stage is less than 640, we return the smallest of 640 or 850 (eg 640). 
				// But if stage is wider than 640 we return the smallest of stage width or 850 
				// Meaning we can never go below 640 or above 850
				
				// But sites either embed with 800 or 850 in width?
				return Math.min(Math.max(Config.minwidth,stage.stageWidth),Config.maxwidth);
			}else{
				return EMBED_WIDTH;//fullWidth;
			}
		}

		public static function get height():int {
			if(!stage) 
				return fullHeight;
			if(stage.displayState == StageDisplayState.NORMAL){
				return stage.stageHeight;
			}else{
				return stage.stageHeight;
			}
		}
		
		public static function setPath(title:String, path:String = ""):void {
			if (!ExternalInterface.available) return;
			try{ ExternalInterface.call("setPath", title, path || ( "/games/" + roomid.split(" ").join("-") )); }
			catch(e:Error){ }
		}
		
		public static function toOrdinal(number:int):String {
			if (number % 100 < 10 || number % 100 >= 20) {
				switch (number % 10) {
					case 1: return number + "st";
					case 2: return number + "nd";
					case 3: return number + "rd";
				}
			}
			return number + "th";
		}
		
		public static function monthName(number:int):String {
			return ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"][number];
		}
		
		public static function toPrettyDate(date:Date):String {
			return toOrdinal(date.date) + " of " + monthName(date.month) + " " + date.fullYear;
		}
		
		public static function cleanCookie():void{
			Global.cookie.data.hotbarSmileys = [];
			Global.cookie.data.history = [];
			Global.cookie.data.keyboardKeys = [];
			if (!Global.noSave) Global.cookie.flush();
		}
		
		public static function get ping():Number {
			return 0.2; //possibility to add randomisation here
			//ie, if(Global.randomPing) return Math.random() / 10 + 0.1; // (this would be between 100ms and 200ms ping)
		}
	}
}
