package socialGrid.commands {
  
  import flash.events.Event;
  
  import socialGrid.core.Locator;
  
  public class StartAppCommand extends BaseCommand {
    
    public function StartAppCommand() {}
    
    override public function execute(e:Event):void {
      Locator.instance.ui.loadingView.setLoadingViewFinishedCallback(onLoadingViewFinished);
    }
    
    protected function onLoadingViewFinished():void {
      
      // show test view
      //Locator.instance.ui.showTestView();
      
      // show debug view
      //Locator.instance.ui.showDebugView();
      
      // start cycling content
      Locator.instance.contentCycleController.start();
      
      // starts displaying content
      Locator.instance.contentDisplayController.start();
      
      Locator.instance.appModel.appReady = true;
      onComplete();
    }
  }
}