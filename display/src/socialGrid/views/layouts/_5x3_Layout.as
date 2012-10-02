package socialGrid.views.layouts {
  
  import socialGrid.core.Locator;
  import socialGrid.models.content.UserContentVO;
  import socialGrid.util.ContentHelper;
  import socialGrid.util.ContentQuery;
  import socialGrid.views.ContentView;
  
  public class _5x3_Layout extends BaseLayout {
    
    public function _5x3_Layout() {
      
      var userContentVO:UserContentVO = Locator.instance.appModel.contentModel.getContentVO(
        new ContentQuery({ contentType:'user', size:'5x3', index:'random'})
      ) as UserContentVO;
      
      var contentView:ContentView;
      
      contentView = ContentHelper.createNonContentView(
        userContentVO.imageData,
        '5x3',
        1500
      );
      contentView.gridX = 0;
      contentView.gridY = 0;
      contentViews.push(contentView);
      
      if (contentViews.length == 1) {
        hasContent = true;
      }
    }
  }
}