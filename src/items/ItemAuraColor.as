package items
{
	public class ItemAuraColor
	{
		public var id:int;
		public var name:String;
		public var payVaultId:String;
		
		public function ItemAuraColor(id:int, name:String, payVaultId:String)
		{
			this.id = id;
			this.name = name;
			this.payVaultId = payVaultId;
		}
		
		public static const WHITE:uint = 0xFFFFFF; //white template + white color? don't ask.
		public static const RED:uint = 0xFF0000;
		public static const BLUE:uint = 0x0080FF;
		public static const YELLOW:uint = 0xFFD400;
		public static const GREEN:uint = 0x13D213;
		public static const PURPLE:uint = 0xAA00FF;
		public static const ORANGE:uint = 0xFF5500;
		public static const CYAN:uint = 0x00FFFF;
		public static const GOLD:uint = 0xFFD700;
		public static const PINK:uint = 0xFF80C0;
		public static const INDIGO:uint = 0x0000FF;
		public static const LIME:uint = 0xAAFF00;
		public static const BLACK:uint = 0x000000;
		public static const TEAL:uint = 0x89E9B9;
		public static const GREY:uint = 0x7F7F7F;
		public static const AMARANTH:uint = 0xff0047;
	}
}