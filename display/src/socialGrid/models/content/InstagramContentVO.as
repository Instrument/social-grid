package socialGrid.models.content {
  
  import flash.display.BitmapData;
  
  import socialGrid.models.posts.InstagramPostVO;
  
  public class InstagramContentVO extends BaseContentVO {
    
    public var postId:String;
    public var authorHandle:String;
    public var caption:String;
    public var imageData:BitmapData;
    
    public function InstagramContentVO(postVO:InstagramPostVO) {
      super();
      contentType = 'instagram';
      canDoSizes = canDoSizes.concat(['1x1', '2x2']);
      
      postId = postVO.postId;
      authorHandle = postVO.authorHandle;
      caption = postVO.caption;
      imageData = postVO.imageData.clone();
    }
  }
}