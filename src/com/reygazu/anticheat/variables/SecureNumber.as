package com.reygazu.anticheat.variables
{
	import com.reygazu.anticheat.managers.CheatManager;
	
	public class SecureNumber
	{
		private var secureData:SecureObject;
		
		private var fake:Number;
		
		public function SecureNumber(name:String="Unnamed SecureNumber")
		{
			secureData = new SecureObject(name);
			secureData.objectValue = fake;
		}
		
		public function set value(data:Number):void
		{
			if (fake!=secureData.objectValue && !isNaN(secureData.objectValue as Number)) 
			{
				CheatManager.getInstance().detectCheat(secureData.name,fake,secureData.objectValue);
			}
			
			
			secureData.objectValue = data;
			
			fake = data;	
		}
		
		public function get value():Number
		{
			return secureData.objectValue as Number;
		}
	}
}