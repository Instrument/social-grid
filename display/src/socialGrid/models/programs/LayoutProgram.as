package socialGrid.models.programs {
  import socialGrid.core.Locator;
  
  public class LayoutProgram extends BaseProgram {
    
    public function LayoutProgram() {
      programType = 'layout';
    }
    
    override public function checkReadyToStart():void {
      if (Locator.instance.contentDisplayController.getNumTilesOpen() == 15) {
        start();
      }
    }
    
    override public function checkReadyToFinish():void {
      // if it has started, it's ready to finish
      finish();
    }
    
    override protected function start():void {
      Locator.instance.contentCycleController.chooseTransitionDirection();
      super.start();
    }
  }
}