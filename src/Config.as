package
{
	import ui.lobby.FallingItemMode;

	public class Config
	{
		public static const site:String = "https://everybodyedits.com/";
		public static const url_blog:String = "https://blog.everybodyedits.com";
		public static const url_goldmember_about_page:String = site + "gold";
		public static const url_terms_page:String = site + "terms";
		public static const url_help_page:String = site + "help";
		public static const url_faq:String = site + "faq";
		public static const url_forums:String = "https://forums.everybodyedits.com/";
		public static const url_merch:String = "https://everybodyedits.wordpress.com/2018/08/01/everybody-edits-t-shirts/";
		public static const url_patreon:String = "https://patreon.com/everybodyedits/overview/";
		
		//Mp debug
		public static const use_debug_server:Boolean = false;
		public static const run_in_development_mode:Boolean = false;
		public static const show_disabled_shopitems:Boolean = false;
		public static const development_mode_autojoin_room:String = "PWGosha";
		
		// News
		public static const debug_news:String = ""; // "solitude" "scarecrow" "farm" "helen";
		
		public static const developer_server:String = "127.0.0.1:8184";
		
		//Profile debug
		public static const forceBeta:Boolean = false;
		
		public static const debug_profile:String = "";
		public static const debug_crew_profile:String = "";
		
		public static const disableCookie:Boolean = false;
		
		public static const show_debug_friendrequest:Boolean = false;
		public static const debug_friendrequest:String = "";
		
		public static const show_blacklist_invitation:Boolean = false;
		public static const debug_invitation:String = "";
		public static const termsVersion:int = 2;
		
		//Specefic to physics.		
		public static var physics_ms_per_tick:int = 10
		public static var physics_variable_multiplyer:Number = 7.752;
		
		public static var physics_base_drag:Number = Math.pow(.9981,physics_ms_per_tick) * 1.00016093;
		public static var physics_ice_no_mod_drag:Number = Math.pow(.9993,physics_ms_per_tick) * 1.00016093;
		public static var physics_ice_drag:Number = Math.pow(.9998,physics_ms_per_tick) * 1.00016093;
		//Multiplyer when not applying force by userkeys
		public static var physics_no_modifier_drag:Number = Math.pow(.9900,physics_ms_per_tick) * 1.00016093;
		public static var physics_water_drag:Number = Math.pow(.9950,physics_ms_per_tick) * 1.00016093;
		public static var physics_mud_drag:Number = Math.pow(.9750,physics_ms_per_tick) * 1.00016093;
		public static var physics_lava_drag:Number = Math.pow(.9800,physics_ms_per_tick) * 1.00016093;
		public static var physics_toxic_drag:Number = Math.pow(.9900,physics_ms_per_tick) * 1.00016093;
		public static var physics_jump_height:Number = 26;
		
		public static var physics_gravity:Number = 2;	
		public static var physics_boost:Number = 16;
		public static var physics_water_buoyancy:Number = -.5;
		public static var physics_mud_buoyancy:Number = .4;
		public static var physics_lava_buoyancy:Number = .2;
		public static var physics_toxic_buoyancy:Number = -.4;
		
		public static var physics_queue_length:int = 2;
		
		//Other
		public static var camera_lag:Number = 1/16
		 
		public static var isMobile:Boolean = false;
		
		public static var enableDebugShadow:Boolean = false;
		
		public static var maxwidth:int = 640; //wtf
		public static const minwidth:int = 640;
		public static const width:int = 640;
		public static const height:int = 500;
		public static const maxFrameRate:int = 120;
		public static const lobbyFrameRate:int = 50;
		
		// Lobby Effects
		public static const displayFog:Boolean = false;
		public static const displayBanner:Boolean = false;
		public static const lobbyEffect:String = FallingItemMode.NONE;
		
		// Effects
		public static const effectReset:int = -1;
		public static const effectJump:int = 0;
		public static const effectFly:int = 1;
		public static const effectRun:int = 2;
		public static const effectProtection:int = 3;
		public static const effectCurse:int = 4;
		public static const effectZombie:int = 5;
		// Team = 6
		public static const effectLowGravity:int = 7;
		public static const effectFire:int = 8;
		public static const effectMultijump:int = 9;
		public static const effectGravity:int = 10;
		public static const effectPoison:int = 11;
		
		// Particle Engine
		public static const max_Particles:int = 45;
		
		// Colors
		public static const guest_color:uint = 0xff333333;
		public static const default_color:uint = 0xffeeeeee;
		public static const default_color_dark:uint = 0xffcccccc;
		public static const friend_color:uint = 0xff00ff00;
		public static const friend_color_dark:uint = 0xff00bb00;
		//public static const mod_color:uint = 0xffffbb00;
		public static const admin_color:uint = 0xffffb400;
		public static const moderator_color:uint = 0xffce9ff4;
		public static const developer_color:uint = 0xff3399ff;
		public static const designer_color:uint = 0xffff7733;
		public static const campaign_curator_color:uint = 0xff77ddff;
		public static const composer_color:uint = 0xffff6a5a;
		public static const patron_color_1:uint = 0xffffff99;
		//public static const patron_color_2:uint = 0xffaaffbf;
		
	}
}