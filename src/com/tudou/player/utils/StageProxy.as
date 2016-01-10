package com.tudou.player.utils 
{
	import com.tudou.player.events.StageVideoStatusEvent;
	import com.tudou.utils.Debug;
	import flash.display.DisplayObjectContainer;
	import flash.display.StageDisplayState;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.MouseEvent;
	import flash.events.StageVideoAvailabilityEvent;
	import flash.media.StageVideo;
	import flash.utils.flash_proxy;
	import flash.utils.Proxy;
	
	/**
	 * 场景代理
	 * 
	 * @author 8088 at 2015/1/9 11:11:50
	 */
    dynamic public class StageProxy extends Proxy implements IEventDispatcher
    {
        public function StageProxy(element:DisplayObjectContainer = null)
        {
			dispatcher = new EventDispatcher(this);
            postAddedToStageListeners = [];
            this.element = element;
			
            if (addedToStage)
            {
                addEventListener(Event.ACTIVATE, onStageFocus);
                addEventListener(Event.DEACTIVATE, onStageBlur);
                addEventListener(MouseEvent.CLICK, onStageClick, true, 0, true);
                testStageAvailability();
            }
            else if (!stageVideoAvailabilityTested && element) {
                element.addEventListener(Event.ADDED_TO_STAGE, testStageAvailability);
            }
        }
		
        protected function onStageVideoAvailabilityEvent(evt:Event):void
        {
            _stageVideoAvailable = evt.hasOwnProperty("availability") && evt["availability"] == "available";
			if (!stageVideoAvailableWithoutFullscreenTested)
            {
                stageVideoAvailableWithoutFullscreen = _stageVideoAvailable;
                stageVideoAvailableWithoutFullscreenTested = true;
            }
            rebroadcastStageVideoAvailability();
        }
		
        public function isFullScreen():Boolean
        {
            return this.displayState == StageDisplayState.FULL_SCREEN || this.displayState == "fullScreenInteractive";
        }
		
        protected function rebroadcastStageVideoAvailability():void
        {
            if (_stageVideoAvailable)
            {
                dispatchEvent(new StageVideoStatusEvent(StageVideoStatusEvent.AVAILABLE));
            }
            else {
                dispatchEvent(new StageVideoStatusEvent(StageVideoStatusEvent.UNAVAILABLE));
            }
        }
		
        protected function testStageAvailability(evt:Event = null):void
        {
            var listeners:Array;
            var i:int;
			
            if (!stageVideoAvailabilityTested)
            {
                stageVideoAvailabilityTested = true;
                
				addEventListener(StageVideoAvailabilityEvent.STAGE_VIDEO_AVAILABILITY, onStageVideoAvailabilityEvent);
            }
            if (addedToStage && postAddedToStageListeners.length)
            {
                listeners = postAddedToStageListeners;
                postAddedToStageListeners = [];
                i = 0;
                while (i < listeners.length)
                {
                    addEventListener.apply(null, listeners[i]);
                    i++;
                }
            }
        }
		
        private function onStageClick(event:Event):void
        {
            if (!_stageHasFocus)
            {
                dispatchEvent(new Event(Event.ACTIVATE, false, false));
            }
        }
		
        public function get addedToStage():Boolean
        {
            return _stageAllowed && element && element.stage;
        }
		
        public function get stageVideoAvailable():Boolean
        {
			return _stageVideoAvailable && this.stageVideos && this.stageVideos.length > 0;
        }
		
        public function get contentsScaleFactor():Number
        {
            if (this.hasProperty("contentsScaleFactor"))
            {
                return this.getProperty("contentsScaleFactor");
            }
            return 1;
        }
		
        override flash_proxy function hasProperty(name:*):Boolean
        {
            if (addedToStage)
            {
                try
                {
                    return element.stage.hasOwnProperty(name);
                }
                catch (e:SecurityError) {
                    _stageAllowed = false;
                }
            }
            return false;
        }
		
        public function get stageAllowed():Boolean
        {
            return _stageAllowed;
        }
		
        override flash_proxy function getProperty(name:*):*
        {
            if (addedToStage)
            {
                try
                {
                    return element.stage[name];
                }
                catch (e:SecurityError) {
                    _stageAllowed = false;
                }
            }
        }
		
        public function get fullScreenAllowed():Boolean
        {
            return _stageAllowed && _fullScreenAllowed;
        }
		
        private function onStageBlur(evt:Event):void
        {
            _stageHasFocus = false;
        }
		
		override flash_proxy function setProperty(name:*, value:*):void
        {
            try
            {
                if (addedToStage)
                {
                    element.stage[name] = value;
                }
            }
            catch (e:SecurityError) {
                if (e.errorID == 2152)
                {
                    _fullScreenAllowed = false;
                }
                else {
                    _stageAllowed = false;
                }
            }
        }
		
        private function onStageFocus(evt:Event):void
        {
            _stageHasFocus = true;
        }
		
		override flash_proxy function callProperty(name:*, ...rest):*
        {
            if (addedToStage)
            {
                try
                {
                    return element.stage[name].apply(null, rest);
                }
                catch (e:SecurityError) {
                    _stageAllowed = false;
                }
            }
        }
		
        public function resize():void
        {
            this.dispatchEvent(new Event(Event.RESIZE));
        }
		
        public function get stageHasFocus():Boolean
        {
            return _stageHasFocus;
        }
		
        public function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = true):void
        {
            if (stageVideoAvailabilityTested && type== StageVideoAvailabilityEvent.STAGE_VIDEO_AVAILABILITY)
            {
                rebroadcastStageVideoAvailability();
            }
            if (addedToStage)
            {
                try
                {
                    element.stage.addEventListener(type, listener, useCapture, priority, useWeakReference);
                }
                catch (e:SecurityError) {
                    _stageAllowed = false;
                }
            }
            else {
                postAddedToStageListeners.push(arguments);
            }
        }
		
	    public function dispatchEvent(evt:Event):Boolean{
	        return dispatcher.dispatchEvent(evt);
	    }
	    
	    public function hasEventListener(type:String):Boolean{
	        return dispatcher.hasEventListener(type);
	    }
	    
	    public function removeEventListener(type:String, listener:Function, useCapture:Boolean = false):void{
	        dispatcher.removeEventListener(type, listener, useCapture);
	    }
	    
	    public function willTrigger(type:String):Boolean {
	        return dispatcher.willTrigger(type);
	    }
		
		private var dispatcher:EventDispatcher;
		private var element:DisplayObjectContainer;
        private var postAddedToStageListeners:Array;
        private static var _fullScreenAllowed:Boolean = true;
        public static var _stageVideoAvailable:Boolean = false;
        private static var _stageAllowed:Boolean = true;
        private static var stageVideoAvailabilityTested:Boolean = false;
        private static var stageVideoAvailableWithoutFullscreenTested:Boolean = false;
        private static var _stageHasFocus:Boolean = false;
        private static var stageVideoAvailableWithoutFullscreen:Boolean = false;
        
    }

}