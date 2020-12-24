package ui.brickselector
{
	import com.greensock.TweenMax;
	import flash.events.ContextMenuEvent;
	import flash.ui.ContextMenu;
	import flash.ui.ContextMenuItem;
	import items.ItemLayer;
	import ui.ConfirmPrompt;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Graphics;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.ColorTransform;
	import flash.geom.Point;
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.clearInterval;
	import flash.utils.setTimeout;
	
	import flash.net.FileReference;
	import flash.events.Event;
	import flash.net.FileFilter;
	import flash.display.Loader;
	
	import items.ItemBrick;
	import items.ItemId;
	import items.ItemManager;
	import items.ItemTab;
	
	import mx.utils.StringUtil;
	
	import ui.HoverLabel;
	
	import ui2.ui2selector;
	
	public class BrickPackage extends MovieClip
	{
		public var content:Vector.<ItemBrick>;
		public var tabId:int;
		public var title:String;
		protected var uix:UI2;
		private var tags:Array;
		
		private var highlight:Bitmap = new Bitmap(new ui2selector());
		private var rotatableHighlight:Bitmap = new Bitmap(new ui2selector());
		
		private var hoverLabel:HoverLabel = new HoverLabel();
		private var hoverTimer:uint;
		private var hoverId:int;
		private var visibleBlocks:int;
		private var defaultVisibleBlocks:int;
		private var isPopup:Boolean;
		private var textVisible:Boolean;
		private var bg:Sprite = new Sprite();
		
		protected var blocks:Sprite = new Sprite();
		protected var blocksBitmap:Bitmap;
		protected var textField:TextField = new TextField();
		
		private var temporaryContent:Vector.<ItemBrick>;
		private var selectedBlockId:int;
		
		public function BrickPackage(title:String, content:Vector.<ItemBrick>, uix:UI2, tabId:int, tags:Array, textVisible:Boolean = true, visibleBlocks:int = 0, isPopup:Boolean = false)
		{
			super();
			
			this.title = title;
			this.content = content;
			this.uix = uix;
			this.tabId = tabId;
			this.tags = tags;
			this.visibleBlocks = visibleBlocks > 0 ? Math.min(content.length, visibleBlocks) : content.length;
			this.defaultVisibleBlocks = this.visibleBlocks;
			this.isPopup = isPopup;
			this.textVisible = textVisible || isPopup;
			
			if (isPopup)
				addChild(bg);
			
			if (this.textVisible)
				addText(title);
			
			hoverLabel.visible = false;
			
			blocksBitmap = new Bitmap();
			blocks.addChild(blocksBitmap);
			if (isPopup || !textVisible)
				blocks.x = 2;
			else
				blocks.x = textField.width >= (16 * this.visibleBlocks) ? (textField.width - 16 * this.visibleBlocks)/2 : 2;
				
			blocks.y = this.textVisible ? 12 : 0;
			addChild(blocks);
			
			updateContent(title, content);
			
			blocks.useHandCursor = true;
			blocks.buttonMode = true;
			blocks.addEventListener(MouseEvent.MOUSE_DOWN, handleMouseDown);
			
			if (!isCollapsed)
			{
				blocks.addEventListener(MouseEvent.MOUSE_OVER, handleMouse);
				blocks.addEventListener(MouseEvent.MOUSE_OUT, handleMouse);
				blocks.addEventListener(MouseEvent.MOUSE_MOVE, handleMouseMove);
			}
			
			blocks.addEventListener(KeyboardEvent.KEY_DOWN, handleKeyDown);
			
			blocks.addChild(highlight);
			blocks.addChild(rotatableHighlight);
			rotatableHighlight.bitmapData.colorTransform(rotatableHighlight.bitmapData.rect, new ColorTransform(0, 0, 1, 1, 30, 230, 255, 0));
			rotatableHighlight.visible = false;
		}
		
		public function restoreContent():void
		{
			visibleBlocks = defaultVisibleBlocks;
			updateContent(title, content, false, true);
		}
		
		private function isMatchIn(text:String, searchArray:Array):Boolean
		{
			var matchText:String = text.toLowerCase();
			for each (var search:String in searchArray)
			{
				if (StringUtil.trim(matchText).indexOf(search) != -1)
				{
					return true;
				}
			}
			return false;
		}
		
		// Retruns terms that don't match with any of provided tags
		private function getNonMatchingTerms(tags:Array, searchArray:Array):Array
		{
			var newSearchArray:Array = [];
			
			for each (var searchTerm:String in searchArray)
			{
				var matches:Boolean = false;

				for each (var tag:String in tags)
				{
					tag = tag.toLowerCase();
					
					if (tag.indexOf(searchTerm) != -1)
					{
						matches = true;
						break;
					}
				}
				
				// If no tag matches this search term we add it for later checks
				if (!matches)
					newSearchArray.push(searchTerm);
			}

			return newSearchArray;
		}
		
		public function isBlockIdMatch(text:String):Boolean
		{
			text = StringUtil.trim(text);
			for each (var brick:ItemBrick in content)
			{
				if (brick.id.toString() == text)
				{
					var vector:Vector.<ItemBrick> = new Vector.<ItemBrick>();
					vector.push(brick);
					updateContent(title, vector, true, true);
					return true;
				}
			}
			return false;
		}

		public function isSearchMatch(searchArray:Array):Boolean
		{
			// Update the content to revert previous filter (if there was one)
			restoreContent();
			
			// Check matches for title
			searchArray = getNonMatchingTerms([title], searchArray);

			// If all search terms match we return happy that all is good
			// Similar thing is done for rest of the matches
			if (searchArray.length == 0)
				return true;
			
			// Check matches for package tags
			searchArray = getNonMatchingTerms(tags, searchArray);
			if (searchArray.length == 0)
				return true;
			
			var matching:Vector.<ItemBrick> = new Vector.<ItemBrick>();
			for each (var brick:ItemBrick in content)
			{
				// Brick tags or tab match rest of search terms
				var blockSearchArray:Array = getNonMatchingTerms(brick.tags, searchArray);
				if (blockSearchArray.length == 0
					|| getNonMatchingTerms(ItemTab.toNamesArray(brick.tab), blockSearchArray).length == 0)
					matching.push(brick);
			}
			
			if (matching.length > 0)
			{
				// Update content to display only blocks that have matching tags
				updateContent(title, matching, true, true);
				return true;
			}
			
			return false;
		}
		
		public function updateContent(title:String, content:Vector.<ItemBrick>, updateLength:Boolean = false, temporary:Boolean = false):void
		{
			if (temporary) {
				temporaryContent = content;
			} else {
				this.content = content;
				temporaryContent = null;
			}
			
			if (updateLength)
				visibleBlocks = content.length;
			
			updateText(title);
			
			highlight.visible = false;
			highlight.x = 0;
			rotatableHighlight.visible = false;
			rotatableHighlight.x = 0;
			
			blocksBitmap.bitmapData = new BitmapData(16 * visibleBlocks, 16, false, 0xffffffff);
			for (var i:int = 0; i < visibleBlocks; i++)
			{
				ItemManager.bricks[content[i].selectorBG].drawTo(blocksBitmap.bitmapData, i*16, 0);
				content[i].drawTo(blocksBitmap.bitmapData, i*16, 0);
			}
			
			if (isPopup)
			{
				var g:Graphics = bg.graphics;
				g.clear();
				g.lineStyle(1,0x7B7B7B,1);
				g.beginFill(0x323231,0.85);
				var w:int = content.length*16 > textField.width ? content.length*16 : textField.width;
				g.drawRect(-3, -3, w + 8, 34);
			}
		}
		
		private function addText(text:String):void
		{
			textField.embedFonts = true;
			textField.selectable = true;
			textField.antiAliasType = AntiAliasType.ADVANCED;
			textField.mouseEnabled = false;
			textField.defaultTextFormat = new TextFormat("visitor", 13, 0xffffff);
			addChild(textField);
			
			updateText(text);
		}
		
		private function updateText(text:String):void
		{
			if (!textVisible)
				return;
			
			textField.text = text;
			textField.width = textField.textWidth + 5;
			textField.height = textField.textHeight + 5;
		}
		
		private function select(id:int):void
		{
			if (id >= this.visibleBlocks)
				return;
			var blockId:int = temporaryContent != null ? temporaryContent[id].id : content[id].id;
			uix.setSelected(blockId);
			setSelected(blockId);
		}
		
		public function getPosition(val:int):Point
		{
			if (!visible)
				return null;
			
			for (var i:int = 0; i < this.visibleBlocks; i++)
			{
				if (content[i].id == val) {
					return new Point(x + i*16 + blocks.x + 8, y + blocks.y);
				}
			}
			return null;
		}
		
		public function setSelected(val:int):void
		{
			selectedBlockId = val;
			for (var i:int = 0; i < this.visibleBlocks; i++)
			{
				var blockId:int = temporaryContent != null ? temporaryContent[i].id : content[i].id;
				if (blockId == val)
				{
					highlight.x = i * 16;
					highlight.visible = true;
					return;
				}
			}
			
			highlight.visible = false;
		}
		
		private function handleMouseDown(e:MouseEvent):void
		{
			var offset:int = blocks.mouseX/16 >> 0;
			if (offset >= this.visibleBlocks)
				return;
			
			var block:ItemBrick = temporaryContent != null ? temporaryContent[offset] : content[offset];
			
			if (isCollapsed)
				uix.toggleBrickPackagePopup(title, content, block.id == selectedBlockId);
			else if (!isPopup)
				uix.hideBrickPackagePopup();
			
			select(offset);
			uix.dragIt(block);
		}
		
		private function handleMouse(e:MouseEvent):void
		{
			if (e.type == MouseEvent.MOUSE_OVER)
			{
				var offset:int = blocks.mouseX/16 >> 0;
				if (offset >= this.visibleBlocks)
					return;
				
				hoverTimer = setTimeout(showHoverLabel, 800);
				hoverId = temporaryContent != null ? temporaryContent[offset].id : content[offset].id;
			}
			else
			{
				hoverLabel.visible = false;
				clearInterval(hoverTimer);
				rotatableHighlight.visible = false;
			}
		}
		
		private function handleMouseMove(event:MouseEvent = null):void
		{
			var offset:int = blocks.mouseX/16 >> 0
			if (offset >= this.visibleBlocks) 
			{
				return;
			}
			
			hoverId = temporaryContent != null ? temporaryContent[offset].id : content[offset].id;
			
			var isRotatable:Boolean = ItemId.isBlockRotateable(hoverId)
				|| hoverId == ItemId.SPIKE
				|| hoverId == ItemId.SPIKE_SILVER
				|| hoverId == ItemId.SPIKE_BLACK
				|| hoverId == ItemId.SPIKE_RED
				|| hoverId == ItemId.SPIKE_GOLD
				|| hoverId == ItemId.SPIKE_GREEN
				|| hoverId == ItemId.SPIKE_BLUE
				|| hoverId == ItemId.PORTAL
				|| hoverId == ItemId.PORTAL_INVISIBLE
				|| hoverId == ItemId.TEXT_SIGN;
			
			if (isRotatable)
			{
				rotatableHighlight.x = offset * 16;
				rotatableHighlight.visible = true;
			}
			else
			{
				rotatableHighlight.visible = false;
			}
			
			if (hoverLabel.visible)
			{
				var desc:String = ItemManager.getBlockDescription(hoverId);
				var text:String = "";
				
				if (desc.length > 0)
					text += desc + "\n\n";
				
				text += "id: " + hoverId;
				
				if (isRotatable)
					text += "\nmorphable";
				if (ItemManager.getBrickById(hoverId).requiresOwnership)
					text += "\nowner-only";
				if (ItemId.isClimbable(hoverId))
					text += "\nclimbable";
				if (ItemId.isSlippery(hoverId))
					text += "\nslippery";
				if (ItemId.canJumpThroughFromBelow(hoverId))
					text += "\none-way";
				
				var blockTags:Array = tags.concat(ItemManager.getBlockTags(hoverId));
				if (blockTags.length > 0)
					text += "\n\ntags:\n" + blockTags.join(", ");
				
				hoverLabel.draw(text);
				
				hoverLabel.x = uix.mouseX;
				if (hoverLabel.x > uix.width/2)
				{
					hoverLabel.x -= hoverLabel.w + 12;
				}
				else
				{
					hoverLabel.x += 12;
				}
				if (uix.mouseY + hoverLabel.height/2 > -12)
					hoverLabel.y = -hoverLabel.height - 12;
				else
					hoverLabel.y = uix.mouseY - hoverLabel.height/2;
			}
		}
		
		private function handleKeyDown(event:KeyboardEvent = null):void
		{
			if (hoverId >= 0)
			{
				var pos:int = event.keyCode - 48;
				if (pos >= 1 && pos <= 9)
				{
					Global.base.ui2instance.favoriteBricks.setDefault(pos, ItemManager.bricks[hoverId]);
				}
			}
		}
		
		private function showHoverLabel():void
		{
			if (!uix.contains(hoverLabel))
				uix.addChild(hoverLabel);
			hoverLabel.alpha = 0;
			TweenMax.to(hoverLabel, 0.25, {alpha:1});
			hoverLabel.draw(hoverId.toString());
			hoverLabel.visible = true;
			handleMouseMove();
		}
		
		private function get isCollapsed():Boolean
		{
			return visibleBlocks < content.length;
		}
	}
}