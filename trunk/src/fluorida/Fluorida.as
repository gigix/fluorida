package fluorida {
	import flash.events.Event;
    import mx.core.Application;

	import fluorida.framework.TestSuite;
	import fluorida.util.TestLoader;
	
	public class Fluorida {
		private var _application:Application;
		private var _testLoader:TestLoader;
		
		public function Fluorida(application:Application) {
			_application = application;
		}
		
		public function runTestSuite(url:String) : void {
			_testLoader = new TestLoader();
			_testLoader.addEventListener(TestLoader.COMPLETE, suiteLoaded);
			_testLoader.load(url);
		}
		
		private function suiteLoaded(event:Event) : void {
			var testSuite:TestSuite = _testLoader.getSuite();
			testSuite.setApplication(_application);
			testSuite.run();
		}
	}	
}