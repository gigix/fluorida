package fluorida.action {
	import mx.controls.ComboBox;
	import mx.events.DropdownEvent;
	import mx.events.ListEvent; 
	
	public class Select extends Action {
		protected override function doRun(args:Array) : void {
			var dropdown:ComboBox = _accessor.$$(args[0]) as ComboBox;
			dropdown.selectedIndex = parseInt(args[1]);
			
			dropdown.dispatchEvent(new DropdownEvent(DropdownEvent.OPEN));
			dropdown.dispatchEvent(new ListEvent(ListEvent.CHANGE));
			dropdown.dispatchEvent(new DropdownEvent(DropdownEvent.CLOSE));
		}	
	}	
}