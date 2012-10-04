package socialGrid.views {
  
  import flash.display.Sprite;

  public class UI extends Sprite {
    
    public var loadingView:AppLoadingView;
    
    public var gridView:GridView;
    
    public function UI() {
      
      loadingView = new AppLoadingView();
      addChild(loadingView);
      
      gridView = new GridView();
      addChild(gridView);
      
      // show debug view
      //showDebugView();
      
      // show content visualization view
      //showContentVisualizationView();
    }
    
    public function hideLoadingView():void {
      if (loadingView.parent == this) {
        removeChild(loadingView);
      }
    }
    
    public function showTestView():void {
      addChild(new TestView());
    }
    
    protected function showDebugView():void {
      addChild(new DebugView());
    }
    
    protected function showContentVisualizationView():void {
      addChild(new ContentVisualizationView());
    }
  }
}