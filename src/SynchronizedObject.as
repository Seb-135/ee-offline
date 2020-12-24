package
{
	import blitter.Bl;
	import blitter.BlObject;
	
	public class SynchronizedObject extends BlObject
	{
		protected var _speedX:Number = 0;
		protected var _speedY:Number = 0;
		protected var _modifierX:Number = 0;
		protected var _modifierY:Number = 0;
		
		protected var _baseDragX:Number = Config.physics_base_drag;
		protected var _baseDragY:Number = Config.physics_base_drag;
		protected var _no_modifier_dragX:Number = Config.physics_no_modifier_drag;
		protected var _no_modifier_dragY:Number = Config.physics_no_modifier_drag;
		protected var _water_drag:Number = Config.physics_water_drag;
		protected var _water_buoyancy:Number = Config.physics_water_buoyancy;
		protected var _mud_drag:Number = Config.physics_mud_drag;
		protected var _mud_buoyancy:Number = Config.physics_mud_buoyancy;
		protected var _lava_drag:Number = Config.physics_lava_drag;
		protected var _lava_buoyancy:Number = Config.physics_lava_buoyancy;
		protected var _toxic_drag:Number = Config.physics_toxic_drag;
		protected var _toxic_buoyancy:Number = Config.physics_toxic_buoyancy;
		protected var _boost:Number = Config.physics_boost;
		protected var _gravity:Number = Config.physics_gravity;

		public var mox:Number = 0;
		public var moy:Number = 0;
		
		public var mx:Number = 0;
		public var my:Number = 0;

		public var last:Number = 0;
		protected var offset:Number = 0;

		
		public function SynchronizedObject()
		{
			super();
			last = new Date().time;
		}
		
		//Moved to player
/*		public override function update():void{
		}*/
	
		/* Getters and setters galore */
		private var mult:Number = Config.physics_variable_multiplyer;
		public function get speedX():Number	{
			if (isNaN(_speedX)) {
				return 0;
			}			
			return _speedX * mult;
		}
		
		public function set speedX(value:Number):void{
			_speedX = value / mult;
		}
		
		public function get speedY():Number{
			if (isNaN(_speedY)) {
				return 0;
			}
			return _speedY * mult;
		}
		
		public function set speedY(value:Number):void{
			_speedY = value / mult;
		}
		
		public function get modifierX():Number{
			if (isNaN(_modifierX)) {
				return 0;
			}
			return _modifierX * mult;
		}
		
		public function set modifierX(value:Number):void{
			_modifierX = value / mult;
		}
		
		public function get modifierY():Number{
			if (isNaN(_modifierY)) {
				return 0;
			}
			return _modifierY* mult;
		}
		
		public function set modifierY(value:Number):void{
			_modifierY = value / mult;
		}
	}
}