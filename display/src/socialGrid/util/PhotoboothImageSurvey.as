package socialGrid.util {
  
  import flash.filesystem.File;
  
  import socialGrid.core.Locator;
  
  public class PhotoboothImageSurvey {
    
    protected var imageFilenames:Array; // names of images already reported
    
    public function PhotoboothImageSurvey() {
      imageFilenames = new Array();
    }
    
    public function surveyPhotoboothImages():Array {
      var imageUrls:Array = new Array();
      
      var photoboothFolder:File = File.applicationDirectory.resolvePath(Locator.instance.appModel.config.photoboothFolderPath);
      
      if (!photoboothFolder) {
        trace('cannot find photobooth folder');
        return imageUrls;
      }
      
      var file:File;
      for each (file in photoboothFolder.getDirectoryListing()) {
        if (imageFilenames.indexOf(file.name) == -1 && FiletypeHelper.isFilenameImage(file.name)) {
          imageUrls.push(Locator.instance.appModel.config.photoboothFolderPath + '/' + file.name);
          imageFilenames.push(file.name);
        }
      }
      
      return imageUrls;
    }
  }
}