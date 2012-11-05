package socialGrid.commands {
  
  import flash.events.Event;
  
  import socialGrid.core.Locator;
  import socialGrid.models.content.UserImageContentVO;
  import socialGrid.models.content.UserVideoContentVO;
  import socialGrid.util.assetLoader.AssetLoader;
  import socialGrid.util.assetLoader.ImageAssetLoaderItem;
  import socialGrid.util.assetLoader.VideoMetadataAssetLoaderItem;
  
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
      
      // user image content
      var userImageContentVO:UserImageContentVO;
      for each (userImageContentVO in Locator.instance.appModel.contentModel.getContentVOsForLoading('user_image')) {
        assetLoader.addLoadItem(new ImageAssetLoaderItem(userImageContentVO.imageUrl, userImageContentVO, 'imageData'));
      }
      
      // user video content
      var userVideoContentVO:UserVideoContentVO;
      for each (userVideoContentVO in Locator.instance.appModel.contentModel.getContentVOsForLoading('user_video')) {
        assetLoader.addLoadItem(new VideoMetadataAssetLoaderItem(userVideoContentVO.videoUrl, userVideoContentVO, 'metadata'));
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