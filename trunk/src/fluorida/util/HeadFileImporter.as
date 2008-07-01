package fluorida.util
{
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	import fluorida.action.CustomAction;
	import fluorida.framework.TestCase;
	
	import mx.utils.StringUtil;
	
	public class HeadFileImporter
	{
		private var _testCase : TestCase;
		private var _loader : URLLoader;
		
		public function HeadFileImporter( testCase : TestCase ) {
			this._testCase = testCase;
		}
		
		public function load( url : String ) : void {
		    _loader = new URLLoader();
		    _loader.addEventListener( Event.COMPLETE, onComplete );
		    _loader.load( new URLRequest( url ) );
		}
		
		private function onComplete( event : Event ) : void {
			var data:String = _loader.data;
			var customActionStringArray : Array = splitToFunctons( _loader.data );
			for each ( var customActionString : String in customActionStringArray ) {
				var customAction : CustomAction = buildCustomActionByString( customActionString );
				this._testCase.setCustomAction( customAction.name, customAction ); 
			}
		}
		
		public function splitToFunctons( string : String ) : Array {
//			var functionBegin = splitToFunctons
			return string.match(/\|def\|.*?\|end\|/gs);
		}
		
		private function buildCustomActionByString( string : String ) : CustomAction {
			var rows:Array = getUsefulRows(string);
			var cmdArray:Array = row.split("|").map(trim).filter(notEmpty);
			var cAction : CustomAction = new CustomAction( cmdArray );
			var action:String = cmdArray.shift();
			if ( action == "def" ) {
				var defType : String =  cmdArray.shift();
				if ( defType == "action" )
					var actionName : String = cmdArray.shift();
					for ( var index : Number = 0; index < rows.length; index++) {
						var row : String = rows[ index ];
						while( actionCommandRow != "|end|" ) {
							index++;
							var actionCommandRow : String = rows[ index ];
							cAction.addCommandRowsString( actionCommandRow );
						}
						index++;
						cAction.name = actionName;
					}
			}
			return cAction;
		}
		
		private function getUsefulRows(content:String) : Array {
			return content.split("\n").map(trim).filter(notEmpty).filter(notComment);
		}
		
		private function notEmpty(element:*, index:int, arr:Array) : Boolean {
            return (element as String).length > 0;
        }
		
		private function notComment(element:*, index:int, arr:Array) : Boolean {
            return (element as String).charAt(0) != "#";
        }
        
        private function trim(element:*, index:int, arr:Array) : String {
            return StringUtil.trim(element as String);
        }
		
	}
}