package{
	import blitter.Bl;
	import blitter.BlContainer;
	import blitter.BlObject;
	import blitter.BlSprite;
	import blitter.BlText;
	import blitter.BlTilemap;
	import items.ItemNpc;
	import utilities.MathUtil;

	import com.reygazu.anticheat.variables.SecureBoolean;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.ByteArray;
	
	import items.ItemId;
	import items.ItemManager;
	
	import states.PlayState;
	
	import ui.ingame.ResetPopup;
	
	
	public class World extends BlTilemap
	{
		private var player:Player
		
		private var labelcontainer:BlContainer = new BlContainer();
		public var particlecontainer:BlContainer = new BlContainer();
		
		private var bgColor:uint = 0xA8C0FC;
		private var customBgColor:Boolean = false;
		
		public var lookup:Lookup = new Lookup();
		
		// spawnpoint order no longer handled on server because yes
		// and now things are arrays of arrays/ints because world portals
		public var spawnPoints:Array = new Array();
		public var nextSpawnPos:Array = new Array();
		
		private static var worldportaltext:WorldPortalHelpBubble = new WorldPortalHelpBubble();
		private static var resetPopup:ResetPopup = new ResetPopup();
		
		public static function updateRiskyPopups():void {
			resetPopup.updateGraphic();
			worldportaltext.updateGraphic();
		}
		
		private var textSignBubble:TextBubble = new TextBubble();
		
		// indicates wheter to reveal all secretbricks, used when in god mode
		public var showAllSecrets:Boolean = false;
		
		private var inspectTool:InspectTool;
		
		private var isAnimatingNPC:Boolean = false;
		private var offsetNPC:Number;
		
		public var imageBlocks:Array = new Array();
			
		public function World(reset_lookups:Boolean = true){
			super(new Bitmap(new BitmapData(16,16,false,0x0)),9);
			if (reset_lookups) {
				lookup.reset();
				customBgColor = false;
			}
			
			inspectTool = new InspectTool(this);
		}

		public function setShowAllSecrets(show:Boolean):void{
			showAllSecrets = show;
		}
		
		public function setPlayer(p:Player):void{
			this.player = p;
		}
		
		public function setBackgroundColor(color:uint):void{
			/*Global.backgroundEnabled = */customBgColor = ((color >> 24) & 0xFF) == 255;
			Global.bgColor = bgColor = color;
			ItemManager.bricks[0].minimapColor = this.customBgColor?color:4.27819008E9;
			if (Global.ui2 && Global.ui2.settingsMenu && Global.ui2.settingsMenu.levelOptions &&
			Global.ui2.settingsMenu.levelOptions.backgroundColorSelector)
				Global.ui2.settingsMenu.levelOptions.backgroundColorSelector.handleBackgroundChange(bgColor);
		}
		
		private var offset:Number = 0;
		
		private var keys:Object = {
			"red": new SecureBoolean("RedKey"),
			"green": new SecureBoolean("GreenKey"),
			"blue": new SecureBoolean("BlueKey"),
			"cyan": new SecureBoolean("CyanKey"),
			"magenta": new SecureBoolean("MagentaKey"),
			"yellow": new SecureBoolean("YellowKey")
		}
		
		private var keysTimer:Object = {
			"red": new Number(),
			"green": new Number(),
			"blue": new Number(),
			"cyan": new Number(),
			"magenta": new Number(),
			"yellow": new Number()
		}
		
		public function getKey(color:String):Boolean {
			if (!keys[color]) throw new Error("Color '" + color + "' doesn't exist!");
			if (!(keys[color] is SecureBoolean)) throw new Error("Key '" + color + "' is not type 'SecureBoolean'!");
			return keys[color].value;
		}
		
		public function setKey(color:String, state:Boolean, fromqueue:Boolean = false):void {
			if (!keys[color]) throw new Error("Color '" + color + "' doesn't exist!");
			if (!(keys[color] is SecureBoolean)) throw new Error("Key '" + color + "' is not type 'SecureBoolean'!");
			if (fromqueue && ((offset - keysTimer[color]) / 30) >= 5) return;
			keys[color].value = state;
			if (state == true && !fromqueue) keysTimer[color] = offset;
		}
		
		public function setTimedoor(state:Boolean):void {
			hideTimedoorOffset = offset;
			hideTimedoorTimer = new Date().time;
			timedoorState = state; 
		}
		
		public var orangeSwitches:Object = {};
		
		private var timedoorState:Boolean = false;
		public var canShowOrHidePurple:Boolean = false;
		public var showCoinGate:int = 0;
		public var showBlueCoinGate:int = 0;
		public var showDeathGate:int = 0;
		public var hideTimedoorOffset:Number = 0;
		public var hideTimedoorTimer:Number = new Date().time;
		
		public override	function update():void{
			offset+=.3;
			
			// Update all particles
			for (var i:int=0;i<particlecontainer.children.length;i++) {
				var p:Particle = particlecontainer.children[i] as Particle;
				p.tick();
			}
			
			//aaaaaaaaaaaaaaaaaaa
			if (((offset - hideTimedoorOffset) / 30) >= 5) {
				setTimedoor(!timedoorState);
			}
			
			for(var color:String in keys) {
				if (getKey(color) && ((offset - keysTimer[color]) / 30) >= 5) {
					Global.playState.switchKey(color, false);
				}
			}
			
			super.update()
		}
		
		public function updateRotateablesMap(type:int, x:int, y:int, layer:int = 0):void {
			var prevBlock:int = getTile(layer, x, y);
			if (prevBlock == type) return; //prev block is the same as the current
			
			if (prevBlock != ItemId.SPIKE
			&&	prevBlock != ItemId.SPIKE_SILVER
			&&	prevBlock != ItemId.SPIKE_BLACK
			&&	prevBlock != ItemId.SPIKE_RED
			&&	prevBlock != ItemId.SPIKE_GOLD
			&&	prevBlock != ItemId.SPIKE_GREEN
			&&	prevBlock != ItemId.SPIKE_BLUE
			&& !ItemId.isBlockRotateable(prevBlock)) return; //prev block is not rotatable And it's not a spike
			
			if (type != ItemId.SPIKE 
			&&	type != ItemId.SPIKE_SILVER
			&&	type != ItemId.SPIKE_BLACK
			&&	type != ItemId.SPIKE_RED
			&&	type != ItemId.SPIKE_GOLD
			&&	type != ItemId.SPIKE_GREEN
			&&	type != ItemId.SPIKE_BLUE
			&& !ItemId.isBlockRotateable(type)) return; //current block is not rotatable And it's not a spike
				lookup.deleteLookup(x, y); //reset the rotateable in the lookup
		}
		
		private function readUShortArray(data:ByteArray) : Array {
			var arr:Array = [];
			var length:int = data.readUnsignedInt();
			var offset:int = data.position;
			for (var i:int = 0; i < length / 2; i++ ) {
				data.position = 2 * i + offset;
				arr[i] = (data.readUnsignedByte() << 8) | data.readUnsignedByte();
			}
			return arr;
		}
		
		public function deserializeFromMessage(width:int, height:int):Array{
			var offset:int;
			var length:int;
			
			var layers:Array = []
			var cols:Array = []
			var row:Array = []
			
			lookup.reset();
				
			//Create empty world array.
			var l:int;
			for(l=0;l<2;l++)
			{
				cols = [];
				for( var a:int=0;a<height;a++){
					row = []
					for( var b:int=0;b<width;b++){
						row.push(0);
					}
					cols.push(row);
				}
				layers.push(cols);
			}
			
			if (Global.dataPos == -1) {
				//for(l=0;l<2;l++) {
					//for (var c:int = 0; c < height; c++) {
						//for ( var d:int = 0; d < width; d++) {
							//layers[l][c][d] = 0;
						//}
					//}
				//}
				var c:int;
				for ( c = 0; c < height; c++) {
					layers[0][c][0] = 9;
					layers[0][c][width-1] = 9;
				}
				for ( c = 0; c < width; c++) {
					layers[0][0][c] = 9;
					layers[0][height-1][c] = 9;
				}
			} 
			else {
				
				Global.newData.position = Global.dataPos;
				
				while (Global.newData.position < Global.newData.length){
					var type:int = Global.newData.readInt();
					var layer:int = Global.newData.readInt();
					var xs:Array = readUShortArray(Global.newData);
					var ys:Array = readUShortArray(Global.newData);
					var rotation:int = 0 // portal and spikes
					var id:int = 0		 // portal, world portal spawn and music
					var tar:int = 0;	 // portal and world portal
					var text:String;	// label
					var text_color:String;	// label color
					var wrapLength:int;	// label wrap
					var target_world:String; // world portal
					var sign_text:String;
					var sign_type:int;
					var onStatus:Boolean; // On/off blocks
					var name:String; //npc
					var messages:Array = new Array();
					
					// check if its a rotateable block (note spikes and portals are not included in the decorations)
					if (ItemId.isBlockRotateable(type) || ItemId.isNonRotatableHalfBlock(type) || ItemId.isBlockNumbered(type)
					|| type === ItemId.GUITAR || type === ItemId.DRUMS || type === ItemId.PIANO
					|| type === ItemId.SPIKE || type == ItemId.SPIKE_SILVER || type == ItemId.SPIKE_BLACK
					|| type == ItemId.SPIKE_RED || type == ItemId.SPIKE_GOLD || type == ItemId.SPIKE_GREEN || type == ItemId.SPIKE_BLUE) {
						rotation = Global.newData.readInt();
					} else if (type === ItemId.PORTAL || type === ItemId.PORTAL_INVISIBLE) {
						rotation = Global.newData.readInt();
						id = Global.newData.readInt();
						tar = Global.newData.readInt();
					} else if (type === ItemId.TEXT_SIGN) {
						sign_text = Global.newData.readUTF();
						sign_type = Global.newData.readInt();
					} else if (type === ItemId.WORLD_PORTAL) {
						target_world = Global.newData.readUTF();
						tar = Global.newData.readInt();
					} else if (type === ItemId.LABEL) {
						text = Global.newData.readUTF();
						text_color = Global.newData.readUTF();
						wrapLength = Global.newData.readInt();
					} else if (ItemId.isNPC(type)) {
						name = Global.newData.readUTF();
						messages[0] = Global.newData.readUTF();
						messages[1] = Global.newData.readUTF();
						messages[2] = Global.newData.readUTF();
					}
					
					xs.position = 0;
					ys.position = 0;
					
					for(var o:int=0;o<xs.length;o++){
						var nx:int = xs[o];
						var ny:int = ys[o];
						
						if (nx >= width || ny >= height) continue;
						
						layers[layer][ny][nx] = type;
						
						if (ItemId.isBlockRotateable(type) || ItemId.isNonRotatableHalfBlock(type) || ItemId.isBlockNumbered(type)) {
							lookup.setInt(nx, ny, rotation);
						}
						
						switch(type) {
							//case ItemId.COINDOOR:
							//case ItemId.BLUECOINDOOR:
							//case ItemId.BLUECOINGATE:
							//case ItemId.COINGATE:
							//case ItemId.DEATH_DOOR:
							//case ItemId.DEATH_GATE:
							//case ItemId.SWITCH_PURPLE:
							//case ItemId.RESET_PURPLE:
							//case ItemId.DOOR_PURPLE:
							//case ItemId.GATE_PURPLE:
							//case ItemId.EFFECT_TEAM:
							//case ItemId.TEAM_DOOR:
							//case ItemId.TEAM_GATE:
							//case ItemId.EFFECT_CURSE:
							//case ItemId.EFFECT_ZOMBIE:
							//case ItemId.EFFECT_FLY:
							//case ItemId.EFFECT_JUMP:
							//case ItemId.EFFECT_PROTECTION:
							//case ItemId.EFFECT_RUN:
							//case ItemId.EFFECT_LOW_GRAVITY:
							//case ItemId.EFFECT_MULTIJUMP:
							//case ItemId.EFFECT_POISON:
							//case ItemId.SWITCH_ORANGE:
							//case ItemId.RESET_ORANGE:
							//case ItemId.DOOR_ORANGE:
							//case ItemId.GATE_ORANGE:
							//{
								//lookup.setInt(nx, ny, rotation);
								//break;
							//}
							case 83:
							case 77:
							case 1520:{
								lookup.setInt(nx, ny, rotation);
								break;
							}
							//
							//case ItemId.EFFECT_GRAVITY:
							case ItemId.SPIKE:
							case ItemId.SPIKE_SILVER:
							case ItemId.SPIKE_BLACK:
							case ItemId.SPIKE_RED:
							case ItemId.SPIKE_GOLD:
							case ItemId.SPIKE_GREEN:
							case ItemId.SPIKE_BLUE: {
								lookup.setInt(nx, ny, rotation);
								break;
							}
							case ItemId.PORTAL_INVISIBLE:
							case ItemId.PORTAL:{
								lookup.setPortal(nx, ny, new Portal(id, tar, rotation, type));
								break
							}
							case ItemId.WORLD_PORTAL: {
								lookup.setWorldPortal(nx, ny, new WorldPortal(target_world, tar));
								break;
							}
							
							case ItemId.SPAWNPOINT:
							case ItemId.WORLD_PORTAL_SPAWN: {
								//lookup.setInt(nx, ny, rotation);
								if(!spawnPoints[rotation]) spawnPoints[rotation] = new Array();
								spawnPoints[rotation].push([nx, ny]);
								//if(!nextSpawnPos[id]) nextSpawnPos[id] = 0;
								break;
							}
							//case ItemId.SPAWNPOINT: {
								//if(!spawnPoints[0]) spawnPoints[0] = new Array();
								//spawnPoints[0].push([nx, ny]);
								////if(!nextSpawnPos[0]) nextSpawnPos[0] = 0;
								//break;
							//}
							
							case 1000: {
								lookup.setLabel(nx, ny, text, text_color, wrapLength);
								var t:BlText = new BlText(Global.default_label_size,wrapLength,uint("0x"+text_color.substr(1,text_color.length)),"left","system",true);
								t.text = text;
								t.x = nx * size;
								t.y = ny * size;
								labelcontainer.add(t);
							}
							
							case ItemId.TEXT_SIGN: {
								lookup.setTextSign(nx, ny, new TextSign(sign_text, sign_type));
								break;
							}
							
							case ItemId.BRICK_COMPLETE: {
								break;
							}
						}
						if(ItemId.isNPC(type)) {
							lookup.setNpc(nx, ny, name, messages, ItemManager.getNpcById(type));
						}
					}
				}
			}
			setMapArray(layers);
			return layers;
		}
		
		public function resetCoins():void{
			for( var a:int=0;a<width;a++){
				for( var b:int=0;b<height;b++){
					if(realmap[0][b][a] == 110) setTile(0,a,b,100);
					if(realmap[0][b][a] == 111) setTile(0,a,b,101);
				}
			}
		}
		
		// ******************************************************************************
		//  setTileComplex
		// ******************************************************************************
		
		public function setTileComplex(layer:int,x:int, y:int, type:int, properties:Object):void
		{
			if (layer == 0) {
				lookup.deleteLookup(x, y);
			}
			
			if (ItemId.isBlockRotateable(type) || ItemId.isNonRotatableHalfBlock(type)) { 
				if (properties.rotation != null) {
					lookup.setInt(x, y, properties.rotation);
				}
			}
			
			// removing save-breaking symbols
			if (properties != null && properties.text != null) {
				properties.text = properties.text.replace(/᎙/g, "");
			}
			if (properties != null && properties.messages != null) {
			for (var i:int = 0; i < properties.messages.length; i++) {
					properties.messages[i] = properties.messages[i].replace(/᎙/g, "");
				}
			}
			
			switch(type){
				case ItemId.COINDOOR:
				case ItemId.BLUECOINDOOR:
				case ItemId.BLUECOINGATE:
				case ItemId.COINGATE:
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
				case ItemId.EFFECT_ZOMBIE:
				case ItemId.EFFECT_FLY:
				case ItemId.EFFECT_JUMP:
				case ItemId.EFFECT_PROTECTION:
				case ItemId.EFFECT_RUN:
				case ItemId.EFFECT_LOW_GRAVITY:
				case ItemId.EFFECT_MULTIJUMP:
				case ItemId.EFFECT_POISON:
				case ItemId.SWITCH_ORANGE:
				case ItemId.RESET_ORANGE:
				case ItemId.DOOR_ORANGE:
				case ItemId.GATE_ORANGE:
				case ItemId.WORLD_PORTAL_SPAWN: {
					lookup.setInt(x, y, properties.rotation);
					break;
				}
				
				case ItemId.EFFECT_GRAVITY:
				case ItemId.SPIKE:
				case ItemId.SPIKE_SILVER:
				case ItemId.SPIKE_BLACK:
				case ItemId.SPIKE_RED:
				case ItemId.SPIKE_GOLD:
				case ItemId.SPIKE_GREEN:
				case ItemId.SPIKE_BLUE: {
					if (properties.rotation != null) {
						lookup.setInt(x, y, properties.rotation);
					}
					break;
				}
				case ItemId.PORTAL_INVISIBLE:
				case ItemId.PORTAL:{
					if(properties.rotation != null && properties.id != null && properties.target != null) {
						lookup.setPortal(x, y, new Portal(properties.id, properties.target, properties.rotation, type));
					}
					break;
				}
				case ItemId.WORLD_PORTAL:{
					if (properties.target != null && properties.spawnid != null) {
						lookup.setWorldPortal(x, y, new WorldPortal(properties.target, properties.spawnid));
					}	
					break;
				}
				case ItemId.TEXT_SIGN: {
					if (properties.text != null && properties.signtype != null) {
						lookup.setTextSign(x, y, new TextSign(properties.text, properties.signtype));
					}
					break;
				}
				case 83:
				case 77:
				case 1520:{
					lookup.setInt(x, y, properties.rotation);
					lookup.setBlink(x, y, 30);
					break;
				}
				case 411:
				case 412:
				case 413:
				case 414:
				case ItemId.SLOW_DOT_INVISIBLE:
				case 1519:
				case ItemId.FIREWORKS: {
					lookup.setBlink(x, y, 0);
					break;
				}
				case 1000:{
					lookup.setLabel(x, y, properties.text, properties.text_color, properties.wraplength);
					var t:BlText = new BlText(Global.default_label_size,lookup.getLabel(x, y).WrapLength,uint("0x"+properties.text_color.substr(1,properties.text_color.length)),"left","system",true);
					t.text = properties.text;
					t.x = x * size;
					t.y = y * size;
					labelcontainer.add( t );
					break;
				}
			}
			
			if (ItemId.isNPC(type) && properties.name != null && properties.messages) {
				if (player.currentNpc && lookup.getNpc(x, y).equals(player.currentNpc)) {
					lookup.setNpc(x, y, properties.name, properties.messages, ItemManager.getNpcById(type));
					player.currentNpc = lookup.getNpc(x, y);
					player.currentNpc.reset();
				} else  lookup.setNpc(x, y, properties.name, properties.messages, ItemManager.getNpcById(type));
			}
			
			// Making sure labels get updated when a block with id 1000 is set to 0.
			if (type != 1000 && layer == 0) {
				for (var j:int=0;j<labelcontainer.children.length;j++) {
					var txt:BlText = labelcontainer.children[j] as BlText;
					if (txt.x == (x * size) && txt.y == (y * size)) {
						labelcontainer.remove(txt);
						break;
					}
				}
			}
			
			setTile(layer, x, y, type);
		}
		
		// ******************************************************************************
		//  setTile
		// ******************************************************************************
		
		protected override function setTile(layer:int, x:int, y:int, type:int):void {
			var old:int = realmap[layer][y][x];
			
			if (old == 1000) {
				var ch:Vector.<BlObject> = labelcontainer.children;
				for(var a:int = 0; a < ch.length; a++) {
					var cc:BlObject = ch[a];
					if (cc.x == x * size && cc.y == y * size) {
						labelcontainer.remove(cc);
						break;
					}
				}
			}
			super.setTile(layer, x, y, type);
			
			// now collected
			if (type == ItemId.COLLECTEDCOIN && old == ItemId.COIN) return;
			if (type == ItemId.COLLECTEDBLUECOIN && old == ItemId.BLUECOIN) return;
			// was collected
			if (type == ItemId.COIN && old == ItemId.COLLECTEDCOIN) return;
			if (type == ItemId.BLUECOIN && old == ItemId.COLLECTEDBLUECOIN) return;
			
			(Global.base.state as PlayState).unsavedChanges = true;
		}
		
		// ******************************************************************************
		//  overlaps - NOTE: Checks only in layer 0 (foreground)!
		// ******************************************************************************
		
		public function Overlaps(o:BlObject, x:int, y:int, isrotateable:Boolean = false) : Boolean
		{
			if ((o as Player).isFlying) return false;
			var bid:int = realmap[0][y][x];
			if(ItemId.isSolid(bid) || isrotateable)
			{
				var rect:Rectangle = ItemManager.GetBlockBounds(bid);
				if (isrotateable)
					rect = ItemManager.GetBlockBounds(bid, lookup.getInt(x, y));
				rect.x = rect.x+(x*16);
				rect.y = rect.y+(y*16);
				if (rect.intersects(new Rectangle(o.x, o.y, 16, 16)))
				{
					return true;
				}
				return false;
			}
			return false;
		}
		
		public override function overlaps(o:BlObject):int{
			if(o.x < 0 || o.y < 0 || o.x > this.width*16-16 || o.y > this.height*16-16 ) return 1;

			var pl:Player = o as Player;
			if (pl.isFlying) return 0;
			
			var ox:int = pl.x>>4; //player x
			var oy:int = pl.y>>4; //player y
		
			var oh:Number = (o.x+o.height)/size; 
			var ow:Number = (o.y+o.width)/size;
				
			var skipa:Boolean = false;
			var skipb:Boolean = false;
			var skipc:Boolean = false;
			var skipd:Boolean = false;
			var map:Vector.<int>;
			var rect:Rectangle = new Rectangle(pl.x, pl.y, 16, 16);
			for(var cy:int=oy; cy < ow; cy++){
				map = realmap[0][cy];
				for(var cx:int=ox; cx < oh; cx++){
					if(!map) continue;
					var val:int = map[cx];
					if (!ItemId.isSolid(val)) {
						if (val == 243) {
							lookup.setSecret(cx, cy, true);
						}
						continue;
					}
					if (!rect.intersects(new Rectangle(cx*16, cy*16, 16, 16))) continue;
					var rot:int = lookup.getInt(cx, cy);
					if (ItemId.isRotatableHalfBlock(val)) {
						if (ItemId.canJumpThroughFromBelow(val)) {
							//up
							if ((pl.speedY < 0 || cy <= pl.overlapa || (pl.speedY == 0 && pl.speedX == 0 && (pl.oy + 15) > cy * 16)) && rot == 1) {
								if(cy != oy || pl.overlapa == -1) pl.overlapa = cy;
								skipa = true
								continue
							}
							//right
							if ((pl.speedX > 0 || (cx <= pl.overlapb && pl.speedX <= 0 && pl.ox < cx*16+16)) && rot == 2) {
								if(cx != ox || pl.overlapb == -1) pl.overlapb = cx;
								skipb = true
								continue
							}
							//down
							if ((pl.speedY > 0 || (cy <= pl.overlapc && pl.speedY <= 0 && pl.oy < cy*16+16)) && rot == 3) {
								if(cy != oy || pl.overlapc == -1) pl.overlapc = cy;
								skipc = true
								continue
							}
							//left
							if ((pl.speedX < 0 || cx <= pl.overlapd || (pl.speedY == 0 && pl.speedX < 0 && (pl.ox - 15) < cx * 16)) && rot == 0) {
								if(cx != ox || pl.overlapd == -1) pl.overlapd = cx;
								skipd = true
								continue
							}
						}
					}
					else if (ItemId.isHalfBlock(val)) {
						if (rot == 1) {
							if (!rect.intersects(new Rectangle(cx*16, cy*16+8, 16, 8)))
								continue;
						}
						else if (rot == 2) {
							if (!rect.intersects(new Rectangle(cx*16, cy*16, 8, 16)))
								continue;
						}
						else if (rot == 3) {
							if (!rect.intersects(new Rectangle(cx*16, cy*16, 16, 8)))
								continue;
						}
						else if (rot == 0) {
							if (!rect.intersects(new Rectangle(cx*16+8, cy*16, 8, 16)))
								continue;
						}
					}
					else {
						if (ItemId.canJumpThroughFromBelow(val)) {
							if(pl.speedY < 0 || cy <= pl.overlapa || (pl.speedY == 0 && pl.speedX == 0 && (pl.oy + 15) > cy*16)){ 
								if(cy != oy || pl.overlapa == -1) pl.overlapa = cy;
								skipa = true
								continue
							}
						}
					}
					
					switch(val){
						case 23: if (getKey("red")) continue; break;
						case 24: if (getKey("green")) continue; break;
						case 25: if (getKey("blue")) continue; break;
						case 26: if (!getKey("red")) continue; break;
						case 27: if (!getKey("green")) continue; break;
						case 28: if (!getKey("blue")) continue; break;
						
						case 1005: if (getKey("cyan")) continue; break;
						case 1006: if (getKey("magenta")) continue; break;
						case 1007: if (getKey("yellow")) continue; break;
						case 1008: if (!getKey("cyan")) continue; break;
						case 1009: if (!getKey("magenta")) continue; break;
						case 1010: if (!getKey("yellow")) continue; break;
						
						case 156: if (timedoorState) continue; break;
						case 157: if (!timedoorState) continue; break;
						
						case ItemId.DOOR_PURPLE: if ( pl.switches[lookup.getInt(cx, cy)]) continue; break;
						case ItemId.GATE_PURPLE: if (!pl.switches[lookup.getInt(cx, cy)]) continue; break;
						
						case ItemId.DOOR_ORANGE: if ( orangeSwitches[lookup.getInt(cx, cy)]) continue; break;
						case ItemId.GATE_ORANGE: if (!orangeSwitches[lookup.getInt(cx, cy)]) continue; break;
						
						case ItemId.DOOR_GOLD: if ( pl.wearsGoldSmiley) continue; break;
						case ItemId.GATE_GOLD: if (!pl.wearsGoldSmiley) continue; break;
						
						case ItemId.CROWNDOOR: if ( pl.collideWithCrownDoorGate) continue; break;
						case ItemId.CROWNGATE: if (!pl.collideWithCrownDoorGate) continue; break;
						
						case ItemId.SILVERCROWNDOOR: if ( pl.collideWithSilverCrownDoorGate) continue; break;
						case ItemId.SILVERCROWNGATE: if (!pl.collideWithSilverCrownDoorGate) continue; break;
						
						case ItemId.COINDOOR: 		if (lookup.getInt(cx, cy) <= pl.coins) 	continue; break;
						case ItemId.BLUECOINDOOR: 	if (lookup.getInt(cx, cy) <= pl.bcoins)	continue; break;
						case ItemId.DEATH_DOOR: 	if (lookup.getInt(cx, cy) <= pl.deaths) continue; break;
						case ItemId.COINGATE: 		if (lookup.getInt(cx, cy) >  /*pl.coins*/ (pl.isme ? showCoinGate : pl.coins))  continue; break;
						case ItemId.BLUECOINGATE: 	if (lookup.getInt(cx, cy) >  /*pl.bcoins*/ (pl.isme ? showBlueCoinGate : pl.bcoins)) continue; break;
						case ItemId.DEATH_GATE: 	if (lookup.getInt(cx, cy) >  /*pl.deaths*/ (pl.isme ? showDeathGate : pl.deaths)) continue; break;
					
						case ItemId.TEAM_DOOR: if (pl.team == lookup.getInt(cx, cy)) continue; break;
						case ItemId.TEAM_GATE: if (pl.team != lookup.getInt(cx, cy)) continue; break;
						
						case ItemId.ZOMBIE_GATE: if (!pl.zombie) continue; break;
						case ItemId.ZOMBIE_DOOR: if ( pl.zombie) continue; break;
						
						case 50:{
							lookup.setSecret(cx, cy, true);
							break;
						}
					}
					
					return val;
				}
			}
			if(!skipa) pl.overlapa = -1
			if(!skipb) pl.overlapb = -1
			if(!skipc) pl.overlapc = -1
			if(!skipd) pl.overlapd = -1
			return 0;
		}
		
		public function getMinimapColor(xo:int,yo:int):Number{
			return 	ItemManager.getMinimapColor(decoration[yo][xo] || forground[yo][xo]  || background[yo][xo]) || ItemManager.getMinimapColor(background[yo][xo])
		}
		
		// ******************************************************************************
		//  draw
		// ******************************************************************************
		private static var point:Point = new Point();
		private static var sprite:BlSprite;

		
		private static var rect16x16:Rectangle = new Rectangle(0,0,16,16);
		private static var rect18x18:Rectangle = new Rectangle(0,0,18,18);
		private static var bmd:BitmapData;
		
		private static var type:int;
		
		private var ice:Number = 0;
		private var iceTime:int = 60;
		
		public var fullImage:BitmapData;
		public function drawFull():void {
			fullImage = new BitmapData(width * size, height * size, false);
			onDraw(fullImage, 0, 0, true);
			postDraw(fullImage, 0, 0, true);
			labelcontainer.draw(fullImage, 0, 0);
		}
		
		public override function draw(target:BitmapData, ox:int, oy:int):void{
			onDraw(target, ox, oy, false);
		}
		
		private function onDraw(target:BitmapData, ox:int, oy:int, full:Boolean):void{
			
			var height_:int = full ? height * size : Bl.height/size;
			var width_:int = full ? width * size : Bl.width/size;
			
			var starty:int = -oy/size - 1;
			var startx:int = -ox/size - 1;
			var clear:Boolean = false;
			if(starty < 0){
				clear = true;
				starty = 0;
			}
			if(startx < 0){
				clear = true;
				startx = 0;
			}
			
			var endy:int = starty + height_ + 2;
			var endx:int = startx + width_ + 2;
			
			if(endy > height){
				clear = true
				endy = height; 
			}
			if(endx > width){
				clear = true;
				endx = width; 
			}
			
			if(clear){
				//target.fillRect(target.rect, 0x0);
				target.fillRect(target.rect, 0x0);
			}
			
			var cy:uint;
			var cx:uint;
	
			var bgrow:Vector.<int>
			var fgrow:Vector.<int>
			var drow:Vector.<int>

			//Seperate loop to perserve shadows stupid!
			for(cy=starty; cy < endy; cy++){
				bgrow	= background[cy]
				fgrow	= forground[cy]
				for( cx=startx;cx<endx;cx++){
					point.x = (cx<<4)+ox;
					point.y = (cy<<4)+oy;
					
					if(fgrow[cx] != 0){
						continue;
					}
					
					// Render all background rotateables - current not in use
					var bgType:int = bgrow[cx];
					
					if(bgrow[cx] == 0 && customBgColor){
						//target.copyPixels(ItemManager.bmdBricks[614],rect16x16,point);						
						target.fillRect(new Rectangle(point.x,point.y,16,16), bgColor);
					}else{
						target.copyPixels(ItemManager.bmdBricks[bgrow[cx]],rect16x16,point);
					}
				}
			}
			
			//draw imageBlocks right after BG
			for (var i:int = 0; i<imageBlocks.length; i++) {
				var image:ImageBlock = (imageBlocks[i] as ImageBlock);
				if (!image.loaded) continue;
				if (!image.isInbounds(startx, starty, endx, endy)) continue; //is inbounds
				target.copyPixels(image.bitmapData, image.rect, new Point((image.x << 4) + ox, (image.y << 4) + oy));
			}
			
			ice += 0.25;
			if (ice > iceTime)
			{
				ice = 0;
				iceTime = Math.floor(Math.random() * (80 + 1)) + 40;
			}
			
			var infront:Vector.<Object> = new Vector.<Object>();
			
			//Draw BG			
			for( cy=starty;cy<endy;cy++){
				bgrow	= background[cy]
				drow	= decoration[cy];
				fgrow	= forground[cy]
				for( cx=startx;cx<endx;cx++){
					point.x = (cx<<4)+ox;
					point.y = (cy<<4)+oy;
					
					type = fgrow[cx]
						
					if(type != 0){						
						target.copyPixels(ItemManager.bmdBricks[type],rect18x18,point);
						continue;
					}
					
					type = drow[cx];
					//Early break for the empty forground case.
					if(type == 0) continue;

					
					// render rotateables, note spikes and portals are not in this list currently
					
					if (ItemId.isBlockRotateable(type) && !ItemId.isNonRotatableHalfBlock(type) && type != ItemId.HALLOWEEN_2016_EYES && type != ItemId.FIREWORKS && type != ItemId.DUNGEON_TORCH) {
						var rot:int = lookup.getInt(cx, cy);
						var rotSprite:BlSprite = ItemManager.getRotateableSprite(type);
						rotSprite.drawPoint(target, point, rot);
						continue;
					}
					switch(type){
						
						case ItemId.CHECKPOINT:{
							continue;
						}
						
						//Red doors
						case 23:
						case 26: {
							if (getKey("red")) {
								ItemManager.sprDoors.drawPoint(target, point, type == 23? 0 : 3);
								continue;
							}
							break;
						}
						
						//Green doors
						case 24:
						case 27: {
							if (getKey("green")) {
								ItemManager.sprDoors.drawPoint(target, point, type == 24? 1 : 4);
								continue;
							}
							break;
						}
						
						//Blue doors
						case 25:
						case 28: {
							if (getKey("blue")) {
								ItemManager.sprDoors.drawPoint(target, point, type == 25? 2 : 5);
								continue;
							}
							break;
						}
						
						//Cyan doors
						case 1005:
						case 1008: {
							if (getKey("cyan")) {
								ItemManager.sprDoors.drawPoint(target, point, type == 1005? 14 : 17);
								continue;
							}
							break;
						}
							
						//Magenta doors
						case 1006:
						case 1009: {
							if (getKey("magenta")) {
								ItemManager.sprDoors.drawPoint(target, point, type == 1006? 15 : 18);
								continue;
							}
							break;
						}
						
						//Yellow doors
						case 1007:
						case 1010: {
							if (getKey("yellow")) {
								ItemManager.sprDoors.drawPoint(target, point, type == 1007? 16 : 19);
								continue;
							}
							break;
						}
							
						// Death doors/gates
						case ItemId.DEATH_DOOR:{
							if (lookup.getInt(cx, cy) <= player.deaths) {
								ItemManager.sprDoors.drawPoint(target, point, 20)
							} else {
								ItemManager.sprDeathDoor.drawPoint(target, point, lookup.getInt(cx, cy) - player.deaths)
							}
							continue;
						}
						case ItemId.DEATH_GATE:{
							if (lookup.getInt(cx, cy) <= player.deaths) {
								ItemManager.sprDoors.drawPoint(target, point, 21)
							} else {
								ItemManager.sprDeathGate.drawPoint(target, point, lookup.getInt(cx, cy) - player.deaths)
							}
							continue;
						}
							
						//Purple switch, doors and gates
						case ItemId.DOOR_PURPLE:{
							if (player.switches[lookup.getInt(cx, cy)]) {
								ItemManager.sprPurpleGates.drawPoint(target, point, lookup.getInt(cx, cy))
							} else {
								ItemManager.sprPurpleDoors.drawPoint(target, point, lookup.getInt(cx, cy))
							}
							continue;
						}
						case ItemId.GATE_PURPLE:{
							if (player.switches[lookup.getInt(cx, cy)]) {
								ItemManager.sprPurpleDoors.drawPoint(target, point, lookup.getInt(cx, cy))
							} else {
								ItemManager.sprPurpleGates.drawPoint(target, point, lookup.getInt(cx, cy))
							}
							continue;
						}

						case ItemId.DOOR_ORANGE:{
							if (orangeSwitches[lookup.getInt(cx, cy)]) {
								ItemManager.sprOrangeGates.drawPoint(target, point, lookup.getInt(cx, cy))
							} else {
								ItemManager.sprOrangeDoors.drawPoint(target, point, lookup.getInt(cx, cy))
							}
							continue;
						}
						case ItemId.GATE_ORANGE:{
							if (orangeSwitches[lookup.getInt(cx, cy)]) {
								ItemManager.sprOrangeDoors.drawPoint(target, point, lookup.getInt(cx, cy))
							} else {
								ItemManager.sprOrangeGates.drawPoint(target, point, lookup.getInt(cx, cy))
							}
							continue;
						}
							
						case ItemId.DOOR_GOLD:{
							if(player.wearsGoldSmiley){
								ItemManager.sprDoors.drawPoint(target, point, 10)
								continue;
							}
							break;
						}
						case ItemId.GATE_GOLD:{
							if(player.wearsGoldSmiley){
								ItemManager.sprDoors.drawPoint(target, point, 11)
								continue;
							}
							break;
						}
						
						case ItemId.SWITCH_PURPLE:{
							if (player.switches[lookup.getInt(cx, cy)]) {
								ItemManager.sprSwitchDOWN.drawPoint(target, point, lookup.getInt(cx, cy))
							} else {
								ItemManager.sprSwitchUP.drawPoint(target, point,lookup.getInt(cx, cy))
							}
							continue;
						}
						
						case ItemId.SWITCH_ORANGE:{
							if (orangeSwitches[lookup.getInt(cx, cy)]) {
								ItemManager.sprOrangeSwitchDOWN.drawPoint(target, point,lookup.getInt(cx, cy))
							} else {
								ItemManager.sprOrangeSwitchUP.drawPoint(target, point,lookup.getInt(cx, cy))
							}
							continue;
						}
						
						case ItemId.RESET_PURPLE:{
							ItemManager.sprSwitchRESET.drawPoint(target, point, lookup.getInt(cx, cy))
							continue;
						}
						
						case ItemId.RESET_ORANGE:{
							ItemManager.sprOrangeSwitchRESET.drawPoint(target, point,lookup.getInt(cx, cy))
							continue;
						}
						
						//Time doors	
						case ItemId.TIMEDOOR:{
							ItemManager.sprDoorsTime.drawPoint(target, point, Math.min( (((offset-hideTimedoorOffset)/30)>>0) , 4) + (timedoorState? 5: 0))
							continue;
						}		
						case ItemId.TIMEGATE:{
							ItemManager.sprDoorsTime.drawPoint(target, point,Math.min( (((offset-hideTimedoorOffset)/30)>>0) , 4) + (timedoorState? 0: 5))
							continue;
						}		
						
						// Invisible arrow blink
						case 411:
						case 412:
						case 413:
						case 414: {
							if (!player.isFlying && !full) {
								if (lookup.isBlink(cx, cy)) {
									if (lookup.getBlink(cx, cy) >= 0) {
										var id:int = type - 411;
										if (lookup.getBlink(cx, cy) == 0) {
											lookup.setBlink(cx, cy, id * 5);
										}
										var frame:int = lookup.getBlink(cx, cy);										
										ItemManager.sprInvGravityBlink.drawPoint(target, point, frame);
										
										if (lookup.updateBlink(cx, cy, 1/10) >= 5 + id * 5) {
											lookup.deleteBlink(cx, cy);
										}
									} else {
										lookup.updateBlink(cx, cy, 1);
										break;
									}
									continue;
								} else {
									continue;
								}
							}
							break;
						}
						
						case 1519: {
							if (!player.isFlying && !full) {
								if (lookup.isBlink(cx, cy)) {
									if (lookup.getBlink(cx, cy) >= 0) {
										ItemManager.sprInvGravityDownBlink.drawPoint(target, point, lookup.getBlink(cx, cy));
										if (lookup.updateBlink(cx, cy, 1/10) >= 5) {
											lookup.deleteBlink(cx, cy);
										}
									} else {
										lookup.updateBlink(cx, cy, 1);
										break;
									}
									continue;
								} else {
									continue;
								}
							}
							break;
						}
						
						case ItemId.SLOW_DOT_INVISIBLE: {
							if (!player.isFlying && !full) {
								if (lookup.isBlink(cx, cy)) {
									if (lookup.getBlink(cx, cy) >= 0) {
										ItemManager.sprInvDotBlink.drawPoint(target, point, lookup.getBlink(cx, cy));
										if (lookup.updateBlink(cx, cy, 1/10) >= 5) {
											lookup.deleteBlink(cx, cy);
										}
									} else {
										lookup.updateBlink(cx, cy, 1);
										break;
									}
									continue;
								} else {
									continue;
								}
							}
							break;
						}
							
						case ItemId.CROWNDOOR:{
							if (player.collideWithCrownDoorGate) {
								ItemManager.sprDoors.drawPoint(target, point, 40);
								continue;
							} 
							break;
						}
							
						case ItemId.CROWNGATE:{
							if (player.collideWithCrownDoorGate) {
								ItemManager.sprDoors.drawPoint(target, point, 41);
								continue;
							}
							break;
						}
							
						case ItemId.SILVERCROWNDOOR:{
							if (player.collideWithSilverCrownDoorGate) {
								ItemManager.sprDoors.drawPoint(target, point, 42);
								continue;
							} 
							break;
						}
							
						case ItemId.SILVERCROWNGATE:{
							if (player.collideWithSilverCrownDoorGate) {
								ItemManager.sprDoors.drawPoint(target, point, 43);
								continue;
							}
							break;
						}
						
						case ItemId.COINDOOR:{
							// Open / Invisible
							if (lookup.getInt(cx, cy) <= player.coins) {
								ItemManager.sprDoors.drawPoint(target, point, 6)
							} else {
								// Locked
								ItemManager.sprCoinDoors.drawPoint(target, point, lookup.getInt(cx, cy) - player.coins)
							}
							continue;
						}
							
						case ItemId.BLUECOINDOOR:{
							// Open / Invisible
							if (lookup.getInt(cx, cy) <= player.bcoins) {
								ItemManager.sprDoors.drawPoint(target, point, 36)
							} else {
								// Locked
								ItemManager.sprBlueCoinDoors.drawPoint(target, point, lookup.getInt(cx, cy) - player.bcoins)
							}
							continue;
						}
							
						case ItemId.COINGATE:{
							// Open / Invisible
							if (lookup.getInt(cx,cy) <= player.coins) {
								ItemManager.sprDoors.drawPoint(target, point, 7)
							} else {
								// Locked
								ItemManager.sprCoinGates.drawPoint(target, point, lookup.getInt(cx, cy) - player.coins)
							}
							continue;
						}
							
						case ItemId.BLUECOINGATE:{
							// Open / Invisible
							if (lookup.getInt(cx, cy) <= player.bcoins) {
								ItemManager.sprDoors.drawPoint(target, point, 37)
							}else{
								// Locked
								ItemManager.sprBlueCoinGates.drawPoint(target, point, lookup.getInt(cx, cy) - player.bcoins)
							}
							continue;
						}
						
						case ItemId.ZOMBIE_DOOR: {
							if (player.zombie) {
								ItemManager.sprDoors.drawPoint(target, point, 12);
							}
							else {
								ItemManager.sprDoors.drawPoint(target, point, 13);
							}
							continue;
						}
						case ItemId.ZOMBIE_GATE: {
							if (player.zombie) {
								ItemManager.sprDoors.drawPoint(target, point, 13);
							}
							else {
								ItemManager.sprDoors.drawPoint(target, point, 12);
							}
							continue;
						}
							
						case 83:{
							if (lookup.isBlink(cx, cy)) {
								ItemManager.sprDrumsBlink.drawPoint(target, point, (lookup.getBlink(cx, cy)/6)<<0);
								if (lookup.updateBlink(cx, cy, -1) <= 0) {
									lookup.deleteBlink(cx, cy);
								}
								continue;
							}
							break;
						}
						case 77:{
							if (lookup.isBlink(cx, cy)) {
								ItemManager.sprPianoBlink.drawPoint(target, point, (lookup.getBlink(cx, cy)/6)<<0);
								if (lookup.updateBlink(cx, cy, -1) <= 0) {
									lookup.deleteBlink(cx, cy);
								}
								continue;
							}
							break;
						}
							
						//If user can edit, draw shadow coins	
						case 110:{
							if(Bl.data.canEdit){
								ItemManager.sprCoinShadow.drawPoint(target, point, ((offset >> 0)+cx+cy)%12)
							}
							continue;
						}
							
						case 111:{
							if(Bl.data.canEdit){
								ItemManager.sprBonusCoinShadow.drawPoint(target, point, ((offset >> 0)+cx+cy)%12)
							}
							continue;
						}
							
						case ItemId.SPIKE:{
							ItemManager.sprSpikes.drawPoint(target, point, lookup.getInt(cx, cy));	
							continue;
						}
						
						case ItemId.SPIKE_SILVER:{
							ItemManager.sprSpikesSilver.drawPoint(target, point, lookup.getInt(cx, cy));	
							continue;
						}
						case ItemId.SPIKE_BLACK:{
							ItemManager.sprSpikesBlack.drawPoint(target, point, lookup.getInt(cx, cy));	
							continue;
						}
						case ItemId.SPIKE_RED:{
							ItemManager.sprSpikesRed.drawPoint(target, point, lookup.getInt(cx, cy));	
							continue;
						}
						case ItemId.SPIKE_GOLD:{
							ItemManager.sprSpikesGold.drawPoint(target, point, lookup.getInt(cx, cy));	
							continue;
						}
						case ItemId.SPIKE_GREEN:{
							ItemManager.sprSpikesGreen.drawPoint(target, point, lookup.getInt(cx, cy));	
							continue;
						}
						case ItemId.SPIKE_BLUE:{
							ItemManager.sprSpikesBlue.drawPoint(target, point, lookup.getInt(cx, cy));	
							continue;
						}

						case ItemId.PORTAL:{
							var p:Portal = lookup.getPortal(cx,cy)
							ItemManager.sprPortal.drawPoint(target, point, p.rotation * 15 + (((offset/1.5 >> 0)+cx+cy)%15) + 1)// +1 because the first frame is just cy "dead portal" used by the UI
							continue;
						}	
							
						case ItemId.PORTAL_INVISIBLE: {
							if ((Bl.data.canEdit && player.isFlying) || full) {
								var pInv:Portal = lookup.getPortal(cx,cy);
								ItemManager.sprPortalInvisible.drawPoint(target, point, pInv.rotation);
							}
							continue;
						}

						case ItemId.WORLD_PORTAL:{
							ItemManager.sprPortalWorld.drawPoint(target, point, (((offset/2 >> 0)+cx+cy)%21));
							
							if (Math.random()*100<18) {
								addParticle(new Particle(this, Math.random()*100<50?6:7, (cx*16)+6, (cy*16)+6, .7, .7, 0.013, 0.013, Math.random()*360, Math.random()*115, true));
							}	
							continue;
						}
						
						case ItemId.DIAMOND:{
							ItemManager.sprDiamond.drawPoint(target, point, ((offset/5 >> 0)+cx+cy)%13)
							continue;
						}

						case ItemId.CAKE:{
							ItemManager.sprCake.drawPoint(target, point, ((offset/5 >> 0)+cx+cy)%5)
							continue;
						}
							
						case ItemId.HOLOGRAM:{
							ItemManager.sprHologram.drawPoint(target, point, ((offset/5 >> 0)+cx+cy)%5)
							continue;
						}
						
						case ItemId.EFFECT_TEAM: {
							var effectBlockTeam:int = lookup.getInt(cx, cy);							
							ItemManager.sprTeamEffect.drawPoint(target, point, effectBlockTeam);
							
							continue;
						}
						
						case ItemId.TEAM_DOOR: {
							var teamDoorTeam:int = lookup.getInt(cx, cy);
							var teamDoorFrame:int = 22 + teamDoorTeam;
							if (player.team == teamDoorTeam) teamDoorFrame += 7;
							ItemManager.sprDoors.drawPoint(target, point, teamDoorFrame);
							continue;
						}
						case ItemId.TEAM_GATE: {
							var teamGateTeam:int = lookup.getInt(cx, cy);
							var teamGateFrame:int = 29 + teamGateTeam;
							if (player.team == teamGateTeam) teamGateFrame -= 7;
							ItemManager.sprDoors.drawPoint(target, point, teamGateFrame);
							continue;
						}
							
						case ItemId.EFFECT_CURSE: {
							ItemManager.sprEffect.drawPoint(target, point, lookup.getInt(cx, cy) != 0 ? 4 : 11);
							continue;
						}
						case ItemId.EFFECT_FLY: {
							ItemManager.sprEffect.drawPoint(target, point, lookup.getBoolean(cx, cy) ? 1 : 8);
							continue;
						}
						case ItemId.EFFECT_JUMP: {
							ItemManager.sprEffect.drawPoint(target, point, [7, 0, 22][lookup.getInt(cx, cy)]);
							continue;
						}
						case ItemId.EFFECT_PROTECTION: {
							ItemManager.sprEffect.drawPoint(target, point, lookup.getBoolean(cx, cy) ? 3 : 10);
							continue;
						}
						case ItemId.EFFECT_RUN: {
							ItemManager.sprEffect.drawPoint(target, point, [9, 2, 25][lookup.getInt(cx, cy)]);
							continue;
						}
						case ItemId.EFFECT_ZOMBIE: {
							ItemManager.sprEffect.drawPoint(target, point, lookup.getInt(cx, cy) != 0 ? 5 : 12);
							continue;
						}
						case ItemId.EFFECT_LOW_GRAVITY: {
							ItemManager.sprEffect.drawPoint(target, point, lookup.getBoolean(cx, cy) ? 13 : 14);
							continue;
						}
						case ItemId.EFFECT_MULTIJUMP: {
							if (lookup.getInt(cx, cy) == 1) {
								ItemManager.sprEffect.drawPoint(target, point, 16)
							}
							else ItemManager.sprMultiJumps.drawPoint(target, point, lookup.getInt(cx, cy))
							continue;
						}
						case ItemId.EFFECT_GRAVITY: {
							ItemManager.sprGravityEffect.drawPoint(target, point, lookup.getInt(cx, cy));
							continue;
						}
						case ItemId.EFFECT_POISON: {
							ItemManager.sprEffect.drawPoint(target, point, lookup.getInt(cx, cy) != 0 ? 23 : 24);
							continue;
						}

						//Secret passages!
						case 50:{
							if (showAllSecrets || full || lookup.getSecret(cx, cy)) {
								ItemManager.sprSecret.drawPoint(target, point, 0);
							}
							continue;
						}
						case 243:{
							if (showAllSecrets || full || lookup.getSecret(cx, cy)) {
								ItemManager.sprSecret.drawPoint(target, point, 1);
							} else {
								ItemManager.bricks[44].drawTo(target, (cx<<4)+ox, (cy<<4)+oy)
							}
							continue;
						}
						case 136:{
							var pl:Player = (Global.base.state as PlayState).player;
							if ((Bl.data.canEdit && pl.isFlying) || full){
								ItemManager.sprSecret.drawPoint(target, point, 2);
							}
							continue;
						}
						
						case ItemId.LABEL: {
							continue;
						}
							
						case ItemId.ICE: {
							if (lookup.getNumber(cx, cy) != 0) {
								lookup.setNumber(cx, cy, lookup.getNumber(cx, cy) - .25);
								if (lookup.getNumber(cx, cy) % 12 == 0) {
									lookup.setNumber(cx, cy, 0);
								}
							} else if (ice == (cx + cy) % iceTime || Math.random() < 0.0001) {
								lookup.setNumber(cx, cy, 11.75);
							}
							ItemManager.sprIce.drawPoint(target, point, 11 - (lookup.getNumber(cx, cy) >> 0) % 12);
							continue;
						}
							
						case ItemId.CAVE_TORCH:{
							ItemManager.sprCaveTorch.drawPoint(target, point, ((offset/2.3 >> 0)+(width-cx)+cy)%12);
							continue;
						}
							
						case ItemId.DUNGEON_TORCH:{
							ItemManager.sprDungeonTorch.drawPoint(target, point, lookup.getInt(cx, cy) * 12 + ((offset/2.3 >> 0)+(width-cx)+cy)%12);
							continue;
						}
							
						case ItemId.CHRISTMAS_2016_CANDLE:{
							ItemManager.sprChristmas2016Candle.drawPoint(target, point, ((offset/2.3 >> 0)+(width-cx)+cy)%12);
							continue;
						}
							
						case ItemId.HALLOWEEN_2016_EYES:{
							if (player.isFlying)
							{
								ItemManager.sprHalloweenEyes.drawPoint(target, point, (lookup.getNumber(cx, cy)*6));
								continue;
							}
							
							if (lookup.isBlink(cx, cy)) {
								if (cx == startx || cx == endx-1 || cy == starty || cy == endy-1)
								{
									lookup.deleteBlink(cx, cy);
									continue;
								}
								var blink:int = lookup.getBlink(cx, cy);
								if (blink >= 6)
								{
									blink -= 6;
									//blink = 5-blink;
								}
								else
								{
									blink = 5-blink;
								}
								ItemManager.sprHalloweenEyes.drawPoint(target, point, blink+(lookup.getNumber(cx, cy)*6));
								if ((lookup.getBlink(cx, cy) != 5 && Math.random()<.25) || (lookup.getBlink(cx, cy) == 5 && Math.random() <= 0.01)){
									if (lookup.updateBlink(cx, cy, -1) <= 0) {
										lookup.deleteBlink(cx, cy);
									}
								}
							}
							else
							{
								if (Math.random() < 0.05 && MathUtil.inRange(cx*16, cy*16, player.x, player.y, 120))
									lookup.setBlink(cx,cy, 11);
							}
							continue;
						}
						case 1520:{
							if (lookup.isBlink(cx, cy)) {
								ItemManager.sprGuitarBlink.drawPoint(target, point, (lookup.getBlink(cx, cy)/6)<<0);
								if (lookup.updateBlink(cx, cy, -1) <= 0) {
									lookup.deleteBlink(cx, cy);
								}
								continue;
							}
							
							break;
						}
						case ItemId.FIREWORKS: {
							if (lookup.isBlink(cx, cy)) {
								var speed:Number = 1 / 3;
								var b:int = lookup.getBlink(cx, cy);
								var frames:int = ItemManager.blocksFireworksBMD.width / 64 / speed;
								if (b >= 0 && b <= frames) {
									infront.push({
										d:ItemManager.blocksFireworksBMD,
										r:new Rectangle(Math.floor(b * speed) * 64, lookup.getInt(cx, cy) * 64, 64, 64),
										p:new Point(point.x - 24, point.y - 24)
									});
								}
								if (lookup.updateBlink(cx, cy, 1) >= frames + 60 * 3) {
									lookup.deleteBlink(cx, cy);
								}
							} else if (Math.random() < 0.01 && MathUtil.inRange(cx * 16, cy * 16, player.x, player.y, 12 * 16)) {
								lookup.setBlink(cx, cy, 0);
							}
							if (player.isFlying) {
								ItemManager.sprFireworks.drawPoint(target, point, lookup.getInt(cx, cy));
							}
							continue;
						}
					}
					
					//If forground has content, draw forground
					target.copyPixels(ItemManager.bmdBricks[type],rect18x18,point);
					
				} // x loop
			} // y loop
			
			for each (var obj:Object in infront) {
				target.copyPixels(obj.d, obj.r, obj.p);
			}
			
			full = false;
		} // draw
		
		public final function postDraw(target:BitmapData, ox:int, oy:int, full_:Boolean = false):void{
			var height_:int = full_ ? height * size : Bl.height/size;
			var width_:int = full_ ? width * size : Bl.width/size;
			
			var starty:int = -oy/size - 1;
			var startx:int = -ox/size - 1;
			if(starty < 0) starty = 0;
			if(startx < 0) startx = 0;
			
			var endy:int = starty + height_ + 2;
			var endx:int = startx + width_ + 2;
			
			if(endy > height) endy = height; 
			if(endx > width) endx = width; 
			
			var cy:int;
			var cx:int;
			var row:Vector.<int>;
			
			var drewAnimatedNPC:Boolean = false;
			
			var infront:Vector.<Object> = new Vector.<Object>();
			
			for(cy=starty; cy<endy; cy++){
				row = above[cy];
				for(cx=startx; cx<endx; cx++){
					type = row[cx]
					point.x = (cx<<4)+ox;
					point.y = (cy<<4)+oy;
					switch(type){
						case 0:{
							break;
						}
							
						//Draw coins	
						case 100:{
							ItemManager.sprCoin.drawPoint(target, point,((offset >> 0)+cx+cy)%12)
							break;
						}
						case 101:{
							ItemManager.sprBonusCoin.drawPoint(target, point, ((offset >> 0)+cx+cy)%12)
							break;
						}

						case ItemId.WAVE:{
							ItemManager.sprWave.drawPoint(target, point, ((offset/5 >> 0))%8);
							break;
						}
						case ItemId.MUD_BUBBLE:{
							if (lookup.getNumber(cx, cy) != 0) {
								lookup.setNumber(cx, cy, lookup.getNumber(cx, cy) + .25);
								if (lookup.getNumber(cx,cy ) % 10 == 0) {
									lookup.setNumber(cx, cy, 0);
								}
							} else {
								if (Math.random()<0.005) {
									lookup.setNumber(cx, cy, 1 + Math.round(Math.random()) * 10);
								}
							}
							ItemManager.sprMudBubble.drawPoint(target, point, (lookup.getNumber(cx, cy) >> 0) % 19);
							break;
						}
						case ItemId.FIRE:{
							ItemManager.sprFireHazard.drawPoint(target, point, ((offset / 1.2 >> 0) + (width - cx) + cy) % 12);
							break;
						}
							
						case ItemId.WATER:{
							if (lookup.getInt(cx, cy) != 0) {
								lookup.setInt(cx, cy, lookup.getInt(cx, cy) + 1);
								if (lookup.getInt(cx, cy) % 25 == 0) {
									lookup.setInt(cx, cy, 0);
								}
							} else {
								if (Math.random() < 0.001) {
									lookup.setInt(cx, cy, int(Math.random() * 4) * 25 + 5);
								}
							}
							ItemManager.sprWater.drawPoint(target, point, int(lookup.getNumber(cx, cy) / 5))
							break;
						}
						case ItemId.TOXIC_WASTE: {
							if (lookup.getInt(cx, cy) != 0) {
								lookup.setInt(cx, cy, lookup.getInt(cx, cy) + 1);
								if (lookup.getInt(cx, cy) % 25 == 0) {
									lookup.setInt(cx, cy, 0);
								}
							} else {
								if (Math.random() < 0.005) {
									lookup.setInt(cx, cy, int(Math.random() * 4) * 25 + 5);
								}
							}
							ItemManager.sprToxic.drawPoint(target, point, int(lookup.getNumber(cx, cy) / 5))
							break;
						}
						case ItemId.TOXIC_WASTE_SURFACE: {
							if (lookup.getNumber(cx, cy) != 0) {
								lookup.setNumber(cx, cy, lookup.getNumber(cx, cy) + .25);
								if (lookup.getNumber(cx,cy ) % 10 == 0) {
									lookup.setNumber(cx, cy, 0);
								}
							} else {
								if (Math.random()<0.01) {
									lookup.setNumber(cx, cy, 1 + Math.round(Math.random()) * 10);
								}
							}
							ItemManager.sprToxicBubble.drawPoint(target, point, (lookup.getNumber(cx, cy) >> 0) % 19);
							break;
						}
						case ItemId.TEXT_SIGN:{
							var isFloating:Boolean = !ItemId.isSolid(getTile(0, cx, cy + 1));
							ItemManager.sprSign.drawPoint(target, point, lookup.getTextSign(cx, cy).type + (isFloating? 4 : 0))
							break;
						}
							
						case ItemId.LAVA:{
							ItemManager.sprLava.drawPoint(target, point, ((offset/5 >> 0))%8);
							break;
						}
						
						case ItemId.GOLDEN_EASTER_EGG: {
							infront.push({
								d:ItemManager.blocksGoldenEasterEggBMD,
								r:new Rectangle(0, 0, 48, 48),
								p:new Point(point.x - 16, point.y - 16)
							});
							break;
						}
						
						default:{
							if (ItemId.isNPC(type)) {
								var npclookup:Npc = lookup.getNpc(cx, cy);
								var npc:ItemNpc = ItemManager.getNpcById(type);
								if (player.currentNpc != null && player.currentNpc.equals(npclookup) && player.currentNpc.isTalking) {
									if (!isAnimatingNPC) {
										isAnimatingNPC = true;
										offsetNPC = offset;
										// Basically just makes NPCs always start animations at frame 0
									}
									npc.drawTo(target, point, ((offset - offsetNPC) / npc.rate >> 0) % npc.frames);
									drewAnimatedNPC = true;
								} else npc.drawTo(target, point, 0);
							} else if (ItemId.isBlockRotateable(type) && !ItemId.isNonRotatableHalfBlock(type) && type != ItemId.HALLOWEEN_2016_EYES && type != ItemId.FIREWORKS && type != ItemId.DUNGEON_TORCH) {
								var rot:int = lookup.getInt(cx, cy);
								var rotSprite:BlSprite = ItemManager.getRotateableSprite(type);
								rotSprite.drawPoint(target, point, rot);
							} else {
								target.copyPixels(ItemManager.bmdBricks[type],rect18x18,point);
							}
							break;
						}
					}
					
					if (decoration[cy][cx] == ItemId.CHECKPOINT) {
						ItemManager.sprCheckpoint.drawPoint(target, point, (player.checkpoint_x == cx && player.checkpoint_y == cy) ? 1 : 0);
					}
					
					if (Global.playState.brushSize > 1) {
						if(Global.playState.brushGridLocked) {
							if ((cx - Global.playState.gridOffsetX + Global.playState.brushSize)
								% Global.playState.brushSize == 0 && 
								(cy - Global.playState.gridOffsetY + Global.playState.brushSize)
								% Global.playState.brushSize == 0) {
								target.setPixel(point.x,   point.y,   0xff0000);
								target.setPixel(point.x-1, point.y,   0xff0000);
								target.setPixel(point.x,   point.y-1, 0xff0000);
								target.setPixel(point.x-1, point.y-1, 0xff0000);
							}
						} else {
							//Bl.stage.mouseX
							var mx:int = (Bl.mouseX - Global.playState.x) / 16 >> 0;
							var my:int = (Bl.mouseY - Global.playState.y) / 16 >> 0;
							var min:int = -Math.floor((Global.playState.brushSize-1) / 2);
							var max:int = 1+Math.ceil((Global.playState.brushSize-1) / 2);
							if (cx == mx + max && cy == my + max
							|| cx == mx + min && cy == my + min
							|| cx == mx + max && cy == my + min
							|| cx == mx + min && cy == my + max) {
								target.setPixel(point.x,   point.y,   0xff0000);
								target.setPixel(point.x-1, point.y,   0xff0000);
								target.setPixel(point.x,   point.y-1, 0xff0000);
								target.setPixel(point.x-1, point.y-1, 0xff0000);
							}
						}
					}
				}
			}
			
			for each (var obj:Object in infront) {
				target.copyPixels(obj.d, obj.r, obj.p);
			}
			
			if (!drewAnimatedNPC) isAnimatingNPC = false;
			
			labelcontainer.draw(target,ox,oy);
			particlecontainer.draw(target, ox, oy);
			
			
			lastframe = target;
		}
		
		public function drawDialogs(target:BitmapData, ox:int, oy:int):void {
			const starty:int = Math.max(0, -oy/size - 1);
			const startx:int = Math.max(0, -ox/size - 1);
			
			const endy:int = Math.min(height, starty + Bl.height/size + 2);
			const endx:int = Math.min(width, startx + Bl.width/size + 2);
			
			for (var cy:int = starty; cy < endy; cy++) {
				for (var cx:int = startx; cx < endx; cx++) {
					point.x = (cx<<4)+ox;
					point.y = (cy<<4)+oy;
					
					type = decoration[cy][cx]
					switch (type) {
						case ItemId.WORLD_PORTAL:{
							if (MathUtil.inRange(player.x, player.y, cx * 16, cy * 16, 8)) { // 8 pixels. 1/2 of the block
								worldportaltext.update(lookup.getWorldPortal(cx, cy), player.isInGodMode);
								worldportaltext.drawPoint(target, point);
							}
							break;
						}
						case ItemId.PORTAL:
						case ItemId.PORTAL_INVISIBLE: {
							if (MathUtil.inRange(player.x, player.y, cx * 16, cy * 16, 8) && (player.isFlying && Bl.data.canEdit)) {
								textSignBubble.update("ID: " + lookup.getPortal(cx, cy).id + "\nTARGET: " + lookup.getPortal(cx, cy).target);
								textSignBubble.drawPoint(target, point);
							}				
							break;
						}
						case ItemId.EFFECT_CURSE:
						case ItemId.EFFECT_ZOMBIE:
						case ItemId.EFFECT_POISON: {
							if (MathUtil.inRange(player.x, player.y, cx * 16, cy * 16, 8) && (player.isFlying && Bl.data.canEdit)) {
								var duration:int = lookup.getInt(cx, cy);
								if (duration == 0) break;
								textSignBubble.update("Duration: " + duration);
								textSignBubble.drawPoint(target, point);
							}
							break;
						}
					}
					
					type = above[cy][cx]
					switch (type) {
						case ItemId.TEXT_SIGN: {
							if (MathUtil.inRange(player.x, player.y, cx * 16, cy * 16, 8)){
								textSignBubble.update(lookup.getTextSign(cx, cy).text, lookup.getTextSign(cx, cy).type);
								textSignBubble.drawPoint(target, point);
							}
							break;
						}
						case ItemId.RESET_POINT: {
							if (MathUtil.inRange(player.x, player.y, cx * 16, cy * 16, 8)) {
								resetPopup.drawPoint(target, point);
							}
							break;
						}
					}
					
					if (Global.getPlacer)
					{
						const p1x:int = Bl.mouseX - ox - 16;
						const p1y:int = Bl.mouseY - oy - 16;
						
						const p2x:int = cx * 16;
						const p2y:int = cy * 16;
						
						if (p2x > p1x && p2x < p1x + 16 && p2y > p1y && p2y < p1y + 16)
						{
							inspectTool.updateForBlockAt(cx, cy);
							inspectTool.drawPoint(target, point);
						}
					}
				}
			}
		}
		
		//just a quick reminder. >>4 means /16 and <<4 means *16
		
		public function findCurrentNPC():Npc {
			
			var closest:Npc = null; // Closest NPC
			var closest2:Npc = null; // Closest with messages
			
			var radius:int = 64;
			var radiusSqr:int = radius * radius;
			var prevDistSqr:Number;
			var distSqr:Number;
			
			var left:int = 	Math.max((player.x - radius	) >> 4, 0);
			var right:int = Math.min((player.x + radius - .001) >> 4, width - 1);
			var top:int = 	Math.max((player.y - radius) >> 4, 0);
			var bottom:int= Math.min((player.y + radius - .001) >> 4, height - 1);
			
			for (var cy:int = top; cy <= bottom; cy++) {
				for (var cx:int = left; cx <= right; cx++) {
					if (cx < 0 || cy < 0 || cx >= width || cy >= height || !ItemId.isNPC(above[cy][cx])) continue;
					distSqr = MathUtil.distanceSqr(player.x, player.y, cx << 4, cy << 4);
					if (distSqr <= radiusSqr && (!closest || distSqr < prevDistSqr)) {
						var npc:Npc = lookup.getNpc(cx, cy);
						if (npc == closest || npc == closest2) continue;
						closest = npc;
						prevDistSqr = distSqr;
						if (!npc.messagesEmpty) closest2 = npc;
					}
				}
			}
			
			if (!closest2) {
				player.currentNpc = null; // if active npc wasn't found - remove current npc
			} else if (!player.currentNpc || !player.currentNpc.equals(closest2)) { // if active npc was found and it is not the same as current npc.
				player.currentNpc = closest2;
				player.currentNpc.reset();
			}
			
			return closest; // return the nearest npc, even without messages
		}
		
		public function addParticle(p:Particle):void {
			
			if (!Global.base.settings.particles) return;
			particlecontainer.add(p);
			var particles:int = particlecontainer.children.length;
			if (particles <= Config.max_Particles) return;
			var deleteAmount:int = particles - Config.max_Particles;
			var chil:Vector.<BlObject> = particlecontainer.children.splice(particlecontainer.children.length-deleteAmount, deleteAmount);
			
			for (var i:int = 0; i < chil.length; i++)
			{
				particlecontainer.remove(chil[i]);
			}
		}
		
		//return location of the block on the screen relative to the world
		public function worldOnScreen(point:Point, screen:Point):Point {
			return new Point((point.x << 4) + screen.x, (point.y << 4) + screen.y);
		}
		
		public function reset():void{
			bmd.dispose();
			realmap = null;
			background = null;
			decoration = null;
			forground = null;
			above = null;
		}
		
		public function removeAllLabels():void {
			labelcontainer.removeAll();
		}
	}
}
