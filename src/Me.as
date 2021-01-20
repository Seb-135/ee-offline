package {
	import blitter.Bl;
	import items.ItemId;
	import sounds.*;
	import states.PlayState;
	import utilities.Random;
	
	import ui.LevelComplete;
	
	public class Me extends Player {
		protected var coinCountChanged:Boolean = false;
		protected var tickID:int = 0;
		public var ticks:int = 0;
		public var completed:Boolean = false;
		private static var keys:Object = {
			"6": "red",
			"7": "green",
			"8": "blue",
			"408": "cyan",
			"409": "magenta",
			"410": "yellow"
		}
		
		public function Me(world:World, name:String, isme:Boolean, state:PlayState) {
			super(world, name, isme, state);
		}
		
		protected override function getPlayerInput():void {
			if(isControlled) {
				leftdown  = Bl.isKeyDown(37) || KeyBinding.left.isDown(true) ? -1 : 0;
				updown    = Bl.isKeyDown(38) || KeyBinding.up.isDown(true) ? -1 : 0;
				rightdown = Bl.isKeyDown(39) || KeyBinding.right.isDown(true) ? 1 : 0;
				downdown  = Bl.isKeyDown(40) || KeyBinding.down.isDown(true) ? 1 : 0;
				
				spacejustdown = KeyBinding.jump.isJustPressed(true);
				spacedown = KeyBinding.jump.isDown(true);
				
				horizontal = leftdown + rightdown;
				vertical = updown + downdown;
				Bl.resetJustPressed();
			}
		}
		
		private function spawnCoinPatricle(cx:int, cy:int, blue:Boolean):void {
			var frame:int = blue? 5 : Random.nextInt(1, 4); // [1, 2, 3]
			world.addParticle(new Particle(world, frame, (cx * 16) + 6, (cy * 16) + 6, Math.random() - (Math.random() / 10), Math.random() - (Math.random() / 10), 0.023, 0.023, Math.random() * 360, Math.random() * 90));
		}
		
		protected override function touchBlock(cx:int, cy:int, isgodmode:Boolean):void {
			if (isme){
				multiJumpEffectDisplay.update();
				coinCountChanged = false;
			}
			
			switch(current) { //always-interactive blocks
				case ItemId.COIN_GOLD:
				case ItemId.COIN_BLUE:
				case 110:
				case 111: {
					if(isme && current != 110 && current != 111) {
					SoundManager.playMiscSound(SoundId.COIN);
					world.setTileComplex(0, cx, cy, current + 10, null); // 100 -> 110; 101 -> 111
					if (current == ItemId.COIN_GOLD) {
						coins++;
						gx.push(cx)
						gy.push(cy);
					}
					else {
						bcoins++;
						bx.push(cx);
						by.push(cy);
					}
					coinCountChanged = true;
					if (!Global.base.settings.particles) break;
					for (var k:int = 0; k < 4; k++)
						spawnCoinPatricle(cx, cy, current == ItemId.COIN_BLUE);
					} else if (!isme){
						var found:Boolean = false;
						for (var i:int = 0; i < gx.length; i++) {
							if (gx[i] == cx && gy[i] == cy) {
								found = true;
								break;
							}
						}
						if (!found) {
							if (current == ItemId.COIN_GOLD || current == 110) {
								coins++;
								gx.push(cx)
								gy.push(cy);
							}
							else if (current == ItemId.COIN_BLUE || current == 111) {
								bcoins++;
								bx.push(cx);
								by.push(cy);
							}
						}
					}
					break;
				}
				case ItemId.RESET_POINT: 
					if (isgodmode || !KeyBinding.risky.isDown() && isme || resetSend) break;
					resetPlayer();
					break;
			}
			
			if (pastx != cx || pasty != cy){ //only just-entered blocks
				
				if(isme) {
					switch(current) { //blocks that don't care about godmode
						
						case ItemId.PIANO:
							if (SoundManager.playPianoSound(world.lookup.getInt(cx, cy)))
								world.lookup.setBlink(cx, cy, 30);
							break;
						case ItemId.DRUMS:
							if (SoundManager.playDrumSound(world.lookup.getInt(cx, cy)))
								world.lookup.setBlink(cx, cy, 30);
							break;
						case ItemId.GUITAR: 
							if (SoundManager.playGuitarSound(world.lookup.getInt(cx, cy))) 
								world.lookup.setBlink(cx, cy, 30);
							break;
					}
				}
				
				if(!isgodmode) {				
					switch(current) {
						case ItemId.CROWN: 
							if (!hascrown && !isgodmode) {
								Global.playState.removeCrown();
								hascrown = true;
								if (isme) Global.playState.checkCrown(true);
								else collideWithCrownDoorGate = true;
							}
							break;
						
						case ItemId.SWITCH_PURPLE:
							var sid:int = world.lookup.getInt(cx, cy);
							var enablePurpleSwitch:Boolean = !this.switches[sid];
							pressPurpleSwitch(sid, enablePurpleSwitch);
							break;
						case ItemId.SWITCH_ORANGE: 
							var osid:int = world.lookup.getInt(cx, cy);
							var enableOrangeSwitch: Boolean = !this.world.orangeSwitches[osid];
							state.pressOrangeSwitch(osid, enableOrangeSwitch);
							break;
						
						case ItemId.RESET_PURPLE:
							var rsid:int = world.lookup.getInt(cx, cy);
							if (rsid == 1000 || this.switches[rsid]) {
								pressPurpleSwitch(rsid, false);
							}
							break;
						case ItemId.RESET_ORANGE: 
							var rosid:int = world.lookup.getInt(cx, cy);
							if (rosid == 1000 || this.world.orangeSwitches[rosid]) {
								state.pressOrangeSwitch(rosid, false);
							}
							break;
						
						case 411:
						case 412:
						case 413:
						case 414:
						case ItemId.SLOW_DOT_INVISIBLE:
						case 1519: world.lookup.setBlink(cx, cy, -100); break;
						
						case ItemId.DIAMOND:
							frame = 31; break;
						case ItemId.CAKE:
							frame = Random.nextInt(72, 76); break;
						case ItemId.HOLOGRAM:
							frame = 100; break;
						
						case ItemId.CHECKPOINT:
							checkpoint_x = cx;
							checkpoint_y = cy; 
							break;
						
						case ItemId.BRICK_COMPLETE:
							if (!hascrownsilver && !resetSend) {
								hascrownsilver = true;
								if (isme) {
									completed = true;
									Global.playState.checkSilverCrown(true);
									Global.ui2.completeLevel();
								}
								else collideWithSilverCrownDoorGate = true;
								//if (Global.base.overlayContainer.getChildByName("LevelCompleteScreen")) return;
								//Global.base.showOnTop(new LevelComplete());
							}
							break;
						case ItemId.GOD_BLOCK:
							if (_canToggleGod) break;
								if (isme) {
									canToggleGodMode = true;
									Bl.data.canToggleGodMode = true;
									Global.ui2.auraMenu.redraw();
									Global.ui2.configureInterface();
								} else {
									isInGodMode = true;
									resetDeath();
								}
							break;
						case ItemId.MAP_BLOCK:
							if (!isme) break;
							var oldMapEnabled:Boolean = Global.base.ui2instance.minimapEnabled;
							Global.base.ui2instance.playerMapEnabled = true;
							if (!oldMapEnabled) {
								Global.base.ui2instance.configureInterface();
								Global.base.showInfo2("System Message", "You may now use the minimap.");

							}
							break;
						
						//{ KEYS
						case ItemId.KEY_RED:
						case ItemId.KEY_GREEN:
						case ItemId.KEY_BLUE:
						case ItemId.KEY_CYAN:
						case ItemId.KEY_MAGENTA:
						case ItemId.KEY_YELLOW: {
							state.switchKey(keys[current], true);
							break;
						}
						//}
						//{ EFFECTS
						case ItemId.EFFECT_JUMP: 
							var newJumpBoost:int = world.lookup.getInt(cx, cy);
							if (jumpBoost == newJumpBoost) break;
							jumpBoost = newJumpBoost;
							setEffect(Config.effectJump, jumpBoost != 0, jumpBoost);
							break;
						case ItemId.EFFECT_FLY: 
							var newLevitation:Boolean = world.lookup.getBoolean(cx, cy);
							if (hasLevitation == newLevitation) break;
							hasLevitation = newLevitation;
							setEffect(Config.effectFly, hasLevitation);
							break;
						case ItemId.EFFECT_RUN: 
							var newSpeed:int = world.lookup.getInt(cx, cy);
							if (speedBoost == newSpeed) break;
							speedBoost = newSpeed;
							setEffect(Config.effectRun, speedBoost != 0, speedBoost);
							break;
						case ItemId.EFFECT_LOW_GRAVITY:
							var newLowGravity:Boolean = world.lookup.getBoolean(cx, cy);
							if (low_gravity == newLowGravity) break;
							low_gravity = newLowGravity;
							setEffect(Config.effectLowGravity, low_gravity);
							break;
						case ItemId.EFFECT_CURSE: 
							var newCurse:Boolean = world.lookup.getInt(cx, cy) > 0;
							if (cursed == newCurse || isInvulnerable) break;
							cursed = newCurse;
							setEffect(Config.effectCurse, cursed, world.lookup.getInt(cx, cy), world.lookup.getInt(cx, cy));
							break;
						case ItemId.EFFECT_ZOMBIE:
							var newZombie:Boolean = world.lookup.getInt(cx, cy) > 0;
							if (zombie == newZombie || isInvulnerable) break;
							zombie = newZombie;
							setEffect(Config.effectZombie, zombie, world.lookup.getInt(cx, cy), world.lookup.getInt(cx, cy));
							break;
						case ItemId.EFFECT_POISON: 
							var newPoison:Boolean = world.lookup.getInt(cx, cy) > 0;
							if (poison == newPoison || isInvulnerable) break;
							poison = newPoison;
							setEffect(Config.effectPoison, poison, world.lookup.getInt(cx, cy), world.lookup.getInt(cx, cy));
							break;
						case ItemId.NPC_ZOMBIE: 
							if (zombie || isInvulnerable) break;
							zombie = true;
							setEffect(Config.effectZombie, true);
							break;
						case ItemId.EFFECT_PROTECTION: 
							var newInv:Boolean = world.lookup.getBoolean(cx, cy);
							if (isInvulnerable == newInv) break;
							isInvulnerable = newInv;
							if (isInvulnerable) {
								cursed = false;
								zombie = false;
								poison = false;
								isOnFire = false;
								setEffect(Config.effectCurse, false);
								setEffect(Config.effectPoison, false);
								setEffect(Config.effectZombie, false);
								setEffect(Config.effectFire, false);
							}
							setEffect(Config.effectProtection, isInvulnerable);
							break;
						case ItemId.EFFECT_RESET:
							resetEffects(false);
							break;
						
						case ItemId.EFFECT_TEAM:
							if (isme) UpdateTeamDoors(cx, cy);
							else team = world.lookup.getInt(cx, cy);
							break;
						
						case ItemId.LAVA:
							if (isOnFire || isInvulnerable) break;
							isOnFire = true;
							setEffect(Config.effectFire, isOnFire, 2, 2);
							break;
						case ItemId.WATER:
						case ItemId.MUD:
						case ItemId.TOXIC_WASTE: 
							if (!isOnFire) break;
							isOnFire = false;
							setEffect(Config.effectFire, false);
							break;
						case ItemId.EFFECT_MULTIJUMP: 
							var jps:int = world.lookup.getInt(cx, cy);
							if (jps == maxJumps) break;
							maxJumps = jps;
							setEffect(Config.effectMultijump, maxJumps != 1, maxJumps);
							break;
						case ItemId.EFFECT_GRAVITY:
							var newflipGravity:int = world.lookup.getInt(cx, cy);
							if (flipGravity == newflipGravity) break;
							flipGravity = newflipGravity;
							setEffect(Config.effectGravity, flipGravity != 0, flipGravity);
							break;
						//}
						
					}
				}
				
				pastx = cx;
				pasty = cy;
				
			}
		}
		
		protected override function sendMovement(cx:int, cy:int):void {
			if (isControlled) {
				if (this.oh != horizontal || this.ov != vertical || ospacedown != spacedown || (ospaceJP != spacejustdown && spacejustdown) || coinCountChanged || enforceMovement) {
					this.oh = horizontal;
					this.ov = vertical;
					this.ospacedown = spacedown;
					this.ospaceJP = spacejustdown;
					tickID++;
					spacejustdown = false;
				}
				enforceMovement = false;
			}
		}
		
		protected override function updateStuff():void {
			if (isControlled) if (!completed && (ticks || horizontal || vertical || spacedown)) ticks += 1;
		}
	}
}