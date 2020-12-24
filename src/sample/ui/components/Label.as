package sample.ui.components{
	import flash.text.AntiAliasType;
	import flash.text.GridFitType;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;

	public class Label extends TextField{
		function Label(text:String, size:Number = 12, align:String = "left", color:Number = 0x000000, multiline:Boolean = false, font:String = null){
			
			var format:TextFormat = new TextFormat();
			format.font = font || "Arial"
			
			if (format.font != "Arial") {
				embedFonts = true;
				antiAliasType = AntiAliasType.ADVANCED;
				sharpness = 400;
			}
			
			format.align = align
			format.size = size
			format.color = color
			
			this.defaultTextFormat = format 
			super.text = text;
			this.selectable = false;
			this.mouseEnabled = false;
			
			if(multiline){
				this.multiline = true;
				this.wordWrap = true;
			}
			
			resize()
		}
		
		
		public override function set text(t:String):void{
			super.text = t;
			
			
			resize()
		}
		
		public override function set htmlText(t:String):void{
			super.htmlText = t;
			this.mouseEnabled = true;
			
			resize()
		}
		
		public function clear():void{
			super.text = "";
		}
		
		private function resize():void{
			this.width = this.textWidth+10
			this.height = this.textHeight+(this.defaultTextFormat.size as Number)/2
		}
		
		public override function get height():Number{
			return this.textHeight+3
		}
		
		public function Clone():Label{
			return new Label(this.text, this.defaultTextFormat.size as Number, this.defaultTextFormat.align);
		}
	}	
}