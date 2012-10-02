package socialGrid.util.assetLoader {
  
  import flash.display.Bitmap;
  import flash.display.BitmapData;
  import flash.display.Loader;
  
  public class ImageAssetLoaderItem extends BaseAssetLoaderItem {
    
    protected var imageParentObj:Object;
    protected var imageDataName:String;
    
    public function ImageAssetLoaderItem(url:String, imageParentObj:Object, imageDataName:String) {
      loaderType = Loader;
      this.url = url;
      this.imageParentObj = imageParentObj;
      this.imageDataName = imageDataName;
    }
    
    override public function onLoadSuccess(content:*):void {
      var bmp:Bitmap = Bitmap(content);
      if (imageParentObj.hasOwnProperty(imageDataName)) {
        imageParentObj[imageDataName] = bmp.bitmapData.clone(); // [(!)] may cause error if the property isn't not type BitmapData
      }
      bmp.bitmapData.dispose();
    }
  }
}