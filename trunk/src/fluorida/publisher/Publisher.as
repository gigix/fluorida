package fluorida.publisher {
	import fluorida.framework.TestResult;

	public class Publisher {
		public static function create(configString:String) : Publisher {
			// create HTTP publisher based on config
			return new ScreenPublisher();
		}
		
		public function publish(result:TestResult) : void {
			publishXML(result.toXml());
		}
		
		protected function publishXML(xml:XML) : void {
			throw new Error("This function should never be invoked.");
		}
	}
}