package 
{
	import flash.events.EventDispatcher;
	import flash.external.ExternalInterface;
	import flash.system.Security;

	public class ExternalInterfaceWrapper extends EventDispatcher
	{
		public function ExternalInterfaceWrapper() 
		{
			Security.allowDomain("everybodyedits.com");
			try{
				if(ExternalInterface.available){
					ExternalInterface.addCallback("showUserProfile",showUserProfile);
				}	
			}catch(e:Error){/*Do nothing*/}
		}
		
		public function showUserProfile(username:String):void
		{
			var e:NavigationEvent = new NavigationEvent(NavigationEvent.SHOW_PROFILE);
			e.username = username;
			dispatchEvent(e);
		}
	}
}