package ui.brickselector
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	import items.ItemBrick;
	
	import ui2.tabPage1;
	import ui2.tabPage2;
	import ui2.tabPage3;
	import ui2.tabPage4;
	
	public class BrickSelectorPage extends MovieClip
	{
		private var container:MovieClip = new MovieClip();
		private var _id:int;
		private var page:MovieClip;
		
		private var currentX:int = 5;
		private var currentY:int = 5;
		private var rowHeight:int;
		private var maxRows:int = Global.base.settings.visibleRows;
		
		public function BrickSelectorPage(id:int, onSelect:Function, blocksContainer:Sprite)
		{
			super();
			this._id = id;
			this.rowHeight = Global.base.settings.showPackageNames ? 30 : 20;
			
			switch (id)
			{
				case 0:
					page = new tabPage1();
					break;
				case 1:
					page = new tabPage2();
					break;
				case 2:
					page = new tabPage3();
					break;
				default:
				case 3:
					page = new tabPage4();
					break;
			}
			
			page.mouseEnabled = true;
			page.buttonMode = true;
			page.addEventListener(MouseEvent.CLICK, function(e:MouseEvent):void { onSelect(id); });
			
			addChild(page);
			blocksContainer.addChild(container);
			
			visible = false;
		}
		
		public function set selected(value:Boolean):void
		{
			page.gotoAndStop(value ? 1 : 2);
			container.visible = value;
		}
		
		public override function set visible(value:Boolean):void
		{
			super.visible = value;
			selected = false;
		}
		
		public function get id():int
		{
			return _id;
		}
		
		/**
		 * Add package to this page.
		 * Returns true when package was added or false otherwise.
		 */
		public function addPackage(bp:BrickPackage):Boolean
		{
			// If package gets out of view..
			if (currentX + bp.width + 5 >= Global.fullWidth)
			{
				// ..and it didn't reach height limit
				if (maxRows > 0 && currentY + rowHeight >= maxRows * rowHeight)
				{
					return false;
				}
				
				// ..we move it one row lower 
				currentX = 5;
				currentY += rowHeight;
			}
			
			bp.x = currentX;
			bp.y = currentY;
			
			currentX += bp.width + 5;
			container.addChild(bp);
			
			return true;
		}
		
		public function removePackages():void
		{
			currentX = 5;
			currentY = 5;
			container.removeChildren();
		}
		
		public function setMaxY(maxY:int):int
		{
			return currentY >= maxY ? currentY : maxY;
		}
		
		public function get hasBlocks():Boolean
		{
			return container.numChildren > 0;
		}
		
		public function hasBlock(blockId:int):Boolean
		{
			for (var i:int = 0; i < container.numChildren; i++) {
				var pack:BrickPackage = container.getChildAt(i) as BrickPackage;
				for each (var brick:ItemBrick in pack.content) {
					if (brick.id == blockId) {
						return true;
					}
				}
			}
			return false;
		}
	}
}