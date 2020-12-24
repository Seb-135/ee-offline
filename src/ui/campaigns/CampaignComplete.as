package ui.campaigns
{
	import blitter.Bl;
	import states.LobbyState;
	
	import com.greensock.*;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Graphics;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.*;
	import flash.net.*;
	import flash.text.*;
	
	import sample.ui.components.Label;
	
	import states.LobbyStatePage;
	
	public class CampaignComplete extends Sprite
	{
		private var currentTier:int;
		private var maxTier:int;
		private var footerTextSize:int = 17;
		
		private var words:Array = ["first","second","third","fourth","fifth","sixth","seventh","eighth","ninth","tenth"];
		//private var rewards:Array;
		
		private var campaignName:String;
		private var imageURL:String;

		public function CampaignComplete(name:String, tier:int, maxTier:int /*rewards:Array, imageURL:String*/) : void
		{
			this.campaignName = name;
			this.currentTier = tier-1;
			this.maxTier = maxTier;
			//this.rewards = rewards;
			this.imageURL = imageURL;
			
			name = "CampaignCompleteScreen";
			redraw();
		}
		
		private function redraw() : void
		{
			//Darkens the screen
			var blackBG:BlackBG = new BlackBG();
			blackBG.width = 660;
			addChild(blackBG);
			
			//Spinny thingy
			var starburst:assets_lightrotation = new assets_lightrotation();
			starburst.alpha = 0;
			starburst.x = (640 - starburst.width) / 2;
			starburst.y = (470 - starburst.height) / 2;
			addChild(starburst);
			alphaFade(starburst,0.5,.75);
			
			//Dark box below header text
			var headerBox:Sprite = new Sprite();
			headerBox.y = -80;
			headerBox.graphics.clear();
			headerBox.graphics.beginFill(0x222222,0.85);
			headerBox.graphics.drawRect(0,0,640,57);
			headerBox.graphics.endFill();
			addChild(headerBox);
			TweenMax.to(headerBox,0.5,{y:27});
			
			var headerLabel:Label = new Label("Congratulations!",30,"left",0xFFFFFF,false,"system");
			headerLabel.x = 168;
			headerLabel.y = -100;
			addChild(headerLabel);
			TweenMax.to(headerLabel,0.5,{y:38});
			
			//Dark box below footer text
			var footerBox:Sprite = new Sprite();
			footerBox.y = 510;
			footerBox.graphics.clear();
			footerBox.graphics.beginFill(0x222222,0.85);
			footerBox.graphics.drawRect(0,0,640,33);
			footerBox.graphics.endFill();
			addChild(footerBox);
			TweenMax.to(footerBox,0.5,{y:350});
			
			var footerLabel:Label = new Label(getFooterText(), 14, "left",0xFFFFFF,false,"system");
			footerLabel.x = (640 - footerLabel.width) / 2;
			footerLabel.y = 510;
			addChild(footerLabel);
			TweenMax.to(footerLabel,0.5,{y:358});
			
			var image:BitmapData = CampaignPage.previews[Global.currentCampId][currentTier+1];
			if (currentTier == maxTier - 1){
				var badge:Bitmap = new Bitmap(image);
				badge.alpha = 1;
				badge.x = (640 - badge.width) / 2;
				badge.y = (470 - badge.height) / 2;
				addChild(badge);
			}else{
				var worldImage:Bitmap = new Bitmap(image);
				var imageContainer:Sprite = new Sprite();
				imageContainer.graphics.lineStyle(1, 0xFFFFFF, 1);
				imageContainer.graphics.drawRect(-1,-1,worldImage.width + 1,worldImage.height + 1)
				imageContainer.x = (640 - worldImage.width) / 2;
				imageContainer.y = (headerBox.y + headerBox.height + (footerBox.y - worldImage.height) / 2);
				imageContainer.buttonMode = true;
				imageContainer.useHandCursor = true;
				imageContainer.addEventListener(MouseEvent.CLICK,function(e:MouseEvent):void{
					//Global.base.ShowLobby(LobbyStatePage.CAMPAIGN);
					Global.ui2.goToLobby();
					Global.base.campaigns.loadWorld(Global.base.campaigns.currentCampaign.campaignWorlds[currentTier + 1]);
				});
				imageContainer.addChild(worldImage);
				addChild(imageContainer);
				
				var text:Label = new Label("Click to proceed to tier " + (currentTier + 2) + "!",12,"left",0xFFFFFF,false,"system");
				text.x = imageContainer.x + (imageContainer.width - text.width) / 2;
				text.y = imageContainer.y - text.height - 3;
				addChild(text);
			}
			
			var totalWidth:int = 0;
			
			var dismissButton:assets_dismiss = new assets_dismiss();
			dismissButton.alpha = 0;
			dismissButton.x = 3;
			dismissButton.y = 446;
			dismissButton.addEventListener(MouseEvent.CLICK, function(e:MouseEvent):void{
				Global.base.hideCampaignComplete();
			});
			addChild(dismissButton);
			alphaFade(dismissButton,0.2,1);
			
			addEventListener(MouseEvent.MOUSE_DOWN, function(e:MouseEvent):void{
				e.preventDefault();
				e.stopImmediatePropagation()
				e.stopPropagation();
			});
		}
		
		private function getFooterText() : String
		{
			if (currentTier != maxTier){
				return "You've completed the " + words[currentTier] + " tier of the " + campaignName + " Campaign!";
			}else{
				return "You've completed the " + campaignName + " Campaign!";
			}
		}
		
		private function alphaFade(o:*, speed:Number, newAlpha:Number) : void
		{
			if (o.alpha == newAlpha) return;
			TweenMax.to(o,speed,{alpha:newAlpha});
		}
	}
}