package{
	import animations.AnimationManager;
	import blitter.BlContainer;
	import com.greensock.core.SimpleTimeline;
	import flash.display.DisplayObject;
	import flash.display.SimpleButton;
	import flash.display.SpreadMethod;
	import sample.ui.components.Label;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.system.Capabilities;
	import ui.campaigns.CampaignPage;
	import ui.campaigns.CampaignTrialDone;
	import utilities.AsyncTasks;
	
	import blitter.Bl;
	import blitter.BlGame;
	
	import com.greensock.*;
	import com.greensock.easing.*;
	import com.greensock.plugins.*;
	import com.jac.mouse.MouseWheelEnabler;
	import com.reygazu.anticheat.events.CheatManagerEvent;
	import com.reygazu.anticheat.managers.CheatManager;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.MovieClip;
	import flash.display.StageAlign;
	import flash.display.StageDisplayState;
	import flash.display.StageScaleMode;
	import flash.events.ContextMenuEvent;
	import flash.events.Event;
	import flash.events.FullScreenEvent;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.external.ExternalInterface;
	import flash.net.SharedObject;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.system.LoaderContext;
	import flash.system.Security;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.ui.ContextMenu;
	import flash.ui.ContextMenuItem;
	import flash.utils.ByteArray;
	import flash.utils.setInterval;
	import flash.utils.setTimeout;
	
	import input.KeyState;
	
	import io.player.tools.Badwords;
	
	import items.ItemBrick;
	import items.ItemManager;
	import items.ItemSmiley;
	
	import sounds.SoundId;
	import sounds.SoundManager;
	
	import states.JoinState;
	import states.LobbyState;
	import states.LobbyStatePage;
	import states.PlayState;
	
	import ui.CopyPrompt;
	import ui.ConfirmPrompt;
	import ui.InfoDisplay;
	import ui.LoadingScreen;
	import ui.Prompt;
	import ui.campaigns.CampaignComplete;

	import ui2.ui2minusbtn;
	import ui2.ui2plusbtn;
	
	import items.ItemLayer;
	
	import flash.display.LoaderInfo;
	
	public class EverybodyEdits extends BlGame
	{
		public var ui2instance:UI2;
		
		public var ee_menu:ContextMenu = new ContextMenu();
		
		protected var iseecom:Boolean = false;
		
		private var showDisconnectedMessage:Boolean = true;
		
		protected var roomname:String = null;
		protected var forcejoin:String = null;
		protected var email_confirm_key:String = null;
		
		public var loading:LoadingScreen;
		
		public var filterbadwords:Boolean = false;

		private var eiw:ExternalInterfaceWrapper;

		private var cc:CampaignComplete;
		private var ctd:CampaignTrialDone;
		
		private var infoBox:InfoDisplay;
		private var infoBox1:InfoBox;
		private var infoBoxBG:BlackBG;
		private var infoBox2:HelpInfoBox;
		
		private var fullscreenBlack:BlackBG = new BlackBG();
		
		public var settings:SettingsManager = new SettingsManager();
		public var campaigns:CampaignPage = null;
		
		public const TITLE_FP:String = "Players";
		public const TITLE_EDIT:String = "Edit Tools";
		public const TITLE_WORLD:String = "Worlds";
		
		public function EverybodyEdits(){
			//Init blitter
			
			super(640,480,1);
			Global.base = this;
			
			// Tweening Plugins
			TweenPlugin.activate([BlurFilterPlugin, GlowFilterPlugin, ColorTransformPlugin, DropShadowFilterPlugin]);
			
			//Basic configruatv ion
			Bl.data.brick = 0;
			Bl.data.base = this;
			
			Bl.data.roomname = "";
			Bl.data.name = "";
			
			Bl.data.portal_id = 0;
			Bl.data.portal_target = 0;
			Bl.data.world_portal_id = Global.worldIndex;
			Bl.data.world_portal_name = "";
			Bl.data.world_portal_target = 0;
			Bl.data.spawn_id = 1;
			
			Bl.data.npc_name = "";
			Bl.data.npc_mes1 = "";
			Bl.data.npc_mes2 = "";
			Bl.data.npc_mes3 = "";
			
			Bl.data.jumps = 2;
			Bl.data.coincount = 10;
			Bl.data.switchId = 0;
			Bl.data.wrapLength = 200;
			Bl.data.deathcount = 10;
			Bl.data.team = 0;
			Bl.data.direction = 0;
			Bl.data.effectDuration = 10;
			Bl.data.onStatus = true;
			Bl.data.mode = 1;
			
			addEventListener(Event.ADDED_TO_STAGE, handleAttach);
			
			addEventListener(Event.ADDED_TO_STAGE, handleAddedToStage, false, 0, true);
			
			eiw = new ExternalInterfaceWrapper();
			
			// EE Context Menu
			ee_menu.hideBuiltInItems();
			ee_menu.builtInItems.zoom = true;
			
			var version:ContextMenuItem = new ContextMenuItem("Everybody Edits Offline");
			
			version.enabled = false;
			
			ee_menu.customItems.push(version);
			
			function listenAndShow(target:ContextMenuItem, path:String):void {
				target.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, function(e:ContextMenuEvent):void {
					navigateToURL(new URLRequest(path), "_blank");
				});
			}
		}
		
		protected function handleAddedToStage(event:Event):void
		{
			Bl.stage.removeEventListener(Event.ADDED_TO_STAGE,handleAddedToStage);
			Bl.stage.addEventListener(NavigationEvent.JOIN_WORLD,handleJoinWorld,false,0,true);
			KeyState.activate(Bl.stage);
			
			(Bl.stage.getChildAt(0) as MovieClip).contextMenu = ee_menu;
			
			MouseWheelEnabler.init(Bl.stage);
			
			Global.EMBED_WIDTH = stage.stageWidth;
		}
		
		private var mapBG:BlackBG;
		
		protected function handleJoinWorld(e:NavigationEvent):void
		{
			clearOverlayContainer();
			cleanUIAndConnections();
			joinDownloaded(e.world_id, e.world_name, e.extra.owner, e.extra.gravity, e.extra.bg, e.extra.minimap, e.extra.width, e.extra.height, e.joindata, e.joindata && e.joindata.trialsmode == "true", e.extra.spawn);
		}
		
		private function handleFullScreen(e:Event):void {
			if (Bl.stage.displayState == StageDisplayState.NORMAL) { //exiting fullscreen
				Bl.stage.align = StageAlign.TOP_LEFT;
				Bl.stage.scaleMode = StageScaleMode.NO_SCALE;
				setTimeout(hideInvisibleMask, 100);
			} else { //entering fullscreen
				Bl.stage.scaleMode = StageScaleMode.SHOW_ALL;
				Bl.stage.align = StageAlign.TOP;
				Bl.stage.dispatchEvent(new Event(Event.RESIZE, false, false));
				showInvisibleMask();
			} 
		}
		
		public function updatePlayerProperties(callback:Function = null):void
		{
			if (Global.cookie.data.settings) {
				var cookieSet:Object = Global.cookie.data.settings;
				if (cookieSet.smileys) Global.base.settings.smileys = cookieSet.smileys;
				if (cookieSet.keybinds) Global.base.settings.keybinds = cookieSet.keybinds;
				if (cookieSet.particles) {
					Global.base.settings.particles = cookieSet.particles;
					Global.base.settings.greenOnMinimap = cookieSet.greenOnMinimap;
					Global.base.settings.minimapAlpha = cookieSet.minimapAlpha;
					Global.base.settings.hideBubbles = cookieSet.hideBubbles;
					Global.base.settings.showPackageNames = cookieSet.showPackageNames;
					Global.base.settings.visibleRows = cookieSet.visibleRows;
					Global.base.settings.collapsed = cookieSet.collapsed;
					Global.base.settings.blockPicker = cookieSet.blockPicker;
					Global.base.settings.volume = cookieSet.volume;
					Global.base.settings.azerty = cookieSet.azerty;
				}
				if (cookieSet.savedBlocks) Global.base.settings.savedBlocks = cookieSet.savedBlocks;
			}
			
			
			Bl.data.chatbanned = false;
			
			Bl.data.isAdmin = true;	
			Bl.data.isModerator = false;
			Bl.data.isDesigner = false;
			Bl.data.isCampaignCurator = false;
			Bl.data.isStaff = true; //just a tag
			//collection of all staff
			Bl.data.isStaffMember = true;
			
			Bl.data.canUseAllItems = true;
			
			KeyBinding.load();
			
			if(callback != null) callback.call(this);
		}
		
		private function cleanUIAndConnections():void
		{
			showDisconnectedMessage = false;
			
			if(ui2instance && ui2instance.parent){
				overlayContainer.removeChild(ui2instance);
			}
			
			if(state && state is LobbyState) {
				LobbyState(state).reset();
			}
			
			if(state && state is PlayState) {
				PlayState(state).reset()
			}
			
			showDisconnectedMessage = true;
		}
		//New public methods for general control!
		public function ShowLobby(tab:String = LobbyStatePage.ROOMLIST):void{
			clearOverlayContainer();
			cleanUIAndConnections();
			showLobby(tab);
		}
		
		public function loadStoredCookie(callback:Function):void {
			//var cookiePath:String = loaderInfo.url;
			//cookiePath = cookiePath.substring(0, Math.max(cookiePath.lastIndexOf("\\"), cookiePath.lastIndexOf("/")) + 1);
			var cookiePath:String = "/";
			
			trace("Cookie is being stored under " + cookiePath);
			
			try {
				if (Config.disableCookie) {
					Global.cookie = SharedObject.getLocal("Temp" + Math.random(), cookiePath);
					callback();
					return;
				}
				
				Global.cookie = SharedObject.getLocal("ssx", cookiePath)
				Global.sharedCookie = SharedObject.getLocal("ss", cookiePath)
			} catch (e:Error) {
				trace("Cookie error:", e.name, e.message);
				handleError("Error loading SharedObject. Please check you Flash Player settings (Right click -> Global Settings)");
				Global.noSave = true;
			}
			
			callback();
		}
		
		
		private function handleAttach(e:Event):void{
			
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			
			Global.stage = stage;
			ItemManager.init();
			AnimationManager.init();
			SoundManager.init();
			
			var offset:int = 5;
			setInterval(function():void{
				offset+=5
			}, 60*5*1000)
			
			loadStoredCookie(handleLoadCookie);
		}
		
		private function handleLoadCookie():void
		{
			stage.addEventListener(FullScreenEvent.FULL_SCREEN, handleFullScreen);
			
			if (Capabilities.playerType == "PlugIn") {
				fullscreenBlack.addEventListener(MouseEvent.MOUSE_DOWN, function(e:MouseEvent):void {
					e.preventDefault();
					e.stopImmediatePropagation();
					e.stopPropagation();
				});
				
				fullscreenBlack.addEventListener(MouseEvent.CLICK, function(e:MouseEvent):void {
					e.preventDefault();
					e.stopImmediatePropagation();
					e.stopPropagation();
				});
				stage.addEventListener(FullScreenEvent.FULL_SCREEN_INTERACTIVE_ACCEPTED, function(e:FullScreenEvent):void {
					setTimeout(hideInvisibleMask, 100);
				});
			}
			
			
			Bl.data.showMap = false;
			Bl.data.canEdit = false;
			Bl.data.canToggleGodMode = false;
			
			this.filterbadwords = Global.base.settings.wordFilter;
			
			var parameters:Object = LoaderInfo(this.root.loaderInfo).parameters;
			iseecom = true;
			Global.affiliate =  Global.affiliate || Global.cookie.data.affiliate || null
			
		
			if(!Global.cookie.data.affiliate && Global.affiliate){
				Global.cookie.data.affiliate = Global.affiliate
				if (!Global.noSave) Global.cookie.flush();
			}
			
			campaigns = new CampaignPage(null);
			simpleConnect();
		}
		
		public function setGoldBorder(value:Boolean):void {
			
			var target:Player = Global.playState.target as Player;
			if (target != null && target != Global.playState.player) {
				target.wearsGoldSmiley = value;
				ui2instance.smileyMenu.updateAllSmileyBorders(value);
				return;
			}
			Global.playState.player.wearsGoldSmiley = value;
			Global.cookie.data.goldBorder = value;
			ui2instance.smileyMenu.updateAllSmileyBorders(value);
			//if (!Global.noSave) Global.cookie.flush();
		}
		
		
		private function setError(field:TextField, error:Boolean):void{
			var tf:TextFormat = new TextFormat();
			tf.color = error ? 0xff0000 : 0xffffff;
			field.setTextFormat(tf,-1,-1);
		}

		public function simpleConnect():void {
			clearOverlayContainer();	
			showLobby();
		}
		
		
		public function canUseBlock(block:ItemBrick):Boolean
		{
			return block.id != 110 && block.id != 111
		}
		
		private function showLobby(tab:String = LobbyStatePage.ROOMLIST):void{
			Global.setPath("Everybody Edits", "/")
			Global.getPlacer = false;
			
			/*
			if (Bl.stage.displayState != StageDisplayState.NORMAL){
				Bl.stage.displayState = StageDisplayState.NORMAL;
			}*/
			
			cleanUIAndConnections();
			
			var lobbystate:LobbyState =  new LobbyState(self, false, tab)
			state = lobbystate;
			if(campaigns) {
				campaigns.lobbystate = lobbystate;
				lobbystate.setPage(LobbyStatePage.CAMPAIGN);
			}
			
			var self:EverybodyEdits = this;
			var rooms1:Array = [];
			var rooms2:Array = [];
			
			updatePlayerProperties();
			
			var firstDailyLogin:Boolean = false;
		}
		
		public function resetCampaignProgress():void 
		{
			if (campaigns) {
				campaigns.resetProgress();
			}
		}
		
		public static function getProperties(obj:*):String  {
            var p:*;
            var res:String = '';
            var val:String;
            var prop:String;
            for (p in obj) {
                prop = String(p);
                if (prop && prop!=='' && prop!==' ') {
                    val = String(obj[p]);
                    if (val.length>10) val = val.substr(0,10)+'...';
                    res += prop+':'+val+', ';
                }
            }
            res = res.substr(0, res.length-2);
            return res;
        }
		
		private function joinDownloaded(roomid:String, worldName:String, owner:String, gravity:Number, bgColour:uint, minimap:Boolean, width:int, height:int, joindata:Object = null, trialsMode:Boolean = false, worldSpawn:int = 0):void {
			cleanUIAndConnections();
			
			trace("join room", roomid);
			if (joindata == null) joindata = {};
			trace("-------------------------------------------------------------");
			trace(getProperties(joindata));
			trace("-------------------------------------------------------------");
			
			handleJoinDownloaded(roomid, worldName, owner, gravity, bgColour, minimap, width, height, joindata, trialsMode, worldSpawn);

			
			//connection.send("say", "/name " + worldName);
		}
		
		
		private function handleJoinDownloaded(roomid:String, worldName:String, owner:String, gravity:Number, bgColour:uint, minimap:Boolean, width:int, height:int, joindata:Object, trialsMode:Boolean, worldSpawn:int):void {
			Global.roomid = roomid;
			//so on handleJoin, it sends "init" to server, then server sends back "init" to client, and client basically initializes the world.
			//those are the steps we want to skip
			//so basically we need what's inside "init" but instead of the parameters, we will use the file data
			trace("Initializing world...");
			var self:EverybodyEdits = this;
				
			//we need these:
			//Bl.data.isCampaignRoom = isCampaignRoom;
			//Bl.data.owner = owner;
			//Global.currentLevelname = levelname;
			//Global.worldOwner = levelowner;
			//Global.ownerID = ownerID;
			//Global.currentLevelCrew = crew;
			//Global.currentLevelCrewName = crewName;
			//Global.currentLevelStatus = crewWorldStatus;
			//Global.bgColor = bgColor;
			//Global.backgroundEnabled = ((bgColor >> 24) & 0xFF) == 255;
			
			//now this is the difficult part:
			// things we need: m, name, face, aura, auracolor, smileygoldborder, width, height, gravityMul, bgColor, orangeSwitches
			
			if (!Global.cookie.data.smiley || Global.cookie.data.smiley >= ItemManager.totalSmilies) Global.cookie.data.smiley = 0;
			if (!Global.cookie.data.aura) Global.cookie.data.aura = 0;
			if (!Global.cookie.data.auraColor) Global.cookie.data.auraColor = 0;
			if (!Global.cookie.data.goldBorder) Global.cookie.data.goldBorder = 0;
			if (!Global.cookie.data.modmodeRow) Global.cookie.data.modmodeRow = 0;
			if (!Global.cookie.data.easterEggs) Global.cookie.data.easterEggs = new Object();
			
			if (!Global.noSave) Global.cookie.flush();
			
			state = new PlayState(Global.cookie.data.smiley, Global.cookie.data.aura,
			Global.cookie.data.auraColor, Global.cookie.data.goldBorder,
			width, height, gravity, bgColour, worldSpawn);
			
			if (worldName == "Moderator Land" &&
				owner.toLowerCase() == "stubby" &&
				Global.worldInfo.ownerId == "simple1298507192333x32") {
				(state as PlayState).addFakePlayer(16, 0, 0, false, -13.2, -9.2, "mrvoid", true);
			}
			
			//Bl.data.canEdit = false;
			//Bl.data.canToggleGodMode = false;
			
			//and this will be difficult too:
			// things we need: self?, m, canEdit=false, roomId, description, minimapEnabled, trialsMode
			Global.currentLevelname = worldName;
			var canEdit:Boolean = !Bl.data.isCampaignRoom &&
				(Global.cookie.data.username == Global.worldInfo.owner || Global.worldIndex > 0 && Bl.data.canEdit)
			ui2instance = new UI2(self, canEdit, "PWTest", worldName, owner, Global.worldInfo.desc, minimap, trialsMode);
			ui2instance.y = 500;
			
			if (Bl.data.isCampaignRoom) {
				var campId:int = Global.currentCampId;
				var tierId:int = Global.currentTierId;
				var progress:Object = Global.cookie.data.campaignProgress[campId][tierId];
				ui2instance.joinCampaign(joindata.camp, joindata.diff, joindata.tier, joindata.maxTier, joindata.completed, progress.hascrownsilver);
				if (trialsMode) {
					ui2instance.joinTimeTrial(Global.currentTierInfo.times.concat(), progress.time, progress.rank)
				} else {
					var player:Player = Global.playerInstance;
					if (progress.x != null) {
						player.x = progress.x;
						player.y = progress.y;
						(state as PlayState).x = -player.x+Bl.width/2;
						(state as PlayState).y = -player.y+Bl.height/2;
						player.speedX = progress.speedX;
						player.speedY = progress.speedY;
						player.jumpCount = progress.jumpCount;
						
						player.worldSpawn = progress.worldSpawn;
						
						player.deaths = progress.deaths;
						player.checkpoint_x = progress.checkpoint_x;
						player.checkpoint_y = progress.checkpoint_y;
						if (progress.isDead) player.killPlayer();
						
						if(progress.gx) {
							Global.playState.restoreCoins(progress.gx, progress.gy, false);
						}
						if(progress.bx) {
							Global.playState.restoreCoins(progress.bx, progress.by, true);
						}
						
						for (var i:String in progress.switches) {
							Global.playerInstance.switches[parseInt(i)] = true;
						}
						player.hascrownsilver = progress.hascrownsilver;
						player.hascrown = progress.hascrown;
						
						player.setEffect(Config.effectJump, progress.jumpBoost != 0, progress.jumpBoost);
						player.setEffect(Config.effectRun, progress.speedBoost != 0, progress.speedBoost);
						player.setEffect(Config.effectFly, progress.hasLevitation);
						player.setEffect(Config.effectLowGravity, progress.low_gravity);
						player.setEffect(Config.effectProtection, progress.isInvulnerable);
						player.setEffect(Config.effectMultijump, progress.maxJumps != 1, progress.maxJumps);
						player.setEffect(Config.effectGravity, progress.flipGravity != 0, progress.flipGravity);
					}
				}
			}
			
			overlayContainer.addChild(ui2instance); //oops
			
			Global.worldNames[Global.worldIndex] = Global.currentLevelname;
			hasDeleted = false;
			if (Global.isWorldManagerOpen) {
				Global.isWorldManagerOpen = false;
				showWorldManager(false);
			}
		}
		
		public function showOnTop(m:Sprite):void {
			overlayContainer.addChild(m);
			TweenMax.to(m,0,{alpha:0});
			TweenMax.to(m,0.2,{alpha:1});
		}
		
		public function showCampaignComplete(lc:CampaignComplete):void {
			if (overlayContainer.getChildByName("CampaignCompleteScreen")) return;
			cc = lc;
			showOnTop(cc);
		}
		
		public function hideCampaignComplete() : void{
			if (!cc) return;
			TweenMax.to(cc, 0.5, {
				alpha:0,
				"onComplete":function():void {
					if (cc.parent) overlayContainer.removeChild(cc);
					cc = null;
				}
			});
			stage.focus = stage;
		}
		
		public function showCampaignTrialDone(ctd:CampaignTrialDone):void {
			if (overlayContainer.getChildByName("CampaignTrialDoneScreen")) return;
			this.ctd = ctd;
			showOnTop(ctd);
		}
		
		public function hideCampaignTrialDone():void {
			if (!ctd) return;
			TweenMax.to(ctd, 0.5, {
				alpha:0,
				"onComplete":function():void {
					if (ctd.parent) overlayContainer.removeChild(ctd);
					ctd = null;
				}
			});
			stage.focus = stage;
		}
		
		public function toggleUI():void {
			Global.showUI = !Global.showUI;
			Global.base.ui2instance.toggleVisible(Global.showUI);
		}
		
		public function showInfo2(title:String, body:String, sound:String = null) : void{
			if (infoBox != null){
				if (overlayContainer.contains(infoBox)){
					if (infoBox.timer.running) infoBox.timer.stop();
					overlayContainer.removeChild(infoBox);
				}
			}
			
			var mouseDown:Boolean = false;
			infoBox = new InfoDisplay(title,body);
			infoBox.alpha = 0;
			infoBox.x = (640 - infoBox.width) / 2;
			infoBox.y = -infoBox.height - 10;
			overlayContainer.addChild(infoBox);
			
			var pullDownY:Number = infoBox.y + 10;
			
			TweenMax.to(infoBox,0.4,{
				alpha:1,
				y:10,
				ease:Back.easeOut
			});
			
			TweenPlugin.activate([GlowFilterPlugin]);
			TweenMax.to(infoBox,1,{
				repeat:3,
				yoyo:true,
				glowFilter:{color:0xAAAAAA, blurX:7, blurY:7, strength:1, alpha:1}
			});
			
			infoBox.buttonMode = true;
			infoBox.useHandCursor = true;
			infoBox.addEventListener(MouseEvent.MOUSE_DOWN,function(e:MouseEvent):void{
				e.preventDefault();
				e.stopImmediatePropagation();
				e.stopPropagation();
				
				if (infoBox.timer.running) infoBox.timer.stop();
				
				mouseDown = true;
				TweenMax.to(infoBox,0.4,{
					y:infoBox.y + 10
				});
			});
			infoBox.addEventListener(MouseEvent.MOUSE_UP,function(e:MouseEvent):void{
				mouseDown = false;
				hideInfoDisplay();
			});
			infoBox.addEventListener(MouseEvent.MOUSE_OUT,function(e:MouseEvent):void{
				if (mouseDown){
					if (!infoBox.timer.running) infoBox.timer.start();
					mouseDown = false;
					TweenMax.to(infoBox,0.4,{
						y:infoBox.y - 10
					});
				}
			});
			
			if (sound) SoundManager.playAnySound(sound);
		}
		
		public function hideInfoDisplay() : void
		{
			TweenMax.to(infoBox,0.2,{
				y:-infoBox.height - 10,
				alpha:0,
				"onComplete":function():void{
					if (overlayContainer.contains(infoBox)){
						overlayContainer.removeChild(infoBox);
					}
				},
				"ease":Back.easeIn
			});
		}
		
		public function showInvisibleMask():void {
			if (Capabilities.playerType == "PlugIn") overlayContainer.addChild(fullscreenBlack);
		}
		
		public function hideInvisibleMask():void {
			if (Capabilities.playerType == "PlugIn") {
				//setTimeout(function():void {
					overlayContainer.removeChild(fullscreenBlack);
				//}, 100);
			}
		}
		
		public function loadImage(image:String):void {
			var loader:Loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, function(e:Event):void {
				showImage(Bitmap(loader.content));
			});
			loader.load(new URLRequest(image), new LoaderContext(true));
		}
		
		public function showImage(img:Bitmap):void {
			var bg:BlackBG = new BlackBG();
			
			img.x = Config.width / 2 - img.width / 2;
			img.y = Config.height / 2 - img.height / 2;
			
			overlayContainer.addChild(bg);
			overlayContainer.addChild(img);
			TweenMax.to(img, 0, {alpha:0});
			TweenMax.to(bg, 0, {alpha:0});
			TweenMax.to(img, 0.2, {alpha:1});
			TweenMax.to(bg, 0.3, {alpha:1});
			
			function closeImage():void {
				TweenMax.to(img, 0.2, {alpha:0, onComplete:function():void{
					TweenMax.to(bg, 0.25, {alpha:0, onComplete:function():void{
						overlayContainer.removeChild(bg);
						overlayContainer.removeChild(img);
					}});
				}});
			}
			
			bg.addEventListener(MouseEvent.CLICK, closeImage);
			img.addEventListener(MouseEvent.CLICK, closeImage);
		}
		
		public function loadInfo(title:String, body:String, prefferedWidth:Number = -1, modal:Boolean = false, image:String = null, sound:String = null):void {
			if (!image) {
				showInfo(title, body, prefferedWidth, modal, null, sound);
				return;
			}
			
			var loader:Loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, function(e:Event):void {
				showInfo(title, body, prefferedWidth, modal, Bitmap(loader.content), sound);
			});
			loader.load(new URLRequest(image), new LoaderContext(true));
		}
		
		public function showInfo(title:String, body:String, prefferedWidth:Number = -1, modal:Boolean = false, image:Bitmap = null, sound:String = null):void {
			showDisconnectedMessage = false;
			removeInfoBoxes();
			
			var bg:BlackBG = new BlackBG();
			var inf:InfoBox = new InfoBox();
			infoBoxBG = bg;
			infoBox1 = inf;
			inf.addEventListener(MouseEvent.MOUSE_DOWN, function(e:MouseEvent):void{
				e.preventDefault()
				e.stopImmediatePropagation()
				e.stopPropagation()
			});
			bg.addEventListener(MouseEvent.MOUSE_DOWN, function(e:MouseEvent):void{
				e.preventDefault()
				e.stopImmediatePropagation()
				e.stopPropagation()
			});
			inf.ttitle.autoSize = TextFieldAutoSize.LEFT;
			inf.ttitle.text = Badwords.Filter(title);
			inf.tbody.autoSize = TextFieldAutoSize.LEFT;
			inf.tbody.text = Badwords.Filter(body);
			
			if (prefferedWidth != -1)
				inf.tbody.width = prefferedWidth;
			
			var newwidth:int = Math.max(inf.ttitle.width, inf.tbody.width, image ? image.width : 0) + 30;
			var offset_x:Number = (640 /*- newwidth*/  - inf.bg.width) / 2;
			
			inf.bg.x -= offset_x;
			inf.ttitle.x -= offset_x;
			inf.ttitle.y -= 5;
			inf.tbody.x -= offset_x;
			
			if (image) {
				image.x = inf.bg.x + newwidth / 2 - image.width / 2;
				image.y = inf.tbody.y + inf.tbody.height + 5;
				inf.addChild(image);
			}
			
			inf.bg.width = newwidth;
			inf.bg.height = (inf.tbody.y-inf.bg.y) + inf.tbody.height + (image ? image.height + 20 : 40);
			inf.closebtn.x = inf.bg.x+inf.bg.width;
			inf.closebtn.addEventListener(MouseEvent.CLICK, function():void{
				TweenMax.to(inf, 0.2, {alpha:0, onComplete:function():void{
					TweenMax.to(bg, 0.25, {alpha:0, onComplete:function():void{
						if(bg) overlayContainer.removeChild(bg);
						if(inf) overlayContainer.removeChild(inf);
					}});
				}});
				showDisconnectedMessage = true;
				if (stage) stage.focus = stage;
			});
			
			if(modal){
				inf.closebtn.visible = false;
			}
			overlayContainer.addChild(bg);
			overlayContainer.addChild(inf);
			TweenMax.to(inf, 0, {alpha:0});
			TweenMax.to(bg, 0, {alpha:0});
			TweenMax.to(inf, 0.2, {alpha:1});
			TweenMax.to(bg, 0.3, {alpha:1});
			
			if (sound) SoundManager.playAnySound(sound);
		}
		
		public function showHelpInfo(title:String, text1:String, text2:String, text3:String, prefferedWidth:Number = -1):void {
			showDisconnectedMessage = false;
			removeInfoBoxes();
			
			var inf:HelpInfoBox = new HelpInfoBox();
			infoBox2 = inf;
			inf.addEventListener(MouseEvent.MOUSE_DOWN, function(e:MouseEvent):void{
				e.preventDefault()
				e.stopImmediatePropagation()
				e.stopPropagation()
			});
			inf.ttitle.autoSize = TextFieldAutoSize.LEFT;
			inf.ttitle.text = Badwords.Filter(title);
			
			inf.col1.autoSize = TextFieldAutoSize.LEFT;
			inf.col1.text = Badwords.Filter(text1);
			inf.col2.autoSize = TextFieldAutoSize.LEFT;
			inf.col2.text = Badwords.Filter(text2);
			inf.col3.autoSize = TextFieldAutoSize.LEFT;
			inf.col3.text = Badwords.Filter(text3);
			
			if (prefferedWidth != -1) {
				inf.col1.width = prefferedWidth / 3;
				inf.col2.width = prefferedWidth / 3;
				inf.col3.width = prefferedWidth / 3;
			}
			
			var newwidth:int = Math.max(inf.ttitle.width, inf.col1.width + inf.col2.width + inf.col3.width) + 30;
			var offset_x:Number = -12;
			var offset_y:Number = -4;
			
			inf.bg.x -= offset_x;
			inf.bg.y -= offset_y;
			var pixel_err:int = Math.round(0.038 * inf.col1.height);
			inf.bg.y += pixel_err - 5;
			
			inf.ttitle.x -= offset_x;
			inf.ttitle.y -= 5 + offset_y;
			inf.col1.x -= offset_x;
			inf.col2.x -= offset_x;
			inf.col3.x -= offset_x;
			
			inf.bg.width = newwidth;
			inf.bg.height = /*(inf.col1.y-inf.bg.y) + */inf.col1.height + 54;
			inf.closebtn.x = inf.bg.x+inf.bg.width;
			inf.closebtn.y ++;
			inf.closebtn.addEventListener(MouseEvent.CLICK, function():void{
				TweenMax.to(inf, 0.2, {alpha:0, onComplete:function():void{
					if(inf) overlayContainer.removeChild(inf);
				}});
				showDisconnectedMessage = true;
				if (stage) stage.focus = stage;
			});
			
			overlayContainer.addChild(inf);
			TweenMax.to(inf, 0, {alpha:0});
			TweenMax.to(inf, 0.2, {alpha:1});
		}
		
		
		private function showSimpleMenu(animate:Boolean, prefferedWidth:Number, title:String, rows:Array, desc:Sprite = null):void 
		{
			showDisconnectedMessage = false;
			removeInfoBoxes();
			
			var inf:HelpInfoBox = new HelpInfoBox();
			infoBox2 = inf;
			inf.addEventListener(MouseEvent.MOUSE_DOWN, function(e:MouseEvent):void{
				e.preventDefault()
				e.stopImmediatePropagation()
				e.stopPropagation()
			});
			inf.ttitle.autoSize = TextFieldAutoSize.LEFT;
			inf.ttitle.text = title;
			
			inf.removeChild(inf.col1);
			inf.removeChild(inf.col2);
			inf.removeChild(inf.col3);
			
			if (desc != null) inf.addChild(desc);
			
			var tbody:Sprite = new Sprite();
			inf.addChild(tbody);
			
			for each(var row:Sprite in rows) {
				tbody.addChild(row);
			}
			//trace(tbody.width);
			//for each(var d:DisplayObject in rows[1]) {
				//tbody.width += d.width + 5;
			//}
			//tbody.width -= 15;
			
			var endRow:Sprite = new Sprite();
			tbody.addChild(endRow);
			
			if (prefferedWidth != -1) {
				tbody.width = prefferedWidth;
			}
			
			var newwidth:int = Math.max(inf.ttitle.width, tbody.width) + 30;
			if (desc) newwidth = Math.max(newwidth, desc.getChildAt(0).x + desc.width + 30);
			var offset_x:Number = /*268*/ -12;
			var offset_y:Number = /*120*/ -4;
			
			inf.bg.x -= offset_x;
			inf.bg.y -= offset_y;
			var pixel_err:Number = /*Math.round(*/0.039 * tbody.height/*)*/;
			inf.bg.y += pixel_err - 5;
			
			inf.ttitle.x -= offset_x;
			inf.ttitle.y -= 5 + offset_y;
			
			tbody.x += inf.ttitle.x;
			tbody.y += inf.ttitle.y + inf.ttitle.height;
			if (desc) {
				desc.x = tbody.x;
				desc.y = tbody.y;
			}
			
			inf.bg.width = newwidth;
			inf.bg.height = /*(tbody.y-inf.bg.y) + (*/tbody.height/*-inf.ttitle.height)*/ + 54;
			inf.closebtn.x = inf.bg.x+inf.bg.width;
			//inf.closebtn.y -= 120 -8;
			inf.closebtn.y++;
			inf.closebtn.addEventListener(MouseEvent.CLICK, function():void{
				TweenMax.to(inf, 0.2, {alpha:0, onComplete:function():void{
					if(inf) overlayContainer.removeChild(inf);
				}});
				showDisconnectedMessage = true;
				if (stage) stage.focus = stage;
			});
			
			overlayContainer.addChild(inf);
			if(animate) {
				TweenMax.to(inf, 0, {alpha:0});
				TweenMax.to(inf, 0.2, {alpha:1});
			}
		}
		
		
		
		public function showFPMenu(animate:Boolean = true, prefferedWidth:Number = -1):void 
		{
			var rows:Array = new Array();
			var ps:PlayState = (state as PlayState);
			var fps:Array = ps.getFakePlayers;
			
			var info:Label = new Label("fakeplayers can interact\nwith the world - useful\nwith orange switches!", 8, "left", 0xcccccc, false, "system");
			info.x = 90;
			info.y = -35;
			var desc:Sprite = new Sprite();
			desc.addChild(info);
			
			for each(var fp:Player in fps) {
				var row:Sprite = new Sprite();
				
				var rowNum:int = rows.length + 1;
				var rNum:Label = new Label((rowNum==10?0:rowNum).toString(),12,"left",0xffffff,false,"system");
				rNum.y = 18 + 18 * rows.length;
				row.addChild(rNum);
				
				var rGoto:SimpleButton = createButton("goto", function(target:Player):void {
					if (Global.playState.target == Global.playerInstance) {
						Global.playState.offset(Global.playerInstance.x - target.x,
							Global.playerInstance.y - target.y)
					}
					Global.playerInstance.setPosition(target.x, target.y);
				}, -1, fp);
				rGoto.x = rNum.x + 20;
				rGoto.y = rNum.y + (rNum.height - rGoto.height)/2;
				row.addChild(rGoto);
				
				var rBring:SimpleButton = createButton("bring", function(target:Player):void {
					if (Global.playState.target == target) {
						Global.playState.offset(target.x - Global.playerInstance.x,
							target.y-Global.playerInstance.y)
					}
					target.setPosition(Global.playerInstance.x, Global.playerInstance.y);
				}, -1, fp);
				rBring.x = rGoto.x + rGoto.width + 5;
				rBring.y = rNum.y + (rNum.height - rBring.height)/2;
				row.addChild(rBring);
				
				var rGod:SimpleButton = createButton("god", function(target:Player):void {
					target.isInGodMode = !target.isInGodMode;
					target.resetDeath();
				}, -1, fp);
				rGod.x = rBring.x + rBring.width + 5;
				rGod.y = rNum.y + (rNum.height - rGod.height)/2;
				row.addChild(rGod);
				
				var rView:SimpleButton = createButton("view", Global.playState.spectate, -1, fp);
				rView.x = rGod.x + rGod.width + 5;
				rView.y = rNum.y + (rNum.height - rView.height)/2;
				row.addChild(rView);
				
				var rReset:SimpleButton = createButton("reset", function(target:Player):void {
					var oldx:Number = target.x;
					var oldy:Number = target.y;
					target.resetPlayer();
					if (Global.playState.target == target) {
						Global.playState.offset(oldx - target.x,
							oldy - target.y)
					}
				}, 0xff5050, fp);
				rReset.x = rView.x + rView.width + 5;
				rReset.y = rNum.y + (rNum.height - rReset.height)/2;
				row.addChild(rReset);
				
				var rDel:SimpleButton = createButton("delete", Global.playState.removeFakePlayer, 0xff5050, fp.id);
				rDel.x = rReset.x + rReset.width + 5;
				rDel.y = rNum.y + (rNum.height - rDel.height)/2;
				row.addChild(rDel);
				
				rows.push(row);
			}
			
			var endRow:Sprite = new Sprite();
			
			if (rows.length > 0) {
			var rDelAll:SimpleButton = createButton("delete all", Global.playState.removeFakePlayers, 0xff5050);
			rDelAll.x = rows[0].width - rDelAll.width/* + 15*/;
			//rDelAll.y = 18 * rows.length;
			endRow.addChild(rDelAll); 
			
			var rResetAll:SimpleButton = createButton("reset all", function():void {
				Global.playState.resetFakePlayers();
			}, 0xff5050);
			rResetAll.x = rDelAll.x - rResetAll.width;
			endRow.addChild(rResetAll); }
			
			if (rows.length < 10) {
				var rSummon:SimpleButton = createButton("spawn x 1", ui2instance.sendChat, 0x50ff50, "/spawn 1");
				endRow.addChild(rSummon);
				if (rows.length < 9) {
					var rSummon10:SimpleButton = createButton("spawn x " + (10 - rows.length), ui2instance.sendChat, 0x50ff50, "/spawn "  + (10 - rows.length));
					rSummon10.x = rSummon.x + rSummon.width + 5;
					endRow.addChild(rSummon10);
				}
			}
			
			rows.push(endRow);
			
			showSimpleMenu(animate, prefferedWidth, TITLE_FP, rows, desc);
		}
		
		public function updateMenu(title:String = TITLE_FP):void {
			if (isMenuOpen(title)) {
				if(title == TITLE_FP) showFPMenu(false);
				else if(title == TITLE_EDIT) showEditTools(false);
				else if(title == TITLE_WORLD) showWorldManager(false);
			}
		}
		
		public function closeInfo2Menus():void {
			removeInfoBoxes(true);
		}
		
		public function isMenuOpen(title:String = TITLE_FP):Boolean {
			return infoBox2 != null && overlayContainer.contains(infoBox2)
				&& infoBox2.ttitle.text == title;
		}
		
		
		
		public function showEditTools(animate:Boolean = true, prefferedWidth:Number = -1):void 
		{
			var ps:PlayState = (state as PlayState);
			
			var rows:Array = new Array();
			
			{
				var brush:Sprite = new Sprite();
				var brushSize:Label = new Label("Brush Size:", 10, "left", 0xffffff, false, "system");
				brush.addChild(brushSize);
				
				var sub:ui2minusbtn = new ui2minusbtn();
				sub.x = sub.width/2 + 5;
				brush.addChild(sub);
				
				var add:ui2plusbtn = new ui2plusbtn();
				add.x = /*sub.x + (sub.width + add.width)/2 + 32;*/ /*brushSize.width - 10*/68 - 5; //68
				brush.addChild(add);
				
				var num:Label = new Label(ps.brushSize + "x" + ps.brushSize,12,"left",0xffffff,false,"system");
				num.x = (sub.x + add.x - num.width + 5)/2;
				num.y = brushSize.y + brushSize.height;
				sub.y = add.y = num.y + (num.height+sub.height/2)/2;
				brush.addChild(num);
				
				function brushInc(inc:int = 2):Function {
					return function(e:MouseEvent):void {
						ps.brushSize += inc;
						if (ps.brushSize < 1) ps.brushSize = 5;
						if (ps.brushSize > 5) ps.brushSize = 1;
						num.text = ps.brushSize + "x" + ps.brushSize;
						num.x = (sub.x + add.x - num.width + 5) / 2;
						
						updateMenu(TITLE_EDIT);
						
						if (stage) stage.focus = stage;
					}
				}
				sub.addEventListener(MouseEvent.MOUSE_DOWN, brushInc(-1));
				add.addEventListener(MouseEvent.MOUSE_DOWN, brushInc(+1));
				
				rows.push(brush);
			}
			
			if(ps.brushSize > 1) {
				var grid:Sprite = new Sprite();
				grid.y = rows[0].height;
				
				var brushGrid:Label = new Label("Brush Grid-lock:", 10, "left", 0xffffff, false, "system");
				grid.addChild(brushGrid);
				
				var gridTxt:Label = new Label(ps.brushGridLocked ? "Enabled" : "Disabled", 8, "left",
					ps.brushGridLocked ? 0x50ff50 : 0xff5050, false, "system");
				//gridLock.y = brushGrid.y + brushGrid.height-5;
				//grid.addChild(gridLock);
				
				function toggleGrid():void {
					ps.brushGridLocked = !ps.brushGridLocked;
					gridTxt.text = ps.brushGridLocked ? "Enabled" : "Disabled";
					gridTxt.setTextFormat(new TextFormat(null, null, ps.brushGridLocked ? 0x50ff50 : 0xff5050));
					
					updateMenu(TITLE_EDIT);
				}
				var toggle:SimpleButton = createButton(gridTxt, toggleGrid);
				toggle.y = brushGrid.y + brushGrid.height;
				grid.addChild(toggle);
				
				rows.push(grid);
			}
			
			if(ps.brushSize > 1 && ps.brushGridLocked) {
				var offset:Sprite = new Sprite();
				offset.y = rows[1].y + rows[1].height + 3;
				
				var brushOffset:Label = new Label("Grid Offset:", 10, "left", 0xffffff, false, "system");
				offset.addChild(brushOffset);
				
				var osubx:ui2minusbtn = new ui2minusbtn();
				osubx.x = osubx.width/2 + 5;
				offset.addChild(osubx);
				
				var oaddx:ui2plusbtn = new ui2plusbtn();
				oaddx.x = 68 - 5 - 19;
				offset.addChild(oaddx);
				
				var onumx:Label = new Label(ps.gridOffsetX.toString(),12,"left",0xffffff,false,"system");
				onumx.x = (osubx.x + oaddx.x - onumx.width + 5)/2;
				onumx.y = brushOffset.y + brushOffset.height;
				osubx.y = oaddx.y = onumx.y + (onumx.height+osubx.height/2)/2;
				offset.addChild(onumx);
				
				
				var osuby:ui2minusbtn = new ui2minusbtn();
				osuby.x = osuby.width/2 + 5 + oaddx.x + oaddx.width;
				offset.addChild(osuby);
				
				var oaddy:ui2plusbtn = new ui2plusbtn();
				oaddy.x = 68 - 5 - 19 + oaddx.x + oaddx.width;
				offset.addChild(oaddy);
				
				var onumy:Label = new Label(ps.gridOffsetY.toString(),12,"left",0xffffff,false,"system");
				onumy.x = (osuby.x + oaddy.x - onumy.width + 5)/2;
				onumy.y = brushOffset.y + brushOffset.height;
				osuby.y = oaddy.y = onumy.y + (onumy.height+osuby.height/2)/2;
				offset.addChild(onumy);
				
				function offsetXInc(inc:int = 2):Function {
					return function(e:MouseEvent):void {
						ps.gridOffsetX += inc;
						if (ps.gridOffsetX < -4) ps.gridOffsetX = 4;
						if (ps.gridOffsetX > 4) ps.gridOffsetX = -4;
						onumx.text = ps.gridOffsetX.toString();
						onumx.x = (osubx.x + oaddx.x - onumx.width + 5)/2;
						if (stage) stage.focus = stage;
					}
				}
				osubx.addEventListener(MouseEvent.MOUSE_DOWN, offsetXInc(-1));
				oaddx.addEventListener(MouseEvent.MOUSE_DOWN, offsetXInc(+1));
				
				function offsetYInc(inc:int = 2):Function {
					return function(e:MouseEvent):void {
						ps.gridOffsetY += inc;
						if (ps.gridOffsetY < -4) ps.gridOffsetY = 4;
						if (ps.gridOffsetY > 4) ps.gridOffsetY = -4;
						onumy.text = ps.gridOffsetY.toString();
						onumy.x = (osuby.x + oaddy.x - onumy.width + 5)/2;
						if (stage) stage.focus = stage;
					}
				}
				osuby.addEventListener(MouseEvent.MOUSE_DOWN, offsetYInc(-1));
				oaddy.addEventListener(MouseEvent.MOUSE_DOWN, offsetYInc(+1));
				
				rows.push(offset);
			}
			
			//var select:Sprite = new Sprite();
			//{
				//select.x = brush.width;
				//var selection:Label = new Label("Selection:", 10, "left", 0xffffff, false, "system");
				//select.addChild(selection);
				//
				//var selectTool:SimpleButton = createButton("make selection", null);
				//select.y = selection.height;
				//select.addChild(selectTool);
				//
				////var sub:ui2minusbtn = new ui2minusbtn();
				////sub.x = sub.width/2;
				////select.addChild(sub);
				////
				////var add:ui2plusbtn = new ui2plusbtn();
				////add.x = sub.x + (sub.width + add.width)/2 + 34;
				////select.addChild(add);
				////
				////var num:Label = new Label(ps.brushSize + "x" + ps.brushSize,12,"left",0xffffff,false,"system");
				////num.x = (sub.x + add.x - num.width + 4)/2;
				////num.y = brush.y + brush.height-5;
				////sub.y = add.y = num.y + (num.height+sub.height/2)/2;
				////brush.addChild(num);
				//
				//tbody.addChild(select);
			//}
			showSimpleMenu(animate, prefferedWidth, "Edit Tools", rows);
		}
		
		public var worldPage:int = 0;
		private var hasDeleted:Boolean = false;
		public function showWorldManager(animate:Boolean = true, prefferedWidth:Number = -1):void  {
			
			var rows:Array = new Array();
			
			var topRow:Sprite = new Sprite();
			var create:SimpleButton = createButton("create", campaigns.createWorld, 0x50ff50);
			topRow.addChild(create);
			
			var upload:SimpleButton = createButton("upload", campaigns.uploadWorld, 0x50ff50);
			upload.x = create.x + create.width + 5;
			topRow.addChild(upload);
			
			var wid:Label = new Label("world id: " + Global.worldIndex, 8, "left", 0xffffff, false, "system");
			wid.x = upload.x + upload.width + 5;
			topRow.addChild(wid);
			
			rows.push(topRow);
			
			var info:Label = new Label("this is a worlds manager. you can use it\nto add, remove, and reorder sub-worlds,\naccessible with world portals.", 8, "left", 0xcccccc, false, "system");
			info.x = upload.x + upload.width;
			info.y = -35;
			var desc:Sprite = new Sprite();
			desc.addChild(info);
			
			
			//for each(var name:String in Global.worldNames) {
			var maxIndex:int = Math.min(worldPage * 10 + 10, Global.worldNames.length);
			for (var i:int = worldPage * 10; i < maxIndex; i++) {
				if (!Global.worldNames[i]) continue;
				var name:String = Global.worldNames[i];
				
				var row:Sprite = new Sprite();
				
				var rNum:Label = new Label(i.toString(),12,"left",0xffffff,false,"system");
				rNum.y = 18 * rows.length;
				row.addChild(rNum);
				
				var rGoto:SimpleButton = createButton("goto", campaigns.joinWorld, -1, i);
				rGoto.x = rNum.x + 8*(i.toString().length) + 12;
				rGoto.y = rNum.y + (rNum.height - rGoto.height)/2;
				row.addChild(rGoto);
				
				var rMove:Label = new Label("move:", 8, "left", 0xffffff, false, "system");
				rMove.x = rGoto.x + rGoto.width;
				rMove.y = rNum.y + (rNum.height - rMove.height) / 2;
				row.addChild(rMove);
				
				var canMoveUp:Boolean = i > 0;
				var rMoveUp:SimpleButton = createButton("/\\", function(id:int, canMoveUp:Boolean):void {
					if (canMoveUp) {
						var tempW:ByteArray = Global.worlds[id];
						var tempWN:ByteArray = Global.worldNames[id];
						
						Global.worlds[id] = Global.worlds[id-1];
						Global.worldNames[id] = Global.worldNames[id-1];
						Global.worlds[id-1] = tempW;
						Global.worldNames[id-1] = tempWN;
						
						if (id == Global.worldIndex) Global.worldIndex--;
						else if (id == Global.worldIndex +1) Global.worldIndex++;
						
						Global.unsavedWorlds = true;
						
						updateMenu(TITLE_WORLD);
					}
				}, canMoveUp ? 0x50ff50 : 0x505050, i, canMoveUp);
				rMoveUp.x = rMove.x + rMove.width;
				rMoveUp.y = rNum.y + (rNum.height - rMoveUp.height)/2;
				row.addChild(rMoveUp);
				
				var canMoveDown:Boolean = i < Global.worldNames.length - 1;
				var rMoveDown:SimpleButton = createButton("\\/", function(id:int, canMoveDown:Boolean):void {
					if (canMoveDown) {
						var tempW:ByteArray = Global.worlds[id];
						var tempWN:ByteArray = Global.worldNames[id];
						
						Global.worlds[id] = Global.worlds[id+1];
						Global.worldNames[id] = Global.worldNames[id+1];
						Global.worlds[id+1] = tempW;
						Global.worldNames[id+1] = tempWN;
						
						if (id == Global.worldIndex) Global.worldIndex++;
						else if (id == Global.worldIndex -1) Global.worldIndex--;
						
						Global.unsavedWorlds = true;
						
						updateMenu(TITLE_WORLD);
					}
				}, canMoveDown ? 0x50ff50 : 0x505050, i, canMoveDown);
				rMoveDown.x = rMoveUp.x + rMoveUp.width;
				rMoveDown.y = rNum.y + (rNum.height - rMoveDown.height)/2;
				row.addChild(rMoveDown);
				
				var isCurrent:Boolean = i == Global.worldIndex;
				var rDel:SimpleButton = createButton("delete", function(id:int, isCurrent:Boolean):void {
					if(!isCurrent) {
						if (hasDeleted) {
							Global.worlds.splice(id, 1);
							Global.worldNames.splice(id, 1);
							Global.unsavedWorlds = true;
							if (id < Global.worldIndex) Global.worldIndex--;
							updateMenu(TITLE_WORLD);
						} else {
							var confirm:ConfirmPrompt = new ConfirmPrompt("Are you sure you want to delete a sub-world?\n(You won't be prompted again in this world)", true, "Delete");
							
							Global.base.showOnTop(confirm);
							
							confirm.btn_yes.addEventListener(MouseEvent.MOUSE_DOWN, function(e:MouseEvent):void {
								Global.worlds.splice(id, 1);
								Global.worldNames.splice(id, 1);
								Global.unsavedWorlds = true;
								if (id < Global.worldIndex) Global.worldIndex--;
								updateMenu(TITLE_WORLD);
								hasDeleted = true;
								confirm.close();
							});
							confirm.btn_no.addEventListener(MouseEvent.MOUSE_DOWN, function(e:MouseEvent):void {
								confirm.close();
							});
						}
					}
				}, isCurrent ? 0x505050 : 0xff5050, i, isCurrent);
				rDel.x = rMoveDown.x + rMoveDown.width + 5;
				rDel.y = rNum.y + (rNum.height - rDel.height)/2;
				row.addChild(rDel);
				
				name = name.substr(0, 20) + (name.length > 20 ? "..." : "");
				var rName:Label = new Label("(" + name + ")",20,"left",0xffffff,false,"visitor");
				rName.x = rDel.x + rDel.width + 5;
				rName.y = rDel.y + (rNum.height - rName.height - 4) / 2;
				row.addChild(rName);
				
				rows.push(row);
			}
			
			var bottomRow:Sprite = new Sprite();
			
			var pg:Label = new Label("page:", 8, "left", 0xffffff, false, "system");
			pg.y = 18 * rows.length;
			bottomRow.addChild(pg);
			
			var pgPrevEnabled:Boolean = worldPage > 0;
			var pgPrev:SimpleButton = createButton("prev", function(pgPrevEnabled:Boolean):void {
					if(pgPrevEnabled) {
						worldPage--;
						updateMenu(TITLE_WORLD);
					}
				}, pgPrevEnabled ? 0x50ff50 : 0x505050, pgPrevEnabled);
			pgPrev.x = pg.x + pg.width + 5;
			pgPrev.y = pg.y;
			bottomRow.addChild(pgPrev);
			
			var pgNextEnabled:Boolean = maxIndex < Global.worldNames.length;
			var pgNext:SimpleButton = createButton("next", function(pgNextEnabled:Boolean):void {
					if(pgNextEnabled) {
						worldPage++;
						updateMenu(TITLE_WORLD);
					}
				}, pgNextEnabled ? 0x50ff50 : 0x505050, pgNextEnabled);
			pgNext.x = pgPrev.x + pgPrev.width + 5;
			pgNext.y = pg.y;
			bottomRow.addChild(pgNext);
			
			rows.push(bottomRow);
			
			showSimpleMenu(animate, prefferedWidth, "Worlds", rows, desc);
		}
		
		private function createButton(display:*, onClick:Function, textColor:int = 0xffffff, ...args):SimpleButton {
			if (textColor == -1) textColor = 0xffffff;
			var btn:SimpleButton;
			if (display is String) {
				var btnTxt:Label = new Label(display, 8, "left", textColor, false, "system");
				btn = new SimpleButton(btnTxt, btnTxt, btnTxt, btnTxt);
			} else if (display is BitmapData) {
				var btnSpr:Sprite = new Sprite();
				btnSpr.graphics.beginBitmapFill(display);
				btn = new SimpleButton(btnSpr, btnSpr, btnSpr, btnSpr);
			} else {
				btn = new SimpleButton(display, display, display, display);
			}
			
			function owo():Function {
				return function(e:MouseEvent):void {
					onClick.apply(null, args);
					if (stage) stage.focus = stage;
				}
			}
			btn.addEventListener(MouseEvent.MOUSE_DOWN, owo());
			return btn;
		}
		
		
		private function removeInfoBoxes(onlyInfo2:Boolean = false):void {
			if (infoBox1 != null && !onlyInfo2){
				if (overlayContainer.contains(infoBox1)){
					overlayContainer.removeChild(infoBoxBG);
					overlayContainer.removeChild(infoBox1);
				}
			}
			if (infoBox2 != null){
				if (overlayContainer.contains(infoBox2)){
					overlayContainer.removeChild(infoBox2);
				}
			}
		}
		
		public function showLoadingScreen(text:String):void {
			if(loading != null) {
				overlayContainer.removeChild(loading);
			}
			
			var isnull:Boolean = loading == null;
			
			loading = new LoadingScreen(text);
			loading.alpha = 0;
			overlayContainer.addChild(loading);
			if (isnull) {
				TweenMax.to(loading, 0.4, {alpha:1});
			} else {
				loading.alpha = 1;
			}
		}
		
		public function hideLoadingScreen():void {
			if (this.loading != null) {
				loading.close();
			}
		}
		
		private function handleError(e:Object):void{
			trace(e);
			
			var errorText:String = 
				e.hasOwnProperty("message") ? e.message :  
				e.hasOwnProperty("text") ? e.text : 
				e.toString();
				("An unhandled error occurred :(", "We saved the error to our servers and are working on fixing it already!\n\n\nHorrible Error:\n" + errorText);
		}
	}
}