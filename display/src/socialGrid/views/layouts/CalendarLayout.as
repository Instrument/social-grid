package socialGrid.views.layouts {
  
  import socialGrid.core.Locator;
  import socialGrid.util.ContentHelper;
  import socialGrid.util.ContentQuery;
  import socialGrid.views.ContentView;
  
  public class CalendarLayout extends BaseLayout {
    
    public function CalendarLayout(startIndex:int) {
      
      var numMFNW:int = Locator.instance.appModel.contentModel.getNumContentVOs(
        new ContentQuery({contentType:'mfnw', matchActiveContent:true})
     );
      
      var indexes:Array = new Array();
      var i:int;
      var thisIndex:int;
      for (i = startIndex; i < startIndex + 15; i++) {
        thisIndex = i;
        if (thisIndex > numMFNW - 1) {
          thisIndex -= numMFNW;
        }
        indexes.push(thisIndex);
      }
      
      var indexesIndex:int = 0;
      
      var gridX:int;
      var gridY:int;
      var contentView:ContentView;
      for (gridY = 0; gridY < 3; gridY++) {
        for (gridX = 0; gridX < 5; gridX++) {
          
          contentView = ContentHelper.createContentView(
            new ContentQuery({size:'1x1', contentType:'mfnw', index:indexesIndex}),
            '1x1',
            ContentHelper.getDisplayTimeBySize('1x1')
          );
          if (contentView) {
            contentView.gridX = gridX;
            contentView.gridY = gridY;
            contentViews.push(contentView);
          }
          
          indexesIndex++;
        }
      }
      
      if (contentViews.length == 15) {
        hasContent = true;
      }
    }
  }
}