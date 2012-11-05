package socialGrid.util {
  
  import flash.filesystem.File;
  
  import socialGrid.models.content.UserImageContentVO;
  import socialGrid.models.content.UserVideoContentVO;
  
  public class UserContentSurvey {
    
    public static function surveyUserImageContent():Array {
      return surveyUserContent('image');
    }
    
    public static function surveyUserVideoContent():Array {
      return surveyUserContent('video');
    }
    
    protected static function surveyUserContent(type:String):Array {
      var userContentVOs:Array = new Array();
      
      // make array of possible sizes
      var possibleSizes:Array = new Array();
      var gridX:int;
      var gridY:int;
      for (gridY = 0; gridY < 3; gridY++) {
        for (gridX = 0; gridX < 5; gridX++) {
          possibleSizes.push((gridX + 1) + 'x' + (gridY + 1));
        }
      }
      
      // determine path to containing folder
      var contentFolder:File;
      switch (type) {
        case 'image':
          contentFolder = File.applicationDirectory.resolvePath('resources/images/');
          break;
        case 'video':
          contentFolder = File.applicationDirectory.resolvePath('resources/videos/');
          break;
        default:
          return userContentVOs;
      }
      
      // find size folders
      var sizeFolders:Array = new Array();
      var file:File;
      for each (file in contentFolder.getDirectoryListing()) {
        if (possibleSizes.indexOf(file.name) != -1) {
          sizeFolders.push(file);
        }
      }
      
      // iterate through size folders, generating content vos
      var sizeFolder:File;
      var userImageContentVO:UserImageContentVO;
      var userVideoContentVO:UserVideoContentVO;
      for each (sizeFolder in sizeFolders) {
        for each (file in sizeFolder.getDirectoryListing()) {
          switch (type) {
            case 'image':
              if (FiletypeHelper.isFilenameImage(file.name)) {
                userImageContentVO = new UserImageContentVO(findSizes(sizeFolder.name));
                userImageContentVO.imageUrl = 'resources/images/' + sizeFolder.name + '/' + file.name;
                userContentVOs.push(userImageContentVO);
              }
              break;
            case 'video':
              if (FiletypeHelper.isFilenameVideo(file.name)) {
                userVideoContentVO = new UserVideoContentVO(findSizes(sizeFolder.name));
                userVideoContentVO.videoUrl = 'resources/videos/' + sizeFolder.name + '/' + file.name;
                userContentVOs.push(userVideoContentVO);
              }
              break;
          }
        }
      }
      
      return userContentVOs;
    }
    
    protected static function findSizes(size:String):Array {
      var sizes:Array = new Array();
      
      var sizeSplit:Array = size.split('x');
      
      var originalGridWidth:int = int(sizeSplit[0]);
      var originalGridHeight:int = int(sizeSplit[1]);
      
      var gridWidth:int = originalGridWidth;
      var gridHeight:Number;
      
      while (gridWidth > 0) {
        gridHeight = gridWidth / originalGridWidth * originalGridHeight;
        if (gridHeight % 1 == 0) {
          sizes.push(gridWidth + 'x' + gridHeight);
        }
        gridWidth--;
      }
      
      return sizes;
    }
  }
}