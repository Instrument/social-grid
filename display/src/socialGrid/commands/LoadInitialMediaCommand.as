package socialGrid.commands {
  
  // import flash classes
  import flash.events.Event;
  
  import socialGrid.core.Locator;
  import socialGrid.util.ContentQuery;
  
  public class LoadInitialMediaCommand extends BaseCommand {
    
    protected var minNum1x1:int; // the minimum number of 1x1 content that must be loaded into the app before it can start
    
    public function LoadInitialMediaCommand() {
      minNum1x1 = 60;
    }
    
    override public function execute(e:Event):void {
      
      // start loading media
      if (Locator.instance.appModel.config.pullSocialDirectly) {
        Locator.instance.postsDirectLoadController.start(); // starts loading posts directly
      } else {
        Locator.instance.postsServiceLoadController.start(); // starts loading posts from service
      }
      
      // start recruiting posts
      Locator.instance.postRecruitmentController.start(); // starts selecting posts to be used as content
      
      // check number of 1x1 content
      var num1x1:int = Locator.instance.appModel.contentModel.getNumContentVOs(new ContentQuery({size:'1x1'}));
      if (num1x1 >= minNum1x1) {
        
        // already enough
        Locator.instance.ui.loadingView.setInitialMediaPercent(1);
        onEnoughPosts();
        
      } else {
        
        // start listening for more
        Locator.instance.addEventListener('content_added', contentAddedListener);
        
        // set initial media percent
        Locator.instance.ui.loadingView.setInitialMediaPercent(num1x1 / minNum1x1);
      }
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
      }
    }
  }
}