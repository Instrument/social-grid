package socialGrid.models.content {
  
  import flash.display.BitmapData;
  import flash.utils.Dictionary;
  
  import socialGrid.util.ContentRenderer;
  
  public class BaseContentVO {
    
    public var contentType:String;
    
    public var isActive:Boolean; // whether this content is currently being displayed or in line to be displayed
    
    public var timesDisplayed:Array; // times this content has been displayed. array length works as a counter for times displayed
    
    protected var canDoSizes:Array;
    protected var renderedDataDictionary:Dictionary;
    
    public function BaseContentVO() {
      canDoSizes = new Array();
      renderedDataDictionary = new Dictionary();
      timesDisplayed = new Array();
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
    
    public function get numTimesDisplayed():int {
      return timesDisplayed.length;
    }
    
    /*
    public function get hasBeenDisplayed():Boolean {
      return Boolean(timesDisplayed.length);
    }
    */
  }
}