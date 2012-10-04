package socialGrid.models {
  import flash.events.Event;
  
  import socialGrid.core.Locator;
  import socialGrid.models.content.BaseContentVO;
  import socialGrid.models.content.InstagramContentVO;
  import socialGrid.models.content.TwitterContentVO;
  import socialGrid.util.ArrayHelper;
  import socialGrid.util.ContentQuery;
  
  public class ContentModel {
    
    public var contentVOs:Array;
    
    public var removedPostIds:Array;
    
    public function ContentModel() {
       contentVOs = new Array();
       removedPostIds = new Array();
    }
    
    // ADD AND REMOVE
    
    public function addContentVO(contentVO:BaseContentVO):void {
      
      // check to see if it's blacklisted
      if (checkRemovedPostIdsForContentVO(contentVO)) { return; }
      
      contentVOs.push(contentVO);
      Locator.instance.dispatchEvent(new Event('content_added')); 
    }
    
    public function removeContentVOByPostId(postId:String):void {
      
      removedPostIds.push(postId);
      
      var contentVO:BaseContentVO;
      for each (contentVO in contentVOs) {
        if (checkContentVOForPostId(contentVO, postId)) {
          deleteContentVO(contentVO);
          break;
        }
      }
    }
    
    // CHECK IN AND OUT
    
    public function checkoutContentVO(contentVO:BaseContentVO):void {
      contentVO.isActive = true;
    }
    
    public function checkinContentVO(contentVO:BaseContentVO):void {
      contentVO.isActive = false;
      
      // check to see if it's blacklisted
      if (checkRemovedPostIdsForContentVO(contentVO)) {
        deleteContentVO(contentVO);
      }
    }
    
    // GETTERS
    
    public function getNumContentVOs(contentQuery:ContentQuery):int {
      return getContentVOs(contentQuery).length;
    }
    
    public function getContentVO(contentQuery:ContentQuery):BaseContentVO {
      
      var contentVOs:Array = getContentVOs(contentQuery);
      
      while (!contentVOs.length && contentQuery.secondaryParamQueue.length) {
        // try the next one
        contentQuery.parseParams(contentQuery.secondaryParamQueue.shift());
        contentVOs = getContentVOs(contentQuery);
      }
      
      var index:int;
      if (contentQuery.random) {
        index = Math.floor(Math.random() * contentVOs.length);
      } else if (contentQuery.index != -1) {
        index = Math.floor(contentQuery.index);
      } else {
        index = 0;
      }
      var contentVO:BaseContentVO = contentVOs[index];
      return contentVO;
    }
    
    public function getContentVOs(contentQuery:ContentQuery):Array {
      
      var matches:Array = new Array();
      var contentVO:BaseContentVO;
      for each (contentVO in contentVOs) {
        // elimination
        if (
          // active
          (!contentQuery.matchActiveContent && contentVO.isActive) ||
          // content type (single)
          (contentQuery.contentType != 'any' && contentVO.contentType != contentQuery.contentType) ||
          // not type (single)
          (contentQuery.notContentType != 'none' && contentVO.contentType == contentQuery.notContentType) ||
          // size
          (contentQuery.size != 'any' && !contentVO.canDo(contentQuery.size)) ||
          // has been displayed
          (!contentQuery.matchDisplayedContent && contentVO.hasBeenDisplayed)
        ) {
          // match not found
        } else {
          matches.push(contentVO);
        }
      }
      return matches;
    }
    
    public function getContentVOsForLoading(contentType:String):Array {
      return getContentVOs(new ContentQuery({contentType:contentType}));
    }
    
    
    // UTIL
    
    protected function checkRemovedPostIdsForContentVO(contentVO:BaseContentVO):Boolean {
      var clean:Boolean = true;
      var postId:String;
      for each (postId in removedPostIds) {
        if (checkContentVOForPostId(contentVO, postId)) {
          clean = false;
        }
      }
      return !clean;
    }
    
    protected function checkContentVOForPostId(contentVO:BaseContentVO, targetPostId:String):Boolean {
      var postId:String;
      switch (contentVO.contentType) {
        case 'twitter':
          postId = TwitterContentVO(contentVO).postId;
          break;
        case 'instagram':
          postId = InstagramContentVO(contentVO).postId;
          break;
      }
      return postId && postId == targetPostId;
    }
    
    protected function deleteContentVO(contentVO:BaseContentVO):void {
      if (contentVO.isActive) { return; } // can't remove it if it's active
      
      // [(!)] actually remove contentVO, clean up memory
      contentVO.unrender();
      
      ArrayHelper.removeItemFromArray(contentVO, contentVOs);
    }
  }
}