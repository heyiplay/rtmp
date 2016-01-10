package com.tudou.player.config 
{
	/**
	 * 媒体列表信息
	 * - 包含一组需要播放的数据
	 * 
	 * @author 8088 at 2014/6/30 10:13:32
	 */
	public class MediaListData 
	{
		
		public function MediaListData() 
		{
			_id = null;
			_type = null;
			_data = null;
		}
		
		public function equals(obj:Object):Boolean {
			
			if (obj as MediaListData)
			{
				if ( obj["id"] == this.id
				&& obj["type"] == this.type
				//&& 还有值判断
				)
				{
					return true;
				}
			}
			return false	
		}
		
		public function get id():String
		{
			return _id;
		}
		
		public function set id(value:String):void
		{
			_id = value;
		}
		
		public function get type():String
		{
			return _type;
		}
		
		public function set type(value:String):void
		{
			_type = value;
		}
		
		public function get data():Object
		{
			return _data;
		}
		
		public function set data(value:Object):void
		{
			_data = value;
		}
		
		
		// Internals..
		//
		public function toObject():Object
		{
			var _obj:Object = {
				id:_id,
				type:_type,
				data:_data
			};
			return _obj;
		}
		
		
		private var _id:String;
		private var _type:String;
		private var _data:Object;
	}

}