package socialGrid.models {
  
  import flash.filesystem.File;
  
  import socialGrid.models.content.UserContentVO;
  
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
    
    public var assetsModel:AppAssetsModel;
    
    public function AppModel() {
      
      config = new Config();
      
      pendingEventsModel = new PendingEventsModel();
      postsModel = new PostsModel();
      contentModel = new ContentModel();
      
      assetsModel = new AppAssetsModel();
      
      surveyUserContent();
    }
    
    public function surveyUserContent():void {
      
      var possibleSizes:Array = new Array();
      var gridX:int;
      var gridY:int;
      for (gridY = 0; gridY < 3; gridY++) {
        for (gridX = 0; gridX < 5; gridX++) {
          possibleSizes.push((gridX + 1) + 'x' + (gridY + 1));
        }
      }
      
      var imagesFolder:File = File.applicationDirectory.resolvePath('resources/assets/images/');
      
      var sizeFolders:Array = new Array();
      var file:File;
      for each (file in imagesFolder.getDirectoryListing()) {
        if (possibleSizes.indexOf(file.name) != -1) {
          sizeFolders.push(file);
        }
      }
      
      var sizeFolder:File;
      var userContentVO:UserContentVO;
      for each (sizeFolder in sizeFolders) {
        
        for each (file in sizeFolder.getDirectoryListing()) {
          
          if (isFilenameImage(file.name)) {
            
            userContentVO = new UserContentVO([sizeFolder.name]);
            userContentVO.imageUrl = 'resources/assets/images/' + sizeFolder.name + '/' + file.name;
            
            contentModel.addContentVO(userContentVO);
          }
        }
      }
    }
    
    public function isFilenameImage(filename:String):Boolean {
      var allowedExtensions:Array = ['.jpg', '.jpeg', '.png', '.gif', '.bmp'];
      var extension:String;
      for each (extension in allowedExtensions) {
        if (filename.toLowerCase().substr(filename.length - extension.length, extension.length) == extension) {
          return true;
        }
      }
      return false;
    }
  }
}