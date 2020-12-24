package com.reygazu.anticheat.variables
{
	import com.reygazu.anticheat.managers.CheatManager;
	
	public class SecureInt
	{
		private var secureData:SecureObject;
		
		private var fake:int;
		
		public function SecureInt(name:String="Unnamed SecureInt")
		{
			secureData = new SecureObject(name);
			secureData.objectValue = fake;
		}
		
		public function set value(data:int):void
		{
			// check if fake wasnt modified externaly
			
			if (fake!=secureData.objectValue) 
			{
				CheatManager.getInstance().detectCheat(secureData.name,fake,secureData.objectValue);
			}
			
			
			secureData.objectValue = data;
			
			fake = data;
		}
		
		public function get value():int
		{
			return secureData.objectValue as int;
		}
	}
}