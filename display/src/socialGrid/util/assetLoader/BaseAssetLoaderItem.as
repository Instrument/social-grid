package socialGrid.util.assetLoader {
  
  public class BaseAssetLoaderItem {
    
    public var loaderType:String;
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