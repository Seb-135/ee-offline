package ui
{
	import com.greensock.TweenMax;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.GradientType;
	import flash.display.MovieClip;
	import flash.display.SpreadMethod;
	import flash.display.Sprite;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	import utilities.ColorUtil;

	public class BackgroundColorSelector extends assets_colorselector
	{
		private var matrix:Matrix;
		
		private var adjColor:uint;
		
		private var previewColorColorTransform:ColorTransform;
		private var previewFill:MovieClip, adjusterFill:MovieClip;
		
		private var adjusterFillBMD:BitmapData;
		
		private var mouseDown:Boolean = false, adjMouseDown:Boolean;
		
		[Embed(source="/../media/color_wheel.png")] private static var ColorWheel:Class;
		private static var colorWheelBMD:BitmapData = new ColorWheel().bitmapData;
		private var colorWheelBM:Bitmap = new Bitmap(colorWheelBMD);
		
		private var circleBorder:Sprite;
		private var colorWheelBMContainer:Sprite = new Sprite();
		
		
		public function BackgroundColorSelector() 
		{
			matrix = new Matrix();
			bg_mail.gotoAndStop(1);
			
			previewFill = colorPreview.getChildByName("fill") as MovieClip;
			adjusterFill = brightnessAdjuster.getChildByName("fill") as MovieClip;
			adjusterFillBMD = new BitmapData(adjusterFill.width, adjusterFill.height);
			adjusterFillBMD.draw(adjusterFill);
			
			//Initialize the textfields with their respective hex codes and event listeners
			var hexCode:TextField;
			for (var i:int = 0; i < 4; i++)
			{
				hexCode = getChildByName("hexLabel" + (i + 1)) as TextField;
				hexCode.text = "#" + ((Global.cookie.data.previousColors[i] == null) ? "000000" : ColorUtil.DecimalToHex(Global.cookie.data.previousColors[i]));
				hexCode.addEventListener(MouseEvent.CLICK, hexLabelClick);
				hexCode.addEventListener(MouseEvent.MOUSE_OUT, hexLabelOut);
				hexCode.addEventListener(MouseEvent.MOUSE_OVER, hexLabelOver);
			}
			
			//Restrict the custom hex code to 7 characters and certains characters
			input_hex.maxChars = 7;
			input_hex.restrict = "a-fA-F0-9#";
			
			if (Global.backgroundEnabled)
			{
				input_hex.text = "#" + ColorUtil.DecimalToHex(Global.bgColor);

				updatePreviewColor(Global.bgColor);
				updateGradientBar(Global.bgColor);
			}
			else
			{
				input_hex.text = "none";
			}
			
			checkbox_background.buttonMode = true;
			checkbox_background.gotoAndStop(Global.backgroundEnabled ? 2 : 1);
			checkbox_background.addEventListener(MouseEvent.MOUSE_DOWN, function(e:MouseEvent):void {
				//Set the current state of the checkbox depending on if the background is enabled
				checkbox_background.gotoAndStop(checkbox_background.currentFrame == 1 ? 2 : 1);
				
				var enabled:Boolean = (checkbox_background.currentFrame == 2);
				
				input_hex.text = (enabled ? hexLabel4.text : "none");
				Global.backgroundEnabled = enabled;
			});
			
			//Add colorWheelBM to a sprite container because Bitmap's contain handle mouse events
			colorWheelBMContainer.addChild(colorWheelBM);
			
			colorWheelBMContainer.addEventListener(MouseEvent.CLICK, colorWheelClick);
			colorWheelBMContainer.addEventListener(MouseEvent.MOUSE_MOVE, colorWheelMove);
			colorWheelBMContainer.addEventListener(MouseEvent.MOUSE_DOWN, colorWheelDown);
			
			colorWheelBMContainer.x = ((colorPreview.x - colorWheelBM.width) + colorPreview.width) - 2;
			colorWheelBMContainer.y = ((colorPreview.y - colorWheelBM.height) + colorPreview.height) - 2;
			
			addChild(colorWheelBMContainer);
			
			//The border for the color wheel
			circleBorder = new Sprite();
			circleBorder.graphics.lineStyle(3, 0x666666);
			circleBorder.graphics.drawCircle(0, 0, 75);
			circleBorder.graphics.endFill();
			circleBorder.mouseEnabled = false;
			circleBorder.x = (colorWheelBMContainer.x + (circleBorder.width / 2)) - 2;
			circleBorder.y = (colorWheelBMContainer.y + (circleBorder.height / 2)) - 2;
			addChild(circleBorder);
			
			brightnessAdjuster.getChildByName("fill").addEventListener(MouseEvent.MOUSE_DOWN, adjusterDown);
			brightnessAdjuster.getChildByName("fill").addEventListener(MouseEvent.CLICK, adjusterClick);
			brightnessAdjuster.getChildByName("fill").addEventListener(MouseEvent.MOUSE_MOVE, adjusterMove);
			
			addEventListener(MouseEvent.MOUSE_UP, handleMouseUp);
			
			addEventListener(MouseEvent.MOUSE_DOWN, function(e:MouseEvent) : void 
			{
				e.preventDefault();
				e.stopImmediatePropagation();
				e.stopPropagation();
			});
			addEventListener(KeyboardEvent.KEY_DOWN, function(e:KeyboardEvent) : void 
			{
				e.preventDefault();
				e.stopImmediatePropagation();
				e.stopPropagation();
			});
		}
		
		public function handleSave() : void
		{
			if (Global.backgroundEnabled)
			{
				//Get the hex code from the textbox without the #
				var hexColor:String = ((input_hex.text.indexOf("#") != -1) ? input_hex.text.replace("#", "") : input_hex.text);
				
				if (input_hex.text.length >= 6)
				{
					//Add # to the front of the hex code and cut it down to 7 characters
					input_hex.text = "#" +  hexColor;
					input_hex.text = input_hex.text.slice(0, 7);
					
					//If the custom hex code is not 7 characters long show the red box around the textbox
					bg_mail.gotoAndStop((input_hex.text.length == 7) ? 1 : 2)
					
					if (input_hex.text.length == 7){
						Global.ui2.sendChat("/bgcolor " + input_hex.text);
					}
				}
				else
				{
					bg_mail.gotoAndStop(2);
				}
			}
			else
			{
				Global.ui2.sendChat("/bgcolor none");
			}
		}
		
		public function handleBackgroundChange(bgColor:uint) : void
		{
			Global.backgroundEnabled = ((bgColor >> 24) & 0xFF) == 255;
			if (Global.backgroundEnabled) 
			{
				//Update all colors to the new bgColor
				updateColorArray(Global.bgColor);
				updateHexLabels();
				
				updateGradientBar(Global.bgColor);
				updatePreviewColor(Global.bgColor);
				
				input_hex.text = "#" + ColorUtil.DecimalToHex(Global.bgColor);
				checkbox_background.gotoAndStop(2);
			} 
			else 
			{
				input_hex.text = "none";
				checkbox_background.gotoAndStop(1);
				
				updatePreviewColor(0x202020);
				adjusterFill.graphics.clear();
			}
		}
		
		private function updateColorArray(bgColor:uint) : void
		{
			//Check if the array doesn't already contain the color
			if (Global.cookie.data.previousColors.indexOf(bgColor) == -1)
			{
				Global.cookie.data.previousColors.push(bgColor);
				//Move all items in array up by one
				var a:int = 0;
				while (a < 4)
				{
					Global.cookie.data.previousColors[a] = Global.cookie.data.previousColors[a + 1];
					a++;
				}
				
				//Cut array to 5 items
				Global.cookie.data.previousColors.length = 4;
			}
		}
		
		private function updateHexLabels() : void
		{
			for (var i:int = 0; i < 4; i++)
			{
				(getChildByName("hexLabel" + (i + 1)) as TextField).text = "#" + ((Global.cookie.data.previousColors[i] == null) ? "000000" : ColorUtil.DecimalToHex(Global.cookie.data.previousColors[i]));
			}
		}
		
		private function updateGradientBar(color:uint): void
		{
			matrix.createGradientBox(21, 165, Math.PI / 2, 0, 0);
			
			adjusterFill.graphics.clear();
			adjusterFill.graphics.beginGradientFill(GradientType.LINEAR, [0xFFFFFF, color, 0x000000], [1, 1, 1], [0, 127.5, 255], matrix, SpreadMethod.PAD);
			adjusterFill.graphics.drawRect(0, 0, 21, 165);
			adjusterFill.graphics.endFill();
			adjusterFillBMD.draw(adjusterFill);
		}
		
		private function updatePreviewColor(newColor:uint):void
		{
			previewColorColorTransform = previewFill.transform.colorTransform;
			previewColorColorTransform.color = newColor;
			previewFill.transform.colorTransform = previewColorColorTransform;
		}
		
		private function adjusterMove(e:MouseEvent) : void
		{
			if ((adjMouseDown) && (Global.backgroundEnabled))
			{
				getAdjusterColor(e);
				updatePreviewColor(Global.bgColor);
			}
		}
		
		private function adjusterClick(e:MouseEvent) : void
		{
			if (Global.backgroundEnabled)
			{
				getAdjusterColor(e);
				updatePreviewColor(Global.bgColor);
			}
		}
		
		private function getAdjusterColor(e:MouseEvent) : void
		{
			var colorValue:uint = adjusterFillBMD.getPixel(3, e.target.mouseY);
		
			var hexValue:String = ColorUtil.DecimalToHex(colorValue);
			
			trace("Here: ", colorValue, hexValue);
			
			updatePreviewColor(colorValue);
			input_hex.text = ("#" + hexValue);
			Global.bgColor = colorValue
		}
		
		private function adjusterDown(e:MouseEvent) : void
		{
			if (adjMouseDown == false)
				adjMouseDown = true;
		}
		
		private function colorWheelMove(e:MouseEvent) : void
		{
			if ((mouseDown) && (Global.backgroundEnabled))
			{
				getColorWheelValue(e);
				updatePreviewColor(Global.bgColor);
				updateGradientBar(Global.bgColor);
			}
		}
		
		private function colorWheelClick(e:MouseEvent) : void
		{
			if (Global.backgroundEnabled)
			{
				getColorWheelValue(e);
				updatePreviewColor(Global.bgColor);
				updateGradientBar(Global.bgColor);
			}
		}
		
		private function getColorWheelValue(e:MouseEvent) : void
		{
			var colorValue:uint = colorWheelBMD.getPixel(e.target.mouseX, e.target.mouseY);
			
			var hexValue:String = ColorUtil.DecimalToHex(colorValue);
			
			input_hex.text = "#" + hexValue;
			Global.bgColor = colorValue;
		}
		
		private function colorWheelDown(e:MouseEvent) : void 
		{
			if (mouseDown == false)
				mouseDown = true;
		}
		
		private function hexLabelClick(e:MouseEvent) : void
		{
			if (Global.backgroundEnabled)
			{
				//conn.send("say", "/bgcolor " + (e.target as TextField).text);
			}
		}
		
		private function hexLabelOver(e:MouseEvent) : void
		{
			if (Global.backgroundEnabled)
				setHexLabelColor(e, 16777215);
		}
		
		private function hexLabelOut(e:MouseEvent) : void
		{
			if (Global.backgroundEnabled)
				setHexLabelColor(e, 10066329);
		}
		
		private function setHexLabelColor(e:MouseEvent, color:uint): void
		{
			if (!(e.target as TextField).getTextFormat().color != color)
			{
				(e.target as TextField).setTextFormat(new TextFormat(null, null, color));
			}
		}
		
		private function handleMouseUp(e:MouseEvent) : void
		{
			if (mouseDown)
				mouseDown = false;
			if (adjMouseDown)
				adjMouseDown = false;
		}
	}
}