package states
{
	import animations.AnimatedSprite;
	import animations.AnimationManager;
	import flash.display.StageDisplayState;
	import flash.utils.getTimer;
	import ui.BrickContainer;
	import ui.DebugStats;
	import utilities.MathUtil;
	
	import blitter.Bl;
	import blitter.BlContainer;
	import blitter.BlSprite;
	import blitter.BlState;
	import blitter.BlText;
	
	import com.greensock.TweenMax;
	import com.greensock.easing.Quint;
	
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.events.SecurityErrorEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.media.Sound;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.ui.Keyboard;
	import flash.utils.ByteArray;
	
	import items.ItemId;
	import items.ItemManager;
	
	import sounds.SoundId;
	import sounds.SoundManager;
	
	import ui.ConfirmPrompt;
	import ui.HoverLabel;
	import ui.Tile;
	
	public class PlayState extends BlState
	{
		[Embed(source="/../media/death_count_icon.png")] private static var DeathIcon:Class;
		private static var deathIconBMD:BitmapData = new DeathIcon().bitmapData;
		
		public var player:Me;
		public var world:World;
		protected var players:Object = {};
		public var minimap:MiniMap
		public var totalCoins:int = 0
		public var bonusCoins:int = 0
		public var gravityMultiplier:Number = 1;
		protected var cointext:BlText
		protected var cointextcontainer:BlContainer = new BlContainer();
		protected var worldowner:String;
		protected var saidOver9000:Boolean = false;
		
		public var lastframe:BitmapData;
		
		public var unsavedChanges:Boolean = false;
		
		private var spectatingText:BlText;	
		private var stopSpectatingText:BlText;
		
		protected var particles:Array = [];
		
		protected var bcointext:BlText
		protected var bcointextcontainer:BlContainer = new BlContainer();
		protected var rw:int = 0;
		protected var rh:int = 0;
		
		protected var deathcounttext:BlText
		protected var deathcountcontainer:BlContainer = new BlContainer();
		
		protected var eraserLayerLock:int;  // The layer that we are currently erasing in
		
		//protected var overlay:BitmapData = new BitmapData(640,480,true, 0x0);
		
		protected var confirm:ConfirmPrompt;
		
		private var lastRetry:int = -1;
		
		public var brushSize:int = 1;
		public var brushGridLocked:Boolean = false;
		public var gridOffsetX:int = 0;
		public var gridOffsetY:int = 0;
		private var justPlaced:Boolean = false;
		
		
		public function PlayState(face:int, aura:int, auraColor:int, smileyGoldBorder:Boolean, rw:int, rh:int, gravityMultiplier:Number, bgColor:uint, worldSpawn:int)
		{
			this.rw = rw;
			this.rh = rh;
			
			this.gravityMultiplier = gravityMultiplier;
			Global.currentBgColor = bgColor;
			
			world = new World();
			world.deserializeFromMessage(rw,rh);
			world.setBackgroundColor(bgColor);
			add(world);
			
			totalCoins += world.getTypeCount(100);
			bonusCoins += world.getTypeCount(101);
			
			player = new Me(world, Global.cookie.data.username, true, this);
			player.worldGravityMultiplier = gravityMultiplier;
			if (!Global.cookie.data.easterEggs.grav && gravityMultiplier != 1) {
				Global.cookie.data.easterEggs.grav = true;
				Global.base.showInfo2("Easter Egg!", "You have unlocked a new world setting!", SoundId.MAGIC);
			}
			
			player.worldSpawn = worldSpawn;
			player.placeAtSpawn();
			
			player.frame = face;
			player.aura = aura;
			player.auraColor = auraColor;
			player.wearsGoldSmiley = smileyGoldBorder;
			this.x = -player.x+Bl.width/2;
			this.y = -player.y+Bl.height/2;
			add(player);
			
			Global.playerInstance = player;
			
			world.setPlayer(player);
			
			target = player;
			Bl.data.npc_name = player.name;
			
			player.hitmap = world; //it's an instance of the world eh, i'll keep it for now
			
			minimap = new MiniMap(world, rw, rh);
			
			cointext = new BlText(12, 100, 0xffffff,"right");
			cointext.x = 523
			cointext.y = 20;
			cointextcontainer.add(cointext)
			
			bcointext = new BlText(12, 100, 0xffffff,"right");
			bcointext.x = 523
			bcointext.y = 20;
			bcointextcontainer.add(bcointext)
			
			deathcounttext = new BlText(12, 100, 0xffffff,"right");
			deathcounttext.x = 523
			deathcounttext.y = 20;
			deathcountcontainer.add(deathcounttext)
			
			spectatingText = new BlText(12, 300, 16777215, "center", "system");
			spectatingText.x = 197;
			spectatingText.y = 4;
			
			stopSpectatingText = new BlText(12, 300, 16777215, "center", "system");
			stopSpectatingText.x = 197;
			stopSpectatingText.y = 450;
			stopSpectatingText.text = "Click anywhere to stop spectating";
			
			var tcoin:BlSprite = BlSprite.createFromBitmapData( ItemManager.getBrickPackageByName("coins").bricks[0].bmd );
			tcoin.x = 626-4
			tcoin.y = 24-3
			cointextcontainer.add(tcoin);
			
			var btcoin:BlSprite = BlSprite.createFromBitmapData( ItemManager.getBrickPackageByName("coins").bricks[1].bmd );
			btcoin.x = 626-4
			btcoin.y = 24-3
			bcointextcontainer.add(btcoin);
			
			var skull:BlSprite = BlSprite.createFromBitmapData( deathIconBMD );
			skull.x = 626-2
			skull.y = 24-3
			deathcountcontainer.add(skull);
			
			var s:PlayState = this;
			var shadowDebug:Boolean = Config.enableDebugShadow;
			
			Global.debug_stats = new DebugStats(this);
			Global.base.overlayContainer.addChild(Global.debug_stats);
			Global.debug_stats.visible = false;
			Global.playState = this;
			
			Global.stage.frameRate = Config.maxFrameRate;
		}
		
		public function restoreCoins(xs:Array, ys:Array, isBlue:Boolean):void {			
			for (var i:int = 0; i < xs.length; i++)
			{
				world.setTileComplex(0, xs[i], ys[i], isBlue ? 111 : 110, null);
				if (isBlue) {
					player.bcoins++;
					player.bx.push(xs[i])
					player.by.push(ys[i]);
				}
				else {
					player.coins++;
					player.gx.push(xs[i])
					player.gy.push(ys[i]);
				}
			}
		}
		
		public function updateMinimap(xo:int,yo:int):void {
			minimap.updatePixel(xo,yo,world.getMinimapColor(xo,yo));
		}
		
		public function switchKey(color:String, state:Boolean, fromqueue:Boolean = false):void {
			world.setKey(color, state, fromqueue);
			if (world.overlaps(player)) {
				world.setKey(color, !state);
				keysquene.push({color:color, state:state});
			}
		}
		
		public function pressOrangeSwitch(switchId:int, enabled:Boolean):void {
			if (switchId == 1000)
				for (var i:int = 0; i < 1000; i++)
					pressOrangeSwitch(i, enabled);
			
			world.orangeSwitches[switchId] = enabled;
			if (world.overlaps(player)) {
				world.orangeSwitches[switchId] = !enabled;
				queue.push(function():void { pressOrangeSwitch(switchId, enabled); });
			}
		}
		
		public function checkCrown(collide:Boolean):void {
			player.collideWithCrownDoorGate = collide;
			if (world.overlaps(player)) {
				player.collideWithCrownDoorGate = !collide;
				queue.push(function():void { checkCrown(collide); });
			}
		}
		
		public function removeCrown():void {
			for each(var p:Player in players) {
				p.hascrown = false;
				p.collideWithCrownDoorGate = false;
			}
			player.hascrown = false;
			checkCrown(false);
		}
		
		public function checkSilverCrown(collide:Boolean):void {
			player.collideWithSilverCrownDoorGate = collide;
			if (world.overlaps(player)) {
				player.collideWithSilverCrownDoorGate = !collide;
				queue.push(function():void { checkSilverCrown(collide); });
			}
		}
		
		public function checkPurple():void {
			world.canShowOrHidePurple = true;
			if(world.overlaps(player)){
				world.canShowOrHidePurple = false;
			}
		}
		
		private var queue:Array = [];
		private var keysquene:Array = [];
		public var tilequeue:Array = [];
		
		public function setTile(layer:int,xo:int,yo:int,value:int, properties:Object):void {
			
			if (brushSize > 1 && justPlaced) {
				justPlaced = false;
				var minx:int; var miny:int;
				var maxx:int; var maxy:int;
				
				if (brushGridLocked) {
					//var offs:int = Math.min(Math.abs(gridOffset), brushSize-1);
					minx = -((xo - gridOffsetX + brushSize) % brushSize);
					miny = -((yo - gridOffsetY + brushSize) % brushSize);
					maxx = brushSize-1 + minx;
					maxy = brushSize-1 + miny;
				} else {
					minx = miny = -Math.floor((brushSize-1) / 2);
					maxx = maxy = Math.ceil((brushSize-1) / 2);
				}
				
				for (var xx:int = minx; xx <= maxx; xx++) {
					for (var yy:int = miny; yy <= maxy; yy++) {
						if (xo + xx >= 0 && xo + xx < world.width
							&& yo + yy >= 0 && yo + yy < world.height
							&&  !isSame(layer, xo + xx, yo + yy)) {
							setTile(layer, xo + xx, yo + yy, value, properties);
						}
					}
				}
				return;
			}
			
			if (layer == 0) {
				
				var spawnID:int = value == ItemId.WORLD_PORTAL_SPAWN ? Bl.data.spawn_id : 0;
				var oldSpawnID:int = world.lookup.getInt(xo, yo);
				var oldValue:int = world.getTile(0, xo, yo);
				
				if (value == ItemId.SPAWNPOINT && oldValue != ItemId.SPAWNPOINT ||
					value == ItemId.WORLD_PORTAL_SPAWN && oldValue != ItemId.WORLD_PORTAL_SPAWN ||
					value == ItemId.WORLD_PORTAL_SPAWN && oldValue == ItemId.WORLD_PORTAL_SPAWN && spawnID != oldSpawnID) {
					if (!world.spawnPoints[spawnID]) world.spawnPoints[spawnID] = new Array();
					world.spawnPoints[spawnID].push([xo, yo]);
				}
				if (oldValue == ItemId.SPAWNPOINT || oldValue == ItemId.WORLD_PORTAL_SPAWN) {
					var pos:String = xo + "," + yo;
					for (var j:int = 0; j < world.spawnPoints[oldSpawnID].length; j++) {
						if (String(world.spawnPoints[oldSpawnID][j]) == pos) {
							world.spawnPoints[oldSpawnID].splice(j, 1);
							break;
						}
					}
				}
			}
			
			for (var i:int = 0; i < tilequeue.length; i++) 
			{
				var tile:Tile = (tilequeue[i] as Tile);
				if( (tilequeue[i] as Tile).equals(new Tile(layer,xo,yo,value,properties))){
					tilequeue.splice(i,1);
					i--;
				}
			}
			
			var old:int = world.getTile(layer,xo,yo);
			
			// Check if an update is neccesary
			if( old == value && 
				old != ItemId.COINDOOR && 
				old != ItemId.COINGATE &&
				old != ItemId.BLUECOINDOOR && 
				old != ItemId.BLUECOINGATE && 
				old != ItemId.PORTAL && 
				old != 77 && 
				old != 83 && 
				old != 1520 && 
				old != 1000 &&
				old != ItemId.SPIKE &&
				old != ItemId.SPIKE_SILVER &&
				old != ItemId.SPIKE_BLACK &&
				old != ItemId.SPIKE_RED &&
				old != ItemId.SPIKE_GOLD &&
				old != ItemId.SPIKE_GREEN &&
				old != ItemId.SPIKE_BLUE &&
				old != ItemId.WORLD_PORTAL &&
				old != ItemId.WORLD_PORTAL_SPAWN &&
				old != ItemId.PORTAL_INVISIBLE &&
				old != ItemId.SWITCH_PURPLE &&
				old != ItemId.RESET_PURPLE &&
				old != ItemId.DOOR_PURPLE &&
				old != ItemId.GATE_PURPLE &&
				old != ItemId.DEATH_DOOR &&
				old != ItemId.DEATH_GATE &&
				old != ItemId.EFFECT_TEAM &&
				old != ItemId.TEAM_DOOR &&
				old != ItemId.TEAM_GATE &&
				old != ItemId.EFFECT_CURSE &&
				old != ItemId.EFFECT_FLY &&
				old != ItemId.TEXT_SIGN &&
				old != ItemId.EFFECT_JUMP &&
				old != ItemId.EFFECT_PROTECTION &&
				old != ItemId.EFFECT_RUN &&
				old != ItemId.EFFECT_ZOMBIE &&
				old != ItemId.EFFECT_LOW_GRAVITY &&
				old != ItemId.EFFECT_MULTIJUMP &&
				old != ItemId.EFFECT_GRAVITY &&
				old != ItemId.EFFECT_POISON &&
				old != ItemId.SWITCH_ORANGE &&
				old != ItemId.RESET_ORANGE &&
				old != ItemId.DOOR_ORANGE &&
				old != ItemId.GATE_ORANGE &&
				!ItemId.isBlockRotateable(old) &&
				!ItemId.isBackgroundRotateable(old) &&
				!ItemId.isNPC(old)) {
				return; /* THEN we return, doing nothing, because then there's nothing to update */
			}
			
			// Preventing glitchy coin increase.
			var ot:int = totalCoins;	
			var pc:int = player.coins;
			var ot_blue:int = bonusCoins;
			var pc_blue:int = player.bcoins;
			
			world.setTileComplex(layer,xo,yo,value,properties);
			
			var oldIsCoin:Boolean = old == 100 || old == 110;
			var newIsCoin:Boolean = value == 100 || value == 110;
			
			if(newIsCoin){
				if(!oldIsCoin){
					totalCoins ++;
				}else{
					player.coins--
				}
			}else{
				if(oldIsCoin){
					if(old == 110) player.coins--
						totalCoins --;
					for each(var pg:Player in players) {
						for (var ig:int = 0; ig < pg.gx.length; ig++) {
							if (pg.gx[ig] == xo && pg.gy[ig] == yo){
								pg.coins--;
								pg.gx.splice(ig, 1);
								pg.gy.splice(ig, 1);
							}
						}
					}
				}
			}
			
			if (old == ItemId.CHECKPOINT)
			{
				// Remove old checkpoint stored position so it doesn't appear green after placing back
				if (player.checkpoint_x == xo && player.checkpoint_y == yo)
				{
					player.resetCheckpoint();
				}
				for each (var p:Player in players)
				{
					if (p.checkpoint_x == xo && p.checkpoint_y == yo)
					{
						p.resetCheckpoint();
					}
				}
			}
			
			var oldIsBlueCoin:Boolean = old == 101 || old == 111
			var newIsBlueCoin:Boolean = value == 101 || value == 111;
			
			
			if(newIsBlueCoin){
				if(!oldIsBlueCoin){
					bonusCoins++
				}else{
					player.bcoins--
				}
			}else{
				if(oldIsBlueCoin){
					if(old == 111) player.bcoins--
						bonusCoins-- ;
					for each(var pb:Player in players) {
						for (var ib:int = 0; ib < pb.bx.length; ib++) {
							if (pb.bx[ib] == xo && pb.by[ib] == yo){
								pb.bcoins--;
								pb.bx.splice(ib, 1);
								pb.by.splice(ib, 1);
							}
						}
					}
				}
			}
			
			if(world.Overlaps(player, xo, yo)){
				totalCoins = ot;
				bonusCoins = ot_blue;
				player.coins = pc;
				player.bcoins = pc_blue;
				world.setTileComplex(layer,xo,yo,old, properties);
				tilequeue.push( new Tile(layer,xo,yo,value,properties) );
			}
			
			updateMinimap(xo,yo)
			
		}
		
		public override function enterFrame():void {
			super.enterFrame();
			Global.base.ui2instance.enterFrame();
			
			cointext.text = player.coins + "/" + totalCoins  
			bcointext.text = player.bcoins + "/" + bonusCoins
			deathcounttext.text = player.deaths + "x";
			
			var specTarget:Player = target as Player;
			if (specTarget != null) {
				spectatingText.text = "Spectating" + 
				(Global.base.isMenuOpen() ? "\n" : " ")
				+ specTarget.name.toUpperCase();
			}
			
			if (player.deaths > 9000 && !saidOver9000) {
				saidOver9000 = true;
				SoundManager.playMiscSound(SoundId.OVER9000);
			}
			
			var length:int = queue.length
			while(length--){
				queue.shift()();
			}
			
			var keyslength:int = keysquene.length;
			while (keyslength--){
				var key:Object = keysquene.shift();
				switchKey(key.color, key.state, true);
			}
			
			var tilelength:int = tilequeue.length
			while(tilelength--){
				var tile:Tile = tilequeue.shift();
				setTile(tile.layer,tile.xo,tile.yo,tile.value,tile.properties);
			}
			
			for each(var p:Player in players){
				minimap.showPlayer(p,p.minimapColor);
			}
			minimap.showPlayer(player, player.minimapColor);
			
			//for( var x:String in players){
				//p = players[x] as Player
				//p.enterChat()
			//}
			
			player.enterChat();
		}
		
		private var pastX:uint = 0;
		private var pastY:uint = 0;
		private var pastT:Number = new Date().time;
		
		public override function tick():void {
			Global.base.ui2instance.tick();
			
			var old:Number = world.showCoinGate;
			world.showCoinGate = player.coins;
			if (world.overlaps(player)) world.showCoinGate = old;
			// must check overlaps each time values like showCoinGate are changed
			
			var oldb:Number = world.showBlueCoinGate;
			world.showBlueCoinGate = player.bcoins;
			if (world.overlaps(player)) world.showBlueCoinGate = oldb;
			
			var oldd:Number = world.showDeathGate;
			world.showDeathGate = player.deaths;
			if (world.overlaps(player)) world.showDeathGate = oldd;
			
			
			for(var i:int = 0; i<particles.length-1;i++)
			{
				if (particles[i] != null) { 
					particles[i].tick();
					if (particles[i].life >= particles[i].maxlife) {
						remove(particles[i]);
						delete particles[i];
					}
				}
			}
			
			if (!confirm) {
				if (KeyBinding.screenshot.isJustPressed()) {
					confirm = new ConfirmPrompt("Do you want to make a screenshot?", false);
					confirm.btn_yes.addEventListener(MouseEvent.MOUSE_DOWN, function(userEvent:MouseEvent):void {
						confirm.close();
						Screenshot.SavePNG(userEvent);
					});
					confirm.onAnyClose = function():void { confirm = null; };
					Global.base.showOnTop(confirm);
				} else if (KeyBinding.screenshotMinimap.isJustPressed() && Global.base.ui2instance.minimapEnabled) {
					confirm = new ConfirmPrompt("Do you want to save the minimap?", false);
					confirm.btn_yes.addEventListener(MouseEvent.MOUSE_DOWN, function(userEvent:MouseEvent):void {
						confirm.close();
						Screenshot.SavePNGWithMinimap(userEvent);
					});
					confirm.onAnyClose = function():void { confirm = null; };
					Global.base.showOnTop(confirm);
				}
			}
			if (KeyBinding.hideChatBubbles.isJustPressed()) {
				Global.base.settings.hideBubbles = !Global.base.settings.hideBubbles;
				//Global.base.SystemSay(Global.base.settings.hideBubbles ? "Chat bubbles are now hidden." : "Chat bubbles are now visible.", "* System");
			}
			if (KeyBinding.hideUsernames.isJustPressed()) {
				Global.base.settings.hideUsernames = !Global.base.settings.hideUsernames;
			}
			
			if (KeyBinding.inspect.isJustPressed()) {
				Global.getPlacer = !Global.getPlacer;
				//Global.base.SystemSay("Inspect tool active: " + Global.getPlacer.toString().toUpperCase(), "* System");
			}
			
			if (KeyBinding.interact.isJustPressed()) {
				if (player.currentNpc) player.currentNpc.sayNext();
			}
			
			if (Bl.isKeyJustPressed(119)/* && Bl.stage.displayState != StageDisplayState.NORMAL*/) {
				//Global.base.SystemSay("TESTING FUNCTION", "* System");
				Bl.stage.scaleMode = Bl.stage.scaleMode == "exactFit"? "showAll":"exactFit";
				//Global.base.SystemSay("Changed scalemode to \"" + (Bl.stage.scaleMode == "exactFit"?"Exact Fit":"Show All") + "\"", "* System");
				Bl.stage.dispatchEvent(new Event(Event.RESIZE, false, false));
			}
			
			if (player.canCheat) {
				// Camera helpers
				if (KeyBinding.lookRight.isDown()) x += 15;
				if (KeyBinding.lookLeft.isDown()) x -= 15;
				if (KeyBinding.lookDown.isDown()) y += 15;
				if (KeyBinding.lookUp.isDown()) y -= 15;
				
				if (KeyBinding.lockCamera.isJustPressed()) {
					target = target ? null : player;
					_isPlayerSpectating = false;
				}
				if (KeyBinding.hideUI.isJustPressed()) Global.base.toggleUI();
				
				if (!confirm && KeyBinding.screenshotFull.isJustPressed()) {
					confirm = new ConfirmPrompt("Do you want to make a screenshot of this entire world?", false);
					confirm.btn_yes.addEventListener(MouseEvent.MOUSE_DOWN, function(userEvent:MouseEvent):void {
						confirm.close();
						Screenshot.SavePNGWithFullWorld(userEvent);
					});
					confirm.onAnyClose = function():void { confirm = null; };
					Global.base.showOnTop(confirm);
				}
			}
			
			if (KeyBinding.godmode.isJustPressed() && Bl.data.canToggleGodMode) { // user pressed "g" key
				player.isInGodMode = !player.isInGodMode;
				player.resetDeath();
				world.setShowAllSecrets(player.isInGodMode);
				Global.ui2.auraMenu.redraw();
				Global.ui2.toggleGodMode(player.isInGodMode);
				if (!Bl.data.canToggleGodMode)
				Global.ui2.configureInterface(player.isInGodMode);
				
				if (player.isInModMode) {
					player.isInModMode = !player.isInModMode;
					player.resetDeath();
				}
			}
			
			if (Bl.isKeyJustPressed(27) && isPlayerSpectating) { //escape button
				stopSpectating();
			}
			
			if (Global.base.ui2instance.trialsMode && KeyBinding.retryRun.isJustPressed()) {
				var t:int = getTimer();
				if (lastRetry == -1 || t - lastRetry >= 500) {
					Global.playState.player.resetPlayer();
					Global.base.hideCampaignTrialDone();
					lastRetry = t;
				}
			}
			
			var xo:int = ((Bl.mouseX - this.x) / 16) >> 0;
			var yo:int = ((Bl.mouseY - this.y) / 16) >> 0;
			
			if (Bl.isMiddleMouseJustPressed) {
				if (Bl.data.canEdit) {
					var favBricks:BrickContainer = Global.base.ui2instance.favoriteBricks;
					var id:int = world.getTile(0, xo, yo);
					if (id == 0) { //foreground layer check
						id = world.getTile(1, xo, yo);
						
						if (id == 0) { //background layer check
							favBricks.select(0);
							return;
						}
					}
					
					if (favBricks.getPosFromID(id) != -1) {
						readBlock(getLayerFromId(id), xo, yo, favBricks.getPosFromID(id));
					}
					else {
						var pos:int = favBricks.selectedBlock;
						readBlock(getLayerFromId(id), xo, yo, pos);
					}
				}
			}
			
			if(Bl.isMouseJustPressed || Bl.isMouseDown){
				if (!(Bl.mouseX > 640 ||  Bl.mouseX < 0 || Bl.mouseY > 470 ||  Bl.mouseY < 0)) {
					var layer:int = getLayerFromId(Bl.data.brick);
					var determinedLayer:int = layer;
					
					// Erase stuff: first time the mouse is pressed, determine layer
					if (Bl.isMouseJustPressed) {
						// If something exists in the foreground layer, erase that first...
						if (world.getTile(0,xo,yo) != 0)
							determinedLayer = 0;
						else
							determinedLayer = 1;
						
						// Lock on that layer
						eraserLayerLock = determinedLayer;
					}
					else {
						determinedLayer = eraserLayerLock;
					}
					
					if (Bl.data.brick == 0)
						layer = determinedLayer;
					
					var clicked:Boolean = false;
					
					if (Bl.isKeyDown(86) && Bl.isMouseJustPressed && player.canCheat && (player.isFlying || player.isInGodMode || player.isInModMode)) {
						player.x = xo << 4;
						player.y = yo << 4;
						player.enforceMovement = true;
					}
					
					if (Bl.data.canEdit && xo >= 0 && yo >= 0 && xo < world.width && yo < world.height && !Bl.isKeyDown(86))
					{
						if (Bl.data.brick == 100 && world.getTile(0,xo,yo) == 110) {
							setTile(0,xo,yo,100, null)
						}
						
						if (Bl.data.brick == 101 && world.getTile(0,xo,yo) == 111) {
							setTile(0,xo,yo,101, null)
						}
						
						clicked = true;
						
						// Read block from the world 
						var numberDown:int = numberKeyDown();
						if (Global.base.settings.blockPicker && numberDown != -1) {
							readBlock(determinedLayer, xo, yo, numberDown);
						}
							
						else if ((brushSize > 1 || !isSame(layer,xo,yo)) && Bl.data.brick >= 0 && !isPlayerSpectating) {
							var dochange:Boolean = true
							if (xo == pastX && yo == pastY) {
								if (new Date().time - pastT < 500) dochange = false;
							}
							
							if (lockPlacement) {
								dochange = false;
								
								if (Bl.isMouseJustPressed)
									lockPlacement = false;
							}
							
							if (dochange) {
								pastX = xo;
								pastY = yo;
								pastT = new Date().time;
								placeBlock(layer, xo, yo, Bl.data.brick);
							}
						}
							
						else {
							clicked = false;
						}
					}
					if(!clicked && isPlayerSpectating)
					{
						stopSpectating();
						lockPlacement = true;
					}
				}
			}
			playerOverlaps();
			super.tick()
		}
		
		private function getLayerFromId(id:int):int {
			return id >= 500 && id < 1000 ? 1 : 0;
		}
		
		private function numberKeyDown():int {
			var n:int = 0;
			for (var k:int = 48; k <= 57; k++) {
				if (Bl.isKeyDown(k)) return n;
				n++;
			}
			return -1;
		}
		
		private function readBlock(layer:int, x:int, y:int, pos:int):void {
			var id:int = world.getTile(layer, x, y);
			
			if (!Global.base.canUseBlock(ItemManager.getBrickById(id)) && id != ItemId.COLLECTEDCOIN && id != ItemId.COLLECTEDBLUECOIN)
				return;
			
			Bl.data.brick = id;
			
			switch (Bl.data.brick) {
				case ItemId.COINDOOR:
				case ItemId.COINGATE:
				case ItemId.BLUECOINDOOR:	
				case ItemId.BLUECOINGATE:{
					Bl.data.coincount = world.lookup.getInt(x, y);
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
					Bl.data.switchId = world.lookup.getInt(x, y);
					break;
				}
				
				case ItemId.DEATH_DOOR:
				case ItemId.DEATH_GATE: {
					Bl.data.deathcount = world.lookup.getInt(x, y);
					break;
				}
					
				case ItemId.PORTAL_INVISIBLE:
				case ItemId.PORTAL: {
					Bl.data.portal_id = world.lookup.getPortal(x, y).id;
					Bl.data.portal_target = world.lookup.getPortal(x, y).target;
					break;
				}
				
				case ItemId.WORLD_PORTAL: {
					Bl.data.world_portal_id = parseInt(world.lookup.getWorldPortal(x, y).id);
					Bl.data.world_portal_target = world.lookup.getWorldPortal(x, y).target;
					Bl.data.world_portal_name = "";
					break;
				}
				
				case ItemId.WORLD_PORTAL_SPAWN: {
					Bl.data.spawn_id = world.lookup.getInt(x, y);
					break;
				}
				
				case ItemId.TEXT_SIGN: {
					Global.text_sign_text = world.lookup.getTextSign(x, y).text;
					break;
				}
					
				case 83:{
					Global.drumOffset = world.lookup.getInt(x, y);
					break;
				}
				case 77:{
					Global.pianoOffset = world.lookup.getInt(x, y);
					break;
				}
				case ItemId.EFFECT_TEAM:
				case ItemId.TEAM_DOOR:
				case ItemId.TEAM_GATE: {
					Bl.data.team = world.lookup.getInt(x, y);
					break;
				}
				case ItemId.EFFECT_CURSE:
				case ItemId.EFFECT_ZOMBIE:
				case ItemId.EFFECT_POISON: {
					Bl.data.effectDuration = world.lookup.getInt(x, y);
					break;
				}
				case ItemId.EFFECT_FLY:
				case ItemId.EFFECT_PROTECTION:
				case ItemId.EFFECT_LOW_GRAVITY: {
					Bl.data.onStatus = world.lookup.getBoolean(x, y);
					break;
				}
				case ItemId.EFFECT_JUMP:
				case ItemId.EFFECT_RUN: {
					Bl.data.mode = world.lookup.getInt(x, y);
					break;
				}
				case ItemId.EFFECT_MULTIJUMP: {
					Bl.data.jumps = world.lookup.getInt(x, y);
					break;
				}
				case ItemId.EFFECT_GRAVITY: {
					Bl.data.direction = world.lookup.getInt(x, y);
					break;
				}
				case 1520:{
					Global.guitarOffset = SoundManager.guitarMap.indexOf(world.lookup.getInt(x, y));
					break;
				}
				case 1000: {
					var labelLookup:LabelLookup = world.lookup.getLabel(x, y);
					Bl.data.wrapLength = labelLookup.WrapLength;
					Global.default_label_text = labelLookup.Text;
					Global.default_label_hex = labelLookup.Color;
					break;
				}
				case ItemId.COLLECTEDBLUECOIN:
				case ItemId.COLLECTEDCOIN: {
					Bl.data.brick -= 10; //cheese, but works. Turns collected coins into real ones. 110 -> 100; 111 -> 101
					break;
				}
				default:{
					if (ItemId.isNPC(Bl.data.brick)) {
						world.lookup.getNpc(x, y).setAsDefault();
					}
					break;
				}
			}
			
			
			
			if (pos == 0) pos = 10;
			
			Global.base.ui2instance.favoriteBricks.setDefault(pos, ItemManager.getBrickById(Bl.data.brick));
			Global.base.ui2instance.favoriteBricks.select(pos);
		}
		
		private function playerOverlaps():void {
			players["me"] = player;
			for each(var p1:Player in players) {
				if (!p1.getCanTag()) continue;
				if (p1.touchCooldown > 0){
					p1.touchCooldown--;
					continue;
				}
				for each(var p2:Player in players) {
					if (p1 == p2) continue;
					if (p2.getCanBeTagged()) {
						if (MathUtil.inRange(p1.x, p1.y, p2.x, p2.y, 8)) {
							if (p1.cursed && !p2.cursed) {
								var curTime:Number = new Date().time;
								p1.touchCooldown = 100;
								p2.touchCooldown = 100;
								p2.setEffect(Config.effectCurse, true, Math.round(p1.curseDuration - (curTime - p1.curseTimeStart) / 1000), p1.curseDuration);
								p1.setEffect(Config.effectCurse, false);
							}
							if (p1.zombie && !p2.zombie) {
								p2.setEffect(Config.effectZombie, true, p1.zombieDuration, p1.zombieDuration);
							}
							if (p1.isInvulnerable && (p2.cursed || p2.zombie)) {
								p2.setEffect(Config.effectCurse, false);
								p2.setEffect(Config.effectZombie, false);
							}
						}
					}
				}
			}
			delete players["me"];
		}
		
		private function isSame(layer:int, x:int, y:int):Boolean {
			if (Bl.data.brick != world.getTile(layer, x, y)) return false;
			if (ItemId.isBackgroundRotateable(Bl.data.brick)) return false;
			if (ItemId.isBlockRotateable(Bl.data.brick)) return false;
			
			switch(Bl.data.brick){
				case ItemId.COINDOOR:
				case ItemId.COINGATE:
				case ItemId.BLUECOINDOOR:	
				case ItemId.BLUECOINGATE:
					return world.lookup.getInt(x, y) == Bl.data.coincount;
					
				case ItemId.SWITCH_PURPLE:
				case ItemId.RESET_PURPLE:
				case ItemId.DOOR_PURPLE:
				case ItemId.GATE_PURPLE:
				case ItemId.SWITCH_ORANGE:
				case ItemId.RESET_ORANGE:
				case ItemId.DOOR_ORANGE:
				case ItemId.GATE_ORANGE:
					return world.lookup.getInt(x, y) == Bl.data.switchId;
					
				case ItemId.DEATH_DOOR:
				case ItemId.DEATH_GATE: 
					return world.lookup.getInt(x, y) == Bl.data.deathcount;
					
				case 83:
					return world.lookup.getInt(x, y) == Global.drumOffset;
					
				case 77:
					return world.lookup.getInt(x, y) == Global.pianoOffset;
					
				case ItemId.SPIKE:
				case ItemId.SPIKE_SILVER:
				case ItemId.SPIKE_BLACK:
				case ItemId.SPIKE_RED:
				case ItemId.SPIKE_GOLD:
				case ItemId.SPIKE_GREEN:
				case ItemId.SPIKE_BLUE:
				case ItemId.WORLD_PORTAL:
				case ItemId.PORTAL_INVISIBLE:
				case ItemId.TEXT_SIGN:
				case ItemId.PORTAL:		
					return false;
				
				case ItemId.WORLD_PORTAL_SPAWN:
					return world.lookup.getInt(x, y) == Bl.data.spawn_id;
				
				case ItemId.EFFECT_TEAM:
				case ItemId.TEAM_DOOR:
				case ItemId.TEAM_GATE: 
					return world.lookup.getInt(x, y) == Bl.data.team;
					
				case ItemId.EFFECT_GRAVITY: 
					return world.lookup.getInt(x, y) == Bl.data.direction;
					
				case ItemId.EFFECT_CURSE:
				case ItemId.EFFECT_ZOMBIE: 
				case ItemId.EFFECT_POISON:
					return world.lookup.getInt(x, y) == Bl.data.effectDuration;
					
				case ItemId.EFFECT_FLY:
				case ItemId.EFFECT_PROTECTION:
				case ItemId.EFFECT_LOW_GRAVITY: 
					return world.lookup.getBoolean(x, y) == Bl.data.onStatus;
					
				case ItemId.EFFECT_JUMP: 
				case ItemId.EFFECT_RUN:
					return world.lookup.getInt(x, y) == Bl.data.mode;
					
				case ItemId.EFFECT_MULTIJUMP: 
					return world.lookup.getInt(x, y) == Bl.data.jumps;
					
				case 1000: 
					return false;
					
				case 1520:
					return world.lookup.getInt(x, y) == Global.guitarOffset;
				default: 
					if (ItemId.isNPC(Bl.data.brick)) return false;
					return true;
			}
		}
		
		private var chatTime:Number = new Date().time;
		private var starty:Number = 0;
		private var startx:Number = 0;
		private var endy:Number = 0;
		private var endx:Number = 0;
		public override function draw(target:BitmapData, ox:int, oy:int):void {
			var nn:Number = new Date().time; 
			
			startx = -this.x - 90;
			starty = -this.y - 90;
			endx = startx + Bl.width + 180;
			endy = starty + Bl.height + 180;
			
			super.draw(target, ox, oy)
			
			var ox2:int = ox + x;
			var oy2:int = oy + y;
			
			var visible:Boolean = !player.moving || Global.chatIsVisible;
			if (!visible) {
				chatTime = new Date().time;
			} else {
				if (new Date().time - chatTime < 1500) visible = false || Global.chatIsVisible;
			}
			
			// Draws the "above" decoration layer
			world.postDraw(target, ox2, oy2);
			
			for (var n:String in players) {
				var p:Player = players[n] as Player;
				if (p.x > startx && p.y > starty && p.x < endx && p.y < endy) {
					// Draws other flying players
					p.drawGods(target, ox2, oy2);
					// Draws others' names, teamdots, and queues chat messages for drawing (or draws microchat)
					p.drawChat(target, ox2, oy2, visible);
				}
			}
			
			// Finds the current closest NPC
			var nearest:Npc = world.findCurrentNPC();
			if (player.currentNpc != null) nearest = player.currentNpc;
			
			// Draws the NPC's name, if you ARE flying
			if (nearest && player.isFlying) nearest.drawName(target, ox2, oy2);
			
			// Queues NPC's chat bubbles for drawing (or draws microchat)
			if (player.currentNpc) player.currentNpc.drawChat(target, ox2, oy2);
			
			// Draws you, if flying
			player.drawGods(target, ox2, oy2);
			// Draws your name, teamdot, and queues your chat messages for drawing (or draws microchat)
			player.drawChat(target, ox2, oy2, visible);
			
			// Draws the NPC's name, if you're NOT flying
			if (nearest && !player.isFlying) nearest.drawName(target, ox2, oy2);
			
			// Draws all queued chat messages
			Chat.drawAll();
			
			// Draws bubbles for signs, world portals, etc.
			world.drawDialogs(target, ox2, oy2);
			
			var min:int = Global.showUI ? -16 : -200;
			var usedup:int = 0;
			if(player.deaths > 0) { deathcountcontainer.draw(target, 0,usedup + min); usedup += 15; }
			if(totalCoins > 0) { cointextcontainer.draw(target, 0,usedup + min); usedup += 15; }
			if(bonusCoins > 0) { bcointextcontainer.draw(target,0,usedup + min); usedup += 15; }
			
			if (isPlayerSpectating) {
				spectatingText.draw(target, 0, 0);
				stopSpectatingText.draw(target, 0, 0);
			}
			
			if(Bl.data.showMap){
				minimap.draw(target, 0, 0)
			}else minimap.clear();
			
			if (Global.debug_stats && Global.base.overlayContainer.contains(Global.debug_stats)) {
				Global.base.overlayContainer.setChildIndex(Global.debug_stats, Global.base.overlayContainer.numChildren - 1);
			}
			if (Global.drawableContentTest.numChildren > 0) {
				if (!Global.base.overlayContainer.contains(Global.drawableContentTest)) 
					Global.base.overlayContainer.addChild(Global.drawableContentTest)
			}
			
			lastframe = target;
		}
		
		override public function get align():String {
			return STATE_ALIGN_LEFT;
		}
		
		public function reset():void {
			if (Global.debug_stats && Global.base.overlayContainer.contains(Global.debug_stats))
				Global.base.overlayContainer.removeChild(Global.debug_stats);
			Global.debug_stats = null;
		}
		
		public function getPlayerScreenPosition(id:int = -1):Point {
			var p:Player = player;
			if (id >= 0) p = players[id] as Player;
			
			return p == null? new Point(-1, -1): new Point(x + p.x, y + p.y);
		}
		
		private function doAnim(p:Player, type:String):void {
			var bmd:BitmapData;
			if (type == "favorite") bmd = AnimationManager.animFavorite;
			if (type == "like") bmd = AnimationManager.animLike;
			
			var anim:AnimatedSprite = new AnimatedSprite(bmd,40);
			anim.x = p.x-12;
			anim.y = p.y-13;
			anim.scale = 0;
			add(anim);
			TweenMax.to(anim,.3,{y:"-30", scale:1, ease:com.greensock.easing.Quint.easeOut});
			TweenMax.to(anim,.1,{scale:0,delay:2,onCompleteParams:[anim],onComplete:function(s:AnimatedSprite):void{
				remove(s);
			}});
		}
		
		public function getWorld():World {
			return this.world;
		}
		
		public function getPlayer():Player {
			return this.player;
		}
		
		public function setBlockPlayerData(xo:int, yo:int, layer:int, playerid:int):void {
			if (playerid == -1) return;
			var p:Player = null;
			
			p = player;
			
			if (!p) return;
			world.lookup.setPlacer(xo, yo, layer, p.name);
		}
		
		private var fPid_:int = 1;
		public function addFakePlayer(smiley:int, aura:int, auraColor:int, goldBorder:Boolean = false, xx:int = -1, yy:int = -1, name:String = "", admin:Boolean = false, adminRow:int = 0):void {
			var id:int = fPid_++;
			var p:Player  = players[id] as Player;
			
			if (p) return;
			
			var num:int = countFakePlayers+1;
			p = new Me(world, name == "" ? "fake" + (num==10?0:num).toString() : name, false, this);
			players[id] = p;
			p.id = id;
			
			p.worldGravityMultiplier = gravityMultiplier;
			
			p.worldSpawn = num;
			if(xx == -1) {
				p.placeAtSpawn();
			} else {
				p.x = xx * 16;
				p.y = yy * 16;
			}
			
			p.frame = smiley;
			p.wearsGoldSmiley = goldBorder;
			p.aura = aura;
			p.auraColor = auraColor;
			
			p.coins = 0;
			p.bcoins = 0;
			p.deaths = 0;
			p.team = 0;
			p.isInGodMode = false;
			p.isInModMode = admin;
			p.modmodeRow = adminRow;
			
			//var isguest:Boolean = name.indexOf("-") != -1;
			//var chatcolor:Number = 0xCCCCCC;
			//if(isguest) chatcolor = 0x666666;		
			//if (ChatColor > -1) chatcolor = ChatColor;			
			//chatcolor = Player.getNameColor(p.name);
			//
			//p.nameColor = chatcolor;
			
			p.canEdit = false;
			
			addBefore(p,player);
			Global.base.updateMenu();
		}
		
		public function removeFakePlayers():void {
			for (var spId:String in players) {
				var pId:int = parseInt(spId);
				if (players[pId] == target) stopSpectating();
				remove(players[pId]);
				delete players[pId];
			}
			Global.base.updateMenu();
		}
		
		public function resetFakePlayers():void {
			for each(var fp:Player in players) {
				var oldx:Number = fp.x;
				var oldy:Number = fp.y;
				fp.resetPlayer();
				if (target == fp) {
					offset(oldx - fp.x,
						oldy - fp.y)
				}
			}
		}
		
		public function removeFakePlayer(id:int):void {
			//trace("removing id", id);
			//for (var spId:String in players) {
				//var pId:int = parseInt(spId);
				//if(pId == id) {
					//remove(players[pId]);
					//delete players[pId];
					//return;
				//}
			//}
			if(players[id]) {
				if (players[id] == target) stopSpectating();
				remove(players[id]);
				delete players[id];
				Global.base.updateMenu();
			}
			var i:int = 1;
			for each(var fp:Player in getFakePlayers) {
				if(fp.name.substr(0, 4) == "fake")
					fp.name = fp.chat.name.text = "fake" + (i==10?0:i).toString();
				fp.worldSpawn = i;
				i++;
			}
		}
		
		public function get countFakePlayers():int {
			var num:int = 0;
			for (var spId:String in players) {
				num++;
			}
			return num;
		}
		
		public function get getFakePlayers():Array {
			var fps:Array = [];
			for each(var fp:Player in players) {
				fps.push(fp);
			}
			fps.sort(function(a:Player, b:Player):int {
				if (a.id > b.id) return 1;
				if (a.id < b.id) return -1;
				return 0;
			});
			return fps;
		}
		
		public function randInt(min:Number, max:Number):Number {
			return min + (max - min) * Math.random();
		}
		
		private var lockPlacement:Boolean = false;
		
		private var _isPlayerSpectating:Boolean = false;
		public function get isPlayerSpectating():Boolean {
			return _isPlayerSpectating;
		}
		
		public function spectate(target:Player):void {
			this.target = target;
			Global.ui2.setSelectedAura(target.aura);
			Global.ui2.setSelectedAuraColor(target.auraColor);
			Global.ui2.setSelectedSmiley(target.frame);
			Global.base.setGoldBorder(target.wearsGoldSmiley);
			_isPlayerSpectating = true;
		}
		
		public function stopSpectating():void {
			target = player;
			Global.ui2.setSelectedAura(player.aura);
			Global.ui2.setSelectedAuraColor(player.auraColor);
			Global.ui2.setSelectedSmiley(Global.cookie.data.smiley);
			Global.base.setGoldBorder(player.wearsGoldSmiley);
			_isPlayerSpectating = false;
		}
		
		private function getIntArrayFromVarint(bytes:ByteArray):Array {
			var shift:int = 0;
			var result:uint = 0;
			
			var results:Array = [];
			
			for (var i:int = 0; i < bytes.length; i++) {
				var byteValue:uint = bytes[i];
				var tmp:uint = byteValue & 0x7f;
				result |= tmp << shift;
				
				if ((byteValue & 0x80) != 0x80) {
					results.push((int)(result));
					result = 0;
					shift = 0;
					continue;
				}
				
				shift += 7;
			}
			
			return results;
		}
		
		public function getWidth() : int {
			return this.rw;
		}
		public function getHeight() : int {
			return this.rh;
		}
		public function setWidth(w:int) : void {
			this.rw = w;
			width = w;
		}
		public function setHeight(h:int) : void {
			this.rh = h;
			height = h;
		}
		
		public function placeBlock(layer:int, x:int, y:int, id:int):void {
			justPlaced = true;
			var rotation:int = 0;
			if (ItemId.isBlockRotateable(id) || ItemId.isNonRotatableHalfBlock(id)
			|| id == ItemId.SPIKE
			|| id == ItemId.SPIKE_SILVER
			|| id == ItemId.SPIKE_BLACK
			|| id == ItemId.SPIKE_RED
			|| id == ItemId.SPIKE_GOLD
			|| id == ItemId.SPIKE_GREEN
			|| id == ItemId.SPIKE_BLUE) {
				rotation = world.lookup.getInt(x, y);
				world.updateRotateablesMap(id, x, y);
				var maxRotation:int = 
					(id == ItemId.INDUSTRIAL_PIPE_THIN || id == ItemId.INDUSTRIAL_PIPE_THICK) ? 1 :
					(id == ItemId.INDUSTRIAL_TABLE) ? 2 :
						
					(id == ItemId.DOJO_LIGHT_LEFT || id == ItemId.DOJO_LIGHT_RIGHT || id == ItemId.DOJO_DARK_LEFT || id == ItemId.DOJO_DARK_RIGHT) ? 2 :
					
					(id == ItemId.MEDIEVAL_TIMBER) ? 5 :
					
					(id == ItemId.DOMESTIC_PIPE_STRAIGHT) ? 1 :
					
					(id == ItemId.HALLOWEEN_2015_WINDOW_RECT || id == ItemId.HALLOWEEN_2015_WINDOW_CIRCLE || id == ItemId.HALLOWEEN_2015_LAMP || id == ItemId.HALLOWEEN_2016_PUMPKIN) ? 1 :
					
					(id == ItemId.NEW_YEAR_2015_BALLOON || id == ItemId.NEW_YEAR_2015_STREAMER || id == ItemId.CHRISTMAS_2016_LIGHTS_DOWN || id == ItemId.CHRISTMAS_2016_LIGHTS_UP) ? 4 :
					(id == ItemId.FIREWORKS) ? 5 :
					
					(id == ItemId.TOXIC_WASTE_BARREL) ? 1 :
					(id == ItemId.SEWER_PIPE) ? 4 :
					
					(id == ItemId.FAIRYTALE_FLOWERS || id == ItemId.SPRING_DAISY || id == ItemId.SPRING_TULIP || id == ItemId.SPRING_DAFFODIL) ? 2 :
					
					(id == ItemId.SUMMER_FLAG || id == ItemId.SUMMER_AWNING || id == ItemId.CAVE_CRYSTAL) ? 5 :
					
					(id == ItemId.RESTAURANT_PLATE) ? 4 :
					
					(id == ItemId.SHADOW_C || id == ItemId.SHADOW_H) ? 1 :
					
					(id == ItemId.DOMESTIC_FRAME_BORDER) ? 10 : 3;
				setTile(layer,x,y,id,{rotation:rotation >= maxRotation ? 0 : rotation+1});
				return;
			}
			switch(id) {										
				case ItemId.COINDOOR:
				case ItemId.COINGATE:
				case ItemId.BLUECOINDOOR:
				case ItemId.BLUECOINGATE:{
					setTile(layer,x,y,id, {rotation:Bl.data.coincount});
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
					setTile(0,x,y,id,{rotation:(Bl.data.switchId == -1 ? 1000 : Bl.data.switchId)});
					break;
				}
				
				case ItemId.DEATH_DOOR:
				case ItemId.DEATH_GATE: {
					setTile(0,x,y,id,{rotation:Bl.data.deathcount});
					break;
				}
					
				case ItemId.PORTAL_INVISIBLE:
				case ItemId.PORTAL: {
					rotation = world.lookup.getPortal(x, y).rotation;
					setTile(0,x,y,id,{rotation:rotation >= 3 ? 0 : rotation+1, id:Bl.data.portal_id, target:Bl.data.portal_target});
					break;
				}
					
				case ItemId.WORLD_PORTAL:{
					if (Bl.data.world_portal_name != null){
						var targetWorld:String = Bl.data.world_portal_id == Global.worldIndex ? "Current" : Bl.data.world_portal_id.toString();
						setTile(0,x,y,id,{target:targetWorld, spawnid:Bl.data.world_portal_target});
					}
					break;
				}
				
				case ItemId.WORLD_PORTAL_SPAWN:{
					setTile(0,x,y,id,{rotation:Bl.data.spawn_id});
					break;
				}
				
				case ItemId.TEXT_SIGN: {
					rotation = world.lookup.getTextSign(x, y).type;
					setTile(0, x, y, id, {text:Global.text_sign_text, signtype:rotation >= 3 ? 0 : rotation+1});
					break;
				}
					
				case ItemId.LABEL:{
					setTile(0, x, y, id, {text:Global.default_label_text, text_color:Global.default_label_hex, wraplength:Bl.data.wrapLength});
					break;
				}
					
				case 83:{
					setTile(0,x,y,id,{rotation:Global.drumOffset});
					
					break
				}
				case 77:{
					setTile(0,x,y,id,{rotation:Global.pianoOffset});
					break;
				}
				case ItemId.EFFECT_TEAM:
				case ItemId.TEAM_DOOR:
				case ItemId.TEAM_GATE: {
					setTile(0,x,y,id,{rotation:Bl.data.team});
					break;
				}
				case ItemId.EFFECT_GRAVITY: {
					setTile(0,x,y,id,{rotation:Bl.data.direction});
					break;
					break;
				}
				case ItemId.EFFECT_CURSE:
				case ItemId.EFFECT_ZOMBIE:
				case ItemId.EFFECT_POISON: {
					setTile(0,x,y,id,{rotation:Bl.data.effectDuration});
					break;
				}
				case ItemId.EFFECT_FLY:
				case ItemId.EFFECT_PROTECTION:
				case ItemId.EFFECT_LOW_GRAVITY: {
					setTile(0,x,y,id,{rotation:Bl.data.onStatus ? 1 : 0});
					break;
				}
				case ItemId.EFFECT_JUMP:
				case ItemId.EFFECT_RUN: {
					setTile(0,x,y,id,{rotation:Bl.data.mode});
					break;
				}
				case ItemId.EFFECT_MULTIJUMP: {
					setTile(0,x,y,id,{rotation:Bl.data.jumps === -1 ? 1000 : Bl.data.jumps});
					break;
				}
				case 1520:{
					setTile(0,x,y,id,{rotation:SoundManager.guitarMap[Global.guitarOffset]});
					break;
				}
				default:{
					if (ItemId.isNPC(id)) {
						setTile(0, x, y, id, {name:Bl.data.npc_name, messages:new Array(Bl.data.npc_mes1, Bl.data.npc_mes2, Bl.data.npc_mes3)});
						break;
					}
					setTile(layer,x,y,id,{});
					break;
				}
			}
		}
	}
}
