package ui.button
{
	import flash.display.GradientType;
	import flash.display.SpreadMethod;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.filters.DropShadowFilter;
	import flash.geom.Matrix;
	
	import sample.ui.components.Label;
	
	public class Button extends Sprite
	{
		private var text:String;
		
		private var active:Boolean = true;
		
		private var ow:Number;
		private var oh:Number;
		
		private var prevColor:String = "green";
		private var color:String = "green";
		
		private var borderColor:uint;
		
		private var matrix:Matrix;
		
		private var title:Label;
		
		private var colors:Array = [];
		
		public function Button(text:String, color:String = "green", size:Number = 15, ow:Number = 225, oh:Number = 40)
		{
			this.text = text;
			this.color = color;
			this.ow = ow;
			this.oh = oh;
			this.prevColor = color;
			
			matrix = new Matrix();
			matrix.createGradientBox(ow, oh, (Math.PI / 2));
			
			title = new Label(text, size, "left", 0xFFFFFF, false, "system");
			title.filters = [new DropShadowFilter(0, 0, 0x000000, 1, 5, 5)];
			title.x = (width - title.width) / 2;
			title.y = (height - title.height) / 2;
			title.mouseEnabled = false;
			addChild(title);
			
			mouseChildren = false;
			
			setActive(true);
		}
		
		private function redraw() : void{
			switch (color){
				case ButtonColorType.DISABLED:{
					borderColor = 0x636363;
					colors = [0x3B3B3B3, 0x636363];
				} break;
				
				case ButtonColorType.RED:{
					borderColor = 0x9C0100;
					colors = [0xF42C2D, 0x9C0100];
				} break;
				
				case ButtonColorType.GREEN:{
					borderColor = 0x2D7B22;
					colors = [0x33D52A, 0x2D7B22];
				} break;
				
				case ButtonColorType.BLUE:{
					borderColor = 0x084C7C;
					colors = [0x53A7E7, 0x084C7C];
				} break;
			}
			
			graphics.clear();
			graphics.lineStyle(1, borderColor);
			graphics.beginGradientFill(GradientType.LINEAR, colors, [1, 1], [0, 255], matrix, SpreadMethod.PAD);
			graphics.drawRoundRect(0, 0, ow, oh, 5, 5);
			graphics.endFill();
		}
		
		public function setActive(active:Boolean) : void{
			buttonMode = active;
			useHandCursor = active;
			mouseEnabled = active;
			
			if (active == false){
				prevColor = color;
				color = ButtonColorType.DISABLED;
			} else{
				color = prevColor;
			}
			
			redraw();
		}
		
		public override function get width() : Number{
			return ow;
		}
		
		public override function get height() : Number{
			return oh;
		}
	}
}