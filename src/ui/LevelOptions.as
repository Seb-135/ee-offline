package ui {
	import com.greensock.*;
	import com.greensock.easing.*;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.text.TextFieldType;
	
	public class LevelOptions extends assets_leveloptions
	{
		private var confirmAction:String;
		private var currentPage:int = 1;
		
		public var backgroundColorSelector:BackgroundColorSelector;
		
		public function LevelOptions(levelname:String, description:String, minimapEnabled:Boolean, ui2:UI2)
		{
			x = (640 - 542) / 2 - 128;
			this.addEventListener(MouseEvent.MOUSE_DOWN, function(e:MouseEvent):void{
				e.preventDefault();
				e.stopImmediatePropagation()
				e.stopPropagation();
			})
			
			this.addEventListener(KeyboardEvent.KEY_DOWN, function(e:KeyboardEvent):void{
				e.preventDefault();
				e.stopImmediatePropagation()
				e.stopPropagation();
			})
			
			addButton(btn_actions, 1);
			addButton(btn_info, 2);
			addButton(btn_settings, 3);
			
			Actions.Confirm.visible = false;
			Actions.Confirm.btn_no.addEventListener(MouseEvent.MOUSE_DOWN, function(e:MouseEvent):void {
				Actions.Confirm.visible = false;
			});
			Actions.Confirm.btn_yes.addEventListener(MouseEvent.MOUSE_DOWN, handleConfirmAction);
			
			Actions.btn_savelevel.addEventListener(MouseEvent.MOUSE_DOWN, function(e:MouseEvent):void {
				showConfirmAction("Are you sure you want to save this world?", "save");
			});
			
			Actions.btn_loadlevel.addEventListener(MouseEvent.MOUSE_DOWN, function(e:MouseEvent):void {
				showConfirmAction("Are you sure you want to load this level?\nUnsaved changes will be lost forever!", "loadlevel");
			});
			
			Actions.btn_resetlevel.addEventListener(MouseEvent.MOUSE_DOWN, function(e:MouseEvent):void {
				showConfirmAction("Are you sure you want to reset all players?", "resetall");
			});
			
			Actions.btn_clearlevel.addEventListener(MouseEvent.MOUSE_DOWN, function(e:MouseEvent):void {
				showConfirmAction("Are you sure you want to clear this world?\nUnsaved changes will be lost forever!", "clear");
			});
			
			Info.input_description.addEventListener(Event.CHANGE, descChar);
			
			Info.input_name.maxChars = 20;
			Info.input_name.text = levelname;
			Info.input_description.text = description;
			
			descChar();
			
			setupCheckbox(Settings.checkbox_minimap_ingame, minimapEnabled);

			status.alpha = 0;
			
			// Set first page active
			setActive(currentPage, true);
			
			if (Global.cookie.data.backgroundEnabled == null)
				Global.cookie.data.backgroundEnabled = true;
			
			if (Global.cookie.data.previousColors == null)
				Global.cookie.data.previousColors = new Array();
			
			backgroundColorSelector = new BackgroundColorSelector();
			backgroundColorSelector.y = 120;
			Settings.addChild(backgroundColorSelector);
			
			this.save_all.addEventListener(MouseEvent.MOUSE_DOWN, function(ov:MouseEvent):void {
				// World name
				Global.base.closeInfo2Menus();
				if (Info.input_name.text != levelname) {
					Global.currentLevelname = Info.input_name.text;
					ui2.worldName = Info.input_name.text;
					if(ui2.worldNameLabel != null) ui2.worldNameLabel.text = Info.input_name.text;
					levelname = Info.input_name.text;
				}
				// Change description
				if (description != Info.input_description.text) {
					description = Info.input_description.text;
					ui2.description = Info.input_description.text;
				}
				
				var mapEnabled:Boolean = Settings.checkbox_minimap_ingame.currentFrame == 2;
				if (minimapEnabled != mapEnabled) {
					minimapEnabled = mapEnabled;
					ui2.playerMapEnabled = mapEnabled;
					ui2.worldMapEnabled = mapEnabled;
					ui2.configureInterface();
				}
				
				backgroundColorSelector.handleSave();
				showInfo("Saved all settings!");
			});
			
			closebtn.addEventListener(MouseEvent.MOUSE_DOWN, close);
		}
		
		private function genEditKey(length:int) : String{
			var chars:String = "bcdfjnpqrstvwxzAEIOUYKLMGH_-";
			var out:String = "";
			
			for(var i:int=0;i<length;i++){
				out += chars.charAt(int(Math.random()*chars.length));
			}
			
			return out;
		}
		
		private function setupCheckbox(checkbox:MovieClip, active:Boolean):void
		{
			checkbox.gotoAndStop(active ? 2 : 1);
			checkbox.buttonMode = true;
			checkbox.addEventListener(MouseEvent.CLICK, function(e:MouseEvent):void
			{
				checkbox.gotoAndStop(checkbox.currentFrame == 1 ? 2 : 1);
			});
		}
		
		private function showConfirmAction(text:String, action:String):void
		{
			Actions.Confirm.visible = true;
			Actions.Confirm.confirmText.text = text;
			confirmAction = action;
		}
		
		private function handleConfirmAction(e:MouseEvent):void
		{
			Global.ui2.sendChat("/" + confirmAction);
			close();			
			confirmAction = "none";
			Actions.Confirm.visible = false;
		}
		
		public function showInfo(text:String):void {
			status.text = text;
			TweenMax.to(status, 0.4, {alpha:1, onComplete:function():void{
				TweenMax.to(status, 1, {alpha:0, delay:3});
			}});
		}
		
		public function addButton(m:MovieClip, p:int):void {
			m.buttonMode = true;
			
			m.addEventListener(MouseEvent.MOUSE_DOWN, function(e:MouseEvent):void{
				setActive(p);
			});
			m.addEventListener(MouseEvent.ROLL_OVER, function (e:MouseEvent):void {
				if (m.currentFrame != 3)
					m.gotoAndStop(2);
			});
			m.addEventListener(MouseEvent.ROLL_OUT, function (e:MouseEvent):void {
				if (m.currentFrame != 3)
					m.gotoAndStop(1);
			});
		}
		
		public function descChar(ov:Event = null):void{
			Info.description_chars.text = Info.input_description.text.length + " of 100";
			
			if (Info.input_description.text.length >= 100) {
				Info.description_chars.textColor = 0xFF0000;
			} else if (Info.input_description.text.length >= 90) {
				Info.description_chars.textColor = 0xFF9900;
			} else if (Info.input_description.text.length >= 80) {
				Info.description_chars.textColor = 0xFFFF00;
			}  else {
				Info.description_chars.textColor = 0x00FF00;
			}
			
			if (Info.input_description.numLines > 3) {
				var lastChar:int = Info.input_description.getLineOffset(3) - 1;
				lastChar = Info.input_description.text.substring(0, lastChar + 1).search(/\S\s*$/);
				Info.input_description.text = Info.input_description.text.substring(0,  lastChar + 1);
			}
		}
		
		public function setActive(p:int, ignore:Boolean = false):void {
			if (p == currentPage && !ignore) return;
			
			currentPage = p;
			
			btn_actions.gotoAndStop(p == 1 ? 3 : 1);
			btn_info.gotoAndStop(p == 2 ? 3 : 1);
			btn_settings.gotoAndStop(p == 3 ? 3 : 1);
			
			Actions.visible = p==1;
			Info.visible = p==2;
			Settings.visible = p==3;
			
			switch (p)
			{
				case 1:
					TweenMax.from(Actions, .3, {x:Actions.x-30, alpha:0});
					break;
				case 2:
					TweenMax.from(Info, .3, {x:Info.x-30, alpha:0});
					break;
				case 3:
					TweenMax.from(Settings, .3, {x:Settings.x-30, alpha:0});
					break;
			}
		}
		
		public function close(e:Event=null):void
		{
			var pm:LevelOptions = this;
			TweenMax.to(pm, 0.4, {alpha:0, onComplete:function(pr:LevelOptions):void{
				if(stage) stage.focus = Global.base
				pr.parent.removeChild(pr);
			}, onCompleteParams:[pm]});
		}
	}
}