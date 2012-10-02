package socialGrid.models.programs {
  
  import flash.events.TimerEvent;
  import flash.utils.Timer;
  
  import socialGrid.core.Locator;
  
  public class RandomProgram extends BaseProgram {
    
    protected var programTimer:Timer;
    protected var programTimerFinished:Boolean;
    
    public function RandomProgram() {
      programType = 'random';
      
      programTimer = new Timer(15000, 1);
      programTimer.addEventListener(TimerEvent.TIMER_COMPLETE, programTimerListener);
    }
    
    override public function init(params:Object = null):void {
      super.init(params);
      programTimer.reset();
      programTimerFinished = false;
    }
    
    override public function checkReadyToStart():void {
      if (Locator.instance.contentDisplayController.getNumTilesOpen() >= 1) {
        start();
      }
    }
    
    override public function checkReadyToFinish():void {
      if (programTimerFinished) {
        finish();
      }
    }
    
    override protected function start():void {
      super.start();
      programTimer.start();
    }
    
    protected function programTimerListener(e:TimerEvent):void {
      programTimerFinished = true;
    }
  }
}