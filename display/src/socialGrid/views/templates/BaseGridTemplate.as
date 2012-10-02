package socialGrid.views.templates {
  
  import flash.display.Sprite;
  
  import socialGrid.models.content.BaseContentVO;
  
  public class BaseGridTemplate extends Sprite {
    
    public var gridWidth:int;
    public var gridHeight:int;
    
    public function BaseGridTemplate() {}
    
    public function populate(contentVO:BaseContentVO):void {}
  }
}