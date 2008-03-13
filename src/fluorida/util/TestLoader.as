package fluorida.util {
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import mx.utils.StringUtil;
	
	import fluorida.framework.Command;
	import fluorida.framework.TestSuite;
	import fluorida.framework.TestCase;
	
	public class TestLoader extends EventDispatcher {
		public static var COMPLETE:String = Event.COMPLETE;
		
		private var _loader:URLLoader;
		private var _suite:TestSuite;
		private var _cases:Array = new Array();
		
		public function getSuite() : TestSuite {
			return _suite;	
		}

		public function load(url:String) : void {
			loadFile(url, createSuite);
		}
		
		private function createSuite(event:Event) : void {
			_suite = new TestSuite();
			_cases = getUsefulRows(_loader.data).map(createCase);

			for each(var testCase:TestCase in _cases) {
				_suite.addTestCase(testCase);
			}
			
			loadNextCase();
		}
		
		private function loadNextCase() : void {
			if(_cases.length == 0) {
				dispatchEvent(new Event(COMPLETE));
				return ;
			}
			var testCase:TestCase = _cases[0];
			loadFile(testCase.getName(), loadTestCase);
		}
		
		private function loadTestCase(event:Event) : void {
			var testCase:TestCase = _cases.shift();
			var string:String = _loader.data;
			
			var rows:Array = getUsefulRows(string);
			for each(var row:String in rows) {
				var cmdArray:Array = row.split("|").map(trim).filter(notEmpty);
				var action:String = cmdArray.shift();
				var args:Array = cmdArray;
				var command:Command = new Command(action, args);
				testCase.addCommand(command);
			}
			
			loadNextCase();
		}
		
		private function loadFile(url:String, completeHandler:Function) : void {
		    _loader = new URLLoader();
		    _loader.addEventListener(COMPLETE, completeHandler);
		    _loader.load(new URLRequest(url));
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
		
		private function createCase(element:*, index:int, arr:Array) : TestCase {
            return new TestCase(element as String);
        }
	}
}