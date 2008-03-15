package fluorida.publisher {
    import mx.controls.Alert;
	import mx.rpc.http.HTTPService;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.events.FaultEvent;
	
	public class HttpPublisher extends Publisher {
		private var _url:String;
	
		public function HttpPublisher(url:String) {
			_url = url;
		}
		
		protected override function publishXML(xml:XML) : void {
			var http:HTTPService = new HTTPService();
			http.method = "POST";
			http.url = _url;
			http.addEventListener(ResultEvent.RESULT, onSuccessful);
			http.addEventListener(FaultEvent.FAULT, onError);
			
			var parameters:Object = {data: xml.toXMLString(), authenticity_token: "08636d4bb04dee6871dd01cc4b86a559d5e1cf08"};
			http.send(parameters);
		}		

		private function onSuccessful(event:*) : void {
			Alert.show("Result has been published to " + _url);
		}
		
		private function onError(event:*) : void {
			Alert.show(event["fault"]);
		}
	}
}