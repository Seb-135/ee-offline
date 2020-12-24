package ui
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.filters.DropShadowFilter;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.ui.Keyboard;
	import flash.ui.Mouse;
	import flash.utils.describeType;
	
	import items.ItemBrick;
	import items.ItemManager;
	
	import ui2.worldbrickscontainer;
	
	public class BrickContainer extends ui2.worldbrickscontainer{
		private var images:Array = [];
		private var sprites:Array = [];
		private var defaults:Vector.<ItemBrick>
		private var curdefaults:Object = {};
		private var selected:int = 0;
		private var selectedIndex:int = 0;
		private var uix:UI2
		private var dragmc:Sprite = new Sprite()
		private var dragbm:Bitmap = new Bitmap(new BitmapData(16,16,false,0x0));
		public function BrickContainer(def:Vector.<ItemBrick>, uix:UI2) {
			
			this.uix = uix;
			defaults = def.concat();
			
			dragmc.addChild(dragbm)
			dragmc.mouseChildren = false;
			dragmc.mouseEnabled = false;
			dragmc.filters = [new DropShadowFilter(0,45,0x0,1,4,4,1,3)]
			
			selector.mouseEnabled = numbers.mouseEnabled = false;
			
			for( var a:int=0;a<11;a++){
				var tb:BitmapData = new BitmapData(16,16,false,0x0);
				var bm:Bitmap = new Bitmap(tb)
				
				var sp:Sprite = new Sprite();
				
				attachClickHandler(sp,a)
				ItemManager.bricks[0].drawTo(tb,0,0);
				sp.useHandCursor = true;
				sp.buttonMode = true
				sp.addChild(bm);
				
				sp.x = a*16
				brickcontainer.addChild(sp);			
				images.push(tb);
				sprites.push(sp);
			}
			
			for(a=0;a<def.length;a++){
				setDefault(a,def[a]);
			}
			
			addEventListener(Event.ADDED_TO_STAGE, handleAttach);
			addEventListener(Event.REMOVED_FROM_STAGE, handleDetatch);
		}
		
		public function get value():int{
			return selected
		}
		
		public function get selectedBlock():int{
			return selectedIndex;
		}
		
		public function setDefault(position:int, brick:ItemBrick ):void{
			defaults[position] = brick;
			drawDefault(position, brick);
			setSelected(brick.id);
		}
		
		public function setDefaults( def:Vector.<ItemBrick> ):void
		{
			defaults = def.concat();; 
			
			// redraw
			for(var a:int=0;a<11;a++){
				drawDefault(a,defaults[a]);
			}
		}
		
		/*
		public function getDefaults():Array{
			return defaults;
		}
		*/
		
		public function select( index:int, external:Boolean = false):void{
			
			selectedIndex = index;
			selected = defaults[index].id;
			selector.x = 3 + index * 16
			selector.y = 10 
			selector.visible = true
				
			if(!external){
				uix.setSelected(selected, true)
			}
		}
		
		public function getPosFromID(id:int):int {
			if (id == 110) id = 100;
			if (id == 111) id = 101;
			for(var i:int=0; i < defaults.length; i++){
				if(defaults[i].id == id){
					return i;
				}
			}
			
			return -1;
		}
		
		public function getPosWithID(val:int):Point {
			for( var a:int=0;a<defaults.length;a++){
				if(defaults[a].id == val){
					return new Point((3 + a * 16) + 8, -5);
				}
			}
			return new Point(0, 0);
		}
		
		public function get blockIDs():Array {
			var returnArr:Array = new Array();
			for (var a:int = 1; a < defaults.length; a++){
				returnArr.push(defaults[a].id);
			}
			return returnArr;
		}
		
		public function setSelected(val:int):void{
			for( var a:int=0;a<defaults.length;a++){
				if(defaults[a].id == val){
					select(a,true)
					return
				}
			}
			selector.visible = false
		}
		
		private var indrag:Boolean = false
		private var dragged:ItemBrick;
		
		public function dragIt(brick:ItemBrick):void{
			dragged = brick;
			indrag = true
			
			uix.addChild(dragmc)
			stage.addEventListener(MouseEvent.MOUSE_UP, handleMouseUp);
			stage.addEventListener(MouseEvent.MOUSE_MOVE, handleMouseMove);
			
			dragbm.bitmapData.fillRect(dragbm.bitmapData.rect, 0x0);				// Clear the drag-bitmap...
			ItemManager.bricks[brick.selectorBG].drawTo(dragbm.bitmapData,0,0);
			brick.drawTo(dragbm.bitmapData,0,0);
			
			//SpriteManager.drawSpriteById(type,dragbm.bitmapData,0,0);	// ....And draw the proper sprite on it
			dragmc.x = -1000
			dragmc.y = -1000
			
			///**/handleMouseMove();
		}
		
		private function handleMouseMove(e:MouseEvent = null):void{
			dragmc.x = uix.mouseX-8
			dragmc.y = uix.mouseY-8
			if(e)e.updateAfterEvent()
			Mouse.hide()
		}
		
		private function handleMouseUp(e:MouseEvent):void{
			Mouse.show()
			
			if (!indrag) return;
			var globalpoint:Point = dragmc.parent.localToGlobal(new Point(dragmc.x+8, dragmc.y+8));
			if(dragmc.parent) {
				dragmc.parent.removeChild(dragmc)
			}
			indrag = false;
			stage.removeEventListener(MouseEvent.MOUSE_UP, handleMouseUp);
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, handleMouseMove);
			
			for( var a:int=0;a<sprites.length;a++){
				var sp:Sprite = sprites[a] as Sprite
				if(sp.hitTestPoint(globalpoint.x,globalpoint.y)){
					if(a != 0)
					{
						setDefault(a, dragged);
						setSelected(dragged.id);
					}
					return;
				}
			}
		}
		
		private function handleAttach(e:Event):void{
			stage.addEventListener(KeyboardEvent.KEY_DOWN, handleKeyDown );
			stage.addEventListener(KeyboardEvent.KEY_UP, handleKeyUp );
		}
		
		private function handleDetatch(e:Event):void{
			stage.removeEventListener(KeyboardEvent.KEY_DOWN,  handleKeyDown );
			stage.addEventListener(KeyboardEvent.KEY_UP, handleKeyUp );
		}
		
		private var oldKeyCode:uint = 0;
		private var oldvar:int = 0;
		private function handleKeyDown(e:KeyboardEvent):void{
			if (e.keyCode == oldKeyCode)
				return;
				
			oldKeyCode = e.keyCode;
			switch(e.keyCode){
				case 16:{}
				case 17:{
					if(selectedIndex!=0)oldvar = selectedIndex;
					select(0);
					break;
				}
				case 49:{ indrag ? setDefault(1,dragged) : select(1); break}
				case 50:{ indrag ? setDefault(2,dragged) : select(2); break}
				case 51:{ indrag ? setDefault(3,dragged) : select(3); break}
				case 52:{ indrag ? setDefault(4,dragged) : select(4); break}
				case 53:{ indrag ? setDefault(5,dragged) : select(5); break}
				case 54:{ indrag ? setDefault(6,dragged) : select(6); break}
				case 55:{ indrag ? setDefault(7,dragged) : select(7); break}
				case 56:{ indrag ? setDefault(8,dragged) : select(8); break}
				case 57:{ indrag ? setDefault(9,dragged) : select(9); break}
				case 48:{ indrag ? setDefault(10,dragged) : select(10); break}
			}
		}
		
		private function handleKeyUp(e:KeyboardEvent):void{
			if(oldvar != 0 && (e.keyCode == 16 || e.keyCode == 17)){
				oldvar == 0
				select(oldvar);
			}
			oldKeyCode = 0;
		}
		
		private function attachClickHandler(o:Sprite, offset:int):void{
			o.addEventListener(MouseEvent.MOUSE_DOWN, function():void{
				select(offset);
			});
		}
		
		private function drawDefault(position:int, brick:ItemBrick):void{
			images[position].fillRect(new Rectangle(0,0,16,16), 0x00000000)
			ItemManager.bricks[brick.selectorBG].drawTo(images[position],0,0);
			brick.drawTo(images[position],0,0);
		}
	}
}