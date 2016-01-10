package com.tudou.player.utils 
{
	import com.tudou.player.interfaces.IMediaPlayer;
	import flash.utils.flash_proxy;
	import flash.utils.Proxy;
	/**
	 * ...
	 * @author 8088 at 2015/1/9 10:36:39
	 */
	dynamic public class ProxyNetClient extends Proxy
    {
		private var target:Object;
        private static const WHITELIST:Object = { onCuePoint:IMediaPlayer, onMetaData:IMediaPlayer, onPlayStatus:IMediaPlayer };
		
        public function ProxyNetClient(target:Object)
        {
            this.target = target;
        }
		
        private function noop(...args):void
        {
            return;
        }
		
        override flash_proxy function callProperty(method:*, ...args):*
        {
            if (method in WHITELIST && this.target is WHITELIST[method])
            {
                return this.target[method].apply(null, args);
            }
        }
		
        override flash_proxy function getProperty(method:*):*
        {
            if (method in WHITELIST && this.target is WHITELIST[method])
            {
                return this.target[method];
            }
            return Object(this.noop);
        }
		
        override flash_proxy function hasProperty(method:*):Boolean
        {
            if (method && method.hasOwnProperty("localName"))
            {
                method = method.localName;
            }
            return method in WHITELIST && this.target is WHITELIST[method];
        }
		
    }

}