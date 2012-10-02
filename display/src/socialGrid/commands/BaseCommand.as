package socialGrid.commands {
  
	import flash.events.Event;
	import flash.events.EventDispatcher;
  
	import socialGrid.core.Locator;
	
	public class BaseCommand extends EventDispatcher {
		
    public var isExecuting:Boolean;
    
		public function BaseCommand() {}
		
		public function execute(e:Event):void {
			// override in subclass
		}
		
    protected function onComplete():void {
      dispatchEvent(new Event('command_complete'));
    }
    
    protected function onFailure():void {
      dispatchEvent(new Event('command_failure'));
    }
		
		protected function addToPending(e:Event):void {
			Locator.instance.appModel.pendingEventsModel.addPendingEvent(e);
		}
	}
}