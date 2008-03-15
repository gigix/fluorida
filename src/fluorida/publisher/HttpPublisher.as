package fluorida.publisher {
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
			http.addEventListener(ResultEvent.RESULT, exit);
			http.addEventListener(FaultEvent.FAULT, publishToScreen);
			
			var parameters:Object = {data : xml.toXMLString()};
			http.send(parameters);
		}		
	}
}