package socialGrid.models.programs {
  
  import socialGrid.core.Locator;
  import socialGrid.views.TransitionView;
  
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
        
        // if the content view for insterstitial is still waiting to be displayed
        if (Locator.instance.contentCycleController.currentContentViewForInterstitial) {
          
          // tell the grid view to display the content view that belongs to this interstitial
          Locator.instance.contentDisplayController.displayActualInterstitialView();
        } else {
          
          // it's done
          finish();
        }
      }
    }
    
    override protected function start():void {
      Locator.instance.contentCycleController.chooseInterstitial();
      
      Locator.instance.ui.videoPlaybackView.endCurrentVideos();
      
      var transitionView:TransitionView;
      var gridX:int;
      var gridY:int;
      for (gridY = 0; gridY < 3; gridY++) {
        for (gridX = 0; gridX < 5; gridX++) {
          transitionView = Locator.instance.ui.gridView.getTransitionViewAt(gridX, gridY);
          if (transitionView.contentView && transitionView.contentView.contentViewType == 'video') {
            //trace('transitioning to video when interstitial is starting');
          }
        }
      }
      
      super.start();
    }
    
    override protected function finish():void {
      Locator.instance.contentCycleController.chooseTransitionDirection();
      super.finish();
    }
  }
}