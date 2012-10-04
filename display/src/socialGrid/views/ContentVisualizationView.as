package socialGrid.views {
  
  import flash.display.Shape;
  import flash.display.Sprite;
  import flash.events.Event;
  
  import socialGrid.core.Locator;
  import socialGrid.models.content.BaseContentVO;
  import socialGrid.models.posts.BasePostVO;
  import socialGrid.util.ContentQuery;
  
  public class ContentVisualizationView extends Sprite {
    
    protected var postsCanvas:Shape;
    protected var contentCanvas:Shape;
    
    public function ContentVisualizationView() {
      
      postsCanvas = new Shape();
      addChild(postsCanvas);
      
      contentCanvas = new Shape();
      addChild(contentCanvas);
      
      addEventListener(Event.ENTER_FRAME, contentVisualizationFrameListener);
    }
    
    protected function updateDisplay():void {
      
      // for iterating
      var placeholderX:Number;
      var placeholderY:Number;
      var statusColor1:uint;
      var statusColor2:uint;
      var typeColor:uint;
      
      var postVO:BasePostVO;
      
      placeholderX = 0;
      placeholderY = 0;
      postsCanvas.graphics.clear();
      for each(postVO in Locator.instance.appModel.postsModel.postVOs) {
        switch (postVO.postType) {
          case 'twitter':
            typeColor = 0x2dcfff;
            break;
          case 'instagram':
            typeColor = 0xff632d;
            break;
        }
        
        with (postsCanvas.graphics) {
          beginFill(typeColor, 1);
          drawRect(placeholderX, placeholderY, 20, 10);
          drawCircle(placeholderX + 5, placeholderY + 5, 4);
          endFill();
          
          beginFill(typeColor, 1);
          drawCircle(placeholderX + 5, placeholderY + 5, 3);
          endFill();
        }
        
        placeholderY += 20;
        if (placeholderY > 768 - 40) {
          placeholderY = 0;
          placeholderX += 40;
        }
      }
      
      contentCanvas.x = postsCanvas.x + postsCanvas.width + 40;
      
      var contentVOs:Array = Locator.instance.appModel.contentModel.getContentVOs(new ContentQuery(
        {matchActiveContent:true, matchDisplayedContent:true}
      ));
      
      var contentVO:BaseContentVO;
      
      placeholderX = 0;
      placeholderY = 0;
      contentCanvas.graphics.clear();
      for each(contentVO in contentVOs) {
        switch (contentVO.contentType) {
          case 'twitter':
            typeColor = 0x2dcfff;
            break;
          case 'instagram':
            typeColor = 0xff632d;
            break;
          case 'user':
            typeColor = 0x822dff;
            break;
        }
        
        if (contentVO.hasBeenDisplayed) {
          statusColor1 = 0x000000;
        } else {
          statusColor1 = 0xffffff;
        }
        
        if (contentVO.isActive) {
          statusColor2 = 0x00ff00;
        } else {
          statusColor2 = 0xffffff;
        }
        
        with (contentCanvas.graphics) {
          beginFill(typeColor, 1);
          drawRect(placeholderX, placeholderY, 20, 10);
          drawCircle(placeholderX + 5, placeholderY + 5, 3);
          drawCircle(placeholderX + 15, placeholderY + 5, 3);
          endFill();
          
          beginFill(statusColor1, 1);
          drawCircle(placeholderX + 5, placeholderY + 5, 2);
          endFill();
          
          beginFill(statusColor2, 1);
          drawCircle(placeholderX + 15, placeholderY + 5, 2);
          endFill();
        }
        
        placeholderY += 20;
        if (placeholderY > 768 - 40) {
          placeholderY = 0;
          placeholderX += 40;
        }
      }
      
      // update bkg
      graphics.clear();
      with (graphics) {
        beginFill(0xffffff, 0.75);
        drawRect(contentCanvas.x, 0, contentCanvas.x + contentCanvas.width, 768);
        endFill();
      }
      
    }
    
    protected function contentVisualizationFrameListener(e:Event):void {
      updateDisplay();
    }
  }
}