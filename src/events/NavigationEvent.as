package events
{
	import flash.events.Event;
	
	public class NavigationEvent extends Event
	{
		
		public static const SHOW_PROFILE:String = "show_profile";
		public static const START_OPENWORLD:String = "start_openworld";
		public static const INVITE_FRIEND:String = "invite_friend";
		public static const LOGOUT:String = "logout";
		public static const SHOW_GOLD_ABOUT:String = "show_gold_about";
		public static const SHOW_HELP:String = "show_help";
		public static const SHOW_TERMS:String = "show_terms";
		
//		public static const JOIN_WORLD:String = "join_world";
		
		public var username:String;
		
//		public var world_id:String;
//		public var world_author:String;
//		
		public function NavigationEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}