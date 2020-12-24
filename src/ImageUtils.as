package
{
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import items.ItemNpc;
	
	import items.ItemAuraShape;
	import items.ItemBrick;
	import items.ItemManager;

	public class ImageUtils
	{
		public static function createImageForSmileyAndBlocks(packageId:String, smileyId:int) : BitmapData
		{
			var smiley:BitmapData = ItemManager.getSmileyById(smileyId).bmd;
			var blocks:BitmapData = createBricksImageFromPayVaultId(packageId);
			
			var result:BitmapData = new BitmapData(smiley.width + blocks.width, 26, true, 0x0);
			result.copyPixels(smiley, new Rectangle(0, 0, 26, 26), new Point(0, 0));
			result.copyPixels(blocks, new Rectangle(0, 0, blocks.width, 16), new Point(26, 5));
			return result;
		}
		
		public static function createBricksImageFromPayVaultId(id:String) : BitmapData
		{
			var bricks:Vector.<ItemBrick> = ItemManager.getBricksByPayVaultId(id);
			if (bricks.length > 0) {
				if (bricks.length > 1) {
					return createImageFromBrickArray(bricks);
				} else {
					return bricks[0].bmd;
				}
			}
			
			return null;
		}
		
		public static function  createAuraShapeImageFromPayVaultId(id:String) : BitmapData
		{
			var auraShape:ItemAuraShape = ItemManager.getAuraShapeByPayVaultId(id);
			if (auraShape == null)
				return null;
			
			return auraShape.auras[0].bmd;
		}
		
		public static function createNpcImageFromPayVaultId(id:String):BitmapData
		{
			var npc:ItemNpc = ItemManager.getNpcByPayvaultId(id);
			if (npc == null) return null;
			return npc.bmd;
		}
		
		private static function createImageFromBrickArray(source:Vector.<ItemBrick>) : BitmapData{
			var maxWidth:int = (10 * 16);
			var image:BitmapData = new BitmapData((source.length * 16 > maxWidth) ? maxWidth : source.length * 16,
												  (source.length * 16 > maxWidth) ? ((source.length * 16 > maxWidth * 2) ? ((source.length * 16  > maxWidth * 3) ? 64 : 48) : 32) : 16,
												  true,0x0);
			var a:int = 0;
			var ox:int = -16;
			var oy:int = 0;
			while (a < source.length){
				ox += 16;
				
				if (ox >= maxWidth){
					ox = 0;
					oy += 16;
				}
				
				image.copyPixels(source[a].bmd, new Rectangle(0,0,16,16), new Point(ox,oy));
				a++;
			}
			return image;
		}
	}
}