package items
{
	import animations.AnimationManager;
	
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	public class ItemAuraShape
	{
		public var id:int
		public var name:String;
		public var payvaultid:String;
		public var bmd:BitmapData;
		public var generated:Boolean;
		
		public var auras:Vector.<ItemAura> = new Vector.<ItemAura>();
		
		public function ItemAuraShape(id:int, name:String, bmd:BitmapData, payvaultid:String, frames:int = 1, speed:Number = 0.2, createRotationAnimation:Boolean = false, generate:Boolean = true)
		{
			this.id = id;
			this.name = name;
			this.bmd = bmd;
			this.payvaultid = payvaultid;
			this.generated = generate;
			
			if (generate) {
				var coloredAuras:Vector.<ItemAura> = applyColors(bmd);
				for (var i:int = 0; i < coloredAuras.length; i++) {
					var aura:ItemAura = coloredAuras[i];
					auras.push(aura);
					
					
					if (frames > 1) {
						var animationBmd:BitmapData = new BitmapData(64 * frames, 64, true, 0x0);
						animationBmd.copyPixels(aura.fullbmd, new Rectangle(0, 0, 64 * frames, 64), new Point(0, 0));
						aura.setFramedAnimation(animationBmd, frames, speed);
					}
					else if (createRotationAnimation) {
						aura.setRotationAnimation(14, 84);
					}
				}
			} else {
				var aura2:ItemAura = new ItemAura(id, 0, bmd);
				if (frames > 1) aura2.setFramedAnimation(bmd, frames, speed);
				auras.push(aura2);
			}
		}
		
		private function applyColors(baseShape:BitmapData):Vector.<ItemAura> {
			var auraColors:Vector.<ItemAura> = new Vector.<ItemAura>();
			auraColors.push(createColoredAura(baseShape, 0, ItemAuraColor.WHITE));
			auraColors.push(createColoredAura(baseShape, 1, ItemAuraColor.RED));
			auraColors.push(createColoredAura(baseShape, 2, ItemAuraColor.BLUE));
			auraColors.push(createColoredAura(baseShape, 3, ItemAuraColor.YELLOW));
			auraColors.push(createColoredAura(baseShape, 4, ItemAuraColor.GREEN));
			auraColors.push(createColoredAura(baseShape, 5, ItemAuraColor.PURPLE));
			auraColors.push(createColoredAura(baseShape, 6, ItemAuraColor.ORANGE));
			auraColors.push(createColoredAura(baseShape, 7, ItemAuraColor.CYAN));
			auraColors.push(createColoredAura(baseShape, 8, ItemAuraColor.GOLD));
			auraColors.push(createColoredAura(baseShape, 9, ItemAuraColor.PINK));
			auraColors.push(createColoredAura(baseShape, 10, ItemAuraColor.INDIGO));
			auraColors.push(createColoredAura(baseShape, 11, ItemAuraColor.LIME));
			auraColors.push(createColoredAura(baseShape, 12, ItemAuraColor.BLACK));
			auraColors.push(createColoredAura(baseShape, 13, ItemAuraColor.TEAL));
			auraColors.push(createColoredAura(baseShape, 14, ItemAuraColor.GREY));
			auraColors.push(createColoredAura(baseShape, 15, ItemAuraColor.AMARANTH));
			return auraColors;
		}
		
		private function createColoredAura(baseShape:BitmapData, colorid:int, color:uint):ItemAura {
			/* note(Gosha): eww, hardcoding stuff.
			 * id 6 - Snowflake - snowflake has a different black color.
			 * id 3 - Ornate (goldmember) - Ornate requires adding golden cross
			 * colorid 8 - gold - gold auras have special gradient, so they are used in a different way.
			*/
			
			if (colorid == 8) {
				var goldbmd:BitmapData = new BitmapData(baseShape.width, 64, true, 0x0);
				goldbmd.copyPixels(baseShape, new Rectangle(0, 64, baseShape.width, 64), new Point());
				return new ItemAura(this.id, colorid, goldbmd);
			}
			
			var bmd:BitmapData = AnimationManager.colorize(baseShape, color);
			
			if (this.id == 3) {
				for (var i:int = 0; i < bmd.width / 64; i++) {
					bmd = AnimationManager.combine(bmd, ItemManager.aurasOrnateBMD, new Point(i*64, 0));
				}
			}
			return new ItemAura(this.id, colorid, bmd);
		}
	}
}