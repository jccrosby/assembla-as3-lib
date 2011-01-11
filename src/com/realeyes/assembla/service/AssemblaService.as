package com.realeyes.assembla.service
{
	import com.realeyes.assembla.model.Assembla;
	import com.realeyes.assembla.model.Milestone;
	import com.realeyes.assembla.model.Space;
	import com.realeyes.assembla.model.Task;
	import com.realeyes.assembla.model.Ticket;
	import com.realeyes.assembla.model.User;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.net.URLRequestHeader;
	import flash.net.URLRequestMethod;
	import flash.utils.Dictionary;
	
	import mx.collections.ArrayCollection;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.utils.ObjectUtil;
	
	[Event( name="spacesResult", type="com.realeyes.assembla.service.AssemblaService" )]
	[Event( name="milestonesResult", type="com.realeyes.assembla.service.AssemblaService" )]
	[Event( name="ticketsResult", type="com.realeyes.assembla.service.AssemblaService" )]
	[Event( name="createdResult", type="com.realeyes.assembla.service.AssemblaService" )]
	[Event( name="fault", type="mx.rpc.events.FaultEvent" )]
	[Event( name="ioError", type="flash.events.IOErrorEvent" )]
	
	/**
	 * <p>Provides a basic API for the Assembla REST API 
	 * <a href="http://www.assembla.com/wiki/show/breakoutdocs/Assembla_REST_API" target="_blank">http://www.assembla.com/wiki/show/breakoutdocs/Assembla_REST_API</a></p>
	 *  
	 * @author jccrosby
	 * @version 1.1
	 */
	public class AssemblaService extends EventDispatcher implements IAssemblaService
	{
		/////////////////////////////////////////
		// Declarations
		/////////////////////////////////////////
		
		static private const DOMAIN:String = "www.assembla.com";
		static private const HTTP_PROTOCOL:String = "http://";
		static private const HTTPS_PROTOCOL:String = "https://";
		
		static public const SPACES_RESULT:String= "spacesResult";
		static public const MILESTONES_RESULT:String= "milestonesResult";
		static public const TICKETS_RESULT:String= "ticketsResult";
		static public const CREATED_RESULT:String= "createdResult";
		
		static public const SPACES:String = "/spaces/my_spaces";
		static public const MILESTONES:String = "/spaces/@@SPACE_ID@@/milestones";
		static public const TICKETS:String = "/spaces/@@SPACE_ID@@/tickets";
		static public const TASK:String = "/user/time_entries/";
	
		//private var _loader:URLLoader;
		private var _loader:URLLoader;
		private var _userURL:String;
		private var _user:User;
				
		private var _loading:Boolean;
		private var _requestQueue:Vector.<URLRequest>;
		
		public var assembla:Assembla;
		
		/////////////////////////////////////////
		// Init Methods
		/////////////////////////////////////////
		
		public function AssemblaService()
		{
			super();
			
			_initLoader();
		}
		
		private function _initLoader():void
		{
			_requestQueue = new Vector.<URLRequest>();
			
			//_loader = new URLLoader();
			_loader = new URLLoader();
			
			_loader.dataFormat = URLLoaderDataFormat.TEXT;
			
			_loader.addEventListener( Event.COMPLETE, _onComplete );
			_loader.addEventListener( HTTPStatusEvent.HTTP_STATUS, _onHTTPStatus );
			_loader.addEventListener( IOErrorEvent.IO_ERROR, _onIOError );
			_loader.addEventListener( ProgressEvent.PROGRESS, _onProgress );
			_loader.addEventListener( SecurityErrorEvent.SECURITY_ERROR, _onSecurityError );
			
		}
		
		/////////////////////////////////////////
		// Control Methods
		/////////////////////////////////////////
		
		private function _load( request:URLRequest ):void
		{
			if( !_loading )
			{
				_loading = true;
				_loader.load( request );
			}
			else
			{
				_requestQueue.push( request );
			}
		}
		
		private function _processRequestQueue():void
		{
			_loading = false;
			if( _requestQueue.length )
			{
				_load( _requestQueue.shift() );
			}
		}
		
		private function _buildBaseRequest( url:String, data:Object=null, method:String=URLRequestMethod.GET ):URLRequest
		{   
			var request:URLRequest = new URLRequest()
			request.url = url;
			request.method = method;
			request.data = data;
			//request.authenticate = false;
			request.requestHeaders.push( new URLRequestHeader( "Accept", "application/xml" ) );
			request.requestHeaders.push( new URLRequestHeader( "Authorization","Basic " + _user.authToken ) );
			
			return request;
		}
		
		public function getSpaces():void
		{
			_load( _buildBaseRequest( HTTPS_PROTOCOL + DOMAIN + SPACES ) );
		}
		
		public function getMilestones( space:com.realeyes.assembla.model.Space ):void
		{
			_load( _buildBaseRequest( HTTPS_PROTOCOL + DOMAIN + MILESTONES.split( "@@SPACE_ID@@" ).join( space.name ) ) );
		}
		
		public function getTickets( space:Space ):void
		{
			_load( _buildBaseRequest( HTTPS_PROTOCOL + DOMAIN + TICKETS.split( "@@SPACE_ID@@" ).join( space.id ) ) );
		}
		
		public function getTimeEntries():void
		{
			// TODO: Implement getTimeEntries
			throw new Error( "Need to implement getTimeEntries()." );
		}
		
		public function postTimeEntry( task:Task ):void
		{
			var request:URLRequest = _buildBaseRequest( HTTP_PROTOCOL + DOMAIN + TASK, task.toXML(), URLRequestMethod.POST );
			request.requestHeaders.push( new URLRequestHeader( "Content-Type", "application/xml" ) );
			_load( request );
		}
		
		/////////////////////////////////////////
		// Event Handlers
		/////////////////////////////////////////
		private function _onComplete( event:Event ):void
		{
			_processRequestQueue();
			
			var resultXML:XML = XML( _loader.data );
			//trace( resultXML.toString() );
			var responseName:String = resultXML.name();			
			var spaceID:String;
			trace( "Response Name: " + responseName );
			switch( responseName )
			{
				case "spaces":
				{
					var spaces:ArrayCollection= new ArrayCollection();
					for each( var space:XML in resultXML..space )
					{
						var newSpace:Space = new Space();
						newSpace.id = space.id;
						newSpace.name = space.name;
						spaces.addItem( newSpace );
					}
					
					dispatchEvent( new ResultEvent( SPACES_RESULT, false, true, spaces ) );
					break;
				}
				case "milestones":
				{
					var milestones:ArrayCollection = new ArrayCollection();
					var milestonesXML:XMLList = resultXML..milestone;
					for each( var milestoneXML:XML in milestonesXML )
					{
						var milestone:Milestone = new Milestone().parseXML( milestoneXML );
						milestones.addItem( milestone );
						spaceID = milestone.spaceID;
					}
					
					dispatchEvent( new ResultEvent( MILESTONES_RESULT, false, true, milestones ) );
					break;
				}
				case "tickets":
				{
					var tickets:ArrayCollection = new ArrayCollection();
					var ticketsXML:XMLList = resultXML..ticket;
					for each( var ticket:XML in ticketsXML )
					{
						var number:int = parseInt( ticket.number );
						var summary:String = ticket.summary;
						var description:String = ticket.description;
						var workingHours:Number = parseFloat( ticket.elements( "working-hours" )[0] );
						
						var newTicket:Ticket = new Ticket();
						newTicket.id = parseInt( ticket.id );
						newTicket.number = number;
						newTicket.summary = summary;
						newTicket.description = description;
						newTicket.workingHours = workingHours;
						newTicket.spaceID = ticket.child( "space-id" );
						newTicket.milestoneID = parseInt( ticket.child( "milestone-id" ) );
						
						tickets.addItem( newTicket );
						spaceID = newTicket.spaceID;
					}
					
					dispatchEvent( new ResultEvent( TICKETS_RESULT, false, true, tickets ) );
					break;
				}
				case "tasks":
				{
					var tasks:ArrayCollection = new ArrayCollection();
					var tasksXML:XMLList = resultXML..task;
					
					for each( var taskXML:XML in tasksXML )
					{
						var task:Task = new Task().parseXML( taskXML );
						tasks.addItem( task );
					}
					
					dispatchEvent( new ResultEvent( CREATED_RESULT, false, true, tasks ) );
					break;
				}
			}
			
			// FIXME: The service seems to be caching requests between logins
			_loader = null;
			_loader = new URLLoader();
		}
		
		private function _onHTTPStatus( event:HTTPStatusEvent ):void
		{
			trace( "HTTPStatus: " + event.status );
			switch( event.status )
			{
				case 201:
				{
					dispatchEvent( new ResultEvent( CREATED_RESULT, false, true, _loader.data ) );
					break;
				}
				case 422:
				{
					trace( ObjectUtil.toString( _loader.data ) );
					break;
				}
				case 401:
				case 403:
				{
					trace( ObjectUtil.toString( _loader.data ) );
					dispatchEvent( new FaultEvent( FaultEvent.FAULT, false, true ) );
					break;
				}
			}
			
		}
		
		private function _onIOError( event:IOErrorEvent ):void
		{
			trace( "IOError: " + event.text );
			event.stopImmediatePropagation();
		}
		
		private function _onProgress( event:ProgressEvent ):void
		{
			
		}
		
		private function _onSecurityError( event:SecurityErrorEvent ):void
		{
			trace( "SecurityError: " + event.text );
		}
		
		
		/////////////////////////////////////////
		// Getter/Setters
		/////////////////////////////////////////

		public function get user():User
		{
			return _user;
		}
		public function set user(value:User):void
		{
			_user = value;
		}
	}
}