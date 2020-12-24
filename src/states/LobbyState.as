package states {
	import blitter.Bl;
	import blitter.BlState;
	import blitter.BlText;
	import com.greensock.core.SimpleTimeline;
	import flash.display.DisplayObjectContainer;
	import flash.display.SimpleButton;
	import flash.events.KeyboardEvent;
	import sample.ui.components.Label;
	import utilities.AsyncTasks;
	
	import com.greensock.*;
	import com.greensock.easing.*;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.filters.GlowFilter;
	import flash.geom.*;
	import flash.geom.ColorTransform;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	import flash.net.navigateToURL;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.text.TextFieldType;
	import flash.utils.Timer;
	
	import mx.utils.StringUtil;
	import utilities.ColorUtil;
	
	import ui.SettingsPage;
	import ui.ConfirmPrompt;
	import ui.campaigns.CampaignItem;
	import ui.campaigns.CampaignPage;
	import ui.lobby.Background;
	
	public class LobbyState extends BlState {
		
		[Embed(source="/../media/lobby/bg_overlay.png")] protected static var worldScrollOverlay:Class;
		protected var world_image_overlay:Bitmap = new Bitmap(new worldScrollOverlay().bitmapData);
		protected var world_image:Sprite = new Background();
		
		private var callback:Function;
		public var createCallback:Function;
		private var handleJoinSaved:Function;
		private var myroomsCallback:Function;
		
		private var container:Sprite = new Sprite();
		
		private var pageLobby:Sprite = new Sprite();
		
		private var pageCampaigns:Sprite = new Sprite();
		private var pageSocial:Sprite = new Sprite();
		private var pageSettings:Sprite = new Sprite();
		private var pageShop:Sprite = new Sprite();
		
		//[Embed(source="/../media/lobby/banner.png")] protected static var banner:Class;
		//protected var lobby_banner:BitmapData = new banner().bitmapData;
		
		protected var loadroom:LoadRoom;
		protected var loadroomBG:BlackBG;
		
		protected var fbtextfield:TextField;
		//protected var tw:Sprite = new Sprite();
		//protected var myworlds:PlayerWorlds;
		//protected var loginbox:LobbyLoginBox;
		//protected var gw:GuestWellcome;
		
		//private var _mainProfile:MainProfile;
		
		private var annbg:BlackBG;
		
		private var subtext:BlText = new BlText(11, 200, 0xdfdfdf, "left", "system", true);
		private var bm_subtext:Bitmap;
		private var bm_subtext_holder:Sprite;
		private var textTime:int = 0;
		private var texts:Array = []; 
		private var curText:int = 0;
		
		private var online:Number;
		private var wonline:Number;
		
		private var last_world_reload:Object;
		private var loading_worlds:Boolean;
		private var refreshtimer:Timer;
		
		private var firstDailyLogin:Boolean;
		
		public var currentPage:String = LobbyStatePage.ROOMLIST;
		
		//protected var bannerimg:Sprite = new Sprite();
			
		private var settings:SettingsPage;
		private var campaigns:CampaignPage;
		private var shop:ShopUI;
		
		//private var nameInput:BlText = new BlText(11, 300, 0xdfdfdf, "left", "arial", true);
		private var nameInputBl:BlText = new BlText(20, 200, Config.default_color_dark, "left", "visitor", true);
		private var nameInput:TextField = new TextField();
		private var nameHolder:Sprite = new Sprite();
		
		
		public function LobbyState(base:EverybodyEdits, firstDailyLogin:Boolean, tab:String){
			this.handleJoinSaved = handleJoinSaved;
			this.myroomsCallback = myroomsCallback;
			
			this.callback = callback;
			this.createCallback = createCallback;
			
			this.firstDailyLogin = firstDailyLogin;
			
			
			container.x = 0;
			Bl.stage.addChild(container);
			
			//trace(container.y);
			//trace(this.y);
			//trace(container.parent.y);
			
			container.addChild(world_image);
			container.addChild(world_image_overlay);
			
			var t:BlText = new BlText(30, 510, 0xD85C1A);
			t.text = "Everybody Edits Offline";
			var bmt:Bitmap = new Bitmap(t.clone());
			bmt.x = 10;
			bmt.y = 6;
			container.addChild(bmt);
			
			nameHolder.alpha = 0;
			
			var n:BlText = new BlText(11, 85, 0xdfdfdf, "left", "system", true);
			n.text = "Your name:";
			var bmn:Bitmap = new Bitmap(n.clone());
			//bmn.x = 450;
			//bmn.y = 14;
			bmn.y = 42 + 30 + 1 -29;
			bmn.x = 185;
			nameHolder.addChild(bmn);
			
			
			
			nameInputBl.text = Global.cookie.data.username ? Global.cookie.data.username : "player";
			Global.cookie.data.username = nameInputBl.text;
			
			if(nameInput != nameInputBl.textfield)
				nameInput = nameInputBl.textfield;
			
			nameInput.type = TextFieldType.INPUT;
			nameInput.selectable = true;
			nameInput.maxChars = 20;
			nameInput.restrict = "a-zA-Z0-9%\\-.'~"; 
			
			nameInput.addEventListener(Event.CHANGE, function(e:Event):void {
				//nameInput.text = nameInput.text.toLowerCase();
				nameInputBl.text = nameInput.text.toLowerCase();
			});
			nameInput.addEventListener(FocusEvent.FOCUS_OUT, function(e:Event):void {
				if(nameInput.text == "") {
					nameInputBl.text = "player";
				}
				Global.cookie.data.username = nameInputBl.text;
			});
			
			nameInput.x = bmn.x + 85;
			nameInput.y = bmn.y;
			nameHolder.addChild(nameInput);
			
			
			//nameInput.text = Global.cookie.data.username ? Global.cookie.data.username : "player";
			//Global.cookie.data.username = nameInput.text;
			//
			//nameInput.type = TextFieldType.INPUT;
			//nameInput.maxChars = 20;
			//nameInput.multiline = false;
			//nameInput.restrict = "a-zA-Z0-9%\\-.'~"; 
			//nameInput.setTextFormat(new TextFormat("visitor", 20, Config.default_color_dark));
			//ColorUtil.colorizeUsername(nameInput);
			//nameInput.addEventListener(Event.CHANGE, function(e:Event):void {
				//nameInput.text = nameInput.text.toLowerCase();
				//nameInput.setTextFormat(new TextFormat(null, null, Config.default_color_dark));
				//ColorUtil.colorizeUsername(nameInput);
			//});
			//nameInput.addEventListener(FocusEvent.FOCUS_OUT, function(e:Event):void {
				//if(nameInput.text == "") {
					//nameInput.text = "player";
					//nameInput.setTextFormat(new TextFormat(null, null, Config.default_color_dark));
				//}
				//Global.cookie.data.username = nameInput.text;
			//});
			
			//nameInput.autoSize = TextFieldAutoSize.LEFT;
			////nameInput.x = bmn.x;
			////nameInput.y = bmn.y + 14;
			//nameInput.x = bmn.x + 85;
			//nameInput.y = bmn.y - 2;
			//nameHolder.addChild(nameInput);
			
			var rc:Label = new Label("Reset Cookies", 11, "left", 0xff5050, false, "system");
			var rcBtn:SimpleButton = new SimpleButton(rc, rc, rc, rc);
			rcBtn.y = 42 + 30 + 1 -29;
			rcBtn.x = 640 - rcBtn.width - 4;
			rcBtn.addEventListener(MouseEvent.MOUSE_DOWN, function(e:MouseEvent):void {
				
				var confirmReset1:ConfirmPrompt = new ConfirmPrompt("Are you sure you want to reset your cookies?\nAll of your campaign and time trial progress will be lost!", true, "Reset");
				
				Global.base.showOnTop(confirmReset1);
				
				confirmReset1.btn_yes.addEventListener(MouseEvent.MOUSE_DOWN, function(e:MouseEvent):void {
					confirmReset1.close();
					var confirmReset2:ConfirmPrompt = new ConfirmPrompt("Additionally, your name, smiley, aura, and customised settings will all be reset to default.", true, "Reset");
					
					Global.base.showOnTop(confirmReset2);
					
					confirmReset2.btn_yes.addEventListener(MouseEvent.MOUSE_DOWN, function(e:MouseEvent):void {
						confirmReset2.close();
						var confirmReset3:ConfirmPrompt = new ConfirmPrompt("Are you 100% sure you want to reset campaigns and settings?", true, "Reset!");
						
						Global.base.showOnTop(confirmReset3);
						
						confirmReset3.btn_yes.addEventListener(MouseEvent.MOUSE_DOWN, function(e:MouseEvent):void {
							Global.cookie.clear();
							nameInputBl.text = "player";
							Global.cookie.data.username = nameInput.text;
							Global.base.resetCampaignProgress();
							confirmReset3.close();
							Global.base.showInfo2("Successfully Reset!", "All of your progress is gone, and settings are reset to default.");
						});
						confirmReset3.btn_no.addEventListener(MouseEvent.MOUSE_DOWN, function(e:MouseEvent):void {
							confirmReset3.close();
						});
					});
					confirmReset2.btn_no.addEventListener(MouseEvent.MOUSE_DOWN, function(e:MouseEvent):void {
						confirmReset2.close();
					});
				});
				confirmReset1.btn_no.addEventListener(MouseEvent.MOUSE_DOWN, function(e:MouseEvent):void {
					confirmReset1.close();
				});
			});
			nameHolder.addChild(rcBtn);
			
			container.addChild(nameHolder);
			
			// TODO: Decide if the "Beta" tag should be a thing...
			/*if (Global.player_is_beta_member) {
				var tb:BlText = new BlText(11, 35, 0xFFB700);
				tb.text = "Beta";
				var bmtb:Bitmap = new Bitmap(tb.clone());
				bmtb.x = 286;
				bmtb.y = 33;
				container.addChild(bmtb);
			}*/
			
			bm_subtext_holder = new Sprite();
			container.addChild(bm_subtext_holder);
			
			container.addChild(pageLobby);
			
			
			container.addChild(pageCampaigns);
			pageCampaigns.visible = false;
			
			container.addChild(pageSocial);
			pageSocial.visible = false;
			
			container.addChild(pageSettings);
			pageSettings.visible = false;
			
			container.addChild(pageShop);
			pageShop.visible = false;
			
			Global.stage.frameRate = Config.lobbyFrameRate;
			
			//setPage(LobbyStatePage.CAMPAIGN);
		}
		
		public function validateEmail(email:String):Boolean {
			var emailExpression:RegExp=/^[a-z0-9][-._a-z0-9]*@([a-z0-9][-_a-z0-9]*\.)+[a-z]{2,6}$/;
			return emailExpression.test(email);
		}
		
		public function setSubtextArray(arr:Array):void {
			texts = arr;
			curText = 0;
			if (texts.length > 0) updateText();
			
			TweenMax.to(nameHolder, 0.3, { alpha:0, onComplete:function():void{
				TweenMax.to(nameHolder, 0.3, { alpha:1 });
			} });
		}
		
		public override function draw(target:BitmapData, ox:int, oy:int) : void{
			target.fillRect(target.rect,0);
			Global.stage.frameRate = Config.lobbyFrameRate;
			
			if (texts.length > 1 && textTime++ == 30 * 5) updateText();
		}
		
		public function updateText():void {
			TweenMax.to(bm_subtext_holder, 0.3, { alpha:0, onComplete:function():void{
				try {
					subtext.text = texts[curText++];
					if(bm_subtext != null) {
						bm_subtext_holder.removeChild(bm_subtext);				
					}
					bm_subtext = new Bitmap(subtext.clone());
					bm_subtext.y = 42 + 30 + 1 -29;
					bm_subtext.x = 10;
					bm_subtext_holder.addChild(bm_subtext);
					TweenMax.to(bm_subtext_holder, 0.3, { alpha:1 });
				} catch(e:Error) {}
			} });
			textTime = 0;
			
			if (curText > texts.length - 1) curText = 0;
		}
		
		private function joinRoomDirectly(id:String):void {
			reset();
			callback(id);
		}
		
		private function joinRoom(id:String, name:String, room:Object):void {
			reset();
			
			if (room.data.myworld) {		
				if (id == "savedworld") {
					myroomsCallback()
				} else if (id == "savedbetaworld") {
					myroomsCallback(true)
				} else if(id.substring(0,2) == "PW" || id.substring(0,2) == "BW") {
					Bl.data.roomname = name;
					callback(id);
				} else {
					var to:Array = id.split("x")
					handleJoinSaved(to[0], to[1]);
				}
			} else {
				Bl.data.roomname = name;
				callback(id);
			}					
		}
		
		private function createRoom(id:String, editkey:String, iscustom:Boolean = false):void {
			if (editkey != "") Bl.data.createdOpenWorldWithKey = true;
			
			reset();
			createCallback(id, editkey);
		}
		
		public function showLoadRoom():void {
			if (!loadroom) {
				loadroom = new LoadRoom();
				if (!loadroomBG) loadroomBG = new BlackBG();
				function closeLoadRoom():void {
					TweenMax.to(loadroom, 0.3, {alpha:0, onComplete:function():void{
						if (loadroom.parent) loadroom.parent.removeChild(loadroom);
					} });
					TweenMax.to(loadroomBG, 0.3, { alpha:0, onComplete:function():void {
						if (loadroomBG.parent) loadroomBG.parent.removeChild(loadroomBG);
					} });
				}
				function submitLoadRoom():void {
					var id:String = StringUtil.trim(loadroom.roomid.text);
					if (id == "") {
						closeLoadRoom();
					} else {
						if (loadroom.parent) loadroom.parent.removeChild(loadroom);
						if (loadroomBG.parent) loadroomBG.parent.removeChild(loadroomBG);
						joinRoomDirectly(id);
					}
				}
				loadroom.closebtn.addEventListener(MouseEvent.MOUSE_DOWN, closeLoadRoom);
				loadroom.btn_join.addEventListener(MouseEvent.MOUSE_DOWN, submitLoadRoom);
				loadroom.roomid.addEventListener(KeyboardEvent.KEY_DOWN, function(e:KeyboardEvent):void {
					if (e.keyCode == 13) submitLoadRoom();
				});
			}
			loadroom.x = (Global.width - 327) / 2;
			loadroom.alpha = 0;
			loadroom.roomid.text = "";
			Bl.stage.focus = loadroom.roomid;
			loadroomBG.alpha = 0;
			container.addChild(loadroomBG);
			container.addChild(loadroom);
			TweenMax.to(loadroom, 0.3, { alpha:1 });
			TweenMax.to(loadroomBG, 0.3, { alpha:1 });
			
		}
 		
		override public function resize():void {
			//// profile layout	
			//if(_mainProfile != null) _mainProfile.width = Global.width - _mainProfile.x - 13;
			
			//if (shop) shop.x = (Global.width - 620) / 2;
			
			var gs:DisplayObject = container.getChildByName("GetGemsNow");
			if (gs)	gs.x = (Global.width - 606) / 2;
			var ty:DisplayObject = container.getChildByName("Thankyou");
			if (ty)	ty.x = (Global.width - 472) / 2;
			
			//if (fbtextfield) fbtextfield.x = Global.width - 10;
			
			container.x = Bl.stage.stageWidth != 0 ? Math.round((Bl.stage.stageWidth - Config.maxwidth) / 2) : 0;
		}
		
		public function reset():void {
			Global.stage.frameRate = Config.lobbyFrameRate;
			if (container && container.parent) container.parent.removeChild(container);
		}
		
		public function setPage(page:String):void {
			if (currentPage == page) return;
			currentPage = page;
			
			switch (page) {
				case LobbyStatePage.ROOMLIST:
					setSubtextArray([online + " Players Online - " + wonline + " Worlds Online"]);
					break;
				case LobbyStatePage.CAMPAIGN:
					if (!campaigns && Global.base.campaigns) {
						campaigns = /*new CampaignPage(this, null)*/ Global.base.campaigns;
						campaigns.x = 13;
						campaigns.y = 95 -29;
						pageCampaigns.addChild(campaigns);
					}
					if (campaigns) {
						campaigns.refreshSubtext();
					}
					break;
				case LobbyStatePage.SETTINGS:
					if (!settings) {
						settings = new SettingsPage();
						settings.x = 13;
						settings.y = 95;
						pageSettings.addChild(settings);
					}
					setSubtextArray(["Adjust the game's settings to your needs!"]);
					break;
				case LobbyStatePage.SOCIAL:
					setSubtextArray(["Manage friends, crews, and more!"]);
					break;
			}
			
			if (page != LobbyStatePage.SETTINGS && settings) settings.closeKeyBindings();
			
			togglePage(pageLobby, LobbyStatePage.ROOMLIST);
			togglePage(pageCampaigns, LobbyStatePage.CAMPAIGN);
			togglePage(pageSocial, LobbyStatePage.SOCIAL);
			togglePage(pageSettings, LobbyStatePage.SETTINGS);
			togglePage(pageShop, LobbyStatePage.ENERGY_SHOP);
		}
		
		private function togglePage(t:Object, needsPage:String):void {
			if (!t) return;
			
			t.visible = currentPage == needsPage;
			
			if (t.visible) {
				t.alpha = 0;
				TweenMax.to(t, 0.5, { alpha:1 }); // was 0.8
			}
		}
		
		override public function get align():String {
			return STATE_ALIGN_LEFT;
		}
		
	}
}