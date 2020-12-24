package utilities 
{
	import flash.geom.Point;
	public class MathUtil 
	{
		
		public static function distance(ax:Number, ay:Number, bx:Number, by:Number):Number {
			return Math.sqrt(square(ax-bx) + square(ay-by));
		}
		
		public static function distanceSqr(ax:Number, ay:Number, bx:Number, by:Number):Number {
			return square(ax-bx) + square(ay-by);
		}
		
		//real distance between 2 points
		public static function distancePoint(a:Point, b:Point):Number {
			return Math.sqrt(square(a.x-b.x) + square(a.y-b.y));
		}
		
		//distance between 2 points squared
		public static function distancePointSqr(a:Point, b:Point):Number {
			return square(a.x-b.x) + square(a.y-b.y);
		}
		
		//doesn't require Math.sqrt, runs a bit faster.
		public static function inRange(ax:Number, ay:Number, bx:Number, by:Number, range:Number):Boolean {
			// a^2 + b^2 = c^2 => c = sqrt(a^2 + b^2)
			return square(bx - ax) + square(by - ay) < square(range);
		}
		public static function inRangePoint(a:Point, b:Point, range:Number):Boolean {
			return inRange(a.x, a.y, b.x, b.y, range);
		}
		
		private static function square(value:Number):Number {
			return value * value;
		}
	}

}