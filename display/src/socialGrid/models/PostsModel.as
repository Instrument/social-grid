package socialGrid.models {
  
  import flash.events.Event;
  
  import socialGrid.core.Locator;
  import socialGrid.models.posts.BasePostVO;
  import socialGrid.models.posts.InstagramPostVO;
  import socialGrid.models.posts.TwitterPostVO;
  import socialGrid.util.ArrayHelper;
  import socialGrid.util.DateHelper;
  
  public class PostsModel {
    
    public var loadedPostIds:Array; // ids of all post that have been loaded into the system (to avoid adding duplicates)
    
    public var postVOs:Array; // all posts in the system
    public var pendingPostVOs:Array; // posts that are in the process of being recruited
    
    public function PostsModel() {
      
      postVOs = new Array();
      loadedPostIds = new Array();
      pendingPostVOs = new Array();
    }
    
    public function addLoadedPost(postVO:BasePostVO):void {
      if (loadedPostIds.indexOf(postVO.postId) != -1) { return; }
      
      loadedPostIds.push(postVO.postId); // register id to avoid double loading
      postVOs.push(postVO);
      
      postVOs.sortOn('postTimestamp', Array.DESCENDING); // always put most recent first
      
      Locator.instance.dispatchEvent(new Event('new_posts_added'));
    }
    
    public function checkoutPost(postType:String = null):BasePostVO {
      
      var selectedPostVO:BasePostVO;
      var postVO:BasePostVO;
      for each(postVO in postVOs) {
        if (pendingPostVOs.indexOf(postVO) != -1) { continue; }
        if (postType && postVO.postType != postType) { continue; }
        selectedPostVO = postVO;
        break; // stop iterating after a match is found
      }
      
      pendingPostVOs.push(selectedPostVO); // add to pending
      return selectedPostVO;
    }
    
    public function checkinPost(postVO:BasePostVO):void {
      ArrayHelper.removeItemFromArray(postVO, pendingPostVOs); // remove from pending
    }
    
    public function destroyPost(postVO:BasePostVO):void {
      ArrayHelper.removeItemFromArray(postVO, pendingPostVOs); // remove from pending
      ArrayHelper.removeItemFromArray(postVO, postVOs); // remove from model
      postVO.dispose();
    }
  }
}