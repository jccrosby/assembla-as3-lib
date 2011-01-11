package com.realeyes.assembla.model
{	
	import flash.events.Event;
	import flash.utils.Dictionary;
	import flash.utils.IDataInput;
	import flash.utils.IDataOutput;
	import flash.utils.IExternalizable;
	
	import mx.collections.ArrayCollection;
	import mx.utils.Base64Encoder;
	
	[RemoteClass(alias="com.realeyes.model.assembla.User")] 
	public class User extends BaseVO implements IExternalizable
	{
		public var username:String;
		public var password:String;
		public var remembered:Boolean;
		private var _authToken:String;
		
		public function User( username:String=null, password:String=null )
		{
			super();
			this.username = username;
			this.password = password;
		}
		
		public function generateAuthToken():void
		{
			if( username && password )
			{
				var encoder:Base64Encoder = new Base64Encoder();
				encoder.encode( username + ":" + password );
				_authToken = encoder.flush();
			}
		}
		
		public function clear():void
		{
			username = "";
			password = "";
			_authToken = "";
			remembered = false;
		}
		
		public function writeExternal( output:IDataOutput ):void
		{
			output.writeUTF( username );
			output.writeUTF( password );
			output.writeBoolean( remembered );
			output.writeUTF( authToken );
		}
		
		public function readExternal( input:IDataInput ):void
		{
			username = input.readUTF();
			password = input.readUTF();
			remembered = input.readBoolean();
			_authToken = input.readUTF();
		}

		public function get authToken():String
		{
			generateAuthToken();
			return _authToken;
		}

	}
}