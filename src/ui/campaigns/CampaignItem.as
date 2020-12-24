package ui.campaigns
{
	import com.greensock.*;
	import com.greensock.TweenMax;
	import com.greensock.motionPaths.RectanglePath2D;
	import com.greensock.plugins.DropShadowFilterPlugin;
	import flash.display.DisplayObject;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.*;
	import flash.filters.BitmapFilterQuality;
	import flash.filters.GlowFilter;
	import flash.net.*;
	import flash.text.AntiAliasType;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.utils.clearInterval;
	import flash.utils.setInterval;
	
	import sample.ui.components.Label;
	import ui.campaigns.Clock;
	
	//import ui2.difficulties;
	
	public class CampaignItem extends Sprite
	{
		
		[Embed(source="/../media/campaigns/lock.png")] protected static var Lock:Class;
		public static var lockImage:BitmapData = new Lock().bitmapData;
		
		[Embed(source="/../media/campaigns/check.png")] protected static var Check:Class;
		public static var checkImage:BitmapData = new Check().bitmapData;
		
		private var _campaignWorlds:Array = [];
		
		private var imageId:int;
		
		private var _title:String;
		private var _id:String;
		
		public var _check:Bitmap;
		public var _clock:Bitmap;
		private var _lock:Bitmap;
		private var image:Bitmap;
		
		private var _comp:Boolean;
		private var _diff:int;
		private var _locked:Boolean;
		private var _hidden:Boolean;
		private var _maxTier:int;
		
		private var _campaignName:Label;
		private var _campaignDescription:Label;
		private var tierLabel:Label;
		private var nameLabel:Label;
		
		private var mapContainer:Sprite;
		private var imageMask:Sprite = new Sprite();
		private var tierLabelContainer:Sprite;
		
		private var _difficulty:asset_difficulty = new asset_difficulty;
		
		private var innerGlow:GlowFilter;
		
		public var clockDisplay:DisplayObject;
		public var worstRank:int;
		
		//~330~ 280 : Width
		//200 : Height
		
		public function CampaignItem(id:String, title:String, desc:String, diff:int, comp:Boolean, unlocked:Boolean, hidden:Boolean, maxTier:int)
		{
			graphics.lineStyle(1,0x999999);
			graphics.beginFill(0x111111,1);
			graphics.drawRoundRect(0, 0,/*330*/280, 200, 5, 5);
			graphics.endFill();
			
			imageMask.graphics.beginFill(0xFFFFFF,1);
			imageMask.graphics.drawRect(0,0,/*306*/256,117);
			imageMask.graphics.endFill();
			
			mapContainer = new Sprite();
			mapContainer.x = 12;
			mapContainer.y = 70;
			mapContainer.graphics.lineStyle(1,0x999999);
			mapContainer.graphics.beginFill(0x000000,1);
			mapContainer.graphics.drawRoundRect(0,0,/*306*/256,118,5,5);
			mapContainer.graphics.endFill();
			addChild(mapContainer); //
			
			tierLabelContainer = new Sprite();
			tierLabelContainer.x = mapContainer.x + 1;
			tierLabelContainer.y = mapContainer.y + (mapContainer.height - 33) / 2;
			tierLabelContainer.graphics.beginFill(0x000000,0.5);
			tierLabelContainer.graphics.drawRect(0,0,mapContainer.width - 2,33);
			tierLabelContainer.graphics.endFill();
			addChild(tierLabelContainer); //
			
			tierLabel = new Label("",8,"left",0xFFFFFF,false,"system");
			tierLabel.width = tierLabelContainer.width;
			tierLabel.x = (tierLabelContainer.width - tierLabel.width) / 2;
			tierLabel.y = 4;
			tierLabelContainer.addChild(tierLabel);
			
			nameLabel = new Label("",8,"left",0xFFFFFF,false,"system");
			nameLabel.width = tierLabelContainer.width;
			nameLabel.x = (tierLabelContainer.width - nameLabel.width) / 2;
			nameLabel.y = tierLabel.y + tierLabel.height - 3;
			tierLabelContainer.addChild(nameLabel);
			
			buttonMode = true;
			
			_id = id;
			_title = title;
			_comp = comp;
			_diff = diff;
			_locked = !unlocked;
			_hidden = hidden;
			_maxTier = maxTier;
			
			_campaignName = new Label(title,14,"left",0xFFFFFF,false,"system");
			_campaignName.x = (280 - _campaignName.width) / 2;
			_campaignName.y = 8;
			addChild(_campaignName);
			
			_campaignDescription = new Label(desc,8,"center",0x888888,true,"system");
			_campaignDescription.width = 280 - 10;
			_campaignDescription.x = (280 - _campaignDescription.width) / 2;
			_campaignDescription.y = 27;
			addChild(_campaignDescription);
			
			_difficulty.gotoAndStop(diff + 1);
			_difficulty.y = mapContainer.y + mapContainer.height + _difficulty.height - 1;//(((_campaignDescription.y + _campaignDescription.height + mapContainer.y) - difficulty.height) / 2) + 3;
			_difficulty.x = 280 / 2;
			addChild(_difficulty);
			
			//added a container so when mousing over the textfields it will use the hand cursor
			var textFieldsContainer:Sprite = new Sprite();
			textFieldsContainer.mouseChildren = false;
			textFieldsContainer.buttonMode = true;
			
			textFieldsContainer.addChild(_campaignName);
			textFieldsContainer.addChild(_campaignDescription);
			textFieldsContainer.addChild(mapContainer);
			textFieldsContainer.addChild(tierLabelContainer);
			addChild(textFieldsContainer);
			
			innerGlow = new GlowFilter();
			innerGlow.inner = true;
			innerGlow.color = 0x000000;
			innerGlow.quality = BitmapFilterQuality.HIGH;
			innerGlow.blurX = 50;
			innerGlow.blurY = 50;
			innerGlow.strength = 1.5;
			
			if (comp) {
				AddCheckMark(false);
			} else if(_locked){
				_lock = new Bitmap(lockImage, "auto", true);
				_lock.width = 100;
				_lock.height = 100;
				_lock.x = (width - _lock.width) / 2;
				_lock.y = (height - _lock.height) / 2 + 32;
				imageMask.alpha = 0.25;
				addChild(_lock);
			}
			
			setInterval(StartSlideShow, 4000);
		}
		
		public function getFirstWorld () : CampaignWorld
		{
			if (campaignWorlds.length > 0){
				return (campaignWorlds[0] as CampaignWorld);
			}
			return null;
		}
		
		private function StartSlideShow() : void{
			if (image == null)
				return;
			
			TweenMax.to(image,0.4,{
				alpha:0,
				"onComplete":function():void{
					if (mapContainer.contains(image)) mapContainer.removeChild(image);
					if (mapContainer.contains(imageMask)) mapContainer.removeChild(imageMask);
					
					imageId++;
					if (imageId >= campaignWorlds.length) imageId = 0;
					setImage((campaignWorlds[imageId] as CampaignWorld).worldImage);
				}
			});
		}
		
		private function setImage(img:Bitmap) : void
		{
			if (img == null)
				return;
			image = img;
			
			if (image.height < 100 && image.width < 100){
				image.width = 100;
				image.height = 100;
			}
			
			image.alpha = 0;
			image.y = (mapContainer.height - image.height) / 2;
			image.x = (mapContainer.width - image.width) / 2;
			image.mask = imageMask;
			image.filters = [innerGlow];
			mapContainer.addChild(image);
			mapContainer.addChild(imageMask);
			
			tierLabel.text = "Tier " + campaignWorlds[imageId].tier;
			tierLabel.x = (tierLabelContainer.width - tierLabel.width) / 2;
			tierLabel.y = 4;
			
			nameLabel.text = campaignWorlds[imageId].worldName;
			nameLabel.x = (tierLabelContainer.width - nameLabel.width) / 2;
			nameLabel.y = tierLabel.y + tierLabel.height - 3;
			
			TweenMax.to(image,0.4,{ alpha:1 });
		}
		
		private function AddCheckMark(animate:Boolean) : void
		{
			_check = new Bitmap(checkImage, "auto", true);
			_check.width = (animate) ? 200 : 100;
			_check.height = (animate) ? 200 : 100;
			_check.x = (width - _check.width) / 2;
			_check.y = mapContainer.y + (mapContainer.height - _check.height) / 2;
			_check.alpha = (animate) ? 0 : 1;
			addChild(_check);
			
			if (animate)
			{
				TweenMax.to(_check, 0.3, {
					x: (width - 100) / 2,
					y: mapContainer.y + (mapContainer.height - 100) / 2,
					width: 100,
					height: 100,
					alpha: 1
				});
			}
		}
		
		private function AddClock(rank:int) : void
		{
			if (rank > 0 && rank < 6) {
				if(clockDisplay && clockDisplay.parent) 
					clockDisplay.parent.removeChild(clockDisplay);
					
				var fullClocks:BitmapData = Clock.clocksBMD;
				var currClockBMD:BitmapData = new BitmapData(15, 15);
				var currClockRect:Rectangle = new Rectangle(rank * 15, 0, 15, 15);
				currClockBMD.copyPixels(fullClocks, currClockRect, new Point());
				
				_clock = new Bitmap(currClockBMD);
				_clock.width = 45;
				_clock.height = 45;
				//_clock.x = (width - _clock.width) / 2;
				//_clock.y = mapContainer.y + (mapContainer.height - _clock.height) / 2;
				_clock.x = mapContainer.x + 3;
				_clock.y = mapContainer.y + 3;
				_clock.alpha = 1;
				clockDisplay = addChild(_clock);
				
				this.worstRank = rank;
			}
		}
		
		public function set completed(value:Boolean) : void{
			_comp = value;
			
			if (_comp){
				AddCheckMark(/*true*/ false);
			}
		}
		
		public function set newRank(value:int) : void{
			AddClock(value);
		}
		
		public function get campaignName() : Label{
			return _campaignName;
		}
		
		public function get id() : String
		{
			return _id;
		}
		
		public function get title() : String
		{
			return _title;
		}
		
		public function get completed() : Boolean
		{
			return _comp;
		}
		
		public function get locked():Boolean
		{
			return _locked;
		}
		
		public function get hidden():Boolean
		{
			return _hidden;
		}
		
		public function get maxTier():int
		{
			return _maxTier;
		}
		
		public function get difficulty() : int
		{
			return _diff;
		}
		
		public function addWorld(cWorld:CampaignWorld) : void
		{
			campaignWorlds.push(cWorld);
			var id:int = campaignWorlds.length;
			cWorld.setImageLoadedCallback(function(img:Bitmap): void
			{
				if (id == 1)
					setImage(img);
			});
		}
		
		public function clearWorlds() : void
		{
			_campaignWorlds = [];
		}
		
		public function get campaignWorlds() : Array
		{
			return _campaignWorlds;
		}
		
		public function set campaignWorlds(value:Array) : void
		{
			_campaignWorlds = value;
		}
	}
}