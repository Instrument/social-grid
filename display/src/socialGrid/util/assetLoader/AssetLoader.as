package socialGrid.util.assetLoader {
  
  import flash.display.Loader;
  import flash.events.Event;
  import flash.events.EventDispatcher;
  import flash.events.IOErrorEvent;
  import flash.net.URLLoader;
  import flash.net.URLRequest;
  import flash.utils.Dictionary;
  
  public class AssetLoader extends EventDispatcher {

    protected var loader:Loader;
    protected var urlLoader:URLLoader;
    protected var loaderDictionary:Dictionary;
    
    public var loaderItems:Array;
    public var loaderItemIndex:int;
    protected var isLoading:Boolean;
    
    public function AssetLoader() {
      
      loaderDictionary = new Dictionary();
      
      loader = new Loader();
      loaderDictionary[Loader] = loader;
      loader.contentLoaderInfo.addEventListener(Event.COMPLETE, loaderCompleteListener);
      loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, loaderErrorListener);
      
      urlLoader = new URLLoader();
      loaderDictionary[URLLoader] = urlLoader;
      urlLoader.addEventListener(Event.COMPLETE, urlLoaderCompleteListener);
      urlLoader.addEventListener(IOErrorEvent.IO_ERROR, urlLoaderErrorListener);
      
      loaderItems = new Array();
    }
    
    public function addLoadItem(loadItem:BaseAssetLoaderItem):void {
      if (isLoading) { return; }
      loaderItems.push(loadItem);
    }
    
    public function load():void {
      isLoading = true;
      loaderItemIndex = 0;
      loadNext();
    }
    
    protected function loadNext():void {
      if (loaderItemIndex < loaderItems.length) {
        var loaderItem:BaseAssetLoaderItem = loaderItems[loaderItemIndex];
        loaderDictionary[loaderItem.loaderType].load(new URLRequest(loaderItem.url));
      } else {
        // loading is finished
        loaderItems = new Array(); // [(!)] clean up memory?
        isLoading = false;
        dispatchEvent(new Event('asset_loader_complete'));
      }
    }
    
    protected function loaderCompleteListener(e:Event):void {
      var loaderItem:BaseAssetLoaderItem = loaderItems[loaderItemIndex];
      loaderItem.onLoadSuccess(loader.content);
      loaderItemIndex++;
      dispatchEvent(new Event('asset_loader_progress'));
      loadNext();
    }
    
    protected function loaderErrorListener(e:IOErrorEvent):void {
      var loaderItem:BaseAssetLoaderItem = loaderItems[loaderItemIndex];
      loaderItem.onLoadFailure();
      dispatchEvent(new Event('asset_loader_failure'));
    }
    
    protected function urlLoaderCompleteListener(e:Event):void {
      var loaderItem:BaseAssetLoaderItem = loaderItems[loaderItemIndex];
      loaderItem.onLoadSuccess(urlLoader.data);
      loaderItemIndex++;
      dispatchEvent(new Event('asset_loader_progress'));
      loadNext();
    }
    
    protected function urlLoaderErrorListener(e:IOErrorEvent):void {
      var loaderItem:BaseAssetLoaderItem = loaderItems[loaderItemIndex];
      loaderItem.onLoadFailure();
      dispatchEvent(new Event('asset_loader_failure'));
    }
  }
}