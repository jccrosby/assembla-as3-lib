package com.realeyes.assembla.model
{
	public class Milestone extends BaseVO
	{
		public var id:int;
		public var completedDate:Date;
		public var completedAt:Date;
		public var createdBy:String;
		public var description:String;
		public var dueDate:Date;
		public var isCompleted:Boolean;
		public var spaceID:String;
		public var title:String;
		public var userID:String;
		
		public function Milestone()
		{
			super();
		}
		
		public function parseXML( milestoneXML:XML ):Milestone
		{
			id = parseInt( milestoneXML.id );
			completedDate = new Date( milestoneXML.child( "completed-date" ) );
			completedAt = new Date( milestoneXML.child( "completed-at" ) );
			createdBy = milestoneXML.child( "created-by" );
			description = milestoneXML.child( "dscription" );
			dueDate = new Date( milestoneXML.child( "due-date" ) );
			isCompleted = milestoneXML.child( "is-completed" ) == "true" ? true:false;
			spaceID = milestoneXML.child( "space-id" );
			title = milestoneXML.child( "title" );
			userID = milestoneXML.child( "user-id" );
			
			return this;
		}
	}
}