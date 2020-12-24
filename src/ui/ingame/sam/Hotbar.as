package ui.ingame.sam
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	import items.ItemManager;
	import items.ItemSmiley;
	
	import sample.ui.components.Label;

	public class Hotbar extends Sprite
	{
		private var handleSmileyDown:Function;
		
		private var ui2:UI2;
		
		private var _hotbarSmileys:Array = new Array();
		
		public function Hotbar(ui2:UI2, handleSmileyDown:Function)
		{
			this.ui2 = ui2;
			
			this.handleSmileyDown = handleSmileyDown;
			
			setSmileys(Global.base.settings.smileys);
		}
		
		public function addSmiley(smiley:SmileyInstance, ox:int, oy:int) : Boolean{
			//Check if smiley doesn't already exist inside the hotbar
			for each (var i:int in _hotbarSmileys){
				var item:ItemSmiley = ItemManager.getSmileyById(i);
				if (item.id == smiley.item.id) return false;
			}
			
			if (_hotbarSmileys.length > 0) {
				for (var j:int = 0; j < numChildren; j++){
					//Smiley that is being placed on
					var sm:SmileyInstance = (getChildAt(j) as SmileyInstance);
					
					if (!sm) continue;
					var smileyRect:Rectangle = new Rectangle(sm.x, sm.y, sm.width, sm.height);
					
					//Check if it was placed ontop of a smiley
					if (!smileyRect.contains(ox, oy)) continue;
					
					for (var a:int = _hotbarSmileys.length; a > sm.index; a--){
						//Shift all index' from smileyIndex forward by one
						var currentSmiley:int = _hotbarSmileys[a];
						var nextSmiley:int = _hotbarSmileys[a - 1];
						
						_hotbarSmileys[a] = _hotbarSmileys[a - 1];
					}
					
					_hotbarSmileys[sm.index] = smiley.item.id;
					break;
				}
			}
			
			if (_hotbarSmileys.indexOf(smiley.item.id) == -1)
				_hotbarSmileys.push(smiley.item.id);
				
			//Only allow 13 smileys
			if (_hotbarSmileys.length >= 13){
				_hotbarSmileys.splice(13, _hotbarSmileys.length);
			}
		
			redrawHotbarSmileys();
			return _hotbarSmileys.indexOf(smiley.item.id) != -1;
		}
		
		public function removeSmiley(smiley:SmileyInstance) : void{
			for each (var i:int in _hotbarSmileys){
				var item:ItemSmiley = ItemManager.getSmileyById(i);
				if (item.id == smiley.item.id) {
					_hotbarSmileys.splice(smiley.index, 1);
					smiley.destroy(true);
				}
			}
			redrawHotbarSmileys();
		}
		
		public function redrawHotbarSmileys(save:Boolean = true) : void{
			//Clear all children from hotbarContainer
			removeChildren();
			
			var ox:int = 5;
			var oy:int = 5;
			
			for (var i:int = 0; i < _hotbarSmileys.length; i++){
				if (_hotbarSmileys[i] >= ItemManager.totalSmilies) continue;
				var smileyItem:ItemSmiley = ItemManager.getSmileyById(_hotbarSmileys[i]);
				var smiley:SmileyInstance = new SmileyInstance(smileyItem, this.ui2, Global.playerInstance.wearsGoldSmiley, i);
				
				smiley.x = ox;
				smiley.y = oy;
				
				smiley.scaleX = 1;
				smiley.scaleY = 1;
				
				ox += 16 + 6;
				
				addChild(smiley);
				
				smiley.hitBox.addEventListener(MouseEvent.MOUSE_DOWN, function(e:MouseEvent):void {
					handleSmileyDown(e, true);
				});
			}
			
			if (_hotbarSmileys.length == 0) {
				var dragToHotbar:Label = new Label("Save smileys by dragging them here", 12, "left", 0xFFFFFF, false, "visitor");
				dragToHotbar.x = (width - dragToHotbar.width) / 2;
				dragToHotbar.y = 12;
				addChild(dragToHotbar);
			}
			
			if (save) {
				
				//var message:Message = new Message("hotbarSmileys");
				//for (var j:int = 0; j < _hotbarSmileys.length; j++) {
					//message.add(_hotbarSmileys[j]);
				//}
				//trace("sending", message)
				//ui2.connection.sendMessage(message);
				Global.base.settings.smileys = _hotbarSmileys;
				if (!Global.cookie.data.settings) Global.cookie.data.settings = new Object();
				Global.cookie.data.settings.smileys = _hotbarSmileys;
			}
		}
		
		public function setSmileys(smileys:Array):void {
			if (smileys.length == 0) return;
			_hotbarSmileys = smileys;
			redrawHotbarSmileys(false);
		}
		
		public function get hotbarSmileys() : Array{
			return _hotbarSmileys;
		}
		
		public override function get height() : Number{
			return 36;
		}
	}
}
