package
{
	import flash.geom.Point;
	import items.ItemNpc;
	
	import ui.brickoverlays.PortalProperties;

	public class Lookup
	{
		private var lookup:Object = {}; //common blocks
		private var placerLookup:Object = {}; //placer info
		private var portalLookup:Object = {};
		private var worldPortalLookup:Object = {};
		private var secretsLookup:Object = {}; //secret blocks
		private var labelLookup:Object = {};
		private var blinkLookup:Object = {}; //invisible arrows, halloween eyes etc
		private var signLookup:Object = {};
		private var npcLookup:Object = {};
		
		public function reset():void
		{
			lookup = {};
			placerLookup = {};
			portalLookup = {};
			worldPortalLookup = {};
			labelLookup = {};
			blinkLookup = {};
			signLookup = {};
			npcLookup = {};
			resetSecrets();
		}
		
		public function resetSecrets():void
		{
			secretsLookup = {};
		}
		
		public function resetSign(x:int, y:int):void
		{
			signLookup[getLookupId(x, y)] = null;
		}
		
		public function deleteLookup(x:int, y:int):void
		{
			var lookupId:String = getLookupId(x, y);
			delete lookup[lookupId];
			delete portalLookup[lookupId];
			delete worldPortalLookup[lookupId];
			delete placerLookup[lookupId];
			delete secretsLookup[lookupId];
			delete blinkLookup[lookupId];
			delete signLookup[lookupId];
		}
		
		public function deleteBlink(x:int, y:int):void
		{
			delete blinkLookup[getLookupId(x, y)];
		}
		
		public function getPlacer(x:int, y:int, layer:int):String
		{
			return placerLookup[getLookupId(x, y) + "x" + layer] || "";
		}
		
		public function setPlacer(x:int, y:int, layer:int, placer:String):void
		{
			placerLookup[getLookupId(x, y) + "x" + layer] = placer;
		}
		
		public function getInt(x:int, y:int):int
		{
			return getLookup(x, y) || 0;
		}
		
		public function getSignType(x:int, y:int):int
		{
			return signLookup[getLookupId(x, y)].type || 0;
		}
		
		public function setInt(x:int, y:int, value:int):void
		{
			setLookup(x, y, value);
		}
		
		public function getNumber(x:int, y:int):Number
		{
			return getLookup(x, y) || 0;
		}
		
		public function setNumber(x:int, y:int, value:Number):void
		{
			setLookup(x, y, value);
		}
		
		public function getBoolean(x:int, y:int):Boolean
		{
			return getLookup(x, y) || false;
		}
		
		public function setBoolean(x:int, y:int, value:Boolean):void
		{
			setLookup(x, y, value);
		}
		
		public function getText(x:int, y:int):String
		{
			return getLookup(x, y) || "";
		}
		
		public function getTextSign(x:int, y:int):TextSign
		{
			return signLookup[getLookupId(x, y)] || new TextSign("Undefined", -1);
		}
		
		public function setText(x:int, y:int, value:String):void
		{
			setLookup(x, y, value);
		}
		
		public function setTextSign(x:int, y:int, value:TextSign):void
		{
			signLookup[getLookupId(x, y)] = value;
		}
		
		public function setLabel(x:int, y:int, text:String, color:String, wrap:int):void
		{
			labelLookup[getLookupId(x, y)] = new LabelLookup(text, color, wrap);
		}
		
		public function getLabel(x:int, y:int):LabelLookup
		{
			return labelLookup[getLookupId(x, y)] || new LabelLookup(":)", "#FFFFFF", 200);
		}
		
		public function getPortal(x:int, y:int):Portal
		{
			return portalLookup[getLookupId(x, y)] || new Portal(0, 0, 0);
		}
		
		public function setPortal(x:int, y:int, value:Portal):void
		{
			portalLookup[getLookupId(x, y)] = value;
		}
		
		public function getWorldPortal(x:int, y:int):WorldPortal
		{
			return worldPortalLookup[getLookupId(x, y)] || new WorldPortal("", 0);
		}
		
		public function setWorldPortal(x:int, y:int, value:WorldPortal):void
		{
			worldPortalLookup[getLookupId(x, y)] = value;
		}
		
		public function getPortals(portalId:int):Vector.<Point>
		{
			var portals:Vector.<Point> = new Vector.<Point>();
			
			for (var id:String in portalLookup)
			{
				var xys:Array = id.split("x");
				
				if (portalLookup[id].id == portalId)
				{
					portals.push(new Point(
						parseInt(xys[0]) << 4,
						parseInt(xys[1]) << 4));
				}
			}
			return portals;
		}
		
		public function getSecret(x:int, y:int):Boolean
		{
			return secretsLookup[getLookupId(x, y)] || false;
		}
		
		public function setSecret(x:int, y:int, value:Boolean):void
		{
			secretsLookup[getLookupId(x, y)] = value;
		}
		
		public function getBlink(x:int, y:int):Number
		{
			return blinkLookup[getLookupId(x, y)];
		}
		
		public function setBlink(x:int, y:int, value:Number):void
		{
			blinkLookup[getLookupId(x, y)] = value;
		}
		
		public function isBlink(x:int, y:int):Boolean
		{
			return blinkLookup[getLookupId(x, y)] != null;
		}
		
		public function updateBlink(x:int, y:int, add:Number):Number
		{
			var oldValue:Number = getBlink(x, y);
			var newValue:Number = oldValue + add;
			setBlink(x, y, newValue);
			return newValue;
		}
		
		private function getLookup(x:int, y:int):*
		{
			return lookup[getLookupId(x, y)];
		}
		
		private function setLookup(x:int, y:int, value:*):void
		{
			lookup[getLookupId(x, y)] = value;
		}
		
		private function getLookupId(x:int, y:int):String
		{
			return x + "x" + y;
		}
		
		/* NPC */
		public function getNpc(x:int, y:int):Npc {
			return npcLookup[getLookupId(x, y)] || new Npc("&invalid&", ["r","i","p"], new Point(x, y), null);
		}
		public function setNpc(x:int, y:int, name:String, messages:Array, item:ItemNpc):void {
			npcLookup[getLookupId(x, y)] = new Npc(name, messages, new Point(x, y), item);
		}
	}
}