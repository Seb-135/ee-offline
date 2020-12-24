package ui.ingame.sam
{
	import com.greensock.*;
	import com.greensock.easing.Back;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.filters.DropShadowFilter;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.clearInterval;
	import flash.utils.setTimeout;
	
	import items.ItemSmiley;
	
	import ui.HoverLabel;
	
	import ui2.ui2smileyinstance;

	public class SmileyInstance extends ui2smileyinstance
	{
		private var _item:ItemSmiley; // This was public, so it may break stuff - please don't make fields public
		private var _sp:Sprite = new Sprite();
		private var _ss:UI2;
		
		private var _hitBox:Sprite;
		
		private var hoverLabel:HoverLabel;
		private var hovertimer:uint;
		
		private var _index:int;
		
		public var bm:Bitmap;
		
		private var _hoverZoom:Boolean;
		
		public function SmileyInstance(item:ItemSmiley, ss:UI2, goldBorder:Boolean, index:int = -1, hoverZoom:Boolean = true)
		{
			
			_item = item
			_ss = ss;
			_index = index;
			_hoverZoom = hoverZoom;
			
			hoverLabel = new HoverLabel();
			hoverLabel.visible = false;
			
			bm = new Bitmap(item.bmd);
			
			updateBorder(goldBorder);
			
			_sp.mouseEnabled = false;
			_sp.mouseChildren = false;
			addChild(_sp)
			
			_hitBox = new Sprite();
			_hitBox.graphics.beginFill(0x0,0);
			_hitBox.graphics.drawRect(0,0,26,26);
			_hitBox.graphics.endFill();
			addChild(hitBox);
			
			if (hoverZoom){
				_sp.filters = [new DropShadowFilter(3,45,0x000000, 0.6, 3, 3)];
				
				_hitBox.buttonMode = true;
				_hitBox.useHandCursor = true;
				
				_hitBox.doubleClickEnabled = true;
				_hitBox.addEventListener(MouseEvent.DOUBLE_CLICK, handleSmileyDoubleClick);
				
				_hitBox.addEventListener(MouseEvent.MOUSE_OVER, handleMouse);
				_hitBox.addEventListener(MouseEvent.MOUSE_OUT, handleMouse);
			}
		}
		
		public function updateBorder(gold:Boolean) : void{
			if (bm && _sp.contains(bm)) _sp.removeChild(bm);
			bm = new Bitmap(gold ? item.bmdGold : item.bmd);
			_sp.addChild(bm);
		}
		
		protected function handleSmileyDoubleClick(e:MouseEvent) : void{
			var target:Player = Global.playState.target as Player;
			if (target != null && target != Global.playState.player)
				Global.base.setGoldBorder(!target.wearsGoldSmiley);
			else Global.base.setGoldBorder(!Global.playerInstance.wearsGoldSmiley);
		}
		
		protected function handleMouse(e:MouseEvent) : void{
			if (parent){
				switch (e.type){
					case MouseEvent.MOUSE_OVER:{
						if (_hoverZoom){
							scaleImage(this, 2, 0.3);
					
							hovertimer = setTimeout(function() : void{
								if (parent) parent.addChild(hoverLabel);
								hoverLabel.alpha = 0;
								TweenMax.to(hoverLabel, 0.25, {alpha:1});
								hoverLabel.draw(item.name + " [" + item.id + "]");
								hoverLabel.visible = true;
								setHoverLabelPosition();
							}, 400);
						}
					} break;
					
					case MouseEvent.MOUSE_OUT:{
						scaleImage(this, 1, 0.3);
						
						TweenMax.to(hoverLabel, 0.2, {alpha:0});
						clearInterval(hovertimer);
					} break;
					
					case MouseEvent.MOUSE_MOVE:{
						if (hoverLabel.visible){
							hoverLabel.draw(item.name);
							setHoverLabelPosition();
						}
					} break;
				}
			}
		}
		
		public function scaleImage(object:*, scale:Number, time:Number = .2, alpha:int = 1, onCompleteCallback:Function = null):void
		{
			var smiley:SmileyInstance = (object as SmileyInstance);
			
			TweenMax.to(smiley.sp, time,{
				alpha:alpha,
				scaleX:scale,
				scaleY:scale,
				onUpdate:function():void{
					smiley.sp.x = (26 - smiley.sp.width) / 2;
					smiley.sp.y = (26 - smiley.sp.height) / 2;
					
					if (parent) parent.setChildIndex(smiley, parent.numChildren - 1);
				},
				onComplete:onCompleteCallback,
				ease:Back.easeOut
			});
		}
		
		private function setHoverLabelPosition() : void
		{
			if (parent){
				hoverLabel.x = parent.mouseX;
				if (hoverLabel.x>(parent.width/2))
				{
					hoverLabel.x -= (hoverLabel.w + 12);
				} else {
					hoverLabel.x += 12;
				}
				hoverLabel.y = parent.mouseY-(hoverLabel.height/2);
			}
		}
		
		public function get item():ItemSmiley {
			return _item;
		}
		
		public function get sp() : Sprite{
			return _sp;
		}
		
		public function get hitBox() : Sprite{
			return _hitBox;
		}
		
		public function destroy(animated:Boolean = false):void {
			if (animated){
				scaleImage(this, 0.1, 0.3, 0, removeThis);
			} else {
				removeThis();
			}
		}
		
		private function removeThis() : void{
			if (parent) {
				parent.removeChild(this);
			}
		}
		
		public function get index() : int{
			return _index;
		}
		
		public function set index(value:int) : void{
			_index = value;
		}
	}
}