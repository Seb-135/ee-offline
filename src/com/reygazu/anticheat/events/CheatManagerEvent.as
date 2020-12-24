package com.reygazu.anticheat.events
{
	import flash.events.Event;
	
	public class CheatManagerEvent extends Event
	{
		
		public static var FORCE_HOP:String = "forceHop";
		public static var CHEAT_DETECTION:String = "cheatDetection";
		
		public var data:Object;
		
		public function CheatManagerEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}