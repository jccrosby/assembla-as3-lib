package com.realeyes.assembla.model
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	public class BaseVO extends EventDispatcher
	{
		public function BaseVO(target:IEventDispatcher=null)
		{
			super(target);
			
		}
		
		public function dispatch( event:Event ):void
		{
			dispatchEvent( event );
		}
	}
}