package socialGrid.models {
  
  import socialGrid.util.UserContentSurvey;
  
  public class AppModel {
    
    // config
    public var config:Config;
    
    // states
    public var configLoaded:Boolean;
    public var dataLoaded:Boolean;
    public var assetsLoaded:Boolean;
    public var initialMediaLoaded:Boolean;
    public var appReady:Boolean;
    
    // models
    public var pendingEventsModel:PendingEventsModel;
    
    public var postsModel:PostsModel;
    public var contentModel:ContentModel;
    
    public function AppModel() {
      
      config = new Config();
      
      pendingEventsModel = new PendingEventsModel();
      postsModel = new PostsModel();
      contentModel = new ContentModel();
      
      // survey user content
      contentModel.addContentVOs(UserContentSurvey.surveyUserImageContent());
      contentModel.addContentVOs(UserContentSurvey.surveyUserVideoContent());
    }
  }
}