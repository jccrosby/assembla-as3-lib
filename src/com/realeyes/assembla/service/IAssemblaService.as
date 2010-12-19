package com.realeyes.assembla.service
{
	import com.realeyes.assembla.model.Space;

	public interface IAssemblaService
	{
		function getSpaces():void;
		function getTickets( space:com.realeyes.assembla.model.Space ):void;
		function getMilestones( space:Space ):void;
		function getTimeEntries():void
	}
}