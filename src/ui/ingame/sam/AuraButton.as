package ui.ingame.sam 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	public class AuraButton extends MovieClip {
		
		[Embed(source="/../media/aura_button.png")] private static var Aura:Class;
		private static var aura:BitmapData = new Aura().bitmapData;
		
		private	var auraBMD:BitmapData = new BitmapData(30, 28, true, 0x0);
		private var auraBM:Bitmap;
		
		public function AuraButton() {
			buttonMode = true;
			useHandCursor = true;
			
			auraBMD = new BitmapData(30, 28, true, 0x0);
			auraBM = new Bitmap(auraBMD);
			addChild(auraBM);
			
			setActive(false);
		}
		
		public function setActive(active:Boolean):void {
			auraBMD.copyPixels(aura, new Rectangle(active ? 30 : 0, 0, 30, 28), new Point());
		}
	}
}