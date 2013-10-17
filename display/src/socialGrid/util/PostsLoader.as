package socialGrid.util {
  
  import de.danielyan.twitterAppOnly.TwitterSocket;
  import de.danielyan.twitterAppOnly.TwitterSocketEvent;
  
  import flash.events.Event;
  import flash.events.EventDispatcher;
  import flash.events.IOErrorEvent;
  import flash.net.URLLoader;
  import flash.net.URLRequest;
  
  import socialGrid.core.Locator;
  //import com.adobe.protocols.oauth2.OAuth2;
  
  
  public class PostsLoader extends EventDispatcher {

    public var loader:URLLoader;
    public var isLoading:Boolean;
	public var isReady:Boolean;
    
    public var postType:String;
    public var hashtag:String;
    
    public var data:*;
	
	public var twitterSocket:TwitterSocket;
	
    public function PostsLoader(postType:String, hashtag:String) {

      this.postType = postType;
      this.hashtag = hashtag;
	  
	  if(postType == "twitter"){
		trace("Key:" + Locator.instance.appModel.config.twitterConsumerKey);
		twitterSocket = new TwitterSocket(Locator.instance.appModel.config.twitterConsumerKey, Locator.instance.appModel.config.twitterConsumerSecret);
		twitterSocket.addEventListener(TwitterSocket.EVENT_TWITTER_READY, onTwitterReady);
		twitterSocket.addEventListener(TwitterSocket.EVENT_TWITTER_RESPONSE, onTwitterResponse);
		this.isReady = false;
	  } else {
		loader = new URLLoader();
		loader.addEventListener(Event.COMPLETE, loaderCompleteListener);
		loader.addEventListener(IOErrorEvent.IO_ERROR, loaderErrorListener);
		this.isReady = true;
	  }
    }
	
	private function onTwitterReady(event:Event):void{
		this.isReady = true;
	}
	
	private function onTwitterResponse(response:TwitterSocketEvent):void{
		data = JSON.stringify(response.response);

		// unflag
		isLoading = false;

		dispatchEvent(new Event('posts_loader_complete'));
	}
    
    public function loadPosts():void {
      if (isLoading) { return; }
      
      switch (postType) {
        case 'twitter':
          twitterSocket.request("/1.1/search/tweets.json?q=#" + hashtag);
		  isLoading = true;
          break;
        case 'instagram':
		  var loadUrl:String;
          loadUrl = 'https://api.instagram.com/v1/tags/' + hashtag + '/media/recent?access_token=' + Locator.instance.appModel.config.instagramAccessToken + '&count=30';
		  loader.load(new URLRequest(loadUrl));
		  isLoading = true;
          break;
      }
    }
    
    protected function loaderCompleteListener(e:Event):void {
      
      data = loader.data;
      trace("stagram.");
	  trace(data);
      // unflag
      isLoading = false;
      
      dispatchEvent(new Event('posts_loader_complete'));
    }
    
    protected function loaderErrorListener(e:IOErrorEvent):void {
      // unflag
      isLoading = false;
    }
  }
}