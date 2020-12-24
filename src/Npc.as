package 
{
	import blitter.Bl;
	import flash.display.BitmapData;
	import flash.geom.Point;
	import io.player.tools.Badwords;
	import items.ItemId;
	import items.ItemManager;
	import items.ItemNpc;
	import states.PlayState;
	
	public class Npc
	{
		private var _name:String;
		private var _messages:Array;
		private var _loc:Point;
		private var item:ItemNpc;
		
		private var chat:Chat;
		private var curChat:int = -1;
		
		public var messagesEmpty:Boolean = false;
		
		public function Npc(name:String, messages:Array, location:Point, item:ItemNpc) 
		{
			_name = name;
			_messages = messages;
			_loc = location;
			this.item = item;
			chat = new Chat(name);
			messagesEmpty = messages[0] == "" && messages[1] == "" && messages[2] == "";
		}
		
		public function get isTalking():Boolean {
			return curChat != -1;
		}
		
		public function get name():String {
			return _name;
		}
		
		public function get messages():Array {
			return _messages;
		}
		
		public function get location():Point {
			return _loc;
		}
		
		public function drawName(target:BitmapData, ox:Number, oy:Number):void {
			if (Global.showUI && !Global.base.settings.hideUsernames && name != "") chat.drawNpcName(target, ox + location.x * 16, oy + location.y * 16);
		}
		
		public function drawChat(target:BitmapData, ox:Number, oy:Number):void {
			if (messagesEmpty) return;
			if (item != null && curChat > -1) oy += item.bubbleOffset;
			chat.drawNpcChat(target, ox + location.x * 16, oy + location.y * 16, curChat == -1);
		}
		
		public function equals(toCompare:Npc):Boolean {
			return name == toCompare.name && location.equals(toCompare.location) &&
					messages[0] == toCompare.messages[0] &&
					messages[1] == toCompare.messages[1] &&
					messages[2] == toCompare.messages[2];
		}
		
		public function reset():void {
			curChat = -1;
			chat.clearChats();
		}
		
		public function sayNext():void {
			curChat++;
			var mes:String = getNextMessage();
			if (mes == "") 
				reset();
			else 
				chat.say(TextBubble.richMessage(mes, false));//fixed.
		}
		
		private function getNextMessage():String {
			for (var i:int=curChat; i<messages.length; i++) 
				if (messages[i] != "") return messages[i];
				else curChat++;
			return "";
		}
		
		public function setAsDefault():void {
			Bl.data.npc_name = name;
			Bl.data.npc_mes1 = messages[0];
			Bl.data.npc_mes2 = messages[1];
			Bl.data.npc_mes3 = messages[2];
		}
		
		public static function getNextNpcID(block:int, increase:Boolean = true):int {
			//block is not npc or user can't use current npc. (it will loop forever if user doesn't have at least 1 npc)
			if (!ItemId.isNPC(block) || !Global.base.canUseBlock(ItemManager.getBrickById(block))) return block;
			var blockFound:Boolean = false;
			var index:int = ItemId.NpcArray.indexOf(block);
			do {
				increase?index++:index--;
				if (increase && index >= ItemId.NpcArray.length) index = 0;
				if (!increase && index < 0) index = ItemId.NpcArray.length - 1;
				if (Global.base.canUseBlock(ItemManager.getBrickById(ItemId.NpcArray[index])))
					blockFound = true;
			} while (!blockFound);
			return ItemId.NpcArray[index];
		}
		
		private static function richMessage(orig:String):String {
			var player:Player = (Global.base.state as PlayState).player;
			var text:String = orig;
			
			text = text.replace(/%coins%/g, player.coins);
			text = text.replace(/%bcoins%/g, player.bcoins);
			text = text.replace(/%deaths%/g, player.deaths);
			text = text.replace(/%levelname%/g, Global.currentLevelname);
			
			text = text.replace(/%username%/g, player.name);
			text = text.replace(/%Username%/g, player.name.substring(0, 1).toUpperCase() + player.name.substr(1));
			text = text.replace(/%USERNAME%/g, player.name.toUpperCase());
			//text = text.replace(/\\n/g, "\n"); //crashes the game and doesn't really make sense.
			
			text = Badwords.Filter(text);
			
			return text;
		}
		
	}

}