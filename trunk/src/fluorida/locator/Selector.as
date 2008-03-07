package fluorida.locator {
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;

	public class Selector {
		public static function parse(desc:String) : Selector {
			var simpleSelectorPattern:RegExp = /^\w+$/;
			var typeSelectorPattern:RegExp = /^css=(\w+)$/;
			var attributeSelectorPattern:RegExp = /^css=(\w+)\[(\w+)=[\"|\'](.+)[\"|\']\]/;
			
			if(simpleSelectorPattern.test(desc)) {
				return new SimpleSelector(desc);
			} else if(typeSelectorPattern.test(desc)) {
				return new TypeSelector(typeSelectorPattern.exec(desc)[1]);
			} else if(attributeSelectorPattern.test(desc)) {
				var matches:Array = attributeSelectorPattern.exec(desc);
				return new AttributeSelector(matches[1], matches[2], matches[3]);
			} else {
				throw new Error("Invalid selector description: " + desc);
			}
		}
		
		public function select(container:DisplayObjectContainer) : Array {
			var result:Array = new Array();
			recursiveSelect(container, result);
			return result;
		}
		
		private function recursiveSelect(container:DisplayObjectContainer, result:Array) : void {
			for(var cursor:int = 0; cursor < container.numChildren; cursor++) {
				var child:DisplayObject = container.getChildAt(cursor);
				if(match(child)) {
					result.push(child);
				}
				var subContainer:DisplayObjectContainer = child as DisplayObjectContainer;
				if(subContainer == null) {
					continue;	
				}
				recursiveSelect(subContainer, result);
			}
		}
		
		public function match(element:DisplayObject) : Boolean {
			throw new Error("This function should never be invoked.");
		}
	}
}