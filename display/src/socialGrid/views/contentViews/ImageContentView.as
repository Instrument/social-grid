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
  
  public class ImageContentView extends BaseContentView {
    
    public var displayTime:Number; // amount of time the content must display for
    
    public var isInterstitialPiece:Boolean; // whether it's part of an incoming interstitial
    
    protected var displayTimer:Timer;
    
    public function ImageContentView(contentVO:BaseContentVO, bitmapData:BitmapData, displayTime:Number, cloneData:Boolean = false) {
      
      super(contentVO, bitmapData, cloneData);
      
      contentViewType = 'image';
      
      this.displayTime = displayTime;
      
      displayTimer = new Timer(displayTime, 1);
      displayTimer.addEventListener(TimerEvent.TIMER_COMPLETE, displayTimerCompleteListener);
    }
    
    override public function getTimeUntilFinished():Number {
      return displayTime - (new Date().time - timeStarted);
    }
    
    override public function dispose():void {
      super.dispose();
      displayTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, displayTimerCompleteListener);
    }
    
    override protected function startDisplay():void {
      super.startDisplay();
      displayTimer.start();
    }
    
    protected function displayTimerCompleteListener(e:TimerEvent):void {
      onDisplayComplete();
    }
  }
}