package socialGrid.models.programs {
  
  import socialGrid.core.Locator;
  
  public class InterstitialProgram extends BaseProgram {
    
    public function InterstitialProgram() {
      programType = 'interstitial';
    }
    
    override public function checkReadyToStart():void {
      
      if (Locator.instance.contentDisplayController.getNumTilesOpen() >= 1) {
        start();
      }
    }
    
    override public function checkReadyToFinish():void {
      // if all views are displayed and interstitial
      if (Locator.instance.contentDisplayController.getNumFinishedInterstitialTiles() == 15) {
        finish();
      }
    }
    
    override protected function start():void {
      Locator.instance.contentCycleController.chooseInterstitial();
      super.start();
    }
    
    override protected function finish():void {
      Locator.instance.contentCycleController.chooseTransitionDirection();
      super.finish();
    }
  }
}