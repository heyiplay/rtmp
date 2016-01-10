package com.tudou.player.interfaces
{
	import flash.events.IEventDispatcher;
	
	/**
	 * 媒体播放器接口
	 */
	public interface IMediaPlayerStatus extends IEventDispatcher
	{
		/**
		 * 初始化状态
		 */
		function initialize():void;
		
		/**
		 * 获取/设置状态
		 */
		function get state():String; function set state(value:String):void;
	}
	
}