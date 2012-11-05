package socialGrid.views.layouts {
  
  import socialGrid.core.Locator;
  import socialGrid.util.ContentHelper;
  import socialGrid.util.ContentQuery;
  import socialGrid.views.contentViews.BaseContentView;
  
  public class _3x3_2x2_1x1s_Layout extends BaseLayout {
    
    public function _3x3_2x2_1x1s_Layout() {
      
      var option3x3pos:int = Math.floor(Math.random() * 2);
      var option2x2pos:int = Math.floor(Math.random() * 2);
      
      var contentView:BaseContentView;
      
      contentView = ContentHelper.createContentViewFromQuery(new ContentQuery({size:'3x3'}), '3x3');
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
      
      contentView = ContentHelper.createContentViewFromQuery(new ContentQuery({size:'2x2'}), '2x2');
      if (contentView) {
        switch (option3x3pos) {
          case 0:
            contentView.gridX = 3;
            break;
          case 1:
            contentView.gridX = 0;
            break;
        }
        switch (option2x2pos) {
          case 0:
            contentView.gridY = 0;
            break;
          case 1:
            contentView.gridY = 1;
            break;
        }
        contentViews.push(contentView);
      }
      
      contentView = ContentHelper.createContentViewFromQuery(new ContentQuery({size:'1x1'}), '1x1');
      if (contentView) {
        switch (option3x3pos) {
          case 0:
            contentView.gridX = 3;
            break;
          case 1:
            contentView.gridX = 0;
            break;
        }
        switch (option2x2pos) {
          case 0:
            contentView.gridY = 2;
            break;
          case 1:
            contentView.gridY = 0;
            break;
        }
        contentViews.push(contentView);
      }
      
      contentView = ContentHelper.createContentViewFromQuery(new ContentQuery({size:'1x1'}), '1x1');
      if (contentView) {
        switch (option3x3pos) {
          case 0:
            contentView.gridX = 4;
            break;
          case 1:
            contentView.gridX = 1;
            break;
        }
        switch (option2x2pos) {
          case 0:
            contentView.gridY = 2;
            break;
          case 1:
            contentView.gridY = 0;
            break;
        }
        contentViews.push(contentView);
      }
      
      if (contentViews.length == 4) {
        hasContent = true;
      }
    }
  }
}