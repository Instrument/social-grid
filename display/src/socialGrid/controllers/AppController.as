package socialGrid.controllers {
  
  import flash.events.Event;
  import flash.utils.Dictionary;
  
  import socialGrid.commands.BaseCommand;
  import socialGrid.commands.InitAppCommand;
  import socialGrid.commands.LoadAssetsCommand;
  import socialGrid.commands.LoadInitialMediaCommand;
  import socialGrid.commands.LoadConfigCommand;
  import socialGrid.commands.StartAppCommand;
  import socialGrid.core.Locator;

  public class AppController {
    
    protected var commandsByEvent:Dictionary;
    
    public function AppController() {
    
      commandsByEvent = new Dictionary();
      
      registerCommand(InitAppCommand, 'init_app');
      registerCommand(LoadConfigCommand, 'load_config');
      registerCommand(LoadAssetsCommand, 'load_assets');
      registerCommand(LoadInitialMediaCommand, 'load_initial_media');
      registerCommand(StartAppCommand, 'start_app');
    }
    
    protected function registerCommand(commandClass:Class, eventType:String):void {
      
      var command:BaseCommand = new commandClass();
      command.addEventListener('command_complete', commandCompleteListener);
      command.addEventListener('command_failure', commandFailureListener);
      commandsByEvent[eventType] = command;
      
      Locator.instance.addEventListener(eventType, commandListener);
    }
    
    protected function commandListener(e:Event):void {
      
      var command:BaseCommand = commandsByEvent[e.type];
      
      if (!command.isExecuting) {
        trace("executing command: " + command);
        command.execute(e);
      } else {
        //trace("command is already executing: " + command);
      }
    }
    
    protected function commandCompleteListener(e:Event):void {
      
      //trace("command complete: " + e.target);
      
      if (Locator.instance.appModel.pendingEventsModel.hasEvents) {
        Locator.instance.appModel.pendingEventsModel.dispatchPendingEvent();
      }
    }
    
    protected function commandFailureListener(e:Event):void {
      //trace("command failure: " + e.target);
    }
  }
}