package com.realeyes.assembla.model
{
	import com.adobe.utils.DateUtil;
	
	public class Task extends BaseVO
	{
		public var hours:Number;
		public var description:String;
		public var spaceID:String;
		public var beginAt:Date;
		public var endAt:Date;
		public var url:String;
		public var ticketNumber:int;
		public var ticketID:int;
		public var jobAgreementID:String;
		public var id:int;
		public var userID:String;
		public var billed:Boolean;
		public var createdAt:Date;
		public var updatedAt:Date;		
		
		public function Task()
		{
			super();
		}
		
		public function parseXML( taskXML:XML ):Task
		{
			hours = parseFloat( taskXML.hours );
			description = taskXML.description;
			spaceID = taskXML.child( "space-id" );
			beginAt = DateUtil.parseW3CDTF( taskXML.child( "begin-at" ).text() );
			endAt = DateUtil.parseW3CDTF( taskXML.child( "end-at" ).text() );			
			url = taskXML.url;
			ticketNumber = taskXML.child( "ticket-number" );
			ticketID = parseInt( taskXML.child( "ticket-id" ) );
			jobAgreementID = taskXML.child( "job-agreement-id" );
			id = parseInt( taskXML.id );
			userID = taskXML.child( "user-id" );
			billed = taskXML.billed == "true" ? true:false;
			createdAt = DateUtil.parseW3CDTF( taskXML.child( "created-at" ).text() );
			updatedAt = DateUtil.parseW3CDTF( taskXML.child( "updated-at" ).text() );
			
			return this;
		}
		
		public function toXML():XML
		{
			var taskXML:XML = <task>
								<begin-at type="datetime">{ DateUtil.toW3CDTF( beginAt ) }</begin-at>
								<billed type="boolean">{ billed }</billed>
								<description>{ description }</description>
								<end-at type="datetime">{ DateUtil.toW3CDTF( endAt ) }</end-at>
								<hours type="float">{ hours }</hours>
								<space-id>{ spaceID }</space-id>
								<ticket-id>{ ticketID }</ticket-id>
							</task>;
			
			if( id > 0 )
			{
				taskXML.appendChild( "<id type='integer'>" + id + "</id>" );				
			}
			
			if( userID )
			{
				taskXML.appendChild( "<user-id>" + userID + "</user-id>" );
			}
			
			return taskXML;
		}
	}
}