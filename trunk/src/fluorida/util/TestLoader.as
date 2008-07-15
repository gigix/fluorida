package fluorida.util {
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	import fluorida.action.CustomAction;
	import fluorida.framework.Command;
	import fluorida.framework.TestCase;
	import fluorida.framework.TestSuite;
	
	import mx.utils.StringUtil;
	
	public class TestLoader extends EventDispatcher {
		private var _baseUrl:String;
		private var _suiteUrl:String;
		private var _suite:TestSuite;
		private var _cases:Array = new Array();
		
		public function TestLoader(baseUrl:String) {
			_baseUrl = baseUrl;
		}
		
		public function getSuite() : TestSuite {
			return _suite;	
		}

		public function load(url:String) : void {
			_suiteUrl = url;
			new FileLoader(this, createSuite).load(getUrl(_suiteUrl));
		}
		
		private function getUrl(url:String) : String {
			return _baseUrl + "/" + url;
		}
		
		private function createSuite(data:String) : void {
			_suite = new TestSuite(_suiteUrl);
			_cases = CommandStringUtil.getUsefulRows(data).map(createCase);

			for each(var testCase:TestCase in _cases) {
				_suite.addTestCase(testCase);
			}
			
			loadNextCase();
		}
		
		private function loadNextCase() : void {
			if(_cases.length == 0) {
				dispatchEvent(new Event(Event.COMPLETE));
				return ;
			}
			var testCase:TestCase = _cases[0];
			new FileLoader(this, loadTestCase).load(getUrl(testCase.getName()));
		}
		
		private function loadTestCase(string:String) : void {
			// TODO 
			var testCase:TestCase = _cases.shift();
			
			var rows:Array = CommandStringUtil.getUsefulRows(string);
			for ( var index : Number = 0; index < rows.length; index++) {
				var row : String = rows[ index ];
				var cmdArray:Array = CommandStringUtil.buildCommandArray( row );
				
				var action:String = cmdArray.shift();
				if ( action == "def" ) {
					var defType : String =  cmdArray.shift();
					if ( defType == "action" )
					{
						var actionName : String = cmdArray.shift();
						var cAction : CustomAction = new CustomAction( cmdArray );
						var actionCommandRow : String = rows[ ++index ];
						while( actionCommandRow != "|end|" ) {
							cAction.addCommandRowsString( actionCommandRow );
							actionCommandRow = rows[ ++index ];
						}
						cAction.name = actionName;
						testCase.setCustomAction( actionName, cAction );  
					} 
				} else if ( action == "import" ) {
					var fileName : String = cmdArray.shift();
					new HeadFileImporter( testCase ).load( getUrl( fileName ) );
				} else {
					var args:Array = cmdArray;
					var command:Command = new Command(action, args);
					testCase.addCommand(command);
				}
			}
			
			loadNextCase();
		}
		
		private function createCase(element:*, index:int, arr:Array) : TestCase {
            return new TestCase(element as String);
        }
	}
}