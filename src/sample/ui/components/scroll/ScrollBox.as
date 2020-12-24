package sample.ui.components.scroll{
	import com.greensock.*;
	import com.greensock.easing.*;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	import sample.ui.components.Box;
	import sample.ui.components.Component;
	
	public class ScrollBox extends Box{
		
		private var _container:ScrollContainer
		private var _mask:Sprite = new Sprite();
		private var _mouseoverlay:Sprite = new Sprite();
		private var _scrollX:Number = 0;
		private var _scrollY:Number = 0;
		private var _scrollMultiplier:Number = 1;
		private var _reversed:Boolean = false;
		private var _animated:Boolean = true;
		private var scrolldisabled:Boolean = false;
		
		private var scrollAmount:int = 0;
		
		private var hscroll:ScrollBar;
		
		function ScrollBox(horizontal:Boolean = false, container:ScrollContainer = null, fill:uint = 0x000000)
		{
			super();
			
			_container = container || new ScrollContainer();
			
			hscroll = new ScrollBar(horizontal, fill);
			
			super.addChild(_mouseoverlay);
			_mouseoverlay.mouseEnabled = true;
			_mouseoverlay.graphics.beginFill(0x0,0)
			_mouseoverlay.graphics.drawRect(0,0,100,100);
			_mouseoverlay.graphics.endFill();
			super.addChild(_container)
			super.addChild(_mask);
			super.addChild(hscroll);
			_mask.graphics.beginFill(0x0,1)
			_mask.graphics.drawRect(0,0,100,100);
			_mask.graphics.endFill();
			
			_container.mask = _mask
			mouseEnabled = true;
			
			hscroll.scroll(function(s:Number):void{
				if (scrolldisabled == false){
					if (!hscroll.horizontal)
						scrollY = s; 
					else
						scrollX = s;
				}
			});
			
			addEventListener(MouseEvent.MOUSE_WHEEL, handleScrollWheel);
		}
		
		public function set scrollDisabled(value:Boolean) : void
		{
			scrolldisabled = value;
			hscroll.visible = !value;
			refresh();
		}
		
		public function set horizontal(value:Boolean) : void{
			hscroll.horizontal = value;
			
			if (!hscroll.horizontal)
				scrollY = 1;
			else
				scrollX = 1;
		}
		
		public function set scrollMultiplier(value:Number):void
		{
			_scrollMultiplier = value;
		}
		
		private function handleScrollWheel(e:MouseEvent):void
		{
			if (scrolldisabled == false){
				if (!hscroll.horizontal)
					scrollY -= e.delta * _scrollMultiplier;
				else
					scrollX -= e.delta * _scrollMultiplier ;
				
				e.preventDefault();
				e.stopImmediatePropagation();
				e.stopPropagation();
			}
		}
		
		public function reverse():ScrollBox{
			_reversed = !_reversed;
			return this;
		}
		public function animated():ScrollBox{
			_animated = !_animated;
			return this;
		}
		
		public override function add(...args:Array):Box{
			for each(var d:DisplayObject in args)
			_container.addChild(d);
			
			redraw();
			return this;
		}
		
		public function set scrollX(sx:Number):void
		{
			if (sx == scrollWidth - 1) sx++;
			//if (sx == 1) sx--;
			if (_scrollX != sx)
			{
				_scrollX = sx;
				redraw();
				hscroll.scrollValue = sx;
			}
		}
		
		public function set scrollY(sy:Number):void
		{
			if (sy == scrollHeight - 1) sy++;
			//if (sy == 1) sy--;
			if(_scrollY != sy)
			{
				_scrollY = sy;
				redraw();
				hscroll.scrollValue = sy;
			}
		}
		
		public function scrollPixelsX(px:Number) : void{
			hscroll.refresh();
		}
		
		public function scrollPixelsY(py:Number):void
		{
			hscroll.refresh();
		}
		
		public function get scrollWidth():Number{
			return _container.width - _mask.width + 1;
		}
		
		public function get scrollHeight():Number{
			
			return _container.height - _mask.height + 1;
		}
		
		public function get scrollX():Number{
			return _scrollX;
		}
		
		public function get scrollY():Number{
			return _scrollY;
		}
		
		public override function get width():Number{
			return _width
		}
		public override function get height():Number{
			return _height 
		}
		
		public override function addChild(d:DisplayObject):DisplayObject{
			return _container.addChild(d);
		}
		
		public override function removeChild(d:DisplayObject):DisplayObject{
			return _container.removeChild(d);
		}
		
		public function refresh():void{
			redraw();
		}
		
		protected override function redraw():void
		{
			var tw:Number;//_width
			if (hscroll != null)
			{
				if (scrolldisabled == false)
					hscroll.visible = true
				
				if(dirty){
					for(var a:int=0;a<numChildren;a++){
						var contenta:DisplayObject = getChildAt(a);
						contenta.width = rwidth - borderWidth;
						contenta.height = rheight - borderHeight;
					}
				}
				
				if (!hscroll.horizontal){
					
					if (_height == 0) return;
					
					tw = _width;
					_width -= 13
					
					hscroll.scrollViewable = _height + 1
					hscroll.scrollSize = _container.height + (_top||0) + (_bottom||0) + 1
					
					if(_container.height > _height){
						hscroll.focus();
						for(var b:int=0;b<numChildren;b++){
							var contentb:DisplayObject = getChildAt(b);
							contentb.width = rwidth - borderWidth
							contentb.height = rheight - borderHeight
						}
					}else{
						hscroll.blur();	
						
						_width += 13
						for(var c:int=0;c<numChildren;c++){
							var contentc:DisplayObject = getChildAt(c);
							contentc.width = rwidth - borderWidth;
							contentc.height = rheight - borderHeight;
						}
					}
					
					_scrollX = Math.max( Math.min(_scrollX,scrollWidth), 0);
					_scrollY = Math.max( Math.min(_scrollY,scrollHeight), 0);
					
					_container.x = -_scrollX;
					
					if(_reversed && _container.height < _height){
						setContainerY(_height - _container.height);
					}else{
						setContainerY(- _scrollY+1)
					}
					
					hscroll.x = _width + 1;
					hscroll.y = -1;
					hscroll.height = Math.ceil(_height) + 1;
					
					_width = tw;
				}
				else{
					
					if (_width == 0) return;
					
					tw = _height;
					_height -= 13;
					
					hscroll.scrollViewable = _width + 1;
					hscroll.scrollSize = _container.width + (_left||0) + (_right||0) + 1;
					
					if(_container.width > _width){
						hscroll.focus();
						for(var d:int=0;d<numChildren;d++){
							var contentd:DisplayObject = getChildAt(d);
							contentd.width = rwidth - borderWidth;
							contentd.height = rheight - borderHeight;
						}
					}else{
						hscroll.blur();	
						
						_height += 13
						for(var e:int=0;e<numChildren;e++){
							var contente:DisplayObject = getChildAt(e);
							contente.width = rwidth - borderWidth;
							contente.height = rheight - borderHeight;
						}
					}
					
					_scrollX = Math.max(Math.min(_scrollX,scrollWidth), 0);
					_scrollY = Math.max(Math.min(_scrollY, scrollHeight), 0);
					
					_container.y = -_scrollY;
					
					if (_reversed && _container.width < _width){
						setContainerX(_width - _container.width);
					}else{
						setContainerX(-_scrollX + 1);
					}
					
					hscroll.x = -1;
					hscroll.y = _height - 3;
					hscroll.width = Math.ceil(_width) + 1;
					
					_height = tw;
				}	
				
				dirty = false;
				hscroll.refresh();
			}
		}
		
		private var isfirst:Boolean = true;
		public function setContainerY(value:Number):void{
			
			if(_animated && !isfirst)
			{
				TweenMax.to(_container, 0.15, {y:value})
			}
			else 
			{
				_container.y = value;
			}
			isfirst = false;
			
		}
		
		public function setContainerX(value:Number) : void
		{
			if(_animated && !isfirst)
			{
				TweenMax.to(_container, 0.15, {x:value})
			}
			else 
			{
				_container.x = value;
			}
			isfirst = false;
		}
	}
}