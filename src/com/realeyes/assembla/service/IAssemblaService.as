package com.realeyes.assembla.service
{
	import com.realeyes.assembla.model.Space;
	import com.realeyes.assembla.model.Task;
	import com.realeyes.assembla.model.User;
	
	import flash.events.IEventDispatcher;

	public interface IAssemblaService
	{
		function addEventListener( type:String, listener:Function, useCapture:Boolean=false, priority:int=0, useWeakReference:Boolean=false ):void
		function removeEventListener( type:String, listener:Function, useCapture:Boolean=false ):void
		function hasEventListener( type:String ):Boolean
		function getSpaces():void;
		function getTickets( space:com.realeyes.assembla.model.Space ):void;
		function getMilestones( space:Space ):void;
		function postTimeEntry( task:Task ):void
		function getTimeEntries():void
		function set user( user:User ):void
		function get user():User
	}
}