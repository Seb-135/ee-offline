package events
{
	import flash.events.Event;
	
	public class JoinWorldEvent extends Event
	{
		
		public static const JOIN_WORLD:String = "join_world";
		
		public var world_id:String;
		public var world_author:String;
		public var myworld:Boolean;
		
		// 
//		public var world_key:String;
		
		public function JoinWorldEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}