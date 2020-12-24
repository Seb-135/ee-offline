package items
{
	public class ItemTab
	{
		public static const BLOCK:int = 0;
		public static const ACTION:int = 1;
		public static const DECORATIVE:int = 2;
		public static const BACKGROUND:int = 3;
		
		public static function toNamesArray(id:int):Array
		{
			switch (id)
			{
				case BLOCK:
					return ["foreground", "block", "fg"];
				case ACTION:
					return ["action"];
				case DECORATIVE:
					return ["decoration", "decorative"];
				case BACKGROUND:
					return ["background", "bg"];
				default:
					return [];
			}
		}
	}
}