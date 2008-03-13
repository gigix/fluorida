package fluorida.framework {
	import fluorida.action.Action;
	import fluorida.util.Accessor;
	import fluorida.util.ArrayUtil;
	import fluorida.util.WaitAndRun;
	
	public class TestCase {
		private var _commands:Array = new Array();
		private var _runningCommands:Array;
		private var _name:String;
		private var _accessor:Accessor;
		private var _result:TestResult;
		private var _finished:Boolean = false;
		
		public function TestCase(name:String) {
			_name = name;
		}
		
		public function toString() : String {
			return _name;
		}
		
		public function commandsToString() : String {
			var result:String = "";
			for each(var command:Command in _commands) {
				result += (command.toString() + "\n");
			}
			return result;
		}
		
		public function getName() : String {
			return _name;
		}
		
		public function addCommand(command:Command) : void {
			_commands.push(command);
		}
		
		public function getCommands() : Array {
			return _commands;
		}
		
		public function countCommands() : int {
			return _commands.length;
		}
		
		public function isFinished() : Boolean {
			return _finished;
		}
		
		public function addError(cause:Error) : void {
			_result.addError(this, cause);
		}
		
		public function addFailure(cause:AssertionError) : void {
			_result.addFailure(this, cause);
		}
		
		public function run(accessor:Accessor, result:TestResult) : void {
			_accessor = accessor;
			_result = result;
			_runningCommands = ArrayUtil.copy(_commands);
			runNextCommand();	
		}
		
		public function toXml(allFailures:Array) : XML {
			var caseNode:XML = <testcase name={_name} />;
			for each(var failure:TestFailure in allFailures.filter(isMine)) {
				caseNode.appendChild(failure.toXml());
			}
			return caseNode;
		}
		
		private function isMine(failure:TestFailure, index:int, array:Array) : Boolean {
			return failure.test == this;
		}
		
		private function runNextCommand() : void {
			if(_runningCommands.length == 0) {
				_finished = true;
				_accessor.renderResult(_result);
				return;	
			}

			var command:Command = _runningCommands.shift();
			var action:Action = Action.create(this, command, _accessor, runNextCommand);
			action.run();
		}
	}	
}