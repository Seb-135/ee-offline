package ui.ingame.sam
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Graphics;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.DropShadowFilter;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import items.ItemManager;
	import items.ItemSmiley;
	
	import sample.ui.components.Label;
	
	import states.PlayState;

	public class AuraSelector extends MovieClip
	{
		[Embed(source="/../media/arrows.png")] private static var Arrows:Class;
		public static var arrowsBMD:BitmapData = new Arrows().bitmapData;
		
		private var buttonsContainer:Sprite;
		private var buttonsContainerWidth:int = (7 * 15);
		private var buttonsContainerHeight:int = (3 * 15);
		
		private var auras:Vector.<AuraInstance> = new Vector.<AuraInstance>();
		public var basiswidth:int = 64 + 20 * 2;

		private var selectedAura:AuraInstance;
		
		private var id:int = 0;
		
		private var ui2s:UI2;
		
		private var colorsLabel:Label;
		private var shapeLabel:Label;
		private var shapeName:Label;
		
		private var left:Sprite;
		
		public function AuraSelector(ss:UI2) {
			ui2s = ss;
			addEventListener(Event.ADDED_TO_STAGE, handleAttach);
			
			buttonsContainer = new Sprite();
			addChild(buttonsContainer);
			
			colorsLabel = new Label("Aura Color", 12, "left", 0xFFFFFF, false, "visitor");
			colorsLabel.x = 84 + ((224 - 84) - colorsLabel.textWidth) / 2;
			colorsLabel.y = 3;
			addChild(colorsLabel);
			
			shapeLabel = new Label("Aura Shape", 12, "left", 0xFFFFFF, false, "visitor");
			shapeLabel.x = ((224 - 124) - shapeLabel.textWidth) / 2;
			shapeLabel.y = 3;
			addChild(shapeLabel);
			
			shapeName = new Label("<Name>", 12, "left", 0xFFFFFF, false, "visitor");
			shapeName.x = ((224 - 124) - shapeName.textWidth) / 2;
			shapeName.y = 50;
			addChild(shapeName);
		}
		
		private function addArrows():void {
			var leftBMD:BitmapData = new BitmapData(20, 64, true, 0x0);
			leftBMD.copyPixels(arrowsBMD, new Rectangle(0, 0, 20, 64), new Point(0, 0));
			var rightBMD:BitmapData = new BitmapData(20, 64, true, 0x0);
			rightBMD.copyPixels(arrowsBMD, new Rectangle(20, 0, 20, 64), new Point(0, 0));
			var leftBM:Bitmap = new Bitmap(leftBMD);
			var rightBM:Bitmap = new Bitmap(rightBMD);
			
			left = new Sprite();
			var right:Sprite = new Sprite();
			
			left.y = 1;
			right.y = 1;
			right.x = 84;
			
			left.addChild(leftBM);
			left.addEventListener(MouseEvent.CLICK, function():void { switchAura(-1); });
			
			right.addChild(rightBM);
			right.addEventListener(MouseEvent.CLICK, function():void { switchAura(1); });
			
			addChild(left);
			addChild(right);
		}
		
		private function switchAura(dir:int = 1):void {
			clearAura();
			
			id += dir;
			if (dir < 0 && id < 0) id = auras.length - 1;
			if (dir > 0 && id >= auras.length) id = 0;
			
			selectedAura = auras[id];
			addChild(selectedAura);
			redraw();
			ui2s.setSelectedAura(selectedAura.item.id);
		}
		
		public override function get width():Number {
			return basiswidth;
		}
		
		public override function set width(value:Number) : void{
			basiswidth = value;
			redraw();
		}
		
		public function setSelectedAura(aura:int):void {
			clearAura();
			
			for (var i:int = 0; i < auras.length; i++) {
				if (auras[i] && AuraInstance(auras[i]).item.id == aura) {
					id = i;
					selectedAura = auras[i];
					break;
				}
			}
			
			if (selectedAura == null) {
				id = 0;
				selectedAura = auras[0];
			}
			
			var target:Player = Global.playState.target as Player;
			if (target != null && target != Global.playState.player)
				selectedAura.changeColor(target.auraColor);
			else selectedAura.changeColor(Global.playerInstance.auraColor);
			
			shapeName.text = selectedAura.item.name;
			shapeName.x = ((224 - 124) - shapeName.textWidth) / 2;
			
			addChild(selectedAura);
			redraw();
		}
		
		private var ox:int = 0;
		private var oy:int = 5;
		public function addAura(aura:AuraInstance):void {
			auras.push(aura);
			
			if (auras.length > 1 && left == null)
				addArrows();
		}
		
		public function addColor(button:AuraColorButton):void {
			if ((ox + 20) > buttonsContainerWidth){
				ox = 0;
				oy += 15;
			}
			
			button.x = ox;
			button.y = oy;
			
			ox += 15;

			button.useHandCursor = true;
			button.mouseEnabled = true;
			button.buttonMode = true;
			buttonsContainer.addChild(button);
			
			buttonsContainer.x = 84 + ((224 - 84) - buttonsContainer.width) / 2;
			buttonsContainer.y = (65 - buttonsContainer.height) / 2;
		}
		
		public function clearAura():void {
			if (selectedAura) {
				removeChild(selectedAura);
				selectedAura = null;
			}
		}
		
		public function redraw():void {
			if (selectedAura)
				selectedAura.x = 20;
		}
		
		private function handleAttach(e:Event):void {
			redraw();
		}
	}
}