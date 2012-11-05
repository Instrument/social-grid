package socialGrid.models.content {
  
  import flash.display.BitmapData;
  
  public class PhotoboothImageContentVO extends BaseContentVO {
    
    public var imageData:BitmapData;
    
    public function PhotoboothImageContentVO(imageData:BitmapData) {
      super();
      contentType = 'photobooth_image';
      canDoSizes = canDoSizes.concat(['1x1', '2x2', '3x3', '5x3']);
      
      this.imageData = imageData;
    }
  }
}