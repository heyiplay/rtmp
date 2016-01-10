package com.tudou.player.config 
{
	import com.tudou.player.events.NetStatusEventLevel;
	import flash.events.EventDispatcher;
	import flash.events.NetStatusEvent;
	import flash.utils.ByteArray;
	import flash.utils.getQualifiedClassName;
	/**
	 * 信息、参数、配置对象基类
	 * 
	 * @author 8088 at 2015/1/13 17:07:22
	 */
	public class BaseInfo extends EventDispatcher 
	{
		
		public function BaseInfo() 
		{
			var qualifiedClassName:String = getQualifiedClassName(this);
			var temp:Array = qualifiedClassName.split("::");
			if (temp.length == 1) className = temp[0];
			else if (temp.length == 2) className = temp[1];
		}
		
		/**
		 * 生成唯一标识ID
		 * 
		 * @return 随机码
		 */
		public static function createRandomId():String {
			
			var specialChars:Array = new Array('8', '9', 'A', 'B');
			
			return createRandomIdentifier(8, 15) + '-' + createRandomIdentifier(4, 15) + '-4' + createRandomIdentifier(3, 15) + '-' + specialChars[randomIntegerWithinRange(0, 3)] + createRandomIdentifier(3, 15) + '-' + createRandomIdentifier(12, 15);
		}
		private static function createRandomIdentifier(length:uint, radix:uint = 61):String {
			var characters:Array = new Array('0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z', 'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z');
			var id:Array  = new Array();
			radix = (radix > 61) ? 61 : radix;
			while (length--) {
					id.push(characters[randomIntegerWithinRange(0, radix)]);
			}
			
			return id.join('');
		}
		private static function randomIntegerWithinRange(min:int, max:int):int {
			return Math.floor(Math.random() * (1 + max - min) + min);
		}
		
		/**
		 * 属性更改
		 * 
		 * @param	propertyName 对应已更改的属性名称
		 */
		protected function dispatchPropertyChangeEvent(propertyName:String):void
		{
			dispatchEvent( new NetStatusEvent
							( NetStatusEvent.NET_STATUS
							, false
							, false
							, 	{ code:className + PROPERTY_CHANGE
								, level:NetStatusEventLevel.STATUS
								, data:{ name:propertyName }
								}
							)
						 );
		}
		
		/**
		 * 属性设置
		 * - 超出了对应支持的范围，上报此错误。
		 * 
		 * @param	propertyName 属性名称
		 * @param	setValue 想要更改的值
		 */
		protected function dispatchPropertySetError(propertyName:String, setValue:*=null):void
		{
			dispatchEvent( new NetStatusEvent
							( NetStatusEvent.NET_STATUS
							, false
							, false
							, 	{ code:className + PROPERTY_SET_ERROR
								, level:NetStatusEventLevel.ERROR
								, data:{ name:propertyName, value:setValue }
								}
							)
						 );
		}
		
		override public function toString():String
		{
			var info:String = "";
			var temp:ByteArray = new ByteArray();
			temp.writeObject(this);
			temp.position = 0;
			var obj:Object = temp.readObject();
			for (var key:* in obj)
			{
				if (info.length > 0) info = info.concat(", ");
				info = info.concat(String(key) + ":" + String(obj[key]));
			}
			return info;
		}
		
		public function toObject():Object
		{
			var _obj:Object = { };
			return _obj;
		}
		
		
		protected var className:String = "BaseInfo";
		private static const PROPERTY_CHANGE:String = ".Property.Change";
		private static const PROPERTY_SET_ERROR:String = ".Property.SetError";
	}

}