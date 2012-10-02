package socialGrid.commands {
  
  // import flash classes
  import flash.events.Event;
  
  import socialGrid.core.Locator;
  import socialGrid.util.ContentQuery;
  
  public class LoadInitialMediaCommand extends BaseCommand {
    
    protected var minNum1x1:int;
    
    public function LoadInitialMediaCommand() {
      //
    }
    
    override public function toString():String { return "LoadInitialMediaCommand"; }
    
    override public function execute(e:Event):void {
      
      minNum1x1 = 50;
      
      // start loading media
      if (Locator.instance.appModel.config.pullSocialDirectly) {
        Locator.instance.postsDirectLoadController.start(); // starts loading posts directly
      } else {
        Locator.instance.postsServiceLoadController.start(); // starts loading posts from service
      }
      
      // start recruiting posts
      Locator.instance.postRecruitmentController.start(); // starts selecting posts to be used as content
      
      // if there are already enough assets
      var num1x1:int = Locator.instance.appModel.contentModel.getNumContentVOs(new ContentQuery({size:'1x1'}));
      if (num1x1 >= minNum1x1) {
        Locator.instance.ui.loadingView.setInitialMediaPercent(1);
        onEnoughPosts();
        return;
      }
      
      // start listening for more
      Locator.instance.addEventListener('content_added', contentAddedListener);
      
      // set initial media percent
      Locator.instance.ui.loadingView.setInitialMediaPercent(num1x1 / minNum1x1);
    }
    
    protected function onEnoughPosts():void {
      
      Locator.instance.appModel.initialMediaLoaded = true;
      onComplete();
    }
    
    protected function contentAddedListener(e:Event):void {
      var num1x1:int = Locator.instance.appModel.contentModel.getNumContentVOs(new ContentQuery({size:'1x1'}));
      Locator.instance.ui.loadingView.setInitialMediaPercent(num1x1 / minNum1x1);
      
      if (num1x1 >= minNum1x1) {
        Locator.instance.removeEventListener('content_added', contentAddedListener);
        Locator.instance.ui.loadingView.setInitialMediaPercent(1);
        onEnoughPosts();
        return;
      }
    }
  }
}