package com.tudou.player.events 
{
	/**
	 * 状态类型
	 * 
	 * @author 8088
	 */
	public class NetStatusEventLevel 
	{
		/**
		 * 状态
		 */
		public static const STATUS:String = "status";
		
		/**
		 * 命令
		 */
		public static const COMMAND:String = "command";
		
		/**
		 * 错误
		 */
		public static const ERROR:String = "error";
		
		/**
		 * 控制条上面提示
		 */
		public static const NOTE:String = "note";
		
		/**
		 * 警告
		 */
		public static const WARNING:String = "warning";
		/**
		 * 视频中用户操作提示
		 */
		public static const HINT:String = "hint";
		
	}

}