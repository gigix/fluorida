package fluorida.action {
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	
	import mx.containers.TitleWindow;
	import mx.controls.Alert;
	import mx.controls.Button;
	import mx.core.IChildList;
	import mx.core.UIComponent;

	public class ClosePopup extends Action {
		protected override function doRun(args:Array) : void {
			var popupContainer:IChildList = (_accessor.getApplication().root as IChildList);
			var topDisplayObject:DisplayObject = popupContainer.getChildAt( popupContainer.numChildren - 1 );
			if(topDisplayObject is Alert){
				var alert:Alert = topDisplayObject as Alert;
				closeAlertWindow(alert,args);
			}else if(topDisplayObject is TitleWindow){
				var titleWindow:TitleWindow = topDisplayObject as TitleWindow;
				closeTitleWindow(titleWindow,args);
			}else{
				closeCustomWindow(topDisplayObject,args);
			}
		}	
		
		private function closeAlertWindow(alert:Alert, args:Array):void{
			var alertForm:UIComponent = (alert.getChildAt(0) as UIComponent);
			for(var index:Number = 1; index < alertForm.numChildren; index++){
				var alertChild:UIComponent = (alertForm.getChildAt(index) as UIComponent);
				if(alertChild.toString().indexOf(args[0].toString().toUpperCase()) != -1)
				{
					alertChild.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
					break;
				}
			}
		}
		
		private function closeTitleWindow(titleWindow:TitleWindow, args:Array):void{
				if(args[0]=="closeButton" 
					&& titleWindow.showCloseButton){
					var titleBar:UIComponent = (titleWindow.rawChildren.getChildAt(titleWindow.rawChildren.numChildren -1) as UIComponent);
					var closeButton:UIComponent = titleBar.getChildAt(titleBar.numChildren - 1) as UIComponent;
					closeButton.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
				}else{
					closeCustomWindow(titleWindow,args);
				}
		}
		
		private function closeCustomWindow(topDisplayObject:DisplayObject, args:Array):void{
			throw new Error("I don't know how to operate custom component");
		}
		
	}	
}