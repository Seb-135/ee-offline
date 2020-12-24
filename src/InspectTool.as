package
{
	import items.ItemId;
	
	import blitter.BlText;
	import blitter.Bl;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Point;

	public class InspectTool extends TextBubble
	{
		private var world:World;
		
		public function InspectTool(world:World)
		{
			this.world = world;
		}
		
		public function updateForBlockAt(x:int, y:int):void
		{
			update(getInspectText(x, y), 0, false);
		}
		
		private function getInspectText(x:int, y:int):String
		{
			var str:String = "(" + x + "," + y + ")  \n";
			
			if (Bl.data.isCampaignRoom)
				return str;
				
			var fg:String = getLayerText(0, x, y);
			var bg:String = getLayerText(1, x, y);
			
			if (fg != "")
				str += "\n" + fg + "\n";
			if (bg != "")
				str += "\n" + bg + "\n";
				
				
			if (fg == "" && bg == "")
				str += "\n" + "No placement data\n";
				
			str += getForegroundBlockInfo(x, y);
			
			return str;
		}
		
		private function getLayerText(layer:int, x:int, y:int):String
		{			
			var placer:String = world.lookup.getPlacer(x, y, layer);
			var block:int = world.getTile(layer, x, y);
				
			var layerText:String = (layer == 0 ? "Foreground"  : "Background") + " [" + block + "]";			
			if (placer == "")
				return block == 0 ? "" : layerText;			
			
			return layerText + ":\n" + getPlacerText(placer, block);
		}
		
		private function getForegroundBlockInfo(x:int, y:int):String {
			var canEdit:Boolean = Bl.data.canEdit;
			var block:int = world.getTile(0, x, y);
			
			if (block == ItemId.WORLD_PORTAL) {
				var worldPortal:WorldPortal = world.lookup.getWorldPortal(x, y);
				return "\nWorld Portal:\nWorld ID: " + worldPortal.id + "\nSpawn target: " + worldPortal.target;
			}
			
			else if (block == ItemId.WORLD_PORTAL_SPAWN) {
				return "\nWorld Portal Spawn:\nSpawn ID: " + world.lookup.getInt(x, y);
			}
			
			else if ((block == ItemId.PORTAL || block == ItemId.PORTAL_INVISIBLE) && canEdit) {
				var portal:Portal = world.lookup.getPortal(x, y);
				return "\nPortal:\nID: " + portal.id + "\nPortal Target: " + portal.target + "\nRotation: " + portal.rotation;
			}
			
			else if (block == 77 || block == 83 || block == 1520) {
				return "\nNote Block:\nSound: #" + world.lookup.getInt(x, y);
			}
			
			else if (ItemId.isBlockRotateable(block)
				|| block == ItemId.SPIKE
				|| block == ItemId.SPIKE_SILVER
				|| block == ItemId.SPIKE_BLACK
				|| block == ItemId.SPIKE_RED
				|| block == ItemId.SPIKE_GOLD
				|| block == ItemId.SPIKE_GREEN
				|| block == ItemId.SPIKE_BLUE) {
				return "\nMorph:\nVariant: " + world.lookup.getInt(x, y);
			}
			
			else if (block == ItemId.TEXT_SIGN) {
				return "\nMorph:\nVariant: " + world.lookup.getSignType(x, y);
			}
			
			return "";
		}
		
		private function getPlacerText(placer:String, block:int):String
		{
			return (block == 0 ? "Removed" : "Placed") + " by " + placer.toUpperCase();
		}
	}
}