package socialGrid.models {
  
  import flash.events.Event;
  import flash.events.EventDispatcher;
  
  import socialGrid.core.Locator;
  
  public class PendingEventsModel extends EventDispatcher {
    
    protected var _eventsQueue:Array;
    
    public function PendingEventsModel() {
      _eventsQueue = new Array();
    }
    
    public function addPendingEvent(e:Event):void {
      _eventsQueue.push(e);
    }
    
    public function dispatchPendingEvent():void {
      var e:Event;
      if (hasEvents) {
        e = _eventsQueue.pop();
        Locator.instance.dispatchEvent(e.clone());
      }
    }
    
    public function get hasEvents():Boolean {
      return _eventsQueue.length > 0;
    }
  }
}