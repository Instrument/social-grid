package socialGrid.models.content {
  
  import flash.display.BitmapData;
  import flash.utils.Dictionary;
  
  import socialGrid.util.ContentRenderer;
  
  public class BaseContentVO {
    
    public var contentType:String;
    
    public var hasBeenDisplayed:Boolean; // whether this content has been displayed
    public var timeDisplayed:Number; // when this content was displayed
    
    protected var canDoSizes:Array;
    protected var renderedDataDictionary:Dictionary;
    
    public function BaseContentVO() {
      canDoSizes = new Array();
      renderedDataDictionary = new Dictionary();
    }
    
    public function canDo(size:String):Boolean {
      return (canDoSizes.indexOf(size) != -1);
    }
    
    public function renderedData(size:String):BitmapData {
      if (!canDo(size)) { return null; }
      
      if (!renderedDataDictionary[size]) {
        render(size);
      }
      
      return renderedDataDictionary[size];
    }
    
    protected function render(size:String):void {
      if (canDo(size)) {
        renderedDataDictionary[size] = ContentRenderer.renderTemplate(size, this);
      }
    }
    
    public function unrender():void {
      // [(!)] implement this
    }
  }
}