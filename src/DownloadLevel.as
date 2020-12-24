package
{
	import com.nochump.util.zip.ZipEntry;
	import com.nochump.util.zip.ZipOutput;
	import flash.events.MouseEvent;
	import flash.net.FileFilter;
	import flash.net.FileReference;
	import flash.utils.ByteArray;
	import flash.events.Event;
	
	import items.ItemId;
	
	//import states.PlayState;
	
	public class DownloadLevel
	{
		private static var newData:ByteArray = new ByteArray();
		private static var newPos:int = 0;
		private static var downloaded:Boolean;
		public static function SaveLevel(download:Boolean = true):void {
			downloaded = download;
			var fileReference:FileReference = new FileReference();
			var data:ByteArray = new ByteArray();
			data.writeUTF(Global.worldInfo.owner.toLowerCase() == "player" ? Global.cookie.data.username : Global.worldInfo.owner);   // Owner
			data.writeUTF(Global.currentLevelname);                     // World Name
			data.writeInt(Global.playState.getWidth());                 // Width
			data.writeInt(Global.playState.getHeight());                // Height
			data.writeFloat(Global.playState.gravityMultiplier);        // Gravity
			data.writeUnsignedInt(Global.currentBgColor);               // Background
			data.writeUTF(Global.ui2.description);                      // Description
			data.writeBoolean(Global.worldInfo.campaign);               // Campaign
			data.writeUTF(/*Global.worldInfo.crewId*/ "");              // Crew ID
			data.writeUTF(/*Global.worldInfo.crewName*/ "");            // Crew Name
			data.writeInt(/*Global.worldInfo.crewStatus*/ 0);           // Crew Status
			data.writeBoolean(Global.ui2.minimapEnabled);               // Minimap
			data.writeUTF(/*Global.worldInfo.ownerId*/ "made offline"); // Owner ID
			newPos = data.position;

			var blocks:Object = {};
			for (var z:int = 0; z < 2; z++ ) {
				for (var y:int = 0; y < Global.playState.getHeight(); y++ ) {
					for (var x:int = 0; x < Global.playState.getWidth(); x++ ) {
						var bId:int = Global.playState.world.getTile(z, x, y);
						var rot:int;
						var tar:int;
						if (bId === 0) continue;
						
						if (bId == ItemId.COLLECTEDCOIN) {
							bId = ItemId.COIN;
						} else if (bId == ItemId.COLLECTEDBLUECOIN) {
							bId = ItemId.BLUECOIN;
						}
						
						if (ItemId.isBlockRotateable(bId) || ItemId.isNonRotatableHalfBlock(bId) || ItemId.isBlockNumbered(bId)
						|| bId === ItemId.GUITAR || bId === ItemId.DRUMS || bId === ItemId.PIANO
						|| bId === ItemId.SPIKE || bId == ItemId.SPIKE_SILVER || bId == ItemId.SPIKE_BLACK
						|| bId == ItemId.SPIKE_RED || bId == ItemId.SPIKE_GOLD || bId == ItemId.SPIKE_GREEN || bId == ItemId.SPIKE_BLUE) {
							rot = Global.playState.world.lookup.getInt(x, y);
							if (blocks[bId + "᎙0᎙" + rot] == undefined) {
								blocks[bId + "᎙0᎙" + rot] = {Xs: [x], Ys: [y]};
							} else {
								blocks[bId + "᎙0᎙" + rot].Xs.push(x);
								blocks[bId + "᎙0᎙" + rot].Ys.push(y);
							}
						} else if (bId === ItemId.PORTAL || bId === ItemId.PORTAL_INVISIBLE) {
							rot = Global.playState.world.lookup.getPortal(x, y).rotation;
							var id:int = Global.playState.world.lookup.getPortal(x, y).id;
							tar = Global.playState.world.lookup.getPortal(x, y).target;
							if (blocks[bId + "᎙0᎙" + rot + "᎙" + id + "᎙" + tar] == undefined) {
								blocks[bId + "᎙0᎙" + rot + "᎙" + id + "᎙" + tar] = {Xs: [x], Ys: [y]};
							} else {
								blocks[bId + "᎙0᎙" + rot + "᎙" + id + "᎙" + tar].Xs.push(x);
								blocks[bId + "᎙0᎙" + rot + "᎙" + id + "᎙" + tar].Ys.push(y);
							}
						} else if (bId === ItemId.TEXT_SIGN) {
							var sign_text:String = Global.playState.world.lookup.getTextSign(x, y).text;
							var sign_type:int = Global.playState.world.lookup.getTextSign(x, y).type;
							if (blocks[bId + "᎙0᎙" + sign_text + "᎙" + sign_type] == undefined) {
								blocks[bId + "᎙0᎙" + sign_text + "᎙" + sign_type] = {Xs: [x], Ys: [y]};
							} else {
								blocks[bId + "᎙0᎙" + sign_text + "᎙" + sign_type].Xs.push(x);
								blocks[bId + "᎙0᎙" + sign_text + "᎙" + sign_type].Ys.push(y);
							}
						} else if (bId === ItemId.WORLD_PORTAL) {
							var target_world:String = Global.playState.world.lookup.getWorldPortal(x, y).id;
							tar = Global.playState.world.lookup.getWorldPortal(x, y).target;
							if (blocks[bId + "᎙0᎙" + target_world + "᎙" + tar] == undefined) {
								blocks[bId + "᎙0᎙" + target_world + "᎙" + tar] = {Xs: [x], Ys: [y]};
							} else {
								blocks[bId + "᎙0᎙" + target_world + "᎙" + tar].Xs.push(x);
								blocks[bId + "᎙0᎙" + target_world + "᎙" + tar].Ys.push(y);
							}
						} else if (bId === ItemId.LABEL) {
							var text:String = Global.playState.world.lookup.getLabel(x, y).Text;
							var text_color:String = Global.playState.world.lookup.getLabel(x, y).Color;
							var wrapLength:int = Global.playState.world.lookup.getLabel(x, y).WrapLength;
							if (blocks[bId + "᎙0᎙" + text + "᎙" + text_color + "᎙" + wrapLength] == undefined) {
								blocks[bId + "᎙0᎙" + text + "᎙" + text_color + "᎙" + wrapLength] = {Xs: [x], Ys: [y]};
							} else {
								blocks[bId + "᎙0᎙" + text + "᎙" + text_color + "᎙" + wrapLength].Xs.push(x);
								blocks[bId + "᎙0᎙" + text + "᎙" + text_color + "᎙" + wrapLength].Ys.push(y);
							}
						} else if (ItemId.isNPC(bId)) {
							var name:String = Global.playState.world.lookup.getNpc(x, y).name;
							var message1:String = Global.playState.world.lookup.getNpc(x, y).messages[0];
							var message2:String = Global.playState.world.lookup.getNpc(x, y).messages[1];
							var message3:String = Global.playState.world.lookup.getNpc(x, y).messages[2];
							if (blocks[bId + "᎙0᎙" + name + "᎙" + message1 + "᎙" + message2 + "᎙" + message3] == undefined) {
								blocks[bId + "᎙0᎙" + name + "᎙" + message1 + "᎙" + message2 + "᎙" + message3] = {Xs: [x], Ys: [y]};
							} else {
								blocks[bId + "᎙0᎙" + name + "᎙" + message1 + "᎙" + message2 + "᎙" + message3].Xs.push(x);
								blocks[bId + "᎙0᎙" + name + "᎙" + message1 + "᎙" + message2 + "᎙" + message3].Ys.push(y);
							}
						}
						else {
							if (blocks[bId + "᎙" + z] == undefined) {
								blocks[bId + "᎙" + z] = {Xs: [x], Ys: [y]};
							} else {
								blocks[bId + "᎙" + z].Xs.push(x);
								blocks[bId + "᎙" + z].Ys.push(y);
							}
						}
					}
				}
			}
			
			for (var i:String in blocks) {
				var dataSplit:Array = i.split("᎙");
				var blockId:int = parseInt(dataSplit[0]);
				var layer:int = parseInt(dataSplit[1]);
				var Xs:ByteArray = FromUShortArray(blocks[i].Xs);
				var Ys:ByteArray = FromUShortArray(blocks[i].Ys);
				
				data.writeInt(blockId);
				data.writeInt(layer);
				data.writeUnsignedInt(Xs.length);
				data.writeBytes(Xs);
				data.writeUnsignedInt(Ys.length);
				data.writeBytes(Ys);
				for (var j:int = 2; j < dataSplit.length; j++ ) { 
					if ((blockId === ItemId.TEXT_SIGN && j === 2) || (blockId === ItemId.LABEL && (j === 2 || j === 3)) || (blockId === ItemId.WORLD_PORTAL && j === 2) || (ItemId.isNPC(blockId))) {
						data.writeUTF(dataSplit[j]);
					} else {
						var s:int = parseInt(dataSplit[j]);
						if (dataSplit[j] == s) {
							data.writeInt(s);
						} else {
							data.writeUTF(dataSplit[j]);
						}
					}
				}
			}
			data.deflate();
			newData = data;
			
			Global.worlds[Global.worldIndex] = new ByteArray();
			Global.worlds[Global.worldIndex].writeBytes(data, 0, data.length);
			Global.worldNames[Global.worldIndex] = Global.currentLevelname;
			
			if (download) {
				
				fileReference.addEventListener(Event.COMPLETE, fileSaved);
				
				if (Global.worlds.length > 1) {
					var zip:ZipOutput = new ZipOutput();
					for (var worldIndex:int = 0; worldIndex < Global.worlds.length; worldIndex++) {
						var stringID:String = worldIndex.toString();
						var digits:int = (Global.worlds.length-1).toString().length;
						while (stringID.length < digits) {
							stringID = "0" + stringID;
						}
						
						var world:ZipEntry = new ZipEntry(RemoveCharacters(stringID + " - " + Global.worldNames[worldIndex] + " - " +
						(Global.worldInfo.owner.toLowerCase() == "player" ? Global.cookie.data.username : Global.worldInfo.owner)) + ".eelvl");
						zip.putNextEntry(world);
						zip.write(Global.worlds[worldIndex]);
					}
					zip.finish();
					fileReference.save(zip.byteArray, RemoveCharacters(Global.worldNames[0] + " - " +
					(Global.worldInfo.owner.toLowerCase() == "player" ? Global.cookie.data.username : Global.worldInfo.owner)) + ".eelvls");
				}
				else {
					fileReference.save(data, RemoveCharacters(Global.currentLevelname + " - " +
					(Global.worldInfo.owner.toLowerCase() == "player" ? Global.cookie.data.username : Global.worldInfo.owner)) + ".eelvl");
				}
			}
			else fileSaved();
		}
		
		private static function fileSaved(e:Event = null):void {
			Global.playState.unsavedChanges = false;
			Global.newData = newData;
			Global.newData.inflate();
			Global.dataPos = newPos;
			Global.newData.position = newPos;
			Global.worldInfo.width = Global.playState.getWidth();
			Global.worldInfo.height = Global.playState.getHeight();
			Global.worldInfo.gravity = Global.playState.gravityMultiplier;
			Global.worldInfo.bg = Global.currentBgColor;
			Global.worldInfo.minimap = Global.ui2.minimapEnabled;
			Global.worldInfo.desc = Global.ui2.description;
			Global.worldInfo.worldName = Global.currentLevelname;
			if (downloaded) {
				Global.base.showInfo2("System Message", "World successfully saved.");
				Global.unsavedWorlds = false;
			}
		}
		
		private static function FromUShortArray(arr:Array) : ByteArray {
			var count:int = arr.length;
			var arr2:ByteArray = new ByteArray();

			for (var i:int = 0; i < count; i++)
			{
				arr2.writeByte(arr[i] >> 8);
				arr2.writeByte(arr[i] & 255);
			}
			return arr2

		}
		
		public static function RemoveCharacters(s:String):String {
			return s.replace(/[\/\\?%*:|"<>]/g, "");
		}
	}
}
