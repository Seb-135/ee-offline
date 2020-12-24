package items
{
	public class ItemBrickPackage
	{
		public var name:String;
		public var description:String;
		public var tags:Array;
		public var bricks:Vector.<ItemBrick> = new Vector.<ItemBrick>();

		public function ItemBrickPackage(name:String, description:String, tags:Array = null) {
			this.name = name;
			this.description = description;
			this.tags = tags || [];
		}
		public function addBrick(item:ItemBrick):void{
			bricks.push(item);			
		}
	}
}