package
{
	import blitter.Bl;
	
	import com.adobe.images.PNGEncoder;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.FileReference;
	import flash.utils.ByteArray;
	
	import states.PlayState;
	
	public class Screenshot
	{
		// Saves the screen as a .PNG file only containing blocks and smileys.
		public static function SavePNG(e:MouseEvent):void {
			var fileReference:FileReference = new FileReference();
			if (e.buttonDown) {
				var byteArray:ByteArray = PNGEncoder.encode((Global.base.state as PlayState).lastframe);
				fileReference.save(byteArray, Global.currentLevelname + ".png");
				Global.base.showInfo2("Screenshot taken", "Your screenshot was taken!");
			}
		}
		
		// Saves the WHOLE world .PNG to a file. (May take a while to generate if the world is big)
		public static function SavePNGWithFullWorld(e:MouseEvent):void {
			var fileReference:FileReference = new FileReference();
			if (e.buttonDown) {
				(Global.base.state as PlayState).world.drawFull();
				var byteArray:ByteArray = PNGEncoder.encode((Global.base.state as PlayState).world.fullImage);
				fileReference.save(byteArray, Global.currentLevelname + ".png");
				Global.base.showInfo2("Screenshot taken", "Your screenshot was taken!");
			}
		}
		
		public static function SavePNGWithMinimap(e:MouseEvent):void {
			var fileReference:FileReference = new FileReference();
			if (e.buttonDown) {
				var byteArray:ByteArray = PNGEncoder.encode((Global.base.state as PlayState).minimap.getBitmapData());
				fileReference.save(byteArray, Global.roomid + "-minimap.png");
			}
		}
	}
}