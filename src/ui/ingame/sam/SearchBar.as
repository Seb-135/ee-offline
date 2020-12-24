package ui.ingame.sam
{
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	import flash.ui.Keyboard;
	import flash.ui.Mouse;
	import flash.ui.MouseCursor;
	
	import mx.utils.StringUtil;
	
	public class SearchBar extends Sprite
	{
		private var smileySelector:SmileyMenu;
		
		private var search:TextField;
		
		public var oHeight:int = 28;
		public var oWidth:int = 240;
		
		private var cross:SimpleButton = new SimpleButton();
		
		//Temp array for storing smileys found in search
		private var tempSmileys:Array = [];
		
		public function SearchBar(main:SmileyMenu) {
			smileySelector = main;
			
			addEventListener(Event.ADDED_TO_STAGE, handleAttach);
		}
		
		protected function updateFilter(e:Event) : void{
			//Temp array for storing smileys found in search
			tempSmileys = [];
			
			//Check if the search field is not empty
			if (search.text.length > 0){
				//Clear whitespace from search text and convert to lowercase
				var text:String = StringUtil.trim(search.text.toLowerCase());
				
				for each (var smiley:SmileyInstance in smileySelector.smilies){
					var smileyName:String = smiley.item.name.toLowerCase();
					//Check if smiley name contains the search text
					if (smileyName.indexOf(text) >= 0 || smiley.item.id.toString().indexOf(text) >= 0){
						//Check if the array doesn't already contain the same smiley
						if (tempSmileys.indexOf(smiley) == -1){
							tempSmileys.push(smiley);
						}
					}
				}
			}
			
			smileySelector.redraw(tempSmileys, search.text);
		}
		
		private function redraw():void {
			graphics.clear();
			
			//Draw the rectangle
			graphics.lineStyle(1, 0x7B7B7B);
			graphics.beginFill(0x323232);
			graphics.drawRect(0, 0, oWidth, oHeight);
			graphics.endFill();
			
			//Draw the search bar sprite
			graphics.beginFill(0x444444);
			graphics.drawRoundRect(search.x, search.y, search.width, search.height, 5, 5);
			graphics.endFill();
			
			//Draw the magnifying glass
			
			var crossSprite:Sprite = new Sprite();
			crossSprite.graphics.beginFill(0x0, 0);
			crossSprite.graphics.drawRect(0, 0, 16, 16);
			crossSprite.graphics.endFill(); //this is very retard, just to make rectangle hitbox
			
			crossSprite.graphics.lineStyle(2, 0xCCCCCC);
			crossSprite.graphics.moveTo(3, 3);
			crossSprite.graphics.lineTo(11, 11);
			crossSprite.graphics.moveTo(3, 11);
			crossSprite.graphics.lineTo(11, 3);
			crossSprite.graphics.endFill();
			
			cross.overState = cross.downState = cross.upState = cross.hitTestState = crossSprite;
		}
		
		protected function handleAttach(e:Event):void {
			removeEventListener(Event.ADDED_TO_STAGE, handleAttach);
			
			search = new TextField();
			search.defaultTextFormat = new TextFormat("Arial", 11, 0xFFFFFF);
			search.antiAliasType = AntiAliasType.NORMAL;
			search.restrict = "a-zA-Z0-9^\u0020";
			search.maxChars = 25;
			search.selectable = true;
			search.type = TextFieldType.INPUT;
			search.width = (oWidth - 25);
			search.height = (oHeight - 12);
			search.x = 5;
			search.y = (oHeight - search.height) / 2;
			
			blurred(null);
			
			addChild(search);
			
			function handleEvent(e:Event):void {
				e.preventDefault();
				e.stopImmediatePropagation()
				e.stopPropagation();
			}
			
			search.addEventListener(Event.CHANGE, updateFilter);
			search.addEventListener(MouseEvent.MOUSE_DOWN, handleEvent);
			search.addEventListener(KeyboardEvent.KEY_UP, handleEvent);
			
			search.addEventListener(FocusEvent.FOCUS_IN, focused);
			search.addEventListener(FocusEvent.FOCUS_OUT, blurred);
			
			search.addEventListener(KeyboardEvent.KEY_DOWN, function(e:KeyboardEvent):void {
				handleEvent(e);
				
				if (e.keyCode != Keyboard.ESCAPE) return;
				if (search.text == "") 
					Global.base.ui2instance.hideAll();
				else {
					search.text = "";
					updateFilter(e);
				}
			});
			
			cross.x = (oWidth - 17);
			cross.y = 7;
			cross.addEventListener(MouseEvent.CLICK, function(e:MouseEvent):void {
				search.text = "";
				updateFilter(null);
				stage.focus = search;
				
			});
			addChild(cross);
			
			redraw();
		}
		
		protected function focused(e:FocusEvent):void {
			search.textColor = 0xFFFFFF;
			if (search.text.indexOf("Search...") != -1)
				search.text = "";
		}
		
		protected function blurred(e:FocusEvent):void {
			if (search.text == "") {
				search.text = "Search...";
				search.textColor = 0xAAAAAA;
			}
		}
	}
}