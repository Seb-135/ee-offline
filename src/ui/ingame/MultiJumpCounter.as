package ui.ingame
{
	import states.PlayState;

	public class MultiJumpCounter extends assets_multijumpcounter
	{
		public function MultiJumpCounter()
		{
			super();
			
			this.visible = Global.playerInstance.maxJumps != 1;
			Global.playerInstance.multiJumpEffectDisplay = this;
		}
		
		public function update():void {
			this.visible = Global.playerInstance.maxJumps != 1;
			var jc:int =  Global.playerInstance.jumpCount;
			var mj:int =  Global.playerInstance.maxJumps;
			
			if (Global.playerInstance.maxJumps == 1000) {
				this.tf_jumps.text = "Inf.";
			}
			else if (Global.playerInstance.maxJumps == 0) {
				this.tf_jumps.text = "None";				
			}
			else this.tf_jumps.text = (jc > mj ? 0 : mj - jc).toString();
		}
	}
}