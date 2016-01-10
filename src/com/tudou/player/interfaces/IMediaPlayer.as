package com.tudou.player.interfaces
{
    import flash.display.*;
    import flash.events.*;
    import flash.geom.*;
    import flash.net.*;
	/**
	 * 媒体播放器接口
	 * 
	 * @author 8088
	 */
    public interface IMediaPlayer extends IEventDispatcher
    {
		
		/**
		 * 启动
		 */
        function start():void;
		
		/**
		 * 播放
		 * @param	...rest
		 */
        function play(...rest):void;
		
		/**
		 * 重播
		 */
        function replay():void;
		
		/**
		 * 暂停
		 */
        function pause():void;
		
		/**
		 * 如果暂停回复播放，如果播放则return
		 */
        function resume():void;
		
		/**
		 * 搜索
		 * @param	time 时间，单位：秒
		 */
        function seek(time:Number):void;
		
		/**
		 * 停止播放
		 * - 恢复到没有开始的状态
		 */
        function stop():void;
		
		/**
		 * 结束播放
		 * - 播放结束
		 */
        function end():void;
		
		/**
		 * 销毁
		 */
        function destroy():void;
		
		
		
		
		/**
		 * 获取已加载的比例
		 * @return
		 */
        function getLoadedFraction():Number;
		
		/**
		 * 获取默认的媒体显示对象
		 * - 视频播放器 默认显示对象为video
		 * - 音频播放器 默认显示对象为sprite
		 * - 漫画播放器 默认显示对象为bitmap
		 * - 动画播放器 默认显示对象为movieclip
		 * @return
		 */
        function getDefaultMediaSurface():DisplayObject;
		
		/**
		 * 重置流
		 * @param	reconnect 是否重新链接
		 */
        function resetStream(reconnect:Boolean = true):void;
		
		/**
		 * 重置宽高
		 * @param	width
		 * @param	height
		 */
        function resize(width:Number, height:Number):void;
		
		/**
		 * 不可恢复的错误
		 * @param	err 错误信息
		 */
        function unrecoverableError(err:String = null):void;
		
		
		
		
		
		/**
		 * 获取媒体数据
		 * @return
		
        function get data():MediaInfo;
		 */
		/**
		 * 设置媒体数据
		 * @param	data
		 
        function set data(value:MediaInfo):void;
		 */
		
		/**
		 * 获取音量
		 * @return
		 */
        function get volume():Number;
		
		/**
		 * 设置音量
		 * @param	value 音量
		 */
        function set volume(value:Number):void;
		
		/**
		 * 获取语种
		 */
		function get language():String
		
		/**
		 * 获取语种
		 * @param	value 语言
		 */
		function set language(value:String):void
		
		/**
		 * 获取当前媒体支持的多语言种类
		 */
		function get multiLanguage():Array
		
		/**
		 * 获取清晰度
		 */
		function get quality():String
		
		/**
		 * 设置清晰度
		 * - 播放器统一的 标识：1080p、720p、480p、320p ... auto
		 * - 各产品或皮肤各自匹配对应的标识
		 * @param	value 清晰度标识
		 */
		function set quality(value:String):void
		
		/**
		 * 获取当前媒体支持的多清晰度。
		 */
		function get multiQuality():Array
		
		/**
		 * 获取时间
		 * - 只读
		 * @return
		 */
        function get time():Number;
		
		/**
		 * 获取持续时长
		 * - 只读
		 * - 点播为总时长、直播为直播持续时间段，单位都是秒
		 * @return
		 */
        function get duration():Number;
		
		/**
		 * 获取已载入的字节数
		 * - 只读
		 * @return
		 */
        function get bytesLoaded():Number;
		
		/**
		 * 获取总字节数
		 * - 只读
		 * @return
		 */
        function get bytesTotal():Number;
		
		/**
		 * 获取媒体播放器状态
		 * - 只读。
		 * @return
		 */
        function get state():String;
		
		/**
		 * 获取缩放
		 * @return
		 */
        function get scale():Number;
		
		/**
		 * 设置缩放
		 * @param	value 缩放取值范围0～1
		 */
        function set scale(value:Number):void;
		
		/**
		 * 获取比例
		 * @return
		 */
        function get proportion():Number;
		
		/**
		 * 设置比例
		 * @param	value 媒体需要展现的比例值（宽/高）
		 */
        function set proportion(value:Number):void;
		
		
		// IVideoPlayer..
		
		/**
		 * 检测stageVideo 是否可用
		 * @return
		 */
        function isStageVideoAvailable():Boolean;
		
		/**
		 * 检测是否为tag流
		 * @return
		 */
        function isTagStreaming():Boolean;
		
		/**
		 * 获取流对象
		 */
        function get stream():NetStream;
		
		/**
		 * 捕获帧，用于抓屏
		 * @return
		 */
        function captureFrame():BitmapData;
		
		/**
		 * 获取媒体文件播放的帧速率(Frames Per Second)
		 * @return
		 */
        function getFPS():Number;
		
    }
}
