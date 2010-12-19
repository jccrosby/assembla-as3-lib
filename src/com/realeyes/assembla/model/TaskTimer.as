package com.realeyes.assembla.model
{
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	[Bindable]
	public class TaskTimer extends BaseVO
	{
		public static const LABEL_CHANGE:String = "labelChange";
		
		private var _label:String;
		
		public var hours:int;
		public var minutes:int;
		public var seconds:int;
		
		private var _timer:Timer;
		
		public function TaskTimer()
		{
			_timer = new Timer( 1000 );
			_timer.addEventListener( TimerEvent.TIMER, _onTimer );
		}
		

		[Bindable( event="labelChange" )]
		public function get label():String
		{
			return _label;
		}
		public function set label(value:String):void
		{
			_label = value;
			dispatch( new Event( LABEL_CHANGE ) );
		}

		public function start():void
		{
			_timer.start();
		}

		public function stop():void
		{
			_timer.stop();	
		}
		
		public function _onTimer( event:TimerEvent ):void
		{
			seconds++;
			if( seconds == 60 )
			{
				seconds = 0;
				minutes++;
				
				if( minutes == 60 )
				{
					minutes = 0;
					hours++;
				}
			}
			label = ( hours < 10 ? "0"+hours:hours ) + ":" + ( minutes < 10 ? "0"+minutes:minutes ) + ":" + ( seconds < 10 ? "0"+seconds:seconds );
		}
		
		
	}
}