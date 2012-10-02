package socialGrid.views {
  
  import flash.display.Sprite;
  
  import socialGrid.core.Locator;

  public class UI extends Sprite {
    
    public var loadingView:AppLoadingView;
    
    public var gridView:GridView;
    
    public function UI() {
      
      loadingView = new AppLoadingView();
      addChild(loadingView);
      
      gridView = new GridView();
      addChild(gridView);
    }
    
    public function hideLoadingView():void {
      if (loadingView.parent == this) {
        removeChild(loadingView);
      }
    }
    
    public function doTest():void {
      addChild(new TestView());
    }
  }
}