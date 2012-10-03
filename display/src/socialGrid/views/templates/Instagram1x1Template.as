package socialGrid.views.templates {
  
  import flash.display.Bitmap;
  import flash.display.Sprite;
  
  import socialGrid.models.content.BaseContentVO;
  import socialGrid.models.content.InstagramContentVO;
  import socialGrid.util.BitmapResizer;

  public class Instagram1x1Template extends BaseGridTemplate {
    
    protected var bmp:Bitmap;
    
    public function Instagram1x1Template() {
      
      bmp = new Bitmap();
      addChild(bmp);
    }
    
    override public function populate(contentVO:BaseContentVO):void {
      var instagramContentVO:InstagramContentVO = contentVO as InstagramContentVO;
      bmp.bitmapData = BitmapResizer.resizeBitmapData(instagramContentVO.imageData, 256);
    }
  }
}