package ui.ingame.sam
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import items.ItemManager;
	import items.ItemSmiley;
	
	public class SmileyButton extends MovieClip {
		
		[Embed(source="/../media/aura_button.png")] private static var Aura:Class;
		private static var aura:BitmapData = new Aura().bitmapData;
		
		private	var auraBMD:BitmapData = new BitmapData(30, 28, true, 0x0);
		private var auraBM:Bitmap;
		
		public var smiley:SmileyInstance;
		
		public function SmileyButton() {
			buttonMode = true;
			useHandCursor = true;
			
			auraBMD = new BitmapData(30, 28, true, 0x0);
			auraBM = new Bitmap(auraBMD);
			addChild(auraBM);
			
			setActive(false);
		}
		
		public function setSelectedSmiley(id:int):void {
			if (smiley && contains(smiley))
				removeChild(smiley);
			
			smiley = new SmileyInstance(ItemManager.getSmileyById(id), null, Global.playerInstance.wearsGoldSmiley, -1, false);
			smiley.buttonMode = true;
			smiley.useHandCursor = true;
			smiley.x = (width - 26) / 2;
			smiley.y = (height - 26) / 2;
			addChild(smiley);
		}
		
		public function setActive(active:Boolean):void {
			auraBMD.copyPixels(aura, new Rectangle(active ? 30 : 0, 0, 30, 28), new Point());
		}
	}
}