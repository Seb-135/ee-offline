package ui.ingame
{
	import com.greensock.TweenMax;
	import com.greensock.easing.Back;
	import com.greensock.easing.Sine;
	
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	
	import items.ItemBrick;
	import items.ItemId;

	public class EffectDisplay extends Sprite
	{
		public var effects:Vector.<EffectMarker> = new Vector.<EffectMarker>();
		public var multiJumpCounter:MultiJumpCounter;
		private var zombieCounter:ZombieCounter;
		private var curseCounter:CurseCounter;
		
		public function EffectDisplay(curseLimit:int, zombieLimit:int)
		{
			super();
			
			zombieCounter = new ZombieCounter(zombieLimit);
			addChild(zombieCounter);
			
			curseCounter = new CurseCounter(curseLimit);
			addChild(curseCounter);
			
			multiJumpCounter = new MultiJumpCounter();
			addChild(multiJumpCounter);
			
			addEventListener(Event.ADDED_TO_STAGE, handleAddedToStage, false, 0, true);
		}
		
		protected function handleAddedToStage(event:Event):void
		{
			addEventListener(Event.ENTER_FRAME, handleEnterFrame, false, 0, true);
		}
		
		protected function handleEnterFrame(event:Event):void
		{
			refresh();
		}
		
		public function addEffect(bmd:BitmapData, id:int, timeLeft:Number = 0, duration:Number = 0):void
		{
			var newEffect:EffectMarker = new EffectMarker(bmd, id, timeLeft, duration);
			effects.push(newEffect);
			sortEffects();
			
			for (var i:int = 0; i < effects.length; i++)
			{
				addChild(effects[i]);
				var time:Number = effects[i] == newEffect ? 0 : 0.2;
				moveToPosition(effects[i], i, time);
				effects[i].refresh();
			}
			
			TweenMax.to(newEffect, 0, { x: -newEffect.width, alpha: 0 });
			TweenMax.to(newEffect, 0.2, { x: 0, alpha: 1, ease: Sine });
		}
		
		public function removeEffect(id:int):void
		{
			for (var i:int = 0; i < effects.length; i++)
			{
				if (effects[i].id == id) {
					TweenMax.to(effects[i], 0.3, { x: -effects[i].width, alpha: 0, onComplete: function(e:EffectMarker):void {
						removeChild(e);
					}, onCompleteParams: [effects[i]] });
					
					effects.splice(i, 1);
					i--;
				} else {
					moveToPosition(effects[i], i, 0.5);
				}
			}
		}
		
		public function removeAll():void
		{
			for (var i:int = 0; i < effects.length; i++)
			{
				TweenMax.to(effects[i], 0.3, { x: -effects[i].width, alpha: 0, onComplete: function(e:EffectMarker):void {
					removeChild(e);
				}, onCompleteParams: [effects[i]] });
			}
			
			effects = new Vector.<EffectMarker>();
		}
		
		public function update():void
		{	
			multiJumpCounter.update();
			zombieCounter.update();
			curseCounter.update();		
			
			refresh();
		}
		
		public function setLimits(curseLimit:int, zombieLimit:int):void
		{
			curseCounter.setLimit(curseLimit);
			zombieCounter.setLimit(zombieLimit);
		}
		
		public function refresh():void
		{
			multiJumpCounter.y = 0;
			zombieCounter.y = 0;
			curseCounter.y = 0;	
			
			if (zombieCounter.visible) {				
				curseCounter.y = (zombieCounter.y + zombieCounter.height + 2) >> 0;	
			}
			else curseCounter.y = 0;
			
			if (zombieCounter.visible && curseCounter.visible) {			
				multiJumpCounter.y = (curseCounter.y + curseCounter.height + 2) >> 0;				
			}
			else if (zombieCounter.visible) {				
				multiJumpCounter.y = (zombieCounter.y + zombieCounter.height + 2) >> 0;	
			}
			else if (curseCounter.visible) {				
				multiJumpCounter.y = (curseCounter.y + curseCounter.height + 2) >> 0;	
			}
			else multiJumpCounter.y = 0;
			
			for (var i:int = 0; i < effects.length; i++)
			{
				moveToPosition(effects[i], i, 0.5);
				if (effects[i].refresh()) {
					removeEffect(ItemId.EFFECT_CURSE);
					removeEffect(ItemId.EFFECT_ZOMBIE);
					removeEffect(ItemId.LAVA);
					removeEffect(ItemId.EFFECT_POISON);
					Global.playState.player.setEffect(Config.effectCurse, false);
					Global.playState.player.setEffect(Config.effectZombie, false);
					Global.playState.player.setEffect(Config.effectFire, false);
					Global.playState.player.setEffect(Config.effectPoison, false);
				}
			}
		}
		
		private function sortEffects():void
		{
			effects.sort(function(a:EffectMarker, b:EffectMarker):int {
				return a.timeLeft < b.timeLeft ? 1 : -1;
			});
		}
		
		private function moveToPosition(effect:EffectMarker, position:int, time:int):void
		{
			var targetY:int = position * (EffectMarker.HEIGHT + 2);
			
			if (multiJumpCounter.visible) targetY += multiJumpCounter.height + 2;
			if (zombieCounter.visible) targetY += zombieCounter.height + 2;
			if (curseCounter.visible) targetY += curseCounter.height + 2;
			
			TweenMax.to(effect, time, { y: targetY, ease: Back });
		}
	}
}