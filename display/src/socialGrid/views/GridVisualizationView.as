package socialGrid.views {
  
  import flash.display.Sprite;
  import flash.events.Event;
  
  import socialGrid.core.Locator;
  import socialGrid.util.ContentColors;
  import socialGrid.views.contentViews.BaseContentView;
  
  public class GridVisualizationView extends Sprite {
    
    public function GridVisualizationView() {
      addEventListener(Event.ENTER_FRAME, gridStatusFrameListener);
    }
    
    protected function gridStatusFrameListener(e:Event):void {
      graphics.clear();
      var gridX:int;
      var gridY:int;
      var transitionView:TransitionView;
      var contentView:BaseContentView;
      for (gridY = 0; gridY < 3; gridY++) {
        for (gridX = 0; gridX < 5; gridX++) {
          
          transitionView = Locator.instance.ui.gridView.getTransitionViewAt(gridX, gridY);
          if (transitionView.isTransitioning) {
            with (graphics) {
              beginFill(0xffff00, 0.5);
              drawRect(256 * gridX, 256 * gridY, 256, 256);
              endFill();
            }
          }
          
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
            
            if (gridX == contentView.gridX && gridY == contentView.gridY && contentView.contentVO) {
              var typeColor:uint = ContentColors.getColorByType(contentView.contentVO.contentType);
              with (graphics) {
                beginFill(0xffffff, 1);
                drawRect(256 * gridX, 256 * gridY, 20, 20);
                endFill();
                beginFill(typeColor, 1);
                drawRect(256 * gridX + 5, 256 * gridY + 5, 10, 10);
                endFill();
              }
            }
          }
        }
      }
    }
  }
}