package socialGrid.util {
  import flash.display.BitmapData;
  
  public class VideoMetadata {
    
    public var width:Number;
    public var height:Number;
    public var duration:Number;
    public var firstFrame:BitmapData;
    
    public function VideoMetadata(metadata:Object) {
      width = metadata.width;
      height = metadata.height;
      duration = metadata.duration;
    }
  }
}