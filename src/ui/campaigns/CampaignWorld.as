package ui.campaigns
{
	import com.greensock.*;
	import flash.utils.ByteArray;
	import sample.ui.components.Rows;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.filters.GlowFilter;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.net.URLRequest;
	import flash.text.TextFieldAutoSize;
	
	import sample.ui.components.Box;
	import sample.ui.components.Label;
	
	public class CampaignWorld extends Sprite
	{
		
		public var worldImage:Bitmap;
		
		public var main:Box;
		
		private var _lock:Bitmap;
		public var _check:Bitmap;
		public var checkVisible:Boolean = true;
		
		private var _locked:Boolean;
		private var _complete:Boolean;
		private var _lockedCampaign:Boolean;
		
		private var _worldName:String;
		private var worldOwner:String;
		private var tierInfo:String;
		private var _image:Bitmap;
		
		private var worldWidth:int;
		private var worldHeight:int;
		private var _worldData:ByteArray;
		private var difficulty:int;
		private var _tier:int;
		
		private var label:Label;
		private var byLabel:Label;
		private var tierLabel:Label;
		
		private var _rewards:Array;
		public var rewards:Box = new Box();
		
		public var trialsEnabled:Boolean;
		public var time:int;
		public var rank:int;
		public var fullTargetTimes:Array;
		public var targetTimes:Array;
		
		public var times:Sprite = new Sprite();
		
		public function CampaignWorld(name:String, owner:String, diff:int, tier:int, status:int, imageData:BitmapData, rewards:Array, imageLoadedCallback:Function, worldData:ByteArray, trialsEnabled:Boolean, targetTimes:Array = null, time:int = -1, rank:int = 0)
		{
			main = new Box();
			main.border(1, 0x999999, 1);
			main.fill(0x111111, 1, 5);
			main.buttonMode = true;
			addChild(main);
			
			//---
			_locked = status == -1;
			_complete = status == 1;
			_lockedCampaign = status == 3;
			_worldName = name;
			worldOwner = owner;
			_worldData = worldData;
			difficulty = diff;
			worldWidth = 200;
			worldHeight = 200;
			//_image = image;
			_tier = tier;
			_rewards = rewards;
			//---
			
			//---
			
			this.trialsEnabled = trialsEnabled;
			if(trialsEnabled) {
				this.fullTargetTimes = targetTimes.concat();
				updateTargetTimes(rank, time);
			}
			//---
			
			label = new Label(_worldName + "\nBy: " + worldOwner, 12, "left", 0xffffff, false, "visitor");
			label.x = 2;
			label.y = 3;
			
			main.width = (label.width > worldWidth) ? label.width : worldWidth + 6;
			main.height = worldHeight;
			
			main.addChild(label);
			
			//var miniLoading:assets_miniloading = new assets_miniloading();
			//miniLoading.x = (width - miniLoading.width) + 10;
			//miniLoading.y = (height - miniLoading.height) - 10;
			//main.addChild(miniLoading);
			
			//var loader:Loader = new Loader();
			//loader.contentLoaderInfo.addEventListener(Event.INIT, function(e:Event):void
			//{
				//main.removeChild(miniLoading);
				
				var data:BitmapData = imageData;
				//data.draw(loader.content);
				_image = new Bitmap(data);
				
				// Create world image limited in width and height to make sure it won't go outside of the CampaignItem
				worldImage = new Bitmap(new BitmapData(_image.width > 255 ? 255 : _image.width, _image.height > 117 ? 117 : _image.height));
				worldImage.bitmapData.draw(_image);
				
				main.removeChild(label);
				
				worldWidth = _image.width;
				worldHeight = _image.height;
				main.width = (label.width > _image.width) ? label.width : _image.width + 6;
				main.height = _image.height + 28;
				
				main.addChild(label);
				
				_image.x = (main.width - _image.width) / 2;
				_image.y = ((main.height - _image.height) / 2) + label.height - 10;
				main.addChild(_image);
					
				if (_locked)
				{
					_lock = new Bitmap(CampaignItem.lockImage, "auto", true);
					_lock.height = (((_image.height / 2) > 100) ? 100 : _image.height / 2);
					_lock.width = _lock.height;
					_lock.x = _image.x + (_image.width - _lock.width) / 2;
					_lock.y = _image.y + (_image.height - _lock.height) / 2;
					main.addChild(_lock);
					
					_image.alpha = 0.25;
				}
				
				if (_complete)
				{
					AddCheckMark(false);
				}
				
				positionTimes();
				
				imageLoadedCallback();
			//});
			//loader.loadBytes(imageData);
			
			positionTimes();
		}
		
		public function positionTimes():void {
			times.y = main.height + 2;
			times.x = Math.max(0, Math.round((main.width - times.width) / 2));
		}
		
		private var imageLoaded:Function;
		public function setImageLoadedCallback(callback:Function) : void
		{
			imageLoaded = callback;
			if (imageLoaded != null)
				imageLoaded(worldImage);
		}
		
		private function AddCheckMark(animate:Boolean) : void
		{
			_check = new Bitmap(CampaignItem.checkImage, "auto", true);
			_check.width = (animate) ? _image.height : (((_image.height / 2) > 100) ? 100 : _image.height / 2);
			_check.height = (animate) ? _image.height : (((_image.height / 2) > 100) ? 100 : _image.height / 2);
			_check.x = _image.x + (_image.width - _check.width) / 2;
			_check.y = _image.y + (_image.height - _check.height) / 2;
			_check.alpha = (animate) ? 0 : 1;
			_check.visible = checkVisible;
			main.addChild(_check);
			
			if (animate)
			{
				TweenMax.to(_check, 0.3, {
					x: _image.x + (_image.width - _check.width) / 2,
					y: _image.y + (_image.height - _check.height) / 2,
					width: 100,
					height: 100,
					alpha: 1
				});
			}
		}
		
		private function Unlock() : void
		{
			TweenMax.to(_lock, 0.3, {
				x: _image.x + (_image.width - _lock.width + 10) / 2,
				y: _image.y + (_image.height - _lock.height + 10) / 2,
				width: _lock.width + 10,
				height: _lock.height + 10,
				"onComplete": function() : void
				{
					TweenMax.to(_lock, 0.2, {
						x: _image.x + (_image.width - 10) / 2,
						y: _image.y + (_image.height - 10) / 2,
						width: 10,
						height: 10,
						alpha: 0,
						"onComplete": function() : void{
							TweenMax.to(_image, 0.2, {
								alpha: 1
							});
							main.removeChild(_lock);
						}
					});
				}
			});
		}
		
		public function set complete(value:Boolean) : void{
			_complete = value;
			
			if (_complete){
				AddCheckMark(/*true*/ false);
			}
		}
		
		public function get tier() : int{
			return _tier;
		}
		
		public function get diff() : int{
			return difficulty;
		}
		
		public function get completed() : Boolean{
			return _complete;
		}
		
		public function get worldName() : String{
			return _worldName;
		}
		
		public function get worldData():ByteArray {
			return _worldData;
		}
		
		public function CampaignLocked():Boolean {
			return _lockedCampaign;
		}
		
		public function get locked() : Boolean{
			return _locked;
		}
		
		public function set locked(value:Boolean) : void{
			_locked = value;
			
			if (_locked == false)
				Unlock();
		}
		
		override public function get width():Number {
			return main.width;
		}
		override public function get height():Number {
			return main.height;
		}
		
		public function updateTargetTimes(rank:int = 0, time:int = -1):void {
			var targetTimes:Array = fullTargetTimes.concat();
			if (rank < 5) targetTimes.pop();
			if (rank < 3) targetTimes.pop();
			this.targetTimes = targetTimes;
			this.rank = rank;
			this.time = time;
			if(Global.base.campaigns)
				Global.base.campaigns.initCampaignWorlds(Global.currentCampId.toString());
		}
	}
}