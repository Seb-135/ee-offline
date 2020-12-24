package ui.brickoverlays
{
	import flash.display.Bitmap;
	import flash.display.SpreadMethod;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.filters.DropShadowFilter;
	
	import items.ItemManager;
	
	import sounds.SoundManager;

	public class GuitarProperties extends PropertiesBackground
	{
		[Embed(source="/../media/guitar.png") ] protected static var GuitarBM:Class;
		private static var guitar:Bitmap = new GuitarBM;
		[Embed(source="/../media/guitarmark.png") ] protected static var GuitarMarkBM:Class;
		private static var mark:Bitmap = new GuitarMarkBM;
		
		public function GuitarProperties(){
			
			addChild(guitar);
			guitar.x = -(guitar.width/2)-1;
			guitar.y = -guitar.height-12;
				
			addChild(mark);
			mark.x = -237;
			mark.y = -110;

			setSize(guitar.width + 4, guitar.height + 14);
			
			for (var y:int = 0; y < 6; y++)
				for (var x:int = 0; x < 20; x++) 
					addChild(createFret(x * 23 - 237 - ((x == 0) ? 0 : 3), y * 14 - 110, y * 20 + x));
			
			addChild(mark);
		}
		
		private function createFret(x:int, y:int, id:int):Sprite{
			var s:Sprite = new Sprite();
			s.x = x;
			s.y = y;
			
			if (Global.guitarOffset == id) {
				mark.x = s.x;
				mark.y = s.y;
			}
			
			s.graphics.beginFill(0xff0000,0)
			s.graphics.drawRect(0,0,12,8);
			s.graphics.endFill();
			
			s.addEventListener(MouseEvent.MOUSE_DOWN, function():void{
				Global.guitarOffset = id;
				SoundManager.playGuitarSound(SoundManager.guitarMap[id]);
				mark.x = s.x;
				mark.y = s.y;
			});
			return s;
		}
		
	}
}