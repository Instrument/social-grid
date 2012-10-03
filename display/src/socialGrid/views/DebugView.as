package socialGrid.views {
  
  import flash.display.Sprite;
  import flash.events.Event;
  
  import socialGrid.core.Locator;
  
  public class DebugView extends Sprite {
    
    public function DebugView() {
      addEventListener(Event.ENTER_FRAME, gridStatusFrameListener);
    }
    
    protected function gridStatusFrameListener(e:Event):void {
      graphics.clear();
      var gridX:int;
      var gridY:int;
      var contentView:ContentView;
      for (gridY = 0; gridY < 3; gridY++) {
        for (gridX = 0; gridX < 5; gridX++) {
          contentView = Locator.instance.contentDisplayController.getContentViewAt(gridX, gridY);
          if (!contentView) {
            with (graphics) {
              beginFill(0xff0000, 0.5);
              drawRect(256 * gridX, 256 * gridY, 256, 256);
              endFill();
            }
          } else {
            if (contentView.hasDisplayed) {
              with (graphics) {
                beginFill(0x00ff00, 0.5);
                drawRect(256 * gridX, 256 * gridY, 256, 256);
                endFill();
              }
            } else {
              with (graphics) {
                beginFill(0x0000ff, 0.5);
                drawRect(256 * gridX, 256 * gridY, 256, 256);
                endFill();
              }
            }
          }
        }
      }
    }
  }
}