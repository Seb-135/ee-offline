package utilities 
{
	public class Random {
		
		//note that this function can't return the @max value because it's the limit
		public static function nextInt(min:int, max:int):int {
			return Math.floor(Math.random() * (max - min) + min);
		}
		
		public static function percent(chance:Number):Boolean {
			return (Math.random() * 100) < chance;
		}
	}

}