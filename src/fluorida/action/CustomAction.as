package fluorida.action
{
	import fluorida.framework.Command;
	import fluorida.util.CommandStringUtil;
	
	import mx.utils.StringUtil;
	
	public class CustomAction extends Action
	{
		public function CustomAction( params : Array )
		{
			this._params = params;
			this._commandRowsStrings = new Array();
			this._runningCommandsStrings = new Array();
			
		}
		public function addCommandRowsString( _commandRowsString : String ) : void {
			this._commandRowsStrings.push( _commandRowsString );
		}
		
		public function set name( name : String ) : void {
			this._name = name;
		}
		
		public function get name() : String {
			return this._name;
		} 
		
		public function clone() : CustomAction {
			var clonedCA : CustomAction = new CustomAction(this._params);
			clonedCA._commandRowsStrings = this._commandRowsStrings;
			return clonedCA;
		}
		
		protected override function doRun( args : Array ) : void {
			for each ( var rowCommandString : String in this._commandRowsStrings )
			{
				var preparedRowCommandString : String = rowCommandString;
				for ( var index : Number = 0; index < args.length; index++ )
				{
					 preparedRowCommandString = preparedRowCommandString.replace( new RegExp("\\"+this._params[ index ], "g" ), args[ index ] );
				}
				this._runningCommandsStrings.push( preparedRowCommandString );
			} 	
			
			runNextCommand();
		}
		
		private function runNextCommand() : void {
			if ( this._runningCommandsStrings.length == 0 )
				return;
			var commandString : String = this._runningCommandsStrings.shift();
			var cmdArray:Array = CommandStringUtil.buildCommandArray( commandString );
			var actionName:String = cmdArray.shift();
			var args:Array = cmdArray;
			var command : Command = new Command(actionName, args);
			var action : Action = Action.create(this.getTestCase(), command, _accessor, runNextCommand);
			action.run();
		}
        
		private var _params : Array;
		
		private var _runningCommandsStrings : Array;
		
		private var _commandRowsStrings : Array;
		
		private var _name : String
		
	}
}