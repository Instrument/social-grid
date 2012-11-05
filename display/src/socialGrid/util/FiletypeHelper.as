package socialGrid.util {
  
  public class FiletypeHelper {
    
    public function FiletypeHelper() {}
    
    public static function isFilenameImage(filename:String):Boolean {
      var allowedExtensions:Array = ['.jpg', '.jpeg', '.png', '.gif', '.bmp'];
      var extension:String;
      for each (extension in allowedExtensions) {
        if (filename.toLowerCase().substr(filename.length - extension.length, extension.length) == extension) {
          return true;
        }
      }
      return false;
    }
    
    public static function isFilenameVideo(filename:String):Boolean {
      var allowedExtensions:Array = ['.flv', '.f4v', '.mp4', '.m4v', '.mov'];
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