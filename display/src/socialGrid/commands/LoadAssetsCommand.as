package socialGrid.commands {
  
  import flash.events.Event;
  
  import socialGrid.core.Locator;
  import socialGrid.models.content.UserContentVO;
  import socialGrid.util.assetLoader.AssetLoader;
  import socialGrid.util.assetLoader.ImageAssetLoaderItem;
  
  public class LoadAssetsCommand extends BaseCommand {
    
    protected var assetLoader:AssetLoader;
    
    public function LoadAssetsCommand() {
      init();
    }
    
    private function init():void {
      assetLoader = new AssetLoader();
      assetLoader.addEventListener('asset_loader_complete', assetLoaderCompleteListener);
      assetLoader.addEventListener('asset_loader_failure', assetLoaderFailureListener);
      assetLoader.addEventListener('asset_loader_progress', assetLoaderProgressListener);
    }
    
    override public function execute(e:Event):void {
      
      // user content
      var userContentVO:UserContentVO;
      for each (userContentVO in Locator.instance.appModel.contentModel.getContentVOsForLoading('user')) {
        assetLoader.addLoadItem(new ImageAssetLoaderItem(userContentVO.imageUrl, userContentVO, 'imageData'));
      }
      
      // load em!
      assetLoader.load();
    }
    
    protected function assetLoaderCompleteListener(e:Event):void {
      Locator.instance.appModel.assetsLoaded = true;
      onComplete();
    }
    
    protected function assetLoaderFailureListener(e:Event):void {
      onFailure(); // load fail
    }
    
    protected function assetLoaderProgressListener(e:Event):void {
      Locator.instance.ui.loadingView.setAssetsPercent(assetLoader.loaderItemIndex / assetLoader.loaderItems.length);
    }
  }
}