package ui.campaigns {
	import blitter.Bl;
	
	import com.greensock.*;
	import com.greensock.easing.*;
	import events.JoinWorldEvent;
	import flash.display.SimpleButton;
	import flash.media.StageVideoAvailabilityReason;
	import flash.net.FileReference;
	import ui.CreateLevelPrompt;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.BlendMode;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.FileFilter;
	import flash.net.URLRequest;
	import flash.text.TextFieldAutoSize;
	import flash.utils.ByteArray;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import items.ItemId;
	
	import sample.ui.components.*;
	import sample.ui.components.scroll.ScrollBar;
	import sample.ui.components.scroll.ScrollBox;
	
	import states.LobbyState;
	
	import ui.ConfirmPrompt;
	import ui.ConfirmPrompt;
	import ui.campaigns.CampaignWorld;
	import ui.profile.FillBox;
	
	import states.LobbyStatePage;
	
    import com.nochump.util.zip.ZipEntry;
    import com.nochump.util.zip.ZipFile;
	
	public class CampaignPage extends assets_CampaignPage {
		
		[Embed(source = "/../media/empty.eelvl", mimeType = "application/octet-stream")] private static var EmptyWorld:Class;
		
		//[Embed(source="/../campaigns/0/0.eelvl", mimeType = "application/octet-stream")] private static var Tutorial0:Class;
		//[Embed(source="/../campaigns/0/0.info", mimeType = "application/octet-stream")] private static var TutorialInfo0:Class;
		//[Embed(source="/../campaigns/0/0.png", mimeType = "image/png")] private static var TutorialPng0:Class;
		[Embed(source = "/../media/campaigns/campaigns.zip", mimeType = "application/octet-stream")] private static var CampaignZip:Class;
		
		[Embed(source="/../media/campaigns/previews/00/0.png", mimeType = "image/png")] private static var Preview000:Class;
		[Embed(source="/../media/campaigns/previews/00/1.png", mimeType = "image/png")] private static var Preview001:Class;
		[Embed(source="/../media/campaigns/previews/00/2.png", mimeType = "image/png")] private static var Preview002:Class;
		[Embed(source="/../media/campaigns/previews/00/3.png", mimeType = "image/png")] private static var Preview003:Class;

		[Embed(source="/../media/campaigns/previews/01/0.png", mimeType = "image/png")] private static var Preview010:Class;
		[Embed(source="/../media/campaigns/previews/01/1.png", mimeType = "image/png")] private static var Preview011:Class;
		[Embed(source="/../media/campaigns/previews/01/2.png", mimeType = "image/png")] private static var Preview012:Class;
		[Embed(source="/../media/campaigns/previews/01/3.png", mimeType = "image/png")] private static var Preview013:Class;

		[Embed(source="/../media/campaigns/previews/02/0.png", mimeType = "image/png")] private static var Preview020:Class;
		[Embed(source="/../media/campaigns/previews/02/1.png", mimeType = "image/png")] private static var Preview021:Class;
		[Embed(source="/../media/campaigns/previews/02/2.png", mimeType = "image/png")] private static var Preview022:Class;
		[Embed(source="/../media/campaigns/previews/02/3.png", mimeType = "image/png")] private static var Preview023:Class;
		[Embed(source="/../media/campaigns/previews/02/4.png", mimeType = "image/png")] private static var Preview024:Class;
		[Embed(source="/../media/campaigns/previews/02/5.png", mimeType = "image/png")] private static var Preview025:Class;

		[Embed(source="/../media/campaigns/previews/03/0.png", mimeType = "image/png")] private static var Preview030:Class;
		[Embed(source="/../media/campaigns/previews/03/1.png", mimeType = "image/png")] private static var Preview031:Class;
		[Embed(source="/../media/campaigns/previews/03/2.png", mimeType = "image/png")] private static var Preview032:Class;
		[Embed(source="/../media/campaigns/previews/03/3.png", mimeType = "image/png")] private static var Preview033:Class;
		[Embed(source="/../media/campaigns/previews/03/4.png", mimeType = "image/png")] private static var Preview034:Class;

		[Embed(source="/../media/campaigns/previews/04/0.png", mimeType = "image/png")] private static var Preview040:Class;
		[Embed(source="/../media/campaigns/previews/04/1.png", mimeType = "image/png")] private static var Preview041:Class;
		[Embed(source="/../media/campaigns/previews/04/2.png", mimeType = "image/png")] private static var Preview042:Class;
		[Embed(source="/../media/campaigns/previews/04/3.png", mimeType = "image/png")] private static var Preview043:Class;

		[Embed(source="/../media/campaigns/previews/05/0.png", mimeType = "image/png")] private static var Preview050:Class;
		[Embed(source="/../media/campaigns/previews/05/1.png", mimeType = "image/png")] private static var Preview051:Class;
		[Embed(source="/../media/campaigns/previews/05/2.png", mimeType = "image/png")] private static var Preview052:Class;
		[Embed(source="/../media/campaigns/previews/05/3.png", mimeType = "image/png")] private static var Preview053:Class;
		[Embed(source="/../media/campaigns/previews/05/4.png", mimeType = "image/png")] private static var Preview054:Class;

		[Embed(source="/../media/campaigns/previews/06/0.png", mimeType = "image/png")] private static var Preview060:Class;
		[Embed(source="/../media/campaigns/previews/06/1.png", mimeType = "image/png")] private static var Preview061:Class;
		[Embed(source="/../media/campaigns/previews/06/2.png", mimeType = "image/png")] private static var Preview062:Class;
		[Embed(source="/../media/campaigns/previews/06/3.png", mimeType = "image/png")] private static var Preview063:Class;
		[Embed(source="/../media/campaigns/previews/06/4.png", mimeType = "image/png")] private static var Preview064:Class;

		[Embed(source="/../media/campaigns/previews/07/0.png", mimeType = "image/png")] private static var Preview070:Class;
		[Embed(source="/../media/campaigns/previews/07/1.png", mimeType = "image/png")] private static var Preview071:Class;
		[Embed(source="/../media/campaigns/previews/07/2.png", mimeType = "image/png")] private static var Preview072:Class;
		[Embed(source="/../media/campaigns/previews/07/3.png", mimeType = "image/png")] private static var Preview073:Class;

		[Embed(source="/../media/campaigns/previews/08/0.png", mimeType = "image/png")] private static var Preview080:Class;
		[Embed(source="/../media/campaigns/previews/08/1.png", mimeType = "image/png")] private static var Preview081:Class;
		[Embed(source="/../media/campaigns/previews/08/2.png", mimeType = "image/png")] private static var Preview082:Class;
		[Embed(source="/../media/campaigns/previews/08/3.png", mimeType = "image/png")] private static var Preview083:Class;
		[Embed(source="/../media/campaigns/previews/08/4.png", mimeType = "image/png")] private static var Preview084:Class;

		[Embed(source="/../media/campaigns/previews/09/0.png", mimeType = "image/png")] private static var Preview090:Class;
		[Embed(source="/../media/campaigns/previews/09/1.png", mimeType = "image/png")] private static var Preview091:Class;
		[Embed(source="/../media/campaigns/previews/09/2.png", mimeType = "image/png")] private static var Preview092:Class;
		[Embed(source="/../media/campaigns/previews/09/3.png", mimeType = "image/png")] private static var Preview093:Class;
		[Embed(source="/../media/campaigns/previews/09/4.png", mimeType = "image/png")] private static var Preview094:Class;

		[Embed(source="/../media/campaigns/previews/10/0.png", mimeType = "image/png")] private static var Preview100:Class;
		[Embed(source="/../media/campaigns/previews/10/1.png", mimeType = "image/png")] private static var Preview101:Class;
		[Embed(source="/../media/campaigns/previews/10/2.png", mimeType = "image/png")] private static var Preview102:Class;
		[Embed(source="/../media/campaigns/previews/10/3.png", mimeType = "image/png")] private static var Preview103:Class;
		[Embed(source="/../media/campaigns/previews/10/4.png", mimeType = "image/png")] private static var Preview104:Class;
		[Embed(source="/../media/campaigns/previews/10/5.png", mimeType = "image/png")] private static var Preview105:Class;

		[Embed(source="/../media/campaigns/previews/11/0.png", mimeType = "image/png")] private static var Preview110:Class;
		[Embed(source="/../media/campaigns/previews/11/1.png", mimeType = "image/png")] private static var Preview111:Class;
		[Embed(source="/../media/campaigns/previews/11/2.png", mimeType = "image/png")] private static var Preview112:Class;
		[Embed(source="/../media/campaigns/previews/11/3.png", mimeType = "image/png")] private static var Preview113:Class;

		[Embed(source="/../media/campaigns/previews/12/0.png", mimeType = "image/png")] private static var Preview120:Class;
		[Embed(source="/../media/campaigns/previews/12/1.png", mimeType = "image/png")] private static var Preview121:Class;
		[Embed(source="/../media/campaigns/previews/12/2.png", mimeType = "image/png")] private static var Preview122:Class;
		[Embed(source="/../media/campaigns/previews/12/3.png", mimeType = "image/png")] private static var Preview123:Class;

		[Embed(source="/../media/campaigns/previews/13/0.png", mimeType = "image/png")] private static var Preview130:Class;
		[Embed(source="/../media/campaigns/previews/13/1.png", mimeType = "image/png")] private static var Preview131:Class;
		[Embed(source="/../media/campaigns/previews/13/2.png", mimeType = "image/png")] private static var Preview132:Class;
		[Embed(source="/../media/campaigns/previews/13/3.png", mimeType = "image/png")] private static var Preview133:Class;

		[Embed(source="/../media/campaigns/previews/14/0.png", mimeType = "image/png")] private static var Preview140:Class;
		[Embed(source="/../media/campaigns/previews/14/1.png", mimeType = "image/png")] private static var Preview141:Class;
		[Embed(source="/../media/campaigns/previews/14/2.png", mimeType = "image/png")] private static var Preview142:Class;
		[Embed(source="/../media/campaigns/previews/14/3.png", mimeType = "image/png")] private static var Preview143:Class;
		[Embed(source="/../media/campaigns/previews/14/4.png", mimeType = "image/png")] private static var Preview144:Class;
		[Embed(source="/../media/campaigns/previews/14/5.png", mimeType = "image/png")] private static var Preview145:Class;
		[Embed(source="/../media/campaigns/previews/14/6.png", mimeType = "image/png")] private static var Preview146:Class;

		[Embed(source="/../media/campaigns/previews/15/0.png", mimeType = "image/png")] private static var Preview150:Class;
		[Embed(source="/../media/campaigns/previews/15/1.png", mimeType = "image/png")] private static var Preview151:Class;
		[Embed(source="/../media/campaigns/previews/15/2.png", mimeType = "image/png")] private static var Preview152:Class;
		[Embed(source="/../media/campaigns/previews/15/3.png", mimeType = "image/png")] private static var Preview153:Class;

		[Embed(source="/../media/campaigns/previews/16/0.png", mimeType = "image/png")] private static var Preview160:Class;
		[Embed(source="/../media/campaigns/previews/16/1.png", mimeType = "image/png")] private static var Preview161:Class;
		[Embed(source="/../media/campaigns/previews/16/2.png", mimeType = "image/png")] private static var Preview162:Class;
		[Embed(source="/../media/campaigns/previews/16/3.png", mimeType = "image/png")] private static var Preview163:Class;

		[Embed(source="/../media/campaigns/previews/17/0.png", mimeType = "image/png")] private static var Preview170:Class;
		[Embed(source="/../media/campaigns/previews/17/1.png", mimeType = "image/png")] private static var Preview171:Class;
		[Embed(source="/../media/campaigns/previews/17/2.png", mimeType = "image/png")] private static var Preview172:Class;
		[Embed(source="/../media/campaigns/previews/17/3.png", mimeType = "image/png")] private static var Preview173:Class;

		[Embed(source="/../media/campaigns/previews/18/0.png", mimeType = "image/png")] private static var Preview180:Class;
		[Embed(source="/../media/campaigns/previews/18/1.png", mimeType = "image/png")] private static var Preview181:Class;
		[Embed(source="/../media/campaigns/previews/18/2.png", mimeType = "image/png")] private static var Preview182:Class;
		[Embed(source="/../media/campaigns/previews/18/3.png", mimeType = "image/png")] private static var Preview183:Class;

		[Embed(source="/../media/campaigns/previews/19/0.png", mimeType = "image/png")] private static var Preview190:Class;
		[Embed(source="/../media/campaigns/previews/19/1.png", mimeType = "image/png")] private static var Preview191:Class;
		[Embed(source="/../media/campaigns/previews/19/2.png", mimeType = "image/png")] private static var Preview192:Class;
		[Embed(source="/../media/campaigns/previews/19/3.png", mimeType = "image/png")] private static var Preview193:Class;

		[Embed(source="/../media/campaigns/previews/20/0.png", mimeType = "image/png")] private static var Preview200:Class;
		[Embed(source="/../media/campaigns/previews/20/1.png", mimeType = "image/png")] private static var Preview201:Class;
		[Embed(source="/../media/campaigns/previews/20/2.png", mimeType = "image/png")] private static var Preview202:Class;
		[Embed(source="/../media/campaigns/previews/20/3.png", mimeType = "image/png")] private static var Preview203:Class;

		[Embed(source="/../media/campaigns/previews/21/0.png", mimeType = "image/png")] private static var Preview210:Class;
		[Embed(source="/../media/campaigns/previews/21/1.png", mimeType = "image/png")] private static var Preview211:Class;
		[Embed(source="/../media/campaigns/previews/21/2.png", mimeType = "image/png")] private static var Preview212:Class;
		[Embed(source="/../media/campaigns/previews/21/3.png", mimeType = "image/png")] private static var Preview213:Class;

		[Embed(source="/../media/campaigns/previews/22/0.png", mimeType = "image/png")] private static var Preview220:Class;
		[Embed(source="/../media/campaigns/previews/22/1.png", mimeType = "image/png")] private static var Preview221:Class;
		[Embed(source="/../media/campaigns/previews/22/2.png", mimeType = "image/png")] private static var Preview222:Class;
		[Embed(source="/../media/campaigns/previews/22/3.png", mimeType = "image/png")] private static var Preview223:Class;

		[Embed(source="/../media/campaigns/previews/23/0.png", mimeType = "image/png")] private static var Preview230:Class;
		[Embed(source="/../media/campaigns/previews/23/1.png", mimeType = "image/png")] private static var Preview231:Class;
		[Embed(source="/../media/campaigns/previews/23/2.png", mimeType = "image/png")] private static var Preview232:Class;
		[Embed(source="/../media/campaigns/previews/23/3.png", mimeType = "image/png")] private static var Preview233:Class;

		[Embed(source="/../media/campaigns/previews/24/0.png", mimeType = "image/png")] private static var Preview240:Class;
		[Embed(source="/../media/campaigns/previews/24/1.png", mimeType = "image/png")] private static var Preview241:Class;
		[Embed(source="/../media/campaigns/previews/24/2.png", mimeType = "image/png")] private static var Preview242:Class;
		[Embed(source="/../media/campaigns/previews/24/3.png", mimeType = "image/png")] private static var Preview243:Class;
		[Embed(source="/../media/campaigns/previews/24/4.png", mimeType = "image/png")] private static var Preview244:Class;

		[Embed(source="/../media/campaigns/previews/25/0.png", mimeType = "image/png")] private static var Preview250:Class;
		[Embed(source="/../media/campaigns/previews/25/1.png", mimeType = "image/png")] private static var Preview251:Class;
		[Embed(source="/../media/campaigns/previews/25/2.png", mimeType = "image/png")] private static var Preview252:Class;
		[Embed(source="/../media/campaigns/previews/25/3.png", mimeType = "image/png")] private static var Preview253:Class;
		[Embed(source="/../media/campaigns/previews/25/4.png", mimeType = "image/png")] private static var Preview254:Class;

		[Embed(source="/../media/campaigns/previews/26/0.png", mimeType = "image/png")] private static var Preview260:Class;
		[Embed(source="/../media/campaigns/previews/26/1.png", mimeType = "image/png")] private static var Preview261:Class;
		[Embed(source="/../media/campaigns/previews/26/2.png", mimeType = "image/png")] private static var Preview262:Class;
		[Embed(source="/../media/campaigns/previews/26/3.png", mimeType = "image/png")] private static var Preview263:Class;
		[Embed(source="/../media/campaigns/previews/26/4.png", mimeType = "image/png")] private static var Preview264:Class;

		[Embed(source="/../media/campaigns/previews/27/0.png", mimeType = "image/png")] private static var Preview270:Class;
		[Embed(source="/../media/campaigns/previews/27/1.png", mimeType = "image/png")] private static var Preview271:Class;
		[Embed(source="/../media/campaigns/previews/27/2.png", mimeType = "image/png")] private static var Preview272:Class;
		[Embed(source="/../media/campaigns/previews/27/3.png", mimeType = "image/png")] private static var Preview273:Class;
		[Embed(source="/../media/campaigns/previews/27/4.png", mimeType = "image/png")] private static var Preview274:Class;
		[Embed(source="/../media/campaigns/previews/27/5.png", mimeType = "image/png")] private static var Preview275:Class;

		[Embed(source="/../media/campaigns/previews/28/0.png", mimeType = "image/png")] private static var Preview280:Class;
		[Embed(source="/../media/campaigns/previews/28/1.png", mimeType = "image/png")] private static var Preview281:Class;
		[Embed(source="/../media/campaigns/previews/28/2.png", mimeType = "image/png")] private static var Preview282:Class;
		[Embed(source="/../media/campaigns/previews/28/3.png", mimeType = "image/png")] private static var Preview283:Class;

		[Embed(source="/../media/campaigns/previews/29/0.png", mimeType = "image/png")] private static var Preview290:Class;
		[Embed(source="/../media/campaigns/previews/29/1.png", mimeType = "image/png")] private static var Preview291:Class;
		[Embed(source="/../media/campaigns/previews/29/2.png", mimeType = "image/png")] private static var Preview292:Class;
		[Embed(source="/../media/campaigns/previews/29/3.png", mimeType = "image/png")] private static var Preview293:Class;

		[Embed(source="/../media/campaigns/previews/30/0.png", mimeType = "image/png")] private static var Preview300:Class;
		[Embed(source="/../media/campaigns/previews/30/1.png", mimeType = "image/png")] private static var Preview301:Class;
		[Embed(source="/../media/campaigns/previews/30/2.png", mimeType = "image/png")] private static var Preview302:Class;
		[Embed(source="/../media/campaigns/previews/30/3.png", mimeType = "image/png")] private static var Preview303:Class;

		[Embed(source="/../media/campaigns/previews/31/0.png", mimeType = "image/png")] private static var Preview310:Class;
		[Embed(source="/../media/campaigns/previews/31/1.png", mimeType = "image/png")] private static var Preview311:Class;
		[Embed(source="/../media/campaigns/previews/31/2.png", mimeType = "image/png")] private static var Preview312:Class;
		[Embed(source="/../media/campaigns/previews/31/3.png", mimeType = "image/png")] private static var Preview313:Class;
		[Embed(source="/../media/campaigns/previews/31/4.png", mimeType = "image/png")] private static var Preview314:Class;

		[Embed(source="/../media/campaigns/previews/32/0.png", mimeType = "image/png")] private static var Preview320:Class;
		[Embed(source="/../media/campaigns/previews/32/1.png", mimeType = "image/png")] private static var Preview321:Class;
		[Embed(source="/../media/campaigns/previews/32/2.png", mimeType = "image/png")] private static var Preview322:Class;
		[Embed(source="/../media/campaigns/previews/32/3.png", mimeType = "image/png")] private static var Preview323:Class;
		[Embed(source="/../media/campaigns/previews/32/4.png", mimeType = "image/png")] private static var Preview324:Class;
		[Embed(source="/../media/campaigns/previews/32/5.png", mimeType = "image/png")] private static var Preview325:Class;

		[Embed(source="/../media/campaigns/previews/33/0.png", mimeType = "image/png")] private static var Preview330:Class;
		[Embed(source="/../media/campaigns/previews/33/1.png", mimeType = "image/png")] private static var Preview331:Class;
		[Embed(source="/../media/campaigns/previews/33/2.png", mimeType = "image/png")] private static var Preview332:Class;
		[Embed(source="/../media/campaigns/previews/33/3.png", mimeType = "image/png")] private static var Preview333:Class;
		[Embed(source="/../media/campaigns/previews/33/4.png", mimeType = "image/png")] private static var Preview334:Class;
		[Embed(source="/../media/campaigns/previews/33/5.png", mimeType = "image/png")] private static var Preview335:Class;

		[Embed(source="/../media/campaigns/previews/34/0.png", mimeType = "image/png")] private static var Preview340:Class;
		[Embed(source="/../media/campaigns/previews/34/1.png", mimeType = "image/png")] private static var Preview341:Class;
		[Embed(source="/../media/campaigns/previews/34/2.png", mimeType = "image/png")] private static var Preview342:Class;
		[Embed(source="/../media/campaigns/previews/34/3.png", mimeType = "image/png")] private static var Preview343:Class;
		[Embed(source="/../media/campaigns/previews/34/4.png", mimeType = "image/png")] private static var Preview344:Class;

		[Embed(source="/../media/campaigns/previews/35/0.png", mimeType = "image/png")] private static var Preview350:Class;
		[Embed(source="/../media/campaigns/previews/35/1.png", mimeType = "image/png")] private static var Preview351:Class;
		[Embed(source="/../media/campaigns/previews/35/2.png", mimeType = "image/png")] private static var Preview352:Class;
		[Embed(source="/../media/campaigns/previews/35/3.png", mimeType = "image/png")] private static var Preview353:Class;
		[Embed(source="/../media/campaigns/previews/35/4.png", mimeType = "image/png")] private static var Preview354:Class;
		[Embed(source="/../media/campaigns/previews/35/5.png", mimeType = "image/png")] private static var Preview355:Class;
		[Embed(source="/../media/campaigns/previews/35/6.png", mimeType = "image/png")] private static var Preview356:Class;
		[Embed(source="/../media/campaigns/previews/35/7.png", mimeType = "image/png")] private static var Preview357:Class;
		[Embed(source="/../media/campaigns/previews/35/8.png", mimeType = "image/png")] private static var Preview358:Class;
		[Embed(source="/../media/campaigns/previews/35/9.png", mimeType = "image/png")] private static var Preview359:Class;

		[Embed(source="/../media/campaigns/previews/36/0.png", mimeType = "image/png")] private static var Preview360:Class;
		[Embed(source="/../media/campaigns/previews/36/1.png", mimeType = "image/png")] private static var Preview361:Class;
		[Embed(source="/../media/campaigns/previews/36/2.png", mimeType = "image/png")] private static var Preview362:Class;
		[Embed(source="/../media/campaigns/previews/36/3.png", mimeType = "image/png")] private static var Preview363:Class;
		[Embed(source="/../media/campaigns/previews/36/4.png", mimeType = "image/png")] private static var Preview364:Class;

		[Embed(source="/../media/campaigns/previews/37/0.png", mimeType = "image/png")] private static var Preview370:Class;
		[Embed(source="/../media/campaigns/previews/37/1.png", mimeType = "image/png")] private static var Preview371:Class;
		[Embed(source="/../media/campaigns/previews/37/2.png", mimeType = "image/png")] private static var Preview372:Class;
		[Embed(source="/../media/campaigns/previews/37/3.png", mimeType = "image/png")] private static var Preview373:Class;
		[Embed(source="/../media/campaigns/previews/37/4.png", mimeType = "image/png")] private static var Preview374:Class;

		[Embed(source="/../media/campaigns/previews/38/0.png", mimeType = "image/png")] private static var Preview380:Class;
		[Embed(source="/../media/campaigns/previews/38/1.png", mimeType = "image/png")] private static var Preview381:Class;
		[Embed(source="/../media/campaigns/previews/38/2.png", mimeType = "image/png")] private static var Preview382:Class;
		[Embed(source="/../media/campaigns/previews/38/3.png", mimeType = "image/png")] private static var Preview383:Class;
		[Embed(source="/../media/campaigns/previews/38/4.png", mimeType = "image/png")] private static var Preview384:Class;

		[Embed(source="/../media/campaigns/previews/39/0.png", mimeType = "image/png")] private static var Preview390:Class;
		[Embed(source="/../media/campaigns/previews/39/1.png", mimeType = "image/png")] private static var Preview391:Class;
		[Embed(source="/../media/campaigns/previews/39/2.png", mimeType = "image/png")] private static var Preview392:Class;
		[Embed(source="/../media/campaigns/previews/39/3.png", mimeType = "image/png")] private static var Preview393:Class;
		[Embed(source="/../media/campaigns/previews/39/4.png", mimeType = "image/png")] private static var Preview394:Class;

		[Embed(source="/../media/campaigns/previews/40/0.png", mimeType = "image/png")] private static var Preview400:Class;
		[Embed(source="/../media/campaigns/previews/40/1.png", mimeType = "image/png")] private static var Preview401:Class;
		[Embed(source="/../media/campaigns/previews/40/2.png", mimeType = "image/png")] private static var Preview402:Class;
		[Embed(source="/../media/campaigns/previews/40/3.png", mimeType = "image/png")] private static var Preview403:Class;
		[Embed(source="/../media/campaigns/previews/40/4.png", mimeType = "image/png")] private static var Preview404:Class;

		[Embed(source="/../media/campaigns/previews/41/0.png", mimeType = "image/png")] private static var Preview410:Class;
		[Embed(source="/../media/campaigns/previews/41/1.png", mimeType = "image/png")] private static var Preview411:Class;
		[Embed(source="/../media/campaigns/previews/41/2.png", mimeType = "image/png")] private static var Preview412:Class;
		[Embed(source="/../media/campaigns/previews/41/3.png", mimeType = "image/png")] private static var Preview413:Class;
		[Embed(source="/../media/campaigns/previews/41/4.png", mimeType = "image/png")] private static var Preview414:Class;
		
		[Embed(source="/../media/campaigns/badges.png", mimeType = "image/png")] private static var badgesBM:Class;
		private static var badgesBMD:BitmapData = new badgesBM().bitmapData;

		public static var previews:Array = [[new Preview000().bitmapData, new Preview001().bitmapData, new Preview002().bitmapData, new Preview003().bitmapData],
		[new Preview010().bitmapData, new Preview011().bitmapData, new Preview012().bitmapData, new Preview013().bitmapData],
		[new Preview020().bitmapData, new Preview021().bitmapData, new Preview022().bitmapData, new Preview023().bitmapData, new Preview024().bitmapData, new Preview025().bitmapData],
		[new Preview030().bitmapData, new Preview031().bitmapData, new Preview032().bitmapData, new Preview033().bitmapData, new Preview034().bitmapData],
		[new Preview040().bitmapData, new Preview041().bitmapData, new Preview042().bitmapData, new Preview043().bitmapData],
		[new Preview050().bitmapData, new Preview051().bitmapData, new Preview052().bitmapData, new Preview053().bitmapData, new Preview054().bitmapData],
		[new Preview060().bitmapData, new Preview061().bitmapData, new Preview062().bitmapData, new Preview063().bitmapData, new Preview064().bitmapData],
		[new Preview070().bitmapData, new Preview071().bitmapData, new Preview072().bitmapData, new Preview073().bitmapData],
		[new Preview080().bitmapData, new Preview081().bitmapData, new Preview082().bitmapData, new Preview083().bitmapData, new Preview084().bitmapData],
		[new Preview090().bitmapData, new Preview091().bitmapData, new Preview092().bitmapData, new Preview093().bitmapData, new Preview094().bitmapData],
		[new Preview100().bitmapData, new Preview101().bitmapData, new Preview102().bitmapData, new Preview103().bitmapData, new Preview104().bitmapData, new Preview105().bitmapData],
		[new Preview110().bitmapData, new Preview111().bitmapData, new Preview112().bitmapData, new Preview113().bitmapData],
		[new Preview120().bitmapData, new Preview121().bitmapData, new Preview122().bitmapData, new Preview123().bitmapData],
		[new Preview130().bitmapData, new Preview131().bitmapData, new Preview132().bitmapData, new Preview133().bitmapData],
		[new Preview140().bitmapData, new Preview141().bitmapData, new Preview142().bitmapData, new Preview143().bitmapData, new Preview144().bitmapData, new Preview145().bitmapData, new Preview146().bitmapData],
		[new Preview150().bitmapData, new Preview151().bitmapData, new Preview152().bitmapData, new Preview153().bitmapData],
		[new Preview160().bitmapData, new Preview161().bitmapData, new Preview162().bitmapData, new Preview163().bitmapData],
		[new Preview170().bitmapData, new Preview171().bitmapData, new Preview172().bitmapData, new Preview173().bitmapData],
		[new Preview180().bitmapData, new Preview181().bitmapData, new Preview182().bitmapData, new Preview183().bitmapData],
		[new Preview190().bitmapData, new Preview191().bitmapData, new Preview192().bitmapData, new Preview193().bitmapData],
		[new Preview200().bitmapData, new Preview201().bitmapData, new Preview202().bitmapData, new Preview203().bitmapData],
		[new Preview210().bitmapData, new Preview211().bitmapData, new Preview212().bitmapData, new Preview213().bitmapData],
		[new Preview220().bitmapData, new Preview221().bitmapData, new Preview222().bitmapData, new Preview223().bitmapData],
		[new Preview230().bitmapData, new Preview231().bitmapData, new Preview232().bitmapData, new Preview233().bitmapData],
		[new Preview240().bitmapData, new Preview241().bitmapData, new Preview242().bitmapData, new Preview243().bitmapData, new Preview244().bitmapData],
		[new Preview250().bitmapData, new Preview251().bitmapData, new Preview252().bitmapData, new Preview253().bitmapData, new Preview254().bitmapData],
		[new Preview260().bitmapData, new Preview261().bitmapData, new Preview262().bitmapData, new Preview263().bitmapData, new Preview264().bitmapData],
		[new Preview270().bitmapData, new Preview271().bitmapData, new Preview272().bitmapData, new Preview273().bitmapData, new Preview274().bitmapData, new Preview275().bitmapData],
		[new Preview280().bitmapData, new Preview281().bitmapData, new Preview282().bitmapData, new Preview283().bitmapData],
		[new Preview290().bitmapData, new Preview291().bitmapData, new Preview292().bitmapData, new Preview293().bitmapData],
		[new Preview300().bitmapData, new Preview301().bitmapData, new Preview302().bitmapData, new Preview303().bitmapData],
		[new Preview310().bitmapData, new Preview311().bitmapData, new Preview312().bitmapData, new Preview313().bitmapData, new Preview314().bitmapData],
		[new Preview320().bitmapData, new Preview321().bitmapData, new Preview322().bitmapData, new Preview323().bitmapData, new Preview324().bitmapData, new Preview325().bitmapData],
		[new Preview330().bitmapData, new Preview331().bitmapData, new Preview332().bitmapData, new Preview333().bitmapData, new Preview334().bitmapData, new Preview335().bitmapData],
		[new Preview340().bitmapData, new Preview341().bitmapData, new Preview342().bitmapData, new Preview343().bitmapData, new Preview344().bitmapData],
		[new Preview350().bitmapData, new Preview351().bitmapData, new Preview352().bitmapData, new Preview353().bitmapData, new Preview354().bitmapData, new Preview355().bitmapData, new Preview356().bitmapData, new Preview357().bitmapData, new Preview358().bitmapData, new Preview359().bitmapData],
		[new Preview360().bitmapData, new Preview361().bitmapData, new Preview362().bitmapData, new Preview363().bitmapData, new Preview364().bitmapData],
		[new Preview370().bitmapData, new Preview371().bitmapData, new Preview372().bitmapData, new Preview373().bitmapData, new Preview374().bitmapData],
		[new Preview380().bitmapData, new Preview381().bitmapData, new Preview382().bitmapData, new Preview383().bitmapData, new Preview384().bitmapData],
		[new Preview390().bitmapData, new Preview391().bitmapData, new Preview392().bitmapData, new Preview393().bitmapData, new Preview394().bitmapData],
		[new Preview400().bitmapData, new Preview401().bitmapData, new Preview402().bitmapData, new Preview403().bitmapData, new Preview404().bitmapData],
		[new Preview410().bitmapData, new Preview411().bitmapData, new Preview412().bitmapData, new Preview413().bitmapData, new Preview414().bitmapData]];

		
		private static const PAGE_CAMPAIGNS:int = 0;
		private static const PAGE_WORLDS:int = 1;
		private static const PAGE_TT:int = 2;
		private static const PAGE_TTWORLDS:int = 3;
		
		private var content:Box = new Box();
		private var headerBox:Box = new Box();
		
		private var campaign_items:Rows = new Rows();
		
		private var campaignsFillBox:FillBox = new FillBox(/*20, 20*/ 9, 9);
		private var worldsFillBox:FillBox = new FillBox(0, 20);
		
		private var campaignItemsScroll:ScrollBox = new ScrollBox();
		
		private var campaigns:Array = [];
		private var campaignItems:Array = [];
		private var campaignWorlds:Array = [];
		
		private var headerLabel:Label;
		private var backButton:assets_backbutton = new assets_backbutton();
		private var timeTrialsButton:assets_btn_timetrials = new assets_btn_timetrials();
		private var openLevelButton:assets_btn_openlevel = new assets_btn_openlevel();
		private var createLevelButton:assets_btn_createlevel = new assets_btn_createlevel();
		
		public var lobbystate:LobbyState;
		
		private var currentPage:int = PAGE_CAMPAIGNS;
		
		private var loadingFinishedCallback:Function;
		
		public var currentCampaign:CampaignItem;
		
		private var file:FileReference = new FileReference();
		private var file2:FileReference = new FileReference();
		private var loader:Loader = new Loader();
			
		public function CampaignPage(loadingFinishedCallback:Function)
		{
			super();
			
			for (var i:int = 0; i < previews.length; i++) {
				var bmd:BitmapData = new BitmapData(64,64,true,0x0);
				bmd.copyPixels(badgesBMD, new Rectangle(64*i, 0, 64,64), new Point(0,0));
				previews[i].push(bmd);
			}
			
			if (loadingFinishedCallback != null)
				this.loadingFinishedCallback = loadingFinishedCallback;
			
			worldsFillBox.horizontal = true;
			
			headerBox.margin(10, 10, 10, 10);
			content.margin(46,10,10,10);
			
			campaign_items.spacing(30);
			
			campaignItemsScroll.scrollMultiplier = 15;
			
			backButton.x = 24;
			backButton.y = 8;
			backButton.addEventListener(MouseEvent.CLICK, function():void {
				switchTo(currentPage == PAGE_TTWORLDS ? PAGE_TT : PAGE_CAMPAIGNS);
			});
			backButton.visible = false;
			addChild(backButton);
			
			bg.width -= 210;
			bg.height += 27;
			
			timeTrialsButton.x = bg.x + bg.width - 7 - timeTrialsButton.width;
			createLevelButton.x = /*openLevelButton.x - createLevelButton.width*/ 10;
			openLevelButton.x = createLevelButton.x + createLevelButton.width + 5;
			timeTrialsButton.y = bg.y + 10;
			openLevelButton.y = bg.y + 10;
			createLevelButton.y = bg.y + 10;
			timeTrialsButton.addEventListener(MouseEvent.CLICK, function():void {
				switchTo(PAGE_TT);
			});
			openLevelButton.addEventListener(MouseEvent.CLICK, function():void {
				file.browse([new FileFilter("EE Level (.eelvl, .eelvls)", "*.eelvl;*.eelvls")]);
				file.addEventListener(Event.SELECT, onFileSelected);
				//var tut:* = new Tutorial0();
				//onFileLoaded(null, tut);
				//var tutI:Array = new TutorialInfo0().toString().split("᎙");
				//trace(tutI);
				//var i:String = Math.floor(Math.random() * 4).toString();
				//var s:String = "/../campaigns/0/1.png";
				//[Embed(source=s, mimeType = "image/png")] var TutorialPng1:Class;
				//Global.base.showInfo("uwu?", "owo", -1, false, new TutorialPng1());
				
			});
			createLevelButton.addEventListener(MouseEvent.CLICK, function():void {
				Global.base.showOnTop(new CreateLevelPrompt(function(n:String, w:int, h:int, g:Number):void {
					//createEmptyWorld(636, 460);
					createEmptyWorld(w, h, g, n);
				}));
			});
			addChild(timeTrialsButton);
			addChild(openLevelButton);
			addChild(createLevelButton);
			
			content.add(new Box().margin(10,0,0,0).add(campaignItemsScroll.add(new Box().margin(0,0,0,0/*45*/).add(campaign_items))));
			campaignsFillBox.forceScale = false;
			campaignsFillBox.x = /*56*/ 0;
			
			headerLabel = new Label("", 15, "left", 0xFFFFFF, false, "system");
			headerLabel.autoSize = TextFieldAutoSize.LEFT;
			headerBox.add(new Box().margin(0,56,5,56).add(headerLabel));
			
			getCampaigns();
			
			content.add(campaignItemsScroll);
			
			headerBox.width = bg.width;
			headerBox.height = bg.height;
			addChild(headerBox);
			content.width = bg.width;
			content.height = bg.height;
			addChild(content);
		}
		
		private function onFileSelected(e:Event):void {
			file.addEventListener(Event.COMPLETE, onFileLoaded);
			file.load();
		}
		
		private function unsavedPrompt(text:String, button:String, callback:Function, ...args):void 
		{
			if(Global.playState.unsavedChanges && !Bl.data.isCampaignRoom) {
				var confirmPortal:ConfirmPrompt = new ConfirmPrompt(text, true, button);
				
				Global.base.showOnTop(confirmPortal);
				
				confirmPortal.btn_yes.addEventListener(MouseEvent.MOUSE_DOWN, function(e:MouseEvent):void {
					if (!Global.noSave) Global.cookie.flush();
					callback.apply(null, args);
					confirmPortal.close();
				});
				confirmPortal.btn_no.addEventListener(MouseEvent.MOUSE_DOWN, function(e:MouseEvent):void {
					Global.playerInstance.resetSend = false;
					confirmPortal.close();
				});
			}
			else callback.apply(null, args);
		}
		
		public function joinWorld(worldIndex:int = 0, worldSpawn:int = 0):void {
			//if(Global.playState.unsavedChanges && !Bl.data.isCampaignRoom) {
				//var confirmPortal:ConfirmPrompt = new ConfirmPrompt("Are you sure you want to travel to another world?\nUnsaved changes in this world WILL be saved!", true, "Leave");
				//
				//Global.base.showOnTop(confirmPortal);
				//
				//confirmPortal.btn_yes.addEventListener(MouseEvent.MOUSE_DOWN, function(e:MouseEvent):void {
					//if (!Global.noSave) Global.cookie.flush();
					//joinWorld2(worldIndex, worldSpawn);
					//confirmPortal.close();
				//});
				//confirmPortal.btn_no.addEventListener(MouseEvent.MOUSE_DOWN, function(e:MouseEvent):void {
					//Global.playerInstance.resetSend = false;
					//confirmPortal.close();
				//});
			//}
			//else joinWorld2(worldIndex, worldSpawn);
			unsavedPrompt("Are you sure you want to travel to a sub-world?\nUnsaved changes in this world WILL be saved!", "Leave",
				joinWorld2, worldIndex, worldSpawn);
		}
		private function joinWorld2(worldIndex:int = 0, worldSpawn:int = 0):void 
		{
			if (Global.isValidWorldIndex(worldIndex)) {
				DownloadLevel.SaveLevel(false);
				Bl.forceKeyUp(KeyBinding.risky.key.keyCode);
				Global.isWorldManagerOpen = Global.base.isMenuOpen(Global.base.TITLE_WORLD);
				Global.ui2.goToLobby(null, true);
				Global.worldIndex = worldIndex;
				onFileLoaded(null, Global.worlds[worldIndex], null, worldSpawn);
			}
		}
		
		public function createWorld():void {
			unsavedPrompt("Are you sure you want to create a new sub-world?\nUnsaved changes in this world WILL be saved!", "Create",
				function():void {
					DownloadLevel.SaveLevel(false);
					Global.worlds.push(new EmptyWorld());
					Global.worldNames.push("Untitled World");
					
					Global.unsavedWorlds = true;
					
					Global.base.updateMenu(Global.base.TITLE_WORLD);
				});
		}
		
		public function uploadWorld():void {
			unsavedPrompt("Are you sure you want to upload a new sub-world?\nUnsaved changes in this world WILL be saved!", "Upload",
				function():void {
					file2.browse([new FileFilter("EE Level (.eelvl)", "*.eelvl")]);
					file2.addEventListener(Event.SELECT, onFileSelected2);
				});
		}
		private function onFileSelected2(e:Event):void {
			file2.addEventListener(Event.COMPLETE, onFileLoaded2);
			file2.load();
		}
		private function onFileLoaded2(e:Event = null):void {
			DownloadLevel.SaveLevel(false);
			var data:ByteArray = new ByteArray();
			data.writeBytes(file2.data, 0, file2.data.length);
			Global.worlds.push(data);
			
			file2.data.inflate();
			file2.data.position = 0;
			file2.data.readUTF();
			Global.worldNames.push(file2.data.readUTF());
			
			Global.unsavedWorlds = true;
			
			Global.base.updateMenu(Global.base.TITLE_WORLD);
		}
		
		private function onFileLoaded(e:Event = null, worldData:ByteArray = null, tierData:Object = null, worldSpawn:int = 0):void {
			if (worldData == null && file.name.charAt(file.name.length - 1) == "s") {
				var zip:ZipFile = new ZipFile(file.data);
				trace("Loading zipped .eelvls:");
				for each(var entry:ZipEntry in zip.entries)
				{
					var entryContent:ByteArray = zip.getInput(entry);
					var fileType:String = entry.name.substring(entry.name.indexOf(".") + 1);
					
					if (fileType == "eelvl") {
						var wd:ByteArray = new ByteArray();
						wd.writeBytes(entryContent, 0, entryContent.length);
						Global.worlds.push(wd);
						
						entryContent.inflate();
						entryContent.position = 0;
						entryContent.readUTF();
						Global.worldNames.push(entryContent.readUTF());
						trace(Global.worlds.length-1, Global.worldNames.slice(-1));
						trace(entry.name);
					}
				}
				worldData = Global.worlds[0];
			}
			
			var data:ByteArray = null;
			if(worldData == null) {
				data = file.data;
			} else {
				//data = worldData;
				data = new ByteArray();
				data.writeBytes(worldData, 0, worldData.length);
			}
			data.inflate();
			data.position = 0;
			var owner:String = data.readUTF();
			trace("World owner:  " + owner);
			var worldName:String = data.readUTF();
			trace("World name:   " + worldName);
			var width:int = data.readInt();
			trace("World width:  " + width);
			var height:int = data.readInt() ;
			trace("World height: " + height);
			var gravity:Number = data.readFloat();
			trace("Gravity:      " + gravity);
			var background:uint = data.readUnsignedInt();
			trace("Background:   " + background);
			var description:String = data.readUTF();
			trace("Description:  " + description);
			var capaign:Boolean = data.readBoolean();
			trace("Campaign?     " + capaign);
			var crewId:String = data.readUTF();
			trace("Crew id:      " + crewId);
			var crewName:String = data.readUTF();
			trace("Crew name:    " + crewName);
			var crewStatus:int = data.readInt();
			trace("Crew status:  " + crewStatus);
			var minimap:Boolean = data.readBoolean();
			trace("Minimap?      " + minimap);
			var ownerID:String = data.readUTF();
			trace("Owner ID:     " + ownerID);
			
			//while (data.position < data.length) {
				//var bId:int = data.readInt();
				//var layer:int = data.readInt();
				//var xs:Array = readUShortArray(data);
				//var ys:Array = readUShortArray(data);
				//if (ItemId.isBlockRotateable(bId) || ItemId.isBlockNumbered(bId) || bId === ItemId.GUITAR || bId === ItemId.DRUMS || bId === ItemId.PIANO) {
					//var rot:int = data.readInt();
					//trace(bId, layer, rot);
				//} else if (bId === ItemId.PORTAL || bId === ItemId.PORTAL_INVISIBLE) {
					//var rot:int = data.readInt();
					//var id:int = data.readInt();
					//var tid:int = data.readInt();
					//trace(bId, layer, rot, id, tid);
				//} else if (bId === ItemId.TEXT_SIGN) {
					//var txt:String = data.readUTF();
					//var rot:int = data.readInt();
					//trace(bId, layer, txt, rot);
				//} else if (bId === ItemId.WORLD_PORTAL) {
					//var rId:String = data.readUTF();
					//var sId:int = data.readInt();
					//trace(bId, layer, rId, sId);
				//} else if (bId === ItemId.LABEL) {
					//var txt:String = data.readUTF();
					//var col:String = data.readUTF();
					//var width:int = data.readInt();
					//trace(bId, layer, txt, col, width);
				//} else if (ItemId.isNPC(bId)) {
					//var name:String = data.readUTF();
					//var text1:String = data.readUTF();
					//var text2:String = data.readUTF();
					//var text3:String = data.readUTF();
					//trace(bId, layer, name, text1, text2, text3);
				//} else {
					//trace(bId, layer);
				//}
			//}
			
			var d:NavigationEvent = new NavigationEvent(NavigationEvent.JOIN_WORLD, true, false);
			d.world_id = "PWSingplePlayer";
			d.world_name = worldName;
			d.extra.width = width;
			d.extra.height = height;
			d.extra.owner = crewName == "" ? owner : crewName;
			d.extra.gravity = gravity;
			d.extra.bg = background;
			d.extra.minimap = minimap;
			d.extra.spawn = worldSpawn;
			if (currentPage == PAGE_TTWORLDS) d.joindata.trialsmode = "true";
			if (tierData) {
				d.joindata.camp = currentCampaign.title;
				d.joindata.maxTier = currentCampaign.maxTier;
				d.joindata.tier = tierData.tier;
				d.joindata.diff = tierData.diff;
				d.joindata.completed = tierData.completed;
				Bl.data.isCampaignRoom = true;
			}
			else {
				Global.currentCampId = -1;
				Global.currentTierId = -1;
				Bl.data.isCampaignRoom = false;
			}
			
			Global.worldInfo.owner = owner;
			Global.worldInfo.worldName = worldName;
			Global.worldInfo.width = width;
			Global.worldInfo.height = height;
			Global.worldInfo.gravity = gravity;
			Global.worldInfo.bg = background;
			Global.worldInfo.desc = description;
			Global.worldInfo.campaign = capaign;
			Global.worldInfo.crewId = crewId;
			Global.worldInfo.crewName = crewName;
			Global.worldInfo.crewStatus = crewStatus;
			Global.worldInfo.minimap = minimap;
			Global.worldInfo.ownerId = ownerID;
			
			Global.newData = data;
			Global.dataPos = data.position;
			dispatchEvent(d);
		}
		
		private function createEmptyWorld(width:int = 25, height:int = 25, gravity:Number = 1, worldName:String = "Untitled World"):void {
			var d:NavigationEvent = new NavigationEvent(NavigationEvent.JOIN_WORLD, true, false);
			var contribution:String = "Cercul1 typo'd the world ID. That is literally all he contributed.";
			d.world_id = "PWSingplePlayer";
			d.world_name = worldName;
			d.extra.width = width;
			d.extra.height = height;
			d.extra.owner = Global.cookie.data.username ? Global.cookie.data.username : "player";
			d.extra.gravity = gravity;
			d.extra.bg = 0;
			d.extra.minimap = true;
			d.extra.spawn = 0;
			
			Global.worldInfo.owner = d.extra.owner;
			Global.worldInfo.worldName = worldName;
			Global.worldInfo.width = width;
			Global.worldInfo.height = height;
			Global.worldInfo.gravity = gravity;
			Global.worldInfo.bg = 0;
			Global.worldInfo.desc = "";
			Global.worldInfo.campaign = false;
			Global.worldInfo.crewId = "";
			Global.worldInfo.crewName = "";
			Global.worldInfo.crewStatus = 1;
			Global.worldInfo.minimap = true;
			Global.worldInfo.ownerId = "made offline";
			Global.dataPos = -1;
			Global.currentCampId = -1;
			Global.currentTierId = -1;
			
			Bl.data.isCampaignRoom = false;
			
			dispatchEvent(d);
		}
		
		//private function readUShortArray(data:ByteArray) : Array {
			//var arr:Array = [];
			//var length = data.readUnsignedInt();
			//var offset:int = data.position;
			//for (var i:int = 0; i < length / 2; i++ ) {
				//data.position = 2 * i + offset;
				//arr[i] = (data.readUnsignedByte() << 8) | data.readUnsignedByte();
			//}
			//return arr;
		//}
		
		private function getCampaigns() : void
		{
			if(campaigns.length < 3) {
			var zip:ZipFile = new ZipFile(new CampaignZip);
			campaigns = [];
			var tempCamps:Array = [];
			if (!Global.cookie.data.campaignProgress) Global.cookie.data.campaignProgress = new Array();
			trace("Loading campaigns:");
			for each(var entry:ZipEntry in zip.entries)
            {
                var entryContent:ByteArray = zip.getInput(entry);
				
				if (!entry.isDirectory()) {
					var i:int = 0;
					var campId:int = parseInt(entry.name.substring(0, entry.name.indexOf("/")));
					var tierId:int = parseInt(entry.name.substring(entry.name.indexOf("/") + 1, entry.name.indexOf(".")));
					var fileType:String = entry.name.substring(entry.name.indexOf(".") + 1);
					
					if (!tempCamps[campId]) {
						tempCamps[campId] = new Object();
						tempCamps[campId].worlds = [];
						tempCamps[campId].maxTier = 0;
						tempCamps[campId].completedTiers = 0;
						if (!Global.cookie.data.campaignProgress[campId])
							Global.cookie.data.campaignProgress[campId] = new Array();
					}
					var tempCamp:Object = tempCamps[campId];
					
					if (!tempCamp.worlds[tierId]) {
						tempCamp.worlds[tierId] = new Object();
						if (!Global.cookie.data.campaignProgress[campId][tierId]) {
							Global.cookie.data.campaignProgress[campId][tierId] = new Object();
							var progress:Object = Global.cookie.data.campaignProgress[campId][tierId];
							progress.time = -1;
							progress.rank = 0;
							progress.completed = 0;
						}
					}
					var tempWorld:Object = tempCamp.worlds[tierId];
					
					if (entry.name.substring(entry.name.lastIndexOf("/") + 1) == "campaign.info") {
						var campInfo:Array = entryContent.toString().split("᎙");
						tempCamp.diff = campInfo[i++];
						tempCamp.name = campInfo[i++];
						tempCamp.desc = campInfo[i++];
						trace(campId, campInfo[1])
					}
					else if (fileType == "info") {
						tempWorld.img = previews[campId][tierId];
						
						var tierInfo:Array = entryContent.toString().split("᎙");
						tempWorld.diff = tierInfo[i++];
						tempWorld.creators = tierInfo[i++];
						tempWorld.targetTimes = new Array();
						for (var j:int = 0; j < 5; j++) {
							if (i < tierInfo.length) {
								tempWorld.targetTimes.push(parseInt(tierInfo[i++]));
								tempWorld.trialsEnabled = true;
							} else {
								tempWorld.trialsEnabled = false;
							}
						}
						tempCamp.maxTier++;
						if (Global.cookie.data.campaignProgress[campId][tierId].completed)
							tempCamp.completedTiers++;
					}
					//else if (fileType == "png") {
						//var loadPng:Loader = new Loader();
						//var uwu:Function = function(campId:int, tierId:int):Function {
							//return function(event:Event):void {
								//var content:* = loadPng.content;
								//var data:BitmapData = new BitmapData(content.width, content.height)
								//data.draw(content);
								//trace(tempCamps[campId].worlds[tierId].creators);
								//tempCamps[campId].worlds[tierId].img = new Bitmap(data);
								////if(campId == 0 && tierId == 0)
								//Global.base.showInfo("uwu", "owo", -1, false, tempCamps[campId].worlds[tierId].img);
							//}
						//}
						//loadPng.contentLoaderInfo.addEventListener(Event.INIT, uwu(campId, tierId));
						//
						//loadPng.loadBytes(entryContent);
						
						
						//tempWorld.img = entryContent;
						
						
						//tempWorld.img = new ByteArray();
						//tempWorld.img.writeBytes(entryContent, 0, entryContent.length);
					//}
					else if (fileType == "eelvl") {
						tempWorld.eelvl = entryContent;
						//tempWorld.eelvl = new ByteArray();
						//tempWorld.eelvl.writeBytes(entryContent, 0, entryContent.length);
						
						entryContent.inflate();
						entryContent.position = 0;
						/*var owner:String = */entryContent.readUTF();
						tempWorld.name = entryContent.readUTF();
						//var width:int = entryContent.readInt();
						//var height:int = entryContent.readInt();
						//var gravity:Number = entryContent.readFloat();
						//var background:uint = entryContent.readUnsignedInt();
						//var description:String = entryContent.readUTF();
						//var capaign:Boolean = entryContent.readBoolean();
						//var crewId:String = entryContent.readUTF();
						//var crewName:String = entryContent.readUTF();
						//var crewStatus:int = entryContent.readInt();
						//var minimap:Boolean = entryContent.readBoolean();
						//var ownerID:String = entryContent.readUTF();
						entryContent.deflate();
					}
				}
            }
			
			for (var c:int = 0; c < tempCamps.length; c++) {
				var camp:Object = tempCamps[c];
				var stringId:String = c.toString();
				
				var campaign:CampaignItem = new CampaignItem(stringId, camp.name, camp.desc, camp.diff, camp.completedTiers == camp.maxTier, true, false, camp.maxTier);
				campaign.addEventListener(MouseEvent.CLICK, handleCampaignClick);
				campaigns.push(campaign);
				
				var worstRank:int = 6;
				for (var w:int = 0; w < camp.worlds.length; w++) {
					var level:Object = camp.worlds[w];
					var pro:Object = Global.cookie.data.campaignProgress[c][w];
					
					var world:CampaignWorld;
					if(level.trialsEnabled)
						world = new CampaignWorld(level.name, level.creators, level.diff, w+1, pro.completed, level.img, [], refreshScrollBox, level.eelvl, true, level.targetTimes, pro.time, pro.rank);
					else world = new CampaignWorld(level.name, level.creators, level.diff, w+1, pro.completed, level.img, [], refreshScrollBox, level.eelvl, false);
					
					world.main.addEventListener(MouseEvent.CLICK, handleCampaignWorldClick);
					campaign.addWorld(world);
					if (world.rank < worstRank) worstRank = world.rank;
				}
				campaign.newRank = worstRank;
			}
			if (!Global.noSave) Global.cookie.flush();
			}
			switchTo(PAGE_CAMPAIGNS);
			if (loadingFinishedCallback != null) {
				loadingFinishedCallback();
			}
			//if (lobbystate.currentPage == LobbyStatePage.CAMPAIGN)  Global.base.showLoadingScreen("Loading Campaigns");
			//Global.base.requestRemoteMethod("getCampaigns", function(m:Message):void {
				//var i:int = 0;
				//
				//campaigns = [];
				//var ranks:Array = [];
				//var minRank:int = 0;
				//
				//while (i < m.length) {
					//var campaign:CampaignItem = new CampaignItem(m.getString(i++), m.getString(i++), m.getString(i++), m.getInt(i++), m.getBoolean(i++), m.getBoolean(i++), m.getBoolean(i++));
					//campaign.addEventListener(MouseEvent.CLICK, handleCampaignClick);
					//campaigns.push(campaign);
					//
					//var numWorlds:int = m.getInt(i++);
					//for (var n1:int = 0; n1 < numWorlds; n1++) ranks[n1] = 0;
					//
					//for (var j:int = 0; j < numWorlds; j++) {
						//var id:String = m.getString(i++);
						//var name:String = m.getString(i++);
						//var creators:String = m.getString(i++);
						//var difficulty:int = m.getInt(i++);
						//var tier:int = m.getInt(i++);
						//if (id == "PWbc7Vf5QubEI" || id == "PWahKy9wI2cUI") id = "PWAJxPmkCva0I"; //random pic;
						//var imageLink:String = "https://r.playerio.com/r/everybody-edits-su9rn58o40itdbnw69plyw/Campaigns/" + id + ".png";
						//var status:int = m.getInt(i++);
						//
						//var trialsEnabled:Boolean = m.getBoolean(i++);
						//if (trialsEnabled) {
							//var time:int = m.getInt(i++);
							//var rank:int = m.getInt(i++);
							//var targetTimes:Array = [];
							//targetTimes.push(m.getInt(i++));
							//targetTimes.push(m.getInt(i++));
							//targetTimes.push(m.getInt(i++));
							//if (rank >= 3) targetTimes.push(m.getInt(i++));
							//if (rank >= 5) targetTimes.push(m.getInt(i++));
							//ranks[j] = rank;
						//}
						//
						//var rewards:Array = [];
						//var numRewards:int = m.getInt(i++);
						//for (var r:int = 0; r < numRewards; r++) {
							//rewards.push(new CampaignReward(m.getString(i++), m.getUInt(i++)));
						//}
						//
						//var world:CampaignWorld = trialsEnabled ?
							//new CampaignWorld(id, name, creators, difficulty, tier, status, imageLink, rewards, refreshScrollBox, targetTimes, time, rank) :
							//new CampaignWorld(id, name, creators, difficulty, tier, status, imageLink, rewards, refreshScrollBox);
						//world.main.addEventListener(MouseEvent.CLICK, handleCampaignWorldClick);
						//campaign.addWorld(world);
					//}
					//
					//minRank = 5;
					//for (var n2:int = 0; n2 < numWorlds; n2++)
						//minRank = ranks[n2] < minRank ? ranks[n2] : minRank;
					//
					//if (minRank > 0) {
						//campaign.clock = new Clock(minRank);
						//campaign.clock.x = campaign.width - campaign.clock.width - 10;
						//campaign.clock.y = 8;
						//campaign.addChild(campaign.clock);
					//}
				//}
				//switchTo(PAGE_CAMPAIGNS);
				//if (lobbystate.currentPage == LobbyStatePage.CAMPAIGN) Global.base.hideLoadingScreen();
				//
				//if (loadingFinishedCallback != null)
					//loadingFinishedCallback();
			//});
		}
		
		public function getCampaignByName(name:String) : CampaignItem
		{
			for (var i:int = 0; i < campaigns.length; i++){
				if ((campaigns[i] as CampaignItem).campaignName.text.toLowerCase() == name){
					return (campaigns[i] as CampaignItem);
				}
			}
			return null;
		}
		
		public function showTutorialOnly() : void
		{
			campaignsFillBox.removeAllChildren();
			for (var i:int = 0; i < campaigns.length; i++) {
				if ((campaigns[i] as CampaignItem).campaignName.text.toLowerCase() == "tutorials"){
					campaignItems.push(campaigns[i]);
					campaignsFillBox.addChild(campaigns[i]);
					
					campaigns[i].alpha = 0;
					TweenMax.to(campaigns[i], 0.6 * ((i < 5) ? i : 5), { alpha : 1 });
				}
			}
			campaignsFillBox.refresh();
			campaignItemsScroll.refresh();
		}
		
		public function openCampaign(cWorld:CampaignItem) : void
		{
			switchTo(PAGE_WORLDS, cWorld.campaignName.text, cWorld.id);
		}
		
		private function refreshScrollBox() : void
		{
			if (currentPage == PAGE_WORLDS || currentPage == PAGE_TTWORLDS){
				campaignItemsScroll.refresh();
				worldsFillBox.refresh();
			}
		}
		//uwu
		public function resetProgress():void 
		{
			Global.cookie.data.campaignProgress = new Array();
			for each (var camp:CampaignItem in campaigns) {
				var campId:int = parseInt(camp.id);
				Global.cookie.data.campaignProgress[campId] = new Array();
				camp.completed = false;
				camp.worstRank = 0;
				
				var tierId:int = 0;
				for each (var tier:CampaignWorld in camp.campaignWorlds) {
					Global.cookie.data.campaignProgress[campId][tierId] = new Object();
					var progress:Object = Global.cookie.data.campaignProgress[campId][tierId];
					progress.time = -1;
					progress.rank = 0;
					progress.completed = 0;
					
					tier.complete = false;
					if(tier.trialsEnabled) tier.updateTargetTimes();
					
					tierId++;
				}
			}
			if(currentPage == PAGE_TT || currentPage == PAGE_CAMPAIGNS) initCampaignItems();
			if(currentPage == PAGE_TTWORLDS || currentPage == PAGE_WORLDS) initCampaignWorlds(currentCampaign.id);
		}
		
		private function initCampaignItems() : void
		{
			//Clear these so we don't have duplicates
			campaignItems = [];
			campaignsFillBox.clear();
			
			campaigns.sort(function(a:CampaignItem, b:CampaignItem):int {
				if (a.locked && !b.locked) return 1;
				if (!a.locked && b.locked) return -1;
				if(currentPage != PAGE_TT) {
					if (a.completed && !b.completed) return 1;
					if (!a.completed && b.completed) return -1;
				}
				if (a.difficulty > b.difficulty) return 1;
				if (a.difficulty < b.difficulty) return -1;
				if (parseInt(a.id) > parseInt(b.id)) return 1;
				if (parseInt(a.id) < parseInt(b.id)) return -1;
				return 0;
			});
			
			var i:int = 0;
			for each (var item:CampaignItem in campaigns) {
				if (currentPage == PAGE_TT ? /*item.completed &&*/ item.campaignWorlds.some(function(w:CampaignWorld, i:int, a:Array):Boolean { return w.targetTimes !== null; }) : !item.hidden) {
					campaignItems.push(item);
					campaignsFillBox.addChild(item);
					if (item._check) item._check.visible = (item.completed && currentPage != PAGE_TT) || (item.worstRank == 5 && currentPage == PAGE_TT);
					if (item._clock) item._clock.visible = item.worstRank != 0 && currentPage == PAGE_TT;
					//if (item.clock) item.clock.visible = currentPage == PAGE_TT;
					item.alpha = 0;
					TweenMax.to(item, .5, { delay:0.075 * i, alpha:1 });
					i++;
				}
			}
			
			campaignItemsScroll.refresh();
		}
		
		public function initCampaignWorlds(id:String) : void
		{
			//Clear these so we don't have duplicates
			campaignWorlds = [];
			worldsFillBox.clear();
			
			for (var i: int = 0; i < campaigns.length; i++) {
				var campaign:CampaignItem = campaigns[i] as CampaignItem;
				if (campaign.id == id) {
					for (var j:int = 0; j < campaign.campaignWorlds.length; j++) {
						var world:CampaignWorld = campaign.campaignWorlds[j];
						if (currentPage == PAGE_TTWORLDS) {
							if (world.targetTimes === null) continue;
							
							
							world.checkVisible = world.rank == 5;
							if (world._check) world._check.visible = world.rank == 5;
							world.rewards.visible = false;
							//if (!world.times.parent) {
								world.times.removeChildren();
								var clocks:Vector.<ClockTime> = ClockTime.pickFour(world.targetTimes, world.time, world.rank);
								
								world.times.addChild(clocks[0]);
								
								clocks[1].y = Clock.size + 1;
								world.times.addChild(clocks[1]);
								
								clocks[2].y = clocks[1].y * 2;
								world.times.addChild(clocks[2]);
								
								clocks[3].y = clocks[1].y * 3;
								world.times.addChild(clocks[3]);
								
								world.addChild(world.times);
								world.positionTimes();
							//}
						} else {
							world.checkVisible = true;
							if (world._check) world._check.visible = true;
							if (world.times.parent) {
								world.removeChild(world.times);
								world.times.removeChildren();
							}
							world.rewards.visible = true;
						}
						campaignWorlds.push(world);
						worldsFillBox.addChild(world);
						world.alpha = 0;
						TweenMax.to(world, 0.5, { delay:0.075 * j, alpha:1 });
					}
					break;
				}
			}
		}
		
		private function handleCampaignClick(e:MouseEvent) : void
		{
			var cWorld:CampaignItem = (e.target as CampaignItem) || (e.target.parent as CampaignItem);
			switchTo(currentPage == PAGE_TT ? PAGE_TTWORLDS : PAGE_WORLDS, cWorld.campaignName.text, cWorld.id);
			
			currentCampaign = cWorld;
		}
		
		private function handleCampaignWorldClick(e:MouseEvent):void {
			var target:Object = e.target;
			while (!(target as CampaignWorld) && target.parent) target = target.parent;
			var cWorld:CampaignWorld = target as CampaignWorld;
			if (!cWorld) return;
			
			var cont:Boolean = !cWorld.locked;
			
			if (!cont) {
				var conf:ConfirmPrompt = new ConfirmPrompt("Are you sure you want to join this world? Locked worlds will not track your progress and won't reward you!", true, "Join", false);
				conf.btn_yes.addEventListener(MouseEvent.CLICK, function(ev:MouseEvent):void{
					conf.close();
					loadWorld(cWorld);
				});
				Global.base.showOnTop(conf);
			} else {
				loadWorld(cWorld);
			}
		}
		
		public function loadWorld(cWorld:CampaignWorld):void {
			//var joinEvent:NavigationEvent = new NavigationEvent(NavigationEvent.JOIN_WORLD,true,false);
			//joinEvent.world_id = cWorld.worldId;
			//if (currentPage == PAGE_TTWORLDS) joinEvent.joindata.trialsmode = "true";
			//Global.base.dispatchEvent(joinEvent);
			
			Global.currentCampId = parseInt(currentCampaign.id);
			Global.currentTierId = cWorld.tier - 1;
			if(cWorld.trialsEnabled)
				Global.currentTierInfo.times = cWorld.fullTargetTimes.concat();
			
			var tierData:Object = new Object();
			tierData.tier = cWorld.tier;
			tierData.diff = cWorld.diff;
			tierData.completed = cWorld.completed;
			onFileLoaded(null, cWorld.worldData, tierData);
		}
		
		public function switchTo(value:int, headerText:String = "", cId:String = null):void {
			currentPage = value;
			headerLabel.alpha = 0;
			TweenMax.to(headerLabel, 1, { alpha:1 });
			
			headerLabel.text = value == PAGE_CAMPAIGNS ? "" : value == PAGE_TT ? "Time Trials" : headerText;
			
			backButton.visible = timeTrialsButton.visible = openLevelButton.visible = createLevelButton.visible = false;
			
			switch (value) {
				case PAGE_CAMPAIGNS:
				case PAGE_TT:
					if (campaign_items.contains(worldsFillBox)) campaign_items.removeChild(worldsFillBox);
					if (!campaign_items.contains(campaignsFillBox)) campaign_items.addChild(campaignsFillBox);
					
					initCampaignItems();
					
					if (value == PAGE_TT) backButton.visible = true;
					else {
						timeTrialsButton.visible = true;
						openLevelButton.visible = true;
						createLevelButton.visible = true;
					}
					
					campaignItemsScroll.horizontal = false;
					
					break;
				case PAGE_WORLDS:
				case PAGE_TTWORLDS:
					if (campaign_items.contains(campaignsFillBox)) campaign_items.removeChild(campaignsFillBox);
					if (!campaign_items.contains(worldsFillBox)) campaign_items.addChild(worldsFillBox);
					
					initCampaignWorlds(cId);
					
					backButton.visible = true;
					campaignItemsScroll.horizontal = true;
					
					break;
			}
			
			refreshSubtext();
		}
		
		public function refreshSubtext():void {
			if(lobbystate) {
			switch (currentPage) {
				case PAGE_CAMPAIGNS:
				case PAGE_TT:
					var coCs:int = 0;
					for (var i:int = 0; i < campaignItems.length; i++) {
						if (currentPage == PAGE_TT) { if(campaignItems[i].worstRank == 5) coCs++; }
						else if (campaignItems[i].completed) coCs++;
					}
					var pageTitle:String = currentPage == PAGE_TT ? " Trial" : " Campaign";
					if (lobbystate.currentPage == LobbyStatePage.CAMPAIGN) {
						lobbystate.setSubtextArray([
							campaignItems.length + pageTitle + (campaignItems.length == 1?"":"s") + " available",
							coCs + pageTitle + (coCs == 1?"":"s") + " completed"
						]);
					}
					break;
				case PAGE_TTWORLDS:
				case PAGE_WORLDS:
					var coWs:int = 0;
					//var loWs:int = 0;
					for (var j:int = 0; j < campaignWorlds.length; j++) {
						if (currentPage == PAGE_TTWORLDS) { if(campaignWorlds[j].rank == 5) coWs++; }
						else if (campaignWorlds[j].completed) coWs++;
						//if (campaignWorlds[j].locked) loWs++;
					}
					var avWs:int = campaignWorlds.length /*- loWs*/;
					if (lobbystate.currentPage == LobbyStatePage.CAMPAIGN) {
						lobbystate.setSubtextArray([
							coWs + " World" + (coWs == 1?"":"s") + " completed",
							//loWs + " World" + (loWs == 1?"":"s") + " locked",
							avWs + " World" + (avWs == 1?"":"s") + " available"
						]);
					}
					break;
			}
		}
		}
		
	}
}