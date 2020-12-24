package ui.profile
{
	import flash.display.Bitmap;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import ui.social.SocialFriend;
	
	import io.player.tools.Badwords;
	
	import items.ItemManager;
	
	import mx.utils.StringUtil;
	
	public class FriendItem extends asset_friend {
		
		public static const DELETE:String = "delete";
		public static const BLOCK:String = "block";
		
		public var friend:SocialFriend;
		private var altType:String;
		private var altUsername:String;
		
		public function get type():String {
			// Since friend can be null for invites, use this getter when necessary
			return friend ? friend.type : altType;
		}
		public function set type(s:String):void { if (friend) friend.type = s; else altType = s; }
		public function get username():String { return friend ? friend.username : altUsername; }
		public function set username(s:String):void { if (friend) friend.username = s; else altUsername = s; }
		
		private var smileyGraphics:FriendSmiley; 
		private var smileyBitmap:Bitmap;
		private var smileyHolder:MovieClip;
		
		public function FriendItem(friend:SocialFriend, altType:String = null) {
			this.friend = friend;
			this.altType = altType;
			
			divider.mouseEnabled = false;
			addEventListener(MouseEvent.MOUSE_OVER, handleMouse, false, 0, true);
			
			setOnlineStatus();
		}
		
		private function setOnlineStatus():void {
			if (!friend || friend.type != SocialFriend.FRIEND) return;
			
			if (friend.online) {
				tf_online.text = "Online";
				
				if (friend.worldId && friend.worldName) {
					btn_play.visible = true;
					btn_play.addEventListener(MouseEvent.MOUSE_DOWN, handleJoinWorld, false, 0, true);
					
					tf_online.appendText(" - Playing in: ");
					tf_playing.autoSize = TextFieldAutoSize.LEFT;
					tf_playing.text = friend.worldName;
					
					var container:Sprite = new Sprite();
					container.x = tf_playing.x;
					container.y = tf_playing.y;
					container.graphics.beginFill(0, 0);
					container.graphics.drawRect(-3, -3, tf_playing.textWidth + 6, tf_playing.textHeight + 6);
					addChild(container);
					container.useHandCursor = true;
					container.buttonMode = true;
					container.addEventListener(MouseEvent.MOUSE_DOWN, handleJoinWorld, false, 0, true);	
				}
				
				tf_online.setTextFormat(new TextFormat(null, null, 0x00ff00), 0, 6);
			} else {
				btn_play.visible = false;
				var lastSeenText:String = getElapsedTimeString(friend.lastSeen);
				tf_online.text = "Offline - Last seen:";	
				tf_playing.text = lastSeenText;
				
				tf_playing.setTextFormat(new TextFormat(null, null, 0x777777), 0, lastSeenText.length);
				tf_online.setTextFormat(new TextFormat(null, null, 0x777777), 8, tf_online.length);
			}
			
			smileyGraphics = new FriendSmiley(ItemManager.smileysBMD);
			smileyGraphics.frame = friend.smileyId;
			smileyGraphics.setRectY(friend.usingGoldBorder ? 26 : 0);
			if (smileyBitmap && smileyBitmap.parent) removeChild(smileyBitmap);
			smileyBitmap = smileyGraphics.getAsBitmap(2);
			smileyBitmap.x = 5;
			addChild(smileyBitmap);
		}
		
		private function getElapsedTimeString(time:Number):String
		{
			if (time < 0) {
				return "Never";
			} else {
				var timeSpan:TimeSpan = TimeSpan.fromDates(new Date(time * 1000), new Date());
				
				if (timeSpan.days >= 365)
					return "More than 1 year ago";
				if (timeSpan.days >= 30)
				{
					var months:int = timeSpan.days / 30;
					return months + " month" + (months > 1 ? "s" : "") + " ago";
				}
				if (timeSpan.days == 1)
					return "Yesterday";
				if (timeSpan.days > 0)
					return timeSpan.days + " days ago";
				if (timeSpan.hours > 0)
					return timeSpan.hours + " hour" + (timeSpan.hours > 1 ? "s" : "") + " ago";
				if (timeSpan.minutes > 0)
					return timeSpan.minutes + " minute" + (timeSpan.minutes > 1 ? "s" : "") + " ago";
				
				return "Few seconds ago";
			}
		}
		
		private function handleJoinWorld(event:MouseEvent):void
		{
			var navigationEvent:NavigationEvent = new NavigationEvent(NavigationEvent.JOIN_WORLD, true, false);
			navigationEvent.world_id = friend.worldId;
			dispatchEvent(navigationEvent);
		}
		
		private function removeSelf(event:MouseEvent = null):void
		{
			dispatchEvent(new Event(FriendItem.DELETE, true, false));
			if (parent) parent.removeChild(this);
		}
		
		private function handleMouse(event:MouseEvent):void
		{
			if (event.type == MouseEvent.MOUSE_OVER) {
				removeEventListener(MouseEvent.MOUSE_OVER, handleMouse);
				stage.addEventListener(MouseEvent.MOUSE_MOVE, handleMouse, false, 0, true);
			} else {
				var isOver:Boolean = getBounds(this).contains(mouseX, mouseY);
				showMouseOver(isOver);
				if (!isOver) {
					try {
						if (stage != null)
							stage.removeEventListener(MouseEvent.MOUSE_MOVE, handleMouse); 
					} catch(e:Error){}
					addEventListener(MouseEvent.MOUSE_OVER, handleMouse, false, 0, true);
				}
			}
		}
		
		private function showMouseOver(isOver:Boolean):void
		{
			// hack
			if (currentLabel == SocialFriend.WAITING) return;
			
			switch(type)
			{
				case SocialFriend.FRIEND:
				{
					btn_delete.visible = isOver;
					break;
				}
					
				case SocialFriend.CONFIRM:
				{
					break;
				}
					
				case SocialFriend.INVITE:
				{
					break;
				}
					
				case SocialFriend.PENDING:
				{
					btn_delete.visible = isOver;
					break;
				}
					
				case SocialFriend.INVITATION:
				{
					break;
				}
					
				case SocialFriend.BLOCKED:
				{
					break;
				}
			}
		}
		
		private function truncateText(field:TextField, text:String, numLines:int):void
		{
			field.text = text;
			
			for (var i:int = 0; i < text.length && field.numLines > numLines; i++) {
				field.text = StringUtil.trim(text.substring(0, text.length - i)).concat("...");
			}
		}
		
		public override function set height(h:Number):void
		{
			eventarea.height = h;
			divider.y = h - divider.height;
		}
		
		public override function set width(w:Number):void
		{
			var defaultButtonWidth:int = 45;
			var spacing:int = 10;
			
			eventarea.width = w;
			divider.width = w-4;
			var rightMargin:int = 8;
			
			divider_v.x = w - (2 * spacing) - defaultButtonWidth;  			
			divider_v.visible = true;
			
			// hack
			if (currentLabel == SocialFriend.WAITING) return;
			
			switch(type)
			{
				case SocialFriend.FRIEND:
				{
					btn_delete.x = divider_v.x + spacing;
					btn_play.x = divider_v.x + spacing;
					tf_name.width = divider_v.x - tf_name.x - spacing; 
					tf_online.width = divider_v.x - tf_online.x - spacing;
					tf_playing.width = divider_v.x - tf_playing.x - spacing;
					
					if (friend.worldName != null && friend.worldName.length > 0) {
						truncateText(tf_playing, friend.worldName, 1);
					}
					break;
				}
					
				case SocialFriend.CONFIRM:
				{
					divider_v.visible = false;
					tf_msg.width = w - 200;
					tf_msg.x = Math.round((w - tf_msg.width) / 2);
					btn_confirmcancel.x = w / 2 - btn_confirmcancel.width - 5;
					btn_confirmdelete.x = w / 2 + 5;
					break;
				}
					
				case SocialFriend.INVITE:
				{
					btn_send.x = divider_v.x + spacing;
					btn_cancel.x = divider_v.x + spacing;
					tf_mail.width = divider_v.x - tf_mail.x - spacing;
					tf_usermail.width = divider_v.x - tf_usermail.x - spacing;
					bg_mail.width = divider_v.x - bg_mail.x - spacing;
					tf_error.width = divider_v.x - tf_error.x - spacing;
					tf_moreinfo.width = divider_v.x - tf_error.x - spacing;
					
					break;
				}
					
				case SocialFriend.PENDING:
				{
					btn_delete.x = divider_v.x + spacing;
					tf_mail.width = divider_v.x - tf_mail.x - spacing;
					
					truncateText(tf_mail, "Pending response:\n" + username.toUpperCase(), 3);
					break;
				}
					
				case SocialFriend.INVITATION:
				{
					btn_accept.x = divider_v.x + spacing;
					btn_ignore.x = divider_v.x + spacing;
					btn_block.x = divider_v.x + spacing;
					tf_mail.width = divider_v.x - tf_mail.x - spacing;
					tf_error.width = divider_v.x - tf_error.x - spacing;
					
					truncateText(tf_mail, friend.username.toUpperCase() + " would like to be your friend.", 2);
					break;
				}
					
				case SocialFriend.ACCEPTED:
				case SocialFriend.REJECTED:
				{
					btn_ok.x = divider_v.x + spacing;
					tf_mail.width = divider_v.x - tf_mail.x - spacing;
					
					var messageText:String = friend.username.toUpperCase() + (friend.type == SocialFriend.ACCEPTED ? " has accepted your friend request." : " has rejected your friend request.");
					
					truncateText(tf_mail, messageText, 3);
					break;
				}
					
				case SocialFriend.BLOCKED:
				{
					btn_unblock.x = divider_v.x + spacing;
					tf_message.width = divider_v.x - tf_message.x - spacing;
					
					truncateText(tf_message, "\n" + friend.username.toUpperCase(), 3);
					break;
				}
			}
		}
	}
}
