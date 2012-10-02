package socialGrid.models.content {
  
  import socialGrid.models.posts.TwitterPostVO;
  
  public class TwitterContentVO extends BaseContentVO {
    
    public var postId:String;
    public var tweetText:String;
    public var authorHandle:String;
    public var authorName:String;
    public var postDateTime:String;
    
    public function TwitterContentVO(postVO:TwitterPostVO) {
      super();
      contentType = 'twitter';
      canDoSizes = canDoSizes.concat(['1x1', '3x3']);
      
      postId = postVO.postId;
      tweetText = postVO.tweetText;
      authorHandle = postVO.authorHandle;
      authorName = postVO.authorName;
      postDateTime = postVO.postDateTime;
    }
  }
}