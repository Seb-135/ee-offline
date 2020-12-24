package
{
	import blitter.BlContainer;
	import blitter.BlSprite;
	import blitter.BlText;
	import flash.display.Bitmap;
	
	import flash.display.BitmapData;
	import flash.filters.GlowFilter;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import io.player.tools.Badwords;
	
	import mx.utils.StringUtil;
	
	public class Chat extends BlContainer
	{
		[Embed(source="/../media/microchat.png")] protected var microchatimage:Class;
		private var microchat:BlSprite = BlSprite.createFromBitmapData(new microchatimage().bitmapData)
		private var chats:Vector.<ChatBubble> = new Vector.<ChatBubble>();
		public var name:BlText
		private var color:uint;
		
		[Embed(source="/../media/teamdots.png")] protected var teamdotsimage:Class;
		private var teamdot:BlSprite = new BlSprite(new teamdotsimage().bitmapData, 0, 0, 16, 16, 6);
		
		public function Chat(nameText:String)
		{
			super();
			
			var roleColor:Number = Player.getNameColor(nameText);
			
			name = new BlText(14, 160, roleColor, "center", "visitor")
			name.filters = [new GlowFilter(0x0,2,2,2,2,3)]
			name.x = (-80 + 8)
			name.y = 15
			name.text = nameText;
			
			teamdot.y = 15;
		}
		
		public function set textColor(textcolor:uint):void
		{
			color = textcolor;
			var nameText:String = name.text;
			name = new BlText(14, 160, color, "center", "visitor")
			name.filters = [new GlowFilter(0x0,2,2,2,2,3)]
			name.x = (-80 + 8)
			name.y = 15
			name.text = nameText;			
		}
		
		public function say(text:String):void {
			//if (text.length > 80) {
				//text = text.substring(0,80);
				//text = StringUtil.trim(text);
				//text += "...";
			//}
			
			text = Badwords.Filter(text);
	
			var cb:ChatBubble = new ChatBubble(name.text, text);
			
			for (var a:int = 0; a < chats.length; a++) {
				var cc:ChatBubble = chats[a] as ChatBubble;
				cc.y -= cb.height - 5;
			}
			
			chats.push(cb);	
			if (chats.length > 3) {
				chats.shift();
			}
		}
		
		public override function enterFrame():void{
			for( var a:int=0;a<chats.length;a++){
				var cc:ChatBubble = chats[a] as ChatBubble
				
				var offset:Number = new Date().time - cc.time.getTime()
				cc.age(offset);
				if(offset > 15000){
					chats.shift()
					a--;
				}
			}
		}		
		
		public static var queue:Array = [];
		
		public function drawNpcName(target:BitmapData, x:Number, y:Number):void {
			name.draw(target, x, y);
		}
		
		public function drawNpcChat(target:BitmapData, x:Number, y:Number, drawMicro:Boolean = true):void {
			//active - currently interacting.
			
			if (!drawMicro) {
				for (var a:int = 0; a < chats.length; a++) {
					addToQueue(chats[a], target, x, y);
				}
			} else microchat.draw(target, x+8, y-5)
		}
		
		public function drawChat(target:BitmapData, ox:Number, oy:Number, visible:Boolean, hideUsernames:Boolean, hideBubbles:Boolean, team:int):void{
				if (!hideUsernames && visible) {
					name.draw(target, ox, oy);
				}
				
				teamdot.frame = team - 1;
				if (team > 0) {
					if (visible && !hideUsernames) {
						teamdot.draw(target, ox - name.textfield.textWidth / 2 - 6, oy);
					} else {
						teamdot.draw(target, ox, oy);
					}
				}
				
				if (!hideBubbles) {
					if (visible) {
						for (var a:int = 0; a < chats.length; a++) {
							if (chats[a].text == "") {
								microchat.draw(target, ox+8, oy-5)
							} else {
								addToQueue(chats[a], target, ox, oy);
							}
						}
					} else if (chats.length > 0) {
						microchat.draw(target, ox+8, oy-5)
					}
				}
		}
		
		private function addToQueue(c:ChatBubble,target:BitmapData,  ox:Number, oy:Number):void {
			queue.push({t:c.time.getTime(), m:function():void {
				c.draw(target, ox, oy);
			}});
		}
		
		public function clearChats():void {
			chats.splice(0, chats.length);
		}
		
		public static function drawAll():void{
			queue.sortOn(["t"], Array.NUMERIC )
			while(queue.length){
				var cc:Object = queue.shift()
				cc.m()
			}
		}
	}
}