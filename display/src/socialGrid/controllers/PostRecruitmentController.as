package socialGrid.controllers {
  
  import flash.events.Event;
  import flash.events.TimerEvent;
  import flash.utils.Timer;
  
  import socialGrid.core.Locator;
  import socialGrid.models.content.BaseContentVO;
  import socialGrid.models.content.InstagramContentVO;
  import socialGrid.models.content.TwitterContentVO;
  import socialGrid.models.posts.BasePostVO;
  import socialGrid.models.posts.InstagramPostVO;
  import socialGrid.models.posts.TwitterPostVO;
  import socialGrid.util.ArrayHelper;
  import socialGrid.util.PostPreparer;
  
  public class PostRecruitmentController {
    
    protected var recruitmentTimer:Timer;
    
    protected var currentPostTypeNeeded:String;
    
    protected var postPreparers:Array;
    
    public function PostRecruitmentController() {
      
      recruitmentTimer = new Timer(100);
      recruitmentTimer.addEventListener(TimerEvent.TIMER, recruitmentTimerListener);
      
      postPreparers = new Array();
    }
    
    public function start():void {
      recruitmentTimer.start();
    }
    
    
    // ACTIONS
    
    protected function choosePostType():void {
      switch (currentPostTypeNeeded) {
        case null:
        case 'instagram':
          currentPostTypeNeeded = 'twitter';
          break;
        case 'twitter':
          currentPostTypeNeeded = 'instagram';
          break;
      }
    }
    
    protected function recruitPost():void {
      
      choosePostType();
      
      var postVO:BasePostVO = Locator.instance.appModel.postsModel.checkoutPost(currentPostTypeNeeded);
      if (!postVO) { return; }
      
      var postPreparer:PostPreparer = makePostPreparer();
      postPreparer.preparePost(postVO);
    }
    
    protected function graduatePost(postVO:BasePostVO):void {
      
      var contentVO:BaseContentVO;
      
      switch (postVO.postType) {
        case 'twitter':
          contentVO = new TwitterContentVO(postVO as TwitterPostVO);
          break;
        case 'instagram':
          contentVO = new InstagramContentVO(postVO as InstagramPostVO);
          break;
      }
      
      Locator.instance.appModel.contentModel.addContentVO(contentVO);
    }
    
    
    // CREATE AND DESTROY
    
    protected function makePostPreparer():PostPreparer {
      var postPreparer:PostPreparer = new PostPreparer();
      postPreparers.push(postPreparer);
      postPreparer.addEventListener('post_prepared', postPreparedListener);
      postPreparer.addEventListener('post_prepare_fail', postPrepareFailListener);
      return postPreparer;
    }
    
    public function destroyPostPreparer(postPreparer:PostPreparer):void {
      ArrayHelper.removeItemFromArray(postPreparer, postPreparers);
      postPreparer.removeEventListener('post_prepared', postPreparedListener);
      postPreparer.removeEventListener('post_prepare_fail', postPrepareFailListener);
    }
    
    
    // EVENT LISTENERS
    
    protected function recruitmentTimerListener(e:TimerEvent):void {
      recruitPost();
    }
    
    protected function postPreparedListener(e:Event):void {
      var postPreparer:PostPreparer = e.currentTarget as PostPreparer;
      var postVO:BasePostVO = postPreparer.postVO;
      
      graduatePost(postVO);
      
      destroyPostPreparer(postPreparer);
      Locator.instance.appModel.postsModel.destroyPost(postVO);
    }
    
    protected function postPrepareFailListener(e:Event):void {
      var postPreparer:PostPreparer = e.currentTarget as PostPreparer;
      var postVO:BasePostVO = postPreparer.postVO;
      
      destroyPostPreparer(postPreparer);
      Locator.instance.appModel.postsModel.checkinPost(postVO);
    }
  }
}