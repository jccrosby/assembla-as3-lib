package com.realeyes.assembla.model
{
	import flash.events.Event;
	import flash.utils.Dictionary;
	
	import mx.collections.ArrayCollection;
	import mx.collections.Sort;
	import mx.collections.SortField;
	
	[Event( name="spacesChanged", type="flash.events.Event" )]
	[Event( name="ticketsChanged", type="flash.events.Event" )]
	public class Assembla extends BaseVO
	{
		static public const SPACES_CHANGED:String = "spacesChanged";
		public static const TICKETS_CHANGE:String = "ticketsChange";
		
		[Bindable]public var selectedTicket:Ticket;
		private var _tickets:ArrayCollection;
		
		private var _spacesLookup:Dictionary;
		private var _spaces:ArrayCollection;
		
		public function Assembla()
		{
			super();
			_spaces = new ArrayCollection();
			_spacesLookup = new Dictionary();
		}

		public function sortSpaces( collection:ArrayCollection ):void
		{
			var sortField:SortField = new SortField( "name", true );
			var sort:Sort = new Sort();
			sort.fields = [ sortField ];
			
			collection.sort = sort;
			collection.refresh();
		}
		
		public function get spacesLookup():Dictionary
		{
			return _spacesLookup;
		}
		public function set spacesLookup( value:Dictionary ):void
		{
			if( _spacesLookup != value )
			{ 
				_spacesLookup = value;
			}
		}
		
		[Bindable( event="spacesChanged" )]
		public function get spaces():ArrayCollection
		{
			return _spaces;
		}
		public function set spaces( value:ArrayCollection):void
		{
			if( _spaces != value )
			{ 
				_spaces = value;
				sortSpaces( _spaces );
				
				for each( var space:Space in _spaces )
				{
					spacesLookup[ space.id ] = space;
				}
				dispatch( new Event( SPACES_CHANGED ) );
			}
		}
		
		[Bindable( event="ticketsChange" )]
		public function get tickets():ArrayCollection
		{
			return _tickets;
		}
		public function set tickets(value:ArrayCollection):void
		{
			if( value != _tickets )
			{
				_tickets = value;
				if( _tickets.length )
				{
					var spaceID:String = Ticket( _tickets.getItemAt( 0 ) ).spaceID;
					Space( spacesLookup[ spaceID ] ).tickets = _tickets;
				}
				dispatch( new Event( TICKETS_CHANGE ) );
			}
		}
		
		public function clear():void
		{
			if( spaces ) spaces.removeAll();
			if( spacesLookup) spacesLookup = new Dictionary();
			if( tickets ) tickets.removeAll();
			if( selectedTicket ) selectedTicket = new Ticket();
		}
	}
}