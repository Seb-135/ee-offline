package animations
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.filters.BitmapFilterQuality;
	import flash.filters.GlowFilter;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	import items.ItemAuraShape;
	import items.ItemManager;
	
	import ui.ingame.DeathStar;

	public class AnimationManager
	{
		[Embed(source="/../media/death.png")] protected static var deathBM:Class;
		private static var death:BitmapData = new deathBM().bitmapData;
		
		public static var favorite:BitmapData;
		public static var animFavorite:BitmapData;
		
		public static var like:BitmapData;
		public static var animLike:BitmapData;
		
		public static var animGoldMemberAura:BitmapData;
		public static var animProtection:BitmapData;

//		public static var animDeath:BitmapData;
		public static var animDeaths:Vector.<BitmapData> = new Vector.<BitmapData>();
		public static var stars_yellow:Vector.<BitmapData> = new Vector.<BitmapData>();
		
		
		public static var particleEffects:Array =[];
		
		public static function init():void
		{
			favorite = new BitmapData(40,40,true,0x0);
			favorite.copyPixels(ItemManager.sprFavoriteStar.bmd,new Rectangle(0,0,15,15),new Point(12,12));
			favorite.applyFilter(favorite,favorite.rect,new Point(0,0),new GlowFilter(0xFFF2D6,.5,12,12,1,BitmapFilterQuality.LOW));
			animFavorite = createScaledAnimation(favorite,5);
			
			like = new BitmapData(40,40,true,0x0);
			like.copyPixels(ItemManager.sprLikeHeart.bmd, new Rectangle(0,0,15,15),new Point(12,12));
			like.applyFilter(like,like.rect,new Point(0,0),new GlowFilter(0xFFF2D6,.5,12,12,1,BitmapFilterQuality.LOW));
			animLike = createScaledAnimation(like,5);
			
			for (var i:int=0;i<ItemManager.allParticles.width/5;i++){
				particleEffects[i] = new BitmapData(5,5,true,0x0);
				particleEffects[i].copyPixels(ItemManager.allParticles,new Rectangle(5*i,0,5,5),new Point(0,0));
			}
			

			for (var i3:int = 1; i3 < 4; i3++) 
			{
				var star_bmd:BitmapData  = new BitmapData(5,5,true,0x0);
				star_bmd.copyPixels(ItemManager.allParticles,new Rectangle(5*i3,0,5,5),new Point(0,0));
				stars_yellow.push(star_bmd);
			}
			
			
			// DEATH
			for (var i2:int = 0; i2 < 20; i2++) 
			{
				animDeaths.push(createDeathAnim());
			}
		}
		
		public static function createScaledAnimation(bmd:BitmapData, frames:int, from:Number=1, to:Number=0):BitmapData
		{
			var anim:BitmapData = new BitmapData(bmd.width*frames,bmd.height,true,0x0);
			for(var i:int=0; i<frames; i++){
				var m:Matrix = new Matrix();
//				var progress:Number = (frames-i)/frames;
				var progress:Number = i/frames;
				var scale:Number = from+(progress*(to-from));
				var offset:Number = (bmd.width-scale*bmd.width)/2;
				m.scale(scale,scale);
				m.translate(bmd.width*i+offset,offset);
				anim.draw(bmd,m,null,null,null,true);
			}
			return anim;			
		}

		public static function createRotationAnimation(bmd:BitmapData, frames:int, rotation:int):BitmapData
		{
			var anim:BitmapData = new BitmapData(bmd.width * frames, bmd.height, true, 0x0);
			for (var i:int = 0; i < frames; i++) {
				var m:Matrix = new Matrix();
				var rot:Number = (rotation/(frames-1))*i;
				m.translate(-bmd.width / 2, -bmd.height / 2);
				m.rotate(rot*Math.PI/180);
				m.translate(bmd.width / 2, bmd.height / 2);
				m.translate(bmd.width * i, 0);
				anim.draw(bmd,m);
			}
			return anim;			
		}
		
		public static function duplicateFrame(bmd:BitmapData, frames:int):BitmapData
		{
			var anim:BitmapData = new BitmapData(bmd.width*frames,bmd.height,true,0x0);
			for(var i:int=0; i<frames; i++){
				anim.copyPixels(bmd,bmd.rect,new Point(i*bmd.width,0));
			}
			return anim;
		}
		
		public static function addToEnd(a:BitmapData,b:BitmapData):BitmapData
		{
			var bmd:BitmapData = new BitmapData(a.width+b.width,a.height,true,0x0);
			bmd.copyPixels(a,a.rect,new Point());
			bmd.copyPixels(b,b.rect,new Point(a.width,0));
			return bmd;
		}
		
		public static function combine(a:BitmapData, b:BitmapData, drawOffset:Point = null):BitmapData 
		{
			var bmd:BitmapData = new BitmapData(Math.max(a.width, b.width), Math.max(a.height, b.height), true, 0x0);
			bmd.copyPixels(a, a.rect, new Point(), null, null, true);
			bmd.copyPixels(b, b.rect, drawOffset?drawOffset:new Point(), null, null, true);
			return bmd;
		}
		
		public static function colorize(bmdata:BitmapData, color:uint):BitmapData
		{
			var bmd:BitmapData = bmdata.clone();
			var filter:ColorTransform = new ColorTransform();
			filter.color = color;			
			bmd.colorTransform(bmd.rect, filter);
			return bmd;	
		}		
		
		public static function animRandomDeath():BitmapData
		{
			var ran:int = animDeaths.length*Math.random();
			return animDeaths[ran];
		}
		
		public static function randomDeathStar():BitmapData
		{
			var ran:int = stars_yellow.length*Math.random();
			return stars_yellow[ran];
		}
		
		private static function createDeathAnim():BitmapData
		{
			var frames:int = 16;
			var num:int = 6;
			var bmd:BitmapData = new BitmapData(frames*128,128,true,0x0);
			bmd.copyPixels(death,death.rect,new Point(0,0));
			var starholder:Sprite = new Sprite();
			
			
			
			for (var k:int = 2; k < 4; k++) 
			{
				var rot_offset:Number = (k/2);
				for (var i:int = 0; i < num; i++) 
				{
					var star:DeathStar = new DeathStar(randomDeathStar());
					var angle : Number = ( (i+rot_offset)/num) * Math.PI * 2;
					star.speed = 5+(Math.random()*2);
					star.speed_x = Math.cos( angle );
					star.speed_y = Math.sin( angle );
					star.max_dist = 32;
					
					starholder.addChild(star);					
					star.tick(k);	
				}
				
			}
			num = 8;
			for (var ii:int = 0; ii < num; ii++) 
			{
				var randomstar:DeathStar = new DeathStar(randomDeathStar());
				var angleii : Number = (ii/num) * Math.PI * 2;
				randomstar.speed = 1+(Math.random()*8);
				randomstar.speed_x = Math.cos( angleii );
				randomstar.speed_y = Math.sin( angleii );
				randomstar.max_dist = 32;
				starholder.addChild(randomstar);					
				randomstar.tick();
			}
			var m:Matrix = new Matrix();
			for (var j:int = 0; j < frames; j++) 
			{
				m.tx = j*64+32;
				m.ty = 32;
				bmd.draw(starholder,m);
				if(j<1)continue;
				for (var c:int = 0; c < starholder.numChildren; c++) 
				{
					if(j>frames-7){
						starholder.getChildAt(c).alpha = ((frames-j)/6);
					}
					starholder.getChildAt(c)["tick"]();	
				}
				
			}
			
			return bmd;
		}
	}
}