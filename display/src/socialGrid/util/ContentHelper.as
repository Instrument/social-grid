package socialGrid.util {
  
  import flash.display.BitmapData;
  
  import socialGrid.core.Locator;
  import socialGrid.models.content.BaseContentVO;
  import socialGrid.models.content.UserVideoContentVO;
  import socialGrid.views.contentViews.BaseContentView;
  import socialGrid.views.contentViews.ImageContentView;
  import socialGrid.views.contentViews.InterstitialContentView;
  import socialGrid.views.contentViews.VideoContentView;
  
  public class ContentHelper {
    
    public static function createInterstitialContentView(bitmapData:BitmapData, size:String):InterstitialContentView {
      var sizeSplit:Array = size.split('x');
      var contentView:InterstitialContentView = new InterstitialContentView(bitmapData);
      contentView.gridWidth = int(sizeSplit[0]);
      contentView.gridHeight = int(sizeSplit[1]);
      return contentView;
    }
    
    public static function createContentViewFromQuery(contentQuery:ContentQuery, size:String):BaseContentView {
      
      var contentVO:BaseContentVO = Locator.instance.appModel.contentModel.getContentVO(contentQuery);
      
      if (!contentVO) { return null; }
      
      // checkout the contentVO so it can't be used twice
      Locator.instance.appModel.contentModel.checkoutContentVO(contentVO);
      
      // make the content view
      var contentView:BaseContentView;
      switch (contentVO.contentType) {
        case 'twitter':
        case 'instagram':
        case 'user_image':
        case 'photobooth_image':
          // make image content view
          contentView = new ImageContentView(contentVO, contentVO.renderedData(size), getDisplayTimeBySize(size));
          break;
        case 'user_video':
          // make video content view
          contentView = new VideoContentView(contentVO, contentVO.renderedData(size));
          break;
      }
      
      // set dimensions
      var sizeSplit:Array = size.split('x');
      contentView.gridWidth = int(sizeSplit[0]);
      contentView.gridHeight = int(sizeSplit[1]);
      
      return contentView;
    }
    
    protected static function createContentView(contentQuery:ContentQuery, size:String, displayTime:Number):ImageContentView {
      
      var contentVO:BaseContentVO = Locator.instance.appModel.contentModel.getContentVO(contentQuery);
      if (!contentVO) { return null; }
      
      // checkout the contentVO so it can't be used twice
      Locator.instance.appModel.contentModel.checkoutContentVO(contentVO);
      
      // make the content view
      var sizeSplit:Array = size.split('x');
      var contentView:ImageContentView = new ImageContentView(contentVO, contentVO.renderedData(size), displayTime);
      contentView.gridWidth = int(sizeSplit[0]);
      contentView.gridHeight = int(sizeSplit[1]);
      return contentView;
    }
    
    protected static function createVideoContentView(contentQuery:ContentQuery, size:String):VideoContentView {
      
      var contentVO:BaseContentVO = Locator.instance.appModel.contentModel.getContentVO(contentQuery);
      if (!contentVO) { return null; }
      
      // checkout the contentVO so it can't be used twice
      Locator.instance.appModel.contentModel.checkoutContentVO(contentVO);
      
      // make the content view
      var sizeSplit:Array = size.split('x');
      var contentView:VideoContentView = new VideoContentView(contentVO, contentVO.renderedData(size));
      contentView.gridWidth = int(sizeSplit[0]);
      contentView.gridHeight = int(sizeSplit[1]);
      return contentView;
    }
    
    public static function createNonContentView(bitmapData:BitmapData, size:String, displayTime:Number):ImageContentView {
      // make the content view
      var sizeSplit:Array = size.split('x');
      var contentView:ImageContentView = new ImageContentView(null, bitmapData, displayTime, true);
      contentView.gridWidth = int(sizeSplit[0]);
      contentView.gridHeight = int(sizeSplit[1]);
      return contentView;
    }
    
    public static function destroyContentView(contentView:BaseContentView):void {
      
      // check in the content vo
      if (contentView.contentVO) {
        Locator.instance.appModel.contentModel.checkinContentVO(contentView.contentVO);
      }
      
      // clean up memory
      contentView.dispose();
    }
    
    public static function getDisplayTimeBySize(size:String):Number {
      switch (size) {
        case '1x1':
          return 3000 + Math.random() * 2000;
          break;
        case '2x1':
          return 3000 + Math.random() * 3000;
          break;
        case '2x2':
          return 4000 + Math.random() * 3000;
          break;
        case '2x3':
          return 4000 + Math.random() * 3000;
          break;
        case '3x3':
          return 4000 + Math.random() * 3000;
          break;
        default:
          return 3000 + Math.random() * 2000;
      }
    }
  }
}