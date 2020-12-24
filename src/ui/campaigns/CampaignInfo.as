package ui.campaigns
{
	import flash.events.MouseEvent;
	
	import ui2.CampaignInfo;
	
	public class CampaignInfo extends ui2.CampaignInfo
	{
		private var _difficulty:int = 0;
		private var _tier:int = 1;
		private var _maxTier:int = 1;
		private var _campaignName:String;
		
		override public function CampaignInfo()
		{
			super();
			
			displayLockedInfo("UNKNOWN");
		}
		
		public function displayInfo(campaignName:String, difficulty:int, tier:int, maxTier:int, completed:Boolean):void
		{
			this._campaignName = campaignName;
			this._difficulty = difficulty;
			this._tier = tier;
			this._maxTier = maxTier;
			
			gotoAndStop(2);
			
			campaignNameTF.text = campaignName;
			tierTF.text = tier + "/" + maxTier;
			
			if (0 <= difficulty && difficulty < 10)
				difficultyIcon.gotoAndStop(difficulty + 1);
			else
				difficultyIcon.gotoAndStop(1);
			
			updateStatus(completed);
		}
		
		public function updateStatus(completed:Boolean):void
		{
			statusIcon.gotoAndStop(completed ? 2 : 1);
		}
		
		public function displayLockedInfo(campaignName:String):void
		{
			gotoAndStop(1);
			infoTF.text = "This world is part of the " + campaignName + " campaign.\nYou will need to unlock it in order to track your progress.";
		}
		
		public function displayBetaOnlyInfo(campaignName:String):void
		{
			gotoAndStop(1);
			infoTF.text = "This world is part of a campaign currently only available to Beta members. Get Beta if you would like to play it now!";
		}
		
		public function displayLockedCampaignInfo(campaignName:String):void {
			gotoAndStop(1);
			infoTF.text = "This world is part of a locked campaign.\n Play other campaigns to unlock it!";
		}
		
		public function get campaignName() : String{
			return _campaignName;
		}
		
		public function get difficulty():int
		{
			return _difficulty;
		}
		
		public function get tier():int
		{
			return _tier;
		}
		
		public function get maxTier():int
		{
			return _maxTier;
		}
	}
}