package socialGrid.models.programs {
  import flash.events.Event;
  import flash.events.EventDispatcher;
  
  import socialGrid.core.Locator;
  
  public class BaseProgram extends EventDispatcher {
    
    public var programType:String;
    
    public var status:String; // either active or waiting
    
    public function BaseProgram() {}
    
    public function init(params:Object = null):void {
      status = 'waiting';
    }
    
    public function checkReadyToStart():void {
      // override in subclass
    }
    
    public function checkReadyToFinish():void {
      // override in subclass
    }
    
    protected function start():void {
      // override in subclass to add functionality
      status = 'active';
    }
    
    protected function finish():void {
      // override in subclass to add functionality
      Locator.instance.contentCycleController.onCurrentProgramFinished();
    }
  }
}