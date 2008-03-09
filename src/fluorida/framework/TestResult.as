package fluorida.framework {
	public class TestResult {
		private var _testSuite:TestSuite;
		private var _errors:Array = new Array();		
		private var _failures:Array = new Array();		
		
		public function TestResult(testSuite:TestSuite) {
			_testSuite = testSuite;
		}
		
		public function addError(testCase:TestCase, cause:Error) : void {
			_errors.push(new TestFailure(testCase, cause));
		}
		
		public function addFailure(testCase:TestCase, cause:AssertionError) : void {
			_failures.push(new TestFailure(testCase, cause));	
		}
		
		public function getErrors() : Array {
			return _errors;
		}
		
		public function getFailures() : Array {
			return _failures;
		}
		
		public function getUnsuccessfulCases() : Array {
			return _errors.concat(_failures);
		}
		
		public function isSuccessful() : Boolean {
			return getUnsuccessfulCases().length == 0;
		}
		
		public function getTestSuite() : TestSuite {
			return _testSuite;
		}
		
		public function toString() : String {
			var result:String = "Total: " + _testSuite.countTestCases();
			result += ", Run: " + _testSuite.countRunTests();
			result += ", Error: " + _errors.length;
			result += ", Failure: " + _failures.length;
			return result;
		}
	}	
}