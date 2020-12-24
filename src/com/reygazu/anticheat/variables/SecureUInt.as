package com.reygazu.anticheat.variables
{
	import com.reygazu.anticheat.managers.CheatManager;
	
	public class SecureUInt
	{
		private var secureData:SecureObject;
		
		private var fake:uint;
		
		public function SecureUInt(name:String="Unnamed SecureUInt")
		{
			secureData = new SecureObject(name);
			secureData.objectValue = fake;
		}
		
		public function set value(data:uint):void
		{
			if (fake!=secureData.objectValue) 
			{
				CheatManager.getInstance().detectCheat(secureData.name,fake,secureData.objectValue);
			}
			
			
			secureData.objectValue = data;
			
			fake = data;	
		}
		
		public function get value():uint
		{
			return secureData.objectValue as uint;
		}
	}
}