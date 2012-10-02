package socialGrid.views.layouts {
  
  public class BaseLayout {
    
    public var contentViews:Array;
    
    public var hasContent:Boolean; // whether or not the layout has its content views assigned
    
    public function BaseLayout() {
      contentViews = new Array();
    }
  }
}