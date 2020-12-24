package ui.ingame
{
	import states.PlayState;

	public class CurseCounter extends assets_cursecounter
	{
		private var limit:int;
		
		public function CurseCounter(limit:int)
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
			
			var numCursed:int = playState.player.cursed ? 1 : 0;
			var numPlayers:int = 1;
			
			this.tf_curses.text = numCursed + "/" + numPlayers;
			
			if (numCursed == 0) {
				this.visible = false;
			} else {
				this.visible = true;
			}
		}
	}
}