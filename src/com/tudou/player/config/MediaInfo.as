package com.tudou.player.config 
{
	import com.tudou.utils.Utils;
	import flash.events.EventDispatcher;
	import flash.events.NetStatusEvent;
	import flash.utils.ByteArray;
	import flash.utils.getTimer;
	/**
	 * 媒体信息
	 * - TODO:
		 * 封装媒体相关信息、参数、以及配置 并提供默认值
		 * 当有元素变化时 抛出事件
		 * 当有元素异常时 抛出异常
	* - NOTE:
		 * 初始化时虽然会抛出属性变化事件，但是播放器并没初始化完成，不会受影响
	 * @author 8088 at 2014/5/12 17:47:28
	 */
	public class MediaInfo extends BaseInfo 
	{
		
		public function MediaInfo() 
		{
			initialize();
		}
		
		/**
		 * 初始化各参数为默认值
		 */
		public function initialize():void
		{
			_cdnType = CdnType.TUDOU_VOD;
			_mediaId = null;
			_mediaType = MediaType.VIDEO;
			_mediaFormat = MediaFormat.FLV;
			_mediaData = null;
			_mediaListData = null;
			_mediaProperty = {};
			_channelId = null;
			//...
		}
		
		/**
		 * CDN类型
		 * 
		 * @see com.tudou.player.config.CdnType 已支持的CDN类型
		 */
		public function get cdnType():String
		{
			return _cdnType;
		}
		
		public function set cdnType(value:String):void
		{
			if (value && _cdnType != value)
			{
				_cdnType = value.toUpperCase();
				
				dispatchPropertyChangeEvent("cdnType");
			}
		}
		
		/**
		 * 媒体标识
		 * - 当前播放的媒体唯一标识，可以为null || ""。
		 * - MediaId 的变化 意味着 将要重新初始化所有数据。
		 */
		public function get mediaId():String
		{
			return _mediaId;
		}
		
		public function set mediaId(value:String):void
		{
			if (_mediaId != value)
			{
				_mediaId = value;
				
				dispatchPropertyChangeEvent("mediaId");
			}
		}
		
		/**
		 * 媒体类型
		 * 
		 * @see com.tudou.player.config.MediaType 支持的媒体类型
		 */
		public function get mediaType():String
		{
			return _mediaType;
		}
		
		public function set mediaType(value:String):void
		{
			if (_mediaType != value)
			{
				_mediaType = value;
				
				dispatchPropertyChangeEvent("mediaType");
			}
		}
		
		/**
		 * 媒体格式
		 * 
		 * @see com.tudou.player.config.MediaFormat 支持的媒体类型
		 */
		public function get mediaFormat():String
		{
			return _mediaFormat;
		}
		
		public function set mediaFormat(value:String):void
		{
			if (_mediaFormat != value)
			{
				_mediaFormat = value;
				
				dispatchPropertyChangeEvent("mediaFormat");
			}
		}
		
		/**
		 * 当前将要/正在播放的媒体数据。
		 */
		public function get mediaData():MediaData
		{
			return _mediaData;
		}
		
		public function set mediaData(value:MediaData):void
		{
			if (!value.equals(_mediaData))
			{
				if (_mediaData != null) {
					_mediaData.removeEventListener(NetStatusEvent.NET_STATUS, onMediaDataChange);
					_mediaData = null;
				}
				
				_mediaData = value;
				_mediaData.addEventListener(NetStatusEvent.NET_STATUS, onMediaDataChange);
				
				dispatchPropertyChangeEvent("mediaData");
			}
		}
		
		/**
		 * 媒体列表信息，包含一组需要播放的数据。
		 * - 支持土豆各种类型的列表播放：
		 * - 豆单、栏目、剧集。。
		 */
		public function get mediaListData():MediaListData
		{
			return _mediaListData;
		}
		
		public function set mediaListData(value:MediaListData):void
		{
			if (!value.equals(_mediaListData))
			{
				_mediaListData = value;
				
				dispatchPropertyChangeEvent("mediaListData");
			}
		}
		
		public function isListMedia():Boolean
		{
			return _mediaListData != null;
		}
		
		/**
		 * 播放通用属性
		 */
		public function get mediaProperty():Object
		{
			return _mediaProperty;
		}
		
		public function set mediaProperty(value:Object):void
		{
			if (!Utils.equalObject(_mediaProperty, value))
			{
				_mediaProperty = value;
				
				dispatchPropertyChangeEvent("mediaProperty");
			}
		}
		
		/**
		 * 频道ID
		 * - 保留参数
		 */
		public function get channelId():String
		{
			return _channelId;
		}
		
		public function set channelId(value:String):void
		{
			if (value && _channelId != value)
			{
				_channelId = value;
				
				dispatchPropertyChangeEvent("channelId");
			}
		}
		
		/**
		 * 流地址
		 * - 用于直接播放的流地址
		 */
		public function get streamUrl():String
		{
			return _streamUrl;
		}
		
		public function set streamUrl(value:String):void
		{
			if (value && _streamUrl != value)
			{
				_streamUrl = value;
				
				dispatchPropertyChangeEvent("streamUrl");
			}
		}
		
		override public function toObject():Object
		{
			var _obj:Object = {
				cdnType:_cdnType,
				mediaId:_mediaId,
				mediaType:_mediaType,
				mediaFormat:_mediaFormat,
				mediaData:_mediaData.toObject(),
				mediaListData:_mediaListData.toObject(),
				mediaProperty:_mediaProperty,
				channelId:_channelId,
				streamUrl:_streamUrl
			};
			return _obj;
		}
		
		
		// Internals..
		//
		
		private function onMediaDataChange(evt:NetStatusEvent):void
		{
			dispatchPropertyChangeEvent("mediaData."+evt.info.data.name);
		}
		
		private var _cdnType:String;
		
		private var _mediaId:String;
		private var _mediaType:String;
		private var _mediaFormat:String;
		private var _mediaData:MediaData;
		private var _mediaListData:MediaListData;
		private var _mediaProperty:Object;
		private var _channelId:String;
		
		private var _streamUrl:String;
	}

}