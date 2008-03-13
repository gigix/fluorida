package fluorida.framework {
	import mx.core.Application;
	
    import fluorida.util.WaitAndRun;
    import fluorida.util.Accessor;
    import fluorida.util.ArrayUtil;
    
	public class TestSuite {
		private var _testCases:Array = new Array();
		private var _runningTestCases:Array;
		private var _name:String;
		private var _accessor:Accessor = null;
		private var _result:TestResult = null;
		
		public function TestSuite(name:String = "") {
			_name = name;
			_result = new TestResult(this);
		}
		
		public function setApplication(application:Application) : void {
			_accessor = new Accessor(application);
		}
		
		public function addTestCase(testCase:TestCase) : void {
			_testCases.push(testCase);
		}
		
		public function getName() : String {
			return _name;
		}
		
		public function getTestCases() : Array {
			return _testCases;
		}
		
		public function countTestCases() : int {
			return _testCases.length;
		}
		
		public function countRunTests() : int {
			return countTestCases() - _runningTestCases.length;
		}

		public function run() : void {
			_runningTestCases = ArrayUtil.copy(_testCases);
			runNextTestCase();
		}
		
		private function runNextTestCase() : void {
			if(_runningTestCases.length == 0) {
				_accessor.enableRunSuite();
				return;
			}
			_accessor.enableRunSuite(false);
			var testCase:TestCase = _runningTestCases.shift();
			testCase.run(_accessor, _result);
			new WaitAndRun(testCase.isFinished, runNextTestCase, null, 1800);
		}
	}	
}