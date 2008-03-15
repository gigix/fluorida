package fluorida.publisher {
    import mx.controls.Alert;
	import flash.system.System;

	import fluorida.framework.TestResult;

	public class Publisher {
		public static function create(configString:String) : Publisher {
			var config:XML = new XML(configString);
			var resultUrl:String = config.attribute("postResultTo");
			if(resultUrl == "") {
				return new ScreenPublisher();
			} else {
				return new HttpPublisher(resultUrl);
			}
		}
		
		private var _result:TestResult;
		
		public function publish(result:TestResult) : void {
			_result = result;
			publishXML(result.toXml());
		}
		
		protected function publishXML(xml:XML) : void {
			throw new Error("This function should never be invoked.");
		}
		
		protected function exit(event:*) : void {
			System.exit(_result.getUnsuccessfulCases().length);
		}
		
		protected function publishToScreen(event:*) : void {
			Alert.show(event["fault"]);
			new ScreenPublisher().publish(_result);
		}
	}
}