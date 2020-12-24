package ui {
	import blitter.Bl;
	import flash.events.MouseEvent;
	
	public class KeyBindingItem extends assets_keybindingitem {
		
		public var binding:KeyBinding;
		public var menu:KeyBindingsMenu;
		public var keyTemp:Key;
		
		public function KeyBindingItem(binding:KeyBinding, menu:KeyBindingsMenu) {
			this.binding = binding;
			this.menu = menu;
			
			fieldName.text = (binding.staffOnly ? "* " : "") + binding.name;
			fieldKey.mouseEnabled = false;
			
			keyTemp = binding.keyCustom;
			update();
			
			var item:KeyBindingItem = this;
			btnBinding.addEventListener(MouseEvent.CLICK, function(e:MouseEvent):void { menu.rebindKey(item); });
			btnReset.addEventListener(MouseEvent.CLICK, function(e:MouseEvent):void {
				if (menu.bindingItem) return;
				keyTemp = null;
				update();
				menu.testConflicts();
			});
		}
		
		public function update():void {
			fieldKey.text = (keyTemp ? keyTemp : menu.azertyEnabled && binding.keyAzerty ? binding.keyAzerty : binding.keyDefault).print();
			fieldName.alpha = fieldKey.alpha = keyTemp ? 1 : .4;
			btnReset.visible = keyTemp != null;
		}
		
	}
}