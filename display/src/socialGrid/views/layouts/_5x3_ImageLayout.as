package socialGrid.views.layouts {
  
  import socialGrid.util.ContentHelper;
  import socialGrid.util.ContentQuery;
  import socialGrid.views.contentViews.BaseContentView;
  
  public class _5x3_ImageLayout extends BaseLayout {
    
    public function _5x3_ImageLayout() {
      
      var contentView:BaseContentView;
      
      contentView = ContentHelper.createContentViewFromQuery(new ContentQuery({notContentType:'user_video', size:'5x3'}), '5x3');
      if (contentView) {
        contentView.gridX = 0;
        contentView.gridY = 0;
        contentViews.push(contentView);
      }
      
      if (contentViews.length == 1) {
        hasContent = true;
      }
    }
  }
}