package socialGrid.views {
  
  import flash.display.Shape;
  import flash.display.Sprite;
  import flash.events.Event;
  
  import socialGrid.core.Locator;
  import socialGrid.models.content.BaseContentVO;
  import socialGrid.models.content.UserImageContentVO;
  import socialGrid.models.content.UserVideoContentVO;
  import socialGrid.models.posts.BasePostVO;
  import socialGrid.util.ContentColors;
  import socialGrid.util.ContentQuery;
  import socialGrid.util.PostsLoader;
  
  public class ContentVisualizationView extends Sprite {
    
    protected var canvases:Array;
    
    protected var postLoadersCanvas:Shape;
    protected var postsCanvas:Shape;
    protected var contentCanvas:Shape;
    
    public function ContentVisualizationView() {
      
      canvases = new Array();
      
      postLoadersCanvas = new Shape();
      addChild(postLoadersCanvas);
      canvases.push(postLoadersCanvas);
      
      postsCanvas = new Shape();
      addChild(postsCanvas);
      canvases.push(postsCanvas);
      
      contentCanvas = new Shape();
      addChild(contentCanvas);
      canvases.push(contentCanvas);
      
      addEventListener(Event.ENTER_FRAME, contentVisualizationFrameListener);
    }
    
    protected function updateDisplay():void {
      
      // for iterating
      var placeholderX:Number;
      var placeholderY:Number;
      var statusColor1:uint;
      var statusColor2:uint;
      var typeColor:uint;
      
      // post loaders
      var postLoader:PostsLoader;
      placeholderX = 0;
      placeholderY = 0;
      postLoadersCanvas.graphics.clear();
      for each(postLoader in Locator.instance.postsDirectLoadController.postsLoaders) {
        switch (postLoader.postType) {
          case 'twitter':
            typeColor = 0x2dcfff;
            break;
          case 'instagram':
            typeColor = 0xff632d;
            break;
        }
        if (postLoader.isLoading) {
          statusColor1 = 0xffff00;
        } else {
          statusColor1 = 0x000000;
        }
        
        with (postLoadersCanvas.graphics) {
          beginFill(typeColor, 1);
          drawRect(placeholderX, placeholderY, 10, 10);
          endFill();
          
          beginFill(statusColor1, 1);
          drawRect(placeholderX + 10, placeholderY, 10, 10);
          endFill();
        }
        
        placeholderY += 20;
        if (placeholderY > 768 - 40) {
          placeholderY = 0;
          placeholderX += 40;
        }
      }
      
      // post vos
      var postVO:BasePostVO;
      placeholderX = 0;
      placeholderY = 0;
      postsCanvas.graphics.clear();
      for each(postVO in Locator.instance.appModel.postsModel.postVOs) {
        switch (postVO.postType) {
          case 'twitter':
            typeColor = ContentColors.getColorByType('twitter');
            break;
          case 'instagram':
            typeColor = ContentColors.getColorByType('instagram');
            break;
        }
        
        with (postsCanvas.graphics) {
          beginFill(typeColor, 1);
          drawRect(placeholderX, placeholderY, 10, 10);
          endFill();
        }
        
        placeholderY += 20;
        if (placeholderY > 768 - 40) {
          placeholderY = 0;
          placeholderX += 40;
        }
      }
      
      // content vos
      var contentVOs:Array = Locator.instance.appModel.contentModel.getContentVOs(new ContentQuery(
        {matchActiveContent:true, favorLeastDisplayedContent:false}
      ));
      var contentVO:BaseContentVO;
      var userImageContentVO:UserImageContentVO;
      var userVideoContentVO:UserVideoContentVO;
      placeholderX = 0;
      placeholderY = 0;
      contentCanvas.graphics.clear();
      for each(contentVO in contentVOs) {
        typeColor = ContentColors.getColorByType(contentVO.contentType);
        switch (contentVO.contentType) {
          case 'user_image':
            userImageContentVO = contentVO as UserImageContentVO;
            if (!userImageContentVO.imageData) {
              continue;
            }
            break;
          case 'user_video':
            userVideoContentVO = contentVO as UserVideoContentVO;
            if (!userVideoContentVO.metadata) {
              continue;
            }
            break;
        }
        
        if (contentVO.numTimesDisplayed > 0) {
          statusColor1 = 0x000000;
        } else {
          statusColor1 = 0xffffff;
        }
        
        if (contentVO.isActive) {
          statusColor2 = 0xffff00;
        } else {
          statusColor2 = 0x000000;
        }
        
        with (contentCanvas.graphics) {
          beginFill(typeColor, 1);
          drawRect(placeholderX, placeholderY, 10, 10);
          endFill();
          
          beginFill(statusColor1, 1);
          drawRect(placeholderX + 5, placeholderY, 5, 10);
          endFill();
          
          beginFill(statusColor2, 1);
          drawRect(placeholderX + 10, placeholderY, 10, 10);
          endFill();
        }
        
        placeholderY += 20;
        if (placeholderY > 768 - 40) {
          placeholderY = 0;
          placeholderX += 40;
        }
      }
      
      // update bkg
      var canvas:Shape;
      placeholderX = 0;
      graphics.clear();
      for each (canvas in canvases) {
        canvas.x = placeholderX + 20;
        canvas.y = 20;
        with (graphics) {
          beginFill(0xffffff, 0.75);
          drawRect(canvas.x - 5, canvas.y - 5, canvas.width + 10, canvas.height + 10);
          endFill();
        }
        placeholderX = canvas.x + canvas.width;
      }
    }
    
    protected function contentVisualizationFrameListener(e:Event):void {
      updateDisplay();
    }
  }
}