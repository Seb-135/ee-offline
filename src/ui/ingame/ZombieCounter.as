package ui.ingame
{
	import states.PlayState;

	public class ZombieCounter extends assets_zombiesvshumans
	{
		private var limit:int;
		
		public function ZombieCounter(limit:int)
		{
			super();
			this.visible = false;
			this.limit = limit;
		}

		public function update():void {
			countPlayers();
		}
		
		public function setLimit(newLimit:int):void {
			this.limit = newLimit;
			update();
		}
		
		private function countPlayers():void {
			var playState:PlayState = Global.base.state as PlayState;
			
			var numZombies:int = playState.player.zombie ? 1 : 0;;
			var numPlayers:int = 1;
			
			this.tf_zombies.text = numZombies + "/" + numPlayers;
			
			if (numZombies == 0) {
				this.visible = false;
			} else {
				this.visible = true;
			}
		}
	}
}