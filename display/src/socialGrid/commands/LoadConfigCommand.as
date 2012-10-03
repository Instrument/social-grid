package socialGrid.commands {
	
	// import flash classes
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	import socialGrid.core.Locator;
	
	public class LoadConfigCommand extends BaseCommand {
		
		protected var _dataLoader:URLLoader;
		
		public function LoadConfigCommand() {
			init();
		}
		
		private function init():void {
			_dataLoader = new URLLoader();
			_dataLoader.addEventListener(Event.COMPLETE, dataLoaderCompleteListener);
			_dataLoader.addEventListener(IOErrorEvent.IO_ERROR, dataLoaderErrorListener);
		}
		
		override public function execute(e:Event):void {
      _dataLoader.load(new URLRequest("resources/config.xml"));
		}
		
		protected function dataLoaderCompleteListener(e:Event):void {
			var xml:XML;
			try {
				xml = XML(_dataLoader.data);
			} catch (e:Error) {
				// parse fail
				return;
			}
			
			// parse config
			Locator.instance.appModel.config.parseConfigXml(xml);
      
      // init loading screen (now that config colors are loaded)
      Locator.instance.ui.loadingView.init();
			
			Locator.instance.appModel.configLoaded = true;
			onComplete();
		}
		
		protected function dataLoaderErrorListener(e:IOErrorEvent):void {
      onFailure(); // load fail
		}
	}
}