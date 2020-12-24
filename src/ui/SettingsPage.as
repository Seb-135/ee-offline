package ui
{
	import blitter.Bl;
	import com.greensock.plugins.ColorMatrixFilterPlugin;
	import flash.events.Event;
	import flash.filters.ColorMatrixFilter;
	
	import com.greensock.TweenMax;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.FocusEvent;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.*;
	import flash.text.TextFieldType;
	import flash.utils.clearInterval;
	import flash.utils.setTimeout;
	
	import items.ItemAuraColor;
	import items.ItemAuraShape;
	import items.ItemManager;
	import items.ItemSmiley;
	
	import sample.ui.components.Label;
	
	import states.LobbyState;
	import states.LobbyStatePage;
	import states.PlayState;
	
	import ui.*;
	import ui.ingame.sam.AuraColorButton;
	import ui.ingame.sam.AuraInstance;
	import ui.ingame.sam.SmileyInstance;
	
	import items.ItemBrick;
	
	public class SettingsPage extends assets_settingsitem
	{
		[Embed(source="/../media/arrows.png")] private static var Arrows:Class;
		public static var arrowsBMD:BitmapData = new Arrows().bitmapData;
		
		private var smileys:Vector.<SmileyInstance> = new Vector.<SmileyInstance>();
		private var auras:Vector.<AuraInstance> = new Vector.<AuraInstance>();
		
		private var currentSmiley:SmileyInstance;
		private var currentAura:AuraInstance;
		
		private var smileyId:int = 0;
		private var auraId:int = 0;
		
		private var minimapTransparentValue:Number;
		
		private var greenOnMinimap:Boolean;
		private var blockPicker:Boolean;
		private var wordFilter:Boolean;
		private var hideChatBubbles:Boolean;
		private var hideProfile:Boolean;
		private var hideUsernames:Boolean;
		private var particlesEnabled:Boolean;
		private var blockInvites:Boolean;
		private var packageNames:Boolean;
		private var collapsedMode:Boolean;
		private var coloredUsernames:Boolean;
		private var first:Boolean = true;
		
		private var ss:UI2;
		
		private var hoverlabel:HoverLabel;
		private var hovertimer:uint;
		
		private var currentHover:*;
		
		private var names:Array = ["minimap","particles","transparent","chatbubbles","packagenames","vrows","collapsed","blockpicker"];
		
		private var closeButton:ProfileCloseButton;
		
		private var blackBG:BlackBG;
		
		private var that:SettingsPage;
		
		private var ui2:UI2;
		
		private var buttonsContainer:Sprite;
		
		private var minRows:int = 3;
		private var maxRows:int = 10;
		private var currentRows:int = Global.base.settings.visibleRows;
		
		private var keyBindingsMenu:KeyBindingsMenu;
		
		public function SettingsPage(ui2:UI2 = null) : void
		{
			that = this;
			
			this.ui2 = ui2;
			
			hoverlabel = new HoverLabel(250);
			hoverlabel.visible = false;
			
			gotoAndStop(1);
			ss = Global.base.ui2instance;
			
			minimapTransparency.restrict = "0-9 %";
			
			blackBG = new BlackBG();
			blackBG.y = -50;
			blackBG.x = -50;
			addChildAt(blackBG, 0);
			
			closeButton = new ProfileCloseButton();
			closeButton.x = x + bg.width - closeButton.width/2;
			closeButton.y = y - closeButton.height/2;
			closeButton.addEventListener(MouseEvent.CLICK, handleCloseButton);
			addChild(closeButton);
			
			visibleRowsNum.selectable = false;
			visibleRowsNum.text = "" + currentRows;
			
			initCheckBoxStates();
			initEventListeners();
			
			this.addEventListener(MouseEvent.MOUSE_DOWN, function(e:MouseEvent):void{
				e.preventDefault();
				e.stopImmediatePropagation()
				e.stopPropagation();
			})
			
			this.addEventListener(KeyboardEvent.KEY_DOWN, function(e:KeyboardEvent):void{
				e.preventDefault();
				e.stopImmediatePropagation()
				e.stopPropagation();
			})
		}
		
		private function initCheckBoxStates() : void
		{
			greenOnMinimap = Global.base.settings.greenOnMinimap;
			greenOnMinimapCheck.gotoAndStop(int(greenOnMinimap) + 1);
			
			minimapTransparentValue = (100 - Global.base.settings.minimapAlpha * 100);
			minimapTransparency.text = Math.ceil(minimapTransparentValue) + "%";
			
			hideChatBubbles = Global.base.settings.hideBubbles;
			hideChatBubblesCheck.gotoAndStop(int(hideChatBubbles) + 1);
			
			particlesEnabled = Global.base.settings.particles;
			particleCheck.gotoAndStop(int(particlesEnabled) + 1);
			
			packageNames = Global.base.settings.showPackageNames;
			packageNamesCheck.gotoAndStop(int(packageNames) + 1);
			
			currentRows = Global.base.settings.visibleRows;
			visibleRowsNum.text = Global.base.settings.visibleRows.toString();
			
			collapsedMode = Global.base.settings.collapsed;
			collapsedCheck.gotoAndStop(int(collapsedMode) + 1);
			
			blockPicker = Global.base.settings.blockPicker;
			blockPickerCheck.gotoAndStop(int(blockPicker) + 1);
		}
		
		protected function handleChangeRowsCount(e:MouseEvent) : void{
			trace(e.target);
			switch (e.target){
				case visibleRowsRemove:{
					setRows(-1);
				} break;
				
				case visibleRowsAdd:{
					setRows(1);
				} break;
			}
		}
		
		private function setRows(value:int) : void{
			currentRows += value;
			currentRows = Math.max(minRows, Math.min(currentRows, maxRows));
			
			visibleRowsNum.text = "" + currentRows;
			
			Global.base.settings.visibleRows = currentRows;
			
			if (this.ui2 != null) {
				this.ui2.updateSelectorBricks();
			}
		}
		
		private function initEventListeners() : void
		{
			particleCheck.addEventListener(MouseEvent.CLICK, handleCheckBoxes);
			greenOnMinimapCheck.addEventListener(MouseEvent.CLICK, handleCheckBoxes);
			minimapTransparency.addEventListener(KeyboardEvent.KEY_DOWN, handleKeyPresses);
			minimapTransparency.addEventListener(FocusEvent.FOCUS_IN, handleTransparencyBox);
			minimapTransparency.addEventListener(FocusEvent.FOCUS_OUT, handleTransparencyBox);
			
			hideChatBubblesCheck.addEventListener(MouseEvent.CLICK, handleCheckBoxes);

			packageNamesCheck.addEventListener(MouseEvent.CLICK, handleCheckBoxes);
			collapsedCheck.addEventListener(MouseEvent.CLICK, handleCheckBoxes);
			
			visibleRowsRemove.addEventListener(MouseEvent.CLICK, handleChangeRowsCount);
			visibleRowsAdd.addEventListener(MouseEvent.CLICK, handleChangeRowsCount);
			
			blockPickerCheck.addEventListener(MouseEvent.CLICK, handleCheckBoxes);
			
			for (var i:int = 0; i < names.length; i++){
				var name:String = "tf_" + names[i];
				
				var object:* = getChildByName("tf_" + names[i]);
				object.addEventListener(MouseEvent.MOUSE_OVER, handleMouse);
				object.addEventListener(MouseEvent.MOUSE_OUT, handleMouse);
				object.addEventListener(MouseEvent.MOUSE_MOVE, handleMouseMove);
			}
			
			btnKeybindings.addEventListener(MouseEvent.CLICK, handleKeyBindings);
			btnSaveHotbar.addEventListener(MouseEvent.CLICK, saveHotBar);
			btnLoadHotbar.addEventListener(MouseEvent.CLICK, loadHotBar);
			addEventListener(Event.REMOVED_FROM_STAGE, closeKeyBindings);
		}
		
		private var ox:Number = 0;
		private var oy:Number = 0;
		private function addColor(button:AuraColorButton) : void{
			button.x = ox;
			button.y = oy;
			
			ox += 13;
			
			button.useHandCursor = true;
			button.mouseEnabled = true;
			button.buttonMode = true;
			buttonsContainer.addChild(button);
		}
		
		private function handleCheckBoxes(e:MouseEvent) : void
		{
			switch (e.target)
			{
				case greenOnMinimapCheck:
				{
					greenOnMinimap = !greenOnMinimap;
					greenOnMinimapCheck.gotoAndStop(int(greenOnMinimap) + 1);
					Global.base.settings.greenOnMinimap = greenOnMinimap;
				}
				break;
				case blockPickerCheck:
				{
					blockPicker = !blockPicker;
					blockPickerCheck.gotoAndStop(int(blockPicker) + 1);
					Global.base.settings.blockPicker = blockPicker;
				}
				break;
				case hideChatBubblesCheck:
				{
					hideChatBubbles = !hideChatBubbles;
					hideChatBubblesCheck.gotoAndStop(int(hideChatBubbles) + 1);
					Global.base.settings.hideBubbles = hideChatBubbles;
				}
				break;
				case particleCheck:
				{
					particlesEnabled = !particlesEnabled;
					particleCheck.gotoAndStop(int(particlesEnabled) + 1);
					Global.base.settings.particles = particlesEnabled;
				}
				break;
				
				case packageNamesCheck:
				{
					packageNames = !packageNames;
					packageNamesCheck.gotoAndStop(int(packageNames) + 1);
					Global.base.settings.showPackageNames = packageNames;
					
					if (this.ui2 != null) {
						this.ui2.updateSelectorBricks();
					}
				}
				break;
				case collapsedCheck:{
					collapsedMode = !collapsedMode;
					collapsedCheck.gotoAndStop(int(collapsedMode) + 1);
					Global.base.settings.collapsed = collapsedMode;
					
					if (this.ui2 != null) {
						this.ui2.updateSelectorBricks();
					}
				} break;
			}
		}
		
		private function handleKeyPresses(e:KeyboardEvent) : void
		{
			switch (e.target)
			{
				case minimapTransparency:
				{
					if (e.keyCode == 13)
						setTransparency();
				}
				break;
			}
		}
		
		private function handleTransparencyBox(e:FocusEvent):void {
			if (e.type == FocusEvent.FOCUS_OUT) setTransparency();
		}
		
		private function setTransparency():void {
			stage.stageFocusRect = false;
			stage.focus = this;
			
			if (minimapTransparency.text.length > 0){
				var maxValue:int = 90;
				var a:int = int(minimapTransparency.text.replace("%",""));
				
				if (a > 90) a = 90;
				if (a < 1)  a = 1
				
				var value:int = (100 - a);
				
				
				trace("Entered Value: " + a + " | Actual Value: " + value + " | Alpha Value: " + (value / 100));
				minimapTransparency.text = a + "%";
				Global.base.settings.minimapAlpha = value / 100;
				trace("alpha:", value);
				(Global.base.state as PlayState).minimap.setAlpha(Global.base.settings.minimapAlpha);
			}
		}
		private function handleKeyBindings(e:MouseEvent):void {
			if (keyBindingsMenu) return;
			
			keyBindingsMenu = new KeyBindingsMenu(closeKeyBindings);
			keyBindingsMenu.x = (bg.width - keyBindingsMenu.initW) / 2;
			keyBindingsMenu.y = (bg.height - keyBindingsMenu.initH) / 2;
			addChild(keyBindingsMenu);
			closeButton.visible = false;
			
			keyBindingsMenu.graphics.beginFill(0x121212, .67);
			keyBindingsMenu.graphics.drawRect(-keyBindingsMenu.x + 10, -keyBindingsMenu.y + 10, bg.width - 20, bg.height - 20);
		}
		
		private function saveHotBar(e:MouseEvent):void {
			if (!Global.cookie.data.settings) Global.cookie.data.settings = new Object();
			var blockIDs:Array = Global.ui2.favoriteBricks.blockIDs;
			Global.base.settings.savedBlocks = blockIDs;
			Global.cookie.data.settings.savedBlocks = blockIDs;
		}
		
		private function loadHotBar(e:MouseEvent):void {
			var def:Vector.<ItemBrick> = new Vector.<ItemBrick>();
			
			def.push(ItemManager.getBrickById(0));
			for (var i:int = 0; i < 10; i++)
				def.push(ItemManager.getBrickById(Global.base.settings.savedBlocks[i]));
			
			Global.ui2.favoriteBricks.setDefaults(def);
		}
		
		public function closeKeyBindings(e:Event = null):void {
			if (keyBindingsMenu) removeChild(keyBindingsMenu);
			keyBindingsMenu = null;
			closeButton.visible = true;
		}
		
		private function addSmiley(si:SmileyInstance) : void{
			smileys.push(si);
		}
		
		private function addAura(ai:AuraInstance) : void{
			auras.push(ai);
		}
		
		protected function scaleImage(object:*, scale:Number):void
		{
			TweenMax.to(object, 0, {
				scaleX:scale,
				scaleY:scale
			});			
		}
		
		private function handleMouse(e:MouseEvent):void{
			if (e.type == MouseEvent.MOUSE_OVER) {
				if (currentHover != e.target && (e.target.parent && (e.target.parent != buttonsContainer)))
					currentHover = e.target;
				hovertimer = setTimeout(showHoverLabel, 800);
			} else {
				hoverlabel.visible = false;
				clearInterval(hovertimer);
			}
		}
		
		protected function handleMouseMove(event:MouseEvent = null):void
		{
			if (hoverlabel.visible) {
				hoverlabel.draw(getTextFromCurrentObject(currentHover));
				
				hoverlabel.x = parent.mouseX;
				if (hoverlabel.x > (Config.width - hoverlabel.w - 13))
				{
					hoverlabel.x -= (hoverlabel.w + 12);
				} else {
					hoverlabel.x += 12;
				}
				hoverlabel.y = parent.mouseY-(hoverlabel.height/2);
			}
		}
		
		public function showHoverLabel():void
		{
			parent.addChild(hoverlabel);
			hoverlabel.alpha = 0;
			TweenMax.to(hoverlabel, 0.25, {alpha:1});
			hoverlabel.draw("" + getTextFromCurrentObject(currentHover));
			hoverlabel.visible = true;
			handleMouseMove();
		}
		
		public function getTextFromCurrentObject(object:*) : String{
			switch (object)
			{
				case tf_minimap:{
					return "Toggle whether you see your trail as green on the minimap.";
				} break;
				
				case this.tf_blockpicker:{
					return "Do you like working quickly by using the block picker, but you want to do boss levels as well? Turn the block picker on or off here.";
				} break;
				
				case this.tf_particles:{
					return "Enable/disable some fancy animations ingame. Note: enabling this can cause some performance issues on slower computers.";
				} break;
				
				case this.tf_transparent:{
					return "Enable a custom amount of minimap transparency, up to 90%. This way you can work your levels without blocking a part of your screen.";
				} break;
				
				case this.tf_chatbubbles:{
					return "Toggle whether you see chat bubbles in the playscreen.\n\nThis can also be toggled in game by pressing Shift+I";
				} break;
				case this.tf_packagenames:{
					return "Show package names ontop of packages in the block selector.";
				} break;
				case this.tf_vrows:{
					return "Customize the amount of rows displayed on your block bar.";
				} break;
				case this.tf_collapsed:{
					return "Enable the ultra-compact block bar style.";
				} break;
			}
			return "";
		}
		
		protected function handleCloseButton(e:MouseEvent) : void{
			TweenMax.to(this, 0.2,{
				alpha:0,
				onComplete:function() : void{
					Global.base.overlayContainer.removeChild(that);
					Global.inGameSettings = false;
				}
			});
			
			Global.base.settings.save();
			stage.focus = Global.base;
		}
	}
}
