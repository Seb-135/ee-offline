package ui
{
	import com.greensock.*;
	import com.greensock.easing.*;
	
	import flash.display.Bitmap;
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.DropShadowFilter;
	import flash.utils.clearInterval;
	import flash.utils.setTimeout;
	
	import ui.HoverLabel;
	
	import ui2.ui2selector;
	import ui2.ui2smileyselector;
	import ui.ingame.sam.SmileyInstance;
	import ui.ingame.sam.AuraSelector;

	public class SmileySelector extends ui2smileyselector
	{
		private var smilies:Array = [];
		public var basiswidth:int = 116+15*5
		private var bg:Sprite = new Sprite
		private var selected:Bitmap = new Bitmap(new ui2selector());
		
		private var hoverLabel:HoverLabel;
		private var hovertimer:uint;
		
		private var auraSelector:AuraSelector;
		
		public function SmileySelector(ui:UI2) {
			hoverLabel = new HoverLabel();
			hoverLabel.visible = false;
			
			bg.filters = [new DropShadowFilter(0,45,0,1,4,4,1,3)];
			addChild(bg);
			
			auraSelector = new AuraSelector(ui);
			addChild(auraSelector);
			
			addEventListener(Event.ADDED_TO_STAGE, handleAttach);
		}
		
		public function addSmiley(sm:SmileyInstance):void{
			smilies.push(sm);
			addChild(sm);
			
			sm.hitBox.addEventListener(MouseEvent.MOUSE_OVER, handleMouse);
			sm.hitBox.addEventListener(MouseEvent.MOUSE_OUT, handleMouse);
		}
		
		protected function handleMouse(e:MouseEvent) : void
		{
			switch (e.type){
				case MouseEvent.MOUSE_OVER:{
					scaleImage((e.target.parent),2,0.3);
					
					hovertimer = setTimeout(function() : void{
						parent.addChild(hoverLabel);
						hoverLabel.alpha = 0;
						TweenMax.to(hoverLabel, 0.25, {alpha:1});
						hoverLabel.draw((e.target.parent as SmileyInstance).item.name);
						hoverLabel.visible = true;
						setHoverLabelPosition();
					}, 400);
				} break;
				
				case MouseEvent.MOUSE_OUT:{
					scaleImage((e.target.parent),1,0.3);
					
					TweenMax.to(hoverLabel, 0.2, {alpha:0});
					clearInterval(hovertimer);
				} break;
				
				case MouseEvent.MOUSE_MOVE:{
					if (hoverLabel.visible){
						hoverLabel.draw((e.target.parent as SmileyInstance).item.name);
						setHoverLabelPosition();
					}
				} break;
			}
		}
		
		private function scaleImage(object:*, scale:Number, time:Number = .2):void
		{
			var smiley:SmileyInstance = (object as SmileyInstance);
			
			TweenMax.to(smiley.sp, time,{
				alpha:1,
				scaleX:scale,
				scaleY:scale,
				onUpdate:function():void{
					smiley.sp.x = (26 - smiley.sp.width) / 2;
					smiley.sp.y = (26 - smiley.sp.height) / 2;
					setChildIndex(smiley, numChildren - 1);
				},
				ease:Back.easeOut
			});
		}
		
		public function doEmpty():void {
			for ( var i:int = 0; i < smilies.length; i++ ) {
				if ( smilies[i] ) {
					SmileyInstance(smilies[i]).destroy();
				}
			}
			smilies = [];
		}
		
		public override function get width():Number{
			return basiswidth;
		}
		
		public function setSelectedSmiley(offset:int):void{
			trace("SmileySelector -> setSelectedSmiley: " + offset);
			if(smilies[offset] == null) offset = 1;
		}
		
		public function redraw():void{
			var bx:int = 5;
			var by:int = -94;
			for( var a:int=0;a<smilies.length;a++){
				if(smilies[a]){
					if((bx + smilies[a].width + 5 )>= basiswidth){
						bx = 5;
						by += 22
					}
					smilies[a].x = bx;
					smilies[a].y = by;
					bx += 22;
				}
			}
			
			by += 18
			
			var g:Graphics = bg.graphics;
			g.clear();
			g.lineStyle(1,0x7B7B7B,1);
			g.beginFill(0x323231,0.85);
			g.drawRect(0,-94,basiswidth,by + 8 + 94);
			g.endFill();
			y = (-by - 38) - 94;
			
			auraSelector.y = by + 15;
			auraSelector.width = basiswidth;
		}
		
		private function handleAttach(e:Event):void{
			redraw();
		}
		
		public function getSmileyInstanceByItemId(id:int):SmileyInstance {
			for ( var i:int = 0; i < smilies.length; i++ ) {
				if ( smilies[i] ) {
					if ( SmileyInstance(smilies[i]).item.id == id ) {
						return SmileyInstance(smilies[i]);
					}
				}
			}
			return smilies[0] as SmileyInstance;
		}
		
		private function setHoverLabelPosition() : void
		{
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
}