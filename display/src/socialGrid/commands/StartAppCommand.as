package socialGrid.commands {
  
  // import flash classes
  import socialGrid.core.Locator;
  
  import flash.events.Event;
  
  public class StartAppCommand extends BaseCommand {
    
    public function StartAppCommand() {}
    
    override public function toString():String { return "StartAppCommand"; }
    
    override public function execute(e:Event):void {
      
      Locator.instance.ui.loadingView.setLoadingViewFinishedCallback(onLoadingViewFinished);
    }
    
    protected function onLoadingViewFinished():void {
      
      // test
      //Locator.instance.ui.doTest();
      
      //return;
      
      // start cycling content
      Locator.instance.contentCycleController.start();
      
      // starts displaying content
      Locator.instance.contentDisplayController.start();
      
      Locator.instance.appModel.appReady = true;
      onComplete();
    }
  }
}