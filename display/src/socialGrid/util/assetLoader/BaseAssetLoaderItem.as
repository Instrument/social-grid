package socialGrid.util.assetLoader {
  
  public class BaseAssetLoaderItem {
    
    public var loaderType:Class; // URLLoader for files or Loader for images, etc.
    public var url:String;
    
    public function BaseAssetLoaderItem() {}
    
    public function onLoadSuccess(content:*):void {
      // override in subclass
    }
    
    public function onLoadFailure():void {
      trace('asset load fail: ' + url);
    }
  }
}