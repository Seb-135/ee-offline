package sounds
{
	import flash.media.Sound;
	import flash.media.SoundTransform;
	import flash.media.SoundMixer;
	
	import items.ItemId;

	public class SoundManager
	{
		// Misc
		[Embed(source="/../media/sounds/coin.mp3")] private static var Coin:Class;
		[Embed(source="/../media/sounds/banned.mp3")] private static var Banned:Class;
		[Embed(source="/../media/sounds/easteregg_1.mp3")] private static var Over9000:Class;
		[Embed(source="/../media/sounds/wootup.mp3")] private static var WootUp:Class;
		[Embed(source="/../media/sounds/like.mp3")] private static var Like:Class;
		[Embed(source="/../media/sounds/unlike.mp3")] private static var Unlike:Class;
		[Embed(source="/../media/sounds/favorite.mp3")] private static var Favorite:Class;
		[Embed(source="/../media/sounds/unfavorite.mp3")] private static var Unfavorite:Class;
		[Embed(source="/../media/sounds/halloween/magic.mp3")] private static var Magic:Class; // keeping halloween magic
		[Embed(source="/../media/sounds/dontpanic.mp3")] private static var DontPanic:Class;
		[Embed(source="/../media/sounds/click.mp3")] private static var Click:Class;
		[Embed(source="/../media/sounds/gong.mp3")] private static var Gong:Class;
		private static var miscSounds:Object = {};
		
		// Piano
		[Embed(source="/../media/sounds/Piano/1.mp3") ] private static var piano1:Class;
		[Embed(source="/../media/sounds/Piano/2.mp3") ] private static var piano2:Class;
		[Embed(source="/../media/sounds/Piano/3.mp3") ] private static var piano3:Class;
		[Embed(source="/../media/sounds/Piano/4.mp3") ] private static var piano4:Class;
		[Embed(source="/../media/sounds/Piano/5.mp3") ] private static var piano5:Class;
		[Embed(source="/../media/sounds/Piano/6.mp3") ] private static var piano6:Class;
		[Embed(source="/../media/sounds/Piano/7.mp3") ] private static var piano7:Class;
		[Embed(source="/../media/sounds/Piano/8.mp3") ] private static var piano8:Class;
		[Embed(source="/../media/sounds/Piano/9.mp3") ] private static var piano9:Class;
		[Embed(source="/../media/sounds/Piano/10.mp3") ] private static var piano10:Class;
		[Embed(source="/../media/sounds/Piano/11.mp3") ] private static var piano11:Class;
		[Embed(source="/../media/sounds/Piano/12.mp3") ] private static var piano12:Class;
		[Embed(source="/../media/sounds/Piano/13.mp3") ] private static var piano13:Class;
		[Embed(source="/../media/sounds/Piano/14.mp3") ] private static var piano14:Class;
		[Embed(source="/../media/sounds/Piano/15.mp3") ] private static var piano15:Class;
		[Embed(source="/../media/sounds/Piano/16.mp3") ] private static var piano16:Class;
		[Embed(source="/../media/sounds/Piano/17.mp3") ] private static var piano17:Class;
		[Embed(source="/../media/sounds/Piano/18.mp3") ] private static var piano18:Class;
		[Embed(source="/../media/sounds/Piano/19.mp3") ] private static var piano19:Class;
		[Embed(source="/../media/sounds/Piano/20.mp3") ] private static var piano20:Class;
		[Embed(source="/../media/sounds/Piano/21.mp3") ] private static var piano21:Class;
		[Embed(source="/../media/sounds/Piano/22.mp3") ] private static var piano22:Class;
		[Embed(source="/../media/sounds/Piano/23.mp3") ] private static var piano23:Class;
		[Embed(source="/../media/sounds/Piano/24.mp3") ] private static var piano24:Class;
		[Embed(source="/../media/sounds/Piano/25.mp3") ] private static var piano25:Class;
		[Embed(source="/../media/sounds/Piano/26.mp3") ] private static var piano26:Class;
		[Embed(source="/../media/sounds/Piano/27.mp3") ] private static var piano27:Class;
		[Embed(source="/../media/sounds/Piano/28.mp3") ] private static var piano28:Class;
		[Embed(source="/../media/sounds/Piano/29.mp3") ] private static var piano29:Class;
		[Embed(source="/../media/sounds/Piano/30.mp3") ] private static var piano30:Class;
		[Embed(source="/../media/sounds/Piano/31.mp3") ] private static var piano31:Class;
		[Embed(source="/../media/sounds/Piano/32.mp3") ] private static var piano32:Class;
		[Embed(source="/../media/sounds/Piano/33.mp3") ] private static var piano33:Class;
		[Embed(source="/../media/sounds/Piano/34.mp3") ] private static var piano34:Class;
		[Embed(source="/../media/sounds/Piano/35.mp3") ] private static var piano35:Class;
		[Embed(source="/../media/sounds/Piano/36.mp3") ] private static var piano36:Class;
		[Embed(source="/../media/sounds/Piano/37.mp3") ] private static var piano37:Class;
		[Embed(source="/../media/sounds/Piano/38.mp3") ] private static var piano38:Class;
		[Embed(source="/../media/sounds/Piano/39.mp3") ] private static var piano39:Class;
		[Embed(source="/../media/sounds/Piano/40.mp3") ] private static var piano40:Class;
		[Embed(source="/../media/sounds/Piano/41.mp3") ] private static var piano41:Class;
		[Embed(source="/../media/sounds/Piano/42.mp3") ] private static var piano42:Class;
		[Embed(source="/../media/sounds/Piano/43.mp3") ] private static var piano43:Class;
		[Embed(source="/../media/sounds/Piano/44.mp3") ] private static var piano44:Class;
		[Embed(source="/../media/sounds/Piano/45.mp3") ] private static var piano45:Class;
		[Embed(source="/../media/sounds/Piano/46.mp3") ] private static var piano46:Class;
		[Embed(source="/../media/sounds/Piano/47.mp3") ] private static var piano47:Class;
		[Embed(source="/../media/sounds/Piano/48.mp3") ] private static var piano48:Class;
		[Embed(source="/../media/sounds/Piano/49.mp3") ] private static var piano49:Class;
		[Embed(source="/../media/sounds/Piano/50.mp3") ] private static var piano50:Class;
		[Embed(source="/../media/sounds/Piano/51.mp3") ] private static var piano51:Class;
		[Embed(source="/../media/sounds/Piano/52.mp3") ] private static var piano52:Class;
		[Embed(source="/../media/sounds/Piano/53.mp3") ] private static var piano53:Class;
		[Embed(source="/../media/sounds/Piano/54.mp3") ] private static var piano54:Class;
		[Embed(source="/../media/sounds/Piano/55.mp3") ] private static var piano55:Class;
		[Embed(source="/../media/sounds/Piano/56.mp3") ] private static var piano56:Class;
		[Embed(source="/../media/sounds/Piano/57.mp3") ] private static var piano57:Class;
		[Embed(source="/../media/sounds/Piano/58.mp3") ] private static var piano58:Class;
		[Embed(source="/../media/sounds/Piano/59.mp3") ] private static var piano59:Class;
		[Embed(source="/../media/sounds/Piano/60.mp3") ] private static var piano60:Class;
		[Embed(source="/../media/sounds/Piano/61.mp3") ] private static var piano61:Class;
		[Embed(source="/../media/sounds/Piano/62.mp3") ] private static var piano62:Class;
		[Embed(source="/../media/sounds/Piano/63.mp3") ] private static var piano63:Class;
		[Embed(source="/../media/sounds/Piano/64.mp3") ] private static var piano64:Class;
		[Embed(source="/../media/sounds/Piano/65.mp3") ] private static var piano65:Class;
		[Embed(source="/../media/sounds/Piano/66.mp3") ] private static var piano66:Class;
		[Embed(source="/../media/sounds/Piano/67.mp3") ] private static var piano67:Class;
		[Embed(source="/../media/sounds/Piano/68.mp3") ] private static var piano68:Class;
		[Embed(source="/../media/sounds/Piano/69.mp3") ] private static var piano69:Class;
		[Embed(source="/../media/sounds/Piano/70.mp3") ] private static var piano70:Class;
		[Embed(source="/../media/sounds/Piano/71.mp3") ] private static var piano71:Class;
		[Embed(source="/../media/sounds/Piano/72.mp3") ] private static var piano72:Class;
		[Embed(source="/../media/sounds/Piano/73.mp3") ] private static var piano73:Class;
		[Embed(source="/../media/sounds/Piano/74.mp3") ] private static var piano74:Class;
		[Embed(source="/../media/sounds/Piano/75.mp3") ] private static var piano75:Class;
		[Embed(source="/../media/sounds/Piano/76.mp3") ] private static var piano76:Class;
		[Embed(source="/../media/sounds/Piano/77.mp3") ] private static var piano77:Class;
		[Embed(source="/../media/sounds/Piano/78.mp3") ] private static var piano78:Class;
		[Embed(source="/../media/sounds/Piano/79.mp3") ] private static var piano79:Class;
		[Embed(source="/../media/sounds/Piano/80.mp3") ] private static var piano80:Class;
		[Embed(source="/../media/sounds/Piano/81.mp3") ] private static var piano81:Class;
		[Embed(source="/../media/sounds/Piano/82.mp3") ] private static var piano82:Class;
		[Embed(source="/../media/sounds/Piano/83.mp3") ] private static var piano83:Class;
		[Embed(source="/../media/sounds/Piano/84.mp3") ] private static var piano84:Class;
		[Embed(source="/../media/sounds/Piano/85.mp3") ] private static var piano85:Class;
		
		[Embed(source="/../media/sounds/Piano/86.mp3") ] private static var piano86:Class;
		[Embed(source="/../media/sounds/Piano/87.mp3") ] private static var piano87:Class;
		[Embed(source="/../media/sounds/Piano/88.mp3") ] private static var piano88:Class;
		public static var pianoSounds:Vector.<Sound> = new Vector.<Sound>();
		
		// Drums
		[Embed(source="/../media/sounds/Drums/kick.mp3") ] private static var drums01:Class;
		[Embed(source="/../media/sounds/Drums/kick_hihat.mp3") ] private static var drums02:Class;
		[Embed(source="/../media/sounds/Drums/snare.mp3") ] private static var drums03:Class;
		[Embed(source="/../media/sounds/Drums/snare2.mp3") ] private static var drums04:Class;
		[Embed(source="/../media/sounds/Drums/hihat1.mp3") ] private static var drums05:Class;
		[Embed(source="/../media/sounds/Drums/hihat2.mp3") ] private static var drums06:Class;
		[Embed(source="/../media/sounds/Drums/hihat3.mp3") ] private static var drums07:Class;
		[Embed(source="/../media/sounds/Drums/clap.mp3") ] private static var drums08:Class;
		[Embed(source="/../media/sounds/Drums/crash1.mp3") ] private static var drums09:Class;
		[Embed(source="/../media/sounds/Drums/shacker.mp3") ] private static var drums10:Class;
		[Embed(source="/../media/sounds/Drums/tom1.mp3") ] private static var drums11:Class;
		[Embed(source="/../media/sounds/Drums/tom2.mp3") ] private static var drums12:Class;
		[Embed(source="/../media/sounds/Drums/tom3.mp3") ] private static var drums13:Class;
		[Embed(source="/../media/sounds/Drums/tom4.mp3") ] private static var drums14:Class;
		[Embed(source="/../media/sounds/Drums/hihat4.mp3") ] private static var drums15:Class;
		[Embed(source="/../media/sounds/Drums/hihatopenclose.mp3") ] private static var drums16:Class;
		[Embed(source="/../media/sounds/Drums/crash2.mp3") ] private static var drums17:Class;
		[Embed(source="/../media/sounds/Drums/ride.mp3") ] private static var drums18:Class;
		[Embed(source="/../media/sounds/Drums/ridebell.mp3") ] private static var drums19:Class;
		[Embed(source="/../media/sounds/Drums/cowbell.mp3") ] private static var drums20:Class;
		public static var drumSounds:Vector.<Sound> = new Vector.<Sound>();
		
		// Guitar
		[Embed(source="/../media/sounds/Guitar/1.mp3") ] private static var guitar1:Class;
		[Embed(source="/../media/sounds/Guitar/2.mp3") ] private static var guitar2:Class;
		[Embed(source="/../media/sounds/Guitar/3.mp3") ] private static var guitar3:Class;
		[Embed(source="/../media/sounds/Guitar/4.mp3") ] private static var guitar4:Class;
		[Embed(source="/../media/sounds/Guitar/5.mp3") ] private static var guitar5:Class;
		[Embed(source="/../media/sounds/Guitar/6.mp3") ] private static var guitar6:Class;
		[Embed(source="/../media/sounds/Guitar/7.mp3") ] private static var guitar7:Class;
		[Embed(source="/../media/sounds/Guitar/8.mp3") ] private static var guitar8:Class;
		[Embed(source="/../media/sounds/Guitar/9.mp3") ] private static var guitar9:Class;
		[Embed(source="/../media/sounds/Guitar/10.mp3") ] private static var guitar10:Class;
		[Embed(source="/../media/sounds/Guitar/11.mp3") ] private static var guitar11:Class;
		[Embed(source="/../media/sounds/Guitar/12.mp3") ] private static var guitar12:Class;
		[Embed(source="/../media/sounds/Guitar/13.mp3") ] private static var guitar13:Class;
		[Embed(source="/../media/sounds/Guitar/14.mp3") ] private static var guitar14:Class;
		[Embed(source="/../media/sounds/Guitar/15.mp3") ] private static var guitar15:Class;
		[Embed(source="/../media/sounds/Guitar/16.mp3") ] private static var guitar16:Class;
		[Embed(source="/../media/sounds/Guitar/17.mp3") ] private static var guitar17:Class;
		[Embed(source="/../media/sounds/Guitar/18.mp3") ] private static var guitar18:Class;
		[Embed(source="/../media/sounds/Guitar/19.mp3") ] private static var guitar19:Class;
		[Embed(source="/../media/sounds/Guitar/20.mp3") ] private static var guitar20:Class;
		[Embed(source="/../media/sounds/Guitar/21.mp3") ] private static var guitar21:Class;
		[Embed(source="/../media/sounds/Guitar/22.mp3") ] private static var guitar22:Class;
		[Embed(source="/../media/sounds/Guitar/23.mp3") ] private static var guitar23:Class;
		[Embed(source="/../media/sounds/Guitar/24.mp3") ] private static var guitar24:Class;
		[Embed(source="/../media/sounds/Guitar/25.mp3") ] private static var guitar25:Class;
		[Embed(source="/../media/sounds/Guitar/26.mp3") ] private static var guitar26:Class;
		[Embed(source="/../media/sounds/Guitar/27.mp3") ] private static var guitar27:Class;
		[Embed(source="/../media/sounds/Guitar/28.mp3") ] private static var guitar28:Class;
		[Embed(source="/../media/sounds/Guitar/29.mp3") ] private static var guitar29:Class;
		[Embed(source="/../media/sounds/Guitar/30.mp3") ] private static var guitar30:Class;
		[Embed(source="/../media/sounds/Guitar/31.mp3") ] private static var guitar31:Class;
		[Embed(source="/../media/sounds/Guitar/32.mp3") ] private static var guitar32:Class;
		[Embed(source="/../media/sounds/Guitar/33.mp3") ] private static var guitar33:Class;
		[Embed(source="/../media/sounds/Guitar/34.mp3") ] private static var guitar34:Class;
		[Embed(source="/../media/sounds/Guitar/35.mp3") ] private static var guitar35:Class;
		[Embed(source="/../media/sounds/Guitar/36.mp3") ] private static var guitar36:Class;
		[Embed(source="/../media/sounds/Guitar/37.mp3") ] private static var guitar37:Class;
		[Embed(source="/../media/sounds/Guitar/38.mp3") ] private static var guitar38:Class;
		[Embed(source="/../media/sounds/Guitar/39.mp3") ] private static var guitar39:Class;
		[Embed(source="/../media/sounds/Guitar/40.mp3") ] private static var guitar40:Class;
		[Embed(source="/../media/sounds/Guitar/41.mp3") ] private static var guitar41:Class;
		[Embed(source="/../media/sounds/Guitar/42.mp3") ] private static var guitar42:Class;
		[Embed(source="/../media/sounds/Guitar/43.mp3") ] private static var guitar43:Class;
		[Embed(source="/../media/sounds/Guitar/44.mp3") ] private static var guitar44:Class;
		[Embed(source="/../media/sounds/Guitar/45.mp3") ] private static var guitar45:Class;
		[Embed(source="/../media/sounds/Guitar/46.mp3") ] private static var guitar46:Class;
		[Embed(source="/../media/sounds/Guitar/47.mp3") ] private static var guitar47:Class;
		[Embed(source="/../media/sounds/Guitar/48.mp3") ] private static var guitar48:Class;
		[Embed(source="/../media/sounds/Guitar/49.mp3") ] private static var guitar49:Class;
		public static var guitarSounds:Vector.<Sound> = new Vector.<Sound>();
		
		public static var guitarMap:Array = [00, 01, 02, 03, 04, 05, 06, 07, 08, 09, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19,
20, 21, 22, 23, 24, 25, 01, 02, 03, 04, 05, 06, 07, 08, 09, 10, 11, 12, 13, 14,
26, 27, 28, 29, 30, 21, 22, 23, 24, 25, 01, 02, 03, 04, 05, 06, 07, 08, 09, 10,
31, 32, 33, 34, 35, 36, 27, 28, 29, 30, 21, 22, 23, 24, 25, 01, 02, 03, 04, 05,
37, 38, 39, 40, 41, 42, 32, 33, 34, 35, 36, 27, 28, 29, 30, 21, 22, 23, 24, 25,
43, 44, 45, 46, 47, 48, 38, 39, 40, 41, 42, 32, 33, 34, 35, 36, 27, 28, 29, 30];
		
		public static function init():void
		{
			miscSounds[SoundId.COIN] = new Coin();
			miscSounds[SoundId.BANNED] = new Banned();
			miscSounds[SoundId.OVER9000] = new Over9000();
			miscSounds[SoundId.WOOT_UP] = new WootUp();
			miscSounds[SoundId.LIKE] = new Like();
			miscSounds[SoundId.UNLIKE] = new Unlike();
			miscSounds[SoundId.FAVORITE] = new Favorite();
			miscSounds[SoundId.UNFAVORITE] = new Unfavorite();
			miscSounds[SoundId.MAGIC] = new Magic();
			miscSounds[SoundId.DONTPANIC] = new DontPanic();
			miscSounds[SoundId.CLICK] = new Click();
			miscSounds[SoundId.GONG] = new Gong();
			
			pianoSounds.push(
				/*new piano000 as Sound, // TODO A
				new piano00 as Sound, // TODO A#
				new piano0 as Sound, // TODO B*/
				new piano1 as Sound,
				new piano2 as Sound,
				new piano3 as Sound,
				new piano4 as Sound,
				new piano5 as Sound,
				new piano6 as Sound,
				new piano7 as Sound,
				new piano8 as Sound,
				new piano9 as Sound,
				new piano10 as Sound,
				new piano11 as Sound,
				new piano12 as Sound,
				new piano13 as Sound,
				new piano14 as Sound,
				new piano15 as Sound,
				new piano16 as Sound,
				new piano17 as Sound,
				new piano18 as Sound,
				new piano19 as Sound,
				new piano20 as Sound,
				new piano21 as Sound,
				new piano22 as Sound,
				new piano23 as Sound,
				new piano24 as Sound,				
				new piano25 as Sound,
				new piano26 as Sound,
				new piano27 as Sound,
				new piano28 as Sound,
				new piano29 as Sound,
				new piano30 as Sound,
				new piano31 as Sound,
				new piano32 as Sound,
				new piano33 as Sound,
				new piano34 as Sound,
				new piano35 as Sound,
				new piano36 as Sound,
				new piano37 as Sound,
				new piano38 as Sound,
				new piano39 as Sound,
				new piano40 as Sound,
				new piano41 as Sound,
				new piano42 as Sound,
				new piano43 as Sound,
				new piano44 as Sound,
				new piano45 as Sound,
				new piano46 as Sound,
				new piano47 as Sound,
				new piano48 as Sound,
				new piano49 as Sound,
				new piano50 as Sound,
				new piano51 as Sound,
				new piano52 as Sound,
				new piano53 as Sound,
				new piano54 as Sound,
				new piano55 as Sound,
				new piano56 as Sound,
				new piano57 as Sound,
				new piano58 as Sound,
				new piano59 as Sound,
				new piano60 as Sound,
				new piano61 as Sound,
				new piano62 as Sound,
				new piano63 as Sound,
				new piano64 as Sound,
				new piano65 as Sound,
				new piano66 as Sound,
				new piano67 as Sound,
				new piano68 as Sound,
				new piano69 as Sound,
				new piano70 as Sound,
				new piano71 as Sound,
				new piano72 as Sound,
				new piano73 as Sound,
				new piano74 as Sound,
				new piano75 as Sound,
				new piano76 as Sound,
				new piano77 as Sound,
				new piano78 as Sound,
				new piano79 as Sound,
				new piano80 as Sound,
				new piano81 as Sound,
				new piano82 as Sound,
				new piano83 as Sound,
				new piano84 as Sound,
				new piano85 as Sound,
				new piano86 as Sound,
				new piano87 as Sound,
				new piano88 as Sound
			)
				
			drumSounds.push(
				new drums01 as Sound,
				new drums02 as Sound,
				new drums03 as Sound,
				new drums04 as Sound,
				new drums05 as Sound,
				new drums06 as Sound,
				new drums07 as Sound,
				new drums08 as Sound,
				new drums09 as Sound,
				new drums10 as Sound,
				new drums11 as Sound,
				new drums12 as Sound,
				new drums13 as Sound,
				new drums14 as Sound,
				new drums15 as Sound,
				new drums16 as Sound,
				new drums17 as Sound,
				new drums18 as Sound,
				new drums19 as Sound,
				new drums20 as Sound
			);
			
			guitarSounds.push(
				new guitar1 as Sound,
				new guitar2 as Sound,
				new guitar3 as Sound,
				new guitar4 as Sound,
				new guitar5 as Sound,
				new guitar6 as Sound,
				new guitar7 as Sound,
				new guitar8 as Sound,
				new guitar9 as Sound,
				new guitar10 as Sound,
				new guitar11 as Sound,
				new guitar12 as Sound,
				new guitar13 as Sound,
				new guitar14 as Sound,
				new guitar15 as Sound,
				new guitar16 as Sound,
				new guitar17 as Sound,
				new guitar18 as Sound,
				new guitar19 as Sound,
				new guitar20 as Sound,
				new guitar21 as Sound,
				new guitar22 as Sound,
				new guitar23 as Sound,
				new guitar24 as Sound,
				new guitar25 as Sound,
				new guitar26 as Sound,
				new guitar27 as Sound,
				new guitar28 as Sound,
				new guitar29 as Sound,
				new guitar30 as Sound,
				new guitar31 as Sound,
				new guitar32 as Sound,
				new guitar33 as Sound,
				new guitar34 as Sound,
				new guitar35 as Sound,
				new guitar36 as Sound,
				new guitar37 as Sound,
				new guitar38 as Sound,
				new guitar39 as Sound,
				new guitar40 as Sound,
				new guitar41 as Sound,
				new guitar42 as Sound,
				new guitar43 as Sound,
				new guitar44 as Sound,
				new guitar45 as Sound,
				new guitar46 as Sound,
				new guitar47 as Sound,
				new guitar48 as Sound,
				new guitar49 as Sound
			);
		}
		
		public static function playAnySound(id:String):Boolean {
			try {
				if (id.indexOf('piano') == 0) return playPianoSound(int(id.substr(5)));
				if (id.indexOf('drum') == 0) return playDrumSound(int(id.substr(4)));
				if (id.indexOf('guitar') == 0) return playGuitarSound(int(id.substr(6)));
				return playMiscSound(id);
			} catch (e:Error) {
				trace("Error playing sound:", e);
			}
			return false;
		}
		
		public static function playMiscSound(id:String):Boolean
		{
			return playSound(miscSounds[id]);
		}
		
		public static function playPianoSound(pianoId:int):Boolean
		{
			return playSound(pianoSounds[pianoId + 27]);
		}
		
		public static function playDrumSound(drumId:int):Boolean
		{
			return playSound(drumSounds[drumId]);
		}
		
		public static function playGuitarSound(guitarId:int):Boolean
		{
			return playSound(guitarSounds[guitarId]);
		}
		
		public static function playSound(sound:Sound):Boolean
		{
			if (Global.base.settings.volume <= 0) return false;
			SoundMixer.soundTransform = new SoundTransform(Global.base.settings.volume / 100);
			
			sound.play();
			return true;
		}
	}
}