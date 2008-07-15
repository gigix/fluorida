package fluorida.util
{
	import mx.utils.StringUtil;
	
	public class CommandStringUtil
	{
		public function CommandStringUtil()
		{
		}
		
		public static function buildCommandArray( commandString : String ) : Array {
			return commandString.split("|").map(trim).filter(notEmpty);
		}
		
		public static function getUsefulRows(content:String) : Array {
			return content.split("\n").map(trim).filter(notEmpty).filter(notComment);
		}
		
		private static function notEmpty(element:*, index:int, arr:Array) : Boolean {
            return (element as String).length > 0;
        }
		
		private static function trim(element:*, index:int, arr:Array) : String {
            return StringUtil.trim(element as String);
        }
		
		private static function notComment(element:*, index:int, arr:Array) : Boolean {
            return (element as String).charAt(0) != "#";
        }
	}
}