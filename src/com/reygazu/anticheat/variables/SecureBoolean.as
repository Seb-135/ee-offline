package com.reygazu.anticheat.variables
{
	import com.reygazu.anticheat.managers.CheatManager;
	
	
	public class SecureBoolean
	{
		private var secureData:SecureObject;
		
		private var fake:Boolean;
		
		public function SecureBoolean(name:String="Unnamed SecureBoolean")
		{
			secureData = new SecureObject(name);
			secureData.objectValue = fake;
		}
		
		public function set value(data:Boolean):void
		{
			if (fake!=secureData.objectValue) 
			{
				CheatManager.getInstance().detectCheat(secureData.name,fake,secureData.objectValue);
			}
			
			
			secureData.objectValue = data;
			
			fake = data;	
		}
		
		public function get value():Boolean
		{
			return secureData.objectValue as Boolean;
		}
	}
}