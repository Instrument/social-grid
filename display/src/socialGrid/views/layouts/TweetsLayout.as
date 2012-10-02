package socialGrid.views.layouts {
  
  import socialGrid.core.Locator;
  import socialGrid.util.ContentHelper;
  import socialGrid.views.ContentView;
  
  public class TweetsLayout extends BaseLayout {
    
    public function TweetsLayout() {
      
      var twitterOrNot:Boolean = true;
      
      var gridX:int;
      var gridY:int;
      var contentView:ContentView;
      for (gridY = 0; gridY < 3; gridY++) {
        for (gridX = 0; gridX < 5; gridX++) {
          
          if (twitterOrNot) {
            contentView = ContentHelper.createContentView({size:'1x1', displayTime:4000, contentType:'twitter', index:'random'});
          } else {
            contentView = ContentHelper.createContentView({size:'1x1', displayTime:4000, notType:'twitter', index:'random'});
          }
          
          twitterOrNot = !twitterOrNot;
          
          if (contentView) {
            contentView.gridX = gridX;
            contentView.gridY = gridY;
            contentViews.push(contentView);
          }
        }
      }
      
      if (contentViews.length == 15) {
        hasContent = true;
      }
    }
  }
}