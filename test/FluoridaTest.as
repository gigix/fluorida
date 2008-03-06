package {
	import flash.net.URLLoader;
	import flash.net.URLRequest;
    import flash.events.Event;

    import flexunit.framework.TestCase;
    import flexunit.framework.TestSuite;
	
	import fluorida.util.TestLoader;
	
	public class FluoridaTest extends TestCase {
     	public function FluoridaTest(methodName:String) {
     		super(methodName);
 		}
     
        public static function suite() : TestSuite {
            var testSuite:TestSuite = new TestSuite();
			testSuite.addTest(new FluoridaTest("testLoadFile"));
			testSuite.addTest(new FluoridaTest("testSplitLine"));
			testSuite.addTest(new FluoridaTest("testLoadTestSuite"));
			testSuite.addTest(new FluoridaTest("testMapAccess"));
			testSuite.addTest(new FluoridaTest("testRegexp"));
            return testSuite;
        }
        
        public function testLoadFile() : void {
        	var request:URLRequest = new URLRequest("sample/suite.fls");
		    var loader:URLLoader = new URLLoader();
		    loader.addEventListener("complete", addAsync(verifyLoader, 1000, {loader: loader}));
		    loader.load(request);
		}
		
		private function verifyLoader(event:Event, data:Object) : void {
			var loader:URLLoader = data.loader as URLLoader;
		    assertEquals("sample/success_case.flt\r\nsample/error_case.flt\r\nsample/fail_case.flt", loader.data);
		}
		
		public function testSplitLine() : void {
			var line:String = "|action|arg1|arg2|";	
			var array:Array = line.split("|");
			assertEquals(5, array.length);
			assertEquals("", array[0]);
		}
		
		public function testLoadTestSuite() : void {
			var testLoader:TestLoader = new TestLoader();
			testLoader.addEventListener(TestLoader.COMPLETE, addAsync(verifyTestLoader, 1000, {loader: testLoader}));
			testLoader.load("sample/suite.fls");
		}
		
		private function verifyTestLoader(event:Event, data:Object) : void {
			TestStatics.verifyTestLoader(data.loader);
		}
		
		public function testMapAccess() : void {
			var map:Object = {
				testCase:TestCase,
				testSuite:TestSuite
			};
			assertEquals(TestCase, map['testCase']);	
		}
		
		public function testRegexp() : void {
			assertTrue(new RegExp(".?ell.*$").test("hello"));
		}
	}
}