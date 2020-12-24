package
{
	import items.ItemId;

	public class Portal
	{
		private var _id:int = 0;
		private var _target:int = 0;
		private var _rotation:int = 0;
		private var _type:int = 0;
		
		public function Portal(id:int, target:int, rotation:int, type:int = ItemId.PORTAL)
		{
			_id = id;
			_target = target;
			_rotation = rotation;
			_type = type;
		}
		
		public function get id():int
		{
			return _id;
		}
		
		public function get target():int
		{
			return _target;
		}
		
		public function get rotation():int
		{
			return _rotation;
		}
		
		public function get type():int
		{
			return _type;
		}
	}
}