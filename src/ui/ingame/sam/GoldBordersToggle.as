package ui.ingame.sam
{
	import blitter.BlText;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;

	public class GoldBordersToggle extends Sprite
	{
		private var text:BlText;
		private var textBM:Bitmap;
		
		private var checkBox:Sprite;
		
		[Embed(source="/../media/checkmark.png")] private static var checkmarkBM:Class;
		private static var checkmarkBMD:BitmapData = new checkmarkBM().bitmapData;
		
		public var checkmark:Bitmap;
		
		public function GoldBordersToggle() {
			useHandCursor = true;
			mouseEnabled = true;
			buttonMode = true;
			
			graphics.lineStyle(1, 0x7b7b7b);
			graphics.beginFill(0x323232);
			graphics.drawRect(0, 0, 89, 28);
			graphics.endFill();
			
			checkBox = new Sprite();
			checkBox.graphics.lineStyle(1, 0x7b7b7b);
			checkBox.graphics.beginFill(0x444444);
			checkBox.graphics.drawRect(0, 0, 13, 13);
			checkBox.graphics.endFill();
			checkBox.x = 4;
			checkBox.y = 8;
			addChild(checkBox);
			
			checkmark = new Bitmap(checkmarkBMD);
			checkBox.addChild(checkmark);
		}
		
		public function setActive(value:Boolean):void {
			if (textBM && contains(textBM)) removeChild(textBM);
			
			checkmark.visible = value;
			
			text = new BlText(8, 68);
			text.text = "Gold Borders";
			
			textBM = new Bitmap(text.clone());
			textBM.x = (checkBox.x + 17);
			textBM.y = 9;
			addChild(textBM);
		}
	}
}