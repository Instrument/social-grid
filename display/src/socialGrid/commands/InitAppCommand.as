package socialGrid.commands {
  
	import flash.events.Event;
  
	import socialGrid.core.Locator;
	import socialGrid.models.AppModel;
	
	public class InitAppCommand extends BaseCommand {
		
		public function InitAppCommand() {}
		
		override public function toString():String { return "InitAppCommand"; }
		
		override public function execute(e:Event):void {
			
      if (!Locator.instance.appModel.configLoaded) {
        addToPending(e);
        Locator.instance.dispatchEvent(new Event('load_config'));
        return;
      }
      
      if (!Locator.instance.appModel.assetsLoaded) {
        addToPending(e);
        Locator.instance.dispatchEvent(new Event('load_assets'));
        return;
      }
      
      if (!Locator.instance.appModel.initialMediaLoaded) {
        addToPending(e);
        Locator.instance.dispatchEvent(new Event('load_initial_media'));
        return;
      }
      
      if (!Locator.instance.appModel.appReady) {
        addToPending(e);
        Locator.instance.dispatchEvent(new Event('start_app'));
        return;
      }
      
			onComplete();
		}
	}
}