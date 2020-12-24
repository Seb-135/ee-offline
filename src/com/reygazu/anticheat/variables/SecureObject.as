package com.reygazu.anticheat.variables
{
	import com.reygazu.anticheat.events.CheatManagerEvent;
	import com.reygazu.anticheat.managers.CheatManager;
	
	public dynamic class SecureObject
	{
		
		private var id:String;	
		private var _name:String;
		
		
		public function SecureObject(name:String="Unnamed SecureObject")
		{			
			_name = name;
			
			hop();				
			CheatManager.getInstance().addEventListener(CheatManagerEvent.FORCE_HOP,onForceHop);
		}
		
		public function set objectValue(value:Object):void
		{
			// delete the old variable memory location
			if (this.hasOwnProperty(id))
			{
				delete this[id];
			}
			
			// change memory location of variable
			hop();
			
			
			
			// save the variable in the new location
			this[id] = value;
			
			// save the value in a fake var as a decoy. 
			this['fake'] = value;
			
		}
		
		public function get objectValue():Object
		{
			return this[id];
		}
		
		private function hop():void
		{
			var _id:String = id;
			
			while (id==_id)
				id = String(Math.round(Math.random()*0xFFFFF));	
		}
		
		public function get name():String
		{
			return _name;			
		}
		
		// Event Handlers
		
		private function onForceHop(evt:CheatManagerEvent):void
		{
			var temp:Object = objectValue;
			
			objectValue = temp;
		}
		
	}
}