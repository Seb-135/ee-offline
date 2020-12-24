package ui.ingame.sam 
{
	import blitter.Bl;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import items.ItemAuraColor;
	import items.ItemAuraShape;
	import states.PlayState;
	public class AuraMenu extends Sprite {
		
		private var auraContainer:Sprite;
		
		public var auraSelector:AuraSelector;
		
		private var containerWidth:int = 240;
		private var containerHeight:int = 65;
		
		private var ui2:UI2;
		private var auras:Array;
		
		public function AuraMenu(ui2:UI2) {
			visible = false;
			
			this.ui2 = ui2;
			auras = [];
			
			auraContainer = new Sprite();
			addChild(auraContainer);
			
			auraSelector = new AuraSelector(this.ui2);
			addChild(auraSelector);
			
			addEventListener(Event.ADDED_TO_STAGE, handleAddedToStage);
		}
		
		public function redraw():void {
			var showAuraContainer:Boolean = (Bl.data.canToggleGodMode);
			var playState:PlayState = Global.base.state as PlayState;
			if (playState && playState.player.isInGodMode) 
				showAuraContainer = true;
				
			auraContainer.graphics.clear();
			if (showAuraContainer){
				auraContainer.graphics.lineStyle(1, 0x7B7B7B, 1);
				auraContainer.graphics.beginFill(0x323232, 1);
				auraContainer.graphics.drawRect(0, 0, containerWidth, containerHeight);
				auraContainer.graphics.endFill();
			}
			
			auraSelector.x = containerWidth/2 - auraSelector.width;
			auraSelector.visible = showAuraContainer;
			
			x = 35;
			y = -(containerHeight + 30);
		}
		
		public function addShape(aura:ItemAuraShape):void{
			auraSelector.addAura(new AuraInstance(aura, ui2));
		}
		
		public function addColor(color:ItemAuraColor):void {
			auraSelector.addColor(new AuraColorButton(color, function(id:int):void {
				ui2.setSelectedAuraColor(id);
			}));
		}
		
		protected function handleAddedToStage(e:Event):void {
			removeEventListener(Event.ADDED_TO_STAGE, handleAddedToStage);
			redraw();
		}
	}
}