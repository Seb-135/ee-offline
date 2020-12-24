package ui
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	public class TabBar extends Sprite
	{
		
		private var _spacing:Number = 0;
		
		public var tabs:Vector.<Tab>;
		private var _width:Number = 100;
		
		public function TabBar()
		{
			super();
			mouseEnabled = false;
			
			tabs = new Vector.<Tab>;
			
			addEventListener(MouseEvent.MOUSE_DOWN,handleTab,false,0,true);
		}
		
		protected function handleTab(event:MouseEvent):void
		{
			var tab:Tab = event.target as Tab;
			setSelected(tab.id);
		}		
		
		public function addTab(id:int,title:String,icon:int):Tab
		{
			var tab:Tab = new Tab(id,title,icon);
			tabs.push(tab);
			addChild(tab);
			return tab;
		}
		
		public function setSelected(id:int, deselectothers:Boolean = true):void
		{
			if(deselectothers)deselectAll();
			getTab(id).selected = true;			
		}

		public function deselectAll():void
		{
			for (var i:int = 0; i < tabs.length; i++) 
			{
				tabs[i].selected = false;
			}
		}
		
		public function getTab(id:int):Tab
		{
			for (var i:int = 0; i < tabs.length; i++) 
			{
				if(tabs[i].id == id) return tabs[i];
			}
			return null;
		}

		public function redraw():void
		{
			var u:int = _width;
			var tabwidth:Number = (_width-(tabs.length-1)*_spacing)/tabs.length;
			var counter:int = 0;
			for (var i:int = 0; i < tabs.length; i++) 
			{
				tabs[i].x = ((tabwidth+_spacing)*i)>>0;
				tabs[i].width = tabwidth;
			}			
		}
		
		
		
		public override function set width(value:Number):void{
			_width = value;
			redraw();
		}
		
		public function get spacing():Number
		{
			return _spacing;
		}

		public function set spacing(value:Number):void
		{
			_spacing = value;
		}

	}
}