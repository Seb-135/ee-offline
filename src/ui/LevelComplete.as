package ui
{
	import blitter.Bl;
	
	import com.greensock.*;
	import com.greensock.easing.*;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.utils.setTimeout;
	
	import io.player.tools.Badwords;
	
	import items.ItemManager;
	
	import ui.profile.FriendSmiley;

	public class LevelComplete extends assets_complete
	{
		[Embed(source="/../media/crown_silver.png")] protected var CrownSilver:Class;
		private var crown_silver:BitmapData = new CrownSilver().bitmapData
		private var profile_smiley:Sprite;
		
		public function LevelComplete()
		{
			super();
			
			addEventListener(MouseEvent.MOUSE_DOWN, function(e:MouseEvent):void{
				e.preventDefault();
				e.stopImmediatePropagation()
				e.stopPropagation();
			});
			
			addEventListener(KeyboardEvent.KEY_DOWN, function(e:KeyboardEvent):void{
				e.preventDefault();
				e.stopImmediatePropagation()
				e.stopPropagation();
			});
				
			name = "LevelCompleteScreen";
			
			tf_completed.text = 'You completed "' + Badwords.Filter(Global.currentLevelname.length > 0? Global.currentLevelname: 'Untitled World') + '"';
			
			btn_close.mouseEnabled = true;
			btn_close.addEventListener(MouseEvent.CLICK, close);
			
			var enabled:Boolean = false;
			
			//if(Bl.data.owner || Global.player_is_guest){
				btn_like.visible = false;
			//}else{
				//btn_like.gotoAndStop(Bl.data.liked ? 2 : 1);
				//
				//enabled = Bl.data.liked ? false : true;
				//btn_like.buttonMode = enabled;
				//btn_like.mouseEnabled = enabled;
				//btn_like.mouseChildren = enabled;
				//btn_like.addEventListener(MouseEvent.CLICK, like);				
			//}
			
			//if (Bl.data.owner || Global.player_is_guest){
				btn_favorite.visible = false;
			//} else {
				//btn_favorite.gotoAndStop(Bl.data.inFavorites ? 2 : 1);
				//
				//enabled = Bl.data.inFavorites ? false : true;
				//btn_favorite.buttonMode = enabled;
				//btn_favorite.mouseEnabled = enabled;
				//btn_favorite.mouseChildren = enabled;
				//btn_favorite.addEventListener(MouseEvent.CLICK, favorite);
			//}
			
			//if (Global.hasSubscribedToCrew) {
				//btnSubscribe.buttonMode = false;
				//btnSubscribe.mouseEnabled = false;
				//btnSubscribe.text.text = "Thanks for subscribing";
			//} else if (Global.currentLevelCrew != "") {
				//btnSubscribe.text.text = "Subscribe to " + Global.currentLevelCrewName;
				//btnSubscribe.buttonMode = true;
				//btnSubscribe.text.mouseEnabled = false;
				//btnSubscribe.addEventListener(MouseEvent.CLICK, function(e:MouseEvent):void {
					//Global.base.requestCrewLobbyMethod("crew" + Global.currentLevelCrew, "subscribe", null, null);
					//btnSubscribe.buttonMode = false;
					//btnSubscribe.mouseEnabled = false;
					//btnSubscribe.text.mouseEnabled = false;
					//btnSubscribe.text.text = "Thanks for subscribing";
				//});
			//} else {
				btnSubscribe.visible = false;
			//}
			
			var smileygx:FriendSmiley = new FriendSmiley(ItemManager.smileysBMD);
			smileygx.frame = Global.playState.player.frame;			
			var smileybitmap:Bitmap = smileygx.getAsBitmap(6);
			smileybitmap.y = 6;			

			var crown:FriendSmiley = new FriendSmiley(crown_silver);
			var crownbitmap:Bitmap = crown.getAsBitmap(6);

			profile_smiley = new Sprite();
			profile_smiley.addChild(smileybitmap);
			profile_smiley.addChild(crownbitmap);
			profile_smiley.x = -smileybitmap.width/2;
			profile_smiley.y = -smileybitmap.height/2;
			headanimation.holder.addChild(profile_smiley);
			
			
			addEventListener(Event.ADDED_TO_STAGE, handleAddedToStage, false, 0 ,true);
			
		}
		
		protected function handleAddedToStage(event:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE,handleAddedToStage);
			addEventListener(Event.REMOVED_FROM_STAGE, handleRemovedFromStage, false, 0, true);
		}
		
		protected function handleRemovedFromStage(event:Event):void
		{
			removeEventListener(Event.REMOVED_FROM_STAGE,handleRemovedFromStage);
			
		}
		
		private function closeToLobby(e:Event=null):void
		{
			close();
			Global.base.ShowLobby();
		}
		
		private function favorite(e:Event=null) : void
		{
			if (!Bl.data.inFavorites){
				btn_favorite.gotoAndStop(2);
				btn_favorite.buttonMode = false;
				btn_favorite.useHandCursor = false;
				btn_favorite.mouseEnabled = false;
			}
		}
		
		private function like(e:Event=null):void
		{
			if (!Bl.data.liked){
				btn_like.gotoAndStop(2);
				btn_like.buttonMode = false;
				btn_like.useHandCursor = false;
				btn_like.mouseEnabled = false;
			}
		}
		
		public function close(e:Event=null):void
		{
			if(stage) stage.focus = Global.base
			this.parent.removeChild(this);
		}
		
	}
}