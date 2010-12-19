package com.realeyes.assembla.model
{
	public class Ticket extends BaseVO
	{
		[Bindable]public var id:int;
		[Bindable]public var number:int;
		[Bindable]public var summary:String;
		[Bindable]public var description:String;
		[Bindable]public var workingHours:Number;
		[Bindable]public var spaceID:String;
		[Bindable]public var milestoneID:int;
		
		public function Ticket()
		{
			super();
		}
		
		public function clearData():void
		{
			id = 0;
			number = 0;
			summary = "";
			description = "";
			workingHours = 0;
			spaceID = "";
			milestoneID = 0;
		}
	}
}