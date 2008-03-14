package fluorida.util {
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import mx.utils.StringUtil;
	
	import fluorida.framework.Command;
	import fluorida.framework.TestSuite;
	import fluorida.framework.TestCase;
	import fluorida.util.FileLoader;
	
	public class TestLoader extends EventDispatcher {
		private var _suite:TestSuite;
		private var _cases:Array = new Array();
		
		public function getSuite() : TestSuite {
			return _suite;	
		}

		public function load(url:String) : void {
			new FileLoader(this, createSuite).load(url);
		}
		
		private function createSuite(data:String) : void {
			_suite = new TestSuite();
			_cases = getUsefulRows(data).map(createCase);

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
			new FileLoader(this, loadTestCase).load(testCase.getName());
		}
		
		private function loadTestCase(string:String) : void {
			var testCase:TestCase = _cases.shift();
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