package ui
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	import sample.ui.components.Label;

	public class DropDownListItem extends Sprite
	{
		private var showHighlight:Boolean = false;
		
		public var text:String;
		
		private var title:TextField;
		
		private var ow:Number;
		
		private var callBack:Function;
		
		public function DropDownListItem(text:String, ow:Number, callBack:Function)
		{
			this.text = text;
			this.ow = ow;
			
			title = new TextField();
			title.defaultTextFormat = new TextFormat("Trebuchet MS", 14, 0x000000);
			title.text = text;
			title.x = 20;
			title.autoSize = TextFieldAutoSize.LEFT;
			title.mouseEnabled = false;
			addChild(title);
			
			if (callBack != null){
				this.callBack = callBack;
				
				buttonMode = true;
				useHandCursor = true;
				mouseChildren = false;
				
				addEventListener(MouseEvent.CLICK, handleMouse);
				addEventListener(MouseEvent.MOUSE_OVER, handleMouse);
				addEventListener(MouseEvent.MOUSE_OUT, handleMouse);
			}
			
			mouseEnabled = (callBack != null);
			
			redraw();
		}
		
		private function redraw() : void{
			graphics.clear();
			graphics.beginFill((showHighlight) ? 0xCCCCCC : 0xFFFFFF);
			graphics.drawRect(0, 0, ow, height);
			graphics.endFill();
		}
		
		protected function handleMouse(e:MouseEvent) : void{
			switch(e.type){
				case MouseEvent.CLICK:{
					callBack(e);
				} break;
				case MouseEvent.MOUSE_OVER:{
					showHighlight = true;
				} break;
				
				case MouseEvent.MOUSE_OUT:{
					showHighlight = false;
				} break;
			}
			
			redraw();
		}
	}
}