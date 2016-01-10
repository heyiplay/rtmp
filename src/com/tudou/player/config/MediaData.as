package com.tudou.player.config 
{
	import com.tudou.utils.ArrayUtil;
	import com.tudou.utils.Utils;
	/**
	 * 当前播放的媒体数据
	 * 
	 * @author 8088
	 */
	public class MediaData extends BaseInfo
	{
		
		public function MediaData() 
		{
			//..
		}
		
		public function equals(obj:Object):Boolean
		{
			if (obj&&this.id == obj["id"]) return true;
			else return false;
		}
		
		/**
		 * 媒体数据的唯一标识
		 */
		public function get id():String
		{
			return _id;
		}
		
		public function set id(value:String):void
		{
			if (_id != value)
			{
				_id = value;
				
				dispatchPropertyChangeEvent("id");
			}
		}
		
		/**
		 * 连接参数
		 */
		public function get command():String
		{
			return _command;
		}
		
		public function set command(value:String):void
		{
			if (_command != value)
			{
				_command = value;
				
				dispatchPropertyChangeEvent("command");
			}
		}
		
		/**
		 * 流类型
		 * - 已支持的流类型
		 * @see com.tudou.player.config.StreamType 
		 */
		public function get type():String
		{
			return _type;
		}
		
		public function set type(value:String):void
		{
			if (_type != value)
			{
				_type = value;
				
				dispatchPropertyChangeEvent("type");
			}
			
		}
		
		/**
		 * 标题
		 */
		public function get title():String
		{
			return _title;
		}
		
		public function set title(value:String):void
		{
			if (_title != value)
			{
				_title = value;
				
				dispatchPropertyChangeEvent("title");
			}
		}
		
		/**
		 * 拥有者/制作者/上传者
		 */
		public function get owner():String
		{
			return _owner;
		}
		
		public function set owner(value:String):void
		{
			if (_owner != value)
			{
				_owner = value;
				
				dispatchPropertyChangeEvent("owner");
			}
		}
		
		/**
		 * 媒体持续时间
		 * - 当前播放媒体的可持续时间，单位为-秒，并精确到小数点后三位。
		 * - 原totalTime 改为媒体文件中通用的duration定义。
		 */
		public function get duration():Number
		{
			return _duration;
		}
		public function set duration(value:Number):void
		{
			if (_duration != value)
			{
				_duration = Number(value.toFixed(3));
				
				dispatchPropertyChangeEvent("duration");
			}
		}
		
		/**
		 * 多语种数据
		 */
		public function get multiLanguage():Array
		{
			return _multiLanguage;
		}
		
		public function set multiLanguage(value:Array):void
		{
			if (!ArrayUtil.equals(_multiLanguage, value))
			{
				_multiLanguage = value;
				
				dispatchPropertyChangeEvent("multiLanguage");
			}
		}
		
		public function isMultiLanguage():Boolean
		{
			return _multiLanguage != null && _multiLanguage.length>1;
		}
		
		/**
		 * 当前语种
		 */
		public function get language():String
		{
			return _language;
		}
		
		public function set language(value:String):void
		{
			if (_language != value)
			{
				_language = value;
				
				dispatchPropertyChangeEvent("language");
			}
		}
		
		/**
		 * 多清晰度
		 */
		public function get multiQuality():Array
		{
			return _multiQuality;
		}
		
		public function set multiQuality(value:Array):void
		{
			if (!ArrayUtil.equals(_multiQuality, value))
			{
				_multiQuality = value;
				
				dispatchPropertyChangeEvent("multiQuality");
			}
		}
		
		/**
		 * 多清晰度时，可能有的各清晰度播放权限
		 * { "480p":"vip", "320p":"vip" }
		 */
		public function get multiQualityRight():Object
		{
			return _multiQualityRight;
		}
		
		public function set multiQualityRight(value:Object):void
		{
			if (!Utils.equalObject(_multiQualityRight, value))
			{
				_multiQualityRight = value;
				
				dispatchPropertyChangeEvent("multiQualityRight");
			}
		}
		
		public function isMultiQuality():Boolean
		{
			return _multiQuality != null && _multiQuality.length>1;
		}
		
		/**
		 * 当前清晰度
		 */
		public function get quality():String
		{
			return _quality;
		}
		
		public function set quality(value:String):void
		{
			if (_quality != value)
			{
				_quality = value;
					
				dispatchPropertyChangeEvent("quality");
			}
		}
		
		/**
		 * 当前码率
		 */
		public function get bitrate():Number
		{
			return _bitrate;
		}
		
		public function set bitrate(value:Number):void
		{
			if (_bitrate != value)
			{
				_bitrate = value;
				
				dispatchPropertyChangeEvent("bitrate");
			}
		}
		
		/**
		 * 全景
		 */
		public function get panorama():int
		{
			return _panorama;
		}
		
		public function set panorama(value:int):void
		{
			if (_panorama != value)
			{
				_panorama = value;
				dispatchPropertyChangeEvent("panorama");
			}
		}
		
		public function isPanorama():Boolean
		{
			return _panorama>0;
		}
		
		/**
		 * 缩略图
		 */
		public function get thumbnail():String
		{
			return _thumbnail;
		}
		
		public function set thumbnail(value:String):void
		{
			if (_thumbnail != value)
			{
				_thumbnail = value;
				
				dispatchPropertyChangeEvent("thumbnail");
			}
		}
		
		/**
		 * 封面图
		 */
		public function get cover():String
		{
			return _cover;
		}
		
		public function set cover(value:String):void
		{
			if (_cover != value)
			{
				_cover = value;
				
				dispatchPropertyChangeEvent("cover");
			}
		}
		
		
		// Internals..
		//
		
		override public function toObject():Object
		{
			var _obj:Object = {
				id:_id,
				command:_command,
				type:_type,
				title:_title,
				owner:_owner,
				duration:_duration,
				language:_language,
				multiLanguage:_multiLanguage,
				multiQualityRight:_multiQualityRight,
				quality:_quality,
				multiQuality:_multiQuality,
				bitrate:_bitrate,
				panorama:_panorama,
				thumbnail:_thumbnail,
				cover:_cover
			};
			return _obj;
		}
		
		
		
		private var _id:String;
		private var _command:String;
		private var _type:String;
		private var _title:String;
		private var _owner:String;
		private var _duration:Number = 0.0;
		private var _language:String;
		private var _multiLanguage:Array;
		private var _multiQualityRight:Object;
		private var _quality:String;
		private var _multiQuality:Array;
		private var _bitrate:Number;
		private var _panorama:int;
		private var _thumbnail:String;
		private var _cover:String;
		
	}

}