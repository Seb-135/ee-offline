package ui.brickselector
{
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	import items.ItemTab;
	
	import ui2.tabAction;
	import ui2.tabBackground;
	import ui2.tabBlocks;
	import ui2.tabDecorative;
	import ui2.tabPage1;
	import ui2.tabPage2;

	public class BrickSelectorTab extends Sprite
	{
		public var tabId:int;
		private var tab:MovieClip;
		private var blocksContainer:Sprite;
		private var pagesContainer:Sprite = new Sprite();
		private var uix:UI2;
		
		public var pages:Vector.<BrickSelectorPage> = new Vector.<BrickSelectorPage>();
		
		private var currentPage:int = 0;
		
		public function BrickSelectorTab(tabId:int, blocksContainer:Sprite, uix:UI2)
		{
			super();
			
			this.tabId = tabId;
			this.blocksContainer = blocksContainer;
			this.uix = uix;
			
			switch (tabId)
			{
				case ItemTab.BLOCK:
					tab = new tabBlocks();
					break;
				case ItemTab.ACTION:
					tab = new tabAction();
					break;
				case ItemTab.DECORATIVE:
					tab = new tabDecorative();
					break;
				case ItemTab.BACKGROUND:
					tab = new tabBackground();
					break;
			}
			
			addChild(pagesContainer);
			
			addPage();
			
			tab.mouseEnabled = true;
			tab.buttonMode = true;
			tab.gotoAndStop(2);
			addChild(tab);
		}
		
		private function addPage():BrickSelectorPage
		{
			var newPage:BrickSelectorPage = new BrickSelectorPage(pages.length, selectPage, blocksContainer);
			newPage.x = 22 * pages.length;
			pagesContainer.addChild(newPage);
			
			pages.push(newPage);
			return newPage;
		}
		
		public function selectPage(pageId:int):void
		{
			if (pageId == -1) {
				pageId = Math.max(0, pages.length - 1);
			}
			currentPage = pageId;
			for each (var page:BrickSelectorPage in pages)
			{
				page.selected = page.id == pageId;
			}
			
			uix.hideBrickPackagePopup();
			uix.hideAllProperties();
		}
		
		public function cyclePages(dir:int = 1):Boolean
		{
			var newPage:int = currentPage + dir;
			if (newPage < 0 || newPage >= pages.length)
				return false;

			selectPage(newPage);
			return true;
		}
		
		public function onSelect(action:Function):void
		{
			tab.addEventListener(MouseEvent.CLICK, function(e:MouseEvent):void { action(tabId); });
		}
		
		public function set selected(value:Boolean):void
		{
			tab.gotoAndStop(value ? 1 : 2);
			for each (var page:BrickSelectorPage in pages)
			{
				page.visible = value && pages.length > 1;
			}
			
			if (value && pages.length > 0)
			{
				pages[currentPage].selected = true;
			}
		}
		
		public function get selected():Boolean
		{
			return tab.currentFrame == 1;
		}
		
		public function setPosition(tx:int, ty:int):void
		{
			tab.x = tx;
			tab.y = ty;
			pagesContainer.x = tx;
			pagesContainer.y = ty - 21;
		}
		
		public function addPackage(bp:BrickPackage):void
		{
			if (pages.length == 0)
			{
				addPage();
			}
			
			var lastPage:BrickSelectorPage = pages[pages.length - 1];
			var added:Boolean = lastPage.addPackage(bp);
			
			if (!added)
			{
				var newPage:BrickSelectorPage = addPage();
				// Update selected value to toggle page states
				selected = selected;
				newPage.addPackage(bp);
			}
		}
		
		public function removePackages():void
		{
			while (pagesContainer.numChildren > 0) {
				pagesContainer.removeChildAt(0);
			}
			pages = new Vector.<BrickSelectorPage>();
			currentPage = 0;
		}
		
		public function setMaxY(maxY:int):int
		{
			for each (var page:BrickSelectorPage in pages)
				maxY = page.setMaxY(maxY)
			
			return maxY;
		}
		
		public function get hasBlocks():Boolean
		{
			if (pages.length == 0)
				return false;
			
			if (pages.length > 1)
				return true;
			
			return pages[0].hasBlocks;
		}
		
		public function currentPageHasBlock(blockId:int):Boolean
		{
			return pages[currentPage].hasBlock(blockId);
		}
	}
}