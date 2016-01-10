package com.tudou.player.config 
{
	/**
	 * 媒体流类型
	 * 
	 * @author 8088
	 */
	public class StreamType 
	{
		/**
		 * 基于HTTP协议的静态流
		 */
		public static const HTTP_STATIC_STREAMING:String = "hss";
		
		/**
		 * 基于RTMP协议的静态流
		 */
		public static const RTMP_STATIC_STREAMING:String = "rss";
		
		/**
		 * 基于HTTP协议的动态流
		 * - Adobe推荐的流类型，其中借鉴了HLS的优点，并再加以优化，因此我们将此类型定义为最佳流类型。
		 */
		public static const HTTP_DYNAMIC_STREAMING:String = "hds";
		
		/**
		 * 苹果公司定义的基于HTTP协议的动态流
		 * - PC、TV、移动端都可以支持，因此我们将此类型定义为最通用的流类型。
		 */
		public static const HTTP_LIVE_STREAMING:String = "hls";
		
		/**
		 * The LIVE stream type represents a live stream.
		 */
		public static const LIVE:String = "live";

		/**
		 * The RECORDED stream type represents a recorded stream.
		 */
		public static const RECORDED:String = "recorded";

		/**
		 * Video-On-Demand 视频点播
		 */
		public static const VOD:String = "vod";

		/**
		 * The LIVE_OR_RECORDED stream type represents a live or a recorded stream.
		 */
		public static const LIVE_OR_RECORDED:String = "liveOrRecorded";
		
		/**
		 * 直播或点播
		 */
		public static const LIVE_OR_VOD:String = "liveOrVod";
		
		/**
		 * The DVR stream type represents a possibly server side
		 * recording live stream.
		 */
		public static const DVR:String = "dvr";
	}

}