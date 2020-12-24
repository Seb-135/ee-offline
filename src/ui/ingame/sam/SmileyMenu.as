package ui.ingame.sam
{
	import blitter.Bl;
	
	import com.greensock.TweenMax;
	import com.greensock.easing.Back;
	import com.greensock.easing.Expo;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.filters.DropShadowFilter;
	import flash.geom.Rectangle;
	import flash.ui.Mouse;
	import flash.utils.Timer;
	import flash.utils.clearInterval;
	import flash.utils.setTimeout;
	
	import items.ItemManager;
	import items.ItemSmiley;
	
	import mx.utils.StringUtil;
	
	import sample.ui.components.Label;
	
	import ui.HoverLabel;
	
	public class SmileyMenu extends Sprite
	{
		private var smileyContainer:Sprite;
		
		private var smileyContainerWidth:int = 240;
		private var hotbarContainerHeight:int = 35;
		private var smileyContainerHeight:Number;
		
		private var horSpacing:int = 5;
		private var verSpacing:int = 5;
		
		public var smilies:Array;
		
		private var ui2:UI2;
		
		private var movingSmiley:SmileyInstance;
		private var movingSmileyFromHotbar:Boolean;
		
		private var mouseDown:Boolean;
		
		public var hotbar:Hotbar;
		
		private var searchBar:SearchBar;
		
		private var goldBordersToggle:GoldBordersToggle;

		public function SmileyMenu(ui2:UI2) {
			visible = false;
			
			this.ui2 = ui2;
			
			smilies = [];
			
			goldBordersToggle = new GoldBordersToggle();
			goldBordersToggle.addEventListener(MouseEvent.CLICK, toggleGoldBorders);
			addChild(goldBordersToggle);
			
			updateGoldBordersButton();
			
			searchBar = new SearchBar(this);
			addChild(searchBar);
			
			smileyContainer = new Sprite();
			addChild(smileyContainer);
			
			hotbar = new Hotbar(this.ui2, handleSmileyDown);
			addChild(hotbar);
			
			addEventListener(Event.ADDED_TO_STAGE, handleAddedToStage);
		}
		
		private function updateGoldBordersButton() : void {
			var target:Player = Global.playState.target as Player;
			if (target != null && target != Global.playState.player)
				goldBordersToggle.setActive(target.wearsGoldSmiley);
			else goldBordersToggle.setActive(Global.playerInstance.wearsGoldSmiley);
		}
		
		public function addSmiley(sm:SmileyInstance) : void{
			//Make sure 'smilies' doesn't already contain that smiley (just in case)
			for (var i:int = 0; i < smilies.length; i++){
				if ((smilies[i] as SmileyInstance).item.id == sm.item.id)
					return;
			}
			
			smilies.push(sm);
			smileyContainer.addChild(sm);
				
			sm.hitBox.addEventListener(MouseEvent.MOUSE_DOWN, function(e:MouseEvent):void {
				handleSmileyDown(e, false);
			});
		}
		
		public function setSelectedSmiley(id:int) : void{
			if (smilies[id] == null) id = 0;
		}
		
		public function doEmpty():void {
			for (var i:int = 0; i < smilies.length; i++) {
				if (smilies[i]) SmileyInstance(smilies[i]).destroy();
				
			}
			smilies = [];
		}
		
		public function getSmileyInstanceByItemId(id:int):SmileyInstance {
			for (var i:int = 0; i < smilies.length; i++) {
				if (smilies[i] && SmileyInstance(smilies[i]).item.id == id) return SmileyInstance(smilies[i]);
			}
			return smilies[0] as SmileyInstance;
		}
		
		public function redraw(smileys:Array = null, text:String = "") : void{
			while (smileyContainer.numChildren > 0) {
				smileyContainer.removeChildAt(0);
			}
			
			if (smilies.length > 130) {
				horSpacing = 4;
				smileyContainerWidth = 296;
			}
			else smileyContainerWidth = 240;
			
			searchBar.oWidth = smileyContainerWidth + 1 - (goldBordersToggle?goldBordersToggle.width:0);
			
			//0 = searchSmiley array == 0
			//1 = text.length !> 0
			
			if (text.length == 0){
				//Draw all smileys
				redrawSmileyPositions(smilies);
			} else {
				if (smileys.length <= 0 && text.length > 0){
					var noSmilies:Label = new Label("No smileys found...", 12, "left", 0xFFFFFF, false, "visitor");
					noSmilies.x = (smileyContainerWidth - noSmilies.width) / 2;
					noSmilies.y = 3;
					smileyContainer.addChild(noSmilies);
					
					smileyContainerHeight = (noSmilies.height + 5);
				} else {
					//Draw all smileys from search text
					redrawSmileyPositions(smileys);
				}
			}
			
			//Draw the container for the smileys
			smileyContainer.graphics.clear();
			smileyContainer.graphics.lineStyle(1, 0x7B7B7B, 1);
			smileyContainer.graphics.beginFill(0x323232, 1);
			smileyContainer.graphics.drawRect(0, 0, smileyContainerWidth, smileyContainerHeight);
			smileyContainer.graphics.endFill();
			
			var showAuraContainer:Boolean = (Bl.data.canToggleGodMode && !Bl.data.isOpenWorld);
			
			
			searchBar.y = -searchBar.oHeight;
			
			if (goldBordersToggle) {
				goldBordersToggle.x = smileyContainerWidth - goldBordersToggle.width + 1;
				goldBordersToggle.y = searchBar.y;
			}
			
			hotbar.graphics.clear();
			hotbar.graphics.lineStyle(1, 0x7B7B7B);
			hotbar.graphics.beginFill(0x323232, 1);
			hotbar.y = smileyContainerHeight;
			hotbar.graphics.drawRect(0, 0, smileyContainerWidth, hotbarContainerHeight);
			hotbar.graphics.endFill();
			
			x = smilies.length > 130 ? 10: 25;
			y = -((smileyContainer.y + (hotbar.y + hotbar.height)) + 29);
			
			//DebugTools.outlineChildren(this);
		}
		
		private function redrawSmileyPositions(smileys:Array):void {
			var ox:int = verSpacing - 2;
			var oy:int = (smileyContainer.y) + horSpacing - 2;
			
			if (smileys.length <= 0) return;
			
			for (var i:int = 0; i < smileys.length; i++){
				if (!smileys[i]) continue;
				
				var smiley:SmileyInstance = (smileys[i] as SmileyInstance);
				smiley.updateBorder(Global.playerInstance.wearsGoldSmiley);
				
				smiley.scaleImage(smiley, 1, 0);
				
				if (!smiley) continue;
				
				if ((ox + 18 + horSpacing) >= smileyContainerWidth){
					ox = horSpacing;
					oy += 18 + verSpacing;
				}
				
				smiley.x = ox;
				smiley.y = oy;
				
				ox += 18 + horSpacing;
				
				smileyContainer.addChild(smiley);
			}
			
			smileyContainerHeight = (smileys[smileys.length - 1].y + 18) + verSpacing * 3;
		}
		
		private function toggleGoldBorders(e:MouseEvent):void {
			var target:Player = Global.playState.target as Player;
			if (target != null && target != Global.playState.player)
				Global.base.setGoldBorder(!target.wearsGoldSmiley);
			else Global.base.setGoldBorder(!Global.playerInstance.wearsGoldSmiley);
		}
		
		protected function handleSmileyDown(e:MouseEvent, isFromHotbar:Boolean):void {
			mouseDown = true;
			movingSmileyFromHotbar = isFromHotbar;
			
			var smiley:SmileyInstance = (e.target.parent as SmileyInstance);
			
			if (movingSmiley) 
				movingSmiley.destroy(true);
				
			movingSmiley = new SmileyInstance(smiley.item, this.ui2, Global.playerInstance.wearsGoldSmiley, smiley.index, false);
			
			this.ui2.setSelectedSmiley(smiley.item.id);
		}
		
		protected function handleSmileyMove(e:MouseEvent):void {
			if (!mouseDown) {
				if (movingSmiley) 
					movingSmiley.destroy(true);
				return;
			}
			if (!movingSmiley) return;
			
			//Hide the mouse so you can see the smiley
			Mouse.hide();
			
			//Centering the smiley to the mouse
			movingSmiley.x = mouseX - (movingSmiley.width / 2);
			movingSmiley.y = mouseY - (movingSmiley.height / 2);
		
			if (movingSmiley.scaleX != 2)
				movingSmiley.scaleX = 2;
			if (movingSmiley.scaleY != 2)
				movingSmiley.scaleY = 2;
			
			if (!contains(movingSmiley))
				addChild(movingSmiley);
		}
		
		protected function handleSmileyLetGo(e:MouseEvent):void {
			if (!mouseDown) return;
			
			Mouse.show();
			
			//The smiley that is being dragged
			var draggingSmiley:SmileyInstance = (e.target.parent as SmileyInstance);
			
			if (!draggingSmiley) {
				mouseDown = false;
				return;
			}
			var hotbarRectangle:Rectangle = new Rectangle(0, 0, smileyContainerWidth, hotbarContainerHeight);
			
			var added:Boolean = false;
			//Placed inside the hotbar rectangle
			if (hotbarRectangle.contains(hotbar.mouseX, hotbar.mouseY))
				added = hotbar.addSmiley(draggingSmiley, hotbar.mouseX, hotbar.mouseY);
			else if (movingSmileyFromHotbar)
				hotbar.removeSmiley(draggingSmiley); //If the smiley being dragged was dragged from the hotbar
			
			if (contains(draggingSmiley) && !smileyContainer.contains(draggingSmiley) && !hotbar.contains(draggingSmiley))
				draggingSmiley.destroy(!added);
				
			mouseDown = false;
		}
		
		protected function handleAddedToStage(e:Event):void {
			removeEventListener(Event.ADDED_TO_STAGE, handleAddedToStage);
			
			redraw();
			hotbar.redrawHotbarSmileys(false);
			
			stage.addEventListener(MouseEvent.MOUSE_MOVE, handleSmileyMove);
			stage.addEventListener(MouseEvent.MOUSE_UP, handleSmileyLetGo);
		}
		
		public function updateAllSmileyBorders(value:Boolean):void {
			this.ui2.smileyButton.smiley.updateBorder(value);
			hotbar.redrawHotbarSmileys(false);
			updateGoldBordersButton();
			
			for (var i:int = 0; i < smileyContainer.numChildren; i++){
				if (smileyContainer && smileyContainer.getChildAt(i) && smileyContainer.getChildAt(i) is SmileyInstance)
					(smileyContainer.getChildAt(i) as SmileyInstance).updateBorder(value);
			}
		}
	}
}
