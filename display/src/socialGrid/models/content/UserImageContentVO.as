package socialGrid.models.content {
  
  import flash.display.BitmapData;
  
  public class UserImageContentVO extends BaseContentVO {
    
    public var imageUrl:String;
    
    public var imageData:BitmapData;
    
    public function UserImageContentVO(sizes:Array) {
      super();
      contentType = 'user_image';
      canDoSizes = canDoSizes.concat(sizes);
    }
  }
}