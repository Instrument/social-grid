package socialGrid.views.layouts {
  
  import socialGrid.core.Locator;
  import socialGrid.util.ContentHelper;
  import socialGrid.util.ContentQuery;
  import socialGrid.views.ContentView;
  
  public class _3x3_2x3_Layout extends BaseLayout {
    
    public function _3x3_2x3_Layout() {
      
      var option3x3pos:int = Math.floor(Math.random() * 2);
      
      var contentView:ContentView;
      
      contentView = ContentHelper.createContentView(
        new ContentQuery({size:'3x3', index:'random'}),
        '3x3',
        ContentHelper.getDisplayTimeBySize('3x3')
      );
      if (contentView) {
        switch (option3x3pos) {
          case 0:
            contentView.gridX = 0;
            break;
          case 1:
            contentView.gridX = 2;
            break;
        }
        contentView.gridY = 0;
        contentViews.push(contentView);
      }
      
      contentView = ContentHelper.createContentView(
        new ContentQuery({size:'2x3', index:'random'}),
        '2x3',
        ContentHelper.getDisplayTimeBySize('2x3')
      );
      if (contentView) {
        switch (option3x3pos) {
          case 0:
            contentView.gridX = 3;
            break;
          case 1:
            contentView.gridX = 0;
            break;
        }
        contentView.gridY = 0;
        contentViews.push(contentView);
      }
      
      if (contentViews.length == 2) {
        hasContent = true;
      }
    }
  }
}