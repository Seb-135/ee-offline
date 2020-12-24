package blitter
{
	public class BlState extends BlContainer
	{
		
		public static const STATE_ALIGN_LEFT:String = "left"; 
		public static const STATE_ALIGN_CENTER:String = "center"; 
		public static const STATE_ALIGN_RIGHT:String = "right"; 
		
		public var stopRendering:Boolean = false;
		
		public function BlState()
		{
		}		
		
		public function resize():void
		{
		}
		
		public function killed():void
		{
		}
		
		public function get align():String{
			return STATE_ALIGN_CENTER;
		}
	}
}