package socialGrid.controllers {
  
  import flash.events.Event;
  import flash.events.TimerEvent;
  import flash.utils.Timer;
  
  import socialGrid.core.Locator;
  import socialGrid.models.posts.BasePostVO;
  import socialGrid.models.posts.InstagramPostVO;
  import socialGrid.models.posts.TwitterPostVO;
  import socialGrid.util.DateHelper;
  import socialGrid.util.PostsLoader;
  
  public class PostsDirectLoadController {
    
    protected var loadTimer:Timer;
    public var postsLoaders:Array;
    protected var loadIndex:int;
    
    public function PostsDirectLoadController() {
      
      loadIndex = 0;
      
      postsLoaders = new Array();
      
      loadTimer = new Timer(1000);
      loadTimer.addEventListener(TimerEvent.TIMER, loadTimerListener);
    }
    
    public function start():void {
      
      // setup here
      var hashtag:String;
      for each (hashtag in Locator.instance.appModel.config.twitterHashtags) {
        makePostsLoader('twitter', hashtag);
      }
      
      if (Locator.instance.appModel.config.instagramAccessToken) {
        for each (hashtag in Locator.instance.appModel.config.instagramHashtags) {
          makePostsLoader('instagram', hashtag);
        }
      }
      
      loadNext();
      loadTimer.start();
    }
    
    protected function makePostsLoader(postType:String, hashtag:String):void {
      var postsLoader:PostsLoader = new PostsLoader(postType, hashtag);
      postsLoaders.push(postsLoader);
      postsLoader.addEventListener('posts_loader_complete', postsLoaderCompleteListener);
    }
    
    protected function loadNext():void {
      var postsLoader:PostsLoader = postsLoaders[loadIndex];
      postsLoader.loadPosts();
      
      loadIndex++;
      if (loadIndex > postsLoaders.length - 1) {
        loadIndex = 0;
      }
    }
    
    protected function parsePosts(postType:String, data:*):void {
      var postsObj:Object;
      switch (postType) {
        case 'twitter':
          try {
            postsObj = JSON.parse(data).results;
          } catch (e:Error) {
            trace('twitter json parse fail');
          }
          break;
        case 'instagram':
          try {
            postsObj = JSON.parse(data).data;
          } catch (e:Error) {
            trace('instagram json parse fail');
          }
          break;
      }
      
      var postObj:Object;
      var postVO:BasePostVO;
      for each (postObj in postsObj) {
        switch (postType) {
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
    
    protected function populateTwitterPostVO(twitterPostVO:TwitterPostVO, postObj:Object):void {
      twitterPostVO.postType = 'twitter';
      twitterPostVO.hashtags = postObj.text.match(/#\w+/g);
      twitterPostVO.postId = 'twitter_' + postObj.id;
      twitterPostVO.postTimestamp = DateHelper.parseTwitterDateTime(postObj.created_at);
      
      twitterPostVO.tweetText = postObj.text;
      twitterPostVO.authorHandle = '@' + postObj.from_user;
      twitterPostVO.authorName = postObj.from_user_name;
    }
    
    protected function populateInstagramPostVO(instagramPostVO:InstagramPostVO, postObj:Object):void {
      
      instagramPostVO.postType = 'instagram';
      instagramPostVO.hashtags = postObj.tags;
      instagramPostVO.postId = 'instagram_' + postObj.id;
      instagramPostVO.postTimestamp = uint(postObj.created_time) * 1000;
      
      instagramPostVO.authorHandle = '@' + postObj.user.username; // also post.caption.from.username
      instagramPostVO.caption = postObj.caption ? postObj.caption.text : null;
      instagramPostVO.imageUrl = postObj.images.standard_resolution.url;
    }
    
    protected function loadTimerListener(e:TimerEvent):void {
      loadNext();
    }
    
    protected function postsLoaderCompleteListener(e:Event):void {
      var postsLoader:PostsLoader = e.currentTarget as PostsLoader;
      parsePosts(postsLoader.postType, postsLoader.data);
    }
  }
}