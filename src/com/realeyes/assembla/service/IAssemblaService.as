package com.realeyes.assembla.service
{
	import com.realeyes.assembla.model.Space;
	import com.realeyes.assembla.model.Task;
	import com.realeyes.assembla.model.User;
	
	import flash.events.IEventDispatcher;

	public interface IAssemblaService extends IEventDispatcher
	{
		function getSpaces():void;
		function getTickets( space:Space ):void;
		function getMilestones( space:Space ):void;
		function postTimeEntry( task:Task ):void
		function getTimeEntries():void
		function set user( user:User ):void
		function get user():User
	}
}