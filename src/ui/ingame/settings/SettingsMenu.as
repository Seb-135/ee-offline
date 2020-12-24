package ui.ingame.settings
{
	import blitter.Bl;
	import ui.ingame.sam.SoundSlider;
	
	import com.greensock.TweenMax;
	import com.greensock.easing.Back;
	
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.display.StageDisplayState;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.media.Sound;
	
	import ui.ConfirmPrompt;
	import ui.LevelOptions;
	import ui.SettingsPage;

	public class SettingsMenu extends SettingsButton
	{		
		[Embed(source="/../media/asset_fullscreen.png")] private static var FullScreen:Class;
		private static var fullScreenBMD:BitmapData = new FullScreen().bitmapData;
		
		private var fullScreenButton:SettingsButton;
		private var soundButton:SoundSlider;
		
		private var buttonsContainer:Sprite;
		
		private var ui2:UI2;
		
		private var that:SettingsMenu;
		
		private var lastButtons:Array = [];
		
		public var levelOptions:LevelOptions;
		
		public function SettingsMenu(text:String, ui2:UI2)
		{
			that = this;
			
			super(text, null, function() : void{
				toggleVisible(!buttonsContainer.visible);
			});
				
			that.ui2 = ui2;
			
			buttonsContainer = new Sprite();
			buttonsContainer.visible = false;
			this.ui2.above.addChild(buttonsContainer);
			
			addButton(new SettingsButton("Game\nSettings", null, handleSettings));
			
			if(!Bl.data.isCampaignRoom) {
				addButton(new SettingsButton("World\nOptions", null, handleWorldOptions));
				addButton(new SettingsButton("Save\nWorld", null, handleSaveWorld));
				
				var fakePlayerButton:SettingsButton = new SettingsButton("Fake\nPlayers", null, handleFPMenu);
				fakePlayerButton.x = -SettingsButton.DEFAULT_WIDTH;
				addButton(fakePlayerButton);
				
				var editToolsButton:SettingsButton = new SettingsButton("Edit\nTools", null, handleEditTools);
				editToolsButton.x = -SettingsButton.DEFAULT_WIDTH;
				editToolsButton.y = -SettingsButton.DEFAULT_HEIGHT;
				addButton(editToolsButton);
				
				var worldsButton:SettingsButton = new SettingsButton("World\nManager", null, handleWorldManager);
				worldsButton.x = -SettingsButton.DEFAULT_WIDTH;
				worldsButton.y = -2*SettingsButton.DEFAULT_HEIGHT;
				addButton(worldsButton);
			}
			
			soundButton = new SoundSlider();
			soundButton.x = SettingsButton.DEFAULT_WIDTH; // recalculated on menu toggle
			
			addButton(soundButton);
			lastButtons.push(soundButton);
			
			fullScreenButton = new SettingsButton("", fullScreenBMD, handleFullScreenClick);
			fullScreenButton.x = SettingsButton.DEFAULT_WIDTH; // recalculated on menu toggle
			fullScreenButton.y = -SettingsButton.DEFAULT_HEIGHT;
			addButton(fullScreenButton);
			lastButtons.push(fullScreenButton);
		}
		
		public function addButton(button:Sprite) : void{
			buttonsContainer.addChild(button);
			
			redraw();
		}
		
		public function removeButton(button:Sprite) : void{
			buttonsContainer.removeChild(button);
			
			redraw();
		}
		
		protected function handleFullScreenClick(e:MouseEvent) : void {
			if(!Config.isMobile){
				try{
					if (Bl.stage.displayState == StageDisplayState.NORMAL) {
						Bl.stage.displayState=StageDisplayState.FULL_SCREEN_INTERACTIVE;
					} else {
						Bl.stage.displayState=StageDisplayState.NORMAL;
					} 
				}catch(e:Error){}
			}
		}
		
		protected function handleSaveWorld(e:MouseEvent) : void {
			toggleVisible(false);
			DownloadLevel.SaveLevel();
			//Global.base.showLoadingScreen("Saving World");
			//that.ui2.connection.send("save");
		}
		
		protected function handleSettings(e:MouseEvent) : void{
			toggleVisible(false);
			if (Global.inGameSettings) return;
			var settingsPage:SettingsPage = new SettingsPage(ui2);
			settingsPage.x = (Config.maxwidth - settingsPage.bg.width) / 2;
			settingsPage.y = (500 - settingsPage.bg.height) / 2;
			Global.base.overlayContainer.addChild(settingsPage);
			Global.inGameSettings = true;
		}
		
		protected function handleWorldOptions(e:MouseEvent) : void{
			toggleVisible(false);
			var hasGoldMembership:Boolean = true;
			
			levelOptions = new LevelOptions(Global.currentLevelname, that.ui2.description, that.ui2.worldMapEnabled, that.ui2);
			
			Global.base.showOnTop(levelOptions);
			Global.base.closeInfo2Menus();
		}
		
		protected function handleFPMenu(e:MouseEvent):void {
			toggleVisible(false);
			Global.base.showFPMenu();
		}
		
		protected function handleEditTools(e:MouseEvent):void {
			toggleVisible(false);
			Global.base.showEditTools();
		}
		
		protected function handleWorldManager(e:MouseEvent):void {
			toggleVisible(false);
			Global.base.showWorldManager();
		}
		
		public function toggleVisible(active:Boolean) : void{
			if (active) that.ui2.hideAll();
			
			buttonsContainer.visible = active;
			
			//var left:Boolean = buttonsContainer.x > Config.width - buttonsContainer.width + 5; // overlap tolerance
			//soundButton.x = left ? -soundButton.WIDTH : SettingsButton.DEFAULT_WIDTH;
			//fullScreenButton.x = left ? -fullScreenButton.WIDTH : SettingsButton.DEFAULT_WIDTH;
		}
		
		public function redraw() : void{
			if (this.ui2.settingsMenu){
				buttonsContainer.x = this.ui2.settingsMenu.x;
				buttonsContainer.y = this.ui2.settingsMenu.y - 29;
			}
			
			var index:int = 0;
			for (var i:int = 0; i < buttonsContainer.numChildren; i++){
				var button:Sprite = (buttonsContainer.getChildAt(i) as Sprite);
				
				if (button.x == 0){
					button.y = (index * -29);
					index++;
				}
			}
		}
		
		public function remove():void {
			if (buttonsContainer.parent) this.ui2.above.removeChild(buttonsContainer);
		}
		
	}
}