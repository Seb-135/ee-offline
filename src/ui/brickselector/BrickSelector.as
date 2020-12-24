package ui.brickselector
{
	import blitter.Bl;
	import flash.display.MovieClip;
	import ui.BrickContainer;
	
	import com.greensock.*;
	
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.filters.BitmapFilter;
	import flash.filters.DropShadowFilter;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	import flash.ui.Keyboard;
	
	import items.ItemTab;
	
	import mx.utils.StringUtil;
	
	import ui2.tabBtnLock;
	import ui2.ui2brickselector;
	
	public class BrickSelector extends ui2brickselector
	{
		public var packages:Array = [];
		private var masker:Sprite = new Sprite;
		private var bg:Sprite = new Sprite;
		private var brickContainer:Sprite = new Sprite;
		
		private var selectedTabNum:int;
		private var tabs:Vector.<BrickSelectorTab> = new Vector.<BrickSelectorTab>();
		private var tabBlocks:BrickSelectorTab;
		private var tabAction:BrickSelectorTab;
		private var tabDecorative:BrickSelectorTab;
		private var tabBackground:BrickSelectorTab;
		
		private var locked:Boolean = true;
		private var btnLock:tabBtnLock = new tabBtnLock();
		
		private var totalHeight:int = 0;
		
		private var isup:Boolean = true;
		
		private var uix:UI2;
		
		public var search:BrickSelectorSearch;
		
		public function BrickSelector(uix:UI2)
		{
			addEventListener(Event.ADDED_TO_STAGE, handleAttach);
			
			this.uix = uix;
			
			tabBlocks = new BrickSelectorTab(ItemTab.BLOCK, brickContainer, uix);
			tabs.push(tabBlocks);
			addChild(tabBlocks);
			
			tabAction = new BrickSelectorTab(ItemTab.ACTION, brickContainer, uix);
			tabs.push(tabAction);
			addChild(tabAction);
			
			tabDecorative = new BrickSelectorTab(ItemTab.DECORATIVE, brickContainer, uix);
			tabs.push(tabDecorative);
			addChild(tabDecorative);
			
			tabBackground = new BrickSelectorTab(ItemTab.BACKGROUND, brickContainer, uix);
			tabs.push(tabBackground);
			addChild(tabBackground);
			
			search = new BrickSelectorSearch(this, uix);
			addChild(search);
			
			positionTabs();
			
			btnLock.mouseEnabled = true;
			btnLock.buttonMode = true;
			btnLock.gotoAndStop(2);
			addChild(btnLock);
			
			addChild(bg);
			addChild(brickContainer);
			
			this.addEventListener(MouseEvent.ROLL_OVER, function(e:MouseEvent):void{
				setHeight(true);
			});
			
			this.addEventListener(MouseEvent.ROLL_OUT, function(e:MouseEvent):void{
				if (!locked && !Bl.data.showingproperties)
					setHeight(false);
			});
			
			setActiveTab(0);
			
			tabBlocks.onSelect(setActiveTab);
			tabAction.onSelect(setActiveTab);
			tabDecorative.onSelect(setActiveTab);
			tabBackground.onSelect(setActiveTab);
			btnLock.addEventListener(MouseEvent.CLICK, function():void{ setLock(btnLock.currentFrame == 1); } )
			
			var shadow:BitmapFilter = new DropShadowFilter(0,45,0,1,4,4,1,3);
			bg.filters = tabBlocks.filters = tabAction.filters = tabDecorative.filters = tabBackground.filters = btnLock.filters = [shadow];
		}
		
		private function positionTabs():void
		{
			var i:int = 0;
			for each (var tab:BrickSelectorTab in tabs)
			{
				if (!tab.hasBlocks && selectedTabNum != tab.tabId) {
					tab.visible = false
				} else {
					tab.visible = true;
					tab.setPosition(5 + i * 120, - 22);
					i += 1;
				}
			}
			
			btnLock.x = 5 + i * 120;
			btnLock.y = -22;
			search.x = btnLock.x + btnLock.width + 5;
			search.y = -22;
		}
		
		public function setActiveTab(tabNum:int):void
		{
			uix.hideAllProperties();
			selectedTabNum = tabNum;
			
			// Show inactive frame on all tabs
			for each (var tab:BrickSelectorTab in tabs)
				tab.selected = false;
			
			// Show active frame on selected tab
			tabs[tabNum].selected = true;
			
			uix.hideBrickPackagePopup();
		}
		
		public function currentPageHasBlock(blockId:int):Boolean
		{
			return tabs[selectedTabNum].currentPageHasBlock(blockId);
		}
		
		public function cyclePagesAndTabs(dir:int = 1):void
		{
			if (!tabs[selectedTabNum].visible || !tabs[selectedTabNum].cyclePages(dir)) {
				selectedTabNum += dir;
				if (selectedTabNum < 0)
					selectedTabNum = tabs.length - 1;
				else if (selectedTabNum >= tabs.length)
					selectedTabNum = 0;
				
				if (tabs[selectedTabNum].visible) {
					setActiveTab(selectedTabNum);
					tabs[selectedTabNum].selectPage(dir == 1 ? 0 : -1);
				} else {
					cyclePagesAndTabs(dir);
				}
			}
		}
		
		public function setLock(locked:Boolean):void
		{
			btnLock.gotoAndStop(locked ? 2 : 1);
			this.locked = locked;
		}
		
		// Gets the search array with all space separate terms trimmed
		// Returns only these terms longer than 1 character
		private function getSearchArray(text:String):Array
		{
			var searchArray:Array = text.split(" ");
			var result:Array = [];

			for each (var search:String in searchArray)
			{
				search = StringUtil.trim(search);
				if (search.length >= 2)
					result.push(search);
			}

			return result;
		}
		
		public function filterPackages(text:String = ""):void
		{
			uix.hideBrickPackagePopup();
			removeAllPackages(false);
			
			text = StringUtil.trim(text.toLowerCase());
			
			for each (var pack:BrickPackage in packages)
			{
				if (text.length > 0 && pack.isBlockIdMatch(text))
				{
					// If this is id match we show only this block
					removeAllPackages(false);
					tabs[selectedTabNum].addPackage(pack);
					break;
				}
				
				var searchArray:Array = getSearchArray(text);

				if (searchArray.length == 0)
				{
					// Restore all blocks in package
					pack.restoreContent();
					tabs[pack.tabId].addPackage(pack);
				}
				else if (pack.isSearchMatch(searchArray))
				{
					tabs[selectedTabNum].addPackage(pack);
				}
			}
			
			redraw();
			tabs[selectedTabNum].selected = true;
			positionTabs();
		}
		
		public function addPackage(bp:BrickPackage):void
		{
			packages.push(bp);
			tabs[bp.tabId].addPackage(bp);
			positionTabs();
		}
		
		public function removeAllPackages(clear:Boolean = true):void
		{
			for (var i:int = 0; i < tabs.length; i++)
			{
				tabs[i].removePackages();
			}
			
			while (brickContainer.numChildren > 0) {
				brickContainer.removeChildAt(0);
			}
			
			if (clear)
				packages = [];
		}
		
		public function getPosition(val:int):Point
		{
			var ret:Point = null;
			for (var a:int = 0; a < packages.length; a++) {
				ret = packages[a].getPosition(val) || ret;
			}
			return ret;
		}
		
		
		public function setSelected(val:int):void
		{
			for (var a:int = 0; a < packages.length; a++) {
				packages[a].setSelected(val);
			}
		}
		
		public override function get width():Number
		{
			return Global.fullWidth;
		}
		
		public function redraw():void
		{
			setActiveTab(selectedTabNum);
			var maxY:int = 0;
			
			for each (var tab:BrickSelectorTab in tabs)
			{
				maxY = tab.setMaxY(maxY);
			}
			
			maxY += Global.base.settings.showPackageNames ? 30 : 20;
			
			var g:Graphics = bg.graphics;
			g.clear();
			g.lineStyle(1,0x7B7B7B,1);
			g.beginFill(0x323231,0.85);
			g.drawRect(0,0,Global.fullWidth-1,maxY+5);
			this.y = -maxY - 35
			
			g = masker.graphics;
			g.clear();
			g.beginFill(0xffffff,1);
			g.drawRect(-5,-5,Global.fullWidth+10,maxY+10);
			
			totalHeight = maxY;
		}
		
		public function setHeight(isUp:Boolean):void
		{
			if (isLocked) {
				return;
			}

			if (isUp) {
				TweenMax.killTweensOf(this);
				TweenMax.to(this, .2, {y:-totalHeight - 35});
			} else {
				TweenMax.to(this, .2, {delay:.25,y:-38, onComplete:function():void{
					Global.base.ui2instance.hideAllProperties();
				}});
			}
		}
		
		private function handleAttach(e:Event):void{
			trace("Brickslector added to stage");
			redraw();
		}
		
		public function get isLocked():Boolean
		{
			return locked;
		}
	}
}