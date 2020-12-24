package {
	import com.greensock.*;
	import flash.display.MovieClip;
	import flash.display.StageQuality;
	import flash.events.Event;
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.getDefinitionByName;
	
	public class loader extends MovieClip { 
		
		[Embed(source="/../media/nokiafc22.ttf", fontFamily="system", embedAsCFF="false", mimeType="application/x-font-truetype")]  
		private var systemFont:Class;
		
		private var t:TextField = new TextField();
		
		public function loader() {
			stage.quality = StageQuality.MEDIUM; // flash plugin renders image strangely without this
			
			var loader:preloader = new preloader();
			loader.x = (stage.stageWidth - loader.width) / 2;
			loader.y = (stage.stageHeight - loader.height) / 2;
			loader.mask1.scaleX = 0;
			
			var maskW:Number = loader.width;
			
			var tf:TextFormat = new TextFormat("system", 36, 0xBBBBBB, null, null, null, null, null, "center");
			t.embedFonts = true;
			t.defaultTextFormat = tf;
			t.text = "0%0%0%";
			t.selectable = false;
			t.width = t.textWidth * 3;
			t.height = t.textHeight + 5;
			t.x = stage.stageWidth / 2 - t.width / 2;
			t.y = loader.y + loader.height - 20;
			t.alpha = 0;
			t.antiAliasType = AntiAliasType.ADVANCED;
			
			addChild(t);
			addChild(loader);
			
			TweenMax.to(loader, .35, {delay:.5, y:loader.y - 25, onComplete:function():void {
				TweenMax.to(t, .8, {alpha:1});
			}});
			
			addEventListener(Event.ENTER_FRAME, function(e:Event):void {
				if (stage.loaderInfo.bytesTotal == 0) return;
				
				var progress:Number = stage.loaderInfo.bytesLoaded / stage.loaderInfo.bytesTotal;
				loader.mask1.width = Math.round(progress * maskW);
				loader.mask2.width = maskW - loader.mask1.width;
				t.text = "" + Math.round(progress * 100) + "%";
				
				if (stage.loaderInfo.bytesLoaded != stage.loaderInfo.bytesTotal) return;
				
				removeChild(loader);
				removeChild(t);
				nextFrame();
				stage.quality = StageQuality.HIGH;
				var main:Class = Class(getDefinitionByName("EverybodyEdits"));
				addChild(new main());
				removeEventListener(Event.ENTER_FRAME, arguments.callee);
			});
		}
		
	}
}