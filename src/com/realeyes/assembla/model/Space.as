package com.realeyes.assembla.model
{
	import flash.events.Event;
	import flash.utils.IDataInput;
	import flash.utils.IDataOutput;
	import flash.utils.IExternalizable;
	
	import mx.collections.ArrayCollection;
	import mx.collections.Sort;
	import mx.collections.SortField;
	
	//[Event( name="ticketsChange", type="com.realeyes.assembla.model.Space" )]
	
	[RemoteClass(alias="com.realeyes.model.assembla.Space")] 
	public class Space extends BaseVO implements IExternalizable
	{
		public static const TASKS_CHANGE:String = "tasksChange";
		static public const TICKETS_CHANGE:String = "ticketsChange";
		static public const MILESTONE_CHANGE:String = "milestoneChange";
		
		[Bindable]public var id:String;
		[Bindable]public var name:String;
		private var _milestones:ArrayCollection;
		private var _tickets:ArrayCollection;
		private var _tasks:ArrayCollection;
		
		public function Space()
		{
			super();
		}
		
		public function sortTickets( collection:ArrayCollection ):void
		{
			var sortField:SortField = new SortField( "summary", true );
			var sort:Sort = new Sort();
			sort.fields = [ sortField ];
			
			collection.sort = sort;
			collection.refresh();
		}
		
		[Bindable( event="ticketsChange" )]
		public function get tickets():ArrayCollection
		{
			sortTickets( _tickets );
			return _tickets;
		}
		public function set tickets( value:ArrayCollection ):void
		{
			_tickets = value;
			dispatch( new Event( TICKETS_CHANGE ) );
		}
		
		public function clearData():void
		{
			id = "";
			name = "";
			_tickets.removeAll();
		}
		
		
		
		//////////////////////////////////////////
		// IExternalizable for persistance
		//////////////////////////////////////////
		public function writeExternal( output:IDataOutput ):void
		{
			output.writeUTF( id );
			output.writeUTF( name );
		}
		
		public function readExternal( input:IDataInput ):void
		{
			id = input.readUTF();
			name = input.readUTF();
		}
		
		//////////////////////////////////////////
		// Getter/Setters
		//////////////////////////////////////////
		
		[Bindable( event="milestonesChange" )]
		public function get milestones():ArrayCollection
		{
			return _milestones;
		}
		public function set milestones(value:ArrayCollection):void
		{
			_milestones = value;
			dispatch( new Event( MILESTONE_CHANGE ) );
		}

		[Bindable( event="tasksChange" )]
		public function get tasks():ArrayCollection
		{
			return _tasks;
		}
		public function set tasks(value:ArrayCollection):void
		{
			_tasks = value;
			dispatch( new Event( TASKS_CHANGE ) );
		}
		
	}
}