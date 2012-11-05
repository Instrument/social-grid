package socialGrid.views {
  
  import flash.display.Sprite;
  import flash.events.Event;
  import flash.events.KeyboardEvent;

  public class UI extends Sprite {
    
    public var loadingView:AppLoadingView;
    
    public var gridView:GridView;
    public var videoPlaybackView:VideoPlaybackView;
    
    public var gridVisualizationView:GridVisualizationView;
    public var contentVisualizationView:ContentVisualizationView;
    public var gridInspectorView:GridInspectorView;
    
    public function UI() {
      
      loadingView = new AppLoadingView();
      addChild(loadingView);
      
      gridView = new GridView();
      addChild(gridView);
      
      videoPlaybackView = new VideoPlaybackView();
      addChild(videoPlaybackView);
      
      addEventListener(Event.ADDED_TO_STAGE, addedToStageListener);
    }
    
    public function hideLoadingView():void {
      if (loadingView.parent == this) {
        removeChild(loadingView);
      }
    }
    
    public function showTestView():void {
      addChild(new TestView());
    }
    
    protected function addedToStageListener(e:Event):void {
      // key listener
      stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDownListener);
    }
    
    protected function keyDownListener(e:KeyboardEvent):void {
      
      //trace(e.keyCode);
      
      var keyCode:uint;
      switch (e.keyCode) {
        case 67: // C
        case 71: // G
        case 73: // I
          keyCode = e.keyCode;
          break;
      }
      
      if (!keyCode) { return; }
      
      e.preventDefault();
      e.stopImmediatePropagation();
      
      switch (keyCode) {
        
        case 67: // C
          // toggle content visualization view
          if (contentVisualizationView) {
            removeChild(contentVisualizationView);
            contentVisualizationView = null;
          } else {
            contentVisualizationView = new ContentVisualizationView();
            addChild(contentVisualizationView);
          }
          break;
        
        case 71: // G
          // toggle grid visualization view
          if (gridVisualizationView) {
            removeChild(gridVisualizationView);
            gridVisualizationView = null;
          } else {
            gridVisualizationView = new GridVisualizationView();
            addChild(gridVisualizationView);
          }
          break;
        case 73: // I
          // toggle grid inspector view
          if (gridInspectorView) {
            removeChild(gridInspectorView);
            gridInspectorView = null;
          } else {
            gridInspectorView = new GridInspectorView();
            addChild(gridInspectorView);
          }
          break;
      }
    }
  }
}