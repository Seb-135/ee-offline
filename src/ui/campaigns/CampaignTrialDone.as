package ui.campaigns {
	import blitter.Bl;
	import flash.display.SimpleButton;
	import flash.utils.getTimer;
	import items.ItemManager;
	import items.ItemSmiley;
	
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
	
	public class CampaignTrialDone extends Sprite {
		
		public function CampaignTrialDone(rank:int, time:int, lastRank:int = 0, lastTime:int = -1, nextTime:int = -1):void {
			name = "CampaignTrialDoneScreen";
			
			//Darkens the screen
			var blackBG:BlackBG = new BlackBG();
			blackBG.width = 660;
			addChild(blackBG);
			
			var newTime:Boolean = lastTime < 0 || time < lastTime;
			var newRank:Boolean = rank > lastRank;
			
			var pivot:Sprite = new Sprite();
			pivot.x = 640 / 2;
			pivot.y = 470 / 2;
			addChild(pivot);
			alphaFade(pivot, .5, 1);
			
			var startTime:int = getTimer();
			
			//Spinny thingy
			var starburst:assets_lightrotation = new assets_lightrotation();
			starburst.alpha = .75;
			starburst.x = -starburst.width / 2;
			starburst.y = -starburst.height / 2;
			pivot.addChild(starburst);
			
			if (newRank) {				
				var clock:Clock = new Clock(rank);
				clock.scaleX = clock.scaleY = 4;
				clock.x = -clock.width / 2;
				clock.y = -clock.height / 2;
				pivot.addChild(clock);
			} else {
				var pivot2:Sprite = !newTime ? new Sprite() : null;
				if (pivot2) pivot.addChild(pivot2);
				
				var smiley:Bitmap = new Bitmap(ItemManager.getSmileyById(newTime ? 1 : 2).bmd);
				smiley.scaleX = smiley.scaleY = 4;
				smiley.x = -smiley.width / 2;
				smiley.y = -smiley.height / 2;
				(newTime ? pivot : pivot2).addChild(smiley);
				
				if (!newTime) {
					pivot2.addEventListener(Event.ENTER_FRAME, function():void {
						pivot2.rotation = Math.sin((getTimer() - startTime) * .001 * 2) * 30;
					});
				}
			}
			
			if (newRank || newTime) {
				pivot.addEventListener(Event.ENTER_FRAME, function():void {
					pivot.y = 470 / 2 + Math.sin((getTimer() - startTime) * .001 * 3) * 6;
				});
			}
			
			//Dark box below header text
			var headerBox:Sprite = new Sprite();
			headerBox.y = -80;
			headerBox.graphics.clear();
			headerBox.graphics.beginFill(0x222222, 0.85);
			headerBox.graphics.drawRect(0, 0, 640, 57);
			headerBox.graphics.endFill();
			addChild(headerBox);
			TweenMax.to(headerBox, 0.5, { y:27 });
			
			var headerLabel:Label = new Label(newRank ? "Congratulations!" : newTime ? "New personal best!" : "Better luck next time!", newRank || newTime ? 30 : 26, "left", 0xFFFFFF, false, "system");
			headerLabel.x = Math.round((640 - headerLabel.width) / 2);
			headerLabel.y = -100;
			addChild(headerLabel);
			TweenMax.to(headerLabel, 0.5, { y:newRank || newTime ? 38 : 40 });
			
			//Dark box below footer text
			var footerBox:Sprite = new Sprite();
			footerBox.y = 510;
			footerBox.graphics.clear();
			footerBox.graphics.beginFill(0x222222, 0.85);
			footerBox.graphics.drawRect(0, 0, 640, 57);
			footerBox.graphics.endFill();
			addChild(footerBox);
			TweenMax.to(footerBox, 0.5, { y:350});
			
			var labelTime:Label = new Label("Time: " + ClockTime.format(time), 16, "left", 0xFFFFFF, false, "system");
			labelTime.setTextFormat(new TextFormat(null, null, newRank ? ClockTime.rankColor(rank) : newTime ? 0x40FF40 : 0xff4040), 5, labelTime.length);
			labelTime.x = (640 - labelTime.width) / 2;
			labelTime.y = 510;
			addChild(labelTime);
			TweenMax.to(labelTime, 0.5, { y:350 + Math.floor((footerBox.height - labelTime.height) / 2) });
			
			var prefix:String;
			
			if (lastTime >= 0) {
				prefix = newTime ? "Previous Best: " : "Personal Best: ";
				var labelPrevious:Label = new Label(prefix + ClockTime.format(lastTime), 11, "left", 0x9f9f9f, false, "system");
				labelPrevious.setTextFormat(new TextFormat(null, null, 0xDFDFDF), prefix.length, labelPrevious.length);
				labelPrevious.x = 20;
				labelPrevious.y = 510;
				addChild(labelPrevious);
				TweenMax.to(labelPrevious, 0.5, { y:350 + Math.floor((footerBox.height - labelPrevious.height) / 2) });
			}
			
			if (nextTime >= 0) {
				prefix = newRank ? "Next Goal: " : "Current Goal: ";
				var labelGoal:Label = new Label(prefix + ClockTime.format(nextTime), 11, "left", 0x9f9f9f, false, "system");
				labelGoal.setTextFormat(new TextFormat(null, null, 0xDFDFDF), prefix.length, labelGoal.length);
				labelGoal.x = 640 - labelGoal.width - 20;
				labelGoal.y = 510;
				addChild(labelGoal);
				TweenMax.to(labelGoal, 0.5, { y:350 + Math.floor((footerBox.height - labelGoal.height) / 2) });
			}
			
			var dismissButton:assets_dismiss = new assets_dismiss();
			dismissButton.alpha = 0;
			dismissButton.x = 3;
			dismissButton.y = 446;
			dismissButton.addEventListener(MouseEvent.CLICK, function(e:MouseEvent):void{
				Global.base.hideCampaignTrialDone();
			});
			addChild(dismissButton);
			alphaFade(dismissButton,0.2,1);
			
			var retryMain1:assets_retry = new assets_retry();
			retryMain1.label.autoSize = TextFieldAutoSize.LEFT;
			retryMain1.label.text += " (" + KeyBinding.retryRun.key.print() + ")";
			retryMain1.label.setTextFormat(new TextFormat(null, null, 0x999999), 5, retryMain1.label.length);
			var retryMain2:assets_retry = new assets_retry();
			retryMain2.label.autoSize = TextFieldAutoSize.LEFT;
			retryMain2.label.text = retryMain1.label.text;
			retryMain2.label.setTextFormat(new TextFormat(null, null, 0x999999), 5, retryMain1.label.length);
			
			var retryW:Number = retryMain1.width + 15;
			
			var retryUp:Sprite = new Sprite();
			retryUp.addChild(retryMain1);
			retryUp.graphics.beginFill(0x222222);
			retryUp.graphics.lineStyle(1, 0xcccccc, 1, true);
			retryUp.graphics.drawRoundRect(0, 0, retryW, 18, 3, 5);
			var retryOver:Sprite = new Sprite();
			retryOver.addChild(retryMain2);
			retryOver.graphics.beginFill(0x333333);
			retryOver.graphics.lineStyle(1, 0xcccccc, 1, true);
			retryOver.graphics.drawRoundRect(0, 0, retryW, 18, 3, 5);
			
			var retryButton:SimpleButton = new SimpleButton(retryUp, retryOver, retryOver, retryUp);
			retryButton.alpha = 0;
			retryButton.x = dismissButton.x + dismissButton.width + 5;
			retryButton.y = 446;
			retryButton.addEventListener(MouseEvent.CLICK, function(e:MouseEvent):void{
				Global.base.hideCampaignTrialDone();
				Global.playState.player.resetPlayer();
			});
			addChild(retryButton);
			alphaFade(retryButton,0.2,1);
			
			addEventListener(MouseEvent.MOUSE_DOWN, function(e:MouseEvent):void{
				e.preventDefault();
				e.stopImmediatePropagation()
				e.stopPropagation();
			});
		}
		
		private function alphaFade(o:*, speed:Number, newAlpha:Number):void {
			if (o.alpha == newAlpha) return;
			TweenMax.to(o, speed, { alpha:newAlpha });
		}
		
	}
}