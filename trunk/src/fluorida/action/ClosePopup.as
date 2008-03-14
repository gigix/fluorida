package fluorida.action {
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	
	import mx.controls.Alert;
	import mx.core.IChildList;
	import mx.core.IFlexDisplayObject;
	import mx.core.UIComponent;
	import mx.managers.PopUpManager;

	public class ClosePopup extends Action {
		protected override function doRun(args:Array) : void {
			var popupContainer:IChildList = (_accessor.getApplication().root as IChildList);
			var topDisplayObject:DisplayObject = popupContainer.getChildAt( popupContainer.numChildren - 1 );
			if(topDisplayObject is Alert){
				var alert:Alert = topDisplayObject as Alert;
				if(alert.buttonFlags == Alert.OK){
					((alert.getChildAt(0) as UIComponent).getChildAt(1) as UIComponent).dispatchEvent(new MouseEvent(MouseEvent.CLICK));
				}
			}
		}	
	}	
}