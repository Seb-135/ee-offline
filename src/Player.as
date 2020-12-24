package
{
	import animations.AnimationManager;
	import flash.display.Bitmap;
	import flash.geom.Matrix;
	import flash.utils.getTimer;
	import ui.ingame.MultiJumpCounter;
	
	import blitter.Bl;
	import blitter.BlSprite;
	
	import com.greensock.TweenMax;
	import com.greensock.easing.Sine;
	import com.reygazu.anticheat.variables.SecureBoolean;
	import com.reygazu.anticheat.variables.SecureInt;
	import com.reygazu.anticheat.variables.SecureNumber;
	
	import flash.display.BitmapData;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.ByteArray;
	
	import flashx.textLayout.formats.Float;
	
	import items.ItemAura;
	import items.ItemAuraShape;
	import items.ItemId;
	import items.ItemManager;
	
	import ui.ingame.EffectDisplay;
	import ui.ConfirmPrompt;
	
	import sounds.SoundId;
	import sounds.SoundManager;
	
	import states.PlayState;
	
	public class Player extends SynchronizedSprite
	{
		[Embed(source="/../media/crown.png")] protected static var Crown:Class;
		private static var crown:BitmapData = new Crown().bitmapData;
		[Embed(source="/../media/crown_silver.png")] protected static var CrownSilver:Class;
		private static var crown_silver:BitmapData = new CrownSilver().bitmapData;
		//[Embed(source="/../media/aura.png")] protected static var Aura:Class;
		//private static var auraBitmapData:BitmapData = new Aura().bitmapData;
		[Embed(source="/../media/auras_staff.png")] protected static var StaffAura:Class;
		private static var staffAuraBMD:BitmapData = new StaffAura().bitmapData;
		[Embed(source="/../media/fireaura.png")] protected static var FireAura:Class;
		private static var fireAura:BitmapData = new FireAura().bitmapData;
		[Embed(source="/../media/leviation_effect.png")] protected static var LevitationEffect:Class;
		private static var levitationAnimationBitmapData:BitmapData = new LevitationEffect().bitmapData;
		[Embed(source = "/../media/effect_icons.png")] protected static var EffectIcons:Class;
		private static var effectIconsBitmapData:BitmapData = new EffectIcons().bitmapData;
		[Embed(source="/../media/animations/sparkles.png")] protected static var SparkleAura:Class;
		private static var sparkleAura:BitmapData = new SparkleAura().bitmapData;
		
		private static var goldmemberaura:BitmapData = AnimationManager.animGoldMemberAura;
		
		private static var fireAnimation:BlSprite = new BlSprite(fireAura, 0, 0, 26, 26, 6);
		private static var levitationAnimation:BlSprite = new BlSprite(levitationAnimationBitmapData, 0, 0, 26, 26, 32);
		private static var effectIcons:BlSprite = new BlSprite(effectIconsBitmapData, 0, 0, 16, 16, effectIconsBitmapData.width/16);
		private static var sparkleAnimation:BlSprite = new BlSprite(sparkleAura, 0, 0, 64, 64, 7);
		
		private var _id:int;
		private var _connectedUserId:String;
		
		protected var world:World;
		public var isme:Boolean;
		
		protected var state:PlayState
		public var chat:Chat
		
		private var deadAnim:BitmapData;
		public var isDead:Boolean = false;
		private var deathsend:Boolean = false;

		// To make sure we only send a world portal / reset message once
		public var resetSend:Boolean;
		
		public var name:String;
		private var textcolor:uint;
		
		private var morx:int = 0;
		private var mory:int = 0;
				
		public var overlapa:int = -1;
		public var overlapb:int = -1;
		public var overlapc:int = -1;
		public var overlapd:int = -1;
		
		public var hascrown:Boolean = false;
		public var collideWithCrownDoorGate:Boolean = false;
		public var collideWithSilverCrownDoorGate:Boolean = false;
		public var hascrownsilver:Boolean = false;
		
		public var render:Boolean = true;
		
		//arrays of coin coordinates
		public var gx:Array = new Array();
		public var gy:Array = new Array();
		public var bx:Array = new Array();
		public var by:Array = new Array();
		
		public var worldSpawn:int = 0;
		
		public var touchCooldown:int = 100;
		
		public var curseTimeStart:Number = 0;
		public var curseDuration:Number = 0;
		public var zombieTimeStart:Number = 0;
		public var zombieDuration:Number = 0;
		public var fireTimeStart:Number = 0;
		public var fireDuration:Number = 0;
		public var poisonTimeStart:Number = 0;
		public var poisonDuration:Number = 0;
		
		//if TRUE player will send "m" message no matter what.
		//use it when you need to tp somebody and update their position.
		public var enforceMovement:Boolean = false;
		
		public override function get x():Number
		{
			return isNaN(_posX.value) ? 0 : _posX.value;
		}
		
		public override function set x(value:Number):void
		{
			_posX.value = value;
		}
		
		public override function get y():Number
		{
			return isNaN(_posY.value) ? 0 : _posY.value;
		}
		
		public override function set y(value:Number):void
		{
			_posY.value = value;
		}
		
		private var _posX:SecureNumber = new SecureNumber("PosX");
		private var _posY:SecureNumber = new SecureNumber("PosY");
		
		private var _coins:SecureInt = new SecureInt("Coins");
		public function set coins(value:int):void {
			_coins.value = value; 
		}
		public function get coins():int {
			return _coins.value;
		}
		
		private var _bcoins:SecureInt = new SecureInt("BlueCoins");
		public function set bcoins(value:int):void {
			_bcoins.value = value;
		}
		public function get bcoins():int {
			return _bcoins.value;
		}
		
		private var _inGodMode:SecureBoolean = new SecureBoolean("GodMode");
		public function set isInGodMode(value:Boolean):void {
			_inGodMode.value = value;
		}
		public function get isInGodMode():Boolean {
			return _inGodMode.value;
		}
		
		private var _inModMode:SecureBoolean = new SecureBoolean("ModMode");
		public function set isInModMode(value:Boolean):void {
			_inModMode.value = value;
		}
		public function get isInModMode():Boolean {
			return _inModMode.value;
		}
		
		public var isgoldmember:Boolean = false;
		
		public var current:int = 0;
		public var current_bg:int = 0;
		public var current_below:int = 0;
		public var checkpoint_x:int = -1;
		public var checkpoint_y:int = -1;
			
		public var switches:Object = {};
		
		private var last_respawn:Number = 0;
		
		private var rect2:Rectangle = new Rectangle(0, 0, 26, 26);
		
		private var itemAura:ItemAura;
		
		private var _aura:int = 0;
		public function set aura(id:int):void {
			_aura = id;
			itemAura = ItemManager.getAuraByIdAndColor(aura, auraColor);
		}
		public function get aura():int {
			return _aura;
		}

		private var _auraColor:int = 0;
		public function set auraColor(id:int):void {
			_auraColor = id;
			itemAura = ItemManager.getAuraByIdAndColor(aura, auraColor);
		}
		public function get auraColor():int {
			return _auraColor;
		}
		
		private var _isFlaunting:Boolean = false;
		
		private var tilequeue:Array;
		
		private var _deaths:SecureInt = new SecureInt("Deaths");
		public function set deaths(value:int):void {
			_deaths.value = value;
		}
		public function get deaths():int {
			return _deaths.value;
		}
		
		public var team:int = 0;
		
		public var muted:Boolean;
		public var canEdit:Boolean;
		public var badge:String;
		public var isCrewMember:Boolean;
		
		protected var _canToggleGod:Boolean;
		
		public var currentNpc:Npc = null;
		
		public function Player(cave:World, name:String, isme:Boolean = false, state:PlayState = null)
		{
			
			super(ItemManager.smileysBMD);
			
			this.state = state;
			this.world = cave
			this.hitmap = cave
			
			this.tilequeue = [];
				
			this.x = 16;
			this.y = 16;
				
			this.isme = isme
			this.name = name;
			this.chat = new Chat(name.indexOf(" ") == -1 ? name : "")
				
			size = 16;
			width = 16;
			height = 16;
			
			itemAura = ItemManager.getAuraByIdAndColor(0, 0);
			
			modrect = new Rectangle(0, 0, 64, 64);
			modmodeRow = -1;
		}
		
		protected var pastx:int = 0;
		protected var pasty:int = 0;
		private var queue:Vector.<int> = new Vector.<int>(Config.physics_queue_length);
		private var lastJump:Number = -new Date().time;
		private var changed:Boolean = false;
		
		private var tx:int = -1;
		private var ty:int = -1;
		
		protected var leftdown:int = 0;
		protected var rightdown:int = 0;
		protected var updown:int = 0;
		protected var downdown:int = 0;
		public var spacedown:Boolean = false;
		public var spacejustdown:Boolean = false;
			
		public var horizontal:int = 0;
		public var vertical:int = 0;
		
		public var oh:int = 0;
		public var ov:int = 0;
		public var ox:Number = 0;
		public var oy:Number = 0;
		public var ospacedown:Boolean = false;
		public var ospaceJP:Boolean = false;
		
		public var worldGravityMultiplier:Number = 1;
		
		private var lastPortal:Point = new Point();
			
		private var lastOverlap:int = 0;
		private var that:SynchronizedObject = this as SynchronizedObject;
		private var donex:Boolean = false;
		private var doney:Boolean = false;
		private var animoffset:Number = 0;
		private var modoffset:Number = 0;
		private var modrect:Rectangle;
		private var auraAnimOffset:Number = 0;
		private var deadoffset:Number = 0;
		
		public var low_gravity:Boolean = false;
		
		// Effects
		private var _isInvulnerable:SecureBoolean = new SecureBoolean("Protection");
		private var _hasLevitation:SecureBoolean = new SecureBoolean("Levitation");
		private var _jumpBoost:SecureInt = new SecureInt("JumpBoost");
		private var _speedBoost:SecureInt = new SecureInt("SpeedBoost");
		private var _flipGravity:SecureInt = new SecureInt("FlipGravity");
		private var _zombie:SecureBoolean = new SecureBoolean("Zombie");
		private var _cursed:SecureBoolean = new SecureBoolean("Curse");
		private var _poison:SecureBoolean = new SecureBoolean("Poison");
		
		private var _isThrusting:SecureBoolean = new SecureBoolean("IsThrusting");
		private var _maxThrust:Number = .2;
		private var _thrustBurnOff:Number = .01;
		private var _currentThrust:Number = 0;
		
		public var isOnFire:Boolean = false;
		
		public function get id():int {
			return _id;
		}
		
		public function set id(value:int):void {
			_id = value;
		}
		
		public function get connectedUserId():String {
			return _connectedUserId;
		}
		
		public function set connectedUserId(value:String):void {
			_connectedUserId = value;
		}
		
		public function get gravityMultiplier():Number {
			var gm:Number = 1;
			if (low_gravity) gm *= 0.15;
			/*else*/ gm *= worldGravityMultiplier;
			return gm;
		}

		public function get jumpMultiplier():Number {
			var jm:Number = 1;
			if(jumpBoost == 1) jm *= 1.3;
			if(jumpBoost == 2) jm *= .75;
			if(zombie) jm *= .75;
			if (slippery > 0) jm *= .88;
			return jm;
		}

		public function get speedMultiplier():Number {
			var sm:Number = 1;
			if(speedBoost == 1) sm *= 1.5;
			if(speedBoost == 2) sm *= .6;
			if (zombie) sm *= .6;
			return sm;
		}

		public function get dragMud():Number {
			return _mud_drag;
		}
		
		private var slippery:Number = 0;
		
		public var multiJumpEffectDisplay:MultiJumpCounter = null;
		public var jumpCount:int = 0;
		public var maxJumps:int = 1;
		
		public override function tick():void{			
			//This must happen for all players!
			
			animoffset += .2; //animations
			if(isInModMode && !isInGodMode){
				modoffset += .2;
				if (modoffset >= 12) 
					modoffset = 6;
			}else modoffset = 0;
			
			auraAnimOffset += itemAura.speed;
			if (auraAnimOffset >= itemAura.frames) auraAnimOffset = 0;
			
			if(isDead) deadoffset += .3;				
			else deadoffset = 0;			
			
			if (!isDead && (cursed || zombie || isOnFire || poison)) {
				var curTime:Number = new Date().time;
				if (cursed && curseDuration && curTime - curseTimeStart > curseDuration * 1000) killPlayer();
				if (zombie && zombieDuration && curTime - zombieTimeStart > zombieDuration * 1000) killPlayer();
				if (isOnFire && fireDuration && curTime - fireTimeStart > fireDuration * 1000) killPlayer();
				if (poison && poisonDuration && curTime - poisonTimeStart > poisonDuration * 1000) killPlayer();
			}
			
			var cx:int = (this.x+8)>>4;
			var cy:int = (this.y+8)>>4;
			
			var delayed:int = queue.shift();
			current = world.getTile(0,cx,cy);
			if (ItemId.isHalfBlock(current)) {
				
				var rot:int = world.lookup.getInt(cx, cy);
				if (!ItemId.isBlockRotateable(current) && ItemId.isNonRotatableHalfBlock(current))
					rot = 1;
				if (rot == 1) cy -=1;
				if (rot == 0) cx -=1;
				current = world.getTile(0,cx,cy);
			}
			
			if (tx != -1) UpdateTeamDoors(tx, ty);
			
			function getCurrentBelow():int {
				var x:int = 0, y:int = 0;
				switch(current) {
					case 1: case 411: x -= 1; break;
					case 2: case 412: y -= 1; break;
					case 3: case 411: x += 1; break;
					case 4: case 412: y += 1; break;
					default: switch(flipGravity) {
						case 0: y += 1; break;
						case 1: x -= 1; break;
						case 2: y -= 1; break;
						default: x += 1; break;
					}
				}
				return world.getTile(0, cx + x, cy + y);
			}
			// Getting the block the player is standing on. Also gets the gravity arrows
			current_below = getCurrentBelow();
			
			queue.push(current);
			
			if(current == 4 || current == 414 || ItemId.isClimbable(current)){
				delayed = queue.shift();
				queue.push(current);
			}
			
			var queue_length:int = this.tilequeue.length;
			while(queue_length--) this.tilequeue.shift()(); 
			
			getPlayerInput();
			
			if (isDead) {
				spacejustdown = false;
				spacedown = false;
				horizontal = 0;
				vertical = 0;
			}
			
			var rotateGravitymo:Boolean = true;
			var rotateGravitymor:Boolean = true;
			var isgodmod:Boolean = isFlying;
			this.morx = 0;
			this.mory = 0;
			this.mox = 0;
			this.moy = 0;
			
			if(!isgodmod) {
				if (ItemId.isClimbable(current)) {
					this.morx = 0;
					this.mory = 0;
				} else {
					//Process gravity
					switch(current){
						case 1:
						case 411:{
							this.morx = -_gravity;
							this.mory = 0;
							rotateGravitymor = false;
							break;
						}
						case 2:
						case 412:{
							this.morx = 0;
							this.mory = -_gravity;
							rotateGravitymor = false;
							break;
						}
						case 3:
						case 413:{
							this.morx = _gravity;
							this.mory = 0;
							rotateGravitymor = false;
							break;
						}
						case 1518:
						case 1519:{
							this.morx = 0;
							this.mory = _gravity;
							rotateGravitymor = false;
							break;
						}
						case ItemId.SPEED_LEFT:
						case ItemId.SPEED_RIGHT:
						case ItemId.SPEED_UP:
						case ItemId.SPEED_DOWN:
						case 4:
						case 414:{
							this.morx = 0;
							this.mory = 0;
							break;
						}
						case ItemId.WATER:{
							this.morx = 0;
							this.mory = _water_buoyancy;
							break;
						}
						case ItemId.MUD:{
							this.morx = 0;
							this.mory = _mud_buoyancy;
							break;
						}
						case ItemId.LAVA:{
							this.morx = 0;
							this.mory = _lava_buoyancy;
							break;
						}
						case ItemId.TOXIC_WASTE: {
							this.morx = 0;
							this.mory = _toxic_buoyancy;
							if(!isDead && !isInvulnerable){
								killPlayer();
							}
							break;
						}
						case ItemId.FIRE:
						case ItemId.SPIKE:
						case ItemId.SPIKE_CENTER:
						case ItemId.SPIKE_SILVER:
						case ItemId.SPIKE_SILVER_CENTER:
						case ItemId.SPIKE_BLACK:
						case ItemId.SPIKE_BLACK_CENTER:
						case ItemId.SPIKE_RED:
						case ItemId.SPIKE_RED_CENTER:
						case ItemId.SPIKE_GOLD:
						case ItemId.SPIKE_GOLD_CENTER:
						case ItemId.SPIKE_GREEN:
						case ItemId.SPIKE_GREEN_CENTER:
						case ItemId.SPIKE_BLUE:
						case ItemId.SPIKE_BLUE_CENTER: {
							this.morx = 0;
							this.mory = _gravity;
							if(!isDead && !isInvulnerable){
								killPlayer();
							}
							break;
						}
						default:{
								this.morx = 0;
								this.mory = _gravity;
								break;
							break;
						}
					}
				}
			   
				if (ItemId.isClimbable(delayed)) {
					this.mox = 0;
					this.moy = 0;
				} else {
					switch(delayed){
						case 1:
						case 411:{
							this.mox =-_gravity;
							this.moy = 0;
							rotateGravitymo = false;
							break;
						}
						case 2:
						case 412:{
							this.mox = 0;
							this.moy = -_gravity;
							rotateGravitymo = false;
							break;
						}
						case 3:
						case 413:{
							this.mox = _gravity;
							this.moy = 0;
							rotateGravitymo = false;
							break;
						}
						case 1518:
						case 1519:{
							this.mox = 0;
							this.moy = _gravity;
							rotateGravitymo = false;
							break;
						}
						case ItemId.SPEED_LEFT:
						case ItemId.SPEED_RIGHT:
						case ItemId.SPEED_UP:
						case ItemId.SPEED_DOWN:
						case 4:
						case 414:{
							this.mox = 0;
							this.moy = 0;
							break;
						}
						case ItemId.WATER:{
							this.mox = 0;
							this.moy = _water_buoyancy;
							break;
						}
						case ItemId.MUD:{
							this.mox = 0;
							this.moy = _mud_buoyancy;
							break;
						}
						case ItemId.LAVA:{
							this.mox = 0;
							this.moy = _lava_buoyancy;
							break;
						}
						case ItemId.TOXIC_WASTE:{
							this.mox = 0;
							this.moy = _toxic_buoyancy;
							break;
						}
						default:{
							this.mox = 0;
							this.moy = _gravity;
							break;
						}
					}
				}			
			}
			   
			var temp:Number;
			switch(flipGravity)
			{
				case 1:
					if (rotateGravitymo) {
						temp = mox;
						mox = -moy;
						moy = temp;
					}
					if(rotateGravitymor) {
						temp = morx;
						morx = -mory;
						mory = temp;
					}
				break;
				
				case 2:
					if(rotateGravitymo) {
						mox = -mox;
						moy = -moy;
					}
					if(rotateGravitymor) {
						morx = -morx;
						mory = -mory;
					}
				break;
				
				case 3:
					if(rotateGravitymo) {
						temp = mox;
						mox = moy;
						moy = -temp;
					}
					if(rotateGravitymor) {
						temp = morx;
						morx = mory;
						mory = -temp;
					}
				break;
			
				case 4:
					if(rotateGravitymo) {
						mox = 0;
						moy = 0;
					}
					if(rotateGravitymor) {
						morx = 0;
						mory = 0;
					}
				break;
			}
			 
			if(ItemId.isLiquid(delayed)) {
				mx = this.horizontal;
				my = this.vertical;
			}
			else if(this.moy) {
				mx = this.horizontal;
				my = 0;
			}
			else if(this.mox) {
				mx = 0;
				my = this.vertical;
			}
			else {
				mx = this.horizontal;
				my = this.vertical;
			}
				
			mx *= speedMultiplier;
			my *= speedMultiplier;
			mox *= gravityMultiplier;
			moy *= gravityMultiplier;
			
			this.modifierX = this.mox + mx;
			this.modifierY = this.moy + my;
			
			if (ItemId.isSlippery(current_below) && !ItemId.isClimbable(current) && current != 4 && current != 414) {
				slippery = 2;
			} else if (ItemId.isSolid(current_below)) {
				slippery = 0;
			}else if (slippery > 0) {
				slippery -= .2;
			}

			if( _speedX || _modifierX ){
				_speedX += _modifierX;
				if(((( mx == 0 && moy != 0 ) || (_speedX < 0 && mx > 0) || (_speedX > 0 && mx <0)) && (slippery <= 0 || isgodmod)) || ( ItemId.isClimbable(current) && !isgodmod)){
					_speedX *= Config.physics_base_drag;
					_speedX *= _no_modifier_dragX;
				}else if(current == ItemId.WATER  && !isgodmod){
					_speedX *= Config.physics_base_drag;
					_speedX *= _water_drag;
				}else if(current == ItemId.MUD  && !isgodmod){
					_speedX *= Config.physics_base_drag;
					_speedX *= dragMud;
				}else if(current == ItemId.LAVA  && !isgodmod){
					_speedX *= Config.physics_base_drag;
					_speedX *= _lava_drag;
				}else if(current == ItemId.TOXIC_WASTE && !isgodmod){
					_speedX *= Config.physics_base_drag;
					_speedX *= _toxic_drag;
				}
				else if (slippery > 0 && !isgodmod)
				{
					if (mx != 0 && !((_speedX < 0 && mx > 0) || (_speedX > 0 && mx <0)))
						_speedX *= Config.physics_base_drag;
					else
						_speedX *= Config.physics_ice_no_mod_drag;
					if ((_speedX < 0 && mx > 0) || (_speedX > 0 && mx <0))
					{
						_speedX *= Config.physics_ice_drag;
					}
				} else {
					_speedX *= Config.physics_base_drag;
				}
				
				if(_speedX > 16){
					_speedX = 16;
				}else if(_speedX < -16){
					_speedX = -16
				}else if(_speedX < 0.0001 && _speedX > -0.0001){
					_speedX = 0;
				}
			}
			
			if( _speedY || _modifierY ){
				_speedY += _modifierY;
				if(((( my == 0 && mox != 0 ) || (_speedY < 0 && my > 0) || (_speedY > 0 && my <0)) && (slippery <= 0 || isgodmod)) || ( ItemId.isClimbable(current) && !isgodmod)){
					_speedY *= Config.physics_base_drag;
					_speedY *= _no_modifier_dragY;
				}else if(current == ItemId.WATER  && !isgodmod){
					_speedY *= Config.physics_base_drag;
					_speedY *= _water_drag;
				}else if(current == ItemId.MUD  && !isgodmod){
					_speedY *= Config.physics_base_drag;
					_speedY *= dragMud;
				}else if(current == ItemId.LAVA  && !isgodmod){
					_speedY *= Config.physics_base_drag;
					_speedY *= _lava_drag;
				}else if(current == ItemId.TOXIC_WASTE && !isgodmod){
					_speedY *= Config.physics_base_drag;
					_speedY *= _toxic_drag;
				}
				else if (slippery > 0 && !isgodmod)
				{
					if (my != 0 && !((_speedY < 0 && my > 0) || (_speedY > 0 && my <0)))
						_speedY *= Config.physics_base_drag;
					else
						_speedY *= Config.physics_ice_no_mod_drag;
					if ((_speedY < 0 && my > 0) || (_speedY > 0 && my <0))
					{
						_speedY *= Config.physics_ice_drag;
					}
				} else {
					_speedY *= Config.physics_base_drag;
				}

				if(_speedY > 16){
					_speedY = 16;
				}else if(_speedY < -16){
					_speedY = -16
				}else if(_speedY < 0.0001 && _speedY > -0.0001){
					_speedY = 0;
				}
			}
			
			if(!isgodmod){
				switch(current){
					case ItemId.SPEED_LEFT:{
						_speedX = -_boost;
						break;
					}
					case ItemId.SPEED_RIGHT:{
						_speedX = _boost;
						break;
					}
					case ItemId.SPEED_UP:{
						_speedY = -_boost;
						break;
					}
					case ItemId.SPEED_DOWN:{
						_speedY = _boost;
						break;
					}
				}
				
				if (isDead) {
					_speedX = 0;
					_speedY = 0;
				}
			}
			
			var reminderX:Number = x%1;
			var currentSX:Number = _speedX
			
			var reminderY:Number = y%1;
			var currentSY:Number = _speedY

			
			donex = false;
			doney = false;
			
			var grounded:Boolean = false;
			
			//todo flipgravity
			function stepx():void{
				if(currentSX > 0){
					if( currentSX + reminderX >= 1){
						x += (1-reminderX)
						x>>=0
						currentSX -= (1-(reminderX)); 
						reminderX = 0;
					} else {
						x += currentSX;
						currentSX = 0;
					}
				}
				else if(currentSX < 0){
					if(reminderX + currentSX < 0 && (reminderX != 0 || ItemId.isBoost(current))){
						currentSX += reminderX;
						x -= reminderX
						x>>=0
						reminderX = 1;
					}else{
						x += currentSX;
						currentSX = 0;
					}
				}
				if(hitmap != null){
					if( hitmap.overlaps(that)){
						x = ox;
						if (_speedX > 0 && (morx > 0))
							grounded = true;
						if (_speedX < 0 && (morx < 0))
							grounded = true;
							
						_speedX = 0;
						currentSX = osx;
						donex = true;
					}
				}
			}
			
			function stepy():void{
				if(currentSY > 0){
					if( currentSY + reminderY >= 1 ){
						y  += 1-reminderY
						y>>=0
						currentSY -= (1-reminderY); 
						reminderY = 0;
					} else {
						y += currentSY;
						currentSY = 0;
					}
				}else if(currentSY < 0){
					if( reminderY + currentSY < 0 && (reminderY != 0 || ItemId.isBoost(current))){
						y -= reminderY
						y>>=0
						currentSY += reminderY;
						reminderY = 1;
					}else{
						y += currentSY;  
						currentSY = 0;
					}
				}
				if(hitmap != null){
					if( hitmap.overlaps(that)){
						y = oy;
						if (_speedY > 0 && (mory > 0))
							grounded = true;
						if (_speedY < 0 && (mory < 0))
							grounded = true;
							
						_speedY = 0;
						currentSY = osy;
						doney = true;
					}
				}
			}
			
			var osx:Number;
			var osy:Number;
			
			while((currentSX != 0 && !donex ) || (currentSY != 0 && !doney)){
				processPortals()
				
				ox = x;
				oy = y;
				
				osx = currentSX;
				osy = currentSY;
				
				stepx();
				stepy();
			}
			
			if (!isDead) {
				var mod:int = 1
				var injump:Boolean = false;
				if (spacejustdown){
					lastJump = -new Date().time;
					injump = true;
					mod = -1
				}
				
				if(spacedown || !isme && !isControlled && hasLevitation){
					if ( hasLevitation ) {
						isThrusting = true;
						applyThrust();
					}
					else {
						if(lastJump < 0){
							if(new Date().time + lastJump > 750){
								injump = true;
							}
						}else{
							if(new Date().time - lastJump > 150){
								injump = true;
							}
						}
					}
				}
				else {
					isThrusting = false;
				}
				if((this.speedX == 0 && morx && mox || this.speedY == 0 && mory && moy) && grounded || current == ItemId.EFFECT_MULTIJUMP) {
					// On ground so reset jumps to 0
					jumpCount = 0;
				}
				
				if(jumpCount == 0 && !grounded) jumpCount = 1; // Not on ground so first 'jump' removed
					
				if(injump && !this.hasLevitation) {
					if(jumpCount < maxJumps && morx && mox) { // Jump in x direction
						if (maxJumps < 1000) { // Not infinite jumps
							jumpCount += 1;
						}
						this.speedX = -morx * Config.physics_jump_height * jumpMultiplier;
						changed = true;
						lastJump = new Date().time * mod;
					}
					if(jumpCount < maxJumps && mory && moy) { // Jump in y direction
						if (maxJumps < 1000) { // Not infinite jumps
							jumpCount += 1;
						}
						this.speedY = -mory * Config.physics_jump_height * jumpMultiplier;
						changed = true;
						lastJump = new Date().time * mod;
					}
				}
				
				touchBlock(cx, cy, isgodmod);
				sendMovement(cx, cy);
				changed = false;
			}
			
			//////////////// messing about with jetpack stuff ////////////////
			if (hasLevitation) {
				updateThrust();
			}
			//////////////////////////////////////////////////////////////////
			
			//Auto align to grid. (do not autocorrect in liquid)
			var imx:int = _speedX<<8;
			var imy:int = _speedY<<8;
			
			moving = false
			
			if(imx != 0 || (ItemId.isLiquid(current) && !isgodmod)){
				moving = true;
			}else if(_modifierX < 0.1 && _modifierX > -0.1){ 
				var tx:Number = x % 16
				if(tx < 2){
					if(tx < .2){
						x >>=0;
					}else x-= tx/15
				}else if(tx > 14){
					if(tx > 15.8){
						x >>=0;
						x ++
					}else x+= (tx-14)/15;
				}
				
			}
			
			if(imy != 0 || (ItemId.isLiquid(current) && !isgodmod)){
				moving = true;
			}else if(_modifierY < 0.1 && _modifierY > -0.1 ){
				var ty:Number = y % 16
				
				if(ty < 2){
					if(ty < .2){
						y >>=0;
					}else y-= ty/15
				}else if(ty > 14){
					
					if(ty > 15.8){
						y >>=0;
						y ++
					}else y+= (ty-14)/15;
				}
			};
			
			updateStuff();
			
			function randomRange(minNum:Number, maxNum:Number):Number
			{
				return (Math.floor(Math.random() * (maxNum - minNum + 1)) + minNum);
			}
			
			function processPortals():void{
//				cx = (x+8)>>4;
//				cy = (y+8)>>4;
//				
				current = world.getTile(0, cx, cy);
				
				if (!isgodmod && current == ItemId.WORLD_PORTAL) {
					if (!isme) {
						resetSend = true;
						resetPlayer(false, false, wp.target);
					} else if (isme && KeyBinding.risky.isDown() && !resetSend) {
						var wp:WorldPortal = world.lookup.getWorldPortal(cx, cy);
						if (wp.id.length > 0) {
							resetSend = true;
							//if (wp.id != connection.roomId) {
								//if (connection.connected) {
									//connection.disconnect();
								//}
								//var d:NavigationEvent = new NavigationEvent(NavigationEvent.JOIN_WORLD,true,false);
								//d.world_id = wp.id;
								//d.joindata.spawnid = wp.target;
								//d.joindata.lastowner = Global.ownerID;
								//d.joindata.lastcrew = Global.currentLevelCrew;
								//Global.base.dispatchEvent(d);
							//} else {
								//connection.send("reset", cx, cy);
							//}
							var id:int = parseInt(wp.id);
							if (Global.isValidWorldIndex(id)) {
								Global.base.campaigns.joinWorld(id, wp.target);
							}
							else resetPlayer(false, false, wp.target);
						}
					}
				}
				
				if (isgodmod || (current != ItemId.PORTAL && current != ItemId.PORTAL_INVISIBLE) || (world.lookup.getPortal(cx, cy).target == world.lookup.getPortal(cx, cy).id)) {
					lastPortal = null;
					return;
				}
				
				if (lastPortal != null)
					return;
					
				lastPortal =  new Point(cx<<4, cy<<4)
				var portals:Vector.<Point> = world.lookup.getPortals(world.lookup.getPortal(cx,cy).target);
				
				if (portals.length <= 0) return;
				var cp:Point = portals[randomRange(0, portals.length - 1)];
				
				var oldRotationg:int = world.lookup.getPortal(lastPortal.x>>4, lastPortal.y>>4).rotation
				var newRotation:int = world.lookup.getPortal(cp.x>>4, cp.y>>4).rotation
				
				if (oldRotationg < newRotation) oldRotationg += 4;	
				
				/*
				 * 0 - down 
				 * 1 - left
				 * 2 - up
				 * 3 - right
				*/
				
				var osx:Number = speedX
				var osy:Number = speedY
				var omx:Number = modifierX
				var omy:Number = modifierY
				
				var dir:int = oldRotationg-newRotation
				var magic:Number = 1.42
				
				switch(dir){
					case 1:{ // 90 degrees
						speedX = osy * magic
						speedY = -osx * magic
						
						modifierX = omy*magic
						modifierY = -omx*magic
						
						reminderY = -reminderX
						currentSY = -currentSX
						break;
					}
					case 2:{ // 180 degrees
						speedX = -osx * magic
						speedY = -osy * magic
						
						modifierX = -omx*magic
						modifierY = -omy*magic
						
						reminderY = -reminderY
						currentSY = -currentSY
						reminderX = -reminderX
						currentSX = -currentSX
						break;
					}
					case 3:{ // 270 degrees
						speedX = -osy * magic
						speedY = osx * magic
						
						modifierX = -omy*magic
						modifierY = omx*magic
						
						reminderX = -reminderY
						currentSX = -currentSY
						break;
					}
				}
				
				if (state && state.target == that) state.offset( x-cp.x,y-cp.y )
				
				if (Global.base.settings.particles) {
					if (current == ItemId.PORTAL && isme) { // In
						for (var k:int = 0; k < 25; k++) {
							var speedFactor:Number = (Math.random() + 1) / 2;
							world.addParticle(new Particle(world, (Math.random()*100 < 50 ? 5 : 4), cp.x+6, cp.y+6, speedFactor, speedFactor, speedFactor/70, speedFactor/70, Math.random()*360, Math.random()*90, false));
						}
					}
				}
				
				x = cp.x
				y = cp.y
				
				lastPortal = cp;
			}
		}
		
		//New more advanced update ticket
		
		//Update now does nothing
		public override function update():void{}		
		
		public function drawChat(target:BitmapData, ox:Number, oy:Number, visible:Boolean):void {
			if (!isme && !render) return;
					
			if (Global.showUI && (Global.showChatAndNames || Global.chatIsVisible))
				chat.drawChat(target, ox+x, oy+y, visible, Global.base.settings.hideUsernames, Global.base.settings.hideBubbles , team)
		}
		
		public function enterChat():void{
			chat.enterFrame()
		}
	
		public function say(text:String):void{
			chat.say(text);
		}
		
		public function killPlayer():void {
			if (!isFlying && !isDead) {
				isDead = true;
				deadAnim = AnimationManager.animRandomDeath();
			}
			else if (!isme && isFlying) {
				cursed = zombie = isOnFire = poison = false;
			}
		}
		
		public function placeAtSpawn(checkpoint:Boolean = false):void {
			var nx:int = 1;
			var ny:int = 1;
			if(checkpoint && checkpoint_x != -1) {
				nx = checkpoint_x;
				ny = checkpoint_y;
			} else if (world.spawnPoints.length > 0) {
				if (!world.spawnPoints[worldSpawn]) world.spawnPoints[worldSpawn] = new Array();
				var spawnID:int = world.spawnPoints[worldSpawn].length > 0 ? worldSpawn : 0;
				
				if (!world.nextSpawnPos[spawnID] || 
					world.nextSpawnPos[spawnID] >= world.spawnPoints[spawnID].length)
					world.nextSpawnPos[spawnID] = 0;
					
				if (world.spawnPoints[spawnID].length > 0) {
					nx = world.spawnPoints[spawnID][world.nextSpawnPos[spawnID]][0];
					ny = world.spawnPoints[spawnID][world.nextSpawnPos[spawnID]][1];
					
					world.nextSpawnPos[spawnID]++;
				}
			}
			nx *= 16;
			ny *= 16;
			if (isme) state.offset(x - nx, y - ny);
			x = nx;
			y = ny;
		}
		
		public function respawn():void
		{
			_modifierX = 0;
			_modifierY = 0;
			modifierX = 0;
			modifierY = 0;
			_speedX = 0;
			_speedY = 0;
			speedX = 0;
			speedY = 0;
			isDead = false;
			deathsend = false;
			isOnFire = false;
			last_respawn = new Date().time;
			resetSend = false;
			tilequeue = [];
			
			placeAtSpawn(true);
			
			setEffect(Config.effectCurse, false);
			setEffect(Config.effectZombie, false);
			setEffect(Config.effectFire, false);
			setEffect(Config.effectPoison, false);
		}
		
		public function resetPlayer(load:Boolean = false, clear:Boolean = false, worldSpawnID:int = -1):void {
			if (isFlying && !load && !clear) return;
			if (worldSpawnID > -1)
				worldSpawn = worldSpawnID;
			hascrown = false;
			hascrownsilver = false;
			Global.playState.checkCrown(false);
			Global.playState.checkSilverCrown(false);
			collideWithCrownDoorGate = false;
			collideWithSilverCrownDoorGate = false;
			deaths = 0;
			resetCoins();
			resetDeath();
			resetEffects();
			resetCheckpoint();
			switches = {};
			team = 0;
			if (worldSpawnID == -1) {
				Global.playState.player.ticks = 0;
				Global.base.ui2instance.validRun = true;
			}
			Global.playState.player.completed = false;
			Global.playState.getWorld().resetCoins();
			gx = new Array();
			gy = new Array();
			bx = new Array();
			by = new Array();
			Global.playState.getWorld().lookup.resetSecrets();
			Global.base.ui2instance.playerMapEnabled = false;
			Global.base.ui2instance.configureInterface();
			if(!isFlying && !clear)
				respawn();
		}
		
		public function resetDeath():void {
			isDead = false;
			deathsend = false;
		}
		
		public function resetCoins():void{
			coins = 0;
			bcoins = 0;
		}
		
		public function resetCheckpoint():void{
			checkpoint_x = -1;
			checkpoint_y = -1;
		}
		
		private var starty:Number = 0;
		private var startx:Number = 0;
		private var endy:Number = 0;
		private var endx:Number = 0;
		
		public override function draw(target:BitmapData, ox:int, oy:int):void{
			if (!isme && !render) return;
				
			if (isFlying) return;
			if (!state) return; // Don't render anything if there's nothing to render.
			
			starty = -state.y - 90;
			startx = -state.x - 90;
			endy = starty + Bl.height + 180;
			endx = startx + Bl.width + 180;
			
			
			if (isDead && deadoffset > 16) {
				//if (isme) { //on the last frame of the death animation send "death".
					respawn();
					deaths ++;
					//connection.send("death");
				//}
				return;
			}
			//smiley is not currently on the screen and it's not me
			if (!(this.x > startx && this.y > starty && this.x < endx && this.y < endy) && !isme) return;
			
			if (isDead) {
				//if (deadoffset > 16) {
					////if (isme) { //on the last frame of the death animation send "death".
						//respawn();
						//deaths ++;
						////connection.send("death");
					////}
					//return;
				//}
				if (deadoffset < 2) {
					drawFace(target, new Point(x + ox - 5, y + oy - 5), zombie);
				}
				var dx:int = deadoffset;
				target.copyPixels(deadAnim, new Rectangle(dx*64,0,64,64), new Point(x+ox-24,y+oy-24));		
				return;
			}
			
			var playerX:Number = x + ox - 5;
			var playerY:Number = y + oy - 5;
			
			var playerCrown:BitmapData = hascrown ? crown : hascrownsilver ? crown_silver : null;	
			
			var deg:int = flipGravity * 90;
			if (deg >= 360 || deg < 0) deg = 0;
			
			//draw smiley bitmap
			drawFace(target, new Point(playerX, playerY), zombie, deg);
			if (playerCrown != null)
				target.copyPixels(rotateBitmapData(playerCrown, deg), playerCrown.rect, new Point(
				playerX + ((flipGravity % 2 == 0) ? 0 : (flipGravity == 1) ? 1 : -1),
				playerY + ((flipGravity % 2 == 1) ? 0 : (flipGravity == 2) ? 1 : -1)));
			
			
			// Play fire aura animation
			if (isOnFire) {
				if ((animoffset >> 0) % 3 == 0) { 
					if (fireAnimation.frame < fireAnimation.totalFrames - 1) {
						fireAnimation.frame++;
					} else {
						fireAnimation.frame = 0;
					}
				}
				
				fireAnimation.RotateDeg = deg;
				fireAnimation.draw(target, playerX + ((flipGravity >= 1 && flipGravity <= 3) ? -1 : 1), playerY + ((flipGravity == 1) ? 1 : flipGravity == 3 ? -1 : 0));
			}
	
			if (hasLevitation && isThrusting) {
				playLevitationAnimation(target, ox, oy);
			}
			
			drawTagged(target, ox, oy);
			
		}
		
		private function drawFace(target:BitmapData, point:Point, zombie:Boolean, deg:int = 0):void {
			var target2:BitmapData = deg == 0 ? target : new BitmapData(26, 26, true, 0);
			var point2:Point = deg == 0 ? point : new Point(0, 0);
			
			if (zombie) {
				target2.copyPixels(bmd, new Rectangle(26 * 87, rect2.y, rect2.width, rect2.height), point2);
			} else {
				if (frame == ItemId.SMILEY_PLATINUM_SPENDER) {
					var time:int = getTimer() + id * 400; // current ms, offset by user id to desync players
					var msPer:int = 90; // ms per frame
					var num:int = ItemManager.smileyPlatinumSpenderBMD.width / 26; // number of frames
					var extra:int = 2920; // extra ms to stay on first frame
					var frame:int = Math.max(0, (time % (msPer * num + extra) - extra) / msPer);
					target2.copyPixels(ItemManager.smileyPlatinumSpenderBMD, new Rectangle(frame * 26, rect2.y, rect2.width, rect2.height), point2);
				} else {
					target2.copyPixels(bmd, rect2, point2);
				}
			}
			
			if (deg != 0) target.copyPixels(rotateBitmapData(target2, deg), target2.rect, point);
		}
		
		private function playLevitationAnimation(target:BitmapData, ox:int, oy:int):void {
			if (!isme && !render) return;
				
			if (this.morx == 0 && this.mory == 0) { // no gravity means levitation does not work (applies to no gravity dots, water, mud)
				return;
			}
			// Frame interval in spritesheet
			var startFrame:int = 0;
			var sequenceLength:int = 8;
			// position the animation in relation to the character 
			var animationYPos:int = -5;
			var animationXPos:int = -5;
			
			// check if gravitational pull direction is on the y axis
			if (this.mory != 0) {
				
				if (this.mory < 0) { // pull is upside down
					animationYPos = -21;
					startFrame = 8;
				}
				else {
					animationYPos = 12; // pull is normal
					startFrame = 0;
				}
			}
			// check if gravitational pull direction is on the x axis
			if (this.morx != 0) {
				if (this.morx < 0) { // pull is to the left
					animationXPos = -24;
					startFrame = 16;
				}
				else {
					animationXPos = 14; // pull is to the right
					startFrame = 24;
				}
			}
			
			// Do frame changing stuff
			if (levitationAnimation.frame < startFrame+sequenceLength - 1) {
				levitationAnimation.frame++;
			}
			else {
				levitationAnimation.frame = startFrame;
			}
			levitationAnimation.draw(target, x + ox + animationXPos, y + oy + animationYPos);
		}
		
		public function drawGods(target:BitmapData, ox:int, oy:int):void{
			if ((!isme && !render) || !isFlying) return;
			
			var behind:Boolean = isInGodMode && aura == 10;
			
			if (behind) {
				drawFace(target, new Point(x + ox - 5, y + oy - 5), false);
				
				if (hascrown) target.copyPixels(crown, crown.rect, new Point(x+ox-5,y+oy-6));
				else if (hascrownsilver) target.copyPixels(crown_silver, crown_silver.rect, new Point(x+ox-5,y+oy-6));
			}
				
			if (isInGodMode) {
				ItemManager.getAuraByIdAndColor(aura, auraColor).drawTo(target, x + ox - 24, y + oy - 24, auraAnimOffset);
				/*if(aura == 6) {
					sparkleAnimation.draw(target, x + ox - 24, y + oy - 24); 
					sparkleAnimation.frame++;
					if (sparkleAnimation.frame >= sparkleAnimation.totalFrames) sparkleAnimation.frame = 0;
				}*/
				
			} else if (isInModMode) {
				var mx:int = modoffset;
				modrect.x = mx * 64;
				target.copyPixels(staffAuraBMD, modrect, new Point(
					x+ox-24,y+oy-24
				));
			}
			
			if (!behind) {
				drawFace(target, new Point(x + ox - 5, y + oy - 5), false);
				
				if (hascrown) target.copyPixels(crown, crown.rect, new Point(x+ox-5,y+oy-6));
				else if (hascrownsilver) target.copyPixels(crown_silver, crown_silver.rect, new Point(x+ox-5,y+oy-6));
			}
		}
		
		public override function set frame(f:int):void{
			rect2.x = f*26
		}
		
		public override function get frame():int{
			return rect2.x/26
		}
		
		public function set wearsGoldSmiley(value:Boolean):void
		{
			rect2.y = value ? 26 : 0;
		}
		
		public function get wearsGoldSmiley():Boolean
		{
			return rect2.y == 26;
		}
		
		public function get canCheat():Boolean{
			//return isAdmin(name) || isModerator(name) || isDesigner(name) || isCampaignCurator(name)
			return !Bl.data.isCampaignRoom || (Global.playerInstance.hascrownsilver && !Global.ui2.trialsMode);
		}
		
		public static function isAdmin(name:String):Boolean{
			return hasStaffRank(name, "Admin");
		}
		
		public static function isModerator(name:String):Boolean{
			return hasStaffRank(name, "Moderation");
		}
		
		public static function isDesigner(name:String):Boolean{
			return hasStaffRank(name, "Design");
		}
		
		public static function isCampaignCurator(name:String):Boolean{
			return hasStaffRank(name, "Campaign");
		}
		
		private static function hasStaffRank(name:String, rank:String):Boolean {
			return true;
		}
		
		public static function isPatron(name:String):Boolean {
			return false;
		}
		
		public static function getPatronLevel(name:String):int {
			return 0;
		}
		
		public static function getPatronTier(name:String):String {
			return "";
		}
		
		public static function getPatronColor(name:String):uint {
			//var lvl:int = getPatronLevel(name);
			return Config.patron_color_1;
		}
		
		public static function getNameColor(name:String):uint {
			//return isAdmin(name) ? Config.admin_color :
				//isModerator(name) ? Config.moderator_color :
				//isDesigner(name) ? Config.designer_color :
				//isCampaignCurator(name) ? Config.campaign_curator_color :
				//isPatron(name) ? getPatronColor(name) :
			return Config.default_color;
		}
		
		public static function getProfileColor(name:String):uint {
			return getNameColor(name);
		}

		public function set nameColor(color:int):void {
			this.chat.textColor = color;
		}
		
		public function pressPurpleSwitch(switchId:int, enabled:Boolean) : void
		{
			if (switchId == 1000)
				for (var i:int = 0; i < 1000; i++)
					pressPurpleSwitch(i, enabled);
			
			this.switches[switchId] = enabled;
			if (this.world.overlaps(this)) {
				this.switches[switchId] = !enabled;
				tilequeue.push(function(): void { pressPurpleSwitch(switchId, enabled); });
			}
		}
		
		public function UpdateTeamDoors(x:int, y:int) : void
		{
			var id:int = world.lookup.getInt(x, y);
			tx = x; ty = y;
			UpdateTeamDoorsById(id, false);
		}
		
		public function UpdateTeamDoorsById(id:int, force:Boolean = true) : void { //oh is this not allowed ;c 
			var oid:int = team;
			if (team == id) return;
			team = id;
			if (!force && hitmap.overlaps(that)) {
				team = oid;
				//if(tx == -1) {
					//tx = (this.x + 8) >> 4;
					//ty = (this.x + 8) >> 4;
				//}
			} else {
				tx = -1;
				ty = -1;
			}
		}

		public function get minimapColor():uint {
			var smileyColor:uint = ItemManager.getSmileyById(frame).minimapcolor || 0xffffff;
			return isInModMode ? (modmodeRow == 0 ? Config.admin_color :
				modmodeRow == 1 ? Config.moderator_color :
				modmodeRow == 2 ? Config.designer_color : Config.campaign_curator_color) :
				smileyColor != 0xffffffff ? smileyColor :
				isInGodMode && isPatron(name) ? getPatronColor(name) :
				isme && Global.base.settings.greenOnMinimap ? 0xff00ff00 :
				0xffffffff;
		}
		
		private function drawTagged(target:BitmapData, ox:Number, oy:Number):void {
			var offset:int = -16;
			var deg:int = flipGravity * 90 % 360;
			
			function drawIcon(id:int):void {
				effectIcons.frame = id;
				
				effectIcons.RotateDeg = deg;
				effectIcons.draw(target, x + ox + ((flipGravity%2==0) ? 0 : (flipGravity==1) ? -offset : offset), y + oy + ((flipGravity%2==1) ? 0 : (flipGravity==2) ? -offset : offset));
				offset -= 12;
			}
			
			if (isInvulnerable) drawIcon(0);
			if (cursed) drawIcon(1);
			//if (zombie) drawIcon(2);
			if (poison) drawIcon(3);
		}

		public function get speedBoost():int
		{
			return _speedBoost.value;
		}
		
		public function set speedBoost(value:int):void
		{
			_speedBoost.value = value;
		}
		
		public function set flipGravity(value:int):void
		{
			_flipGravity.value = value;
		}
		
		public function get flipGravity():int
		{
			return _flipGravity.value;
		}
		
		public function get jumpBoost():int
		{
			return _jumpBoost.value;
		}
		
		public function set jumpBoost(value:int):void
		{
			_jumpBoost.value = value;
		}
		
		public function set cursed(value:Boolean):void
		{
			_cursed.value = value;
		}
		
		public function get cursed():Boolean
		{
			return _cursed.value;
		}

		public function set zombie(value:Boolean):void
		{
			_zombie.value = value;
		}
		
		public function get zombie():Boolean
		{
			if (isFlying) return false;
			return _zombie.value;
		}

		public function set poison(value:Boolean):void
		{
			_poison.value = value;
		}
		
		public function get poison():Boolean
		{
			if (isFlying) return false;
			return _poison.value;
		}
		
		public function set onFire(value:Boolean):void
		{
			isOnFire = value;
		}
		
		public function get onFire():Boolean
		{
			return isOnFire;
		}
		
		public function getCanTag():Boolean
		{
			if (isFlying || isDead) return false;
			return cursed || isInvulnerable || zombie;
		}
		
		public function getCanBeTagged():Boolean
		{
			if (isFlying || isDead || isInvulnerable) return false;
			return (new Date().time - last_respawn) > 1000; 
		}
		
		public function setPosition(px:Number, py:Number):void {
			x = px;
			y = py;
		}
		
		public function setEffect(effectId:int, active:Boolean, arg:Number = 0, duration:Number = 0):void {
			//trace((active ? "set" : "reset") + " effect " + effectId);
			if (duration > 0) {
				arg += 2 * Global.ping;
				duration += 2 * Global.ping;
			}
			switch (effectId) {
				case Config.effectReset: {
					resetEffects(false);
				}
				case Config.effectJump: {
					jumpBoost = active ? arg : 0;
					break;
				}
				case Config.effectFly: {
					hasLevitation = active;
					break;
				}
				case Config.effectRun: {
					speedBoost = active ? arg : 0;
					break;
				}
				case Config.effectProtection: {
					isInvulnerable = active;
					break;
				}
				case Config.effectCurse: {
					cursed = active;
					if (active) {
						curseTimeStart = new Date().time - (duration - arg) * 1000;
						curseDuration = duration;
					}
					break;
				}
				case Config.effectZombie: {
					zombie = active;
					if (active) {
						zombieTimeStart = new Date().time - (duration - arg) * 1000;
						zombieDuration = duration;
					}
					break;
				}
				case Config.effectLowGravity: {
					low_gravity = active;
					break;
				}
				case Config.effectFire: {
					isOnFire = active;
					if (active) {
						fireTimeStart = new Date().time - (duration - arg) * 1000;
						fireDuration = duration;
					}
					break;
				}
				case Config.effectMultijump: {
					maxJumps = active ? arg : 1;
					break;
				}
				case Config.effectGravity: {
					flipGravity = arg;
					break;
				}
				case Config.effectPoison: {
					poison = active;
					if (active) {
						poisonTimeStart = new Date().time - (duration - arg) * 1000;
						poisonDuration = duration;
					}
					break;
				}
			}
			
			if (isme) Global.base.ui2instance.setEffectIcon(effectId, active, arg, duration);
		}
		
		private const staticEffects:Array = [
			Config.effectJump,
			Config.effectFly,
			Config.effectRun,
			Config.effectProtection,
			Config.effectLowGravity,
			Config.effectMultijump,
			Config.effectGravity
		];
		
		private const timedEffects:Array = [
			Config.effectCurse,
			Config.effectZombie,
			Config.effectFire,
			Config.effectPoison
		];
		
		public function resetEffects(resetTimed:Boolean = true):void
		{
			for each (var s:int in staticEffects) setEffect(s, false);
			if (resetTimed) for each (var t:int in timedEffects) setEffect(t, false);
		}
		
		public function set isInvulnerable(value:Boolean):void 
		{
			_isInvulnerable.value = value;
		}
		
		public function get isInvulnerable():Boolean
		{
			return _isInvulnerable.value;
		}

		public function get hasLevitation():Boolean
		{
			return _hasLevitation.value;
		}

		public function set hasLevitation(value:Boolean):void
		{
			_hasLevitation.value = value;
			if (!value) {
				_currentThrust = 0;
			}
		}
		
		public function updateThrust():void {
			if (this.mory != 0) {
				this.speedY -= _currentThrust*(Config.physics_jump_height/2)*(this.mory*0.5);//mory is positive or negative depending on gravitation direction - zero is no pull on this axis
			}
			if (this.morx != 0) {
				this.speedX -= _currentThrust*(Config.physics_jump_height/2)*(this.morx*0.5);//morx is positive or negative depending on gravitation direction - zero is no pull on this axis
			}
			if (!isThrusting) {
				if (_currentThrust > 0) {
					_currentThrust -= _thrustBurnOff;
				}
				else {
					_currentThrust = 0;
				}
			}
		}
		
		public static function rotateBitmapData(bitmapData:BitmapData, degree:int):BitmapData
		{
			if (degree == 0) return bitmapData;
			
			var newBitmap:BitmapData = new BitmapData(bitmapData.width, bitmapData.height, true, 0x00000000);
			var matrix:Matrix = new Matrix();
			
			matrix.rotate(degree * Math.PI / 180);
			if (degree == 90) {
				matrix.translate(bitmapData.height, 0);
			} else if (degree == 270) {
				matrix.translate(0, bitmapData.width);
			} else if (degree == 180) {
				matrix.translate(bitmapData.width, bitmapData.height);
			}

			newBitmap.draw(bitmapData, matrix)
			return newBitmap;
		}

		public function get isThrusting():Boolean
		{
			return _isThrusting.value;
		}

		public function set isThrusting(value:Boolean):void
		{
			_isThrusting.value = value;
		}

		public function applyThrust():void {
			_currentThrust = _maxThrust;
		}
		
		public function get isFlying():Boolean {
			return isInGodMode || isInModMode;
		}

		public function get modmodeRow():int
		{
			return modrect.y / 64;
		}

		public function set modmodeRow(row:int):void
		{
			if (row == -1) row = Global.cookie.data.modmodeRow;
			row %= 4;
			modrect.y = row * 64;
			
			if (row != -1) {
				Global.cookie.data.modmodeRow = row;
				//if (!Global.noSave) Global.cookie.flush();
			}
		}
		
		public function get isFlaunting():Boolean
		{
			return _isFlaunting;
		}

		public function set isFlaunting(value:Boolean):void
		{
			_isFlaunting = value;
		}
		
		public function get canToggleGodMode():Boolean
		{
			return canEdit || _canToggleGod;
		}
		
		public function set canToggleGodMode(value:Boolean):void
		{
			_canToggleGod = value;
		}
		
		public function get isControlled():Boolean {
			return !Global.playState.target && isme || Global.playState.target == this;
		}
		
		//{ functions for ME.as
		protected function getPlayerInput():void {
			//overridden in Me.as
		}
		
		protected function touchBlock(cx:int, cy:int, isgodmode:Boolean):void {
			//overridden in Me.as
		}
		
		protected function sendMovement(cx:int, cy:int):void {
			//overridden in Me.as
		}
		
		protected function updateStuff():void {
			//overridden in Me.as
		}
		//}
	}
}