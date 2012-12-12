package socialGrid.models {
  
  import flash.events.Event;
  
  import socialGrid.core.Locator;
  import socialGrid.models.content.BaseContentVO;
  import socialGrid.models.content.InstagramContentVO;
  import socialGrid.models.content.TwitterContentVO;
  import socialGrid.util.ArrayHelper;
  import socialGrid.util.ContentQuery;
  
  public class ContentModel {
    
    public var contentVOs:Array; // all content
    
    public var removedPostIds:Array; // ids of content to be removed
    
    public function ContentModel() {
       contentVOs = new Array();
       removedPostIds = new Array();
    }
    
    // ADD AND REMOVE
    
    public function addContentVOs(contentVOs:Array):void {
      var contentVO:BaseContentVO;
      for each (contentVO in contentVOs) {
        addContentVO(contentVO, false);
      }
      Locator.instance.dispatchEvent(new Event('content_added')); 
    }
    
    public function addContentVO(contentVO:BaseContentVO, signalContentAdded:Boolean = true):void {
      if (checkRemovedPostIdsForContentVO(contentVO)) { return; } // check to see if it's blacklisted
      contentVOs.push(contentVO);
      if (signalContentAdded) {
        Locator.instance.dispatchEvent(new Event('content_added'));
      }
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
      
      // check to see if it should be removed
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
          (contentQuery.size != 'any' && !contentVO.canDo(contentQuery.size))
        ) {
          // match not found
        } else {
          matches.push(contentVO);
        }
      }
      
      // favor ones displayed the least
      var lowestTimesDisplayed:Number = Number.POSITIVE_INFINITY;
      var lowestTimesDisplayedMatches:Array = new Array();
      if (contentQuery.favorLeastDisplayedContent) {
        for each (contentVO in matches) {
          if (contentVO.numTimesDisplayed < lowestTimesDisplayed) {
            lowestTimesDisplayed = contentVO.numTimesDisplayed;
          }
        }
        for each (contentVO in matches) {
          if (contentVO.numTimesDisplayed == lowestTimesDisplayed) {
            lowestTimesDisplayedMatches.push(contentVO);
          }
        }
        matches = lowestTimesDisplayedMatches;
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
      
      ArrayHelper.removeItemFromArray(contentVO, contentVOs);
    }
  }
}