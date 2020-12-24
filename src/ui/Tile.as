package ui
{
	public class Tile
	{
		
		public var layer:int;
		public var xo:int;
		public var yo:int;
		public var value:int;
		public var properties:Object;
		
		public function Tile(layer:int,xo:int,yo:int,value:int, properties:Object)
		{
			this.layer = layer;
			this.xo = xo;
			this.yo = yo;
			this.value = value;
			this.properties = properties;
		}
		
		public function equals(tile:Tile):Boolean
		{
			return (tile.layer == layer && tile.xo == xo && tile.yo == yo);
		}
		
	}
}