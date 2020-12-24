package ui.ingame.settings
{
	import blitter.BlText;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.GradientType;
	import flash.display.SpreadMethod;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import flash.text.AntiAliasType;
	import flash.text.GridFitType;
	import flash.text.TextFormat;

	public class SettingsButton extends Sprite
	{
		public static var DEFAULT_WIDTH:int = 54; // 49;
		public static var DEFAULT_HEIGHT:int = 29;
		
		public var WIDTH:int = DEFAULT_WIDTH;
		public var HEIGHT:int = DEFAULT_HEIGHT;
		
		private var label:BlText;
		
		private var text:String;
		
		private var matrix:Matrix;
		
		private var subOptions:Array;
		
		public var subOptionsContainer:Sprite;
		
		private var triangle:Sprite;
		
		private var clickCallback:Function;
		
		private var image:Bitmap;
		private var imageBMD:BitmapData;
		
		public function SettingsButton(text:String, imageBMD:BitmapData, clickCallback:Function, subOptions:Array = null)
		{
			this.text = text;
			this.imageBMD = imageBMD;
			this.subOptions = subOptions;
			this.clickCallback = clickCallback;
			
			var bothAreNull:Boolean = ((text == "") && (imageBMD == null));
			
			if (!bothAreNull){
				this.buttonMode = true;
				this.useHandCursor = true;
				this.mouseEnabled = true;
				
				setSubOptions(subOptions);
				
				if (clickCallback != null)
					setClickCallback(clickCallback);
			}
			
			matrix = new Matrix();
			matrix.createGradientBox(WIDTH, HEIGHT, (Math.PI / 2));
			
			redraw();
		}
		
		private function redraw() : void{
			graphics.clear();
			graphics.lineStyle(1, 0x7B7B7B);
			graphics.beginGradientFill(GradientType.LINEAR, [0x313131, 0x202020], [1, 1], [0, 255], matrix, SpreadMethod.PAD);
			graphics.drawRect(0, -1, WIDTH, HEIGHT);
			graphics.endFill();
			
			if (text != ""){
				label = new BlText(13, WIDTH, 0xFFFFFF, "center", "visitor");
				label.text = text;

				var bm:Bitmap = new Bitmap(label.clone());
				bm.x = Math.round(((WIDTH - bm.width) / 2) + 1);
				bm.y = Math.round(((HEIGHT - bm.height) / 2) - 1)
				addChild(bm);
			}
			
			if (imageBMD != null){
				updateImage(imageBMD);
			}
			
			mouseChildren = false;
		}
		
		public function updateImage(newImage:BitmapData) : void{
			if ((image != null) && contains(image)){
				removeChild(image);
			}
			
			image = new Bitmap(newImage);
			image.x = Math.round((WIDTH - image.width) / 2);
			image.y = Math.round((HEIGHT - image.height) / 2) - 1;
			addChild(image);
		}
		
		public function toggleSubOptionsVisible(active:Boolean) : void{
			subOptionsContainer.visible = active;
		}
		
		protected function handleMouse(e:MouseEvent) : void{
			switch (e.type){
				case MouseEvent.MOUSE_OVER:{
					toggleSubOptionsVisible(true);
				} break;
				
				case MouseEvent.MOUSE_OUT:{
					toggleSubOptionsVisible(false);
				} break;
			}
		}
		
		public function setClickCallback(callback:Function) : void{
			if (callback != null){
				addEventListener(MouseEvent.CLICK, callback);
			}
		}
		
		public function setSubOptions(subOptions:Array) : void{
			if (subOptions != null && subOptions.length > 0){
				subOptionsContainer = new Sprite();
				subOptionsContainer.visible = false;
				
				for (var i:int = 0; i < subOptions.length; i++){
					var button:SettingsButton = (subOptions[i] as SettingsButton);
					
					button.y = (i * HEIGHT);
					
					subOptionsContainer.addChild(button);
				}
				
				//Draw the triangle
				var tSize:int = 4; //Width and Height (in pixels)
				
				triangle = new Sprite();
				triangle.x = (WIDTH - tSize);
				triangle.mouseEnabled = false;
				triangle.graphics.clear();
				triangle.graphics.beginFill(0xFFFFFF);
				triangle.graphics.moveTo(0, 0);
				triangle.graphics.lineTo(tSize, 0);
				triangle.graphics.lineTo(tSize, tSize);
				triangle.graphics.lineTo(0, 0);
				triangle.graphics.endFill();
				addChild(triangle);
				
				subOptionsContainer.x = WIDTH;
				subOptionsContainer.y = -((subOptions.length - 1) * 29)
				addChild(subOptionsContainer);
				
				addEventListener(MouseEvent.MOUSE_OVER, handleMouse);
				addEventListener(MouseEvent.MOUSE_OUT, handleMouse);
				
				setClickCallback(function() : void{
					toggleSubOptionsVisible(!subOptionsContainer.visible);
				});
			}
		}
		
		public function setSize(width:Number, height:Number) : void{
			WIDTH = width;
			HEIGHT = height;
			
			redraw();
		}
	}
}