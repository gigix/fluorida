package fluorida.util {
	public class ArrayUtil {
		public static function copy(array:Array) : Array {
			return array.map(copyElement);
		}

		private static function copyElement(element:*, index:int, arr:Array) : * {
            return element;
        }
	}
}