package socialGrid.util.assetLoader {
  
  import socialGrid.util.VideoMetadata;
  
  public class VideoMetadataAssetLoaderItem extends BaseAssetLoaderItem {
    
    protected var metadataParentObj:Object;
    protected var metadataName:String;
    
    public function VideoMetadataAssetLoaderItem(url:String, metadataParentObj:Object, metadataName:String) {
      loaderType = 'video';
      this.url = url;
      this.metadataParentObj = metadataParentObj;
      this.metadataName = metadataName;
    }
    
    override public function onLoadSuccess(content:*):void {
      var metadata:VideoMetadata = content as VideoMetadata;
      if (metadataParentObj.hasOwnProperty(metadataName)) {
        metadataParentObj[metadataName] = metadata;
      }
    }
  }
}