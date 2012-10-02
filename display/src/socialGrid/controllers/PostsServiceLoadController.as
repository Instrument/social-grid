package socialGrid.controllers {
  
  import flash.events.Event;
  import flash.events.IOErrorEvent;
  import flash.net.URLLoader;
  import flash.net.URLRequest;
  import flash.net.URLRequestMethod;
  import flash.net.URLVariables;
  
  import socialGrid.core.Locator;
  import socialGrid.models.posts.BasePostVO;
  import socialGrid.models.posts.InstagramPostVO;
  import socialGrid.models.posts.TwitterPostVO;
  
  public class PostsServiceLoadController {
    
    protected var started:Boolean;
    
    protected var loader:URLLoader;
    protected var reportLoader:URLLoader;
    
    protected var lastTimestamp:int;
    protected var lastId:int;
    
    protected var displayedIds:Array;
    
    protected var isReporting:Boolean;
    protected var pendingReportingIds:Array;
    
    public function PostsServiceLoadController() {
      
      displayedIds = new Array();
      
      loader = new URLLoader();
      loader.addEventListener(Event.COMPLETE, loaderCompleteListener);
      loader.addEventListener(IOErrorEvent.IO_ERROR, loaderErrorListener);
      
      reportLoader = new URLLoader();
      reportLoader.addEventListener(Event.COMPLETE, reportLoaderCompleteListener);
      reportLoader.addEventListener(IOErrorEvent.IO_ERROR, reportLoaderErrorListener);
    }
    
    public function start():void {
      
      started = true;
      
      lastId = -1;
      
      loadPosts();
    }
    
    protected function loadPosts():void {
      loader.load(new URLRequest(Locator.instance.appModel.config.backendRoot + '/get-items?lastid=' + lastId + '&app=application'));
    }
    
    public function addDisplayedIds(ids:Array):void {
      if (!started) { return; }
      
      displayedIds = displayedIds.concat(ids);
      reportDisplayedIds();
    }
    
    protected function reportDisplayedIds():void {
      
      if (isReporting) { return; }
      
      // move displayed ids to pending removal ids
      pendingReportingIds = displayedIds;
      displayedIds = new Array();
      
      var idsString:String = pendingReportingIds.join(',');
      
      var request:URLRequest = new URLRequest(Locator.instance.appModel.config.backendRoot + '/shown-items');
      request.method = URLRequestMethod.POST;
      var variables:URLVariables = new URLVariables();  
      variables.items = idsString;
      request.data = variables;
      reportLoader.load(request);
      
      isReporting = true;
    }
    
    protected function parsePosts(postsObj:Object):void {
      var postObj:Object;
      var postVO:BasePostVO;
      for each (postObj in postsObj) {
        
        //trace('add new ' + postObj.type);
        
        switch (postObj.type) {
          case 'twitter':
            postVO = new TwitterPostVO();
            populateTwitterPostVO(postVO as TwitterPostVO, postObj);
            break;
          case 'instagram':
            postVO = new InstagramPostVO();
            populateInstagramPostVO(postVO as InstagramPostVO, postObj);
            break;
        }
        
        if (!postVO) { continue; }
        
        postVO.normalizeData();
        
        Locator.instance.appModel.postsModel.addLoadedPost(postVO); // add to model
      }
    }
    
    protected function removePosts(postsObj:Object):void {
      var postObj:Object;
      for each (postObj in postsObj) {
        if (postObj.id) {
          Locator.instance.appModel.contentModel.removeContentVOByPostId(postObj.id);
        }
      }
    }
    
    protected function populateTwitterPostVO(twitterPostVO:TwitterPostVO, postObj:Object):void {
      twitterPostVO.postType = 'twitter';
      twitterPostVO.hashtags = [];
      twitterPostVO.postId = postObj.id;
      twitterPostVO.postTimestamp = Number(postObj.updated_at);
      
      twitterPostVO.tweetText = postObj.text;
      twitterPostVO.authorHandle = '@' + postObj.name;
      twitterPostVO.authorName = postObj.name;
    }
    
    protected function populateInstagramPostVO(instagramPostVO:InstagramPostVO, postObj:Object):void {
      instagramPostVO.postType = 'instagram';
      instagramPostVO.hashtags = [];
      instagramPostVO.postId = postObj.id;
      instagramPostVO.postTimestamp = Number(postObj.updated_at);
      
      instagramPostVO.authorHandle = '@' + postObj.name;
      instagramPostVO.caption = postObj.text;
      instagramPostVO.imageUrl = postObj.image;
    }
    
    protected function loaderCompleteListener(e:Event):void {
      
      var serviceObj:Object;
      
      try {
        serviceObj = JSON.parse(loader.data);
      } catch (e:Error) {
        trace('service json parse fail');
        loadPosts();
        return;
      }
      
      if (serviceObj.message == 'success') {
        
        // parse
        if (serviceObj.items) {
          parsePosts(serviceObj.items);
        }
        if (serviceObj.remove) {
          removePosts(serviceObj.remove);
        }
        
        // set last id
        lastId = serviceObj.lastid;
      }
      
      loadPosts();
    }
    
    protected function loaderErrorListener(e:IOErrorEvent):void {
      loadPosts();
    }
    
    protected function reportLoaderCompleteListener(e:Event):void {
      isReporting = false;
      if (displayedIds.length) {
        reportDisplayedIds();
      }
    }
    
    protected function reportLoaderErrorListener(e:IOErrorEvent):void {
      isReporting = false;
      displayedIds = displayedIds.concat(pendingReportingIds);
      if (displayedIds.length) {
        reportDisplayedIds();
      }
    }
  }
}