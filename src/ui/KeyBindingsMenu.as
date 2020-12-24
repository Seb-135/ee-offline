package ui {
	import blitter.Bl;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.utils.Dictionary;
	import sample.ui.components.Rows;
	import sample.ui.components.scroll.ScrollBox;
	
	public class KeyBindingsMenu extends assets_keybindingsmenu {
		
		public var initW:Number;
		public var initH:Number;
		public var closeCallback:Function;
		
		private var rows:Rows = new Rows();
		private var scroll:ScrollBox = new ScrollBox();
		
		public var azertyEnabled:Boolean;
		
		private var bindingItems:Vector.<KeyBindingItem> = new Vector.<KeyBindingItem>();
		public var bindingItem:KeyBindingItem = null;
		
		public function KeyBindingsMenu(closeCallback:Function) {
			gotoAndStop(1);
			initW = width;
			initH = height;
			this.closeCallback = closeCallback;
			
			azertyEnabled = Global.base.settings.azerty;
			azertyCheck.gotoAndStop(azertyEnabled ? 2 : 1);
			azertyCheck.addEventListener(MouseEvent.CLICK, handleAzerty);
			
			scroll.x = 18;
			scroll.y = 49;
			scroll.width = 427;
			scroll.height = 205;
			scroll.scrollMultiplier = 10;
			addChild(scroll);
			
			rows.spacing(0);
			scroll.add(rows);
			
			for each (var k:KeyBinding in KeyBinding._all) {
				if (k.staffOnly && !Bl.data.isStaffMember) continue;
				var item:KeyBindingItem = new KeyBindingItem(k, this);
				bindingItems.push(item);
				rows.addChild(item);
			}
			testConflicts();
			
			scroll.refresh();
			
			btnCancel.addEventListener(MouseEvent.CLICK, handleCancel);
			btnSave.addEventListener(MouseEvent.CLICK, handleSave);
			btnResetAll.addEventListener(MouseEvent.CLICK, handleResetAll);
			
			addEventListener(Event.ADDED_TO_STAGE, handleAdded);
		}
		
		private function handleAdded(e:Event):void {
			removeEventListener(Event.ADDED_TO_STAGE, handleAdded);
			
			stage.addEventListener(KeyboardEvent.KEY_DOWN, handleKeys, false, 0, true);
			addEventListener(Event.ENTER_FRAME, handleFrame);
		}
		
		private function handleAzerty(e:MouseEvent):void {
			if (bindingItem) return;
			azertyEnabled = !azertyEnabled;
			azertyCheck.gotoAndStop(azertyEnabled ? 2 : 1);
			for each (var item:KeyBindingItem in bindingItems) {
				item.update();
			}
			testConflicts();
		}
		
		private function handleCancel(e:MouseEvent):void {
			if (!bindingItem) closeCallback();
		}
		
		private function handleSave(e:MouseEvent):void {
			if (bindingItem) return;
			Global.base.settings.azerty = azertyEnabled;
			for each (var item:KeyBindingItem in bindingItems) {
				item.binding.keyCustom = item.keyTemp;
			}
			KeyBinding.save();
			handleCancel(null);
		}
		
		private function handleResetAll(e:MouseEvent):void {
			if (bindingItem) return;
			
			for each (var item:KeyBindingItem in bindingItems) {
				item.keyTemp = null;
				item.update();
				item.fieldKey.textColor = item.fieldName.textColor = 0xffffff;
			}
			
			updateResetAll(false);
		}
		
		public function rebindKey(item:KeyBindingItem):void {
			if (bindingItem) return;
			
			bindingItem = item;
			bindingItem.fieldKey.alpha = .75;
			bindingItem.fieldKey.text = "Press key...";
			bindingItem.fieldKey.textColor = 0xffffff;
			
			mouseChildren = false;
		}
		
		private function handleKeys(e:KeyboardEvent):void {
			if (!bindingItem || !Key.isValidKey(e.keyCode)) return;
			
			// different from previous?
			if (bindingItem.keyTemp == null || bindingItem.keyTemp.keyCode != e.keyCode || bindingItem.keyTemp.needsShift != e.shiftKey) {
				// same as current default?
				var d:Key = azertyEnabled && bindingItem.binding.keyAzerty ? bindingItem.binding.keyAzerty : bindingItem.binding.keyDefault;
				if (d.keyCode == e.keyCode && d.needsShift == e.shiftKey) {
					bindingItem.keyTemp = null;
				} else {
					if (!bindingItem.keyTemp) {
						bindingItem.keyTemp = new Key(e.keyCode, e.shiftKey);
					} else {
						bindingItem.keyTemp.keyCode = e.keyCode;
						bindingItem.keyTemp.needsShift = e.shiftKey;
					}
				}
			}
			
			bindingItem.update();
			bindingItem = null;
			testConflicts();
			
			mouseChildren = true;
		}
		
		private function handleFrame(e:Event):void {
			if (bindingItem && stage) stage.focus = stage;
		}
		
		public function testConflicts():void {
			var any:Boolean = false;
			var unique:Object = {};
			
			for each (var item:KeyBindingItem in bindingItems) {
				if (item.keyTemp) any = true;
				var name:String = (item.keyTemp ? item.keyTemp : azertyEnabled && item.binding.keyAzerty ? item.binding.keyAzerty : item.binding.keyDefault).print();
				var u:KeyBindingItem = unique[name] as KeyBindingItem;
				if (u) {
					u.fieldKey.textColor = u.fieldName.textColor = item.fieldKey.textColor = item.fieldName.textColor = 0xff5050;
				} else {
					item.fieldKey.textColor = item.fieldName.textColor = 0xffffff;
					unique[name] = item;
				}
			}
			
			updateResetAll(any);
		}
		
		private function updateResetAll(enable:Boolean):void {
			btnResetAll.mouseEnabled = enable;
			btnResetAll.alpha = enable ? 1 : .4;
		}
		
	}
}