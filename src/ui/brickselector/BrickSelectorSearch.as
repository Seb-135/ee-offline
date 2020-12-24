package ui.brickselector
{
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.KeyboardEvent;
	import flash.text.TextFieldType;
	import flash.ui.Keyboard;
	
	import ui2.tabPageSearch;
	
	public class BrickSelectorSearch extends tabPageSearch
	{
		private var bselector:BrickSelector;
		private var uix:UI2;

		public function BrickSelectorSearch(bselector:BrickSelector, uix:UI2)
		{
			super();
			
			this.bselector = bselector;
			this.uix = uix;

			textfield.text = "";
			textfield.addEventListener(FocusEvent.KEY_FOCUS_CHANGE, handleTabRequest)
			textfield.addEventListener(Event.CHANGE, handleInput);
			textfield.addEventListener(KeyboardEvent.KEY_DOWN, handleKeyDown);
			textfield.addEventListener(KeyboardEvent.KEY_UP, handleKeyUp);
		}

		private function handleTabRequest(e:FocusEvent):void
		{
			e.preventDefault();
			bselector.cyclePagesAndTabs(e.shiftKey ? -1 : 1);
		}
		
		private function handleInput(e:Event):void
		{
			bselector.filterPackages(textfield.text);
		}
		
		private function handleKeyDown(e:KeyboardEvent):void
		{
			e.preventDefault();
			e.stopImmediatePropagation();
			e.stopPropagation();
			
			if (e.keyCode == Keyboard.ESCAPE) {
				if (textfield.text == "") {
					if (bselector.isLocked) {
						uix.toggleMore(false);
					} else {
						uix.stage.focus = uix.stage;
						bselector.setHeight(false);
					}
				} else {
					textfield.text = "";
					bselector.filterPackages();
				}
			}
		}
		
		private function handleKeyUp(e:KeyboardEvent):void
		{
			e.preventDefault();
			e.stopImmediatePropagation();
			e.stopPropagation();
		}
	}
}