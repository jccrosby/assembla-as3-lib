package com.realeyes.assembla.model
{
	import flash.utils.ByteArray;
	
	public class TimeLog extends BaseVO
	{
		public var createdAt:Date;
		public var description:String;
		public var id:int;
		public var isTimeout:Boolean;
		public var screenshot:ByteArray;
		public var spaceID:String;
		public var taskID:int;
		public var userID:String;
		
		public function TimeLog()
		{
			super();
		}
		
		public function parseXML( timeLogXML:XML ):TimeLog
		{
			createdAt = new Date( timeLogXML );	
			description = timeLogXML.child( "description" );
			id = timeLogXML.child( "id" );
			isTimeout = timeLogXML.child( "is-timeout" ) == "true" ? true:false;
			//screenshot = timeLogXML.child( "screenshot" ); // TODO: Deal with this later
			taskID = timeLogXML.child( "task-id" );
			userID = timeLogXML.child( "user-id" );
			return this;
		}
	}
}