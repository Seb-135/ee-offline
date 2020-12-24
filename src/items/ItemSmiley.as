package items
{
	import flash.display.BitmapData;

	public class ItemSmiley
	{
		public var id:int
		public var name:String;
		public var payvaultid:String = null;
		public var description:String;
		public var bmd:BitmapData;
		public var minimapcolor:uint;
		public var bmdGold:BitmapData;
		
		public function ItemSmiley(id:int, name:String, description:String, bmd:BitmapData, payvaultid:String, minimapcolor:uint, bmdGold:BitmapData) {
			this.id = id;
			this.name = name;
			this.description = description;
			this.bmd = bmd;
			this.payvaultid = payvaultid;
			this.minimapcolor = minimapcolor;
			this.bmdGold = bmdGold;
		}
	}
}