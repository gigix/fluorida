package fluorida.action
{
	import flash.display.DisplayObject;
	
	public class Call extends Action
	{
		protected override function doRun(args:Array) : void {
			var locator:String = args.shift();
			var selectedObject : DisplayObject = _accessor.$$(locator);
			var calledFunction : Function = selectedObject[args.shift()];
			if ( calledFunction == null )
			{
				throw new Error( "no such method!");
			}
			var parameters : Array = new Array();
			for each ( var arg : String in args )
			{
				if ( arg as Number )
				{
					parameters.push( arg as Number );
				} else if ( arg as int ) {
					parameters.push( arg as int );
				} else if ( arg.indexOf("{") == 0 && arg.lastIndexOf( "}" ) ==  arg.length - 1 )
				{
					parameters.push( _accessor.$$( arg.substr( 1, arg.length - 1 ) ) );
				} else {
					parameters.push( arg.replace( "\\{", "{").replace("\\}", "}") );
				}
				// TODO 
			}
			calledFunction.apply( selectedObject, parameters );
			
		}	
		
	}
}