package com.realeyes.assembla.model
{
	import flash.events.Event;
	import flash.utils.Dictionary;
	
	import mx.collections.ArrayCollection;
	import mx.collections.Sort;
	import mx.collections.SortField;
	
	public class Assembla extends BaseVO
	{
		static public const SPACES_CHANGED:String = "spacesChanged";
		public static const TASKS_CHANGE:String = "tasksChange";
		
		[Bindable]public var selectedTicket:Ticket;
		private var _tasks:ArrayCollection;
		
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
		
		[Bindable]
		public function get spacesLookup():Dictionary
		{
			return _spacesLookup;
		}
		public function set spacesLookup( value:Dictionary ):void
		{
			if( _spacesLookup != value )
			{ 
				_spacesLookup = value;
				dispatch( new Event( SPACES_CHANGED ) );
			}
		}

		public function get spaces():ArrayCollection
		{
			var spacesCollection:ArrayCollection = new ArrayCollection();
			for each( var space:Space in _spacesLookup )
			{
				spacesCollection.addItem( space );
			}
			sortSpaces( spacesCollection );
			return spacesCollection;
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
		
		public function clearData():void
		{
			spaces.removeAll();
			spacesLookup = new Dictionary();
			tasks.removeAll();
			selectedTicket = new Ticket();
		}
	}
}