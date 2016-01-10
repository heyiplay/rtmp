package
{
	import com.tudou.player.core.rtmp.Rtmp;
	import com.tudou.events.SchedulerEvent;
	import com.tudou.layout.LayoutSprite;
	import com.tudou.player.config.MediaInfo;
	import com.tudou.player.config.MediaData;
	import com.tudou.player.config.StreamType;
	import com.tudou.utils.Global;
	import com.tudou.utils.Scheduler;
	import com.tudou.utils.Utils;
	import flash.display.StageAlign;
	import flash.display.StageQuality;
	import flash.display.StageScaleMode;
	import flash.events.FullScreenEvent;
	import flash.events.StatusEvent;
	import flash.system.Security;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.NetStatusEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	public class TestCoreMoudle extends LayoutSprite
	{
		public function TestCoreMoudle()
		{
			
			//测试 就全放开
			Security.allowDomain("*");
			Security.allowInsecureDomain("*");
			
			super();
			
			this.style = "position:stage; width:100%; height:100%;"
			
		}
		
		override protected function onStage(e:Event =null):void
		{
			super.onStage(e);
			
			initStage();
			
			
			_global.info = new MediaInfo();
			//_global.info.addEventListener(NetStatusEvent.NET_STATUS, onMediaInfoChange);
			
			var rtmp_path:String = "rtmp://xxxx.xxx.xxx/xxx"
			var _i:int = rtmp_path.lastIndexOf("/");
			var mediaData:MediaData = new MediaData();
				mediaData.id = rtmp_path.substring(_i+1);
				mediaData.command = rtmp_path.substring(0, _i);
				mediaData.type = StreamType.RTMP_STATIC_STREAMING;
			_global.info.mediaData = mediaData;
			
			
			create();
			
		}
		
		private function initStage():void
		{
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.quality = StageQuality.HIGH;
			stage.stageFocusRect = false;
			stage.frameRate = 25;
			stage.addEventListener(Event.RESIZE, resize);
			stage.addEventListener(FullScreenEvent.FULL_SCREEN, onFullScreen);
		}
		
		private function resize(evt:Event):void
		{
			applyStyle();
		}
		
		private function onFullScreen(evt:FullScreenEvent):void
		{
			//trace(player.width, player.height, stage.stageWidth, stage.stageHeight)
			if (player) player.resize(player.width, player.height);
		}
		
		private function create():void
		{
			player = new Rtmp();
			player.style = "position:relative; width:100%; height:100%; top:0; left:0;"
			player.addEventListener(NetStatusEvent.NET_STATUS, onNetStatus);
			addChild(player);
			
		}
		
		private function onNetStatus(evt:NetStatusEvent):void
		{
			var code:String = evt.info.code;
			trace("#####################################", Utils.serialize(evt.info))
			if (code == "Player.Is.Ready")
			{
				player.start();
				player.hardwareAccelerate = true;
				//player.rotation = 90;
				//player.proportion = 16/9;
				//player.scale = 0.9;
				//player.pause()
				//Scheduler.setTimeout(3000, function(evt:SchedulerEvent):void { player.play(); } );
			}
			if (code == "Player.Play.Start")
			{
				//..
				player.hardwareAccelerate = true;
				player.rotation = 90;
			}
		}
		
		private var player:Rtmp;
	}
	
	
}