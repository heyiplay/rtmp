package com.tudou.player.events 
{
	import com.tudou.utils.Global;
	import flash.errors.IllegalOperationError;
	/**
	 * 事件代码
	 * 
	 * @author 8088 at 2014/6/25 19:33:53
	 */
	public class NetStatusEventCode
	{
		
		public static const DOMAIN_IS_ILLEGAL:String = "Domain.Is.Illegal";
		
		public static const UNKNOWN_ERROR:String = "Unknown.Error";
		
		public static const ARGUMENT_ERROR:String = "Argument.Error";
		/**
		 * 语言包 快捷键 鼠标右键菜单 相关
		 */
		public static const LANGUAGE_IS_CHANGED:String = "Language.Is.Changed";
		
		public static const LANGUAGE_CHANGE_FAILED:String = "Language.Change.Failed";
		
		public static const LANGUAGE_STRINGS_LOADED:String = "Language.Strings.Loaded";
		
		public static const RIGHTMENU_CONFIG_LOADSTART:String = "Rightmenu.Config.LoadStart";
		
		public static const RIGHTMENU_CONFIG_LOADFAILED:String = "Rightmenu.Config.LoadFailed";
		
		public static const RIGHTMENU_CONFIG_LOADED:String = "Rightmenu.Config.Loaded";
		
		/**
		 * Flash Cookie相关
		 */
		public static const SHARED_OBJECT_TIMEOUT:String = "SharedObject.Timeout";
		
		public static const SHARED_OBJECT_LOAD_FAILED:String = "SharedObject.Load.Failed";
		
		public static const SHARED_OBJECT_IS_READY:String = "SharedObject.Is.Ready";
		
		public static const SHARED_OBJECT_UNABLE_CREAT:String = "SharedObject.Unable.Creat";
		
		public static const SHARED_OBJECT_STORE_FAILED:String = "SharedObject.Store.Failed";
		
		/**
		 * 核心相关
		 */
		public static const PLAYER_CORE_LOAD_START:String = "Player.Core.LoadStart";
		
		public static const PLAYER_CORE_LOAD_PROGRESS:String = "Player.Core.LoadProgress";
		
		public static const PLAYER_CORE_LOAD_FAILED:String = "Player.Core.LoadFailed";
		
		public static const PLAYER_CORE_LOAD_COMPLETE:String = "Player.Core.LoadComplete";
		
		public static const PLAYER_CORE_INITIALIZED:String = "Player.Core.Initialized";
		//
		public static const PLAYER_STATE_CHANGE:String = "Player.State.Change";
		
		public static const PLAYER_IS_READY:String = "Player.Is.Ready";
		
		public static const PLAYER_IS_PAUSED:String = "Player.Is.Paused";
		
		public static const PLAYER_IS_PLAYING:String = "Player.Is.Playing";
		
		public static const PLAYER_IS_LOADING:String = "Player.Is.Loading";
		
		public static const PLAYER_GET_META_DATA:String = "Player.Get.MetaData";
		
		public static const PLAYER_GET_DURATION:String = "Player.Get.Duration";
		
		public static const PLAYER_GET_MULTI_QUALITY:String = "Player.Get.MultiQuality";
		
		public static const PLAYER_GET_MULTI_LANGUAGE:String = "Player.Get.MultiLanguage";
		
		public static const PLAYER_QUALITY_CHANGE:String = "Player.Quality.Change";
		
		public static const QUALITY_SET_FAILED:String = "Quality.Set.Failed";
		
		public static const QUALITY_SET_CANCEL:String = "Quality.Set.Cancel";
		
		public static const PLAYER_LANGUAGE_CHANGE:String = "Player.Language.Change";
		
		public static const PLAYER_PLAY_START:String = "Player.Play.Start";
		
		public static const PLAYER_PLAY_END:String = "Player.Play.End";
		
		public static const PLAYER_PLAY_STOP:String = "Player.Play.Stop";
		
		public static const PLAYER_BUFFER_EMPTY:String = "Player.Buffer.Empty";
		
		public static const PLAYER_BUFFER_FULL:String = "Player.Buffer.Full";
		
		public static const PLAYER_PLAY_FAILED:String = "Player.Play.Failed";
		
		public static const PLAYER_PLAY_HARDWARE_ACCELERATION:String = "Player.Play.HardwareAcceleration";
		
		/**
		 * 皮肤相关
		 */
		public static const PLAYER_SKIN_LOAD_START:String = "Player.Skin.LoadStart";
		
		public static const PLAYER_SKIN_LOAD_PROGRESS:String = "Player.Skin.LoadProgress";
		
		public static const PLAYER_SKIN_LOAD_FAILED:String = "Player.Skin.LoadFailed";
		
		public static const PLAYER_SKIN_LOAD_COMPLETE:String = "Player.Skin.LoadComplete";
		
		public static const SKIN_IS_READY:String = "Skin.Is.Ready";
		
		/**
		 * 广告相关
		 */
		public static const AD_IS_READY:String = "Ad.Is.Ready";
		
		public static const AD_SHOW_START:String = "Ad.Show.Start";
		
		public static const AD_SHOW_FAILED:String = "Ad.Show.Failed";
		
		public static const AD_SHOW_COMPLETE:String = "Ad.Show.Complete";
		
		public static const AD_PRELOAD_COMPLETE:String = "Ad.Preload.Complete";
		
		/**
		 * 业务相关
		 */
		public static const SERVICE_IS_READY:String = "Service.Is.Ready";
		
		public static const SERVICE_EXECUTE_START:String = "Service.Execute.Start";
		
		public static const SERVICE_EXECUTE_PROGRESS:String = "Service.Execute.Progress";
		
		public static const SERVICE_EXECUTE_FAILED:String = "Service.Execute.Failed";
		
		public static const SERVICE_EXECUTE_COMPLETE:String = "Service.Execute.Complete";
		
		public static const SERVICE_DATA_LOAD_START:String = "Service.Data.LoadStart";
		
		public static const SERVICE_DATA_LOAD_COMPLETE:String = "Service.Data.LoadComplete";
		
		public static const SERVICE_DATA_LOAD_FAILED:String = "Service.Data.LoadFailed";
		
		public static const SERVICE_IS_DONE:String = "Service.Is.Done";
		
		public static const SERVICE_ALL_COMPLETE:String = "Service.All.Complete";
		
		/**
		 * 其他
		 */
		public static const API_IS_READY:String = "Api.Is.Ready";
		
		public static const API_INVOKE_FAILED:String = "Api.Invoke.Failed";
		
		public static const API_CHECK_TIMEOUT:String = "Api.Check.Timeout";
		
		public static const API_CONTROL_CHANGE:String = "Api.Control.Change";
		
		public static const APP_IS_READY:String = "App.Is.Ready";
		
		public static const SHORTCUTKEY_IS_READY:String = "ShortCutKey.Is.Ready";
		
		//..
		
		public function NetStatusEventCode(lock:Class = null) 
		{
			if (lock != ConstructorLock)
			{
				throw new IllegalOperationError("禁止实例化 NetStatusEventCode !");
			}
		}
		
		public static function getCodeByMessage(msg:String):String
		{
			var code:String = "";
			
			for (var i:int = 0; i < messageMap.length; i++)
			{
				if (messageMap[i].message == msg)
				{
					code = messageMap[i].code;
					break;
				}
			}
			
			return code;
		}
		
		// Internals..
		//
		private var _global:Global = Global.getInstance();
		
		private static const messageMap:Array =
			[ {code:"E0000", message:UNKNOWN_ERROR}
			, {code:"E1000", message:DOMAIN_IS_ILLEGAL}
			, {code:"W1000", message:LANGUAGE_CHANGE_FAILED}
			]
		
	}

}

class ConstructorLock {};