package socialGrid.views {
  import flash.display.BitmapData;
  import flash.events.Event;
  import flash.events.EventDispatcher;
  import flash.events.TimerEvent;
  import flash.utils.Timer;
  
  import socialGrid.core.Locator;
  import socialGrid.models.content.BaseContentVO;
  import socialGrid.models.content.InstagramContentVO;
  import socialGrid.models.content.TwitterContentVO;
  
  public class ContentView extends EventDispatcher {
    
    public var contentVO:BaseContentVO;
    public var bitmapData:BitmapData;
    
    public var cloneData:Boolean; // whether the bitmap data is a clone or a direct reference
    
    public var gridX:int;
    public var gridY:int;
    
    public var gridWidth:int;
    public var gridHeight:int;
    
    public var displayTime:Number; // amount of time the content must display for
    
    public var hasStarted:Boolean; // whether the display time has started counting down (false if transition is still happening)
    public var hasDisplayed:Boolean; // whether the content has been on display for the display time
    
    public var timeStarted:Number; // time display time started
    public var timeFinished:Number; // time display time finished
    
    public var isInterstitialPiece:Boolean; // whether it's part of an incoming interstitial
    
    protected var displayTimer:Timer;
    public var transitionViewCount:int;
    
    public function ContentView(contentVO:BaseContentVO, bitmapData:BitmapData, displayTime:Number, cloneData:Boolean = false) {
      
      this.cloneData = cloneData;
      
      this.contentVO = contentVO;
      if (cloneData) {
        this.bitmapData = bitmapData.clone();
      } else {
        this.bitmapData = bitmapData;
      }
      
      this.displayTime = displayTime;
      
      displayTimer = new Timer(displayTime, 1);
      displayTimer.addEventListener(TimerEvent.TIMER_COMPLETE, displayTimerCompleteListener);
    }
    
    public function dispose():void {
      if (cloneData) {
        bitmapData.dispose();
      } else {
        bitmapData = null;
      }
      displayTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, displayTimerCompleteListener);
    }
    
    public function onTransitionViewComplete():void {
      transitionViewCount--;
      if (transitionViewCount == 0) {
        startDisplay();
      }
    }
    
    protected function startDisplay():void {
      timeStarted = new Date().time;
      displayTimer.start();
      hasStarted = true;
      
      if (contentVO && !contentVO.hasBeenDisplayed) {
        contentVO.hasBeenDisplayed = true;
        contentVO.timeDisplayed = timeStarted;
      }
    }
    
    protected function displayTimerCompleteListener(e:TimerEvent):void {
      timeFinished = new Date().time;
      hasDisplayed = true;
      
      dispatchEvent(new Event('content_view_displayed'));
    }
  }
}