package com.tudou.player.core.rtmp 
{
	import com.tudou.events.SchedulerEvent;
	import com.tudou.layout.LayoutSprite;
	import com.tudou.net.SWFLoader;
	import com.tudou.player.events.StageVideoStatusEvent;
	import com.tudou.player.core.MediaPlayStatus;
	import com.tudou.player.events.NetStatusEventCode;
	import com.tudou.player.events.NetStatusEventLevel;
	import com.tudou.player.interfaces.IMediaPlayer;
	import com.tudou.player.utils.ProxyNetClient;
	import com.tudou.player.utils.StageProxy;
	import com.tudou.utils.Debug;
	import com.tudou.utils.Scheduler;
	import com.tudou.utils.Utils;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Shape;
	import flash.display.StageAlign;
	import flash.display.StageDisplayState;
	import flash.display.StageQuality;
	import flash.display.StageScaleMode;
	import flash.events.AsyncErrorEvent;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.NetStatusEvent;
	import flash.events.SecurityErrorEvent;
	import flash.events.StageVideoEvent;
	import flash.events.UncaughtErrorEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.media.SoundTransform;
	import flash.media.Video;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	import flash.system.ApplicationDomain;
	import flash.system.Security;
	import flash.utils.getTimer;
	/**
	 * RTMP协议流播放核心
	 * 
	 * @author 8088
	 */
	public class Rtmp extends LayoutSprite implements IMediaPlayer
	{
		private var nc:NetConnection;
		private var ns:NetStream;
		private var vi:Video;
		private var sv:Object;
		
		private var _stage:StageProxy;
		private var _client:ProxyNetClient;
		private var stageVideoTimeout:Scheduler;
		private var metaDataScheduler:Scheduler;
		private var videoRenderStatus:String;
		private var stageVideoRenderStatus:String;
		private var stageVideoTimeoutMillis:Number = 2100;
		
		public function Rtmp()
		{
			Security.allowDomain("*");
			Security.allowInsecureDomain("*");
				
			super();
			
			style = default_style;
			
			_state = MediaPlayStatus.NOT_START;
			
			this.id = "Rtmp";
			
			_stage = new StageProxy(this);
			_client = new ProxyNetClient(this);
			stageVideoTimeout = Scheduler.setTimeout(stageVideoTimeoutMillis, checkStageVideoRenderStatus);
			stageVideoTimeout.stop();
			
			vi = new Video();
			vi.addEventListener(StageVideoEvent.RENDER_STATE, onVideoEvent);
			
		}
		
		override protected function onStage(evt:Event = null):void
		{
			super.onStage(evt);
			
			initialize();
			
		}
		
		override public function setSize():void
		{
			super.setSize();
			
			resize(this.width, this.height);
		}
		
		public function getNewNetStream():NetStream
        {
            return new NetStream(nc);
        }
		
		public function start():void 
		{
			//启动播放...
			
			setPlayerState(MediaPlayStatus.START);
		}
		
		public function play(...rest):void 
		{
			if (rest[0]==undefined || rest[0] =="")
			{
				if (_state == MediaPlayStatus.PLAYING) return;
				
				if (_state == MediaPlayStatus.PAUSED)
				{
					resume();
				}
				else if (_state == MediaPlayStatus.START) {
					if (ns)
					{
						ns.play(_global.info.mediaData.id);
					}
				}
			}
			else {
				if(ns) ns.play(rest[0]);
			}
			setPlayerState(MediaPlayStatus.PLAYING);
		}
		
		public function replay():void
		{
			// ignore..
		}
		
		public function pause():void 
		{
			if (ns) ns.pause();
			
			setPlayerState(MediaPlayStatus.PAUSED);
		}
		
		public function resume():void 
		{
			if (ns) ns.resume();
			
			setPlayerState(MediaPlayStatus.PLAYING);
		}
		
		public function seek(time:Number):void 
		{
			return;
		}
		
		public function stop():void 
		{
			_first_buffer_full = true;
			
			disconnectStream();
			
            setPlayerState(MediaPlayStatus.NOT_START);
		}
		
		public function end():void 
		{
			pause();
			
			setPlayerState(MediaPlayStatus.PLAY_END);
		}
		
		public function destroy():void 
		{
			closeNetConnection(nc);
			stop();
		}
		
		public function getLoadedFraction():Number 
		{
			return NaN;
		}
		
		public function getDefaultMediaSurface():DisplayObject 
		{
			if (vi) return vi;
			else return this;
		}
		
		public function resize(w:Number, h:Number):void 
		{
			resizeVideo(this.width, this.height);
		}
		
		public function resetStream(connect:Boolean = true):void 
		{
			disconnectStream();
            closeNetConnection(nc);
            
			nc = new NetConnection();
			nc.client = this._client;
			nc.addEventListener(NetStatusEvent.NET_STATUS, onNetStatus);
			nc.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onError);
			nc.addEventListener(AsyncErrorEvent.ASYNC_ERROR, onError);
			nc.addEventListener(IOErrorEvent.IO_ERROR, onError);
			
			if (connect&&_global.info&&_global.info.mediaData)
			{
				nc.connect(_global.info.mediaData.command);
			}
		}
		
		public function unrecoverableError(err:String = null):void 
		{
			
		}
		
		public function get volume():Number 
		{
			return _volume;
		}
		
		public function set volume(value:Number):void 
		{
			_volume = value;
			
			if (!isNaN(value) && ns)
			{
				_volume = volume;
				ns.soundTransform = new SoundTransform(_volume);
			}
			
		}
		
		/**
		 * 获取清晰度
		 */
		public function get quality():String 
		{
			return null;
		}
		
		public function set quality(value:String):void
		{
			return;
		}
		
		public function get multiQuality():Array
		{
			return null;
		}
		
		public function get language():String 
		{
			return null;
		}
		
		public function set language(value:String):void
		{
			return;
		}
		
		public function get multiLanguage():Array
		{
			return null;
		}
		
		public function get time():Number 
		{
			return 0.0;
		}
		
		public function get duration():Number 
		{
			return 0.0;
		}
		
		public function get bytesLoaded():Number 
		{
			return 0.0;
		}
		
		public function get bytesTotal():Number 
		{
			return 0.0;
		}
		
		public function get state():String 
		{
			return _state;
		}
		
		public function isStageVideoAvailable():Boolean 
		{
			return _stage.stageVideoAvailable;
		}
		
		public function isTagStreaming():Boolean 
		{
			return false;
		}
		
		public function get stream():NetStream 
		{
			return null;
		}
		
		public function captureFrame():BitmapData 
		{
			return null;
		}
		
		public function getFPS():Number 
		{
			return 0.0
		}
		
		override public function get rotation():Number
		{
			return _rotation;
		}
		
		override public function set rotation(value:Number):void
		{
			if (value % 90 != 0) return;
			
			_rotation = value;
			
			if (vi) vi.rotation = _rotation;
			
			resize(this.width, this.height);
		}
		
		public function get scale():Number
		{
			return _scale;
		}
		
		public function set scale(value:Number):void
		{
			_scale = value;
			
			resize(this.width, this.height);
		}
		
		public function get proportion():Number
		{
			return _proportion;
		}
		
		public function set proportion(value:Number):void
		{
			_proportion = value;
			
			resize(this.width, this.height);
		}
		
		public function onMetaData(info:Object):void
		{
			//log("get metadata: " + Utils.serialize(info));
			
			info.bytesLoaded = this.bytesLoaded;
            info.bytesTotal = this.bytesTotal;
			
            var v:* = sv || vi;
            if (ns)
            {
                if (info.width == undefined)
                {
                    info.width = v.videoWidth;
                }
                if (info.height == undefined)
                {
                    info.height = v.videoHeight;
                }
            }
            if (info.width == 0 || info.height == 0)
            {
                if (!metaDataScheduler)
                {
                    metaDataScheduler = Scheduler.setInterval(0, onPollVideoForDimensions);
                }
            }
			else {
				
				if (isNaN(proportion) && info.width && info.height) proportion = info.width / info.height;
				
				//_global.info.applyMetaData(info);
				
				dispatchEvent( new NetStatusEvent
						( NetStatusEvent.NET_STATUS
						, false
						, false
						, { code:NetStatusEventCode.PLAYER_GET_META_DATA, level:NetStatusEventLevel.STATUS, data:{metadata:info, id:this.id} }
						)
					);
			}
        }
		
		/**
		 * 硬件加速
		 */
		public function get hardwareAccelerate():Boolean
		{
			return _hardwareAccelerate;
		}
		public function set hardwareAccelerate(value:Boolean):void
		{
			_hardwareAccelerate = value;
			
			attachNetStream(true);
		}
		
		
		// Instenals..
		//
		private function initialize():void
        {
			mouseChildren = false;
			tabChildren = false;
			
			_stage.addEventListener(StageVideoStatusEvent.AVAILABLE, onStageVideoStatusEvent);
            _stage.addEventListener(StageVideoStatusEvent.UNAVAILABLE, onStageVideoStatusEvent);
			
			resetStream();
			
			/**
			 * 通知外部，核心初始化完毕
			 */
			dispatchEvent( new NetStatusEvent
				( NetStatusEvent.NET_STATUS
				, false
				, false
				, { code:NetStatusEventCode.PLAYER_IS_READY, level:NetStatusEventLevel.STATUS, data:{id:this.id, version:"2015-11-06 20:54:34"} }
				)
			);
        }
		
		private function onPollVideoForDimensions(evt:Event):void
        {
            var v:* = sv || vi;
            if (_global.info && _global.info.metaData && v.videoWidth > 0)
            {
                //_global.info.applyMetaData({width:v.videoWidth, height:v.videoHeight});
				
				if (isNaN(proportion)) proportion = v.videoWidth / v.videoHeight;
				
                metaDataScheduler.stop();
				
				dispatchEvent( new NetStatusEvent
						( NetStatusEvent.NET_STATUS
						, false
						, false
						, { code:NetStatusEventCode.PLAYER_GET_META_DATA, level:NetStatusEventLevel.STATUS, data:{metadata:{width:v.videoWidth, height:v.videoHeight}, id:this.id} }
						)
					);
            }
        }
		
		private function onStageVideoStatusEvent(evt:Event):void
        {
			attachNetStream();
        }
		
		private function disconnectStream():void
        {
            if (ns)
            {
                ns.soundTransform.volume = 0;
                ns.removeEventListener(NetStatusEvent.NET_STATUS, onNetStreamStatus);
                ns.removeEventListener(AsyncErrorEvent.ASYNC_ERROR, onError);
                ns.removeEventListener(IOErrorEvent.IO_ERROR, onError);
                ns.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, onError);
                ns.close();
                if (ns.hasOwnProperty("dispose"))
                {
                    Object(ns).dispose();
                }
                ns.client = {};
                ns = null;
            }
            if (metaDataScheduler && metaDataScheduler.isRunning())
            {
                metaDataScheduler.stop();
            }
        }
		
		private function closeNetConnection(nc:NetConnection):void
        {
            if (nc)
            {
                nc.removeEventListener(NetStatusEvent.NET_STATUS, onNetStatus);
                nc.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, onError);
                nc.removeEventListener(AsyncErrorEvent.ASYNC_ERROR, onError);
                nc.removeEventListener(IOErrorEvent.IO_ERROR, onError);
                nc.close();
                nc.client = {};
            }
        }
		
		private function connectStream():void
        {
            disconnectStream();
			
            ns = getNewNetStream();
            ns.addEventListener(NetStatusEvent.NET_STATUS, onNetStreamStatus);
            ns.addEventListener(AsyncErrorEvent.ASYNC_ERROR, onError);
            ns.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onError);
            ns.addEventListener(IOErrorEvent.IO_ERROR, onError);
            if(_global.config) ns.bufferTime = _global.config.bufferTime;
            ns.checkPolicyFile = true;
			ns.client = this._client;
            if (!isNaN(volume))
            {
                var v:Number = volume;
                ns.soundTransform = new SoundTransform(v);
            }
			ns.play(_global.info.mediaData.id);
            attachNetStream(true);
        }
		
		private function attachNetStream(b:Boolean = false):void
        {
			var sva:Boolean = isStageVideoAvailable();
            
            if (!b && sva == Boolean(sv)) return;
			if (sva&&hardwareAccelerate)
            {
                if (contains(vi))
                {
                    removeChild(vi);
                }
                if (sv == null)
                {
                    sv = _stage.stageVideos[0];
                    sv.addEventListener(StageVideoEvent.RENDER_STATE, onStageVideoEvent);
                }
				
				videoRenderStatus = null;
                stageVideoRenderStatus = null;
                sv.attachNetStream(ns);
                if (state == MediaPlayStatus.PLAYING)
                {
                    stageVideoTimeout.restart();
                }
            }
            else {
                if (sv)
                {
                    sv.removeEventListener(StageVideoEvent.RENDER_STATE, onStageVideoEvent);
                }
                sv = null;
				videoRenderStatus = null;
                stageVideoRenderStatus = null;
                stageVideoTimeout.stop();
                vi.attachNetStream(ns);
				addChild(vi);
            }
			
            resizeVideo(this.width, this.height);
			
        }
		
		private function onVideoEvent(evt:Event):void
        {
            videoRenderStatus = Object(evt).status;
			attachNetStream();
        }
		
		private function onStageVideoEvent(evt:Event):void
        {
            stageVideoRenderStatus = Object(evt).status;
			attachNetStream();
        }
		
		/**
		 * 处理NC状态
		 * 
		 * @param	evt
		 */
		private function onNetStatus(evt:NetStatusEvent):void
		{
			switch(evt.info.code)
			{
				case "NetConnection.Connect.Success":
					connectStream();
					break;
				case "NetConnection.Connect.Rejected":
					dispatchError("1000");
					break;
				case "NetConnection.Connect.Closed":
					dispatchError("1001");
					break;
			}
			
			evt.info.data = { id:this.id };
        }
		
		/**
		 * 处理NS状态
		 * 
		 * @param	evt
		 */
		private function onNetStreamStatus(evt:NetStatusEvent):void
		{
			var _state:String;
			switch(evt.info.code)
			{
				case "NetStream.Play.Start":
					break;
				case "NetStream.Play.StreamNotFound":
                case "NetStream.Play.FileStructureInvalid":
                case "NetStream.Play.NoSupportedTrackFound":
                    dispatchError("2000");
					break;
				case "NetStream.Play.Complete":
					/*onProgress();*/
                    end();
					break;
				case "NetStream.Play.Stop":
                    
					break;
				case "NetStream.Buffer.Full":
					if (state == MediaPlayStatus.PAUSED || state == MediaPlayStatus.PAUSED_BUFFERING)
					{
						if(ns) ns.pause();
					}
					dispatchBufferFullEvent();
					break;
				case "NetStream.Buffer.Empty":
					dispatchBufferEmptyEvent();
					break;
				case "NetStream.Pause.Notify":
					
					break;
				//..
			}
			evt.info.data = { id:this.id };
			dispatchEvent(evt);
		}
		
		private function dispatchBufferFullEvent():void
		{
			if (_first_buffer_full)
			{
				dispatchEvent( new NetStatusEvent
					( NetStatusEvent.NET_STATUS
					, false
					, false
					, { code:NetStatusEventCode.PLAYER_PLAY_START, level:NetStatusEventLevel.STATUS, data:{id:this.id} }
					)
				);
				
				_first_buffer_full = false;
			}
			else {
				dispatchEvent( new NetStatusEvent
					( NetStatusEvent.NET_STATUS
					, false
					, false
					, { code:NetStatusEventCode.PLAYER_BUFFER_FULL, level:NetStatusEventLevel.STATUS, data:{id:this.id} }
					)
				);
			}
		}
		
		private function dispatchBufferEmptyEvent():void
		{
			dispatchEvent( new NetStatusEvent
				( NetStatusEvent.NET_STATUS
				, false
				, false
				, { code:NetStatusEventCode.PLAYER_BUFFER_EMPTY, level:NetStatusEventLevel.STATUS, data:{id:this.id} }
				)
			);
		}
		
		private function resizeVideo(w:Number, h:Number):void
		{
			var rec:Rectangle = new Rectangle(0, 0, w, h);
			var pw:Number = w;
			var ph:Number = h;
			var _p:Number = 16 / 9;
			if (!isNaN(_proportion)) _p = _proportion;
			
			var _a:Number = rotation % 180;
			if (_a != 0&&!sv)
			{
				pw = h;
				ph = w;
			}
			else {
				pw = w;
				ph = h;
			}
			
			if (_p > pw / ph)
			{
				rec.width = pw;
				rec.height = pw / _p;
            }
			else {
				rec.height = ph;
				rec.width = ph * _p;
            }
			
			if ((rotation == 90 || rotation == -270)&&!sv)
			{ 
				rec.x = ph - ((ph - rec.height * scale) * .5);
				rec.y = 0 + ((pw - rec.width * scale) * .5);
			}
			else if ((rotation == 180 || rotation == -180)&&!sv) {
				rec.x = rec.width * scale + ((pw - rec.width * scale) * .5);
				rec.y = rec.height * scale + ((ph - rec.height * scale) * .5);
			}
			else if ((rotation == 270 || rotation == -90)&&!sv) {
				rec.x = 0 + ((ph - rec.height * scale) * .5);
				rec.y = pw - ((pw - rec.width * scale) * .5);
			}
			else {
				rec.x = 0 + ((pw - rec.width * scale) * .5);
				rec.y = 0 + ((ph - rec.height * scale) * .5);
			}
			
            if (sv)
            {
                if (rec.width * scale > 8191)
                {
                    rec.x = rec.x + (rec.width * scale - 8191) / 2;
                    rec.width = 8191;
                }
                if (rec.height * scale > 8191)
                {
                    rec.y = rec.y + (rec.height * scale - 8191) / 2;
                    rec.height = 8191;
                }
				var point:Point = localToGlobal(new Point(rec.x, rec.y));
                rec.x = Math.max(-8192, Math.min(point.x, 8191));
                rec.y = Math.max( -8192, Math.min(point.y, 8191));
				rec.width = rec.width * scale;
				rec.height = rec.height * scale;
                sv.viewPort = rec;
            }
            else if (vi) {
				vi.rotation = 0;
				vi.width = rec.width * scale;
				vi.height = rec.height * scale;
				vi.rotation = _rotation;
				vi.x = rec.x;
				vi.y = rec.y;
                vi.smoothing = vi.width != vi.videoWidth || vi.height != vi.videoHeight;
            }
		}
		
		private function clearVideo():void
		{
            if (contains(vi))
			{
                removeChild(vi);
				vi.removeEventListener(StageVideoEvent.RENDER_STATE, onVideoEvent);
            }
			
            vi = new Video();
            vi.addEventListener(StageVideoEvent.RENDER_STATE, onVideoEvent);
            
            if (sv)
			{
                sv.viewPort = new Rectangle(0, 0, 0, 0);
            }
        }
		
		private function checkStageVideoRenderStatus(event:Event):void
        {
            if (sv && !stageVideoRenderStatus)
            {
                stageVideoRenderStatus = "unavailable";
                attachNetStream();
            }
        }
		
		private function onError(evt:Event):void
        {
			disconnectStream();
			
            setPlayerState(MediaPlayStatus.ERROR);
        }
		
		private function setPlayerState(state:String):void
        {
			if (_state == state) return;
			
			_state = state;
			
            //mark:在此统一修改，因状态而衍生的周边属性、方法控制
			//...
			
        }
		
		/**
		 * 播放错误：
		 * 1000:服务器拒绝连接
		 * 1001:服务器连接关闭，无法链接
		 * 2000:播放流失败
		 * @param	code为错误码, desc为错误描述
		 */
		private function dispatchError(code:String, desc:String=null):void
		{
			var error_code:String = "R" + code;
			var error_desc:String = desc || "对不起，该直播暂时无法播放，\n请刷新页面重试。";
			
			dispatchEvent(new NetStatusEvent
				( NetStatusEvent.NET_STATUS
				, false
				, false
				, 	{ code:NetStatusEventCode.PLAYER_PLAY_FAILED
					, level:NetStatusEventLevel.ERROR
					, data: { code:error_code, desc:error_desc, id:this.id }
					}
				)
			);
		}
		
		
		internal function log(...args):void
		{
			Debug.log(args, 0x33B5E5, "RTMP");
		}
		
		
		private var _state:String;
		private var _volume:Number = 1;
		private var _duration:Number;
		private var _first_buffer_full:Boolean = true;
		
		private var fuxiao:*;
		private var _rotation:Number = 0.0;
		private var _scale:Number = 1.0;
		private var _proportion:Number;
		private var _hardwareAccelerate:Boolean;
		
		private var default_style:String = "position:stage; width:100%; height:100%;";
	}

}