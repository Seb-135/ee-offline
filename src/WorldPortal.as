package
{
	import items.ItemId;

	public class WorldPortal
	{
		private var _id:String = "";
		private var _target:int = 0;
		
		public function WorldPortal(id:String, target:int)
		{
			_id = id;
			_target = target;
		}
		
		public function get id():String
		{
			return _id;
		}
		
		public function get target():int
		{
			return _target;
		}
	}
}