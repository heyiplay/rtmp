package com.tudou.player.core 
{
	import com.tudou.player.events.NetStatusEventCode;
	import com.tudou.player.events.NetStatusEventLevel;
	import com.tudou.player.interfaces.IMediaPlayer;
	import com.tudou.player.interfaces.IMediaPlayerStatus;
	import flash.events.EventDispatcher;
	import flash.events.NetStatusEvent;
	/**
	 * 媒体播放核心状态，对外部模块为核心的抽象引用
	 * 
	 * @author 8088 at 2014/7/18 14:26:55
	 */
	public class MediaPlayStatus extends EventDispatcher implements IMediaPlayerStatus
	{
		
		public static const NOT_START:String = "notstart";
		
		public static const START:String = "start";
		
		public static const PLAY_START:String = "playstart";
		
		public static const PLAYING:String = "playing";
		
		public static const BUFFERING:String = "buffering";
		
		public static const SEEKING:String = "seeking";
		
		public static const PAUSED:String = "paused";
		
		public static const PAUSED_BUFFERING:String = "pausedbuffering";
		
		public static const PAUSED_SEEKING:String = "pausedseeking";
		
		public static const ERROR:String = "error";
		
		public static const PLAY_END:String = "playend";
		
		public function MediaPlayStatus(core:IMediaPlayer) 
		{
			_core = core;
			
			initialize();
		}
		
		/**
		 * 初始化状态
		 */
		public function initialize():void
		{
			_state = NOT_START;
		}
		
		public function onNetStatus(evt:NetStatusEvent):void
		{
			switch(evt.info.code)
			{
                case NetStatusEventCode.PLAYER_PLAY_FAILED:
				case "NetConnection.Connect.Closed":
				case "NetStream.Play.StreamNotFound":
                case "NetStream.Play.FileStructureInvalid":
                case "NetStream.Play.NoSupportedTrackFound":
                    state = ERROR;
                    break;
                case NetStatusEventCode.PLAYER_PLAY_START:
				case NetStatusEventCode.PLAYER_GET_META_DATA:
					if (state == BUFFERING || state == SEEKING || state == START)
					{
						state = PLAY_START;
					}
					else if (state == PAUSED || state == PAUSED_BUFFERING || state == PAUSED_SEEKING) {
						state = PAUSED;
					}
					else {
						state = PLAYING;
					}
					break;
				case "NetStream.Play.Start":
					if (state == SEEKING || state == START)
					{
						state = BUFFERING;
					}
					else if (state == PAUSED || state == PAUSED_SEEKING) {
						state = PAUSED_BUFFERING;
					}
					break;
				case "NetStream.Play.Stop":
					if (state == PAUSED_BUFFERING) state = PAUSED;
					break;
                case NetStatusEventCode.PLAYER_BUFFER_FULL:
				case "NetStream.Buffer.Full":
					if (state == BUFFERING || state == SEEKING || state == START || state == PLAY_START)
					{
						state = PLAYING;
					}
					else if (state == PAUSED || state == PAUSED_BUFFERING || state == PAUSED_SEEKING) {
						state = PAUSED;
					}
					break;
                case NetStatusEventCode.PLAYER_BUFFER_EMPTY:
				case "NetStream.Buffer.Empty":
					
                    if (state == PLAYING || state == START || state == PLAY_START)
					{
						state = BUFFERING;
					}
                    break;
				case "NetStream.Pause.Notify":
					if (state == PAUSED_BUFFERING)
					{
						state = PAUSED;
					}
                    break;
				case "NetStream.Seek.Notify":
                    if (state == PAUSED_SEEKING)
					{
						state = PAUSED;
					}
                    break;
				default:
                    break;
			}
			
		}
		
		public function get state():String
		{
			return _state;
		}
		
		public function set state(value:String):void
		{
			if (_state != value)
			{
				_state = value;
				
				dispatchStateChangeEvent();
			}
		}
		
		public function set core(value:IMediaPlayer):void
		{
			if (_core != value)
			{
				_core = value;
				
				dispatchStateChangeEvent();
			}
		}
		
		/**
		 * 获取当前播放音量
		 * 
		 * @return
		 */
		public function getVolume():Number
		{
			return _core?_core.volume:0.0;
		}
		
		/**
		 * 获取当前播放时间
		 * 
		 * @return
		 */
		public function getCurrentTime():Number
		{
			return (_core&&state!=NOT_START)?_core.time:0.0;
		}
		
		/**
		 * 获取当前播放媒体的持续时间
		 * 
		 * @return
		 */
		public function getDuration():Number
		{
			return (_core&&state!=NOT_START)?_core.duration:0.0;
		}
		
		/**
		 * 获取当前播放媒体的载入字节数
		 * 
		 * @return
		 */
		public function getBytesLoaded():Number
		{
			return (_core&&state!=NOT_START)?_core.bytesLoaded:0.0;
		}
		
		/**
		 * 获取当前播放媒体的总字节数
		 * 
		 * @return
		 */
		public function getBytesTotal():Number
		{
			return (_core&&state!=NOT_START)?_core.bytesTotal:0.0;
		}
		
		/**
		 * 获取当前播放媒体的加载进度
		 * 
		 * @return
		 */
		public function getLoadedFraction():Number
		{
			return (_core&&state!=NOT_START)?_core.getLoadedFraction():0.0;
		}
		
		
		// Internals..
		//
		/**
		 * 状态变化
		 * 
		 * @param	state 当前的播放状态
		 */
		private function dispatchStateChangeEvent():void
		{
			dispatchEvent( new NetStatusEvent
							( NetStatusEvent.NET_STATUS
							, false
							, false
							, 	{ code:NetStatusEventCode.PLAYER_STATE_CHANGE
								, level:NetStatusEventLevel.STATUS
								, data:{state:_state}
								}
							)
						 );
		}
		
		private var _state:String;
		private var _core:IMediaPlayer;
		
	}

}