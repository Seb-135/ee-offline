package com.reygazu.anticheat.variables
{
	import com.reygazu.anticheat.managers.CheatManager;
	
	public class SecureString
	{
		private var secureData:SecureObject;
		
		private var fake:String;
		
		public function SecureString(name:String="Unnamed SecureString")
		{
			secureData = new SecureObject(name);
			secureData.objectValue = fake;
		}
		
		public function set value(data:String):void
		{
			if (fake!=secureData.objectValue) 
			{
				CheatManager.getInstance().detectCheat(secureData.name,fake,secureData.objectValue);
			}
			
			
			secureData.objectValue = data;
			
			fake = data;		
		}
		
		public function get value():String
		{
			return secureData.objectValue as String;
		}
	}
}