package com.jac.mouse 
{
	public class BrowserInfo
	{//BrowserInfo Class
	
		//Platforms
		public static const WIN_PLATFORM:String = "win";
		public static const MAC_PLATFORM:String = "mac";
		//public static const OTHER_PLATFORM:String = "other";
		
		//Agents
		static public const SAFARI_AGENT:String = "safari";
		static public const OPERA_AGENT:String = "opera";
		static public const IE_AGENT:String = "msie";
		static public const MOZILLA_AGENT:String = "mozilla";
		static public const CHROME_AGENT:String = "chrome";
		
		private var _platform:String="undefined";
		private var _browser:String="undefined";
		private var _version:String="undefined";
	
		public function BrowserInfo(browserInfoObj:Object, platformObj:Object, agent:String) 
		{//BrowserInfo
		
			if (!browserInfoObj || !platformObj || !agent)
			{//bail
				return;
			}//bail
		
			//set version
			_version = browserInfoObj.version;
			
			//Set platform
			for (var prop:String in browserInfoObj)
			{//check props
				if (prop != "version")
				{//check for platform
				
					if (browserInfoObj[prop] == true)
					{//found it
						_browser = prop;
						break;
					}//found it
				}//check for platform
			}//check props
			
			for (var platProp:String in platformObj)
			{//check props
				if (platformObj[platProp] == true)
				{//found it
					_platform = platProp;
				}//found it
			}//check props
			
		}//BrowserInfo
		
		public function get platform():String { return _platform; }
		public function get browser():String { return _browser; }
		public function get version():String { return _version; }
	}//BrowserInfo Class

}
