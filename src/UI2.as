package  {
	import blitter.Bl;
	import blitter.BlText;
	import flash.utils.getTimer;
	import sample.ui.components.Label;
	import ui.campaigns.CampaignTrialDone;
	import ui.campaigns.CampaignWorld;
	import ui.campaigns.ClockTime;
	import ui.campaigns.TimesInfo;
	
	import com.greensock.*;
	import com.greensock.easing.*;
	
	import flash.display.BitmapData;
	import flash.display.InteractiveObject;
	import flash.display.Sprite;
	import flash.display.StageDisplayState;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.ui.Keyboard;
	import flash.utils.setTimeout;
	import flash.utils.ByteArray;
	import flash.system.System;
	
	import items.ItemAuraColor;
	import items.ItemAuraShape;
	import items.ItemBrick;
	import items.ItemBrickPackage;
	import items.ItemId;
	import items.ItemManager;
	import items.ItemSmiley;
	import items.ItemTab;
	
	import mx.utils.StringUtil;
	import states.PlayState;
	
	import ui.CopyPrompt;
	import ui.BrickContainer;
	import ui.ConfirmPrompt;
	import ui.LevelComplete;
	import ui.Share;
	import ui.brickoverlays.*;
	import ui.brickselector.BrickPackage;
	import ui.brickselector.BrickSelector;
	import ui.campaigns.CampaignComplete;
	import ui.campaigns.CampaignInfo;
	import ui.chat.TabTextField;
	import ui.ingame.EffectDisplay;
	import ui.ingame.sam.*;
	import ui.ingame.sam.AuraColorButton;
	import ui.ingame.sam.AuraSelector;
	import ui.ingame.sam.SmileyInstance;
	import ui.ingame.settings.SettingsButton;
	import ui.ingame.settings.SettingsMenu;
	
	import ui2.ui2chatbtn;
	import ui2.ui2chatinput;
	import ui2.ui2godmodebtn;
	import ui2.ui2lobbybtn;
	import ui2.ui2sharebtn;
	import ui2.ui2toggleminimapbtn;
	
	import sounds.SoundId;
	
	import flash.external.ExternalInterface;
	
	public class UI2 extends Sprite{
		
		private var timeLabel:Label;
		
		private var lobby:ui2lobbybtn = new ui2lobbybtn();
		private var godmode:ui2godmodebtn = new ui2godmodebtn();
		private var toggleminimap:ui2toggleminimapbtn = new ui2toggleminimapbtn();
		private var share:ui2sharebtn = new ui2sharebtn();
		private var campaignInfo:CampaignInfo = new CampaignInfo();
		private var timesInfo:TimesInfo = new TimesInfo();
		private var bmd:BitmapData
		private var bmd2:BitmapData
		private var smiliesbmd:BitmapData
		private var chatbtn:ui2chatbtn = new ui2chatbtn()
		private var chatinput:ui2chatinput = new ui2chatinput();
		
		public var favoriteBricks:BrickContainer
		public var bselector:BrickSelector;
		public var base:EverybodyEdits;
		
		private var downloadconfirm:ConfirmPrompt;
		
		private var brickPackagePopup:ui.brickselector.BrickPackage;
		
		private var roomid:String
		
		//Made public for 'SettingsMenu'
		//----
		public var settingsMenu:SettingsMenu;
		
		public var above:Sprite = new Sprite();
		
		public var roomVisible:Boolean = false;
		public var roomHiddenFromLobby:Boolean = false;
		public var lobbyPreviewEnabled:Boolean = true;
		public var allowSpectating:Boolean = false;
		
		public var curseLimit:int = 0;
		public var zombieLimit:int = 0;
		
		public var description:String = "";
		
		public var smileyMenu:SmileyMenu;
		public var smileyButton:SmileyButton;
		public var auraMenu:AuraMenu;
		public var auraButton:AuraButton;
		
		private var effectDisplay:EffectDisplay;
		
		private var specialproperties:PropertiesBackground;
		
		public var hasPropertyOpen:Boolean = false;
		
		private var reqS:Boolean = false;
		
		private var latestPM:String = "";
		
		public var worldName:String = "";
		
		private var worldOwner:String = "";
		
		public var worldNameLabel:Label;
		
		private var worldOwnerLabel:Label;
		
		public var editKey:String = "";
		
		//Trolling decompilers
		public var commandHelp:Object = {		
			"/bgcolor":true,
			"/clear":true,
			"/clearchat":true,
			"/cleareffects":true,
			"/endtrial":true,
			"/forcefly":true,
			"/forgive":true,
			"/fps":true,
			"/gedit":true,
			"/geffect":true,
			"/getpos":true,
			"/givecrown":true,
			"/giveedit":true,
			"/giveeffect":true,
			"/givegod":true,
			"/help":true,
			"/hide":true,
			"/hidelobby":true,
			"/info":true,
			"/inspect":true,
			"/kick":true,
			"/kill":true,
			"/killall":true,
			"/listportals":true,
			"/loadlevel":true,
			"/mute":true,
			"/name":true,
			"/pm":true,
			"/redit":true,
			"/reffect":true,
			"/removecrown":true,
			"/removeedit":true,
			"/removeeffect":true,
			"/removegod":true,
			"/report":true,
			"/reset":true,
			"/resetall":true,
			"/resetswitches":true,
			"/respawn":true,
			"/respawnall":true,
			"/roomid":true,
			"/save":true,
			"/setteam":true,
			"/show":true,
			"/spectate":true,
			"/starttrial":true,
			"/teleport":true,
			"/unmute":true,
			"/visible":true
		};
		
		public var worldMapEnabled:Boolean = true;
		public var playerMapEnabled:Boolean = false;
		public function get minimapEnabled():Boolean {
			return worldMapEnabled || playerMapEnabled || Bl.data.canEdit;
		}
		
		public var trialsAvailable:Boolean = false;
		public var validRun:Boolean = true;
		public var trialsMode:Boolean;
		public var goodTicks:int;
		
		private var lastSmileyKeyTime:int = int.MIN_VALUE;
		private var lastIncrementTime:int = int.MIN_VALUE;
		private var lastIncrementDir:int = 0;
		
		private function quickSayPrompt(message:String, button:String, cmd:String):void {
			var confirm:ConfirmPrompt = new ConfirmPrompt(message, true, button);
			
			Global.base.showOnTop(confirm);
			
			confirm.btn_yes.addEventListener(MouseEvent.MOUSE_DOWN, function(e:MouseEvent):void {
				sendChat(cmd);
				confirm.close();
			});
			confirm.btn_no.addEventListener(MouseEvent.MOUSE_DOWN, function(e:MouseEvent):void {
				confirm.close();
			});
		}
		
		private var quickSay:Array;
		
		public function UI2(base:EverybodyEdits, canEdit:Boolean, roomid:String, worldName:String, worldOwner:String, description:String, mapEnabled:Boolean, trialsEnabled:Boolean) {
			
			trialsMode = trialsEnabled;
			
			this.worldName = worldName;
			this.worldOwner = worldOwner;
			this.worldMapEnabled = mapEnabled;
			this.description = description;
			
			Global.playState.player.canEdit = canEdit;
			Global.playState.player.canToggleGodMode = canEdit;
			Bl.data.canEdit = canEdit;
			Bl.data.canToggleGodMode = canEdit;
			
			var blocks:Vector.<ItemBrick> = new Vector.<ItemBrick>();
			blocks.push(ItemManager.bricks[0]);
			brickPackagePopup = new ui.brickselector.BrickPackage("empty", blocks, this, ItemTab.BLOCK, [], false, 0, true);
			brickPackagePopup.x = 20;
			brickPackagePopup.y = -200;
			
			bselector = new BrickSelector(this);
			
			Bl.data.bselector = bselector;
			Bl.data.showingproperties = false;
			
			Bl.data.world_portal_id = Global.worldIndex;
			Bl.data.world_portal_name = Bl.data.roomname;
			
			this.roomid = roomid
			
			this.smiliesbmd = ItemManager.smileysBMD;
			this.base = base;
			
			addChild(bselector);
			
			var ui2BG:SettingsButton = new SettingsButton("", null, null);
			ui2BG.setSize(639, 29);
			ui2BG.y = -ui2BG.HEIGHT;
			addChild(ui2BG);
			
			addChild(brickPackagePopup);
			
			smileyMenu = new SmileyMenu(this);
			above.addChild(smileyMenu);
			
			auraMenu = new AuraMenu(this);
			above.addChild(auraMenu);
			
			smileyButton = new SmileyButton();
			auraButton = new AuraButton();
			
			effectDisplay = new EffectDisplay(curseLimit, zombieLimit);
			effectDisplay.x = 2;
			effectDisplay.y = -498;
			
			addChild(effectDisplay);
			
			var def:Vector.<ItemBrick> = new Vector.<ItemBrick>();
			
			def.push(ItemManager.getBrickById(0));
			for (var i:int = 0; i < 10; i++)
				def.push(ItemManager.getBrickById(Global.base.settings.savedBlocks[i]));
			
			//0,9,10,11,16,17,18,29,32,2,100
			favoriteBricks = new BrickContainer(def, this)
			
			configureInterface();
			
			toggleMinimap(minimapEnabled && Bl.data.showMap);
			auraMenu.x = (auraButton.x - auraMenu.width / 2 + auraButton.width / 2) >> 0;
			
			//smileyMenu.x = (smileyButton.x - smileyMenu.width / 2 + smileyButton.width / 2) >> 0;
			//if (smileyMenu.x < 10) smileyMenu.x = 10;
			
			bselector.x = (640 - bselector.width) >> 1
			bselector.visible = false;
			
			addChild(chatinput);
			chatinput.y = -59
			chatinput.x = 65
			chatinput.visible = false
			
			chatinput.text = new TabTextField();
			if (Bl.data.isAdmin) {
				chatinput.text.field.maxChars = int.MAX_VALUE;
			}
			
			chatinput.addChild(chatinput.text);
			
			chatinput.text.x = 37;
			chatinput.text.y = 6;
			chatinput.text.width = 445;
			
			quickSay = [
				function():void { sendChat("/help"); },
				function():void { sendChat("/edit"); },
				function():void { sendChat("/god"); },
				function():void { sendChat("/summon"); },
				function():void {
					if (Bl.data.isCampaignRoom) {
						quickSayPrompt("Are you sure you want to reset?\nYour campaign progress will be lost!", "Reset", "/reset");
					}
					else sendChat("/reset");
				},
				function():void {
					quickSayPrompt("Are you sure you want to reload the level?\nUnsaved changes will be lost!", "Load", "/loadlevel");
				},
				function():void {
					quickSayPrompt("Are you sure you want to clear the level?\nUnsaved changes will be lost!", "Clear", "/clear");
				},
				function():void { sendChat("/save"); },
				function():void { sendChat("/kill"); },
				function():void { sendChat("/crown"); }
			];
			
			for (var j:int = 0; j <= 9; j++) {
				chatinput.getChildByName("quicksay" + j).addEventListener(MouseEvent.CLICK, quickSay[j == 0 ? 9 : j - 1]);
			}
			
			function moveInputCursorToEnd(e:Event):void {
				var l:int = chatinput.text.field.length;
				chatinput.text.field.setSelection(l, l);
				stage.removeEventListener(Event.RENDER, moveInputCursorToEnd);
			}
			
			chatinput.text.field.addEventListener(KeyboardEvent.KEY_DOWN, function(e:KeyboardEvent):void{
				e.preventDefault();
				e.stopImmediatePropagation();
				e.stopPropagation();
				
				if (e.keyCode == Keyboard.ESCAPE) {
					hideAll();
				}
				else if (e.keyCode == Keyboard.ENTER) {
					if (chatinput.text.field.text.length > 0)
						sendChat();
					else hideAll();
				}
				else if (e.keyCode == Keyboard.UP) {
					chatHistory--;
					previousChatInput();
					
					stage.addEventListener(Event.RENDER, moveInputCursorToEnd, false, 0, true);
					stage.invalidate();
				}
				else if (e.keyCode == Keyboard.DOWN) {
					chatHistory++;
					previousChatInput();
					
					stage.addEventListener(Event.RENDER, moveInputCursorToEnd, false, 0, true);
					stage.invalidate();
				}
			});
			
			chatinput.text.field.addEventListener(KeyboardEvent.KEY_UP, function(e:KeyboardEvent):void {
				e.preventDefault();
				e.stopImmediatePropagation();
				e.stopPropagation();
			});
			
			chatinput.say.addEventListener(MouseEvent.MOUSE_DOWN, function():void{
				sendChat();
			});
			
			
			chatinput.text.field.addEventListener(MouseEvent.MOUSE_DOWN, function(e:MouseEvent):void{
				e.preventDefault();
				e.stopImmediatePropagation();
				e.stopPropagation();
			});

			
			setSmiliesData();
			smileyMenu.redraw();
			auraMenu.redraw();
			//smilies.redraw();
			
			this.addEventListener(MouseEvent.MOUSE_DOWN, function(e:MouseEvent):void{
				e.preventDefault();
				e.stopImmediatePropagation()
				e.stopPropagation();
				if(stage && !(e.target is TextField)) stage.focus = Global.base
			});
			
			lobby.addEventListener(MouseEvent.MOUSE_DOWN, goToLobby);
			
			share.addEventListener(MouseEvent.MOUSE_DOWN, function():void{
				var owner:String = Global.worldInfo.crewName == "" ? Global.worldInfo.owner : Global.worldInfo.crewName;
				var ownerId:String = Global.worldInfo.crewName == "" ? Global.worldInfo.ownerId : Global.worldInfo.crewId;
				base.showInfo("Playing: " + Global.currentLevelname.substr(0,20) + (Global.currentLevelname.length > 20 ? "..." : "")  /*+ " (worldID)"*/, //idk the worldID looks really ugly in the title
				("By " + owner.toUpperCase() + " (" + ownerId + ")") + (Global.worldInfo.crewName == "" ? "" : 
				("\nHosted by " + Global.worldInfo.owner.toUpperCase() + " (" + Global.worldInfo.ownerId + ")")) + (Global.ui2.description == "" ? "" :
				("\n\nDescription:\n" + Global.ui2.description)),
				400);
			});
			
			godmode.addEventListener(MouseEvent.MOUSE_DOWN, function():void{
				Global.playState.getPlayer().isInGodMode = !Global.playState.getPlayer().isInGodMode;
				Global.playState.getPlayer().resetDeath();
				Global.playState.getWorld().setShowAllSecrets(Global.playState.getPlayer().isInGodMode);
				auraMenu.redraw();
				toggleGodMode(Global.playState.getPlayer().isInGodMode);
				if (!Bl.data.canToggleGodMode)
				configureInterface(Global.playState.getPlayer().isInGodMode);
				
				if (Global.playState.getPlayer().isInModMode) {
					Global.playState.getPlayer().isInModMode = !Global.playState.getPlayer().isInModMode;
					Global.playState.getPlayer().resetDeath();
				}
			});
			
			//connection.addMessageHandler("toggleGod", function(m:Message, id:int, canToggleGod:Boolean):void {
				//if (id == myid) {
					//Bl.data.canToggleGodMode = canToggleGod;
					//auraMenu.redraw();
					//configureInterface();
				//}
			//});
			
			var that:UI2 = this;
			
			chatbtn.addEventListener(MouseEvent.MOUSE_DOWN, function(e:MouseEvent):void{
				toggleChat(chatbtn.currentFrame == 1)
				e.preventDefault();
				e.stopImmediatePropagation()
				e.stopPropagation();
			})

			toggleminimap.buttonMode = true;
			toggleminimap.addEventListener(MouseEvent.MOUSE_DOWN, function():void{
				toggleMinimap(toggleminimap.currentFrame == 1);
				if(stage)stage.focus = Global.base
			});
			
			//connection.addMessageHandler("saving", function():void{
				//Global.base.showLoadingScreen("Saving World");
			//});
			//
			//connection.addMessageHandler("saved", function():void{
				//setTimeout(function():void{
					//settingsMenu.toggleVisible(false);
					//Global.base.hideLoadingScreen();
					//(base.state as PlayState).unsavedChanges = false;
				//}, 500);
			//});
				
			smileyButton.addEventListener(MouseEvent.MOUSE_DOWN, function() : void{
				//smileyMenu.x = smileyButton.x;//(smileyButton.x - smileyMenu.width / 2 + smileyButton.width / 2) >> 0;
				//if (smileyMenu.x < 10) smileyMenu.x = 10;
				if (!smileyMenu.visible) base.closeInfo2Menus();
				toggleSmileyMenu(!smileyMenu.visible);
				
			});
			
			auraButton.addEventListener(MouseEvent.CLICK, function():void {
				toggleAuraMenu(!auraMenu.visible);
			});
			
			favoriteBricks.more.addEventListener(MouseEvent.MOUSE_DOWN, function():void{
				toggleMore(favoriteBricks.more.currentFrame == 1);
			});
			
			//connection.addMessageHandler("toggleOptions", function(m:Message, options:Boolean):void {
				//Bl.data.canChangeWorldOptions = options;
				//configureInterface();
			//});
			
			//connection.addMessageHandler("minimapEnabled", function(m:Message, enabled:Boolean):void {
				//worldMapEnabled = enabled;
				//configureInterface();
			//});
				
			//connection.addMessageHandler("roomDescription", function(m:Message):void{
				//that.description = m.getString(0);
			//})
			
			
			
			//connection.addMessageHandler("joinCampaign", function(m:Message, campaignName:String, status:int):void {
				//trace("Status: " + status);
				//if (Global.player_is_guest)
					//campaignInfo.displayGuestInfo(campaignName);
				//else if (status == -1)
					//campaignInfo.displayLockedInfo(campaignName);
				//else if (status == 2)
					//campaignInfo.displayBetaOnlyInfo(campaignName);
				//else if (status == 3)
					//campaignInfo.displayLockedCampaignInfo(campaignName);
				//else
				//{
					//var i:int = 2;
					//
					//campaignInfo.displayInfo(campaignName, m.getInt(i++), m.getInt(i++), m.getInt(i++), status == 1);
					//
					//if (status == 1)
					//{
						//if (m.getBoolean(i++))
						//{
							//trialsAvailable = true;
							//
							//var time:int = m.getInt(i++);
							//var rank:int = m.getInt(i++);
							//
							//var times:Array = new Array();
							//
							//times.push(m.getInt(i++));
							//times.push(m.getInt(i++));
							//times.push(m.getInt(i++));
							//if (rank >= 3) times.push(m.getInt(i++));
							//if (rank >= 5) times.push(m.getInt(i++));
							//
							//timesInfo.displayTimes(times, time, rank);
							//goodTicks = time < 0 ? int.MAX_VALUE : time;
							//configureInterface();
						//}
					//}
				//}
			//});
			
			//connection.addMessageHandler("stoprun", function(m:Message, disable:Boolean = false):void {
				//validRun = false;
				//if (disable) trialsAvailable = false;
				//if (trialsMode) {
					//Global.base.SystemSay("You left time trials mode.", "* System");
					//trialsMode = false;
					//configureInterface();
				//}
			//});
			
			
			//connection.addMessageHandler("completedLevel", function(m:Message):void {
				//if (Global.base.overlayContainer.getChildByName("LevelCompleteScreen")) return;
				//
				//var i:int = 0;
				//
				//if (m.getBoolean(i++) && trialsMode) {
					//var lastTime:int = m.getInt(i++);
					//var lastRank:int = m.getInt(i++);
					//
					//var newTime:int = m.getInt(i++);
					//var newRank:int = m.getInt(i++);
					//
					//var bestTime:int = m.getInt(i++);
					//var bestRank:int = m.getInt(i++);
					//
					//var times:Array = [];
					//
					//times.push(m.getInt(i++));
					//times.push(m.getInt(i++));
					//times.push(m.getInt(i++));
					//if (bestRank >= 3) times.push(m.getInt(i++));
					//if (bestRank >= 5) times.push(m.getInt(i++));
					//
					//timesInfo.displayTimes(times, bestTime, bestRank);
					//goodTicks = bestTime < 0 ? int.MAX_VALUE : bestTime;
					//configureInterface();
					//
					//Global.base.showCampaignTrialDone(new CampaignTrialDone(newRank, newTime, lastRank, lastTime, bestRank < times.length ? times[bestRank] : -1));
				//}
				//else Global.base.showOnTop(new LevelComplete());
			//});
			
			
			setSelectedSmiley(Global.playerInstance.frame);
			setSelectedAura(Global.playerInstance.aura);
			setSelectedAuraColor(Global.playerInstance.auraColor);
			
			toggleSmileyMenu(false);
			settingsMenu.toggleVisible(false);
			
			updateSelectorBricks();
			setSelected(0);
			
			addEventListener(Event.ADDED_TO_STAGE, handleAttach);
			addEventListener(Event.REMOVED_FROM_STAGE, handleDetatch);
			
			Global.ui2 = this;
		}
		
		private function resetWorldPortalStuff():void {
			Global.worldIndex = 0;
			Global.worlds = new Array();
			Global.worldNames = new Array();
			
			Global.unsavedWorlds = false;
			Global.isWorldManagerOpen = false;
			Global.base.worldPage = 0;
		}
		
		public function goToLobby(e:MouseEvent = null, keepWorldArrays:Boolean = false):void{
			if(((base.state as PlayState).unsavedChanges || Global.unsavedWorlds && !keepWorldArrays) && !Bl.data.isCampaignRoom) {
				var confirmLobby:ConfirmPrompt = new ConfirmPrompt("Are you sure you want to leave?\nYou have unsaved changes in the world!", true, "Leave");
				
				Global.base.showOnTop(confirmLobby);
				
				confirmLobby.btn_yes.addEventListener(MouseEvent.MOUSE_DOWN, function(e:MouseEvent):void {
					if (!Global.noSave) Global.cookie.flush();
					resetWorldPortalStuff();
					base.ShowLobby();
					confirmLobby.close();
				});
				confirmLobby.btn_no.addEventListener(MouseEvent.MOUSE_DOWN, function(e:MouseEvent):void {
					confirmLobby.close();
				});
			} else {
				var campId:int = Global.currentCampId;
				var tierId:int = Global.currentTierId;
				if(Bl.data.isCampaignRoom && !trialsMode) {
					var progress:Object = Global.cookie.data.campaignProgress[campId][tierId];
					var player:Player = Global.playerInstance;
					//physics
					progress.x = player.x;
					progress.y = player.y;
					progress.speedX = player.speedX;
					progress.speedY = player.speedY;
					progress.jumpCount = player.jumpCount;
					
					//idk where to put this one
					//i hate world portals
					progress.worldSpawn = player.worldSpawn;
					
					//death
					progress.deaths = player.deaths;
					progress.checkpoint_x = player.checkpoint_x;
					progress.checkpoint_y = player.checkpoint_y;
					progress.isDead = player.isDead;
					
					//collectibles
					progress.gx = player.gx; //gold coins
					progress.gy = player.gy;
					progress.bx = player.bx; //blue coins
					progress.by = player.by;
					progress.switches = player.switches;
					progress.hascrown = player.hascrown;
					progress.hascrownsilver = player.hascrownsilver;
					
					//effects
					progress.jumpBoost = player.jumpBoost;
					progress.speedBoost = player.speedBoost;
					progress.hasLevitation = player.hasLevitation;
					progress.low_gravity = player.low_gravity;
					if (player.cursed || player.zombie || player.poison || player.onFire) progress.isDead = true;
					progress.isInvulnerable = player.isInvulnerable;
					progress.maxJumps = player.maxJumps;
					progress.flipGravity = player.flipGravity
				}
				//hopefully no longer necessary - joining a world with custom world data now clones that data
				//if (Bl.data.isCampaignRoom) {
					//Global.base.campaigns.currentCampaign.campaignWorlds[tierId].worldData.deflate();
				//}
				if (!Global.noSave) Global.cookie.flush();
				toggleMore(false);
				toggleMinimap(false);
				if(!keepWorldArrays) resetWorldPortalStuff();
				base.ShowLobby();
			}
		}
		
		public function joinCampaign(campName:String, diff:int, tier:int, maxTier:int, completed:Boolean, silvercrown:Boolean):void {
			campaignInfo.displayInfo(campName, diff, tier, maxTier, completed)
			if (silvercrown && !trialsMode) {
				var confirmRerun:ConfirmPrompt = new ConfirmPrompt("You have already beaten this campaign tier. Do you want to replay from the beginning?", true, "Reset");
				
				Global.base.showOnTop(confirmRerun);
				
				confirmRerun.btn_yes.addEventListener(MouseEvent.MOUSE_DOWN, function(e:MouseEvent):void {
					sendChat("/reset");
					confirmRerun.close();
				});
				confirmRerun.btn_no.addEventListener(MouseEvent.MOUSE_DOWN, function(e:MouseEvent):void {
					confirmRerun.close();
				});
			}
		}
		public function joinTimeTrial(times:Array, time:int, rank:int):void {
			trialsAvailable = true;
			
			if (rank < 5) times.pop();
			if (rank < 3) times.pop();
			
			timesInfo.displayTimes(times, time, rank);
			goodTicks = time < 0 ? int.MAX_VALUE : time;
			configureInterface();
		}
		
		public function completeLevel():void {
			if (Global.base.overlayContainer.getChildByName("LevelCompleteScreen")) return;
			
			if (Global.currentCampId >= 0) {
				var progress:Object = Global.cookie.data.campaignProgress[Global.currentCampId][Global.currentTierId];
				progress.completed = 1;
				campaignInfo.updateStatus(true);
				base.campaigns.currentCampaign.campaignWorlds[Global.currentTierId].complete = true;
				if (trialsMode) {
					var lastTime:int = progress.time;
					var lastRank:int = progress.rank;
					
					var ticks:int = (base.state as PlayState).player.ticks;
					var newTime:int = ticks;
					var newRank:int = 0;
					
					var fullTimes:Array = Global.currentTierInfo.times;
					for (var i:int = 0; i < fullTimes.length; i++) {
						if (ticks <= fullTimes[i]) newRank++;
						else break;
					}
					
					var bestTime:int = lastTime == -1 ? newTime : newTime < lastTime ? newTime : lastTime;
					var bestRank:int = newRank > lastRank ? newRank : lastRank;
					progress.time = bestTime;
					progress.rank = bestRank;
					base.campaigns.currentCampaign.campaignWorlds[Global.currentTierId].updateTargetTimes(bestRank, bestTime);
					
					var worstRank:int = 6;
					for each(var world:CampaignWorld in base.campaigns.currentCampaign.campaignWorlds)
						if (world.rank < worstRank) worstRank = world.rank;
					base.campaigns.currentCampaign.newRank = worstRank;
					
					var times:Array = Global.currentTierInfo.times.concat();
					if (bestRank < 5) times.pop();
					if (bestRank < 3) times.pop();
					
					timesInfo.displayTimes(times, bestTime, bestRank);
					goodTicks = bestTime < 0 ? int.MAX_VALUE : bestTime;
					configureInterface();
					
					Global.base.showCampaignTrialDone(new CampaignTrialDone(newRank, newTime, lastRank, lastTime, bestRank < times.length ? times[bestRank] : -1));
					return;
				} else {
					Global.base.showCampaignComplete(new CampaignComplete(campaignInfo.campaignName, campaignInfo.tier, campaignInfo.maxTier/*, [], (showBadge) ? badgeImageName : worldImageName*/));
				}
			} else Global.base.showOnTop(new LevelComplete());
		}
		
		public function setEffectIcon(effectId:int, active:Boolean, timeLeft:Number, duration:Number):void {
			var effectBrick:ItemBrick = ItemManager.getEffectBrickById(effectId);
			var bmd:BitmapData = effectBrick.bmd;
			if (effectId == Config.effectMultijump) return;
			
			effectDisplay.removeEffect(effectBrick.id);
			if (active) {
				effectDisplay.addEffect(bmd, effectBrick.id, timeLeft, duration);
			}
			
			effectDisplay.update();
		}
		
		private function handlePlayerObjectUpdate( e:Event = null ):void 
		{
			smileyMenu.doEmpty(); /////
			smileyMenu.redraw();
		}
		
		private function setSmiliesData():void {
			var sms:Vector.<ItemSmiley> = ItemManager.smilies;
			for( var a:int=0;a<sms.length;a++){
				
				var cs:ItemSmiley = sms[a];
				if(cs.payvaultid != "unobtainable"){
					smileyMenu.addSmiley(new SmileyInstance(cs, this, Global.playerInstance.wearsGoldSmiley));
				}
			}
			
			var auras:Vector.<ItemAuraShape> = ItemManager.auraShapes;
			
			// Add auras
			for (var i:int = 0; i < auras.length; i++) {
				var aura:ItemAuraShape = auras[i];
				auraMenu.addShape(aura);
			}
			
			for (var j:int = 0; j < ItemManager.auraColors.length; j++) {
				var auraColor:ItemAuraColor = ItemManager.auraColors[j];
				auraMenu.addColor(auraColor);
			}
		}
		
		override public function set y(value:Number):void
		{
			super.y = value;
		}
		
		// **********************************************************
		// updateSelectorBricks
		// 
		// Adds brick packages to the selector based on what the user 
		// has access to and what layer is being edited
		//
		// **********************************************************
		public function updateSelectorBricks():void
		{
			bselector.removeAllPackages();
			
			//var notallowedbricks:Vector.<ItemBrick>;
			//notallowedbricks = ItemManager.getOpenWorldAntiSubset();
			
			var packages:Vector.<ItemBrickPackage>;
			packages = ItemManager.brickPackages;
			
			/*
			if(Bl.data.isOpenWorld){
				packages = ItemManager.getOpenWorldBrickPackages();
			}*/
			
			for( var a:int=0;a<packages.length;a++){
				var pack:ItemBrickPackage = packages[a];
				
				var blockArr:Vector.<ItemBrick> = new Vector.<ItemBrick>();
				var actionArr:Vector.<ItemBrick> = new Vector.<ItemBrick>();
				var decorativeArr:Vector.<ItemBrick> = new Vector.<ItemBrick>();
				var backgroundArr:Vector.<ItemBrick> = new Vector.<ItemBrick>();
				
				//Populate list
				for( var b:int=0;b<pack.bricks.length;b++){
					var cb:ItemBrick = pack.bricks[b];
					
					if(cb.payvaultid != "hidden"){
						
						switch(cb.tab){
							case ItemTab.BLOCK:{
								blockArr.push(cb);
								break;
							}
							case ItemTab.ACTION:{
								actionArr.push(cb);
								break;
							}
							case ItemTab.DECORATIVE: {
								decorativeArr.push(cb);
								break;
							}
							case ItemTab.BACKGROUND: {
								backgroundArr.push(cb);
								break;
							}
						}
					}
				}
				
				var bp:ui.brickselector.BrickPackage;
				
				if(blockArr.length > 0){
					bp = new ui.brickselector.BrickPackage(pack.name, blockArr, this, ItemTab.BLOCK, pack.tags, Global.base.settings.showPackageNames, Global.base.settings.collapsed ? 1 : 0);
					bselector.addPackage(bp);
				}
				if(actionArr.length > 0){
					bp = new ui.brickselector.BrickPackage(pack.name, actionArr, this, ItemTab.ACTION, pack.tags, Global.base.settings.showPackageNames, Global.base.settings.collapsed ? 1 : 0);
					bselector.addPackage(bp);
				}
				if(decorativeArr.length > 0){
					bp = new ui.brickselector.BrickPackage(pack.name, decorativeArr, this, ItemTab.DECORATIVE, pack.tags, Global.base.settings.showPackageNames, Global.base.settings.collapsed ? 1 : 0);
					bselector.addPackage(bp);
				}
				if(backgroundArr.length > 0){
					bp = new ui.brickselector.BrickPackage(pack.name, backgroundArr, this, ItemTab.BACKGROUND, pack.tags, Global.base.settings.showPackageNames, Global.base.settings.collapsed ? 1 : 0);
					bselector.addPackage(bp);
				}
				
				
				
			}
			
			// Reset search field input as it no longer has effect
			bselector.search.textfield.text = "";
			
			bselector.redraw();
		}
		
		public function toggleSmileyMenu(active:Boolean):void{
			if(active) hideAll();
			smileyMenu.visible = active;
			smileyButton.setActive(active);
		}
		
		public function toggleAuraMenu(active:Boolean):void {
			if (active) hideAll();
			auraMenu.visible = active;
			auraButton.setActive(active);
		}
		
		public function toggleFavLike(active:Boolean) : void{
			if (active) hideAll();
		}
		
		public function dragIt(brick:ItemBrick):void{
			favoriteBricks.dragIt(brick);
		}
		
		public function setDefault(index:int, value:ItemBrick):void{
			favoriteBricks.setDefault(index,value);
		}
		
		
		public function toggleGodMode(active:Boolean):void{
			godmode.gotoAndStop(active ? 2 : 1)
		}
		
		public function toggleMinimap(active:Boolean):void{
			toggleminimap.gotoAndStop(active ? 2 : 1)
			Bl.data.showMap = active
		}
		
		public function setSelected(brick:int, hotbar:Boolean = false):void{
			var wasShown:Boolean = Bl.data.showingproperties;
			hideAllProperties();
			
			if (brick != Bl.data.brick || !wasShown) {
				switch (brick) {
					case ItemId.COINDOOR:	
					case ItemId.COINGATE:
					case ItemId.BLUECOINDOOR:	
					case ItemId.BLUECOINGATE:
					case 77:
					case 83:
					case 242:
					case ItemId.WORLD_PORTAL:
					case ItemId.WORLD_PORTAL_SPAWN:
					case ItemId.PORTAL_INVISIBLE:
					case ItemId.TEXT_SIGN:
					case ItemId.SWITCH_PURPLE:
					case ItemId.RESET_PURPLE:
					case ItemId.DOOR_PURPLE:
					case ItemId.GATE_PURPLE:
					case ItemId.DEATH_DOOR:
					case ItemId.DEATH_GATE:
					case ItemId.EFFECT_TEAM:
					case ItemId.TEAM_DOOR:
					case ItemId.TEAM_GATE:
					case ItemId.EFFECT_CURSE:
					case ItemId.EFFECT_FLY:
					case ItemId.EFFECT_JUMP:
					case ItemId.EFFECT_PROTECTION:
					case ItemId.EFFECT_RUN:
					case ItemId.EFFECT_ZOMBIE:
					case ItemId.EFFECT_LOW_GRAVITY:
					case ItemId.EFFECT_MULTIJUMP:
					case ItemId.EFFECT_GRAVITY:
					case ItemId.EFFECT_POISON:
					case ItemId.SWITCH_ORANGE:
					case ItemId.RESET_ORANGE:
					case ItemId.DOOR_ORANGE:
					case ItemId.GATE_ORANGE:
					case 1520:
					case 1000: {
						showSpecialProperties(brick, !bselector.visible || !bselector.currentPageHasBlock(brick), hotbar);
						break;
					}
				}
				if (ItemId.isNPC(brick)) showSpecialProperties(brick, !bselector.visible || !bselector.currentPageHasBlock(brick), hotbar);
			}
			
			if (brick == -1) brick = 243;
			Bl.data.brick = brick;
			
			favoriteBricks.setSelected(brick);
			bselector.setSelected(brick);
		}
		
		public function hideBrickPackagePopup():void
		{
			if (brickPackagePopup.visible) hideAllProperties();
			brickPackagePopup.visible = false;
		}
		
		public function toggleBrickPackagePopup(title:String, content:Vector.<ItemBrick>, canHide:Boolean):void
		{
			var firstBlockId:int = content[0].id;
			if (brickPackagePopup.visible && brickPackagePopup.content[0].id == firstBlockId && canHide)
			{
				brickPackagePopup.visible = false;
				return;
			}
			
			var pos:Point = bselector.getPosition(firstBlockId);
			brickPackagePopup.visible = pos != null;
			
			if (pos == null)
				return;
			
			brickPackagePopup.updateContent(title, content, true);
			brickPackagePopup.x = pos.x + bselector.x - (brickPackagePopup.content.length * 16)/2 - 2;
			brickPackagePopup.y = pos.y + bselector.y - 33;
			
			if (brickPackagePopup.x < 0) {
				brickPackagePopup.x = 5;
			} else if (brickPackagePopup.x + brickPackagePopup.content.length*16 > 635) {
				brickPackagePopup.x = 635 - brickPackagePopup.width;
			}
			
			hideAllProperties();
		}
		
		public function showSpecialProperties(brick:int, minimized:Boolean = false, hotbar:Boolean = false):void
		{
			hideAllProperties();
			var pos:Point = brickPackagePopup.getPosition(brick)
			if (pos == null)
			{
				if (!minimized)
					pos = bselector.getPosition(brick);
				else
					pos = favoriteBricks.getPosWithID(brick);
			}
			else
			{
				pos.x -= bselector.x;
				pos.y -= bselector.y;
			}
			
			Bl.data.showingproperties = true;
			specialproperties = null;
			
			switch(brick){
				case ItemId.COINDOOR:	
				case ItemId.COINGATE:
				case ItemId.BLUECOINDOOR:	
				case ItemId.BLUECOINGATE:{	
					specialproperties = new CoinProperties(brick);
					break;
				}
				case 1000:{
					specialproperties = new LabelProperties();
					break;
				}
				case 242:
				case ItemId.PORTAL_INVISIBLE: {  
					specialproperties = new PortalProperties(brick);
					break;
				}
				case ItemId.WORLD_PORTAL:{  
					specialproperties = new WorldPortalProperties();
					break;
				}
				case ItemId.WORLD_PORTAL_SPAWN:{  
					specialproperties = new WorldPortalSpawnProperties();
					break;
				}
				case 83:{
					specialproperties = new DrumProperties();
					break
				}
				case 77:{  
					specialproperties = new PianoProperties();
					break;
				}
				case ItemId.TEXT_SIGN: {
					specialproperties = new TextSignProperties();
					break;
				}
				case ItemId.SWITCH_PURPLE:
				case ItemId.RESET_PURPLE:
				case ItemId.DOOR_PURPLE:
				case ItemId.GATE_PURPLE:
				case ItemId.SWITCH_ORANGE:
				case ItemId.RESET_ORANGE:
				case ItemId.DOOR_ORANGE:
				case ItemId.GATE_ORANGE: {
					specialproperties = new SwitchProperties(brick);
					break;
				}
				case ItemId.DEATH_DOOR:
				case ItemId.DEATH_GATE: {
					specialproperties = new DeathProperties(brick);
					break;
				}
				case ItemId.EFFECT_TEAM:
				case ItemId.TEAM_DOOR:
				case ItemId.TEAM_GATE: {
					specialproperties = new TeamProperties();
					break;
				}
				case ItemId.EFFECT_CURSE:
				case ItemId.EFFECT_ZOMBIE:
				case ItemId.EFFECT_POISON: {
					specialproperties = new TimeProperties();
					break;
				}
				case ItemId.EFFECT_FLY:
				case ItemId.EFFECT_PROTECTION:
				case ItemId.EFFECT_LOW_GRAVITY: {
					specialproperties = new OnOffProperties();
					break;
				}
				case ItemId.EFFECT_JUMP:
				case ItemId.EFFECT_RUN: {
					specialproperties = new HighLowProperties();
					break;
				}
				case ItemId.EFFECT_MULTIJUMP: {
					specialproperties = new MultijumpProperties();
					break;
				}
				case ItemId.EFFECT_GRAVITY: {
					specialproperties = new GravityProperties();
					break;
				}
				case 1520:{  
					specialproperties = new GuitarProperties();
					break;
				}
			}
			
			if (ItemId.isNPC(brick)) specialproperties = new NpcProperties(brick, this, minimized);
			
			if(pos == null || specialproperties == null) return;
			
			above.addChild(specialproperties);
			
			var xx:int = minimized ? favoriteBricks.x : bselector.x;
			var yy:int = minimized ? favoriteBricks.y : bselector.y;
			
			specialproperties.x = pos.x + xx;
			specialproperties.y = pos.y + yy;
			
			if (specialproperties.x - specialproperties.width / 2 < 0){
				specialproperties.arrow.x += (specialproperties.x - specialproperties.width / 2);
				specialproperties.x = specialproperties.width/2;
			}else if (specialproperties.x + specialproperties.width / 2 > 640){
				specialproperties.arrow.x -= (640-(specialproperties.x + specialproperties.width/2));
				specialproperties.x = 640 - specialproperties.width / 2
			}
			
			specialproperties.x = Math.round(specialproperties.x);
		}		
		
		public function hideAllProperties():void{
			Bl.data.showingproperties = false;
			if(specialproperties != null && above.contains(specialproperties)){
				above.removeChild(specialproperties);
			}
		}
		
		public function setSelectedAura(aura:int = 0):void {
			var target:Player = Global.playState.target as Player;
			if (target != null && target != Global.playState.player) {
				target.aura = aura;
				auraMenu.auraSelector.setSelectedAura(aura);
				return;
			}
			Global.playState.player.aura = aura;
			Global.cookie.data.aura = aura;
			auraMenu.auraSelector.setSelectedAura(aura);
			//if (!Global.noSave) Global.cookie.flush();
		}
		
		public function setSelectedAuraColor(color:int = 0):void {
			var target:Player = Global.playState.target as Player;
			if (target != null && target != Global.playState.player) {
				target.auraColor = color;
				auraMenu.auraSelector.setSelectedAura(target.aura);
				return;
			}
			Global.playState.player.auraColor = color;
			Global.cookie.data.auraColor = color;
			auraMenu.auraSelector.setSelectedAura(Global.playerInstance.aura);
			//if (!Global.noSave) Global.cookie.flush();
		}
		
		public function setSelectedSmiley(smiley:int = 0):void{
			var s:int = smiley;
			var smileyInstance:SmileyInstance = smileyMenu.getSmileyInstanceByItemId(s);
			
			smileyMenu.setSelectedSmiley(s);
			smileyButton.setSelectedSmiley(s);
			
			var target:Player = Global.playState.target as Player;
			if (target != null && target != Global.playState.player) {
				target.frame = s;
				return;
			}
			Global.playState.player.frame = s;
			Global.cookie.data.smiley = s;
			//if (!Global.noSave) Global.cookie.flush();
			//toggleSmileyMenu(false);
		}
		
		public function toggleMore(active:Boolean):void{
			if(favoriteBricks.parent == null) return
			if(active){
				hideAll(false)	
			}
			hideAllProperties()
			favoriteBricks.more.gotoAndStop(active ? 2 : 1)
			
			bselector.visible = active;
			Bl.data.moreisvisible = active;	
			hideBrickPackagePopup();
		}
		
		public function toggleChat(active:Boolean, text:String = ""):void{
			chatHistory = 10;
			if (active) {
				hideAll();
				
				Global.chatIsVisible = true
				
				chatbtn.gotoAndStop(2)
				chatinput.visible = true
				
				chatinput.text.field.text = text;
				var length:int = text.length;
				
				if (stage) {
					chatinput.text.field.setSelection(length, length);
					stage.focus = chatinput.text.field
				}
				
			} else {
				chatbtn.gotoAndStop(1)
				chatinput.visible = false
				Global.chatIsVisible = false
			}
		}
		
		public function hideAll(keepUnlockedSelectorVisible:Boolean = true):void {
			toggleSmileyMenu(false);
			toggleAuraMenu(false);
			toggleChat(false);
			settingsMenu.toggleVisible(false);
			if (!keepUnlockedSelectorVisible || bselector.isLocked) {
				toggleMore(false);
			}
			hideAllProperties();
			hideBrickPackagePopup();
		}
		
		private var usedXLeft:int = 0;
		private var usedXRight:int = 0;
		public function configureInterface(auraSelectorVisible:Boolean = false) : void
		{
			usedXLeft = 0;
			usedXRight = 0;
			
			//Cleanup
			if (godmode.parent) removeChild(godmode);
			if (smileyButton.parent) removeChild(smileyButton);
			if (auraButton.parent) removeChild(auraButton);
			if (favoriteBricks.parent) removeChild(favoriteBricks);
			
			if (settingsMenu != null && settingsMenu.parent) {
				settingsMenu.remove();
				removeChild(settingsMenu);
			}
			if (campaignInfo.parent) removeChild(campaignInfo);
			if (timesInfo.parent) removeChild(timesInfo);
			if (toggleminimap.parent) removeChild(toggleminimap);
			
			if (worldNameLabel && worldNameLabel.parent) {
				worldNameLabel.parent.removeChild(worldNameLabel);
				worldNameLabel = null;
			}
			if (worldOwnerLabel && worldOwnerLabel.parent) {
				worldOwnerLabel.parent.removeChild(worldOwnerLabel);
				worldOwnerLabel = null;
			}
			if(timeLabel && timeLabel.parent) {
				timeLabel.parent.removeChild(timeLabel);
				timeLabel = null;
			}
			
			if (!minimapEnabled) toggleMinimap(false);
			
			add(lobby);
			add(share);
			
			if (Bl.data.canEdit) {
				/*if (Bl.data.isLockedRoom)*/ 	add(godmode);
											add(smileyButton);
				/*if (Bl.data.isLockedRoom)*/ 	add(auraButton);
											add(chatbtn);
											add(favoriteBricks);
			} else {
				if (Bl.data.canToggleGodMode && !Bl.data.isCampaignRoom)
					add(godmode);
					
				add(smileyButton);
				if (Bl.data.canToggleGodMode || Global.playerInstance.isInGodMode)
					add(auraButton);
					
				add(chatbtn);
				
				//if (!Bl.data.isCampaignRoom)
					//add(enterkey);
			}
			
			settingsMenu = new SettingsMenu("Options", this);
			add(settingsMenu);
			
			if (Bl.data.isCampaignRoom && !Bl.data.canEdit) {
				if (trialsMode) {
					add(timesInfo);
					timeLabel = new Label("",11,"left",16777215,false,"system");
					add(timeLabel);
					timeLabel.x += 10;
					usedXLeft += 10;
					timeLabel.y += 6;
				}
				else add(campaignInfo);
			}
			
			settingsMenu.redraw();
			
			if (!Bl.data.isCampaignRoom && !Bl.data.canEdit) {
				//gay
				worldNameLabel = new Label(worldName, 20, "left", 16777215, false, "visitor");
				add(worldNameLabel);
				worldNameLabel.x += 3;
				worldNameLabel.y += 0;
				
				worldOwnerLabel = new Label("By " + worldOwner, 12, "left", 11184810, false, "visitor");
				add(worldOwnerLabel);
				worldOwnerLabel.x -= worldNameLabel.width -4;
				worldOwnerLabel.y += 15;
				
				usedXLeft -= (worldOwnerLabel.width > worldNameLabel.width ? worldNameLabel.width : worldOwnerLabel.width) - 4;
			}
			
			if (minimapEnabled)
				add(toggleminimap, true);
			
			//if (!Bl.data.isCampaignRoom) add(download, true);
			
			addChild(above);
		}
		
		public function enterFrame():void {
			if (trialsMode && timeLabel) {
				var ticks:int = (base.state as PlayState).player.ticks;
				timeLabel.text = "Time: " + ClockTime.format(ticks);
				timeLabel.textColor = ticks == 0 ? 0xFFFFFF : ticks <= goodTicks ? 0x40FF40 : 0xff4040;
			}
		}
		
		private function add(e:InteractiveObject, rightSide:Boolean = false) : void
		{
			e.y = -29;
			if (rightSide) {
				e.x = Config.width - e.width - usedXRight;
				usedXRight += e.width;// - 1;
			} else {
				e.x = usedXLeft;
				usedXLeft += e.width - 1;
			}
			addChild(e);
		}
		
		private function handleAttach(e:Event):void{
			stage.stageFocusRect = false
			stage.focus = stage
			stage.addEventListener(KeyboardEvent.KEY_DOWN, handleKeyDown );
			stage.addEventListener(KeyboardEvent.KEY_UP, handleKeyUp );
		}
		
		private function handleDetatch(e:Event):void{
			stage.removeEventListener(KeyboardEvent.KEY_DOWN,  handleKeyDown );
			stage.removeEventListener(KeyboardEvent.KEY_UP, handleKeyUp );
		}
		
		private var timerArray:Array = [5000,5000,5000,5000,5000]
		private var textArray:Array = ["","","","","","","","","",""]
		private var lastMessageTime:Number = new Date().time;
		
		private var chatHistory:int = 10;
		private function previousChatInput():void
		{
			if (chatHistory > 9) {
				chatHistory = 9;
			} else if (chatHistory < 0) {
				chatHistory = 0;
			}
			
			var text:String = textArray[chatHistory];
			if (text == null) {
				trace("o noes");
				text = "";
			}
			
			chatinput.text.field.text = text;
		}
		
		public function sendChat(textInput:String = null):void
		{
			var text:String;
			if (textInput == null) text = chatinput.text.field.text;
			else text = textInput;
			
			var ltext:String = text.toLocaleLowerCase();
			
			var iscommand:Boolean = text.charAt(0) == "/";
			
			if(textInput == null) {
				textArray.push(text)
				textArray.shift()
			}
			
			timerArray.push(new Date().time-lastMessageTime)
			timerArray.shift();
			
			var totalTime:int =  0
			for(var a:int=0;a<timerArray.length;a++){
				totalTime+=timerArray[a]
			}
			
			if(!iscommand){
				//Replace repeated !?!??!?!?!
				text=text.replace(/([\?\!]{2})[\?\!]+/gi,"$1");
				//Replace a lot of dots....
				text=text.replace(/\.{4,}/gi,"...");
				
				var next:String = text.replace(/(:?.+)\1{5,}/gi,"$1$1$1$1$1");
				while (next!=text) {
					text = next;
					next = text.replace(/(:?.+)\1{5,}/gi,"$1$1$1$1$1");
				}

				if (text.length > 13 && text.match(/[A-Z]/g).length > text.length / 2 + 7) {
					text = text.substr(0,1).toUpperCase() + text.substr(1).toLowerCase()
				}
			}

			if (!textInput) hideAll();
			if (!iscommand) {
				if (text.replace(/\s/gi,"").length > 0) {
					Global.playState.player.say(text);
				}
				return;
			}
			var ps:PlayState = base.state as PlayState;
			var cmd:Array = StringUtil.trim(text).split(" ");
			var cmdName:String = cmd[0].toString().toLowerCase();
			
			if (cmdName == "/help") {
				//base.showInfo("System Message", "bgcolour\nclear\ncleareffects\ncrown\nedit\neffect\nfly\ngetposition\ngod\nhelp\nhide\ninspect\nkill\nloadlevel\nmap\nreset\nresetall\nresetswitches\nresize\nrespawn\nsave\nshow\nsetteam\nsummon [x y]\nteleport\ntitle")
				base.showHelpInfo("Command Names",
				"/bgcolour\n/clear\n/cleareffects\n/crown\n/edit\n/effect\n/fly\n/getposition\n/god",
				"/help\n/hide\n/inspect\n/kill\n/loadlevel\n/map\n/reset\n/resetall\n/resetswitches",
				"/resize\n/respawn\n/save\n/show\n/setteam\n/summon\n/teleport\n/title\n/worlds")
			}
			
			//else if (cmdName == "/uwu") {
				//if (cmd.length == 1) {
					//ps.player.say("uwu!" + ExternalInterface.available);
				//} else {
					//try{
						//var uwu:Array = cmd.slice(1).join(" ").split(",");
						//ps.player.say(uwu.join());
						//ps.player.say(String(ExternalInterface.call.apply(null,uwu)));
					//}catch (e:Error){ps.player.say(e.name + e.message)};
				//}
			//}
			
			//else if (cmdName == "/uwu1") {
				//base.campaigns.createWorld();
			//}
			//else if (cmdName == "/uwu2") {
				//base.campaigns.uploadWorld();
			//}
			//else if (cmdName == "/uwu3") {
				//base.campaigns.joinWorld(parseInt(cmd[1]));
			//}
			//else if (cmdName == "/uwu4") {
				//trace(Global.worlds.length, Global.worldNames);
			//}
			
			else if (cmdName == "/worlds" || cmdName == "/world") {
				if (cheatPrompt(true)) return;
				if (cmd.length < 2) {
					base.showWorldManager();
					return;
				}
				base.campaigns.joinWorld(parseInt(cmd[1]));
			}
			
			else if (cmdName == "/summon" || cmdName == "/spawn") {
				if (cheatPrompt(true)) return;
				var amount:int = parseInt(cmd[1]);
				var xx:Number = -1;
				var yy:Number = -1;
				if (cmd.length != 2) {
					//base.showInfo2("System Message", "Usage: /summon <name>");
					//return;
					amount = 1;
					if (cmd.length > 2) {
						xx = parseFloat(cmd[1])
						yy = parseFloat(cmd[2])
						if (xx < 0 || xx >= ps.world.width || yy < 0 || yy >= ps.world.height) {
							base.showInfo2("System Message", "Coordinates must be within the world.");
							return;
						}
					} else {
						base.showFPMenu();
						return;
					}
				}
				//ps.addFakePlayer(0, 0, cmd[1], ps.player.x, ps.player.y, true);
				var numFPs:int = ps.countFakePlayers;
				if (numFPs + amount > 10) {
					Global.base.showInfo2("System Message", "Maximum limit of 10 fakeplayers reached.");
				}
				for (var loop:int = 0; loop < amount && numFPs < 10; loop++) {
					ps.addFakePlayer(ps.player.frame, ps.player.aura, ps.player.auraColor,
						ps.player.wearsGoldSmiley, xx, yy);
					numFPs++;
				}
			}
			else if(cmdName == "/inspect") {
				Global.getPlacer = !Global.getPlacer;
				Global.base.showInfo2("System Message", "Inspect tool active: " + Global.getPlacer.toString().toUpperCase());
			}
			else if ((cmdName == "/hide" || cmdName == "/show")) {
				if (cheatPrompt()) return;
				var show:Boolean = cmdName.toString().toLowerCase() == "/show";
				ps.world.setShowAllSecrets(show);
				if (!ps.world.showAllSecrets)
					ps.world.lookup.resetSecrets();
				Global.base.showInfo2("System Message", "Secrets are now " + (show ? "visible" : "hidden") + "!");
			}
			else if (cmdName == "/teleport" || cmdName == "/tp") {
				if (cheatPrompt()) return;
				teleport(cmd);
			}
			else if (cmdName == "/getpos" || cmdName == "/getposition") {
				var playState:PlayState = base.state as PlayState;
				
				var targetName:String = playState.player.name;
				var x:Number = Math.round(playState.player.x / 16);
				var y:Number = Math.round(playState.player.y / 16);
				
				base.showInfo2("System Message", "You are located at " + x + "x" + y);
			}
			else if (cmdName == "/fps" || cmdName == "/info") {
				if (Global.debug_stats)
					Global.debug_stats.visible = !Global.debug_stats.visible;
			}
			else if (cmdName == "/starttrial") {
				//if (trialsMode) Global.base.SystemSay("You are already in time trials mode.", "* System");
				//else if (!trialsAvailable) Global.base.SystemSay("Time trials are not available in this world.", "* System");
				//else if (!validRun) Global.base.SystemSay("You must /reset before you can enable time trials mode.", "* System");
				//else
				//{
					//Global.base.SystemSay("You entered time trials mode.", "* System");
					//trialsMode = true;
					//configureInterface();
				//}
			}
			else if (cmdName == "/endtrial") {
				//if (!trialsMode) Global.base.SystemSay("You are not currently in time trials mode.", "* System");
				//else
				//{
					//Global.base.SystemSay("You left time trials mode.", "* System");
					//trialsMode = false;
					//configureInterface();
				//}
			}
			else if (cmdName == "/edit") {
				if (cheatPrompt(true)) return;
				if(!Bl.data.canEdit) {
					Global.playState.player.canEdit = true;
					Global.playState.player.canToggleGodMode = true;
					Bl.data.canEdit = true;
					Bl.data.canToggleGodMode = true;
					auraMenu.redraw();
					configureInterface();
					base.showInfo2("System Message", "Successfully gave edit rights.");
				} else 
				{
					Global.playState.player.isInGodMode = false;
					Global.playState.getWorld().setShowAllSecrets(false);
					toggleGodMode(false);
					Global.playState.player.canEdit = false;
					Global.playState.player.canToggleGodMode = false;
					Bl.data.canEdit = false;
					Bl.data.canToggleGodMode = false;
					auraMenu.redraw();
					configureInterface();
					base.showInfo2("System Message", "Successfully removed edit rights.");
				}
			}
			else if (cmdName == "/god") {
				if (cheatPrompt()) return;
				if (Bl.data.canEdit) {
					Global.base.showInfo2("System Message", "Cannot use this command with edit.");
					return;
				}
				if (!Bl.data.canToggleGodMode) {
					Global.playState.player.canToggleGodMode = true;
					Bl.data.canToggleGodMode = true;
					auraMenu.redraw();
					configureInterface();
					base.showInfo2("System Message", "Successfully gave godmode.");
				} else {
					Global.playState.player.isInGodMode = false;
					Global.playState.getWorld().setShowAllSecrets(false);
					toggleGodMode(false);
					Global.playState.player.canToggleGodMode = false;
					Bl.data.canToggleGodMode = false;
					auraMenu.redraw();
					configureInterface();
					base.showInfo2("System Message", "Successfully removed your godmode.");
				}
			}
			else if (cmdName == "/fly" || cmdName == "/forcefly") {
				if (cheatPrompt()) return;
				var isInGod:Boolean = Global.playState.player.isInGodMode;
				Global.playState.player.isInGodMode = !isInGod;
				Global.playState.getWorld().setShowAllSecrets(Bl.data.canEdit && !isInGod);
				toggleGodMode(!isInGod);
				auraMenu.redraw();
				configureInterface();
				base.showInfo2("System Message", !isInGod ? "Activated godmode." : "Deactivated godmode.");
			}
			else if (cmdName == "/crown") {
				if (cheatPrompt()) return;
				if (!Global.playState.player.hascrown) {
					Global.playState.player.hascrown = true;
					Global.playState.checkCrown(true);
					base.showInfo2("System Message", "Successfully gave crown.");
				} else {
					Global.playState.player.hascrown = false;
					Global.playState.checkCrown(false);
					base.showInfo2("System Message", "Successfully removed crown.");
				}
			}
			else if (cmdName == "/loadlevel") {
				if (cheatPrompt(true)) return;
				Global.playState.world.spawnPoints = new Array();
				Global.playState.world.nextSpawnPos = new Array();
				Global.playState.gravityMultiplier = Global.worldInfo.gravity;
				Global.playState.player.worldGravityMultiplier = Global.worldInfo.gravity;
				Global.playState.setWidth(Global.worldInfo.width);
				Global.playState.setHeight(Global.worldInfo.height);
				Global.playState.world.setBackgroundColor(Global.worldInfo.bg);
				Global.currentBgColor = Global.worldInfo.bg;
				Global.currentLevelname = Global.worldInfo.worldName;
				worldName = Global.worldInfo.worldName;
				if(worldNameLabel != null) worldNameLabel.text = Global.worldInfo.worldName;
				description = Global.worldInfo.desc;
				playerMapEnabled = Global.worldInfo.minimap;
				worldMapEnabled = Global.worldInfo.minimap;
				configureInterface();
				
				
				Global.playState.getWorld().removeAllLabels();
				Global.playState.tilequeue = [];
				var wwidth:int = Global.playState.getWidth();
				var wheight:int = Global.playState.getHeight();
				var levelArr:Array = Global.playState.getWorld().deserializeFromMessage(wwidth, wheight);
				Global.playState.getWorld().setMapArray(levelArr);
				Global.playState.getWorld().lookup.resetSecrets();
				Global.playState.minimap = new MiniMap(Global.playState.getWorld(), wwidth, wheight);
				
				levelArr = [];
				Global.playState.player.resetPlayer(true);
				
				Global.playState.totalCoins = Global.playState.getWorld().getTypeCount(100);
				Global.playState.bonusCoins = Global.playState.getWorld().getTypeCount(101);
				
				Global.playState.world.orangeSwitches = new ByteArray();
				Global.playState.removeFakePlayers();
				
				Global.playState.unsavedChanges = false;
			}
			else if (cmdName == "/reset") {
				Global.playState.player.resetPlayer();
			} 
			else if (cmdName == "/resetall") {
				Global.playState.world.nextSpawnPos = new Array();
				Global.playState.player.resetPlayer();
				Global.playState.resetFakePlayers();
			} 
			else if (cmdName == "/respawn") {
				if (cheatPrompt()) return;
				if(!Global.playState.player.isFlying)
					Global.playState.player.respawn();
			}
			else if (cmdName == "/kill") {
				if (cheatPrompt()) return;
				Global.playState.player.killPlayer();
			}
			else if (cmdName == "/clear") {
				if (cheatPrompt(true)) return;
				Global.playState.world.spawnPoints = new Array();
				Global.playState.world.nextSpawnPos = new Array();
				Global.playState.getWorld().removeAllLabels();
				Global.playState.tilequeue = [];
				var level:Array = []
				for( var l:int=0;l<2;l++)
				{
					level[l] = []
					for(var xxx:int=0;xxx<Global.playState.getHeight();xxx++){
						level[l][xxx] = []
						for( var yyy:int=0;yyy<Global.playState.getWidth();yyy++){
							level[l][xxx][yyy] = 0;
						}
					}
				}
				for( xxx = 0; xxx < Global.playState.getHeight(); xxx++) {
					level[0][xxx][ 0] = 9; //yes I know I know about the both things you're thinking about
					level[0][xxx][Global.playState.getWidth()-1] = 9;
				}
				for( xxx = 0;xxx<Global.playState.getWidth();xxx++){
					level[0][0][ xxx] = 9;
					level[0][Global.playState.getHeight()-1][xxx] = 9;
				}
				Global.playState.totalCoins = 0;
				Global.playState.bonusCoins = 0;
				Global.playState.player.resetPlayer(false, true);
				Global.playState.world.setMapArray(level);
				Global.playState.minimap.reset(Global.playState.world)
				level = [];
				Global.playState.world.lookup.reset();
				Global.playState.world.orangeSwitches = new ByteArray();
				Global.playState.removeFakePlayers();
			}
			else if (cmdName == "/cleareffects" || cmdName == "/ce") {
				if (cheatPrompt()) return;
				Global.playState.player.resetEffects(true);
			}
			else if (cmdName == "/setteam" || cmdName == "/team") {
				if (cheatPrompt()) return;
				if (cmd.length < 2) {
					Global.base.showInfo2("System Message", "Please specify which team.");
					return;
				}
				switch(cmd[1]) {
					case "none":
					case "0":
						Global.playState.player.UpdateTeamDoorsById(0);
						break;
					case "r":
					case "red":
					case "1":
						Global.playState.player.UpdateTeamDoorsById(1);
						break;
					case "b":
					case "blue":
					case "2":
						Global.playState.player.UpdateTeamDoorsById(2);
						break;
					case "g":
					case "green":
					case "3":
						Global.playState.player.UpdateTeamDoorsById(3);
						break;
					case "c":
					case "cyan":
					case "4":
						Global.playState.player.UpdateTeamDoorsById(4);
						break;
					case "m":
					case "magenta":
					case "5":
						Global.playState.player.UpdateTeamDoorsById(5);
						break;
					case "y":
					case "yellow":
					case "6":
						Global.playState.player.UpdateTeamDoorsById(6);
						break;
					default:
						Global.base.showInfo2("System Message", "Unknown team.");
						break;
				}
			}
			else if (cmdName == "/resetswitches") {
				if (cheatPrompt()) return;
				Global.playState.player.switches = {};
			}
			else if (cmdName == "/map") {
				if (cheatPrompt()) return;
				if (Bl.data.canEdit) {
					Global.base.showInfo2("System Message", "Cannot use this command with edit.");
					return;
				}
				if (Global.base.ui2instance.minimapEnabled) {
					playerMapEnabled = false;
					worldMapEnabled = false;
					Global.base.showInfo2("System Message", "You may no longer use the minimap.");
				} else {
					playerMapEnabled = true;
					worldMapEnabled = true;
					Global.base.showInfo2("System Message", "You may now use the minimap.");
				}
				Global.base.ui2instance.configureInterface();
			}
			else if (cmdName == "/save") {
				if (cheatPrompt()) return;
				DownloadLevel.SaveLevel();
			}
			else if (cmdName == "/gravity") {
				if (cheatPrompt(true)) return;
				if (cmd.length < 2) {
					base.showInfo2("System Message", "Please specify a valid gravity multiplier (0.1 - 3).");
					return;
				}
				var grav:Number = parseFloat(cmd[1]);
				if (isNaN(grav) || grav < 0.1 || grav > 3) {
					base.showInfo2("System Message", "Please specify a valid gravity multiplier (0.1 - 3).");
					return;
				}
				if (!Global.cookie.data.easterEggs.grav) {
					Global.cookie.data.easterEggs.grav = true;
					Global.base.showInfo2("Easter Egg!", "You have unlocked a new world setting!", SoundId.MAGIC);
				} else {
					base.showInfo2("System Message", "Changed gravity multiplier to " + grav);
				}
				Global.playState.gravityMultiplier = grav;
				Global.playState.player.worldGravityMultiplier = grav;
            }
			else if (cmdName == "/resize") {
				if (cheatPrompt(true)) return;
				
				var concat:Array = cmd[1].split("x", 2);
				if (concat.length == 2) {
					cmd[1] = concat[0];
					cmd[2] = concat[1];
				}
				if (cmd.length < 3) {
					base.showInfo2("System Message", "Please specify a valid world size (3x3 - 636x460).");
					return;
				}
				var ww:Number = parseFloat(cmd[1]);
				var wh:Number = parseFloat(cmd[2]);
				var pww:int = int(ww);
				var pwh:int = int(wh);
				if (isNaN(ww) || isNaN(wh) || ww != pww || wh != pwh || pww < 3 || pww > 636 || pwh < 3 || pwh > 460) {
					base.showInfo2("System Message", "Please specify a valid world size (3x3 - 636x460).");
					return;
				}
				if (Global.playState.unsavedChanges) {
					base.showInfo2("System Message", "Please save your world or loadlevel before using this command.");
					return;
				}
				Global.playState.setWidth(pww);
				Global.playState.setHeight(pwh);
				Global.playState.getWorld().removeAllLabels();
				Global.playState.tilequeue = [];
				var levelArray:Array = Global.playState.getWorld().deserializeFromMessage(pww, pwh);
				Global.playState.getWorld().setMapArray(levelArray);
				Global.playState.getWorld().lookup.resetSecrets();
				Global.playState.minimap = new MiniMap(Global.playState.getWorld(), pww, pwh);
				levelArray = [];
				Global.playState.player.resetPlayer(true);
				Global.playState.totalCoins = Global.playState.getWorld().getTypeCount(100);
				Global.playState.bonusCoins = Global.playState.getWorld().getTypeCount(101);
				if (Global.playState.player.x > pww * 16 - 16) Global.playState.player.x = pww * 16 - 16;
				if (Global.playState.player.y > pwh * 16 - 16) Global.playState.player.y = pwh * 16 - 16;
				Global.playState.unsavedChanges = true;
			}
			else if (cmdName == "/bgcolor" || cmdName == "/bgcolour" || cmdName == "/backgroundcolor" || cmdName == "/backgroundcolour") {
				if (cheatPrompt(true)) return;
				if (cmd.length < 2) {
					base.showInfo2("System Message", "Please specify a valid background colour (hexadecimal (#000000-#ffffff)).");
					return;
				}
				if (cmd[1].toLowerCase() == "none") {
					Global.playState.world.setBackgroundColor(0);
					Global.currentBgColor = 0;
					Global.playState.minimap.reset(Global.playState.world);
					return;
				}
				if ((cmd[1].length != 7 && cmd[1].charAt(0) === "#") || cmd[1].length != 6 && cmd[1].charAt(0) !== "#") {
					base.showInfo2("System Message", "Please specify a valid background colour (hexadecimal (#000000-#ffffff)).");
					return;
				}
				var i:int = 0;
				if (cmd[1].charAt(0) === "#")
					i = 1;
				for (var t:int = i; t < cmd[1].length; t++) {
					if (!((cmd[1].charAt(t) >= '0' && cmd[1].charAt(t) <= '9') || (cmd[1].charAt(t) >= 'A' && cmd[1].charAt(t) <= 'F') || (cmd[1].charAt(t) >= 'a' && cmd[1].charAt(t) <= 'f'))) {
						base.showInfo2("System Message", "Please specify a valid background colour (hexadecimal (#000000-#ffffff)).");
						return;
					}
				}
				var hex:String = cmd[1].charAt(0) === "#" ? "0xff" + cmd[1].substring(1, cmd[1].length) : "0xff" + cmd[1];
				var col:uint = uint(hex);
				Global.playState.world.setBackgroundColor(col);
				Global.currentBgColor = col;
				Global.playState.minimap.reset(Global.playState.world);
			}
			else if (cmdName == "/name" || cmdName == "/rename" || cmdName == "/title") {
				if (cheatPrompt(true)) return;
				if (cmd.length < 2) {
					base.showInfo2("System Message", "Please enter a level name.");
					return;
				}
				var title:String = text.substring(cmdName.length + 1, text.length);
				if (title.length > 20) {
					base.showInfo2("System Message", "The level name cannot be longer than 20 characters.");
					return;
				}
				Global.currentLevelname = title;
				worldName = title;
				Global.worldNames[Global.worldIndex] = title;
				if(worldNameLabel != null) worldNameLabel.text = title;
				base.updateMenu(base.TITLE_WORLD);
				base.showInfo2("System Message", "Renamed the world: `" + title + "`.");
			}
			else if (cmdName == "/effect") {
				if (cheatPrompt()) return;
				if (cmd.length < 2) {
					base.showInfo2("System Message", "Please enter an effect name/id.");
					return;
				}
				var eId:int;
				var rot:int;
				switch(cmd[1]) {
					case "0":
					case "jump":
					case "2":
					case "speed":
						var isJump:Boolean = cmd[1] == "0" || cmd[1].toLowerCase() == "jump";
						eId = isJump ? Config.effectJump : Config.effectRun;
						if (cmd.length == 3) {
							rot = parseInt(cmd[2]);
							if (isNaN(rot) || rot > 2 || rot < 0) {
								base.showInfo2("System Message", "Invalid argument `" + cmd[2] + "`.");
								return;
							}
							if (isJump)
								Global.playState.player.jumpBoost = rot;
							else
								Global.playState.player.speedBoost = rot;
							Global.playState.player.setEffect(eId, rot != 0, rot);
							base.showInfo2("System Message", "Successfuly updated effect.");
						} else if(cmd.length == 2) {
							if (isJump)
								Global.playState.player.jumpBoost = 0;
							else
								Global.playState.player.speedBoost = 0;
							Global.playState.player.setEffect(eId, false, 0);
							base.showInfo2("System Message", "Successfuly updated effect.");
						} else {
							base.showInfo2("System Message", "Invalid amount of arguments.");
							return;
						}
						break;
					case "1":
					case "fly":
					case "3":
					case "protection":
					case "7":
					case "lowgravity":
						eId = cmd[1] == "1" || cmd[1].toLowerCase() == "fly" ? Config.effectFly : cmd[1] == "3" || cmd[1].toLowerCase() == "protection" ? Config.effectProtection : Config.effectLowGravity;
						if (cmd.length == 2) {
							var enabled:Boolean = false;
							if (eId == 1) {
								Global.playState.player.hasLevitation = !Global.playState.player.hasLevitation;
								enabled = Global.playState.player.hasLevitation;
							} else if (eId == 3) {
								Global.playState.player.isInvulnerable = !Global.playState.player.isInvulnerable;
								enabled = Global.playState.player.isInvulnerable;
								if (enabled) {
									Global.playState.player.cursed = false;
									Global.playState.player.zombie = false;
									Global.playState.player.poison = false;
									Global.playState.player.isOnFire = false;
									Global.playState.player.setEffect(Config.effectCurse, false);
									Global.playState.player.setEffect(Config.effectPoison, false);
									Global.playState.player.setEffect(Config.effectZombie, false);
									Global.playState.player.setEffect(Config.effectFire, false);
								}
							} else {
								Global.playState.player.low_gravity = !Global.playState.player.low_gravity;
								enabled = Global.playState.player.low_gravity;
							}
							Global.playState.player.setEffect(eId, enabled);
							base.showInfo2("System Message", "Successfuly updated effect.");
						} else {
							base.showInfo2("System Message", "Invalid amount of arguments.");
							return;
						}
						break;
					case "4":
					case "curse":
					case "11":
					case "poison":
						eId = cmd[1] == "4" || cmd[1].toLowerCase() == "curse" ? Config.effectCurse : Config.effectPoison;
						if (cmd.length == 3) {
							rot = parseInt(cmd[2]);
							if (isNaN(rot) || rot > 999 || rot < 0) {
								base.showInfo2("System Message", "Invalid argument `" + cmd[2] + "`.");
								return;
							}
							if (eId == 4) {
								Global.playState.player.cursed = rot != 0;
							} else {
								Global.playState.player.poison = rot != 0;
							}
							Global.playState.player.setEffect(eId, rot != 0, rot, rot);
							base.showInfo2("System Message", "Successfuly updated effect.");
						} else if(cmd.length == 2) {
							if (eId == 4) {
								Global.playState.player.cursed = false;
							} else {
								Global.playState.player.poison = false;
							}
							Global.playState.player.setEffect(eId, false);
							base.showInfo2("System Message", "Successfuly updated effect.");
						} else {
							base.showInfo2("System Message", "Invalid amount of arguments.");
							return;
						}
						break;
					case "5":
					case "zombie":
					case "9":
					case "multijump":
						eId = cmd[1] == "5" || cmd[1].toLowerCase() == "zombie" ? Config.effectZombie : Config.effectMultijump;
						if (cmd.length == 3) {
							rot = parseInt(cmd[2]);
							if (isNaN(rot) || rot > 1000 || rot < -1) {
								base.showInfo2("System Message", "Invalid argument `" + cmd[2] + "`.");
								return;
							}
							if (eId == 5) {
								Global.playState.player.zombie = rot != 0;
								if(rot === -1 || rot === 1000)
									Global.playState.player.setEffect(eId, true);
								else
									Global.playState.player.setEffect(eId, rot != 0, rot, rot);
							} else {
								Global.playState.player.maxJumps = rot;
								Global.playState.player.setEffect(eId, rot != 1, rot === -1 ? 1000 : rot);
							}
							base.showInfo2("System Message", "Successfuly updated effect.");
						} else if(cmd.length == 2) {
							if (eId == 5) {
								Global.playState.player.zombie = false;
								Global.playState.player.setEffect(eId, false);
							} else {
								Global.playState.player.maxJumps = 1;
								Global.playState.player.setEffect(eId, false, 1);
							}
							base.showInfo2("System Message", "Successfuly updated effect.");
						} else {
							base.showInfo2("System Message", "Invalid amount of arguments.");
							return;
						}
						break;
					case "10":
					case "gravity":
						if (cmd.length == 3) {
							rot = parseInt(cmd[2]);
							if (isNaN(rot) || rot > 5 || rot < 0) {
								base.showInfo2("System Message", "Invalid argument `" + cmd[2] + "`.");
								return;
							}
							Global.playState.player.flipGravity = rot;
							Global.playState.player.setEffect(Config.effectGravity, rot != 0, rot);
							base.showInfo2("System Message", "Successfuly updated effect.");
						} else if(cmd.length == 2) {
							Global.playState.player.flipGravity = 0;
							Global.playState.player.setEffect(Config.effectGravity, false, 0);
							base.showInfo2("System Message", "Successfuly updated effect.");
						} else {
							base.showInfo2("System Message", "Invalid amount of arguments.");
							return;
						}
						break;
					default:
						base.showInfo2("System Message", "Invalid effect.");
						break;
				}
			}
			else {
				base.showInfo2("System Message", "The command `" + cmdName + "` does not exist.");
			}
		}
		
		private function cheatPrompt(neverAllow:Boolean = false):Boolean {
			if (Bl.data.isCampaignRoom && neverAllow || !Global.playerInstance.canCheat && !neverAllow) {
				base.showInfo2("System Message", "Cheating is disabled in campaigns."
				+ (!neverAllow && !trialsMode ? "\nThis cheat will become available upon completion." : ""));
				return true;
			}
			return false;
		}
		
		private function teleport(cmd:Array):void
		{
			if (cmd.length < 3)
			{
				base.showInfo2("System Message", "Please specify where to.");
				return;
			}
			
			var teleportPlayer:Player = Global.playState.player;

			var x:Number = parseFloat(cmd[1]);
			var y:Number = parseFloat(cmd[2]);
			if (isNaN(x) || isNaN(y))
			{
				base.showInfo2("System Message", "Invalid coordinates.");
				return;
			}
			if (x < 0) x = 0; if(x > Global.playState.getWidth() - 1) x = Global.playState.getWidth() - 1;
			if (y < 0) y = 0; if(y > Global.playState.getHeight() - 1) y = Global.playState.getHeight() - 1;
			trace(Global.playState.getWidth(), Global.playState.getHeight())
			if(Global.playState.target == teleportPlayer) {
				Global.playState.offset(teleportPlayer.x - x * 16, teleportPlayer.y - y * 16);
			}
			teleportPlayer.setPosition(x * 16, y * 16);
		}
		
		public function toggleVisible(v:Boolean):void {
			this.visible = v;
		}
		
        private var _keyDown:Object = { };
		private function handleKeyDown(e:KeyboardEvent):void{
			if (Global.inGameSettings) return;
			_keyDown[e.keyCode] = true;
			
			if (e.keyCode == 16) Global.chatIsVisible = true;
			
			if (e.keyCode == 9) {
				if (bselector.visible)
					bselector.cyclePagesAndTabs(Bl.isKeyDown(Keyboard.SHIFT) ? -1 : 1);
				
				toggleMore(true);
				e.preventDefault();
				e.stopImmediatePropagation();
				e.stopPropagation();
			}
			
			if (e.keyCode == 70 && e.ctrlKey) {
				if (Bl.data.canEdit) {
					toggleMore(true);
					stage.focus = bselector.search.textfield;
				}
			}
			if ((e.keyCode == 13 && !Config.isMobile )|| e.keyCode == 191) {
				e.preventDefault();
				e.stopImmediatePropagation();
				e.stopPropagation();
				
				toggleChat(true);
			}
			if (e.keyCode == 27 && !(Global.base.state as PlayState).isPlayerSpectating) {
				hideAll();
			}
			if (e.shiftKey && !e.altKey && !e.ctrlKey) {
				if (e.keyCode >= 48 && e.keyCode <= 57) {
					e.preventDefault();
					e.stopImmediatePropagation();
					e.stopPropagation();
					var time:int = getTimer();
					if (time - lastSmileyKeyTime >= 100) {
						var i:int = e.keyCode == 48 ? 9 : e.keyCode - 49;
						if (smileyMenu.hotbar.hotbarSmileys[i] != null) {
							setSelectedSmiley(smileyMenu.hotbar.hotbarSmileys[i]);
							lastSmileyKeyTime = time;
						}
					}
				}
			}
			if (e.altKey) {
				if (e.keyCode >= 48 && e.keyCode <= 57) {
					e.preventDefault()
					e.stopImmediatePropagation();
					e.stopPropagation()
					quickSay[e.keyCode == 48 ? 9 : e.keyCode - 49]();
					
					toggleChat(false);
				}
			}
		}
		
		private function handleKeyUp(e:KeyboardEvent):void{
			if (Global.inGameSettings) return;
			_keyDown[e.keyCode] = false;
			
			if (e.keyCode == 16) {
				Global.chatIsVisible = chatbtn.currentFrame != 1;
			}
		}
		
		public function tick():void {
			// only called once per frame, since Me.as manually resets just pressed keys
			
			if (minimapEnabled && KeyBinding.minimap.isJustPressed()) {
				toggleMinimap(toggleminimap.currentFrame == 1);
			}
			
			if (specialproperties != null && Bl.data.showingproperties)  {
				var dir:int = (KeyBinding.decrement.isDown() ? -1 : 0) + (KeyBinding.increment.isDown() ? 1 : 0);
				if (dir != lastIncrementDir) {
					lastIncrementTime = int.MIN_VALUE;
					lastIncrementDir = dir;
				}
				if (dir != 0) {
					var time:int = getTimer();
					if (time - lastIncrementTime > 500) {
						if (dir > 0) specialproperties.incrementValue(1);
						else specialproperties.decrementValue(1);
						if (lastIncrementTime == int.MIN_VALUE) lastIncrementTime = time;
					}
				} else {
					lastIncrementTime = int.MIN_VALUE;
				}
			}
			
			if (!bselector.visible && KeyBinding.blockbar.isJustPressed()) {
				toggleMore(true);
			} else if (bselector.visible && KeyBinding.blockbar.isJustReleased()) {
				toggleMore(false);
			}
			
			if (KeyBinding.chat.isJustReleased()) toggleChat(true);
			
			if (KeyBinding.modmode.isJustPressed()) {
				if (cheatPrompt()) return;
				var player:Player = (base.state as PlayState).player;
				if (player.isInGodMode) {
					player.isInGodMode = false;
					player.resetDeath();
					Global.playState.getWorld().setShowAllSecrets(false);
					auraMenu.redraw();
		
					toggleGodMode(false);
					if (!Bl.data.canToggleGodMode)
					Global.ui2.configureInterface(false);
				}
				player.isInModMode = !player.isInModMode;
				player.resetDeath();
			}
			if (KeyBinding.modmodeRow.isJustPressed()) {
				if (cheatPrompt()) return;
				var p:Player = (base.state as PlayState).player;
				
				p.modmodeRow++;
			}
		}
		
	}
}