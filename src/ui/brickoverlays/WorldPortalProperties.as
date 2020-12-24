package ui.brickoverlays
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.utils.Timer;
	import blitter.Bl;
	import ui2.ui2minusbtn;
	import ui2.ui2plusbtn;
	
	public class WorldPortalProperties extends PropertiesBackground{
		
		private var worldname_timer:Timer; 
		
		private var tfwname:TextField;
		private var inptfwid:TextField;
		private var inptfwtarget:TextField;
		
		private var myWorldOffset:int = 0;
		
		public function WorldPortalProperties() {
			
			setSize(320, 100);
			
			var container:Sprite = new Sprite();
			addChild(container);
			
			var tff:TextFormat = new TextFormat("system",12,0xffffff);
			
			var tfwid:TextField = new TextField();
			tfwid.embedFonts = true;
			tfwid.selectable = false;
			tfwid.sharpness = 100;
			tfwid.multiline = false;
			tfwid.wordWrap = false;	
			tfwid.defaultTextFormat = tff;
			tfwid.width = 150;
			tfwid.x = -150;
			tfwid.y = -39-50;
			tfwid.text = "Target World ID:";
			tfwid.height = tfwid.textHeight;
			container.addChild(tfwid);
			
			inptfwid = new TextField();
			inptfwid.type = TextFieldType.INPUT;
			inptfwid.x = 83;
			inptfwid.y = -39-50;
			inptfwid.width = 50;
			inptfwid.height = tfwid.height+3;
			inptfwid.selectable = true;
			inptfwid.sharpness = 100;
			inptfwid.multiline = false
			inptfwid.borderColor = 0xffffff;
			inptfwid.backgroundColor = 0xAAAAAA;
			inptfwid.background = true;
			inptfwid.border = true;
			inptfwid.restrict = "0-9";
			inptfwid.maxChars = 1;
			var inptffwid:TextFormat = new TextFormat("Arial", 12, 0x0, null, null, null, null, null, TextFormatAlign.CENTER);
			//inptffwid.blockIndent = 5;
			inptfwid.defaultTextFormat = inptffwid;
			updateWorldIdTf();
			
			container.addChild(inptfwid);
			
			inptfwid.addEventListener(KeyboardEvent.KEY_DOWN, function(e:KeyboardEvent):void{
				e.preventDefault();
				e.stopImmediatePropagation();
				e.stopPropagation();
			});
			
			inptfwid.addEventListener(KeyboardEvent.KEY_UP, function(e:KeyboardEvent):void {
				e.preventDefault();
				e.stopImmediatePropagation();
				e.stopPropagation();
			});
			
			var addwid:ui2plusbtn = new ui2plusbtn();
			addwid.y = inptfwid.y+9;
			addwid.x = inptfwid.x + inptfwid.width + 12;
			container.addChild(addwid);
			
			addwid.addEventListener(MouseEvent.MOUSE_DOWN, function():void {
				if (Bl.data.world_portal_id < Global.worlds.length - 1) {
					Bl.data.world_portal_id++;
					updateWorldIdTf();
					loadWorldName();
				}
			});
			
			var subwid:ui2minusbtn = new ui2minusbtn();
			subwid.y = inptfwid.y+9;
			subwid.x = inptfwid.x - 12;
			container.addChild(subwid);
			
			subwid.addEventListener(MouseEvent.MOUSE_DOWN, function():void {
				if (Bl.data.world_portal_id > 0) {
					Bl.data.world_portal_id--;
					updateWorldIdTf();
					loadWorldName();
				}
			});
			
			inptfwid.addEventListener(Event.CHANGE, function():void{
				tfwn.text = "World Name: ";
				inptfwid.maxChars = (Global.worldNames.length-1).toString().length;
				var wid:int = parseInt(inptfwid.text);
				if(inptfwid.text.length == 0) Bl.data.world_portal_id = Global.worldIndex;
				else if(Global.isValidWorldIndex(wid)) {
					Bl.data.world_portal_id = wid;
				}
				updateWorldIdTf();
				loadWorldName();
			});
			
			var tfwn:TextField = new TextField();
			tfwn.embedFonts = true;
			tfwn.selectable = false;
			tfwn.sharpness = 100;
			tfwn.multiline = false;
			tfwn.wordWrap = false;	
			tff.align = TextFormatAlign.LEFT;
			tfwn.defaultTextFormat = tff;
			tfwn.text = "World Name:";
			tfwn.width = 150;
			tfwn.height = tfwn.textHeight;
			tfwn.x = -150;
			tfwn.y = -39-25;
			container.addChild(tfwn)	
			
			tfwname = new TextField();
			
			tfwname.embedFonts = true;
			tfwname.selectable = false;
			tfwname.sharpness = 100;
			tfwname.multiline = false;
			tfwname.wordWrap = false;
			tff.align = TextFormatAlign.RIGHT;
			tfwname.defaultTextFormat = tff;
			tfwname.width = 200;
			tfwname.height = 30;
			tfwname.x = -50;
			tfwname.y = -39-25;
			loadWorldName();
			container.addChild(tfwname);
			
			var tfwtarget:TextField = new TextField();
			tfwtarget.embedFonts = true;
			tfwtarget.selectable = false;
			tfwtarget.sharpness = 100;
			tfwtarget.multiline = false;
			tfwtarget.wordWrap = false;
			tff.align = TextFormatAlign.LEFT;
			tfwtarget.defaultTextFormat = tff;
			tfwtarget.width = 200;
			tfwtarget.x = -150;
			tfwtarget.y = -39;
			tfwtarget.text = "Target Spawn Point ID:";
			tfwtarget.height = tfwtarget.textHeight;
			container.addChild(tfwtarget);
			
			inptfwtarget = new TextField();
			inptfwtarget.type = TextFieldType.INPUT;
			inptfwtarget.x = 83;
			inptfwtarget.y = -39;
			inptfwtarget.width = 50;
			inptfwtarget.height = tfwtarget.height + 3;
			inptfwtarget.selectable = true;
			inptfwtarget.sharpness = 100;
			inptfwtarget.multiline = false
			inptfwtarget.borderColor = 0xffffff;
			inptfwtarget.backgroundColor = 0xAAAAAA;
			inptfwtarget.background = true;
			inptfwtarget.border = true;
			inptfwtarget.restrict = "0-9";
			inptfwtarget.maxChars = 5;
			var inptffwtarget:TextFormat = new TextFormat("Arial", 12, 0x0, null, null, null, null, null, TextFormatAlign.CENTER);
			//inptffwtarget.blockIndent = 5;
			inptfwtarget.defaultTextFormat = inptffwtarget;
			updateSpawnTargetTf();
			
			container.addChild(inptfwtarget);
			
			inptfwtarget.addEventListener(KeyboardEvent.KEY_DOWN, function(e:KeyboardEvent):void {
				e.preventDefault();
				e.stopImmediatePropagation();
				e.stopPropagation();
			});
			
			inptfwtarget.addEventListener(KeyboardEvent.KEY_UP, function(e:KeyboardEvent):void {
				e.preventDefault();
				e.stopImmediatePropagation();
				e.stopPropagation();
			});
			
			inptfwtarget.addEventListener(Event.CHANGE, function(e:Event):void {
				var sid:int = parseInt(inptfwtarget.text);
				if(!isNaN(sid) && sid >= 0 && sid <= 99999) {
					Bl.data.world_portal_target = sid;
				}
				updateSpawnTargetTf();
			});
			
			var addwtarget:ui2plusbtn = new ui2plusbtn();
			addwtarget.y = inptfwtarget.y + 9;
			addwtarget.x = inptfwtarget.x + inptfwtarget.width + 12;
			container.addChild(addwtarget);
			
			addwtarget.addEventListener(MouseEvent.MOUSE_DOWN, function():void {
				if (Bl.data.world_portal_target < 99999) {
					Bl.data.world_portal_target++;
					updateSpawnTargetTf();
				}
			});
			
			var subwtarget:ui2minusbtn = new ui2minusbtn();
			subwtarget.y = inptfwtarget.y + 9;
			subwtarget.x = inptfwtarget.x - 12;
			container.addChild(subwtarget);
			
			subwtarget.addEventListener(MouseEvent.MOUSE_DOWN, function():void {
				if (Bl.data.world_portal_target > 0) {
					Bl.data.world_portal_target--;
					updateSpawnTargetTf();
				}
			});
		}
		
		private function loadWorldName():void
		{
			//tfwname.text = "Loading...";
			var id:int = Bl.data.world_portal_id;
			if(Global.isValidWorldIndex(id))
				tfwname.text = Global.worldNames[id];
			else if (id == Global.worldIndex) tfwname.text = Global.currentLevelname;
			else tfwname.text = "No such world"
		}
		
		private function updateSpawnTargetTf():void
		{
			if (Bl.data.world_portal_target > 0) {
				inptfwtarget.text = Bl.data.world_portal_target;
			} else {
				inptfwtarget.text = "Default";
			}
		}
		private function updateWorldIdTf():void
		{
			if (Bl.data.world_portal_id != Global.worldIndex) {
				inptfwid.text = Bl.data.world_portal_id;
			} else {
				inptfwid.text = "Current";
			}
		}
	}
}