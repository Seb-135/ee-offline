package ui
{	
	import com.greensock.TweenMax;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.DropShadowFilter;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	
	import sample.ui.components.Label;
	import sample.ui.components.scroll.ScrollBox;
	
	import ui.profile.FillBox;

	public class DropDownList extends Sprite
	{
		private var arrow:Sprite;
		public var arrowContainer:Sprite;
		public var overlayContainer:Sprite;
		public var dropDownListContainer:Sprite;
		
		public var inputBox:TextField;
		
		public var ow:Number;
		public var oh:Number = 23;
		private var dropDownContainerHeight:Number = 140;
		
		private var canEditInput:Boolean;
		private var listOpen:Boolean = false;
		
		private var items:Array = null;
		
		private var scroll:ScrollBox;
		private var scrollContents:FillBox;
		
		private var dropShadow:DropShadowFilter;
		
		public function DropDownList(ow:Number, items:Array, canEditInput:Boolean = false)
		{
			this.ow = ow;
			this.items = items;
			this.canEditInput = canEditInput;
			
			dropShadow = new DropShadowFilter(1, 75, 0x000000, 1, 5, 5, .5, 1, true);
			
			arrowContainer = new Sprite();
			arrowContainer.buttonMode = true;
			arrowContainer.useHandCursor = true;
			arrowContainer.mouseEnabled = true;
			arrowContainer.addEventListener(MouseEvent.CLICK, function() : void{ showDropDownList(!listOpen); });
			addChild(arrowContainer);
			
			arrow = new Sprite();
			arrowContainer.addChild(arrow);
			arrowContainer.mouseChildren = false;
			
			inputBox = new TextField();
			inputBox.defaultTextFormat = new TextFormat("Trebuchet MS", 14, 0x000000);
			inputBox.x = 10;
			inputBox.width = (ow - (25 + inputBox.x));
			inputBox.height = oh;
			inputBox.type = (canEditInput) ? TextFieldType.INPUT : TextFieldType.DYNAMIC;
			inputBox.selectable = canEditInput;
			inputBox.filters = [dropShadow];
			addChild(inputBox);
			
			if (!canEditInput){
				overlayContainer = new Sprite();
				overlayContainer.buttonMode = true;
				overlayContainer.useHandCursor = true;
				overlayContainer.mouseEnabled = true;
				overlayContainer.mouseChildren = false;
				overlayContainer.addEventListener(MouseEvent.CLICK, function() : void{ showDropDownList(!listOpen); });
				addChild(overlayContainer);
			}
			
			dropDownListContainer = new Sprite();
			dropDownListContainer.filters = [dropShadow];
			dropDownListContainer.visible = false;
			addChildAt(dropDownListContainer, 0);
			
			initDropDownList();
			
			inputBox.text = (this.items[0] as DropDownListItem).text;
			
			redraw();
		}
		
		public function showItemNotFound(defaultText:String) : void{
			this.items = [];
			
			var item:DropDownListItem = new DropDownListItem(defaultText, ow, null);
			this.items.push(item);
				
			setItemsArray(this.items);
		}
		
		public function setItemsArray(newItems:Array) : void{
			scrollContents.removeAllChildren();
			
			this.items = [];
			
			if (newItems != null && newItems.length > 0){
				for (var i:int = 0; i < newItems.length; i++){
					var isDropDownListItem:Boolean = (newItems[i] as DropDownListItem);
					
					var item:DropDownListItem = null;
					if (isDropDownListItem){
						//Already a DropDownListItem so let just continue
						item = (newItems[i] as DropDownListItem);
					} else{
						//Not a DropDownListItem, so let's make it one!
						item = new DropDownListItem(newItems[i], ow, function(e:MouseEvent) : void{
							var ddItem:DropDownListItem = (e.target as DropDownListItem);
							
							inputBox.text = ddItem.text;
							showDropDownList(false);
						});
					}
					this.items.push(item);
					scrollContents.addChild(item);
					
					scrollContents.refresh();
					scroll.refresh();
					
					if (scrollContents.numChildren < 7){
						scroll.height = (item.height * scrollContents.numChildren) + 10;
						dropDownContainerHeight = scroll.height;
					} else {
						scroll.height = dropDownContainerHeight;
					}
				}
			}
			
			redraw();
		}
		
		private function initDropDownList() : void{
			scrollContents = new FillBox(0, ow);
			scrollContents.forceScale = false;
			
			scroll = new ScrollBox().margin(3, 3, 3, 3).add(scrollContents);
			scroll.visible = false;
			scroll.scrollMultiplier = 6;
			scroll.width = (ow - 5);
			
			dropDownListContainer.addChild(scroll);
			
			setItemsArray(this.items);
			
			redraw();
		}
		
		private function redraw() : void{
			graphics.clear();
			graphics.beginFill(0xFFFFFF);
			graphics.drawRoundRect(0, 0, ow, oh, 5, 5);
			graphics.endFill();
			
			if (!canEditInput){
				overlayContainer.graphics.clear();
				overlayContainer.graphics.beginFill(0x0, 0);
				overlayContainer.graphics.drawRoundRect(0, 0, ow, oh, 5, 5);
				overlayContainer.graphics.endFill();
			}
			
			//Container for the arrow (so clickable arrow is larger than the arrow)
			arrowContainer.graphics.clear();
			arrowContainer.graphics.beginFill(0x0, 0);
			arrowContainer.graphics.drawRect(0, 0, 25, oh);
			arrowContainer.graphics.endFill();
			arrowContainer.x = (ow - 25);
			
			//Drawing the triangle, 13x8
			arrow.graphics.clear();
			arrow.graphics.beginFill(0xBABABA);
			arrow.graphics.moveTo(0, 0);
			arrow.graphics.lineTo(13, 0);
			arrow.graphics.lineTo((13 / 2), 8);
			arrow.graphics.lineTo(0, 0);
			arrow.graphics.endFill();
			arrow.x = (25 - 13) / 2;
			arrow.y = (oh - 8) / 2;
			
			dropDownListContainer.graphics.clear();
			dropDownListContainer.graphics.beginFill(0xFFFFFF);
			dropDownListContainer.graphics.drawRoundRectComplex(0, 0, (ow - 5), dropDownContainerHeight, 0, 0, 5, 5);
			dropDownListContainer.x = 5;
			dropDownListContainer.y = oh;
		}
		
		private function flipArrow() : void{
			listOpen = !listOpen;
			
			switch (listOpen){
				case true:{
					arrow.graphics.clear();
					arrow.graphics.beginFill(0xBABABA);
					arrow.graphics.moveTo(0, 8);
					arrow.graphics.lineTo((13 / 2), 0);
					arrow.graphics.lineTo(13, 8);
					arrow.graphics.lineTo(0, 8);
					arrow.graphics.endFill();
				} break;
				
				case false:{
					arrow.graphics.clear();
					arrow.graphics.beginFill(0xBABABA);
					arrow.graphics.moveTo(0, 0);
					arrow.graphics.lineTo(13, 0);
					arrow.graphics.lineTo((13 / 2), 8);
					arrow.graphics.lineTo(0, 0);
					arrow.graphics.endFill();
				} break;
			}
		}
		
		public function showDropDownList(active:Boolean) : void{
			flipArrow();
			
			dropDownListContainer.visible = active;
			TweenMax.to(dropDownListContainer, 0.4,{
				alpha:(active) ? 1 : 0
			});
			
			scroll.visible = active;
			TweenMax.to(scroll, 0.4,{
				alpha:(active) ? 1 : 0
			});
		}
	}
}