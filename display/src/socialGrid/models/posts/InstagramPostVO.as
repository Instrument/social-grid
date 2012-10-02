package socialGrid.models.posts {
  
  import flash.display.BitmapData;

  public class InstagramPostVO extends BasePostVO {
    
    public var authorHandle:String;
    public var caption:String;
    public var imageUrl:String;
    public var imageData:BitmapData;
    
    public function InstagramPostVO() {}
    
    override public function dispose():void {
      if (imageData) {
        imageData.dispose();
      }
    }
  }
}