package socialGrid.models.content {
  
  import flash.display.BitmapData;
  
  public class UserContentVO extends BaseContentVO {
    
    public var imageUrl:String;
    
    public var imageData:BitmapData;
    
    public function UserContentVO(sizes:Array) {
      super();
      contentType = 'user';
      canDoSizes = canDoSizes.concat(sizes);
    }
  }
}