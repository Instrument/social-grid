package socialGrid.views {
  
  import flash.display.Sprite;
  import flash.events.MouseEvent;
  
  import socialGrid.core.Locator;
  import socialGrid.views.contentViews.BaseContentView;
  import socialGrid.views.contentViews.ImageContentView;
  
  public class GridInspectorView extends Sprite {
    
    protected var hit:Sprite;
    
    public function GridInspectorView() {
      
      var i:int;
      
      hit = new Sprite();
      addChild(hit);
      with (hit.graphics) {
        beginFill(0xff0000, 0);
        drawRect(0, 0, 1280, 768);
        endFill();
        
        lineStyle(1, 0xff0000, 1);
        
        for (i = 1; i < 5; i++) {
          moveTo(i * 256, 0);
          lineTo(i * 256, 768);
        }
        
        for (i = 1; i < 3; i++) {
          moveTo(0, i * 256);
          lineTo(1280, i * 256);
        }
      }
      hit.addEventListener(MouseEvent.CLICK, hitClickListener);
    }
    
    protected function hitClickListener(e:MouseEvent):void {
      var gridX:int = Math.floor(mouseX / 256);
      var gridY:int = Math.floor(mouseY / 256);
      
      var contentView:BaseContentView = Locator.instance.contentDisplayController.getContentViewAt(gridX, gridY);
      if (!contentView) { return; }
      
      trace(contentView.contentViewType);
      
      var imageContentView:ImageContentView;
      
      switch (contentView.contentViewType) {
        case 'image':
          imageContentView = contentView as ImageContentView;
          trace(imageContentView.bitmapData);
          break;
        case 'interstitial':
          if (Locator.instance.contentCycleController.currentContentViewForInterstitial) {
            trace(Locator.instance.contentCycleController.currentContentViewForInterstitial.contentViewType);
          } else {
            trace('no current interstitial');
          }
          break;
      }
    }
  }
}