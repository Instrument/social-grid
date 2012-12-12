package socialGrid.util {
  
  import flash.events.Event;
  import flash.events.EventDispatcher;
  import flash.events.IOErrorEvent;
  import flash.net.URLLoader;
  import flash.net.URLRequest;
  
  import socialGrid.core.Locator;
  
  public class PostsLoader extends EventDispatcher {
    
    public var loader:URLLoader;
    public var isLoading:Boolean;
    
    public var postType:String;
    public var hashtag:String;
    
    public var data:*;
    
    public function PostsLoader(postType:String, hashtag:String) {
      
      this.postType = postType;
      this.hashtag = hashtag;
      
      loader = new URLLoader();
      loader.addEventListener(Event.COMPLETE, loaderCompleteListener);
      loader.addEventListener(IOErrorEvent.IO_ERROR, loaderErrorListener);
    }
    
    public function loadPosts():void {
      if (isLoading) { return; }
      
      var loadUrl:String;
      
      switch (postType) {
        case 'twitter':
          loadUrl = 'http://search.twitter.com/search.json?q=%23' + hashtag;
          break;
        case 'instagram':
          loadUrl = 'https://api.instagram.com/v1/tags/' + hashtag + '/media/recent?access_token=' + Locator.instance.appModel.config.instagramAccessToken + '&count=30';
          break;
      }
      
      loader.load(new URLRequest(loadUrl));
      isLoading = true;
    }
    
    protected function loaderCompleteListener(e:Event):void {
      
      data = loader.data;
      
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