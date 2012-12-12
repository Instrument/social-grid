package socialGrid.views.contentViews {
  
  import flash.display.BitmapData;
  import flash.events.Event;
  import flash.events.EventDispatcher;
  import flash.events.TimerEvent;
  import flash.utils.Timer;
  
  import socialGrid.core.Locator;
  import socialGrid.models.content.BaseContentVO;
  import socialGrid.models.content.InstagramContentVO;
  import socialGrid.models.content.TwitterContentVO;
  
  public class BaseContentView extends EventDispatcher {
    
    public var contentViewType:String;
    
    public var contentVO:BaseContentVO; // content vo
    
    public var bitmapData:BitmapData; // data used to transition the content onto the grid
    protected var cloneData:Boolean; // whether to create a clone of the bitmap data (to be disposed of with this content view)
    
    public var gridX:int; // grid coordinates
    public var gridY:int;
    
    public var gridWidth:int; // grid dimensions
    public var gridHeight:int;
    
    public var hasStarted:Boolean; // whether the content has begun display
    public var hasDisplayed:Boolean; // whether the content has completed display
    
    public var timeStarted:Number; // time content started display
    public var timeFinished:Number; // time content finished display
    
    public var transitionViewCount:int; // number of transition views needed to transition content onto the grid
    
    public function BaseContentView(contentVO:BaseContentVO, bitmapData:BitmapData, cloneData:Boolean = false) {
      
      this.contentVO = contentVO;
      
      this.cloneData = cloneData;
      
      if (cloneData) {
        this.bitmapData = bitmapData.clone();
      } else {
        this.bitmapData = bitmapData;
      }
    }
    
    public function getTimeUntilFinished():Number {
      return Number.POSITIVE_INFINITY; // override in subclass
    }
    
    public function dispose():void {
      // override in subclass to extend functionality
      if (cloneData) {
        bitmapData.dispose();
      } else {
        bitmapData = null;
      }
    }
    
    public function onTransitionViewComplete():void {
      transitionViewCount--;
      
      if (transitionViewCount == 0) {
        startDisplay();
      }
    }
    
    protected function startDisplay():void {
      // override in subclass to extend functionality
      timeStarted = new Date().time;
      hasStarted = true;
      if (contentVO) {
        contentVO.timesDisplayed.push(timeStarted);
      }
    }
    
    protected function onDisplayComplete():void {
      timeFinished = new Date().time;
      hasDisplayed = true;
      dispatchEvent(new Event('content_view_displayed'));
    }
  }
}