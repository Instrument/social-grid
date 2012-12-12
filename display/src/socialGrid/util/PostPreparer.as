package socialGrid.util {
  
  import flash.display.Bitmap;
  import flash.display.BitmapData;
  import flash.display.Loader;
  import flash.events.Event;
  import flash.events.EventDispatcher;
  import flash.events.IOErrorEvent;
  import flash.net.URLRequest;
  
  import socialGrid.models.posts.BasePostVO;
  import socialGrid.models.posts.InstagramPostVO;
  import socialGrid.models.posts.TwitterPostVO;
  
  import socialGrid.views.templates.Instagram1x1Template;
  import socialGrid.views.templates.Twitter1x1Template;

  public class PostPreparer extends EventDispatcher {
    
    public var postVO:BasePostVO;
    
    protected var imageLoader:Loader;
    protected var currentImageLoaderCompleteCallback:Function;
    protected var currentImageLoaderErrorCallback:Function;
    
    public function PostPreparer() {
      
      imageLoader = new Loader();
      imageLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, imageIOErrorListener);
      imageLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, imageLoadComplete);
    }
    
    public function preparePost(postVO:BasePostVO):void {
      this.postVO = postVO;
      switch (true) {
        case postVO is TwitterPostVO:
          prepareTwitterPost();
          break;
        case postVO is InstagramPostVO:
          prepareInstagramPost();
          break;
      }
    }
    
    protected function prepareTwitterPost():void {
      var twitterPostVO:TwitterPostVO = postVO as TwitterPostVO;
      dispatchEvent(new Event('post_prepared')); // needs no preparing (no images to load, etc)
    }
    
    protected function prepareInstagramPost():void {
      currentImageLoaderCompleteCallback = onInstagramImageLoad;
      currentImageLoaderErrorCallback = onInstagramImageError;
      imageLoader.load(new URLRequest(InstagramPostVO(postVO).imageUrl));
    }
    
    protected function onInstagramImageLoad():void {
      var instagramPostVO:InstagramPostVO = postVO as InstagramPostVO;
      instagramPostVO.imageData = Bitmap(imageLoader.content).bitmapData;
      dispatchEvent(new Event('post_prepared'));
    }
    
    protected function onInstagramImageError():void {
      dispatchEvent(new Event('post_prepare_fail'));
    }
    
    protected function imageLoadComplete(e:Event):void {
      if (currentImageLoaderCompleteCallback != null) {
        currentImageLoaderCompleteCallback.apply();
      }
      currentImageLoaderCompleteCallback = null;
      currentImageLoaderErrorCallback = null;
    }
    
    protected function imageIOErrorListener(e:IOErrorEvent):void {
      if (currentImageLoaderErrorCallback != null) {
        currentImageLoaderErrorCallback.apply();
      }
      currentImageLoaderCompleteCallback = null;
      currentImageLoaderErrorCallback = null;
    }
  }
}