package ui.brickoverlays
{
	import blitter.Bl;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.filters.DropShadowFilter;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import items.ItemManager;
	import items.ItemId;
	
	import sounds.SoundManager;
	
	import ui2.ui2minusbtn;
	import ui2.ui2plusbtn;
	import ui2.ui2properties;

	public class DrumProperties extends PropertiesBackground
	{
		[Embed(source="/../media/drums.png") ] protected static var drumBM:Class;
		private static var drum:Bitmap = new drumBM;
		private static var mark:Sprite = new Sprite();
		public function DrumProperties(){
			
			addChild(drum);
			drum.x = -(drum.width/2);
			drum.y = -70
				
				
			mark.graphics.clear();
			mark.graphics.beginFill(0xff0000,0.5);
			mark.graphics.drawCircle(0,0,4);
			mark.graphics.endFill();
			mark.mouseEnabled = false;
			
				
			var xx:int = -(drum.width/2)-42
			var yy:int = -35;
			addChild(createDrumBox(0,xx+=40));
			addChild(createDrumBox(2,xx+=40));
			addChild(createDrumBox(10,xx+=40));
			addChild(createDrumBox(4,xx+=40));
			addChild(createDrumBox(8,xx+=40));
			addChild(createDrumBox(17,xx+=40));
			addChild(createDrumBox(7,xx+=40));
			addChild(createDrumBox(9,xx+=40));
			addChild(createDrumBox(19,xx+=40));
			
			xx = -(drum.width/2)-9;
			
			// Box 1 (2)
			addChild(createDrumSelector(0,xx+=15, yy));
			addChild(createDrumSelector(1,xx+=15, yy));
			
			// Box 2 (2)
			addChild(createDrumSelector(2,xx+=15 + 9, yy));
			addChild(createDrumSelector(3,xx+=15, yy));
			
			// Box 3 (4)
			addChild(createDrumSelector(10,xx+=12 + 10, yy));
			addChild(createDrumSelector(11,xx+=12, yy));
			addChild(createDrumSelector(12,xx+=12, yy));
			addChild(createDrumSelector(13,xx-=12, yy+=11));
			
			// Box 4 (5)
			addChild(createDrumSelector(4,xx+=12 + 12 + 3, yy-=11));
			addChild(createDrumSelector(5,xx+=12, yy));
			addChild(createDrumSelector(6,xx+=12, yy));
			addChild(createDrumSelector(14,xx-=18, yy+=11));
			addChild(createDrumSelector(15,xx+=12, yy));
			
			// Box 5 (2)
			addChild(createDrumSelector(8,xx+=15 + 10, yy-=11));
			addChild(createDrumSelector(16,xx+=15, yy));
			
			// Box 6 (2)
			addChild(createDrumSelector(17,xx+=15 + 10, yy));
			addChild(createDrumSelector(18,xx+=15, yy));
			
			// Box 7, 8, 9 (1)
			addChild(createDrumSelector(7,xx+=32, yy));
			addChild(createDrumSelector(9,xx+=40, yy));
			addChild(createDrumSelector(19,xx+=40, yy));
			
		
//			this.bg.width = 256;
//			this.bg.height = 60-2;
//			this.bg.visible = false;
			setSize(drum.width+5,72);
			
			this.filters = [new DropShadowFilter(0,0,0,1,6,6,2)]
			addChild(mark);
			
			
		}
		
		private var selectors:Array = [];
		private function createDrumBox(id:int,xx:int):Sprite{
			
			
		
			var s:Sprite = new Sprite();
			s.x = xx;
			s.y = -70;
			
		
			s.graphics.beginFill(0xff0000,0)
			s.graphics.drawRect(0,0,42,42);
			s.graphics.endFill()
			
			s.addEventListener(MouseEvent.MOUSE_DOWN, function():void {
				SoundManager.playDrumSound(id);	
				selectSound(id);
			})
			
			return s;
		}
		
		private function createDrumSelector(id:int,xx:int,yy:int):Sprite{
			
			
			var s:Sprite = new Sprite();
			
			s.x = xx;
			s.y = yy;
			s.graphics.beginFill(0x0000ff,0)
			s.graphics.drawRect(0,0,12,11);
			s.graphics.endFill()
			
				
			selectors[id] = s;
				
			s.addEventListener(MouseEvent.MOUSE_DOWN, function():void {
				SoundManager.playDrumSound(id);
				selectSound(id);
			})
				
			if(id == Global.drumOffset) selectSound(id);
			
			return s;
		}
		
		private function selectSound(id:int):void{
			Global.drumOffset = id;
			
			mark.x = selectors[id].x + 6;
			mark.y = selectors[id].y + 5.5;
		}
		
	}
}