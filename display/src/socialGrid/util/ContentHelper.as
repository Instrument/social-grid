package socialGrid.util {
  
  import flash.display.BitmapData;
  
  import socialGrid.core.Locator;
  import socialGrid.models.content.BaseContentVO;
  import socialGrid.views.ContentView;
  
  public class ContentHelper {
    
    public static function createContentView(contentQuery:ContentQuery, size:String, displayTime:Number):ContentView {
      
      var contentVO:BaseContentVO = Locator.instance.appModel.contentModel.getContentVO(contentQuery);
      if (!contentVO) { return null; }
      
      // checkout the contentVO so it can't be used twice
      Locator.instance.appModel.contentModel.checkoutContentVO(contentVO);
      
      // make the content view
      var sizeSplit:Array = size.split('x');
      var contentView:ContentView = new ContentView(contentVO, contentVO.renderedData(size), displayTime);
      contentView.gridWidth = int(sizeSplit[0]);
      contentView.gridHeight = int(sizeSplit[1]);
      return contentView;
    }
    
    /*
    public static function createBitmapDataContentView(contentVO:BaseContentVO, bitmapData:BitmapData, size:String, displayTime:Number):ContentView {
      
      if (!contentVO) { return null; }
      
      // checkout the contentVO so it can't be used twice
      Locator.instance.appModel.contentModel.checkoutContentVO(contentVO);
      
      // make the content view
      var sizeSplit:Array = size.split('x');
      var contentView:ContentView = new ContentView(contentVO, bitmapData, displayTime);
      contentView.gridWidth = int(sizeSplit[0]);
      contentView.gridHeight = int(sizeSplit[1]);
      return contentView;
    }
    */
    
    public static function createNonContentView(bitmapData:BitmapData, size:String, displayTime:Number):ContentView {
      // make the content view
      var sizeSplit:Array = size.split('x');
      var contentView:ContentView = new ContentView(null, bitmapData, displayTime, true);
      contentView.gridWidth = int(sizeSplit[0]);
      contentView.gridHeight = int(sizeSplit[1]);
      return contentView;
    }
    
    public static function destroyContentView(contentView:ContentView):void {
      
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
          return 2000 + Math.random() * 2000;
          break;
        case '2x1':
          return 2000 + Math.random() * 3000;
          break;
        case '2x2':
          return 3000 + Math.random() * 3000;
          break;
        case '2x3':
          return 4000 + Math.random() * 2000;
          break;
        case '3x3':
          return 4000 + Math.random() * 3000;
          break;
        default:
          return 2000 + Math.random() * 3000;
      }
    }
  }
}