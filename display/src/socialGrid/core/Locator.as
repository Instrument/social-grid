package socialGrid.core {
  
  import flash.events.EventDispatcher;
  
  import socialGrid.controllers.AppController;
  import socialGrid.controllers.ContentCycleController;
  import socialGrid.controllers.ContentDisplayController;
  import socialGrid.controllers.PhotoboothImageSurveyController;
  import socialGrid.controllers.PostRecruitmentController;
  import socialGrid.controllers.PostsDirectLoadController;
  import socialGrid.controllers.PostsServiceLoadController;
  import socialGrid.models.AppModel;
  import socialGrid.views.UI;
  
  public class Locator extends EventDispatcher {
    
    private static var _instance:Locator;
    
    public var appModel:AppModel;
    
    public var appController:AppController;
    public var postsDirectLoadController:PostsDirectLoadController;
    public var postsServiceLoadController:PostsServiceLoadController;
    
    public var postRecruitmentController:PostRecruitmentController;
    
    public var photoboothImageSurveyController:PhotoboothImageSurveyController;
    
    public var contentDisplayController:ContentDisplayController;
    public var contentCycleController:ContentCycleController;
    
    public var ui:UI;
    
    public function Locator(s:SingletonEnforcer) {
      if (!s) { throw new Error('Singleton Class'); }
    }
    
    public static function get instance():Locator {
      if (!_instance) {
        _instance = new Locator(new SingletonEnforcer);
        
        _instance.appModel = new AppModel();
        
        _instance.appController = new AppController();
        _instance.postsDirectLoadController = new PostsDirectLoadController();
        _instance.postsServiceLoadController = new PostsServiceLoadController();
        
        _instance.postRecruitmentController = new PostRecruitmentController();
        
        _instance.photoboothImageSurveyController = new PhotoboothImageSurveyController();
        
        _instance.contentDisplayController = new ContentDisplayController();
        _instance.contentCycleController = new ContentCycleController();
      }
      return _instance;
    }
  }
}

internal class SingletonEnforcer {}