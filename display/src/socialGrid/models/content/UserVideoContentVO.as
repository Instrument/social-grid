package socialGrid.models.content {
  
  import flash.display.BitmapData;
  
  import socialGrid.util.VideoMetadata;
  
  public class UserVideoContentVO extends BaseContentVO {
    
    public var videoUrl:String;
    
    public var metadata:VideoMetadata;
    
    public var firstFrameData:BitmapData;
    
    public function UserVideoContentVO(sizes:Array) {
      super();
      contentType = 'user_video';
      canDoSizes = canDoSizes.concat(sizes);
    }
  }
}