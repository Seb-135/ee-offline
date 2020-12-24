package ui.brickoverlays
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.filters.DropShadowFilter;
	
	import items.ItemManager;
	
	import sounds.SoundManager;

	public class PianoProperties extends PropertiesBackground
	{
		[Embed(source="/../media/piano.png") ] protected static var pianoBM:Class;
		private static var piano:Bitmap = new pianoBM;
		private static var mark:Sprite = new Sprite();
		
		public function PianoProperties(){
			
			addChild(piano);
			piano.x = -(piano.width/2)-1;
			piano.y = -70
				
				
			mark.graphics.clear();
			mark.graphics.beginFill(0xff0000,0.5);
			mark.graphics.drawCircle(0,0,4);
			mark.graphics.endFill();
			mark.mouseEnabled = false;
			
				
			var xx:int = -(piano.width/2)-(13)
			addChild(createWhiteKey(-27,xx+=12)); // 0
			addChild(createWhiteKey(-25,xx+=12));
			
			addChild(createWhiteKey(-24,xx+=12)); // 1	
			addChild(createWhiteKey(-22,xx+=12));
			addChild(createWhiteKey(-20,xx+=12));
			addChild(createWhiteKey(-19,xx+=12));
			addChild(createWhiteKey(-17,xx+=12));
			addChild(createWhiteKey(-15,xx+=12));
			addChild(createWhiteKey(-13,xx+=12));
			
			addChild(createWhiteKey(-12,xx+=12)); // 2
			addChild(createWhiteKey(-10,xx+=12));
			addChild(createWhiteKey(-8,xx+=12));
			addChild(createWhiteKey(-7,xx+=12));
			addChild(createWhiteKey(-5,xx+=12));			
			addChild(createWhiteKey(-3,xx+=12));
			addChild(createWhiteKey(-1,xx+=12));
			
			// 3
			addChild(createWhiteKey(0,xx+=12)); // C3
			addChild(createWhiteKey(2,xx+=12)); // D3
			addChild(createWhiteKey(4,xx+=12)); // E3
			addChild(createWhiteKey(5,xx+=12)); // F3
			addChild(createWhiteKey(7,xx+=12)); // G3
			addChild(createWhiteKey(9,xx+=12)); // A3
			addChild(createWhiteKey(11,xx+=12)); // B3
			
			// 4
			addChild(createWhiteKey(12,xx+=12));
			addChild(createWhiteKey(14,xx+=12));
			addChild(createWhiteKey(16,xx+=12));
			addChild(createWhiteKey(17,xx+=12));
			addChild(createWhiteKey(19,xx+=12));
			addChild(createWhiteKey(21,xx+=12));
			addChild(createWhiteKey(23,xx+=12));
			
			// 5
			addChild(createWhiteKey(24,xx+=12));
			addChild(createWhiteKey(26,xx+=12));
			addChild(createWhiteKey(28,xx+=12));
			addChild(createWhiteKey(29,xx+=12));
			addChild(createWhiteKey(31,xx+=12));
			addChild(createWhiteKey(33,xx+=12));
			addChild(createWhiteKey(35,xx+=12));
			
			// 6
			addChild(createWhiteKey(36,xx+=12));
			addChild(createWhiteKey(38,xx+=12));
			addChild(createWhiteKey(40,xx+=12));
			addChild(createWhiteKey(41,xx+=12));
			addChild(createWhiteKey(43,xx+=12));
			addChild(createWhiteKey(45,xx+=12));
			addChild(createWhiteKey(47,xx+=12));
			
			// 7
			addChild(createWhiteKey(48,xx+=12));
			addChild(createWhiteKey(50,xx+=12));
			addChild(createWhiteKey(52,xx+=12));
			addChild(createWhiteKey(53,xx+=12));
			addChild(createWhiteKey(55,xx+=12));
			addChild(createWhiteKey(57,xx+=12));
			addChild(createWhiteKey(59,xx+=12));
			
			// 8
			addChild(createWhiteKey(60,xx+=12));
				
			xx = -(piano.width/2)-6
			addChild(createBlackKey(-26,xx+=12)) // 0
			xx+=12;
			addChild(createBlackKey(-23,xx+=12)) // 1
			addChild(createBlackKey(-21,xx+=12))
			xx+=12;
			addChild(createBlackKey(-18,xx+=12))
			addChild(createBlackKey(-16,xx+=12))
			addChild(createBlackKey(-14,xx+=12))
			xx+=12;
			addChild(createBlackKey(-11,xx+=12)) // 2
			addChild(createBlackKey(-9,xx+=12))
			xx+=12;
			addChild(createBlackKey(-6,xx+=12))
			addChild(createBlackKey(-4,xx+=12))
			addChild(createBlackKey(-2,xx+=12))
			xx+=12;
			addChild(createBlackKey(1,xx+=12)) // 3C#
			addChild(createBlackKey(3,xx+=12))
			xx+=12;
			addChild(createBlackKey(6,xx+=12))
			addChild(createBlackKey(8,xx+=12))
			addChild(createBlackKey(10,xx+=12))
			xx+=12;
			addChild(createBlackKey(13,xx+=12)) // 4
			addChild(createBlackKey(15,xx+=12))
			xx+=12;
			addChild(createBlackKey(18,xx+=12))
			addChild(createBlackKey(20,xx+=12))
			addChild(createBlackKey(22,xx+=12))
			xx+=12;
			addChild(createBlackKey(25,xx+=12)) // 5
			addChild(createBlackKey(27,xx+=12))
			xx+=12;
			addChild(createBlackKey(30,xx+=12))
			addChild(createBlackKey(32,xx+=12))
			addChild(createBlackKey(34,xx+=12))
			xx+=12;
			addChild(createBlackKey(37,xx+=12)) // 6
			addChild(createBlackKey(39,xx+=12))
			xx+=12;
			addChild(createBlackKey(42,xx+=12))
			addChild(createBlackKey(44,xx+=12))
			addChild(createBlackKey(46,xx+=12))
			xx+=12;
			addChild(createBlackKey(49,xx+=12)) // 7
			addChild(createBlackKey(51,xx+=12))
			xx+=12;
			addChild(createBlackKey(54,xx+=12))
			addChild(createBlackKey(56,xx+=12))
			addChild(createBlackKey(58,xx+=12))
			
			
		
//			this.bg.width = 256;
//			this.bg.height = 60-2;
//			this.bg.visible = false
			setSize(piano.width+4,72);
			
			this.filters = [new DropShadowFilter(0,0,0,1,6,6,2)]
			addChild(mark);
			
		}
		
		private function createWhiteKey(id:int,xx:int):Sprite{
			var s:Sprite = new Sprite();
			s.x = xx;
			s.y = -61;
			
			if((Global.pianoOffset) == id){
				mark.x = s.x + 17/2 - 2;
				mark.y = s.y + 30;
			}
			
			
			s.graphics.beginFill(0xff0000,0)
			s.graphics.drawRect(0,0,12,39);
			s.graphics.endFill()
			
			s.addEventListener(MouseEvent.MOUSE_DOWN, function():void{
				Global.pianoOffset = id;
				SoundManager.playPianoSound(id);
				mark.x = s.x + 17/2 - 2;
				mark.y = s.y + 30;
			})
			
			return s;
		}
		
		private function createBlackKey(id:int,xx:int):Sprite{
			var s:Sprite = new Sprite();
			
			s.x = xx;
			s.y = -61;
			s.graphics.beginFill(0x0000ff,0)
			s.graphics.drawRect(0,0,8,25);
			s.graphics.endFill()
			
			s.addEventListener(MouseEvent.MOUSE_DOWN, function():void{
				Global.pianoOffset = id;
				SoundManager.playPianoSound(id);
				mark.x = s.x + 4.4;
				mark.y = s.y + 19;
			})
			
			
			return s;
		}
		
	}
}