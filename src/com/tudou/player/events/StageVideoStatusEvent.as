package com.tudou.player.events
{
    import flash.events.*;

    public class StageVideoStatusEvent extends Event
    {
        public static var UNAVAILABLE:String = "unavailable";
        public static var AVAILABLE:String = "available";

        public function StageVideoStatusEvent(type:String, bubbles:Boolean = false)
        {
            super(type, bubbles, false);
        }
		
    }
}
